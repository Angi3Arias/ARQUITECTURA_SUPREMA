# -*- coding: utf-8 -*-
"""
Genera los bocetos visuales del proyecto Elevador Supremo (Version Display LCD 16x2):
  1) proteus_vista_real_lcd.svg  -> como queda armado en Proteus 8 Professional (LM016L)
  2) protoboard_fisico_lcd.svg   -> como queda armado en protoboard fisico con PICkit 3
Ejecutar:  python generar_bocetos_lcd.py
"""
import os

HERE = os.path.dirname(os.path.abspath(__file__))


class SVG:
    def __init__(self, w, h, bg):
        self.w, self.h = w, h
        self.o = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" '
                  f'viewBox="0 0 {w} {h}">']
        self.bg = bg

    def a(self, s):
        self.o.append(s)

    def line(self, x1, y1, x2, y2, c, w=2, extra=""):
        self.a(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{c}" '
               f'stroke-width="{w}" stroke-linecap="round" {extra}/>')

    def rect(self, x, y, w, h, fill="none", stroke="none", sw=1, rx=0, extra=""):
        self.a(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" '
               f'stroke="{stroke}" stroke-width="{sw}" {extra}/>')

    def circle(self, x, y, r, fill="none", stroke="none", sw=1, extra=""):
        self.a(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{fill}" stroke="{stroke}" '
               f'stroke-width="{sw}" {extra}/>')

    def text(self, x, y, s, size=12, c="#000", anchor="start", weight="normal",
             fam="Arial, Helvetica, sans-serif", extra=""):
        self.a(f'<text x="{x}" y="{y}" font-family="{fam}" font-size="{size}" fill="{c}" '
               f'text-anchor="{anchor}" font-weight="{weight}" {extra}>{s}</text>')

    def poly(self, pts, fill="none", stroke="none", sw=1, extra=""):
        p = " ".join(f"{x},{y}" for x, y in pts)
        self.a(f'<polygon points="{p}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}" {extra}/>')

    def path(self, d, fill="none", stroke="none", sw=1, extra=""):
        self.a(f'<path d="{d}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}" {extra}/>')

    def save(self, name):
        self.o.append("</svg>")
        with open(os.path.join(HERE, name), "w", encoding="utf-8") as f:
            f.write("\n".join(self.o))
        print("OK ->", name)


# =====================================================================================
# 1) VISTA REAL EN PROTEUS 8 PROFESSIONAL (PIC18F4550 + LM016L LCD 16x2 + KEYPAD 4x4)
# =====================================================================================
def proteus_lcd():
    W, H = 2000, 1140
    s = SVG(W, H, "#dcd2b4")
    BG = "#dcd2b4"
    WIRE, BODY_FILL, BODY_STRK, PIN_BG, PIN_TXT = "#007a00", "#dcb998", "#8b0000", "#e6b5b5", "#111"
    F = "Segoe UI, Arial, sans-serif"

    s.a('<defs>'
        '<pattern id="p8grid" width="20" height="20" patternUnits="userSpaceOnUse">'
        '<path d="M 20 0 L 0 0 0 20" fill="none" stroke="#cfc5a8" stroke-width="0.8"/></pattern>'
        '<filter id="glow"><feGaussianBlur stdDeviation="2" result="b"/>'
        '<feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>'
        '</defs>')

    # Barra superior estilo Proteus 8
    s.rect(0, 0, W, 38, fill="#f0f0f0")
    s.line(0, 38, W, 38, "#bdbdbd", 1)
    s.text(14, 25, "Elevador LCD - Proteus 8 Professional - Esquema electronico  [VERSION DISPLAY LCD 16x2]",
           14, "#222", "start", "bold", F)
    s.rect(0, 38, W, 28, fill="#e6ecf5")
    s.rect(12, 42, 165, 24, fill="#fff", stroke="#bbb", rx=2)
    s.text(94, 59, "Esquema electronico", 12, "#111", "middle", "bold", F)

    # Panel izquierdo DEVICES estilo Proteus 8
    s.rect(0, 66, 225, H - 66, fill="#f5f5f5", stroke="#c0c0c0", sw=1)
    s.rect(8, 74, 209, 120, fill="#dcd2b4", stroke="#888", sw=1)
    s.text(112, 138, "Vista previa", 11, "#666", "middle", "normal", F)
    s.rect(8, 204, 209, 24, fill="#2f6690")
    s.text(16, 221, "DEVICES (Buscar con 'P')", 11, "#fff", "start", "bold", F)
    devs = [
        ("BUTTON", "2 botones pasillo (Subir/Bajar)"),
        ("BUZZER", "Buzzer ACTIVE 5V (en RB5)"),
        ("COMPIM", "Serial 9600 (Fisico: USB-TTL)"),
        ("KEYPAD-SMALLCALC", "Teclado 4x4 (A,B,C,D,#,*)"),
        ("LED-GREEN", "LED Verde = SUBE (x3)"),
        ("LED-YELLOW", "LED Amarillo = PUERTA (x3)"),
        ("LED-RED", "LED Rojo = BAJA (x3)"),
        ("LM016L", "Pantalla LCD 16x2 (x1)"),
        ("PIC18F4550", "Microcontrolador (x1)"),
        ("POT-HG", "Potenciometro 10k lineal"),
        ("RES", "10k (x7) y 220 Ohm (x9)"),
    ]
    for i, (nm, desc) in enumerate(devs):
        yy = 228 + i * 30
        s.rect(10, yy, 205, 28, fill="#fff" if i % 2 == 0 else "#edf2f7", stroke="#dcdcdc")
        s.text(18, yy + 11, nm, 10, "#003380", "start", "bold", "Consolas, monospace")
        s.text(18, yy + 23, desc, 9, "#444", "start", "normal", F)

    # Modo terminales
    s.rect(8, 560, 209, 155, fill="#fff", stroke="#b0b0b0", rx=3)
    s.rect(8, 560, 209, 24, fill="#406080")
    s.text(16, 577, "MODO TERMINALES (Terminals)", 10.5, "#fff", "start", "bold", F)
    terms = [
        ("POWER", "Triangulo arriba (+5V)"),
        ("GROUND", "Rayas abajo (0V / GND)"),
        ("DEFAULT", "Etiqueta de red (mismo"),
        ("", "nombre = conectados)"),
    ]
    for i, (t1, t2) in enumerate(terms):
        yy = 602 + i * 24
        if t1:
            s.text(16, yy, t1, 11, "#8b0000", "start", "bold", "Consolas")
        s.text(80 if t1 else 16, yy, t2, 10.5, "#333", "start", "normal", F)

    # Ventajas LCD 16x2
    s.rect(8, 735, 209, 190, fill="#fff8d6", stroke="#c9a400", rx=3)
    s.text(16, 757, "VENTAJAS DE ESTA VERSION:", 11, "#5a4200", "start", "bold", F)
    pasos = [
        "- Soporta N pisos (1..99)",
        "- Muestra piso tecleado",
        "  antes de confirmar (#)",
        "- Solo 6 cables al PIC",
        "  (RD0..RD5 en modo 4 bits)",
        "- Sin chips 74LS47 ni 21",
        "  resistencias de display",
        "- Clock en U1 = 8MHz",
    ]
    for i, p in enumerate(pasos):
        s.text(16, 779 + i * 18, p, 10.5, "#333", "start", "normal", F)

    # Lienzo principal estilo Proteus 8
    CX = 225
    s.rect(CX, 66, W - CX, H - 66, fill=BG)
    s.rect(CX, 66, W - CX, H - 66, fill="url(#p8grid)")

    def wire(x1, y1, x2, y2):
        s.line(x1, y1, x2, y2, WIRE, 2.2)

    def junc(x, y):
        s.circle(x, y, 4, fill=WIRE)

    def lbl(x, y, txt, anchor="start", col="#000"):
        s.text(x, y - 5, txt, 11.5, col, anchor, "bold", "Consolas, monospace")

    def term_power(x, y, txt="POWER (+5V)"):
        wire(x, y, x, y - 16)
        s.poly([(x - 8, y - 16), (x + 8, y - 16), (x, y - 27)], fill=WIRE, stroke=WIRE)
        s.text(x, y - 31, txt, 10, "#111", "middle", "bold", F)

    def term_gnd(x, y):
        wire(x, y, x, y + 14)
        s.line(x - 12, y + 14, x + 12, y + 14, WIRE, 2.2)
        s.line(x - 8, y + 19, x + 8, y + 19, WIRE, 2.2)
        s.line(x - 4, y + 24, x + 4, y + 24, WIRE, 2.2)

    def res_h(x, y, ref, val, L=74):
        wire(x, y, x + 18, y)
        s.rect(x + 18, y - 6, L - 36, 12, fill="#fff6c4", stroke=BODY_STRK, sw=1.8)
        wire(x + L - 18, y, x + L, y)
        if ref:
            s.text(x + L / 2, y - 9, ref, 10, "#00008b", "middle", "bold", F)
        if val:
            s.text(x + L / 2, y + 18, val, 10, "#333", "middle", "normal", F)

    def res_v(x, y, ref, val, L=66):
        wire(x, y, x, y + 16)
        s.rect(x - 6, y + 16, 12, L - 32, fill="#fff6c4", stroke=BODY_STRK, sw=1.8)
        wire(x, y + L - 16, x, y + L)
        s.text(x + 10, y + L / 2 - 2, ref, 10, "#00008b", "start", "bold", F)
        s.text(x + 10, y + L / 2 + 10, val, 10, "#333", "start", "normal", F)

    def led_h(x, y, col, lit, ref):
        wire(x, y, x + 14, y)
        s.poly([(x + 14, y - 10), (x + 14, y + 10), (x + 32, y)],
               fill=col if lit else "#fff6c4", stroke=BODY_STRK, sw=1.8,
               extra='filter="url(#glow)"' if lit else "")
        s.line(x + 32, y - 10, x + 32, y + 10, BODY_STRK, 2.2)
        wire(x + 32, y, x + 48, y)
        for dx in (0, 7):
            s.line(x + 20 + dx, y - 12, x + 28 + dx, y - 20, BODY_STRK, 1.4)
            s.poly([(x + 28 + dx, y - 20), (x + 23 + dx, y - 19), (x + 27 + dx, y - 15)], fill=BODY_STRK)
        s.text(x + 23, y + 22, ref, 10, "#00008b", "middle", "bold", F)

    # ================= U1 PIC18F4550 EXACTO DE PROTEUS 8 =================
    ux, uw = 720, 270
    uy, pitch = 215, 26
    left_pins = [
        (0,  2,  "RA0/AN0",              "FILA1"),
        (1,  3,  "RA1/AN1",              "FILA2"),
        (2,  4,  "RA2/AN2/VREF-/CVREF",  "FILA3"),
        (3,  5,  "RA3/AN3/VREF+",        "FILA4"),
        (4,  6,  "RA4/T0CKI/C1OUT/RCV",  "BTN_SUBIR"),
        (5,  7,  "RA5/AN4/SS/HLVDIN",    "BTN_BAJAR"),
        (6,  14, "RA6/OSC2/CLKO",        None),
        (7,  13, "OSC1/CLKI",            None),
        (9,  33, "RB0/AN12/INT0/SDI",    "COL1"),
        (10, 34, "RB1/AN10/INT1/SCK",    "COL2"),
        (11, 35, "RB2/AN8/INT2/VMO",     "COL3"),
        (12, 36, "RB3/AN9/CCP2/VPO",     "COL4"),
        (13, 37, "RB4/AN11/KBI0/CSSPP",  "E3_PUERTA"),
        (14, 38, "RB5/KBI1/PGM",         "BUZZER"),
        (15, 39, "RB6/KBI2/PGC",         "PGC (Libre)"),
        (16, 40, "RB7/KBI3/PGD",         "PGD (Libre)"),
        (19, 18, "VUSB",                 None),
    ]
    right_pins = [
        (0,  15, "RC0/T1OSO/T13CKI",     "E1_SUBE"),
        (1,  16, "RC1/T1OSI/CCP2/UOE",   "E1_BAJA"),
        (2,  17, "RC2/CCP1/P1A",         "E2_SUBE"),
        (3,  23, "RC4/D-/VM",            None),
        (4,  24, "RC5/D+/VP",            None),
        (5,  25, "RC6/TX/CK",            "UART_TX"),
        (6,  26, "RC7/RX/DT/SDO",        "UART_RX"),
        (9,  19, "RD0/SPP0",             "LCD_RS"),
        (10, 20, "RD1/SPP1",             "LCD_E"),
        (11, 21, "RD2/SPP2",             "LCD_D4"),
        (12, 22, "RD3/SPP3",             "LCD_D5"),
        (13, 27, "RD4/SPP4",             "LCD_D6"),
        (14, 28, "RD5/SPP5/P1B",         "LCD_D7"),
        (15, 29, "RD6/SPP6/P1C",         "E1_PUERTA"),
        (16, 30, "RD7/SPP7/P1D",         "E2_PUERTA"),
        (18, 8,  "RE0/AN5/CK1SPP",       "E2_BAJA"),
        (19, 9,  "RE1/AN6/CK2SPP",       "E3_SUBE"),
        (20, 10, "RE2/AN7/OESPP",        "E3_BAJA"),
        (21, 1,  "RE3/MCLR/VPP",         "MCLR"),
    ]
    uh = 21 * pitch + 32
    s.text(ux + 4, uy - 8, "U1", 13, "#111", "start", "bold", F)
    s.rect(ux, uy, uw, uh, fill=BODY_FILL, stroke=BODY_STRK, sw=2)
    s.text(ux + 4, uy + uh + 16, "PIC18F4550", 12, "#111", "start", "normal", F)
    s.text(ux + uw / 2, uy + uh + 34, "(Oscilador interno 8 MHz - VDD/VSS automaticos en Proteus)", 10.5, "#555", "middle", "normal", F)

    lpos, rpos = {}, {}
    for row, num, nm, net in left_pins:
        py = uy + 18 + row * pitch
        lpos[num] = py
        s.rect(ux - 26, py - 9, 26, 18, fill=PIN_BG, stroke=BODY_STRK, sw=1)
        s.text(ux - 13, py + 4, str(num), 9.5, PIN_TXT, "middle", "normal", F)
        s.text(ux + 6, py + 4, nm, 9.5, "#222", "start", "normal", F)
        if net and "Libre" in net:
            s.text(ux - 32, py + 4, net, 9, "#666", "end", "italic", F)
        elif net in ("BTN_SUBIR", "BTN_BAJAR"):
            wire(ux - 26, py, ux - 110, py)
            lbl(ux - 108, py, net, "start", "#8b008b")
        elif net in ("E3_PUERTA", "BUZZER"):
            wire(ux - 26, py, ux - 95, py)
            lbl(ux - 93, py, net, "start", "#b58900" if net == "E3_PUERTA" else "#cc0000")

    for row, num, nm, net in right_pins:
        py = uy + 18 + row * pitch
        rpos[num] = py
        s.rect(ux + uw, py - 9, 26, 18, fill=PIN_BG, stroke=BODY_STRK, sw=1)
        s.text(ux + uw + 13, py + 4, str(num), 9.5, PIN_TXT, "middle", "normal", F)
        s.text(ux + uw - 6, py + 4, nm, 9.5, "#222", "end", "normal", F)
        if net in ("E2_BAJA", "E3_SUBE", "E3_BAJA"):
            wire(ux + uw + 26, py, ux + uw + 96, py)
            lbl(ux + uw + 32, py, net, "start", "#8b0000")
        elif net in ("E1_PUERTA", "E2_PUERTA"):
            wire(ux + uw + 26, py, ux + uw + 115, py)
            lbl(ux + uw + 32, py, net, "start", "#b58900")
        elif net in ("UART_TX", "UART_RX"):
            pass  # conectado directo al bloque COMPIM (P1) justo a la derecha

    # ================= COMPIM (SERIAL UART -> GUI PYTHON / FISICO: USB-TTL) =================
    cx_p1, cy_p1 = 1145, 355
    s.rect(cx_p1, cy_p1, 130, 74, fill=BODY_FILL, stroke="#0055aa", sw=2, rx=4)
    s.text(cx_p1 + 65, cy_p1 + 88, "P1 (COMPIM - 9600 bps)", 10.5, "#0055aa", "middle", "bold", F)
    s.text(cx_p1 + 65, cy_p1 + 33, "COMPIM", 12, "#003380", "middle", "bold", "Consolas")
    s.text(cx_p1 + 65, cy_p1 + 49, "Fisico: USB-TTL", 9.5, "#333", "middle", "bold", F)
    s.text(cx_p1 + 65, cy_p1 + 63, "-> GUI Python", 9.5, "#0055aa", "middle", "italic", F)
    # Pines TXD (3) y RXD (2) del COMPIM conectados directo a RC6/TX (25) y RC7/RX (26)
    py_tx, py_rx = rpos[25], rpos[26]
    wire(ux + uw + 26, py_tx, cx_p1 - 18, py_tx)
    lbl(ux + uw + 32, py_tx, "UART_TX", "start", "#0055aa")
    s.rect(cx_p1 - 18, py_tx - 7, 18, 14, fill=PIN_BG, stroke="#0055aa", sw=1)
    s.text(cx_p1 - 9, py_tx + 3, "3", 8.5, "#111", "middle", "normal", F)
    s.text(cx_p1 + 4, py_tx + 3, "TXD", 8.5, "#003380", "start", "bold", F)

    wire(ux + uw + 26, py_rx, cx_p1 - 18, py_rx)
    lbl(ux + uw + 32, py_rx, "UART_RX", "start", "#0055aa")
    s.rect(cx_p1 - 18, py_rx - 7, 18, 14, fill=PIN_BG, stroke="#0055aa", sw=1)
    s.text(cx_p1 - 9, py_rx + 3, "2", 8.5, "#111", "middle", "normal", F)
    s.text(cx_p1 + 4, py_rx + 3, "RXD", 8.5, "#003380", "start", "bold", F)

    # ================= MCLR Pull-Up 10k abajo derecha =================
    my = rpos[1]
    wire(ux + uw + 26, my, ux + uw + 135, my)
    res_v(ux + uw + 135, my - 66, "R1", "10k", 66)
    term_power(ux + uw + 135, my - 66, "POWER (+5V)")

    # ================= KEYPAD-SMALLCALC A LA IZQUIERDA (CONEXION DIRECTA A RA0..RA3 y RB0..RB3) =================
    kx, ky, kw, kh = 320, 390, 190, 235
    s.text(kx, ky - 8, "KEYPAD1", 12, "#111", "start", "bold", F)
    s.rect(kx, ky, kw, kh, fill="#d9d9d9", stroke=BODY_STRK, sw=2, rx=4)
    krows = [["7", "8", "9", "/"], ["4", "5", "6", "*"], ["1", "2", "3", "-"], ["ON/C", "0", "=", "+"]]
    kalt =  [["1", "2", "3", "A"], ["4", "5", "6", "B"], ["7", "8", "9", "C"], ["*", "0", "#", "D"]]
    for r in range(4):
        for c in range(4):
            bx, by = kx + 12 + c * 43, ky + 14 + r * 54
            bc = "#b85c5c" if (r == 3 and c == 0) else ("#5c78b8" if c == 3 else "#b8b8b8")
            s.rect(bx, by, 37, 44, fill=bc, stroke="#555", sw=1.2, rx=3)
            s.text(bx + 18, by + 22, kalt[r][c], 14, "#fff" if bc != "#b8b8b8" else "#111", "middle", "bold", F)
            s.text(bx + 18, by + 37, f"({krows[r][c]})" if kalt[r][c] != krows[r][c] else "", 8, "#eee", "middle", "normal", F)
    s.text(kx + kw / 2, ky + kh + 32, "KEYPAD-SMALLCALC", 11, "#111", "middle", "bold", F)

    # Filas A, B, C, D conectadas directo a RA0, RA1, RA2, RA3!
    ra_pins = [2, 3, 4, 5]
    for r in range(4):
        py_k = ky + 36 + r * 54
        py_ra = lpos[ra_pins[r]]
        s.line(kx - 20, py_k, kx, py_k, BODY_STRK, 2)
        s.text(kx + 4, py_k + 4, chr(65 + r), 9, "#333", "start", "bold", F)
        x_left = kx - 30 - r * 14
        wire(kx - 20, py_k, x_left, py_k)
        wire(x_left, py_k, x_left, py_ra)
        wire(x_left, py_ra, ux - 26, py_ra)
        lbl(ux - 92, py_ra, f"FILA{r + 1}", "start", "#8b0000")

    # Columnas 1, 2, 3, 4 conectadas directo a RB0..RB3 + Pull-ups 10k (arriba a cada COL, abajo unidos a POWER +5V)
    rb_pins = [33, 34, 35, 36]
    y_res = 755
    y_pu_bot = y_res + 66
    for c in range(4):
        cx_k = kx + 30 + c * 43
        s.line(cx_k, ky + kh, cx_k, ky + kh + 20, BODY_STRK, 2)
        s.text(cx_k, ky + kh - 4, str(c + 1), 9, "#333", "middle", "bold", F)
        y_bus = ky + kh + 86 - c * 15
        wire(cx_k, ky + kh + 20, cx_k, y_bus)
        x_turn = 550 + c * 20
        wire(cx_k, y_bus, x_turn, y_bus)
        junc(cx_k, y_bus)
        # Extremo superior de R -> columna; extremo inferior de R -> riel comun POWER (+5V)
        wire(cx_k, y_bus, cx_k, y_res)
        res_v(cx_k, y_res, f"R{c + 2}", "10k", 66)
        if c == 0:
            wire(cx_k, y_pu_bot, cx_k + 3 * 43 + 48, y_pu_bot)
        else:
            junc(cx_k, y_pu_bot)
        py_rb = lpos[rb_pins[c]]
        wire(x_turn, y_bus, x_turn, py_rb)
        wire(x_turn, py_rb, ux - 26, py_rb)
        lbl(626, py_rb, f"COL{c + 1}", "start", "#006600")
    term_power(kx + 30 + 3 * 43 + 48, y_pu_bot, "POWER (+5V)")
    s.text(kx + 30 + 64, y_pu_bot + 18, "Pull-Ups 10k (Columnas a +5V)", 10, "#111", "middle", "bold", F)

    # ================= 9 LEDS ARRIBA DERECHA (3 POR ELEVADOR: VERDE=SUBE, AMARILLO=PUERTA, ROJO=BAJA) =================
    all_leds = [
        (15,   "E1_SUBE",   "#1fe01f", True,  "D1", "E1 SUBE (V)"),
        (None, "E1_PUERTA", "#ffd000", False, "D2", "E1 PUERTA (A)"),
        (16,   "E1_BAJA",   "#ff2626", False, "D3", "E1 BAJA (R)"),
        (17,   "E2_SUBE",   "#1fe01f", False, "D4", "E2 SUBE (V)"),
        (None, "E2_PUERTA", "#ffd000", False, "D5", "E2 PUERTA (A)"),
        (None, "E2_BAJA",   "#ff2626", True,  "D6", "E2 BAJA (R)"),
        (None, "E3_SUBE",   "#1fe01f", False, "D7", "E3 SUBE (V)"),
        (None, "E3_PUERTA", "#ffd000", True,  "D8", "E3 PUERTA (A)"),
        (None, "E3_BAJA",   "#ff2626", False, "D9", "E3 BAJA (R)"),
    ]
    lx_led = 1165
    x_gnd = 1320
    for idx, (pin, net, col, lit, dref, desc) in enumerate(all_leds):
        y_led = 92 + idx * 32
        if pin is not None:
            py_pin = rpos[pin]
            x_jog = ux + uw + 38 + (idx * 7)
            wire(ux + uw + 26, py_pin, x_jog, py_pin)
            wire(x_jog, py_pin, x_jog, y_led)
            wire(x_jog, y_led, lx_led, y_led)
            lbl(lx_led - 6, y_led, net, "end", "#111")
        else:
            wire(1095, y_led, lx_led, y_led)
            lbl(1098, y_led, net, "start", "#b58900" if "PUERTA" in net else "#8b0000")
        res_h(lx_led, y_led, f"R{idx + 6}", "220", 72)
        led_h(lx_led + 72, y_led, col, lit, dref)
        wire(lx_led + 120, y_led, x_gnd, y_led)
        if idx < 8:
            junc(x_gnd, y_led)
        s.text(x_gnd + 12, y_led + 4, desc, 10, "#111", "start", "bold", F)
    wire(x_gnd, 92, x_gnd, 92 + 8 * 32)
    term_gnd(x_gnd, 92 + 8 * 32)

    # ================= SOLO 2 BOTONES FISICOS DE PASILLO (SUBIR / BAJAR) =================
    bx_box, by_box = 1525, 82
    s.rect(bx_box, by_box, 390, 290, fill="none", stroke="#4060a0", sw=1.5, extra='stroke-dasharray="7 5"')
    s.rect(bx_box, by_box, 390, 24, fill="#4060a0")
    s.text(bx_box + 10, by_box + 17, "SOLO 2 BOTONES FISICOS: PASILLO (SUBIR / BAJAR)",
           10.5, "#fff", "start", "bold", F)
    btns_info = [
        ("BTN1", "BTN_SUBIR", "SUBIR", "RA4 (Pin 6)"),
        ("BTN2", "BTN_BAJAR", "BAJAR", "RA5 (Pin 7)"),
    ]
    b_rail_y = by_box + 66
    wire(bx_box + 70, b_rail_y, bx_box + 230, b_rail_y)
    term_power(bx_box + 70, b_rail_y, "POWER (+5V)")
    for i, (bref, bnet, btxt, bpin) in enumerate(btns_info):
        bx = bx_box + 70 + i * 160
        if i > 0:
            junc(bx, b_rail_y)
        res_v(bx, b_rail_y, f"R{15 + i}", "10k", 66)
        ny = b_rail_y + 66
        junc(bx, ny)
        wire(bx, ny, bx + 54, ny)
        lbl(bx + 6, ny, bnet, "start", "#8b008b")
        wire(bx, ny, bx, ny + 18)
        s.circle(bx, ny + 21, 3, fill="#fff", stroke=BODY_STRK, sw=1.8)
        s.circle(bx, ny + 45, 3, fill="#fff", stroke=BODY_STRK, sw=1.8)
        wire(bx, ny + 48, bx, ny + 66)
        s.line(bx - 11, ny + 15, bx - 11, ny + 51, BODY_STRK, 2.2)
        s.line(bx - 11, ny + 33, bx - 20, ny + 33, BODY_STRK, 2.2)
        s.line(bx - 20, ny + 27, bx - 20, ny + 39, BODY_STRK, 2.2)
        s.text(bx + 10, ny + 29, bref, 10, "#00008b", "start", "bold", F)
        s.text(bx + 10, ny + 42, btxt, 10, "#111", "start", "bold", F)
        s.text(bx + 10, ny + 54, bpin, 9, "#555", "start", "normal", F)
        term_gnd(bx, ny + 66)
    s.text(bx_box + 195, by_box + 275, "(Puertas B/C y Emergencia * van en el Teclado 4x4)", 9.5, "#4060a0", "middle", "bold", F)

    # ================= ALARMA SONORA BUZZER ACTIVE 5V (RB5) ARRIBA IZQUIERDA =================
    ex, ey = 250, 82
    s.rect(ex, ey, 415, 130, fill="none", stroke="#b3261e", sw=1.5, extra='stroke-dasharray="7 5"')
    s.rect(ex, ey, 415, 24, fill="#b3261e")
    s.text(ex + 10, ey + 17, "ALARMA SONORA BUZZER 5V (RB5)  —  EMERGENCIA EN TECLA '*'", 10, "#fff", "start", "bold", F)
    bzx, bzy = ex + 150, ey + 72
    wire(bzx - 75, bzy - 10, bzx - 8, bzy - 10)
    lbl(bzx - 75, bzy - 10, "BUZZER", "start", "#cc0000")
    wire(bzx - 35, bzy + 10, bzx - 8, bzy + 10)
    wire(bzx - 35, bzy + 10, bzx - 35, ey + 105)
    term_gnd(bzx - 35, ey + 105)
    s.a(f'<path d="M {bzx + 12} {bzy - 18} A 18 18 0 0 0 {bzx + 12} {bzy + 18} Z" fill="#cfc9ad" stroke="{BODY_STRK}" stroke-width="2"/>')
    s.text(bzx + 24, bzy - 6,  "BUZ1 (BUZZER - ACTIVE)", 10.5, "#00008b", "start", "bold", F)
    s.text(bzx + 24, bzy + 10, "Operating Voltage: 5V", 10, "#b3261e", "start", "bold", F)
    s.text(bzx + 24, bzy + 25, "Se activa con tecla '*' del teclado", 9.5, "#444", "start", "normal", F)

    # ================= PANTALLA LCD 16x2 (LM016L) A LA DERECHA =================
    lcd_x, lcd_y, lcd_w, lcd_h = 1350, 445, 560, 215
    s.text(lcd_x, lcd_y - 10, "LCD1", 13, "#111", "start", "bold", F)
    # Carcasa verde/oscura estilo LM016L en Proteus 8
    s.rect(lcd_x, lcd_y, lcd_w, lcd_h, fill="#2e6b3e", stroke="#173820", sw=2.5, rx=6)
    s.rect(lcd_x + 24, lcd_y + 22, lcd_w - 48, 132, fill="#1b1f1c", stroke="#444", sw=2, rx=4)
    # Pantalla iluminada verde-amarilla clasica de LM016L
    s.rect(lcd_x + 38, lcd_y + 36, lcd_w - 76, 104, fill="#9be04a", stroke="#4b751d", sw=2, rx=2)
    # Matriz de texto 16x2 simulada (monoespaciada)
    s.text(lcd_x + 56, lcd_y + 78,  "E1:03^ E2:12v E3:01", 28, "#162e08", "start", "bold", "Consolas, monospace")
    s.text(lcd_x + 56, lcd_y + 122, "Piso: 15   [#=OK]",   28, "#162e08", "start", "bold", "Consolas, monospace")
    s.text(lcd_x + lcd_w - 8, lcd_y - 10, "LM016L (LCD 16x2 - Modo 4 bits)", 12, "#003380", "end", "bold", F)

    # 14 pines en la parte inferior del LM016L
    lcd_pins = [
        (1,  "VSS"), (2,  "VDD"), (3,  "VEE"), (4,  "RS"),  (5,  "RW"),  (6,  "E"),
        (7,  "D0"),  (8,  "D1"),  (9,  "D2"),  (10, "D3"),  (11, "D4"),  (12, "D5"),
        (13, "D6"),  (14, "D7"),
    ]
    pin_xs = {}
    for i, (pnum, pnm) in enumerate(lcd_pins):
        px = lcd_x + 42 + i * 36.5
        pin_xs[pnm] = px
        s.text(px, lcd_y + lcd_h - 14, pnm, 9.5, "#fff", "middle", "bold", F)
        s.line(px, lcd_y + lcd_h, px, lcd_y + lcd_h + 24, BODY_STRK, 2)
        s.text(px - 4, lcd_y + lcd_h + 15, str(pnum), 8.5, "#333", "end", "normal", F)

    # Conexiones fijas del LCD: VSS->GND, VDD->POWER, RW->GND, VEE->POT-HG 10k
    # VSS (Pin 1) y RW (Pin 5) -> GROUND
    wire(pin_xs["VSS"], lcd_y + lcd_h + 24, pin_xs["VSS"], lcd_y + lcd_h + 145)
    term_gnd(pin_xs["VSS"], lcd_y + lcd_h + 145)
    wire(pin_xs["RW"], lcd_y + lcd_h + 24, pin_xs["RW"], lcd_y + lcd_h + 62)
    term_gnd(pin_xs["RW"], lcd_y + lcd_h + 62)
    # VDD (Pin 2) -> POWER
    wire(pin_xs["VDD"], lcd_y + lcd_h + 24, pin_xs["VDD"], lcd_y + lcd_h + 50)
    wire(pin_xs["VDD"], lcd_y + lcd_h + 50, pin_xs["VDD"] - 22, lcd_y + lcd_h + 50)
    term_power(pin_xs["VDD"] - 22, lcd_y + lcd_h + 50, "+5V")

    # Potenciometro RV1 (POT-HG 10k) conectado a VEE (Pin 3)
    pot_x = pin_xs["VEE"] + 10
    pot_y = lcd_y + lcd_h + 95
    # Cuerpo del POT-HG vertical
    wire(pot_x, pot_y - 25, pot_x, pot_y)
    term_power(pot_x, pot_y - 25, "+5V")
    s.rect(pot_x - 8, pot_y, 16, 56, fill="#fff6c4", stroke=BODY_STRK, sw=2)
    wire(pot_x, pot_y + 56, pot_x, pot_y + 74)
    term_gnd(pot_x, pot_y + 74)
    # Cursor hacia VEE (Pin 3)
    wire(pin_xs["VEE"], lcd_y + lcd_h + 24, pin_xs["VEE"], pot_y + 28)
    wire(pin_xs["VEE"], pot_y + 28, pot_x - 8, pot_y + 28)
    s.poly([(pot_x - 8, pot_y + 28), (pot_x - 16, pot_y + 23), (pot_x - 16, pot_y + 33)], fill=BODY_STRK)
    s.text(pot_x + 16, pot_y + 22, "RV1", 11, "#00008b", "start", "bold", F)
    s.text(pot_x + 16, pot_y + 37, "10k Lineal (POT-HG)", 10, "#333", "start", "normal", F)
    s.text(pot_x + 16, pot_y + 51, "(Contraste LCD)", 9.5, "#555", "start", "italic", F)

    # Conexion limpia de RD0..RD5 -> RS, E, D4, D5, D6, D7 (6 lineas limpias hacia abajo y directo a los pines!)
    lcd_map = [
        (19, "RS", "LCD_RS"),
        (20, "E",  "LCD_E"),
        (21, "D4", "LCD_D4"),
        (22, "D5", "LCD_D5"),
        (27, "D6", "LCD_D6"),
        (28, "D7", "LCD_D7"),
    ]
    for i, (pic_pin, lpin, lnet) in enumerate(lcd_map):
        py_u = rpos[pic_pin]
        px_l = pin_xs[lpin]
        x_bus = 1175 + i * 20
        y_bus = 825 + i * 22
        wire(ux + uw + 26, py_u, x_bus, py_u)
        lbl(ux + uw + 34, py_u, lnet, "start", "#004499")
        wire(x_bus, py_u, x_bus, y_bus)
        wire(x_bus, y_bus, px_l, y_bus)
        wire(px_l, y_bus, px_l, lcd_y + lcd_h + 24)

    # Cuadro resumen abajo izquierda
    s.rect(250, 945, 865, 165, fill="#f8f6ee", stroke="#7a6f54", sw=1.8, rx=6)
    s.rect(250, 945, 865, 28, fill="#2f6690", rx=4)
    s.text(266, 964, "RESUMEN DE CONEXION EN PROTEUS 8  (VERSION DISPLAY LCD 16x2 - LM016L)",
           12.5, "#fff", "start", "bold", F)
    notes = [
        ("LCD 16x2 (LM016L):", "RD0->RS, RD1->E, RD2->D4, RD3->D5, RD4->D6, RD5->D7  |  VSS/RW a GND, VDD a +5V, VEE a RV1 (10k lineal)"),
        ("Teclado 4x4 (KEYPAD1):", "A: Sel.Piso | B: Abrir puerta | C: Cerrar puerta | D: Borrar | #: Confirmar | *: Emergencia"),
        ("9 LEDs + 2 Botones:", "3 LEDs/elevador (V=Sube, A=Espera/Parpadea [RD6,RD7,RB4], R=Baja)  |  Solo 2 botones: SUBIR(RA4), BAJAR(RA5)"),
        ("Buzzer, UART y PICkit3:", "BUZZER 5V en RB5  |  UART: RC6/TX y RC7/RX (COMPIM/USB-TTL)  |  ICSP: MCLR, RB6, RB7 libres"),
    ]
    for i, (k, v) in enumerate(notes):
        yy = 995 + i * 26
        s.text(266, yy, k, 11.5, "#8b0000", "start", "bold", F)
        s.text(440, yy, v, 11.5, "#222", "start", "normal", F)

    s.save("proteus_vista_real_lcd.svg")


# =====================================================================================
# 2) PROTOBOARD FISICO (VERSION DISPLAY LCD 16x2 + PIC18F4550 + PICKIT 3)
# =====================================================================================
def protoboard_lcd():
    W, H = 1800, 1120
    s = SVG(W, H, "#3b2f26")
    s.a('<defs>'
        '<pattern id="wood" width="200" height="40" patternUnits="userSpaceOnUse">'
        '<rect width="200" height="40" fill="#5a4636"/><path d="M0 20 Q50 12 100 20 T200 20" '
        'stroke="#4d3b2d" stroke-width="3" fill="none"/></pattern>'
        '<pattern id="holes" width="20" height="20" patternUnits="userSpaceOnUse">'
        '<rect x="7" y="7" width="6" height="6" rx="1" fill="#6d6d66"/></pattern>'
        '<filter id="glow"><feGaussianBlur stdDeviation="2.5" result="b"/>'
        '<feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>'
        '<filter id="shadow"><feDropShadow dx="3" dy="4" stdDeviation="3" flood-opacity="0.45"/></filter>'
        '</defs>')
    s.rect(0, 0, W, H, fill="url(#wood)")
    s.text(W / 2, 48, "ELEVADOR SUPREMO (Version LCD 16x2)  -  Armado fisico en protoboard", 28, "#fff",
           "middle", "bold", "Segoe UI, Arial")

    def board(x, y, cols=64):
        w = 20 * cols + 20
        s.rect(x, y, w, 350, fill="#f1f0ea", stroke="#c9c7bd", sw=2, rx=10, extra='filter="url(#shadow)"')
        for ry, col in ((y + 12, "#d33"), (y + 50, "#33d"), (y + 300, "#d33"), (y + 338, "#33d")):
            s.line(x + 20, ry, x + w - 20, ry, col, 2)
        s.rect(x + 10, y + 20, w - 20, 20, fill="url(#holes)")
        s.rect(x + 10, y + 310, w - 20, 20, fill="url(#holes)")
        s.rect(x + 10, y + 70, w - 20, 100, fill="url(#holes)")
        s.rect(x + 10, y + 185, w - 20, 100, fill="url(#holes)")
        s.rect(x + 10, y + 170, w - 20, 14, fill="#dddbd2")
        return w

    def hx(bx, c):
        return bx + 20 + c * 20

    def dip(bx, by, c0, n, name, sub):
        x0 = hx(bx, c0) - 8
        w = (n - 1) * 20 + 16
        ytop, ybot = by + 138, by + 218
        for k in range(n):
            xx = hx(bx, c0 + k)
            s.rect(xx - 3, ytop - 4, 6, 10, fill="#c8c8c8")
            s.rect(xx - 3, ybot - 6, 6, 10, fill="#c8c8c8")
        s.rect(x0, ytop + 4, w, ybot - ytop - 8, fill="#1d1d1f", rx=3, extra='filter="url(#shadow)"')
        cy = (ytop + ybot) / 2
        s.path(f"M{x0} {cy - 8} a8 8 0 0 1 0 16", fill="#3a3a3c")
        s.circle(x0 + 16, ybot - 14, 3, fill="#3a3a3c")
        s.text(x0 + w / 2, cy, name, 15, "#e6e6e6", "middle", "bold", "Consolas, monospace")
        s.text(x0 + w / 2, cy + 18, sub, 11, "#9a9a9a", "middle", "normal", "Consolas, monospace")

    def wirep(d, col):
        s.path(d, stroke="#00000055", sw=6.5, extra='stroke-linecap="round" transform="translate(2,3)"')
        s.path(d, stroke=col, sw=4.5, extra='stroke-linecap="round"')

    def resistor(x1, y1, x2, y2, bands=("#a52a2a", "#000", "#ff8c00")):
        s.line(x1, y1, x2, y2, "#b9b9b9", 3)
        mx, my = (x1 + x2) / 2, (y1 + y2) / 2
        s.rect(mx - 7, my - 18, 14, 36, fill="#e8cfa0", stroke="#b49a6a", rx=6)
        for i, b in enumerate(bands):
            s.rect(mx - 7, my - 11 + i * 8, 14, 4, fill=b)

    def callout(x, y, tx, ty, txt, w=None):
        s.line(x, y, tx, ty, "#ffe066", 2)
        s.circle(x, y, 5, fill="#ffe066")
        lines = txt.split("|")
        ww = w or max(len(l) for l in lines) * 8 + 20
        hh = 22 * len(lines) + 10
        s.rect(tx - 4, ty - 18, ww, hh, fill="#fff8d0", stroke="#c9a400", sw=2, rx=6,
               extra='filter="url(#shadow)"')
        for i, l in enumerate(lines):
            s.text(tx + 6, ty + i * 22, l, 14, "#3a2a00", "start", "bold" if i == 0 else "normal",
                   "Segoe UI, Arial")

    # --- Dos protoboards (mucho mas limpias sin los 3 chips 74LS47!) ---
    AX, AY = 420, 105
    BX, BY = 420, 545
    board(AX, AY)
    board(BX, BY)

    # Board A: PIC18F4550 + ICSP + Pantalla LCD 16x2 + Potenciometro 10k de contraste!
    dip(AX, AY, 6, 20, "PIC18F4550-I/P", "MICROCHIP  |  40-PIN DIP")
    # Header ICSP
    for k in range(6):
        xx = hx(AX, k)
        s.rect(xx - 7, AY + 72, 14, 16, fill="#111")
        s.rect(xx - 2, AY + 66, 4, 18, fill="#e4c15a")
    s.text(hx(AX, 2) + 10, AY + 108, "ICSP", 12, "#333", "middle", "bold", "Segoe UI")
    resistor(hx(AX, 6), AY + 30, hx(AX, 6), AY + 120)
    for c in (16, 19):
        s.line(hx(AX, c), AY + 52, hx(AX, c), AY + 100, "#b9b9b9", 3)
        s.line(hx(AX, c + 1), AY + 30, hx(AX, c + 1), AY + 100, "#b9b9b9", 3)
        s.a(f'<ellipse cx="{hx(AX, c) + 10}" cy="{AY + 92}" rx="13" ry="11" fill="#e0a020" stroke="#9a6a00"/>')
        s.text(hx(AX, c) + 10, AY + 96, "104", 8, "#4a2e00", "middle", "bold")

    # Potenciometro 10k lineal (B10K) rotativo de 3 pines en Board A (c = 29, 30, 31)
    px_pot = hx(AX, 30)
    # 3 patitas: izq (+5V), centro (VEE), der (GND)
    s.line(px_pot - 20, AY + 165, px_pot - 20, AY + 195, "#b9b9b9", 3)
    s.line(px_pot,      AY + 165, px_pot,      AY + 195, "#b9b9b9", 3)
    s.line(px_pot + 20, AY + 165, px_pot + 20, AY + 195, "#b9b9b9", 3)
    # Cables +5V (rojo) y GND (negro) a los extremos del potenciometro lineal
    wirep(f"M{px_pot - 20} {AY + 195} L{px_pot - 20} {AY + 310}", "#ff2222")
    wirep(f"M{px_pot + 20} {AY + 195} L{px_pot + 20} {AY + 338}", "#111111")
    # Cuerpo circular metalico + perilla rotativa del potenciometro lineal B10K
    s.circle(px_pot, AY + 142, 26, fill="#b0b5bc", stroke="#5c636e", sw=2, extra='filter="url(#shadow)"')
    s.circle(px_pot, AY + 142, 17, fill="#22262e", stroke="#555", sw=1.5)
    s.line(px_pot, AY + 142, px_pot - 10, AY + 131, "#f0f0f0", 3)
    s.text(px_pot, AY + 106, "B10K", 10, "#222", "middle", "bold", "Consolas")
    s.text(px_pot, AY + 216, "POT 10k", 11, "#222", "middle", "bold", "Segoe UI")
    s.text(px_pot, AY + 230, "Lineal", 10, "#444", "middle", "normal", "Segoe UI")

    # Modulo Pantalla LCD 16x2 (2.26") montado a la derecha de Board A (c = 36..61)
    lx, ly, lw, lh = hx(AX, 36) - 10, AY + 75, 510, 215
    s.rect(lx, ly, lw, lh, fill="#1f6f3d", stroke="#124224", sw=2.5, rx=8, extra='filter="url(#shadow)"')
    # 16 pines dorados arriba del LCD
    for k in range(16):
        px = lx + 26 + k * 20
        s.circle(px, ly + 14, 5, fill="#e4c15a", stroke="#8a6c1a", sw=1)
    s.rect(lx + 24, ly + 34, lw - 48, 146, fill="#1a1d1b", stroke="#3d423e", sw=2, rx=4)
    s.rect(lx + 40, ly + 48, lw - 80, 118, fill="#9be04a", stroke="#4d751f", sw=2, rx=2, extra='filter="url(#glow)"')
    s.text(lx + 54, ly + 96,  "E1:03^ E2:12v E3:01", 24, "#162e08", "start", "bold", "Consolas, monospace")
    s.text(lx + 54, ly + 142, "Piso: 15   [#=OK]",   24, "#162e08", "start", "bold", "Consolas, monospace")
    s.text(lx + lw - 16, ly + lh - 10, "LCD 16x2 (HD44780)", 11, "#d8f5df", "end", "bold", "Segoe UI")

    # 6 cables PIC (RD0..RD5) -> LCD (RS, E, D4..D7) rodeando por ARRIBA para no tapar la pantalla!
    lcd_cols = ["#2a7fff", "#00b050", "#ff8800", "#ffee00", "#9b59ff", "#00cccc"]
    lcd_pin_idx = [3, 5, 10, 11, 12, 13]
    for i, idx in enumerate(lcd_pin_idx):
        x1 = hx(AX, 20 + i)
        x2 = lx + 26 + idx * 20
        y_arc = AY + 14 + i * 7
        wirep(f"M{x1} {AY + 128} C{x1} {y_arc} {x2 - 25} {y_arc} {x2} {ly + 14}", lcd_cols[i])
    # Cable cursor central POT 10k lineal -> VEE (pin 3 del LCD)
    wirep(f"M{px_pot} {AY + 195} C{px_pot} {AY + 265} {lx + 26 + 2 * 20 - 55} {AY + 58} {lx + 26 + 2 * 20} {ly + 14}", "#ff55aa")

    # Board B: 9 LEDs (3 por elevador: V=Sube, A=Puerta, R=Baja) + 2 Botones Pasillo + Buzzer + Teclado 4x4
    ledc = [("#22dd22", True),  ("#ffd000", False), ("#ff2222", False),
            ("#22dd22", False), ("#ffd000", False), ("#ff2222", True),
            ("#22dd22", False), ("#ffd000", True),  ("#ff2222", False)]
    for k, (col, lit) in enumerate(ledc):
        g = k // 3
        c = 2 + k * 2 + g * 2
        xx = hx(BX, c)
        s.line(xx, BY + 90, xx, BY + 130, "#b9b9b9", 2)
        s.line(xx + 20, BY + 90, xx + 20, BY + 130, "#b9b9b9", 2)
        s.a(f'<ellipse cx="{xx + 10}" cy="{BY + 82}" rx="12" ry="14" fill="{col}" '
            f'opacity="{1 if lit else 0.35}" stroke="#00000044" {'filter="url(#glow)"' if lit else ""}/>')
        if lit:
            s.circle(xx + 10, BY + 82, 22, fill=col, extra='opacity="0.25"')
        resistor(xx + 20, BY + 150, xx + 20, BY + 338, ("#f00", "#f00", "#a52a2a"))
    for g in range(3):
        cx_g = hx(BX, 2 + g * 8) + 40
        s.text(cx_g, BY + 252, f"E{g + 1}", 16, "#222", "middle", "bold", "Segoe UI")
        s.text(cx_g, BY + 270, "V  A  R", 10.5, "#444", "middle", "bold", "Segoe UI")

    # Solo 2 Botones tactiles de Pasillo (SUBIR / BAJAR) en c = 28, 33
    b_labels = [("SUB", "#2a8f4d"), ("BAJ", "#cc3333")]
    for k, (blbl, bcol) in enumerate(b_labels):
        c = 28 + k * 5
        xx = hx(BX, c)
        s.rect(xx - 4, BY + 150, 44, 54, fill="#2a2a2a", rx=4, extra='filter="url(#shadow)"')
        s.circle(xx + 18, BY + 177, 14, fill=bcol, stroke="#111", sw=2)
        for px, py in ((xx - 2, BY + 150), (xx + 34, BY + 150), (xx - 2, BY + 198), (xx + 34, BY + 198)):
            s.rect(px, py, 6, 6, fill="#c8c8c8")
        s.text(xx + 18, BY + 226, blbl, 11.5, "#222", "middle", "bold", "Segoe UI")
        resistor(xx + 36, BY + 12, xx + 36, BY + 135, ("#a52a2a", "#000", "#ff8c00"))

    # Buzzer activo 5V en c = 38
    bz_x, bz_y = hx(BX, 39), BY + 265
    s.circle(bz_x, bz_y, 24, fill="#1c1c1e", stroke="#444", sw=2, extra='filter="url(#shadow)"')
    s.circle(bz_x, bz_y, 6, fill="#0a0a0a", stroke="#555", sw=1)
    s.text(bz_x - 10, bz_y - 9, "+", 12, "#fff", "middle", "bold", "Segoe UI")
    s.text(bz_x, bz_y + 38, "BUZZER 5V", 10.5, "#b3261e", "middle", "bold", "Segoe UI")

    # Header 8 pines del Teclado Matricial 4x4 en Board B (c = 44..58 paso 2)
    k_cols = [44 + i * 2 for i in range(8)]
    s.rect(hx(BX, 44) - 10, BY + 128, 14 * 20 + 20, 24, fill="#1a1a1a", rx=3)
    for idx, kc in enumerate(k_cols):
        xx = hx(BX, kc)
        s.rect(xx - 3, BY + 134, 6, 12, fill="#e4c15a")
        lbl = f"R{idx + 1}" if idx < 4 else f"C{idx - 3}"
        s.text(xx, BY + 120, lbl, 11, "#333", "middle", "bold", "Consolas")
        if idx >= 4:
            resistor(xx, BY + 12, xx, BY + 105, ("#a52a2a", "#000", "#ff8c00"))

    # Teclado Matricial 4x4 externo conectado abajo-derecha de Board B
    kpad_x, kpad_y, kpad_w, kpad_h = hx(BX, 43), BY + 215, 290, 275
    for idx, kc in enumerate(k_cols):
        x1 = hx(BX, kc)
        x2 = kpad_x + 75 + idx * 18
        wirep(f"M{x1} {BY + 148} C{x1} {BY + 185} {x2} {BY + 185} {x2} {kpad_y + 10}",
              "#ff9933" if idx < 4 else "#4da6ff")

    s.rect(kpad_x, kpad_y, kpad_w, kpad_h, fill="#1f2430", stroke="#394256", sw=2.5, rx=12,
           extra='filter="url(#shadow)"')
    s.text(kpad_x + kpad_w / 2, kpad_y + 24, "TECLADO MATRICIAL 4x4", 13, "#cfd8ea",
           "middle", "bold", "Segoe UI")
    k_labels = [["1", "2", "3", "A"], ["4", "5", "6", "B"], ["7", "8", "9", "C"], ["*", "0", "#", "D"]]
    for r in range(4):
        for c in range(4):
            bx = kpad_x + 25 + c * 62
            by = kpad_y + 38 + r * 56
            is_blue = k_labels[r][c] in ("A", "B", "C", "D")
            is_red = k_labels[r][c] in ("*", "#")
            kcol = "#2b4c7e" if is_blue else ("#7a2b2b" if is_red else "#323a4c")
            if k_labels[r][c] == "5":
                kcol = "#2a8f4d"
            s.rect(bx, by, 52, 46, fill=kcol, stroke="#55617a", sw=1.5, rx=6)
            s.text(bx + 26, by + 30, k_labels[r][c], 18, "#ffffff", "middle", "bold", "Segoe UI")

    # Cables PIC -> 9 LEDs (3 por elevador: V, A, R)
    for k in range(9):
        g = k // 3
        x1 = hx(AX, 12 + k)
        x2 = hx(BX, 2 + k * 2 + g * 2)
        wirep(f"M{x1} {AY + 235} C{x1} {AY + 390} {x2} {BY - 40} {x2} {BY + 110}",
              ["#22aa22", "#e0b000", "#dd2222"][k % 3])
    # Cables PIC -> 2 Botones de Pasillo (RA4, RA5) + Buzzer (RB5)
    for k in range(2):
        x1 = hx(AX, 11 + k)
        x2 = hx(BX, 28 + k * 5)
        wirep(f"M{x1} {AY + 235} C{x1} {AY + 360} {x2} {BY - 50} {x2} {BY + 150}", "#c060ff")
    wirep(f"M{hx(AX, 14)} {AY + 120} C{hx(AX, 14)} {AY + 30} {bz_x - 60} {BY - 40} {bz_x} {bz_y - 24}", "#ffcc00")
    # Cables PIC -> Teclado 4x4 (Filas RA0..RA3 y Cols RB0..RB3)
    for r in range(4):
        x1 = hx(AX, 7 + r)
        x2 = hx(BX, k_cols[r])
        wirep(f"M{x1} {AY + 235} C{x1} {AY + 380} {x2 - 50} {BY - 40} {x2} {BY + 128}", "#ff9933")
    for c in range(4):
        x1 = hx(AX, 19 - c)
        x2 = hx(BX, k_cols[4 + c])
        wirep(f"M{x1} {AY + 120} C{x1} {AY + 35} {x2 - 80} {BY - 70} {x2} {BY + 128}", "#ffffff")

    # --- PICkit 3 ---
    kx, ky = 70, 145
    s.rect(kx, ky, 130, 250, fill="#2b2d31", rx=22, extra='filter="url(#shadow)"')
    s.rect(kx + 12, ky + 14, 106, 60, fill="#3b3e44", rx=8)
    s.text(kx + 65, ky + 52, "PICkit 3", 20, "#fff", "middle", "bold", "Segoe UI")
    for i, (c, t) in enumerate((("#2f2", "Power"), ("#fa0", "Active"), ("#f33", "Status"))):
        s.circle(kx + 28, ky + 100 + i * 26, 6, fill=c, extra='filter="url(#glow)"')
        s.text(kx + 42, ky + 105 + i * 26, t, 12, "#ccc", "start", "normal", "Segoe UI")
    s.circle(kx + 65, ky + 195, 14, fill="#555", stroke="#777", sw=2)
    s.rect(kx + 35, ky + 238, 60, 22, fill="#111")
    s.poly([(kx + 40, ky + 242), (kx + 50, ky + 242), (kx + 45, ky + 250)], fill="#fff")
    s.path(f"M{kx + 65} {ky} C{kx + 65} {ky - 60} {kx - 40} {ky - 40} {kx - 60} {ky - 80}",
           stroke="#111", sw=8, extra='stroke-linecap="round"')
    s.text(kx + 65, ky - 20, "USB a PC (MPLAB X)", 13, "#fff", "start", "normal", "Segoe UI")
    icols = ["#ffffff", "#ff3333", "#111111", "#ffcc00", "#33aa33", "#3366ff"]
    for k, col in enumerate(icols):
        x1 = kx + 42 + k * 9
        x2 = hx(AX, k)
        wirep(f"M{x1} {ky + 260} C{x1} {ky + 330} {x2 - 120} {AY + 20} {x2} {AY + 70}", col)

    # --- Fuente 5V ---
    fx, fy = 60, 585
    s.rect(fx, fy, 200, 130, fill="#1f4e8c", rx=10, extra='filter="url(#shadow)"')
    s.text(fx + 100, fy + 40, "FUENTE", 18, "#fff", "middle", "bold", "Segoe UI")
    s.text(fx + 100, fy + 66, "+5V DC / 1A", 16, "#ffe066", "middle", "bold", "Segoe UI")
    s.circle(fx + 60, fy + 108, 10, fill="#d22")
    s.circle(fx + 140, fy + 108, 10, fill="#222", stroke="#888")
    wirep(f"M{fx + 60} {fy + 108} C{fx + 60} {fy + 190} {BX - 80} {BY + 120} {BX + 30} {BY + 22}", "#ff2222")
    wirep(f"M{fx + 140} {fy + 108} C{fx + 140} {fy + 200} {BX - 60} {BY + 140} {BX + 30} {BY + 60}", "#111111")
    wirep(f"M{BX + 10} {BY + 22} C{BX - 60} {BY - 100} {AX - 60} {AY + 390} {AX + 30} {AY + 312}", "#ff2222")
    wirep(f"M{BX + 10} {BY + 60} C{BX - 90} {BY - 60} {AX - 90} {AY + 410} {AX + 30} {AY + 350}", "#111111")

    # --- Modulo USB a TTL (CP2102 / CH340) para conectar con GUI Python en vivo ---
    tx, ty = 60, 765
    # Conector USB metalico a la izquierda
    s.rect(tx - 24, ty + 26, 26, 44, fill="#c4c9d1", stroke="#6c737d", sw=1.5, rx=2)
    s.rect(tx - 18, ty + 35, 10, 8, fill="#555")
    s.rect(tx - 18, ty + 53, 10, 8, fill="#555")
    # PCB roja/azul del modulo USB-TTL
    s.rect(tx, ty, 195, 96, fill="#a81c1c", stroke="#6e1111", sw=2, rx=8, extra='filter="url(#shadow)"')
    s.text(tx + 96, ty + 26, "MODULO USB-TTL", 14, "#fff", "middle", "bold", "Segoe UI")
    s.text(tx + 96, ty + 45, "CP2102 / CH340 (5V)", 11, "#ffe066", "middle", "bold", "Consolas")
    s.text(tx + 96, ty + 64, "USB 2 -> GUI Python", 10.5, "#ffd0d0", "middle", "normal", "Segoe UI")
    # 3 pines usados a la derecha: RX, TX, GND
    ttl_pins = [("RX", "#00bfff"), ("TX", "#33dd88"), ("GND", "#111111")]
    for i, (pnm, pcol) in enumerate(ttl_pins):
        py_t = ty + 22 + i * 26
        s.rect(tx + 195, py_t - 4, 14, 8, fill="#e4c15a")
        s.text(tx + 188, py_t + 4, pnm, 9.5, "#fff", "end", "bold", "Consolas")
    # Cables cruzados: RX->RC6 (TX PIC), TX->RC7 (RX PIC), GND->GND protoboard
    wirep(f"M{tx + 209} {ty + 22} C{tx + 300} {ty - 40} {hx(AX, 16) - 180} {AY + 460} {hx(AX, 17)} {AY + 122}", "#00bfff")
    wirep(f"M{tx + 209} {ty + 48} C{tx + 320} {ty - 20} {hx(AX, 17) - 160} {AY + 470} {hx(AX, 18)} {AY + 122}", "#33dd88")
    wirep(f"M{tx + 209} {ty + 74} C{tx + 280} {ty + 110} {BX - 60} {BY + 340} {BX + 30} {BY + 338}", "#111111")

    # --- Callouts ---
    callout(hx(AX, 15), AY + 178, 635, 495, "PIC18F4550|Oscilador interno 8 MHz|(sin cristal)", 220)
    callout(hx(AX, 3), AY + 75, 225, 455, "Header ICSP|1 MCLR  2 VDD  3 GND|4 PGD  5 PGC  6 NC", 250)
    callout(lx + lw / 2, ly + 100, 1420, 72, "Pantalla LCD 16x2 (2.26\")|Solo 6 pines (RD0..RD5) + POT 10k", 320)
    callout(hx(BX, 8), BY + 82, 415, 970, "3 LEDs por elevador (9 total)|V=Sube | A=Espera(parpadea) | R=Baja", 325)
    callout(hx(BX, 31), BY + 180, 755, 970, "2 Botones Pasillo + Buzzer 5V|SUB(RA4), BAJ(RA5) | BUZZ(RB5)", 320)
    callout(kpad_x + kpad_w, kpad_y + 135, 1580, 970, "Teclado 4x4|A:Piso B:Abr C:Cer|D:Borrar #:OK *:EMG", 205)
    callout(tx + 96, ty + 96, 60, 955, "Modulo USB-TTL (En vivo)|RX->RC6, TX->RC7, GND->GND", 265)

    s.save("protoboard_fisico_lcd.svg")


if __name__ == "__main__":
    proteus_lcd()
    protoboard_lcd()
