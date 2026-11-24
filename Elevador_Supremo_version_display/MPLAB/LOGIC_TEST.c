/*
 * File:   LOGIC_TEST.c
 * Author: santo
 *
 * Proyecto: ELEVADOR SUPREMO (Version Display LCD 16x2 - LM016L)
 * MCU:      PIC18F4550 @ 8 MHz (Oscilador interno INTOSC)
 *
 * Mapa de pines verificado contra Proteus 8 y Protoboard fisico:
 *   - LCD 16x2 (LM016L, 4 bits): RD0=RS, RD1=E, RD2=D4, RD3=D5, RD4=D6, RD5=D7
 *   - Teclado 4x4: Filas A..D -> RA0..RA3 | Columnas 1..4 -> RB0..RB3 (pull-ups 10k)
 *       A = Seleccion de piso | # = Confirmar | D = Borrar
 *       B = Abrir puerta      | C = Cerrar puerta | * = Paro de Emergencia
 *   - Botones fisicos de pasillo (pull-up 10k, activos en 0):
 *       RA4 = SUBIR  |  RA5 = BAJAR
 *   - 9 LEDs (3 por elevador: Verde=Sube, Amarillo=Espera/Parpadea, Rojo=Baja):
 *       E1: RC0 (Verde), RD6 (Amarillo), RC1 (Rojo)
 *       E2: RC2 (Verde), RD7 (Amarillo), RE0 (Rojo)
 *       E3: RE1 (Verde), RB4 (Amarillo), RE2 (Rojo)
 *   - Buzzer activo 5V: RB5
 *   - UART Serial 9600 bps (COMPIM / USB-TTL, opcional no bloqueante): RC6=TX, RC7=RX
 */

#define _XTAL_FREQ 8000000UL
#include "config.h"
#include <xc.h>
#include <stdint.h>
#include <string.h>

/* ==================== CONFIGURACION DEL EDIFICIO ==================== */
#define NUM_PISOS_DEFAULT   12U     /* Cambia aqui (4..20) si deseas otro N inicial */
#define MAX_PISOS           20U

/* Tiempos basados en tick de 10 ms (Timer0) */
#define TICKS_STEP_DECIMA   22U     /* 220 ms por decima de piso -> 2.20 s por piso */
#define TICKS_BOARDING_WAIT 450U    /* 4.50 s para encolar varios destinos simultaneos */
#define TICKS_ARRIVED_OPEN  220U    /* 2.20 s puerta abierta al llegar a destino */
#define TICKS_BLINK_HALF    35U     /* 350 ms ON / 350 ms OFF para parpadeo amarillo y emergencia */

/* ==================== DEFINICION DE PINES ==================== */
/* LCD 16x2 en PORTD (RD0..RD5) — CUIDADO: RD6 y RD7 son LEDs amarillos E1/E2 */
#define LCD_RS              LATDbits.LATD0
#define LCD_EN              LATDbits.LATD1

/* Botones fisicos de pasillo (activos en BAJO = 0) */
#define BTN_SUBIR_PIN       PORTAbits.RA4
#define BTN_BAJAR_PIN       PORTAbits.RA5

/* 9 LEDs */
#define LED_E1_GREEN        LATCbits.LATC0
#define LED_E1_YELLOW       LATDbits.LATD6
#define LED_E1_RED          LATCbits.LATC1

#define LED_E2_GREEN        LATCbits.LATC2
#define LED_E2_YELLOW       LATDbits.LATD7
#define LED_E2_RED          LATEbits.LATE0

#define LED_E3_GREEN        LATEbits.LATE1
#define LED_E3_YELLOW       LATBbits.LATB4
#define LED_E3_RED          LATEbits.LATE2

/* Buzzer activo 5V */
#define BUZZER_PIN          LATBbits.LATB5

/* ==================== ESTADOS Y ESTRUCTURAS ==================== */
#define STATE_IDLE          0U
#define STATE_MOVING        1U
#define STATE_WAIT_DEST     2U
#define STATE_ARRIVED_OPEN  3U
#define STATE_EMERGENCY     4U

#define DIR_NONE            0U
#define DIR_UP              1U
#define DIR_DOWN            2U

#define INPUT_IDLE          0U
#define INPUT_HALL_FLOOR    1U
#define INPUT_WAIT_HALL_BTN 2U

typedef struct {
    uint8_t  idx;               /* 1, 2, 3 */
    uint8_t  floor;             /* Piso actual redondeado (1..N) */
    int16_t  pos10;             /* Posicion exacta en decimas de piso (ej. Piso 5 = 50) */
    uint8_t  target;            /* Proxima parada inmediata (0 = ninguna) */
    uint32_t pickup_up_mask;    /* Bitmask de llamadas SUBIR asignadas (bit f = piso f) */
    uint32_t pickup_down_mask;  /* Bitmask de llamadas BAJAR asignadas (bit f = piso f) */
    uint32_t dest_mask;         /* Bitmask de destinos internos encolados en cabina */
    uint8_t  state;             /* STATE_IDLE, STATE_MOVING, STATE_WAIT_DEST, ... */
    uint8_t  prev_state;        /* Estado previo para reanudar tras emergencia */
    uint8_t  move_dir;          /* DIR_NONE, DIR_UP, DIR_DOWN */
    uint8_t  step_ticks;        /* Contador para avanzar 0.1 pisos cada 220 ms */
    uint16_t door_timer;        /* Temporizador en STATE_ARRIVED_OPEN */
    uint16_t boarding_timer;    /* Ventana de 4.5 s para que varios usuarios encolen pisos */
    uint8_t  boarding_count;    /* Cuantos destinos se han encolado en la parada actual */
} Elevator;

static Elevator elevs[3];
static uint8_t  num_pisos = NUM_PISOS_DEFAULT;
static uint8_t  active_elev_idx = 0U;

/* Cola FIFO de elevadores con puerta abierta esperando destinos (indices 0..2) */
static uint8_t  wait_queue[3];
static uint8_t  wait_queue_len = 0U;

/* Maquina de entrada del usuario */
static uint8_t  input_mode = INPUT_IDLE;
static char     keypad_buf[3] = "";
static uint8_t  keypad_len = 0U;
static uint8_t  pending_user_floor = 0U;

/* Emergencia, parpadeo y buzzer */
static uint8_t  emergency = 0U;
static uint8_t  blink_on = 1U;
static uint8_t  blink_ticks = 0U;
static uint16_t buzzer_ticks = 0U;

/* Buffers de pantalla LCD (evitan parpadeo al actualizar solo cuando cambia el texto) */
static char     last_status_msg[17] = "Presiona A: Piso";
static char     lcd_prev1[17] = "";
static char     lcd_prev2[17] = "";

/* Antirrebote de teclado y botones */
static char     last_raw_key = 0;
static uint8_t  key_stable_cnt = 0U;
static uint8_t  key_latched = 0U;

static uint8_t  btn_sub_cnt = 0U, btn_sub_latched = 0U;
static uint8_t  btn_baj_cnt = 0U, btn_baj_latched = 0U;

/* Telemetria UART periodica */
static uint8_t  uart_tx_ticks = 0U;
static char     uart_rx_buf[8];
static uint8_t  uart_rx_len = 0U;

/* ==================== PROTOTIPOS ==================== */
static void Hardware_Init(void);
static void Timer0_Init(void);
static void UART_Init(void);
static void UART_WriteChar(char c);
static void UART_WriteStr(const char *s);
static void UART_PollRx(void);
static void UART_SendTelemetry(void);

static void LCD_PulseEnable(void);
static void LCD_WriteNibble(uint8_t nib);
static void LCD_SendByte(uint8_t val, uint8_t is_data);
static void LCD_Init(void);
static void LCD_SetLine(uint8_t row, const char *text16);

static char Keypad_ScanRaw(void);
static void Inputs_Task10ms(void);

static void Buzzer_Beep(uint16_t duration_ticks);
static void Set_StatusMsg(const char *msg);
static void Put2D(char *dst, uint8_t val);

static void WaitQueue_Push(uint8_t idx);
static void WaitQueue_Remove(uint8_t idx);
static Elevator* Current_Waiting_Elev(void);

static uint32_t Elev_AllStops(const Elevator *e);
static void Recompute_Target(Elevator *e);
static uint16_t Dispatch_Cost(const Elevator *e, uint8_t user_floor, uint8_t req_dir);

static void Press_Hall(uint8_t req_dir);
static void Press_OpenDoor(void);
static void Press_CloseDoor(void);
static void Toggle_Emergency(void);
static void Process_Key(char key);

static void Elevators_Reset(void);
static void Elevators_Tick10ms(void);
static void Update_LCD_And_LEDs(void);

/* ==================== UTILIDADES DE TEXTO ==================== */
static void Put2D(char *dst, uint8_t val) {
    dst[0] = (char)('0' + (val / 10U) % 10U);
    dst[1] = (char)('0' + (val % 10U));
}

static void Set_StatusMsg(const char *msg) {
    uint8_t i = 0U;
    while (i < 16U && msg[i] != '\0') {
        last_status_msg[i] = msg[i];
        i++;
    }
    while (i < 16U) {
        last_status_msg[i] = ' ';
        i++;
    }
    last_status_msg[16] = '\0';
}

static void Buzzer_Beep(uint16_t duration_ticks) {
    buzzer_ticks = duration_ticks;
    BUZZER_PIN = 1;
}

/* ==================== DRIVER LCD 16x2 (4 BITS SIN TOCAR RD6/RD7) ==================== */
static void LCD_PulseEnable(void) {
    LCD_EN = 1;
    __delay_us(5);
    LCD_EN = 0;
    __delay_us(50);
}

static void LCD_WriteNibble(uint8_t nib) {
    LATDbits.LATD2 = (nib >> 0) & 1U;
    LATDbits.LATD3 = (nib >> 1) & 1U;
    LATDbits.LATD4 = (nib >> 2) & 1U;
    LATDbits.LATD5 = (nib >> 3) & 1U;
    LCD_PulseEnable();
}

static void LCD_SendByte(uint8_t val, uint8_t is_data) {
    LCD_RS = is_data ? 1U : 0U;
    LCD_WriteNibble((val >> 4) & 0x0FU);
    LCD_WriteNibble(val & 0x0FU);
    if (!is_data && (val == 0x01U || val == 0x02U)) {
        __delay_ms(2);
    }
}

static void LCD_Init(void) {
    LCD_RS = 0;
    LCD_EN = 0;
    __delay_ms(30);

    /* Secuencia estandar HD44780 / LM016L para modo 4 bits */
    LCD_WriteNibble(0x03U);
    __delay_ms(5);
    LCD_WriteNibble(0x03U);
    __delay_us(150);
    LCD_WriteNibble(0x03U);
    __delay_us(150);
    LCD_WriteNibble(0x02U);
    __delay_us(150);

    LCD_SendByte(0x28U, 0U); /* 4 bits, 2 lineas, 5x8 */
    LCD_SendByte(0x0CU, 0U); /* Display ON, Cursor OFF, Blink OFF */
    LCD_SendByte(0x06U, 0U); /* Incremento automatico */
    LCD_SendByte(0x01U, 0U); /* Limpiar pantalla inicial */
}

static void LCD_SetLine(uint8_t row, const char *text16) {
    char *cache = (row == 0U) ? lcd_prev1 : lcd_prev2;
    uint8_t i;
    char padded[17];

    for (i = 0U; i < 16U && text16[i] != '\0'; i++) {
        padded[i] = text16[i];
    }
    for (; i < 16U; i++) {
        padded[i] = ' ';
    }
    padded[16] = '\0';

    if (strncmp(cache, padded, 16U) == 0) {
        return; /* Sin cambios -> evita parpadeo en LM016L */
    }
    memcpy(cache, padded, 17U);

    LCD_SendByte((row == 0U) ? 0x80U : 0xC0U, 0U);
    for (i = 0U; i < 16U; i++) {
        LCD_SendByte((uint8_t)padded[i], 1U);
    }
}

/* ==================== TECLADO MATRICIAL 4x4 ==================== */
static const char KEYMAP[4][4] = {
    {'1', '2', '3', 'A'},
    {'4', '5', '6', 'B'},
    {'7', '8', '9', 'C'},
    {'*', '0', '#', 'D'}
};

static char Keypad_ScanRaw(void) {
    uint8_t r;
    char found = 0;

    for (r = 0U; r < 4U; r++) {
        /* Barrido seguro Open-Drain: solo la fila activa baja a 0, las demas quedan en alta impedancia */
        TRISA |= 0x0FU;
        LATA &= (uint8_t)(~0x0FU);
        TRISA &= (uint8_t)(~(1U << r));
        __delay_us(15);

        if (PORTBbits.RB0 == 0U) { found = KEYMAP[r][0]; break; }
        if (PORTBbits.RB1 == 0U) { found = KEYMAP[r][1]; break; }
        if (PORTBbits.RB2 == 0U) { found = KEYMAP[r][2]; break; }
        if (PORTBbits.RB3 == 0U) { found = KEYMAP[r][3]; break; }
    }
    TRISA |= 0x0FU; /* Soltar todas las filas */
    return found;
}

static void Inputs_Task10ms(void) {
    /* 1) Antirrebote del teclado 4x4 (30 ms) */
    char raw = Keypad_ScanRaw();
    if (raw != 0 && raw == last_raw_key) {
        if (key_stable_cnt < 10U) {
            key_stable_cnt++;
        }
        if (key_stable_cnt >= 3U && !key_latched) {
            key_latched = 1U;
            Process_Key(raw);
        }
    } else if (raw == 0) {
        last_raw_key = 0;
        key_stable_cnt = 0U;
        key_latched = 0U;
    } else {
        last_raw_key = raw;
        key_stable_cnt = 1U;
    }

    /* 2) Antirrebote boton fisico SUBIR (RA4, activo en 0) */
    if (BTN_SUBIR_PIN == 0U) {
        if (btn_sub_cnt < 10U) btn_sub_cnt++;
        if (btn_sub_cnt >= 3U && !btn_sub_latched) {
            btn_sub_latched = 1U;
            Press_Hall(DIR_UP);
        }
    } else {
        btn_sub_cnt = 0U;
        btn_sub_latched = 0U;
    }

    /* 3) Antirrebote boton fisico BAJAR (RA5, activo en 0) */
    if (BTN_BAJAR_PIN == 0U) {
        if (btn_baj_cnt < 10U) btn_baj_cnt++;
        if (btn_baj_cnt >= 3U && !btn_baj_latched) {
            btn_baj_latched = 1U;
            Press_Hall(DIR_DOWN);
        }
    } else {
        btn_baj_cnt = 0U;
        btn_baj_latched = 0U;
    }
}

/* ==================== COLA DE ESPERA DE DESTINO ==================== */
static void WaitQueue_Push(uint8_t idx) {
    uint8_t i;
    for (i = 0U; i < wait_queue_len; i++) {
        if (wait_queue[i] == idx) return;
    }
    if (wait_queue_len < 3U) {
        wait_queue[wait_queue_len++] = idx;
    }
}

static void WaitQueue_Remove(uint8_t idx) {
    uint8_t i, j;
    for (i = 0U; i < wait_queue_len; i++) {
        if (wait_queue[i] == idx) {
            for (j = i; j + 1U < wait_queue_len; j++) {
                wait_queue[j] = wait_queue[j + 1U];
            }
            wait_queue_len--;
            return;
        }
    }
}

static Elevator* Current_Waiting_Elev(void) {
    while (wait_queue_len > 0U) {
        uint8_t idx = wait_queue[0];
        if (elevs[idx].state == STATE_WAIT_DEST) {
            return &elevs[idx];
        }
        WaitQueue_Remove(idx);
    }
    return 0;
}

/* ==================== LOGICA OPTIMA COLECTIVA (SCAN / LOOK) ==================== */
static uint32_t Elev_AllStops(const Elevator *e) {
    return (e->pickup_up_mask | e->pickup_down_mask | e->dest_mask);
}

static uint8_t Count_Bits(uint32_t m) {
    uint8_t c = 0U;
    while (m) {
        c += (uint8_t)(m & 1UL);
        m >>= 1U;
    }
    return c;
}

static void Recompute_Target(Elevator *e) {
    uint32_t stops = Elev_AllStops(e);
    uint8_t f, max_s = 0U, min_s = 255U;

    if (stops == 0UL) {
        e->target = 0U;
        e->move_dir = DIR_NONE;
        if (e->state == STATE_MOVING) {
            e->state = STATE_IDLE;
        }
        return;
    }

    for (f = 1U; f <= num_pisos; f++) {
        if (stops & (1UL << f)) {
            if (f < min_s) min_s = f;
            if (f > max_s) max_s = f;
        }
    }

    if (e->move_dir == DIR_UP) {
        /* Buscar la parada mas cercana hacia arriba */
        uint8_t best = 0U;
        for (f = 1U; f <= num_pisos; f++) {
            int16_t f10 = (int16_t)f * 10;
            uint32_t bit = (1UL << f);
            if ((stops & bit) && f10 >= e->pos10) {
                if ((e->dest_mask & bit) || (e->pickup_up_mask & bit) || (f == max_s)) {
                    best = f;
                    break;
                }
            }
        }
        if (best != 0U) {
            e->target = best;
        } else {
            e->move_dir = DIR_DOWN;
            e->target = max_s;
        }
    } else if (e->move_dir == DIR_DOWN) {
        /* Buscar la parada mas cercana hacia abajo */
        uint8_t best = 0U;
        for (f = num_pisos; f >= 1U; f--) {
            int16_t f10 = (int16_t)f * 10;
            uint32_t bit = (1UL << f);
            if ((stops & bit) && f10 <= e->pos10) {
                if ((e->dest_mask & bit) || (e->pickup_down_mask & bit) || (f == min_s)) {
                    best = f;
                    break;
                }
            }
        }
        if (best != 0U) {
            e->target = best;
        } else {
            e->move_dir = DIR_UP;
            e->target = min_s;
        }
    } else {
        /* Estaba detenido: elegir la parada mas cercana */
        uint8_t best = min_s;
        int16_t best_dist = 9999;
        for (f = 1U; f <= num_pisos; f++) {
            if (stops & (1UL << f)) {
                int16_t d = (int16_t)f * 10 - e->pos10;
                if (d < 0) d = -d;
                if (d < best_dist) {
                    best_dist = d;
                    best = f;
                }
            }
        }
        e->target = best;
        if ((int16_t)best * 10 > e->pos10) {
            e->move_dir = DIR_UP;
        } else if ((int16_t)best * 10 < e->pos10) {
            e->move_dir = DIR_DOWN;
        } else {
            e->move_dir = DIR_NONE;
        }
    }
}

static uint16_t AbsDiff16(int16_t a, int16_t b) {
    return (a >= b) ? (uint16_t)(a - b) : (uint16_t)(b - a);
}

static uint16_t Dispatch_Cost(const Elevator *e, uint8_t user_floor, uint8_t req_dir) {
    /* Costo en decimas de piso: evalua TANTO libres COMO en movimiento */
    int16_t u10 = (int16_t)user_floor * 10;
    uint32_t stops = Elev_AllStops(e);
    uint8_t f;

    if (e->state == STATE_IDLE) {
        return AbsDiff16(e->pos10, u10);
    }

    if (e->state == STATE_MOVING) {
        if (e->move_dir == DIR_UP) {
            int16_t far10 = e->pos10;
            uint8_t inter = 0U;
            for (f = 1U; f <= num_pisos; f++) {
                if (stops & (1UL << f)) {
                    int16_t f10 = (int16_t)f * 10;
                    if (f10 > far10) far10 = f10;
                }
            }
            if (req_dir == DIR_UP && u10 >= (e->pos10 + 2)) {
                /* Va de paso subiendo hacia el usuario! */
                for (f = 1U; f <= num_pisos; f++) {
                    int16_t f10 = (int16_t)f * 10;
                    if ((stops & (1UL << f)) && f10 > e->pos10 && f10 < u10) inter++;
                }
                return (uint16_t)(u10 - e->pos10) + (uint16_t)inter * 4U;
            }
            if (u10 >= far10) {
                for (f = 1U; f <= num_pisos; f++) {
                    if ((stops & (1UL << f)) && ((int16_t)f * 10 > e->pos10)) inter++;
                }
                return (uint16_t)(u10 - e->pos10) + (uint16_t)inter * 8U;
            }
            for (f = 1U; f <= num_pisos; f++) {
                if ((stops & (1UL << f)) && ((int16_t)f * 10 >= e->pos10)) inter++;
            }
            return AbsDiff16(far10, e->pos10) + AbsDiff16(far10, u10) + (uint16_t)inter * 8U;
        }

        if (e->move_dir == DIR_DOWN) {
            int16_t far10 = e->pos10;
            uint8_t inter = 0U;
            for (f = 1U; f <= num_pisos; f++) {
                if (stops & (1UL << f)) {
                    int16_t f10 = (int16_t)f * 10;
                    if (f10 < far10) far10 = f10;
                }
            }
            if (req_dir == DIR_DOWN && u10 <= (e->pos10 - 2)) {
                /* Va de paso bajando hacia el usuario! */
                for (f = 1U; f <= num_pisos; f++) {
                    int16_t f10 = (int16_t)f * 10;
                    if ((stops & (1UL << f)) && f10 < e->pos10 && f10 > u10) inter++;
                }
                return (uint16_t)(e->pos10 - u10) + (uint16_t)inter * 4U;
            }
            if (u10 <= far10) {
                for (f = 1U; f <= num_pisos; f++) {
                    if ((stops & (1UL << f)) && ((int16_t)f * 10 < e->pos10)) inter++;
                }
                return (uint16_t)(e->pos10 - u10) + (uint16_t)inter * 8U;
            }
            for (f = 1U; f <= num_pisos; f++) {
                if ((stops & (1UL << f)) && ((int16_t)f * 10 <= e->pos10)) inter++;
            }
            return AbsDiff16(e->pos10, far10) + AbsDiff16(u10, far10) + (uint16_t)inter * 8U;
        }

        return AbsDiff16(e->pos10, u10);
    }

    if (e->state == STATE_ARRIVED_OPEN) {
        if (e->floor == user_floor) return 2U;
        return AbsDiff16(e->pos10, u10) + 15U;
    }

    if (e->state == STATE_WAIT_DEST) {
        if (e->floor == user_floor) return 5U;
        return AbsDiff16(e->pos10, u10) + 35U;
    }

    return 9999U;
}

/* ==================== ACCIONES DE BOTONES Y TECLADO ==================== */
static void Press_Hall(uint8_t req_dir) {
    uint8_t i, best_idx = 0U, user_floor;
    uint16_t best_cost = 65535U;
    Elevator *chosen;
    char msg[17];

    if (emergency) return;

    if (input_mode != INPUT_WAIT_HALL_BTN || pending_user_floor == 0U) {
        Set_StatusMsg("Primero pulsa A!");
        Buzzer_Beep(10U);
        return;
    }

    user_floor = pending_user_floor;
    pending_user_floor = 0U;
    input_mode = INPUT_IDLE;

    /* Evaluar los 3 elevadores (libres y en movimiento) */
    for (i = 0U; i < 3U; i++) {
        uint16_t c = Dispatch_Cost(&elevs[i], user_floor, req_dir);
        if (c < best_cost) {
            best_cost = c;
            best_idx = i;
        }
    }

    chosen = &elevs[best_idx];
    active_elev_idx = best_idx;
    Buzzer_Beep(8U);

    /* Si ya esta detenido en el piso del usuario -> abre puerta en espera */
    if (chosen->floor == user_floor &&
        (chosen->state == STATE_IDLE || chosen->state == STATE_ARRIVED_OPEN || chosen->state == STATE_WAIT_DEST)) {
        chosen->state = STATE_WAIT_DEST;
        chosen->door_timer = 0U;
        chosen->boarding_timer = 0U;
        chosen->boarding_count = 0U;
        WaitQueue_Push(best_idx);

        strcpy(msg, "E1 P00 Abierto  ");
        msg[1] = (char)('0' + chosen->idx);
        Put2D(&msg[4], user_floor);
        Set_StatusMsg(msg);
    } else {
        if (req_dir == DIR_UP) {
            chosen->pickup_up_mask |= (1UL << user_floor);
        } else {
            chosen->pickup_down_mask |= (1UL << user_floor);
        }
        if (chosen->state == STATE_IDLE) {
            chosen->state = STATE_MOVING;
            chosen->step_ticks = 0U;
        }
        if (chosen->state == STATE_MOVING) {
            Recompute_Target(chosen);
        }

        strcpy(msg, "E1->P00 (SUBIR) ");
        msg[1] = (char)('0' + chosen->idx);
        Put2D(&msg[5], user_floor);
        if (req_dir == DIR_DOWN) {
            memcpy(&msg[9], "BAJAR", 5U);
        }
        Set_StatusMsg(msg);
    }
}

static void Press_OpenDoor(void) {
    Elevator *e = Current_Waiting_Elev();
    char msg[17];
    if (e == 0) {
        e = &elevs[active_elev_idx];
    }
    if (e->state == STATE_IDLE || e->state == STATE_ARRIVED_OPEN || e->state == STATE_WAIT_DEST) {
        if (e->state == STATE_IDLE) {
            e->state = STATE_ARRIVED_OPEN;
            e->door_timer = TICKS_ARRIVED_OPEN;
        } else if (e->state == STATE_ARRIVED_OPEN) {
            e->door_timer = TICKS_ARRIVED_OPEN;
        } else if (e->state == STATE_WAIT_DEST && e->boarding_timer > 0U) {
            e->boarding_timer = TICKS_BOARDING_WAIT; /* Extiende tiempo para mas usuarios */
        }
        strcpy(msg, "E1 Puerta ABIER.");
        msg[1] = (char)('0' + e->idx);
        Set_StatusMsg(msg);
        Buzzer_Beep(7U);
    }
}

static void Press_CloseDoor(void) {
    Elevator *e = Current_Waiting_Elev();
    char msg[17];
    if (e == 0) {
        e = &elevs[active_elev_idx];
    }
    if (e->state == STATE_WAIT_DEST || e->state == STATE_ARRIVED_OPEN) {
        WaitQueue_Remove((uint8_t)(e->idx - 1U));
        e->door_timer = 0U;
        e->boarding_timer = 0U;
        e->boarding_count = 0U;
        keypad_len = 0U;
        keypad_buf[0] = '\0';

        if (Elev_AllStops(e) != 0UL) {
            e->state = STATE_MOVING;
            e->step_ticks = 0U;
            Recompute_Target(e);
            strcpy(msg, "E1->Dest P00    ");
            msg[1] = (char)('0' + e->idx);
            Put2D(&msg[10], e->target);
            Set_StatusMsg(msg);
        } else {
            e->state = STATE_IDLE;
            e->move_dir = DIR_NONE;
            strcpy(msg, "E1 Puerta CERRA.");
            msg[1] = (char)('0' + e->idx);
            Set_StatusMsg(msg);
        }
        Buzzer_Beep(7U);
    }
}

static void Toggle_Emergency(void) {
    uint8_t i;
    emergency = (uint8_t)(!emergency);
    input_mode = INPUT_IDLE;
    keypad_len = 0U;
    keypad_buf[0] = '\0';
    pending_user_floor = 0U;

    if (emergency) {
        for (i = 0U; i < 3U; i++) {
            elevs[i].prev_state = elevs[i].state;
            elevs[i].state = STATE_EMERGENCY;
        }
        Buzzer_Beep(25U);
    } else {
        BUZZER_PIN = 0;
        buzzer_ticks = 0U;
        for (i = 0U; i < 3U; i++) {
            elevs[i].state = (elevs[i].prev_state != STATE_EMERGENCY) ? elevs[i].prev_state : STATE_IDLE;
        }
        Set_StatusMsg("Sistema normal  ");
    }
}

static uint8_t Parse_Buffer_Floor(void) {
    uint8_t val = 0U, i;
    for (i = 0U; i < keypad_len; i++) {
        val = (uint8_t)(val * 10U + (uint8_t)(keypad_buf[i] - '0'));
    }
    return val;
}

static void Process_Key(char key) {
    Elevator *wait_e;
    char msg[17];

    if (key == '*') {
        Toggle_Emergency();
        return;
    }
    if (emergency) {
        return;
    }

    Buzzer_Beep(4U);

    if (key == 'A') {
        /* Nuevo usuario en pasillo en cualquier momento (incluso con otros elevadores en viaje) */
        input_mode = INPUT_HALL_FLOOR;
        keypad_len = 0U;
        keypad_buf[0] = '\0';
        pending_user_floor = 0U;
        return;
    }

    if (key >= '0' && key <= '9') {
        wait_e = Current_Waiting_Elev();
        if (input_mode == INPUT_HALL_FLOOR) {
            if (keypad_len >= 2U) {
                keypad_buf[0] = key;
                keypad_buf[1] = '\0';
                keypad_len = 1U;
            } else {
                keypad_buf[keypad_len++] = key;
                keypad_buf[keypad_len] = '\0';
            }
        } else if (input_mode == INPUT_IDLE && wait_e != 0) {
            /* Puerta abierta esperando uno o varios destinos SIN presionar A */
            if (keypad_len >= 2U) {
                keypad_buf[0] = key;
                keypad_buf[1] = '\0';
                keypad_len = 1U;
            } else {
                keypad_buf[keypad_len++] = key;
                keypad_buf[keypad_len] = '\0';
            }
            if (wait_e->boarding_count > 0U) {
                wait_e->boarding_timer = TICKS_BOARDING_WAIT; /* Reinicia ventana mientras escriben */
            }
        } else if (input_mode == INPUT_WAIT_HALL_BTN) {
            strcpy(msg, "P00: SUBIR/BAJAR");
            Put2D(&msg[1], pending_user_floor);
            Set_StatusMsg(msg);
        } else {
            Set_StatusMsg("Presiona A: Piso");
        }
        return;
    }

    if (key == '#') {
        if (input_mode == INPUT_HALL_FLOOR) {
            if (keypad_len == 0U) {
                input_mode = INPUT_IDLE;
                Set_StatusMsg("ERROR:No existe!");
                Buzzer_Beep(18U);
            } else {
                uint8_t fl = Parse_Buffer_Floor();
                keypad_len = 0U;
                keypad_buf[0] = '\0';
                if (fl < 1U || fl > num_pisos) {
                    input_mode = INPUT_IDLE;
                    Set_StatusMsg("ERROR:No existe!");
                    Buzzer_Beep(18U);
                } else {
                    pending_user_floor = fl;
                    input_mode = INPUT_WAIT_HALL_BTN;
                    strcpy(msg, "P00: SUBIR/BAJAR");
                    Put2D(&msg[1], fl);
                    Set_StatusMsg(msg);
                }
            }
        } else if (input_mode == INPUT_IDLE) {
            wait_e = Current_Waiting_Elev();
            if (wait_e != 0) {
                if (keypad_len == 0U) {
                    Set_StatusMsg("ERROR:No existe!");
                    Buzzer_Beep(18U);
                } else {
                    uint8_t dest = Parse_Buffer_Floor();
                    keypad_len = 0U;
                    keypad_buf[0] = '\0';
                    if (dest < 1U || dest > num_pisos) {
                        Set_StatusMsg("ERROR:No existe!");
                        Buzzer_Beep(18U);
                    } else if (dest == wait_e->floor) {
                        strcpy(msg, "Ya en Piso 00!  ");
                        Put2D(&msg[11], dest);
                        Set_StatusMsg(msg);
                    } else {
                        /* Encolar destino y abrir/reiniciar ventana de 4.5 s para mas usuarios */
                        wait_e->dest_mask |= (1UL << dest);
                        wait_e->boarding_count++;
                        wait_e->boarding_timer = TICKS_BOARDING_WAIT;
                        strcpy(msg, "E1 +P00 en cola ");
                        msg[1] = (char)('0' + wait_e->idx);
                        Put2D(&msg[5], dest);
                        Set_StatusMsg(msg);
                    }
                }
            }
        }
        return;
    }

    if (key == 'B') {
        Press_OpenDoor();
        return;
    }

    if (key == 'C') {
        Press_CloseDoor();
        return;
    }

    if (key == 'D') {
        /* Boton D = Borrar si se equivoca al ingresar el piso */
        if (keypad_len > 0U) {
            keypad_len--;
            keypad_buf[keypad_len] = '\0';
        } else if (input_mode == INPUT_WAIT_HALL_BTN) {
            pending_user_floor = 0U;
            input_mode = INPUT_HALL_FLOOR;
        } else if (input_mode == INPUT_HALL_FLOOR) {
            input_mode = INPUT_IDLE;
            Set_StatusMsg("Entrada borrada ");
        }
    }
}

/* ==================== SIMULACION FISICA EN TIEMPO REAL (TICK 10 MS) ==================== */
static void Elevators_Reset(void) {
    uint8_t starts[3];
    uint8_t i;

    starts[0] = 1U;
    starts[1] = (num_pisos >= 2U) ? (uint8_t)(num_pisos / 2U) : 1U;
    starts[2] = num_pisos;

    wait_queue_len = 0U;
    emergency = 0U;
    input_mode = INPUT_IDLE;
    keypad_len = 0U;
    keypad_buf[0] = '\0';
    pending_user_floor = 0U;

    for (i = 0U; i < 3U; i++) {
        elevs[i].idx = (uint8_t)(i + 1U);
        elevs[i].floor = starts[i];
        elevs[i].pos10 = (int16_t)starts[i] * 10;
        elevs[i].target = 0U;
        elevs[i].pickup_up_mask = 0UL;
        elevs[i].pickup_down_mask = 0UL;
        elevs[i].dest_mask = 0UL;
        elevs[i].state = STATE_IDLE;
        elevs[i].prev_state = STATE_IDLE;
        elevs[i].move_dir = DIR_NONE;
        elevs[i].step_ticks = 0U;
        elevs[i].door_timer = 0U;
        elevs[i].boarding_timer = 0U;
        elevs[i].boarding_count = 0U;
    }
    Set_StatusMsg("Presiona A: Piso");
}

static void Elevators_Tick10ms(void) {
    uint8_t i;
    char msg[17];

    /* Parpadeo de 350 ms para LEDs amarillos de espera y alarma de emergencia */
    blink_ticks++;
    if (blink_ticks >= TICKS_BLINK_HALF) {
        blink_ticks = 0U;
        blink_on = (uint8_t)(!blink_on);
    }

    if (emergency) {
        BUZZER_PIN = blink_on ? 1U : 0U;
        return;
    }

    /* Apagar beep puntual cuando termina su duracion */
    if (buzzer_ticks > 0U) {
        buzzer_ticks--;
        if (buzzer_ticks == 0U) {
            BUZZER_PIN = 0;
        }
    }

    for (i = 0U; i < 3U; i++) {
        Elevator *e = &elevs[i];

        if (e->state == STATE_ARRIVED_OPEN) {
            if (e->door_timer > 0U) {
                e->door_timer--;
            }
            if (e->door_timer == 0U) {
                if (Elev_AllStops(e) != 0UL) {
                    e->state = STATE_MOVING;
                    e->step_ticks = 0U;
                    Recompute_Target(e);
                } else {
                    e->state = STATE_IDLE;
                    e->move_dir = DIR_NONE;
                }
            }
            continue;
        }

        if (e->state == STATE_WAIT_DEST) {
            /* Si boarding_count == 0, NO cierra nunca hasta que ingresen >=1 piso.
               Si boarding_count > 0, cuenta atras 4.5 s para permitir mas peticiones. */
            if (e->boarding_count > 0U && e->boarding_timer > 0U) {
                e->boarding_timer--;
                if (e->boarding_timer == 0U) {
                    WaitQueue_Remove(i);
                    e->boarding_count = 0U;
                    if (Elev_AllStops(e) != 0UL) {
                        e->state = STATE_MOVING;
                        e->step_ticks = 0U;
                        Recompute_Target(e);
                        strcpy(msg, "E1->Dest P00    ");
                        msg[1] = (char)('0' + e->idx);
                        Put2D(&msg[10], e->target);
                        Set_StatusMsg(msg);
                    } else {
                        e->state = STATE_IDLE;
                        e->move_dir = DIR_NONE;
                    }
                }
            }
            continue;
        }

        if (e->state == STATE_MOVING) {
            int16_t dest10;
            if (e->target == 0U) {
                Recompute_Target(e);
            }
            if (e->target == 0U) {
                continue;
            }

            e->step_ticks++;
            if (e->step_ticks < TICKS_STEP_DECIMA) {
                continue;
            }
            e->step_ticks = 0U;

            dest10 = (int16_t)e->target * 10;
            if (e->pos10 < dest10) {
                e->move_dir = DIR_UP;
                e->pos10++;
            } else if (e->pos10 > dest10) {
                e->move_dir = DIR_DOWN;
                e->pos10--;
            }
            e->floor = (uint8_t)((e->pos10 + 5) / 10);

            if (e->pos10 == dest10) {
                uint8_t arrived_fl = e->target;
                uint32_t bit = (1UL << arrived_fl);
                uint8_t had_pickup = (uint8_t)(((e->pickup_up_mask | e->pickup_down_mask) & bit) ? 1U : 0U);

                e->floor = arrived_fl;
                e->target = 0U;
                e->pickup_up_mask &= ~bit;
                e->pickup_down_mask &= ~bit;
                e->dest_mask &= ~bit;

                active_elev_idx = i;
                Buzzer_Beep(12U);

                if (had_pickup) {
                    e->state = STATE_WAIT_DEST;
                    e->boarding_timer = 0U;
                    e->boarding_count = 0U;
                    WaitQueue_Push(i);
                    strcpy(msg, "E1 P00 Abierto  ");
                    msg[1] = (char)('0' + e->idx);
                    Put2D(&msg[4], arrived_fl);
                    Set_StatusMsg(msg);
                } else {
                    e->state = STATE_ARRIVED_OPEN;
                    e->door_timer = TICKS_ARRIVED_OPEN;
                    strcpy(msg, "E1 llego a P00  ");
                    msg[1] = (char)('0' + e->idx);
                    Put2D(&msg[11], arrived_fl);
                    Set_StatusMsg(msg);
                }
            }
        }
    }
}

/* ==================== ACTUALIZACION DE LCD 16x2 Y 9 LEDS ==================== */
static char Elev_DirChar(const Elevator *e) {
    if (e->state == STATE_EMERGENCY) return '!';
    if (e->state == STATE_MOVING) {
        if (e->move_dir == DIR_UP) return '^';
        if (e->move_dir == DIR_DOWN) return 'v';
    }
    if (e->state == STATE_WAIT_DEST || e->state == STATE_ARRIVED_OPEN) return 'O';
    return ' ';
}

static void Update_LCD_And_LEDs(void) {
    char l1[17];
    char l2[17];
    uint8_t i;

    if (emergency) {
        strcpy(l1, "!! EMERGENCIA !!");
        strcpy(l2, "Pulsa * reanudar");
    } else {
        Elevator *wait_e = Current_Waiting_Elev();

        /* Linea 1 exacta de 16 caracteres: "1:01^2:06O3:12v " */
        for (i = 0U; i < 3U; i++) {
            uint8_t base = (uint8_t)(i * 5U);
            l1[base + 0U] = (char)('1' + i);
            l1[base + 1U] = ':';
            Put2D(&l1[base + 2U], elevs[i].floor);
            l1[base + 4U] = Elev_DirChar(&elevs[i]);
        }
        l1[15] = ' ';
        l1[16] = '\0';

        /* Linea 2 segun estado actual */
        if (input_mode == INPUT_HALL_FLOOR) {
            strcpy(l2, "Sel.Piso:__ #=OK");
            if (keypad_len >= 1U) l2[9]  = keypad_buf[0];
            if (keypad_len >= 2U) l2[10] = keypad_buf[1];
        } else if (input_mode == INPUT_WAIT_HALL_BTN && pending_user_floor > 0U) {
            strcpy(l2, "P00: SUBIR/BAJAR");
            Put2D(&l2[1], pending_user_floor);
        } else if (wait_e != 0) {
            if (strncmp(last_status_msg, "ERROR:No existe!", 16U) == 0 && keypad_len == 0U) {
                strcpy(l2, "ERROR:No existe!");
            } else if (wait_e->boarding_count > 0U && keypad_len == 0U) {
                uint8_t q_cnt = Count_Bits(wait_e->dest_mask);
                uint8_t secs = (uint8_t)((wait_e->boarding_timer + 99U) / 100U);
                strcpy(l2, "E1 Cola:0 0s C  ");
                l2[1] = (char)('0' + wait_e->idx);
                l2[8] = (char)('0' + (q_cnt % 10U));
                l2[10] = (char)('0' + (secs % 10U));
            } else {
                strcpy(l2, "E1 Dest:__ #=OK ");
                l2[1] = (char)('0' + wait_e->idx);
                if (keypad_len >= 1U) l2[8] = keypad_buf[0];
                if (keypad_len >= 2U) l2[9] = keypad_buf[1];
            }
        } else {
            memcpy(l2, last_status_msg, 17U);
        }
    }

    LCD_SetLine(0U, l1);
    LCD_SetLine(1U, l2);

    /* Actualizar los 9 LEDs fisicos */
    /* Elevador 1: RC0=Verde, RD6=Amarillo(parpadea en espera), RC1=Rojo */
    LED_E1_GREEN  = (!emergency && elevs[0].state == STATE_MOVING && elevs[0].move_dir == DIR_UP) ? 1U : 0U;
    LED_E1_YELLOW = (!emergency && (elevs[0].state == STATE_WAIT_DEST || elevs[0].state == STATE_ARRIVED_OPEN) && blink_on) ? 1U : 0U;
    LED_E1_RED    = (emergency ? blink_on : (elevs[0].state == STATE_MOVING && elevs[0].move_dir == DIR_DOWN)) ? 1U : 0U;

    /* Elevador 2: RC2=Verde, RD7=Amarillo(parpadea en espera), RE0=Rojo */
    LED_E2_GREEN  = (!emergency && elevs[1].state == STATE_MOVING && elevs[1].move_dir == DIR_UP) ? 1U : 0U;
    LED_E2_YELLOW = (!emergency && (elevs[1].state == STATE_WAIT_DEST || elevs[1].state == STATE_ARRIVED_OPEN) && blink_on) ? 1U : 0U;
    LED_E2_RED    = (emergency ? blink_on : (elevs[1].state == STATE_MOVING && elevs[1].move_dir == DIR_DOWN)) ? 1U : 0U;

    /* Elevador 3: RE1=Verde, RB4=Amarillo(parpadea en espera), RE2=Rojo */
    LED_E3_GREEN  = (!emergency && elevs[2].state == STATE_MOVING && elevs[2].move_dir == DIR_UP) ? 1U : 0U;
    LED_E3_YELLOW = (!emergency && (elevs[2].state == STATE_WAIT_DEST || elevs[2].state == STATE_ARRIVED_OPEN) && blink_on) ? 1U : 0U;
    LED_E3_RED    = (emergency ? blink_on : (elevs[2].state == STATE_MOVING && elevs[2].move_dir == DIR_DOWN)) ? 1U : 0U;
}

/* ==================== UART SERIAL 9600 BPS (COMPIM / USB-TTL) ==================== */
static void UART_Init(void) {
    TRISCbits.TRISC6 = 1;   /* EUSART controla RC6/TX y RC7/RX */
    TRISCbits.TRISC7 = 1;
    SPBRG = 51U;            /* 9600 bps @ 8 MHz con BRGH=1, BRG16=0 (0.16% error) */
    TXSTAbits.BRGH = 1;
    TXSTAbits.SYNC = 0;
    BAUDCONbits.BRG16 = 0;
    RCSTAbits.SPEN = 1;
    TXSTAbits.TXEN = 1;
    RCSTAbits.CREN = 1;
}

static void UART_WriteChar(char c) {
    uint16_t timeout = 2000U;
    while (!TXSTAbits.TRMT && timeout > 0U) {
        timeout--;
    }
    if (TXSTAbits.TRMT) {
        TXREG = (uint8_t)c;
    }
}

static void UART_WriteStr(const char *s) {
    while (*s != '\0') {
        UART_WriteChar(*s++);
    }
}

static void UART_SendTelemetry(void) {
    /* Trama ligera: S,01^,06O,12 ,0\r\n */
    char frame[20];
    frame[0] = 'S';
    frame[1] = ',';
    Put2D(&frame[2], elevs[0].floor);
    frame[4] = Elev_DirChar(&elevs[0]);
    frame[5] = ',';
    Put2D(&frame[6], elevs[1].floor);
    frame[8] = Elev_DirChar(&elevs[1]);
    frame[9] = ',';
    Put2D(&frame[10], elevs[2].floor);
    frame[12] = Elev_DirChar(&elevs[2]);
    frame[13] = ',';
    frame[14] = emergency ? '1' : '0';
    frame[15] = '\r';
    frame[16] = '\n';
    frame[17] = '\0';
    UART_WriteStr(frame);
}

static void UART_PollRx(void) {
    if (RCSTAbits.OERR) {
        RCSTAbits.CREN = 0;
        RCSTAbits.CREN = 1;
    }
    while (PIR1bits.RCIF) {
        char c = (char)RCREG;
        if (c == '\r' || c == '\n') {
            uart_rx_buf[uart_rx_len] = '\0';
            if (uart_rx_len >= 3U && uart_rx_buf[0] == 'K' && uart_rx_buf[1] == ':') {
                Process_Key(uart_rx_buf[2]);
            } else if (uart_rx_len >= 3U && uart_rx_buf[0] == 'H' && uart_rx_buf[1] == ':') {
                if (uart_rx_buf[2] == 'U') Press_Hall(DIR_UP);
                else if (uart_rx_buf[2] == 'D') Press_Hall(DIR_DOWN);
            } else if (uart_rx_len >= 3U && uart_rx_buf[0] == 'N' && uart_rx_buf[1] == ':') {
                uint8_t n = (uint8_t)(uart_rx_buf[2] - '0');
                if (uart_rx_len >= 4U && uart_rx_buf[3] >= '0' && uart_rx_buf[3] <= '9') {
                    n = (uint8_t)(n * 10U + (uint8_t)(uart_rx_buf[3] - '0'));
                }
                if (n >= 4U && n <= MAX_PISOS) {
                    num_pisos = n;
                    Elevators_Reset();
                }
            }
            uart_rx_len = 0U;
        } else if (uart_rx_len < 7U) {
            uart_rx_buf[uart_rx_len++] = c;
        }
    }
}

/* ==================== INICIALIZACION DE HARDWARE Y TIMER0 ==================== */
static void Hardware_Init(void) {
    /* 1) Oscilador interno a 8 MHz exactos */
    OSCCONbits.IRCF = 0b111;    /* 8 MHz */
    OSCCONbits.SCS  = 0b10;     /* Bloque oscilador interno */

    /* 2) Desactivar modulos analogicos/USB/SPP para liberar TODOS los pines como digitales */
    ADCON0 = 0x00U;
    ADCON1 = 0x0FU;             /* AN0..AN12 100% digitales (sobreescribe PBADEN=ON) */
    CMCON  = 0x07U;             /* Comparadores apagados */
    UCONbits.USBEN = 0;
    UCFGbits.UTRDIS = 1;
    SPPCON = 0x00U;

    /* 3) Limpiar latches antes de habilitar salidas */
    LATA = 0x00U;
    LATB = 0x00U;
    LATC = 0x00U;
    LATD = 0x00U;
    LATE = 0x00U;

    /* 4) Direccion de puertos (1 = Entrada, 0 = Salida) */
    /* PORTA: RA0..RA3 filas teclado (inician Hi-Z), RA4=BTN_SUBIR, RA5=BTN_BAJAR */
    TRISA = 0b00111111U;

    /* PORTB: RB0..RB3 cols teclado (entradas), RB4=E3_YELLOW (salida), RB5=BUZZER (salida), RB6..RB7 ICSP */
    INTCON2bits.RBPU = 1;       /* Pull-ups externos de 10k ya presentes en el circuito */
    TRISB = 0b11001111U;

    /* PORTC: RC0=E1_GREEN, RC1=E1_RED, RC2=E2_GREEN (salidas); RC6/RC7 UART */
    TRISC = 0b11000000U;

    /* PORTD: RD0..RD5 LCD 16x2, RD6=E1_YELLOW, RD7=E2_YELLOW (todas salidas) */
    TRISD = 0x00U;

    /* PORTE: RE0=E2_RED, RE1=E3_GREEN, RE2=E3_RED (salidas) */
    TRISE &= 0b11111000U;
}

static void Timer0_Init(void) {
    /* Tick exacto de 10 ms @ 8 MHz:
       Fosc/4 = 2 MHz, Prescaler 1:8 -> 250 kHz -> 2500 cuentas = 10 ms
       65536 - 2500 = 63036 = 0xF63C */
    T0CON = 0b00000010U;        /* 16-bit, reloj interno, prescaler 1:8 */
    TMR0H = 0xF6U;
    TMR0L = 0x3CU;
    INTCONbits.TMR0IF = 0;
    T0CONbits.TMR0ON = 1;
}

/* ==================== FUNCION PRINCIPAL ==================== */
void main(void) {
    Hardware_Init();
    LCD_Init();
    UART_Init();
    Timer0_Init();

    Elevators_Reset();
    Update_LCD_And_LEDs();

    while (1) {
        UART_PollRx();

        if (INTCONbits.TMR0IF) {
            /* Recargar Timer0 para el siguiente tick de 10 ms */
            INTCONbits.TMR0IF = 0;
            TMR0H = 0xF6U;
            TMR0L = 0x3CU;

            Inputs_Task10ms();
            Elevators_Tick10ms();
            Update_LCD_And_LEDs();

            uart_tx_ticks++;
            if (uart_tx_ticks >= 50U) { /* Cada 500 ms envia estado por UART (sin bloquear) */
                uart_tx_ticks = 0U;
                UART_SendTelemetry();
            }
        }
    }
}
