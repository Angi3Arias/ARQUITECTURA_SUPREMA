/*
 * File:   LOGIC_TEST.c
 * Author: santo
 *
 * Elevador Supremo — Version simple y breve (estilo Semaforo y Potenciometro Supremo)
 * PIC18F4550 @ 8 MHz | LCD 16x2 | Teclado 4x4 | 2 Botones | 9 LEDs | Buzzer 5V | UART
 */

#define _XTAL_FREQ 8000000UL
#include "config.h"
#include <xc.h>
#include <string.h>

// ===================== CONFIGURACION =====================
#define PISOS_INICIAL   12      // Pisos iniciales (configurable desde la interfaz 4..20)
#define T_POR_PISO      200     // 200 x 10ms = 2.0 s por piso
#define T_ENCOLAR       450     // 450 x 10ms = 4.5 s para que varios usuarios encolen pisos
#define T_BAJAR_PASAJ   220     // 220 x 10ms = 2.2 s puerta abierta al llegar a destino
#define T_PARPADEO      35      // 35  x 10ms = 350 ms parpadeo LED amarillo y emergencia

#define LIBRE 0
#define MOVIENDO 1
#define ESPERA_DEST 2
#define LLEGO 3

#define QUIETO 0
#define SUBIENDO 1
#define BAJANDO 2

// ===================== VARIABLES GLOBALES =====================
int num_pisos       = PISOS_INICIAL;
int piso[3]         = {1, PISOS_INICIAL / 2, PISOS_INICIAL};
int estado[3]       = {LIBRE, LIBRE, LIBRE};
int direccion[3]    = {QUIETO, QUIETO, QUIETO};
int objetivo[3]     = {0, 0, 0};
int reloj_piso[3]   = {0, 0, 0};
int reloj_puerta[3] = {0, 0, 0};
int encolados[3]    = {0, 0, 0};

// Paradas por elevador (1..20): 0=nada, 1=recoger SUBIR, 2=recoger BAJAR, 3=destino cabina
unsigned char paradas[3][21];

// Teclado: modo 0=normal/destino | 1=pulso 'A' (piso) | 2=confirmo '#' (espera SUBIR/BAJAR)
int  modo = 0, piso_usr = 0, elev_activo = 0, buf_len = 0;
char buf[3] = "";

// Emergencia, parpadeo y buzzer
unsigned char emergencia = 0, parpadeo = 1;
int cont_parp = 0, cont_buzz = 0, cont_uart = 0;

// Antirrebote y cache del LCD
char msg_lcd[17] = "Presiona A: Piso", prev_l1[17] = "", prev_l2[17] = "";
char tecla_ant = 0, uart_rx[8] = "";
int  subir_ant = 1, bajar_ant = 1, uart_rx_len = 0;

// ===================== 1. UTILIDADES Y LCD 16x2 (RD0..RD5) =====================
char dig(int v) { return (char)('0' + (unsigned char)(v % 10)); }
int  vabs(int x) { return (x < 0) ? -x : x; }
void beep(int t) { cont_buzz = t; LATBbits.LATB5 = 1; }

void poner_2d(char *p, int v) { p[0] = dig(v / 10); p[1] = dig(v); }

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
    // Solo toca RD2..RD5 para NO alterar RD6/RD7 (LEDs amarillos E1 y E2)
    LATDbits.LATD2 = (n >> 0) & 1; LATDbits.LATD3 = (n >> 1) & 1;
    LATDbits.LATD4 = (n >> 2) & 1; LATDbits.LATD5 = (n >> 3) & 1;
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
    for (f = 0; f < 4; f++) {
        TRISA |= 0x0F; LATA &= 0xF0;
        TRISA &= (unsigned char)(~(1 << f));
        __delay_us(15);
        if (PORTBbits.RB0 == 0) { t = TECLAS[f][0]; break; }
        if (PORTBbits.RB1 == 0) { t = TECLAS[f][1]; break; }
        if (PORTBbits.RB2 == 0) { t = TECLAS[f][2]; break; }
        if (PORTBbits.RB3 == 0) { t = TECLAS[f][3]; break; }
    }
    TRISA |= 0x0F;
    return t;
}

void UART_Init(void) {
    TRISCbits.TRISC6 = 1; TRISCbits.TRISC7 = 1;
    SPBRG = 51; TXSTAbits.BRGH = 1; TXSTAbits.SYNC = 0; BAUDCONbits.BRG16 = 0;
    RCSTAbits.SPEN = 1; TXSTAbits.TXEN = 1; RCSTAbits.CREN = 1;
}

char estado_char(int e) {
    if (emergencia) return 'E';
    if (estado[e] == MOVIENDO) return (direccion[e] == SUBIENDO) ? 'U' : 'D';
    if (estado[e] == ESPERA_DEST || estado[e] == LLEGO) return 'W';
    return 'I';
}

void UART_EnviarEstado(void) {
    // Formato: S,01I,06U,12D,0,12\r\n
    char t[22] = "S,00I,00I,00I,0,12\r\n";
    int i;
    poner_2d(&t[2], piso[0]);  t[4]  = estado_char(0);
    poner_2d(&t[6], piso[1]);  t[8]  = estado_char(1);
    poner_2d(&t[10], piso[2]); t[12] = estado_char(2);
    t[14] = emergencia ? '1' : '0';
    poner_2d(&t[16], num_pisos);
    for (i = 0; t[i] != '\0'; i++) {
        int esp = 800;
        while (!TXSTAbits.TRMT && esp-- > 0);
        if (TXSTAbits.TRMT) TXREG = (unsigned char)t[i];
    }
}

void cambiar_num_pisos(int n) {
    int e, p;
    if (n < 4 || n > 20) return;
    num_pisos = n;
    for (e = 0; e < 3; e++) {
        if (piso[e] > num_pisos) piso[e] = num_pisos;
        if (objetivo[e] > num_pisos) objetivo[e] = 0;
        for (p = num_pisos + 1; p <= 20; p++) paradas[e][p] = 0;
    }
    msg_elev(-1, "Pisos N=00 listo", 8, num_pisos);
    beep(6);
}

// ===================== 3. DESPACHO OPTIMO Y COLA (LOOK) =====================
int tiene_paradas(int e) {
    int p;
    for (p = 1; p <= num_pisos; p++) if (paradas[e][p]) return 1;
    return 0;
}

int contar_destinos(int e) {
    int p, c = 0;
    for (p = 1; p <= num_pisos; p++) if (paradas[e][p] == 3) c++;
    return c;
}

int elev_esperando(void) {
    int e;
    for (e = 0; e < 3; e++) if (estado[e] == ESPERA_DEST) return e;
    return -1;
}

void siguiente_objetivo(int e) {
    int p, min_p = 99, max_p = 0;
    for (p = 1; p <= num_pisos; p++) if (paradas[e][p]) {
        if (p < min_p) min_p = p;
        if (p > max_p) max_p = p;
    }
    if (max_p == 0) {
        objetivo[e] = 0; direccion[e] = QUIETO;
        if (estado[e] == MOVIENDO) estado[e] = LIBRE;
        return;
    }
    if (direccion[e] == SUBIENDO) {
        for (p = piso[e]; p <= num_pisos; p++)
            if (paradas[e][p] == 3 || paradas[e][p] == 1 || p == max_p) { objetivo[e] = p; return; }
        direccion[e] = BAJANDO; objetivo[e] = max_p;
    } else if (direccion[e] == BAJANDO) {
        for (p = piso[e]; p >= 1; p--)
            if (paradas[e][p] == 3 || paradas[e][p] == 2 || p == min_p) { objetivo[e] = p; return; }
        direccion[e] = SUBIENDO; objetivo[e] = min_p;
    } else {
        int mejor = min_p, d = 99;
        for (p = 1; p <= num_pisos; p++) if (paradas[e][p] && vabs(p - piso[e]) < d) {
            d = vabs(p - piso[e]); mejor = p;
        }
        objetivo[e] = mejor;
        direccion[e] = (mejor > piso[e]) ? SUBIENDO : ((mejor < piso[e]) ? BAJANDO : QUIETO);
    }
}

// Evalua libres Y en movimiento para que el mas cercano (o el que ya viene de paso) vaya
int costo_elevador(int e, int p_usr, int dir) {
    int p, lejano = piso[e];
    if (estado[e] == LIBRE) return vabs(piso[e] - p_usr);
    if (estado[e] == MOVIENDO) {
        if (direccion[e] == SUBIENDO) {
            if (dir == SUBIENDO && p_usr > piso[e]) return p_usr - piso[e];
            for (p = piso[e]; p <= num_pisos; p++) if (paradas[e][p]) lejano = p;
            return (lejano - piso[e]) + vabs(lejano - p_usr) + 1;
        }
        if (direccion[e] == BAJANDO) {
            if (dir == BAJANDO && p_usr < piso[e]) return piso[e] - p_usr;
            for (p = piso[e]; p >= 1; p--) if (paradas[e][p]) lejano = p;
            return (piso[e] - lejano) + vabs(p_usr - lejano) + 1;
        }
    }
    return vabs(piso[e] - p_usr) + ((estado[e] == LLEGO) ? 2 : 4);
}

// ===================== 4. BOTONES DE PASILLO Y TECLADO =====================
void llamar_pasillo(int dir) {
    int e, mejor = 0, best = 999, fl;
    if (emergencia) return;
    if (modo != 2 || piso_usr == 0) { poner_msg("Primero pulsa A!"); beep(10); return; }

    fl = piso_usr; piso_usr = 0; modo = 0;
    for (e = 0; e < 3; e++) {
        int c = costo_elevador(e, fl, dir);
        if (c < best) { best = c; mejor = e; }
    }
    elev_activo = mejor; beep(8);

    if (piso[mejor] == fl && estado[mejor] != MOVIENDO) {
        estado[mejor] = ESPERA_DEST; reloj_puerta[mejor] = 0; encolados[mejor] = 0;
        msg_elev(mejor, "E1 P00 Abierto  ", 4, fl);
    } else {
        paradas[mejor][fl] = (dir == SUBIENDO) ? 1 : 2;
        if (estado[mejor] == LIBRE) { estado[mejor] = MOVIENDO; reloj_piso[mejor] = 0; }
        if (estado[mejor] == MOVIENDO) siguiente_objetivo(mejor);
        msg_elev(mejor, (dir == SUBIENDO) ? "E1->P00 (SUBIR) " : "E1->P00 (BAJAR) ", 5, fl);
    }
}

void procesar_tecla(char k) {
    int w, num, e;
    if (k == '*') {
        emergencia = !emergencia;
        modo = 0; buf_len = 0; buf[0] = '\0'; piso_usr = 0;
        if (emergencia) beep(25);
        else { LATBbits.LATB5 = 0; cont_buzz = 0; poner_msg("Sistema normal  "); }
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
            if (num < 1 || num > num_pisos) { poner_msg("ERROR:No existe!"); beep(18); }
            else if (num == piso[w]) msg_elev(-1, "Ya en Piso 00!  ", 11, num);
            else {
                if (paradas[w][num] == 0) paradas[w][num] = 3;
                encolados[w]++; reloj_puerta[w] = T_ENCOLAR;
                msg_elev(w, "E1 +P00 en cola ", 5, num);
            }
        }
        return;
    }

    if (k == 'B') {
        e = (elev_esperando() >= 0) ? elev_esperando() : elev_activo;
        if (estado[e] != MOVIENDO) {
            if (estado[e] == LIBRE || estado[e] == LLEGO) { estado[e] = LLEGO; reloj_puerta[e] = T_BAJAR_PASAJ; }
            else if (reloj_puerta[e] > 0) reloj_puerta[e] = T_ENCOLAR;
            msg_elev(e, "E1 Puerta ABIER.", -1, 0); beep(7);
        }
    } else if (k == 'C') {
        e = (elev_esperando() >= 0) ? elev_esperando() : elev_activo;
        if (estado[e] == ESPERA_DEST || estado[e] == LLEGO) {
            reloj_puerta[e] = 0; encolados[e] = 0; buf_len = 0; buf[0] = '\0';
            if (tiene_paradas(e)) {
                estado[e] = MOVIENDO; reloj_piso[e] = 0; siguiente_objetivo(e);
                msg_elev(e, "E1->Dest P00    ", 10, objetivo[e]);
            } else {
                estado[e] = LIBRE; direccion[e] = QUIETO;
                msg_elev(e, "E1 Puerta CERRA.", -1, 0);
            }
            beep(7);
        }
    } else if (k == 'D') {
        if (buf_len > 0) buf[--buf_len] = '\0';
        else if (modo == 2) { piso_usr = 0; modo = 1; }
        else if (modo == 1) { modo = 0; poner_msg("Entrada borrada "); }
    }
}

// ===================== 5. MOVIMIENTO, PANTALLA Y 9 LEDS =====================
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
                    if (tiene_paradas(e)) { estado[e] = MOVIENDO; reloj_piso[e] = 0; siguiente_objetivo(e); }
                    else { estado[e] = LIBRE; direccion[e] = QUIETO; }
                }
            } else if (estado[e] == ESPERA_DEST) {
                if (encolados[e] > 0 && reloj_puerta[e] > 0 && --reloj_puerta[e] == 0) {
                    encolados[e] = 0;
                    if (tiene_paradas(e)) {
                        estado[e] = MOVIENDO; reloj_piso[e] = 0; siguiente_objetivo(e);
                        msg_elev(e, "E1->Dest P00    ", 10, objetivo[e]);
                    } else { estado[e] = LIBRE; direccion[e] = QUIETO; }
                }
            } else if (estado[e] == MOVIENDO) {
                if (objetivo[e] == 0) siguiente_objetivo(e);
                if (objetivo[e] == 0 || ++reloj_piso[e] < T_POR_PISO) continue;
                reloj_piso[e] = 0;

                if (piso[e] < objetivo[e])      { direccion[e] = SUBIENDO; piso[e]++; }
                else if (piso[e] > objetivo[e]) { direccion[e] = BAJANDO;  piso[e]--; }

                if (piso[e] == objetivo[e]) {
                    int fl = piso[e];
                    unsigned char tipo = paradas[e][fl];
                    paradas[e][fl] = 0; objetivo[e] = 0; elev_activo = e; beep(12);
                    if (tipo == 1 || tipo == 2) {
                        estado[e] = ESPERA_DEST; reloj_puerta[e] = 0; encolados[e] = 0;
                        msg_elev(e, "E1 P00 Abierto  ", 4, fl);
                    } else {
                        estado[e] = LLEGO; reloj_puerta[e] = T_BAJAR_PASAJ;
                        msg_elev(e, "E1 llego a P00  ", 12, fl);
                    }
                }
            }
        }
    }

    // Pantalla LCD 16x2
    if (emergencia) {
        strcpy(l1, "!! EMERGENCIA !!"); strcpy(l2, "Pulsa * reanudar");
    } else {
        // Linea 1 (16 chars exactos, bien espaciada): "1:01  2:04  3:12"
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
                strcpy(l2, "E1 Cola:0 0s C  ");
                l2[1] = dig(w + 1); l2[8] = dig(contar_destinos(w));
                l2[10] = dig((reloj_puerta[w] + 99) / 100);
            } else {
                strcpy(l2, "E1 Dest:__ #=OK "); l2[1] = dig(w + 1);
                if (buf_len >= 1) l2[8] = buf[0];
                if (buf_len >= 2) l2[9] = buf[1];
            }
        } else memcpy(l2, msg_lcd, 17);
    }
    LCD_Linea(0, l1); LCD_Linea(1, l2);

    // 9 LEDs: Verde=Sube | Amarillo=Espera(parpadea) | Rojo=Baja(o Emergencia)
    LATCbits.LATC0 = (!emergencia && estado[0] == MOVIENDO && direccion[0] == SUBIENDO);
    LATDbits.LATD6 = (!emergencia && (estado[0] == ESPERA_DEST || estado[0] == LLEGO) && parpadeo);
    LATCbits.LATC1 = emergencia ? parpadeo : (unsigned char)(estado[0] == MOVIENDO && direccion[0] == BAJANDO);

    LATCbits.LATC2 = (!emergencia && estado[1] == MOVIENDO && direccion[1] == SUBIENDO);
    LATDbits.LATD7 = (!emergencia && (estado[1] == ESPERA_DEST || estado[1] == LLEGO) && parpadeo);
    LATEbits.LATE0 = emergencia ? parpadeo : (unsigned char)(estado[1] == MOVIENDO && direccion[1] == BAJANDO);

    LATEbits.LATE1 = (!emergencia && estado[2] == MOVIENDO && direccion[2] == SUBIENDO);
    LATBbits.LATB4 = (!emergencia && (estado[2] == ESPERA_DEST || estado[2] == LLEGO) && parpadeo);
    LATEbits.LATE2 = emergencia ? parpadeo : (unsigned char)(estado[2] == MOVIENDO && direccion[2] == BAJANDO);
}

// ===================== 6. MAIN =====================
void main(void) {
    OSCCONbits.IRCF = 0b111;    // 8 MHz interno (igual que Semaforo/Potenciometro)
    ADCON0 = 0x00; ADCON1 = 0x0F; CMCON = 0x07; SPPCON = 0x00; // Todos digitales

    // Direcciones (0 = Salida, 1 = Entrada)
    TRISA = 0b00111111;         // RA0..RA3 filas teclado, RA4=SUBIR, RA5=BAJAR
    TRISBbits.TRISB0 = 1; TRISBbits.TRISB1 = 1;
    TRISBbits.TRISB2 = 1; TRISBbits.TRISB3 = 1;
    TRISBbits.TRISB4 = 0;       // LED Amarillo E3
    TRISBbits.TRISB5 = 0;       // Buzzer 5V
    TRISCbits.TRISC0 = 0; TRISCbits.TRISC1 = 0; TRISCbits.TRISC2 = 0;
    TRISD = 0x00;               // LCD (RD0..RD5) y LEDs amarillos E1/E2 (RD6, RD7)
    TRISEbits.TRISE0 = 0; TRISEbits.TRISE1 = 0; TRISEbits.TRISE2 = 0;

    LATA = 0; LATB = 0; LATC = 0; LATD = 0; LATE = 0;
    memset(paradas, 0, sizeof(paradas));

    LCD_Init();
    UART_Init();
    actualizar_todo();

    while (1) {
        char t = leer_teclado();
        if (t != 0 && t != tecla_ant) procesar_tecla(t);
        tecla_ant = t;

        if (PORTAbits.RA4 == 0 && subir_ant == 1) llamar_pasillo(SUBIENDO);
        subir_ant = PORTAbits.RA4;
        if (PORTAbits.RA5 == 0 && bajar_ant == 1) llamar_pasillo(BAJANDO);
        bajar_ant = PORTAbits.RA5;

        // Leer comandos desde la interfaz Python (N:XX, K:x, H:U/D)
        if (RCSTAbits.OERR) { RCSTAbits.CREN = 0; RCSTAbits.CREN = 1; }
        while (PIR1bits.RCIF) {
            char c = (char)RCREG;
            if (c == '\r' || c == '\n') {
                uart_rx[uart_rx_len] = '\0';
                if (uart_rx_len >= 3 && uart_rx[0] == 'N' && uart_rx[1] == ':') {
                    int n = uart_rx[2] - '0';
                    if (uart_rx_len >= 4 && uart_rx[3] >= '0' && uart_rx[3] <= '9')
                        n = n * 10 + (uart_rx[3] - '0');
                    cambiar_num_pisos(n);
                } else if (uart_rx_len >= 3 && uart_rx[0] == 'K' && uart_rx[1] == ':') {
                    procesar_tecla(uart_rx[2]);
                } else if (uart_rx_len >= 3 && uart_rx[0] == 'H' && uart_rx[1] == ':') {
                    if (uart_rx[2] == 'U') llamar_pasillo(SUBIENDO);
                    else if (uart_rx[2] == 'D') llamar_pasillo(BAJANDO);
                }
                uart_rx_len = 0;
            } else if (uart_rx_len < 7) {
                uart_rx[uart_rx_len++] = c;
            }
        }

        actualizar_todo();
        if (++cont_uart >= 50) { cont_uart = 0; UART_EnviarEstado(); }
        __delay_ms(10);
    }
}
