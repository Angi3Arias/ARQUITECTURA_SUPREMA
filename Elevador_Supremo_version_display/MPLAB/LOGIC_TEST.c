/*
 * File:   LOGIC_TEST.c
 * Author: santo
 *
 * Elevador Supremo — Firmware robusto multi-usuario con algoritmo LOOK colectivo
 * PIC18F4550 @ 8 MHz | LCD 16x2 | Teclado 4x4 | 2 Botones | 9 LEDs | Buzzer 5V | UART 9600
 *
 * Correcciones clave:
 *  - UART RX por interrupcion (buffer circular 64 B) + TX no bloqueante (256 B): cero perdida
 *    de comandos N:XX o rafagas de peticiones.
 *  - Mascara de bits en paradas[3][21] (BIT_UP | BIT_DOWN | BIT_DEST): nunca sobreescribe
 *    peticiones simultaneas en un mismo piso.
 *  - Cola FIFO cola_espera[3] para elevadores en ESPERA_DEST: el teclado nunca salta de cabina.
 *  - Recalculo completo al cambiar num_pisos (4..20): poda paradas, ajusta objetivos, puertas y piso_usr.
 *  - Costo de despacho balanceado por carga y paradas intermedias + telemetria enriquecida (S y E).
 */

#define _XTAL_FREQ 8000000UL
#include "config.h"
#include <xc.h>
#include <string.h>

// ===================== CONFIGURACION =====================
#define PISOS_INICIAL   12      // Pisos iniciales (configurable 4..20 via UART N:XX)
#define T_POR_PISO      200     // 200 x 10ms = 2.0 s por piso
#define T_ENCOLAR       450     // 450 x 10ms = 4.5 s ventana para encolar varios destinos
#define T_BAJAR_PASAJ   220     // 220 x 10ms = 2.2 s puerta abierta al llegar a destino
#define T_PARPADEO      35      // 35  x 10ms = 350 ms parpadeo LED amarillo y emergencia

#define LIBRE           0
#define MOVIENDO        1
#define ESPERA_DEST     2
#define LLEGO           3

#define QUIETO          0
#define SUBIENDO        1
#define BAJANDO         2

#define BIT_UP          0x01U
#define BIT_DOWN        0x02U
#define BIT_DEST        0x04U

#define RX_BUF_SZ       64U
#define TX_BUF_SZ       256U

// ===================== VARIABLES GLOBALES =====================
int num_pisos       = PISOS_INICIAL;
int piso[3]         = {1, PISOS_INICIAL / 2, PISOS_INICIAL};
int estado[3]       = {LIBRE, LIBRE, LIBRE};
int direccion[3]    = {QUIETO, QUIETO, QUIETO};
int objetivo[3]     = {0, 0, 0};
int reloj_piso[3]   = {0, 0, 0};
int reloj_puerta[3] = {0, 0, 0};
int encolados[3]    = {0, 0, 0};

// Paradas por elevador (1..20) como mascara de bits: BIT_UP | BIT_DOWN | BIT_DEST
unsigned char paradas[3][21];

// Cola FIFO de elevadores con puerta abierta esperando destino
int cola_espera[3]  = {-1, -1, -1};
int cola_esp_len    = 0;

// Teclado: modo 0=normal/destino | 1=pulso 'A' (piso) | 2=confirmo '#' (espera SUBIR/BAJAR)
int  modo = 0, piso_usr = 0, elev_activo = 0, buf_len = 0;
char buf[3] = "";

// Emergencia, parpadeo y buzzer
unsigned char emergencia = 0, parpadeo = 1;
int cont_parp = 0, cont_buzz = 0, cont_uart = 0;

// Antirrebote y cache del LCD
char msg_lcd[17] = "Presiona A: Piso", prev_l1[17] = "", prev_l2[17] = "";
char tecla_ant = 0;
int  subir_ant = 1, bajar_ant = 1;

// Buffers circulares UART (RX por interrupcion, TX no bloqueante)
volatile char rx_ring[RX_BUF_SZ];
volatile unsigned char rx_head = 0, rx_tail = 0;
char tx_ring[TX_BUF_SZ];
unsigned char tx_head = 0, tx_tail = 0;
char uart_rx[20] = "";
unsigned char uart_rx_len = 0;

// ===================== ISR: RECEPCION UART SIN PERDIDAS =====================
void __interrupt() isr(void) {
    if (PIE1bits.RCIE && PIR1bits.RCIF) {
        if (RCSTAbits.FERR) {
            volatile unsigned char dummy = RCREG;
            (void)dummy;
        } else {
            unsigned char c = RCREG;
            unsigned char next = (unsigned char)((rx_head + 1U) & (RX_BUF_SZ - 1U));
            if (next != rx_tail) {
                rx_ring[rx_head] = (char)c;
                rx_head = next;
            }
        }
        if (RCSTAbits.OERR) {
            RCSTAbits.CREN = 0;
            RCSTAbits.CREN = 1;
        }
    }
}

// ===================== 1. UTILIDADES Y LCD 16x2 (RD0..RD5) =====================
char dig(int v) { return (char)('0' + (unsigned char)(v % 10)); }
int  vabs(int x) { return (x < 0) ? -x : x; }
void beep(int t) { cont_buzz = t; LATBbits.LATB5 = 1; }

void poner_2d(char *p, int v) {
    if (v < 0) v = 0;
    if (v > 99) v = 99;
    p[0] = dig(v / 10);
    p[1] = dig(v);
}

void poner_msg(const char *s) {
    int i;
    for (i = 0; i < 16 && s[i] != '\0'; i++) msg_lcd[i] = s[i];
    for (; i < 16; i++) msg_lcd[i] = ' ';
    msg_lcd[16] = '\0';
}

void msg_elev(int e, const char *plantilla, int pos_num, int num) {
    char m[17];
    strcpy(m, plantilla);
    if (e >= 0) m[1] = dig(e + 1);
    if (pos_num >= 0) poner_2d(&m[pos_num], num);
    poner_msg(m);
}

void LCD_Nib(unsigned char n) {
    // Elevador_v2: D4=RB0, D5=RB1, D6=RD4, D7=RB2 | RS=RD0, E=RD1
    LATBbits.LATB0 = (n >> 0) & 1;
    LATBbits.LATB1 = (n >> 1) & 1;
    LATDbits.LATD4 = (n >> 2) & 1;
    LATBbits.LATB2 = (n >> 3) & 1;
    LATDbits.LATD1 = 1; __delay_us(5); LATDbits.LATD1 = 0; __delay_us(50);
}

void LCD_Byte(unsigned char v, unsigned char dato) {
    LATDbits.LATD0 = dato;
    LCD_Nib(v >> 4); LCD_Nib(v & 0x0F);
    if (!dato && v <= 2) __delay_ms(2);
}

void LCD_Init(void) {
    LATDbits.LATD0 = 0; LATDbits.LATD1 = 0; __delay_ms(30);
    LCD_Nib(3); __delay_ms(5); LCD_Nib(3); __delay_us(150);
    LCD_Nib(3); __delay_us(150); LCD_Nib(2); __delay_us(150);
    LCD_Byte(0x28, 0); LCD_Byte(0x0C, 0); LCD_Byte(0x06, 0); LCD_Byte(0x01, 0);
}

void LCD_Linea(unsigned char fila, const char *txt) {
    char *cache = (fila == 0) ? prev_l1 : prev_l2;
    char l[17];
    int i;
    for (i = 0; i < 16 && txt[i] != '\0'; i++) l[i] = txt[i];
    for (; i < 16; i++) l[i] = ' ';
    l[16] = '\0';
    if (strncmp(cache, l, 16) == 0) return;
    memcpy(cache, l, 17);
    LCD_Byte(fila ? 0xC0 : 0x80, 0);
    for (i = 0; i < 16; i++) LCD_Byte((unsigned char)l[i], 1);
}

// ===================== 2. TECLADO 4x4 Y UART 9600 BPS =====================
const char TECLAS[4][4] = {
    {'1','2','3','A'}, {'4','5','6','B'}, {'7','8','9','C'}, {'*','0','#','D'}
};

char leer_teclado(void) {
    int f;
    char t = 0;
    // Elevador_v2: Filas A..D = RA0..RA3 (no toca RA6) | Cols 1..4 = RA4, RA5, RE0, RE1
    for (f = 0; f < 4; f++) {
        TRISA |= 0x0F; LATA &= 0xF0;
        TRISA &= (unsigned char)(~(1 << f));
        __delay_us(15);
        if (PORTAbits.RA4 == 0) { t = TECLAS[f][0]; break; }
        if (PORTAbits.RA5 == 0) { t = TECLAS[f][1]; break; }
        if (PORTEbits.RE0 == 0) { t = TECLAS[f][2]; break; }
        if (PORTEbits.RE1 == 0) { t = TECLAS[f][3]; break; }
    }
    TRISA |= 0x0F;
    return t;
}

void UART_Init(void) {
    TRISCbits.TRISC6 = 1; TRISCbits.TRISC7 = 1;
    SPBRG = 51; TXSTAbits.BRGH = 1; TXSTAbits.SYNC = 0; BAUDCONbits.BRG16 = 0;
    RCSTAbits.SPEN = 1; TXSTAbits.TXEN = 1; RCSTAbits.CREN = 1;
    PIE1bits.RCIE = 1;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;
}

unsigned char UART_TxFree(void) {
    return (unsigned char)((tx_tail - tx_head - 1U) & (TX_BUF_SZ - 1U));
}

void UART_PutChar(char c) {
    unsigned char next = (unsigned char)(tx_head + 1U);
    if (next == tx_tail) return; // buffer lleno: nunca bloquear el MCU
    tx_ring[tx_head] = c;
    tx_head = next;
}

void UART_PutStr(const char *s) {
    while (*s) UART_PutChar(*s++);
}

void UART_Put2d(int v) {
    if (v < 0) v = 0;
    if (v > 99) v = 99;
    UART_PutChar(dig(v / 10));
    UART_PutChar(dig(v));
}

void UART_PutInt(int v) {
    char tmp[7];
    int i = 0;
    if (v < 0) { UART_PutChar('-'); v = -v; }
    if (v == 0) { UART_PutChar('0'); return; }
    while (v > 0 && i < 6) { tmp[i++] = dig(v); v /= 10; }
    while (i > 0) UART_PutChar(tmp[--i]);
}

void UART_PutHex5(unsigned long mask) {
    static const char HEX[16] = "0123456789ABCDEF";
    UART_PutChar(HEX[(mask >> 16) & 0x0FUL]);
    UART_PutChar(HEX[(mask >> 12) & 0x0FUL]);
    UART_PutChar(HEX[(mask >> 8)  & 0x0FUL]);
    UART_PutChar(HEX[(mask >> 4)  & 0x0FUL]);
    UART_PutChar(HEX[mask         & 0x0FUL]);
}

void UART_PumpTx(void) {
    if (PIR1bits.TXIF && tx_tail != tx_head) {
        TXREG = (unsigned char)tx_ring[tx_tail++];
    }
}

char estado_char(int e) {
    if (emergencia) return 'E';
    if (estado[e] == MOVIENDO) return (direccion[e] == SUBIENDO) ? 'U' : 'D';
    if (estado[e] == ESPERA_DEST) return 'W';
    if (estado[e] == LLEGO) return 'O';
    return 'I';
}

char puerta_nivel(int e) {
    int r;
    if (estado[e] == LIBRE || estado[e] == MOVIENDO) return '0';
    if (estado[e] == ESPERA_DEST) {
        if (encolados[e] == 0 || reloj_puerta[e] > 45) return '9';
        r = reloj_puerta[e] / 5;
        return dig(r > 9 ? 9 : r);
    }
    if (estado[e] == LLEGO) {
        if (reloj_puerta[e] > 45) return '9';
        r = reloj_puerta[e] / 5;
        return dig(r > 9 ? 9 : r);
    }
    return '0';
}

void UART_EmitEnq(int e, int fl, char tipo) {
    if (UART_TxFree() < 16U) return;
    UART_PutStr("E,ENQ,");
    UART_PutChar(dig(e)); UART_PutChar(',');
    UART_Put2d(fl);       UART_PutChar(',');
    UART_PutChar(tipo);   UART_PutStr("\r\n");
}

void UART_EmitDeq(int e, int fl, char tipo) {
    if (UART_TxFree() < 16U) return;
    UART_PutStr("E,DEQ,");
    UART_PutChar(dig(e)); UART_PutChar(',');
    UART_Put2d(fl);       UART_PutChar(',');
    UART_PutChar(tipo);   UART_PutStr("\r\n");
}

void UART_EmitDsp(int fl, char dir_c, int chosen, int c0, int c1, int c2) {
    if (UART_TxFree() < 34U) return;
    UART_PutStr("E,DSP,");
    UART_Put2d(fl); UART_PutChar(',');
    UART_PutChar(dir_c); UART_PutChar(',');
    UART_PutChar(dig(chosen)); UART_PutChar(',');
    UART_PutInt(c0); UART_PutChar(',');
    UART_PutInt(c1); UART_PutChar(',');
    UART_PutInt(c2); UART_PutStr("\r\n");
}

void UART_EmitCfg(int n, int podadas) {
    if (UART_TxFree() < 18U) return;
    UART_PutStr("E,CFG,");
    UART_Put2d(n); UART_PutChar(',');
    UART_PutInt(podadas); UART_PutStr("\r\n");
}

void UART_EmitEmg(unsigned char act) {
    if (UART_TxFree() < 10U) return;
    UART_PutStr("E,EMG,");
    UART_PutChar(act ? '1' : '0');
    UART_PutStr("\r\n");
}

void UART_EnviarEstado(void) {
    // Formato: S,01I000,06U100,12O009,0,12,PK0,DS0,PK1,DS1,PK2,DS2\r\n
    int e, p;
    if (UART_TxFree() < 72U) return;
    UART_PutStr("S,");
    for (e = 0; e < 3; e++) {
        UART_Put2d(piso[e]);
        UART_PutChar(estado_char(e));
        UART_Put2d(objetivo[e]);
        UART_PutChar(puerta_nivel(e));
        UART_PutChar(',');
    }
    UART_PutChar(emergencia ? '1' : '0');
    UART_PutChar(',');
    UART_Put2d(num_pisos);
    for (e = 0; e < 3; e++) {
        unsigned long pk = 0UL, ds = 0UL;
        for (p = 1; p <= num_pisos; p++) {
            if (paradas[e][p] & (BIT_UP | BIT_DOWN)) pk |= (1UL << (p - 1));
            if (paradas[e][p] & BIT_DEST)            ds |= (1UL << (p - 1));
        }
        UART_PutChar(',');
        UART_PutHex5(pk);
        UART_PutChar(',');
        UART_PutHex5(ds);
    }
    UART_PutStr("\r\n");
}

// ===================== 3. COLA FIFO DE ESPERA Y ALGORITMO LOOK =====================
void agregar_cola_espera(int e) {
    int i;
    for (i = 0; i < cola_esp_len; i++) if (cola_espera[i] == e) return;
    if (cola_esp_len < 3) cola_espera[cola_esp_len++] = e;
}

void quitar_cola_espera(int e) {
    int i, j = 0;
    for (i = 0; i < cola_esp_len; i++) {
        if (cola_espera[i] != e) cola_espera[j++] = cola_espera[i];
    }
    cola_esp_len = j;
    for (; j < 3; j++) cola_espera[j] = -1;
}

int elev_esperando(void) {
    while (cola_esp_len > 0) {
        int e = cola_espera[0];
        if (e >= 0 && e < 3 && estado[e] == ESPERA_DEST) return e;
        quitar_cola_espera(e);
    }
    return -1;
}

int tiene_paradas(int e) {
    int p;
    for (p = 1; p <= num_pisos; p++) if (paradas[e][p]) return 1;
    return 0;
}

int contar_paradas(int e) {
    int p, c = 0;
    for (p = 1; p <= num_pisos; p++) if (paradas[e][p]) c++;
    return c;
}

int contar_destinos(int e) {
    int p, c = 0;
    for (p = 1; p <= num_pisos; p++) if (paradas[e][p] & BIT_DEST) c++;
    return c;
}

void siguiente_objetivo(int e) {
    int p, min_p = 99, max_p = 0;
    for (p = 1; p <= num_pisos; p++) {
        if (paradas[e][p]) {
            if (p < min_p) min_p = p;
            if (p > max_p) max_p = p;
        }
    }
    if (max_p == 0) {
        objetivo[e] = 0;
        direccion[e] = QUIETO;
        if (estado[e] == MOVIENDO) estado[e] = LIBRE;
        return;
    }
    if (paradas[e][piso[e]]) {
        objetivo[e] = piso[e];
        return;
    }
    if (direccion[e] == SUBIENDO) {
        for (p = piso[e] + 1; p <= num_pisos; p++) {
            if ((paradas[e][p] & (BIT_DEST | BIT_UP)) || p == max_p) {
                objetivo[e] = p;
                return;
            }
        }
        direccion[e] = BAJANDO;
        for (p = piso[e] - 1; p >= 1; p--) {
            if ((paradas[e][p] & (BIT_DEST | BIT_DOWN)) || p == min_p) {
                objetivo[e] = p;
                return;
            }
        }
        objetivo[e] = max_p;
    } else if (direccion[e] == BAJANDO) {
        for (p = piso[e] - 1; p >= 1; p--) {
            if ((paradas[e][p] & (BIT_DEST | BIT_DOWN)) || p == min_p) {
                objetivo[e] = p;
                return;
            }
        }
        direccion[e] = SUBIENDO;
        for (p = piso[e] + 1; p <= num_pisos; p++) {
            if ((paradas[e][p] & (BIT_DEST | BIT_UP)) || p == max_p) {
                objetivo[e] = p;
                return;
            }
        }
        objetivo[e] = min_p;
    } else {
        int mejor = min_p, d = 99;
        for (p = 1; p <= num_pisos; p++) {
            if (paradas[e][p] && vabs(p - piso[e]) < d) {
                d = vabs(p - piso[e]);
                mejor = p;
            }
        }
        objetivo[e] = mejor;
        direccion[e] = (mejor > piso[e]) ? SUBIENDO : ((mejor < piso[e]) ? BAJANDO : QUIETO);
    }
}

// Costo en decimas de piso (considera distancia, direccion, paradas intermedias y carga)
int costo_elevador(int e, int p_usr, int dir) {
    int p, lejano = piso[e], inter = 0;
    int carga = contar_paradas(e);

    if (estado[e] == LIBRE) {
        return vabs(piso[e] - p_usr) * 10;
    }
    if (estado[e] == MOVIENDO) {
        if (direccion[e] == SUBIENDO) {
            if (dir == SUBIENDO && p_usr > piso[e]) {
                for (p = piso[e] + 1; p < p_usr; p++) if (paradas[e][p]) inter++;
                return (p_usr - piso[e]) * 10 + inter * 5;
            }
            for (p = piso[e]; p <= num_pisos; p++) {
                if (paradas[e][p]) { lejano = p; inter++; }
            }
            return (lejano - piso[e]) * 10 + vabs(lejano - p_usr) * 10 + inter * 8 + 10;
        }
        if (direccion[e] == BAJANDO) {
            if (dir == BAJANDO && p_usr < piso[e]) {
                for (p = p_usr + 1; p < piso[e]; p++) if (paradas[e][p]) inter++;
                return (piso[e] - p_usr) * 10 + inter * 5;
            }
            for (p = piso[e]; p >= 1; p--) {
                if (paradas[e][p]) { lejano = p; inter++; }
            }
            return (piso[e] - lejano) * 10 + vabs(p_usr - lejano) * 10 + inter * 8 + 10;
        }
        return vabs(piso[e] - p_usr) * 10 + carga * 8;
    }
    if (estado[e] == LLEGO) {
        if (piso[e] == p_usr) return 4;
        return vabs(piso[e] - p_usr) * 10 + 18 + carga * 8;
    }
    // ESPERA_DEST
    if (piso[e] == p_usr) return 6;
    return vabs(piso[e] - p_usr) * 10 + 38 + carga * 10;
}

void cambiar_num_pisos(int n) {
    int e, p, podadas = 0;
    if (n < 4 || n > 20) return;
    num_pisos = n;

    if (modo == 2 && piso_usr > num_pisos) {
        piso_usr = 0;
        modo = 0;
    }

    for (e = 0; e < 3; e++) {
        if (piso[e] > num_pisos) piso[e] = num_pisos;
        if (objetivo[e] > num_pisos) objetivo[e] = 0;
        for (p = num_pisos + 1; p <= 20; p++) {
            if (paradas[e][p]) {
                paradas[e][p] = 0;
                podadas++;
            }
        }
        if (estado[e] == MOVIENDO) {
            siguiente_objetivo(e);
            if (objetivo[e] == 0) {
                estado[e] = LIBRE;
                direccion[e] = QUIETO;
                reloj_piso[e] = 0;
            }
        } else if (estado[e] == ESPERA_DEST) {
            if (encolados[e] > 0 && !tiene_paradas(e)) {
                encolados[e] = 0;
                reloj_puerta[e] = 0;
            }
        }
    }

    msg_elev(-1, "NEW PISOS = 00  ", 12, num_pisos);
    beep(6);
    UART_EmitCfg(num_pisos, podadas);
    UART_EnviarEstado();
}

void reiniciar_sistema(void) {
    int e;
    emergencia = 0;
    modo = 0; piso_usr = 0; elev_activo = 0; buf_len = 0; buf[0] = '\0';
    cola_esp_len = 0;
    cola_espera[0] = -1; cola_espera[1] = -1; cola_espera[2] = -1;
    memset(paradas, 0, sizeof(paradas));

    piso[0] = 1;
    piso[1] = (num_pisos / 2 > 1) ? (num_pisos / 2) : 1;
    piso[2] = num_pisos;
    for (e = 0; e < 3; e++) {
        estado[e] = LIBRE;
        direccion[e] = QUIETO;
        objetivo[e] = 0;
        reloj_piso[e] = 0;
        reloj_puerta[e] = 0;
        encolados[e] = 0;
    }
    LATBbits.LATB5 = 0; cont_buzz = 0;
    poner_msg("Presiona A: Piso");
    if (UART_TxFree() >= 8U) UART_PutStr("E,RST\r\n");
    UART_EnviarEstado();
}

// ===================== 4. BOTONES DE PASILLO Y TECLADO =====================
void llamar_pasillo_piso(int fl, int dir) {
    int e, mejor = 0, best = 30000;
    int costos[3];
    unsigned char bit = (dir == SUBIENDO) ? BIT_UP : BIT_DOWN;
    char dir_c = (dir == SUBIENDO) ? 'U' : 'D';

    if (emergencia || fl < 1 || fl > num_pisos) return;

    // Evaluar costos de los 3 elevadores
    for (e = 0; e < 3; e++) {
        costos[e] = costo_elevador(e, fl, dir);
        if (costos[e] < best) { best = costos[e]; mejor = e; }
    }

    // Evitar duplicar la misma llamada de pasillo en otro elevador si ya esta asignada
    for (e = 0; e < 3; e++) {
        if (paradas[e][fl] & bit) {
            mejor = e;
            break;
        }
    }

    elev_activo = mejor;
    beep(8);
    UART_EmitDsp(fl, dir_c, mejor, costos[0], costos[1], costos[2]);

    if (piso[mejor] == fl && estado[mejor] != MOVIENDO) {
        estado[mejor] = ESPERA_DEST;
        reloj_puerta[mejor] = 0;
        encolados[mejor] = 0;
        agregar_cola_espera(mejor);
        msg_elev(mejor, "E1 P00 Abierto  ", 4, fl);
    } else {
        unsigned char nueva = ((paradas[mejor][fl] & bit) == 0);
        paradas[mejor][fl] |= bit;
        if (nueva) UART_EmitEnq(mejor, fl, dir_c);
        if (estado[mejor] == LIBRE) {
            estado[mejor] = MOVIENDO;
            reloj_piso[mejor] = 0;
        }
        if (estado[mejor] == MOVIENDO) siguiente_objetivo(mejor);
        msg_elev(mejor, (dir == SUBIENDO) ? "E1->P00 (SUBIR) " : "E1->P00 (BAJAR) ", 5, fl);
    }
    UART_EnviarEstado();
}

void llamar_pasillo(int dir) {
    int fl;
    if (emergencia) return;
    if (modo != 2 || piso_usr == 0) { poner_msg("Primero pulsa A!"); beep(10); return; }
    fl = piso_usr; piso_usr = 0; modo = 0;
    llamar_pasillo_piso(fl, dir);
}

void encolar_destino_cabina(int w, int num) {
    if (w < 0 || w > 2 || emergencia) return;
    if (num < 1 || num > num_pisos) { poner_msg("ERROR:No existe!"); beep(18); return; }
    if (num == piso[w]) { msg_elev(-1, "Ya en Piso 00!  ", 11, num); return; }

    unsigned char nueva = ((paradas[w][num] & BIT_DEST) == 0);
    paradas[w][num] |= BIT_DEST;
    if (nueva) UART_EmitEnq(w, num, 'C');

    if (estado[w] == ESPERA_DEST) {
        encolados[w]++;
        reloj_puerta[w] = T_ENCOLAR;
    } else if (estado[w] == LIBRE) {
        estado[w] = MOVIENDO;
        reloj_piso[w] = 0;
        siguiente_objetivo(w);
    } else if (estado[w] == MOVIENDO) {
        siguiente_objetivo(w);
    }
    msg_elev(w, "E1 +P00 en cola ", 5, num);
    UART_EnviarEstado();
}

void procesar_tecla(char k) {
    int w, num, e;
    if (k == '*') {
        emergencia = !emergencia;
        modo = 0; buf_len = 0; buf[0] = '\0'; piso_usr = 0;
        if (emergencia) beep(25);
        else { LATBbits.LATB5 = 0; cont_buzz = 0; poner_msg("Sistema normal  "); }
        UART_EmitEmg(emergencia);
        UART_EnviarEstado();
        return;
    }
    if (emergencia) return;
    beep(4);

    if (k == 'A') { modo = 1; buf_len = 0; buf[0] = '\0'; piso_usr = 0; return; }

    if (k >= '0' && k <= '9') {
        w = elev_esperando();
        if (modo == 1 || (modo == 0 && w >= 0)) {
            if (buf_len >= 2) { buf[0] = k; buf[1] = '\0'; buf_len = 1; }
            else { buf[buf_len++] = k; buf[buf_len] = '\0'; }
            if (modo == 0 && w >= 0 && encolados[w] > 0) reloj_puerta[w] = T_ENCOLAR;
        } else if (modo == 2) msg_elev(-1, "P00: SUBIR/BAJAR", 1, piso_usr);
        else poner_msg("Presiona A: Piso");
        return;
    }

    if (k == '#') {
        num = (buf_len == 1) ? (buf[0] - '0')
            : (buf_len == 2) ? ((buf[0] - '0') * 10 + (buf[1] - '0')) : 0;
        buf_len = 0; buf[0] = '\0';

        if (modo == 1) {
            if (num < 1 || num > num_pisos) { modo = 0; poner_msg("ERROR:No existe!"); beep(18); }
            else { piso_usr = num; modo = 2; msg_elev(-1, "P00: SUBIR/BAJAR", 1, num); }
        } else if (modo == 0 && (w = elev_esperando()) >= 0) {
            encolar_destino_cabina(w, num);
        }
        return;
    }

    if (k == 'B') {
        e = (elev_esperando() >= 0) ? elev_esperando() : elev_activo;
        if (estado[e] != MOVIENDO) {
            if (estado[e] == LIBRE || estado[e] == LLEGO) { estado[e] = LLEGO; reloj_puerta[e] = T_BAJAR_PASAJ; }
            else if (reloj_puerta[e] > 0) reloj_puerta[e] = T_ENCOLAR;
            msg_elev(e, "E1 Puerta ABIER.", -1, 0); beep(7);
            UART_EnviarEstado();
        }
    } else if (k == 'C') {
        e = (elev_esperando() >= 0) ? elev_esperando() : elev_activo;
        if (estado[e] == ESPERA_DEST || estado[e] == LLEGO) {
            quitar_cola_espera(e);
            reloj_puerta[e] = 0; encolados[e] = 0; buf_len = 0; buf[0] = '\0';
            if (tiene_paradas(e)) {
                estado[e] = MOVIENDO; reloj_piso[e] = 0; siguiente_objetivo(e);
                msg_elev(e, "E1->Dest P00    ", 10, objetivo[e]);
            } else {
                estado[e] = LIBRE; direccion[e] = QUIETO;
                msg_elev(e, "E1 Puerta CERRA.", -1, 0);
            }
            beep(7);
            UART_EnviarEstado();
        }
    } else if (k == 'D') {
        if (buf_len > 0) buf[--buf_len] = '\0';
        else if (modo == 2) { piso_usr = 0; modo = 1; }
        else if (modo == 1) { modo = 0; poner_msg("Entrada borrada "); }
    }
}

// ===================== 5. LLEGADA, MOVIMIENTO, PANTALLA Y 9 LEDS =====================
void atender_llegada(int e) {
    int fl = piso[e], p;
    unsigned char mask = paradas[e][fl];
    unsigned char had_pickup = 0;
    unsigned char had_dest = (mask & BIT_DEST) ? 1U : 0U;
    int mas_arriba = 0, mas_abajo = 0;

    for (p = fl + 1; p <= num_pisos; p++) if (paradas[e][p]) { mas_arriba = 1; break; }
    for (p = fl - 1; p >= 1; p--)         if (paradas[e][p]) { mas_abajo = 1;  break; }

    paradas[e][fl] &= (unsigned char)(~BIT_DEST);
    if (had_dest) UART_EmitDeq(e, fl, 'C');

    if (direccion[e] == SUBIENDO) {
        if (mask & BIT_UP) {
            paradas[e][fl] &= (unsigned char)(~BIT_UP);
            had_pickup = 1U;
            UART_EmitDeq(e, fl, 'U');
        }
        if (!mas_arriba && (mask & BIT_DOWN)) {
            paradas[e][fl] &= (unsigned char)(~BIT_DOWN);
            had_pickup = 1U;
            direccion[e] = BAJANDO;
            UART_EmitDeq(e, fl, 'D');
        }
    } else if (direccion[e] == BAJANDO) {
        if (mask & BIT_DOWN) {
            paradas[e][fl] &= (unsigned char)(~BIT_DOWN);
            had_pickup = 1U;
            UART_EmitDeq(e, fl, 'D');
        }
        if (!mas_abajo && (mask & BIT_UP)) {
            paradas[e][fl] &= (unsigned char)(~BIT_UP);
            had_pickup = 1U;
            direccion[e] = SUBIENDO;
            UART_EmitDeq(e, fl, 'U');
        }
    } else {
        if (mask & BIT_UP) {
            paradas[e][fl] &= (unsigned char)(~BIT_UP);
            had_pickup = 1U;
            direccion[e] = SUBIENDO;
            UART_EmitDeq(e, fl, 'U');
        }
        if (mask & BIT_DOWN) {
            paradas[e][fl] &= (unsigned char)(~BIT_DOWN);
            had_pickup = 1U;
            if (!(mask & BIT_UP)) direccion[e] = BAJANDO;
            UART_EmitDeq(e, fl, 'D');
        }
    }

    objetivo[e] = 0;
    elev_activo = e;
    beep(12);

    if (had_pickup) {
        estado[e] = ESPERA_DEST;
        reloj_puerta[e] = 0;
        encolados[e] = 0;
        agregar_cola_espera(e);
        msg_elev(e, "E1 P00 Abierto  ", 4, fl);
    } else {
        estado[e] = LLEGO;
        reloj_puerta[e] = T_BAJAR_PASAJ;
        msg_elev(e, "E1 llego a P00  ", 12, fl);
    }
    UART_EnviarEstado();
}

void actualizar_todo(void) {
    int e, w;
    char l1[17], l2[17];

    if (++cont_parp >= T_PARPADEO) { cont_parp = 0; parpadeo = !parpadeo; }
    if (emergencia) {
        LATBbits.LATB5 = parpadeo;
    } else {
        if (cont_buzz > 0 && --cont_buzz == 0) LATBbits.LATB5 = 0;

        for (e = 0; e < 3; e++) {
            if (estado[e] == LLEGO) {
                if (reloj_puerta[e] > 0 && --reloj_puerta[e] == 0) {
                    if (tiene_paradas(e)) {
                        estado[e] = MOVIENDO; reloj_piso[e] = 0; siguiente_objetivo(e);
                    } else {
                        estado[e] = LIBRE; direccion[e] = QUIETO;
                    }
                    UART_EnviarEstado();
                }
            } else if (estado[e] == ESPERA_DEST) {
                if (encolados[e] > 0 && reloj_puerta[e] > 0 && --reloj_puerta[e] == 0) {
                    quitar_cola_espera(e);
                    encolados[e] = 0;
                    if (tiene_paradas(e)) {
                        estado[e] = MOVIENDO; reloj_piso[e] = 0; siguiente_objetivo(e);
                        msg_elev(e, "E1->Dest P00    ", 10, objetivo[e]);
                    } else {
                        estado[e] = LIBRE; direccion[e] = QUIETO;
                    }
                    UART_EnviarEstado();
                }
            } else if (estado[e] == MOVIENDO) {
                if (objetivo[e] == 0) siguiente_objetivo(e);
                if (objetivo[e] == 0) continue;

                // Si el objetivo es el piso actual, abrir inmediatamente sin esperar 2 s
                if (piso[e] == objetivo[e]) {
                    reloj_piso[e] = 0;
                    atender_llegada(e);
                    continue;
                }

                if (++reloj_piso[e] < T_POR_PISO) continue;
                reloj_piso[e] = 0;

                if (piso[e] < objetivo[e])      { direccion[e] = SUBIENDO; piso[e]++; }
                else if (piso[e] > objetivo[e]) { direccion[e] = BAJANDO;  piso[e]--; }

                if (piso[e] == objetivo[e]) {
                    atender_llegada(e);
                }
            }
        }
    }

    // Pantalla LCD 16x2
    if (emergencia) {
        strcpy(l1, "!! EMERGENCIA !!"); strcpy(l2, "Pulsa * reanudar");
    } else {
        strcpy(l1, "1:00  2:00  3:00");
        poner_2d(&l1[2],  piso[0]);
        poner_2d(&l1[8],  piso[1]);
        poner_2d(&l1[14], piso[2]);

        w = elev_esperando();
        if (modo == 1) {
            strcpy(l2, "Sel.Piso:__ #=OK");
            if (buf_len >= 1) l2[9] = buf[0];
            if (buf_len >= 2) l2[10] = buf[1];
        } else if (modo == 2) {
            strcpy(l2, "P00: SUBIR/BAJAR"); poner_2d(&l2[1], piso_usr);
        } else if (w >= 0) {
            if (strncmp(msg_lcd, "ERROR:No existe!", 16) == 0 && buf_len == 0) strcpy(l2, "ERROR:No existe!");
            else if (encolados[w] > 0 && buf_len == 0) {
                strcpy(l2, "E1 Q:00 0s C=Ir ");
                l2[1] = dig(w + 1);
                poner_2d(&l2[5], contar_destinos(w));
                l2[8] = dig((reloj_puerta[w] + 99) / 100);
            } else {
                strcpy(l2, "E1 Dest:__ #=OK "); l2[1] = dig(w + 1);
                if (buf_len >= 1) l2[8] = buf[0];
                if (buf_len >= 2) l2[9] = buf[1];
            }
        } else memcpy(l2, msg_lcd, 17);
    }
    LCD_Linea(0, l1); LCD_Linea(1, l2);

    // 9 LEDs (Elevador_v2): Verde=Sube | Amarillo=Espera(parpadea) | Rojo=Baja(o Emergencia)
    // Elevador 1: D6(V)=RE2, D9(A)=RA6, D8(R)=RC0
    LATEbits.LATE2 = (!emergencia && estado[0] == MOVIENDO && direccion[0] == SUBIENDO);
    LATAbits.LATA6 = (!emergencia && (estado[0] == ESPERA_DEST || estado[0] == LLEGO) && parpadeo);
    LATCbits.LATC0 = emergencia ? parpadeo : (unsigned char)(estado[0] == MOVIENDO && direccion[0] == BAJANDO);

    // Elevador 2: D1(V)=RC2, D7(A)=RD3, D2(R)=RD2
    LATCbits.LATC2 = (!emergencia && estado[1] == MOVIENDO && direccion[1] == SUBIENDO);
    LATDbits.LATD3 = (!emergencia && (estado[1] == ESPERA_DEST || estado[1] == LLEGO) && parpadeo);
    LATDbits.LATD2 = emergencia ? parpadeo : (unsigned char)(estado[1] == MOVIENDO && direccion[1] == BAJANDO);

    // Elevador 3: D3(V)=RD7, D5(A)=RD6, D4(R)=RD5
    LATDbits.LATD7 = (!emergencia && estado[2] == MOVIENDO && direccion[2] == SUBIENDO);
    LATDbits.LATD6 = (!emergencia && (estado[2] == ESPERA_DEST || estado[2] == LLEGO) && parpadeo);
    LATDbits.LATD5 = emergencia ? parpadeo : (unsigned char)(estado[2] == MOVIENDO && direccion[2] == BAJANDO);
}

// ===================== 6. PARSER DE COMANDOS UART =====================
int parse_2d(const char *s) {
    int v = 0;
    if (s[0] >= '0' && s[0] <= '9') {
        v = (int)(s[0] - '0');
        if (s[1] >= '0' && s[1] <= '9') v = v * 10 + (int)(s[1] - '0');
    }
    return v;
}

void UART_ProcessRx(void) {
    while (rx_tail != rx_head) {
        char c = rx_ring[rx_tail];
        rx_tail = (unsigned char)((rx_tail + 1U) & (RX_BUF_SZ - 1U));

        if (c == '\r' || c == '\n') {
            if (uart_rx_len == 0) continue;
            uart_rx[uart_rx_len] = '\0';

            if (uart_rx_len >= 3 && uart_rx[0] == 'N' && uart_rx[1] == ':') {
                cambiar_num_pisos(parse_2d(&uart_rx[2]));
            } else if (uart_rx_len >= 3 && uart_rx[0] == 'K' && uart_rx[1] == ':') {
                procesar_tecla(uart_rx[2]);
            } else if (uart_rx_len >= 3 && uart_rx[0] == 'H' && uart_rx[1] == ':') {
                if (uart_rx[2] == 'U') llamar_pasillo(SUBIENDO);
                else if (uart_rx[2] == 'D') llamar_pasillo(BAJANDO);
            } else if (uart_rx_len >= 6 && uart_rx[0] == 'C' && uart_rx[1] == ':') {
                // Llamada directa de pasillo: C:05,U o C:05,D
                int fl = parse_2d(&uart_rx[2]);
                char d = uart_rx[5];
                if (d == 'U' || d == 'D') llamar_pasillo_piso(fl, (d == 'U') ? SUBIENDO : BAJANDO);
            } else if (uart_rx_len >= 6 && uart_rx[0] == 'D' && uart_rx[1] == ':') {
                // Destino directo de cabina: D:1,09 (elevador 1..3, piso 01..20)
                int e = (uart_rx[2] - '1');
                int fl = parse_2d(&uart_rx[4]);
                if (e >= 0 && e <= 2) encolar_destino_cabina(e, fl);
            } else if (uart_rx[0] == 'R') {
                reiniciar_sistema();
            }
            uart_rx_len = 0;
        } else if (uart_rx_len < 18) {
            uart_rx[uart_rx_len++] = c;
        }
    }
}

// ===================== 7. MAIN =====================
void main(void) {
    OSCCONbits.IRCF = 0b111;    // 8 MHz interno
    ADCON0 = 0x00; ADCON1 = 0x0F; CMCON = 0x07; SPPCON = 0x00; // Todos digitales

    // Direcciones Elevador_v2 (0 = Salida, 1 = Entrada)
    // RA0..RA3=filas teclado, RA4..RA5=cols 1-2 teclado, RA6=LED Amarillo E1 (D9)
    TRISA = 0b00111111;
    // RB0=LCD D4, RB1=LCD D5, RB2=LCD D7, RB3=Btn BAJAR, RB4=Btn SUBIR, RB5=Buzzer, RB6/RB7=PICkit3
    TRISBbits.TRISB0 = 0; TRISBbits.TRISB1 = 0; TRISBbits.TRISB2 = 0;
    TRISBbits.TRISB3 = 1; TRISBbits.TRISB4 = 1;
    TRISBbits.TRISB5 = 0;
    TRISBbits.TRISB6 = 1; TRISBbits.TRISB7 = 1;
    // RC0=LED Rojo E1 (D8), RC1=libre, RC2=LED Verde E2 (D1), RC6/RC7=UART
    TRISCbits.TRISC0 = 0; TRISCbits.TRISC1 = 0; TRISCbits.TRISC2 = 0;
    // RD0=LCD RS, RD1=LCD E, RD2=D2(R E2), RD3=D7(A E2), RD4=LCD D6, RD5=D4(R E3), RD6=D5(A E3), RD7=D3(V E3)
    TRISD = 0x00;
    // RE0..RE1=cols 3-4 teclado, RE2=LED Verde E1 (D6)
    TRISEbits.TRISE0 = 1; TRISEbits.TRISE1 = 1; TRISEbits.TRISE2 = 0;

    LATA = 0; LATB = 0; LATC = 0; LATD = 0; LATE = 0;
    memset(paradas, 0, sizeof(paradas));

    LCD_Init();
    UART_Init();
    actualizar_todo();
    UART_EnviarEstado();

    while (1) {
        char t = leer_teclado();
        if (t != 0 && t != tecla_ant) procesar_tecla(t);
        tecla_ant = t;

        // Botones de pasillo Elevador_v2: RB4 (izq, R6) = SUBIR | RB3 (der, R7) = BAJAR
        if (PORTBbits.RB4 == 0 && subir_ant == 1) llamar_pasillo(SUBIENDO);
        subir_ant = PORTBbits.RB4;
        if (PORTBbits.RB3 == 0 && bajar_ant == 1) llamar_pasillo(BAJANDO);
        bajar_ant = PORTBbits.RB3;

        // Ciclo de 10 ms con bombeo continuo de TX y lectura de RX sin perdida de bytes
        for (int ms = 0; ms < 10; ms++) {
            UART_PumpTx();
            UART_ProcessRx();
            __delay_us(500);
            UART_PumpTx();
            __delay_us(500);
        }

        actualizar_todo();
        if (++cont_uart >= 25) { cont_uart = 0; UART_EnviarEstado(); }
    }
}
