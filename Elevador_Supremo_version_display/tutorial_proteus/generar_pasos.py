# -*- coding: utf-8 -*-
"""
Genera 6 ilustraciones detalladas (zoom parte por parte) de como armar
Elevador Supremo (Version Display LCD 16x2) en Proteus 8 Professional.
"""
import os

HERE = os.path.dirname(os.path.abspath(__file__))

BG = "#dcd2b4"
WIRE = "#007a00"
BODY = "#dcb998"
STRK = "#8b0000"
PINBG = "#e6b5b5"
F = "Segoe UI, Arial, sans-serif"
M = "Consolas, monospace"


class P8SVG:
    def __init__(self, w, h, title, subtitle):
        self.w, self.h = w, h
        self.o = [
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}">',
            '<defs>'
            '<pattern id="g" width="20" height="20" patternUnits="userSpaceOnUse">'
            '<path d="M 20 0 L 0 0 0 20" fill="none" stroke="#cfc5a8" stroke-width="0.9"/></pattern>'
            '<filter id="glow"><feGaussianBlur stdDeviation="2.2" result="b"/>'
            '<feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>'
            '<filter id="sh"><feDropShadow dx="2" dy="3" stdDeviation="3" flood-opacity="0.25"/></filter>'
            '</defs>',
            f'<rect width="{w}" height="{h}" fill="{BG}"/>',
            f'<rect width="{w}" height="{h}" fill="url(#g)"/>',
            f'<rect x="0" y="0" width="{w}" height="64" fill="#1e3a5f"/>',
            f'<text x="24" y="30" font-family="{F}" font-size="22" font-weight="bold" fill="#fff">{title}</text>',
            f'<text x="24" y="52" font-family="{F}" font-size="13" fill="#c7dcff">{subtitle}</text>',
        ]

    def a(self, s):
        self.o.append(s)

    def rect(self, x, y, w, h, fill="none", stroke="none", sw=1, rx=0, ex=""):
        self.a(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}" {ex}/>')

    def line(self, x1, y1, x2, y2, c=WIRE, w=2.5, ex=""):
        self.a(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{c}" stroke-width="{w}" stroke-linecap="round" {ex}/>')

    def circle(self, x, y, r, fill="none", stroke="none", sw=1, ex=""):
        self.a(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}" {ex}/>')

    def poly(self, pts, fill="none", stroke="none", sw=1, ex=""):
        p = " ".join(f"{x},{y}" for x, y in pts)
        self.a(f'<polygon points="{p}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}" {ex}/>')

    def text(self, x, y, s, sz=13, c="#111", anchor="start", w="normal", fam=F, ex=""):
        self.a(f'<text x="{x}" y="{y}" font-family="{fam}" font-size="{sz}" fill="{c}" text-anchor="{anchor}" font-weight="{w}" {ex}>{s}</text>')

    def junc(self, x, y):
        self.circle(x, y, 4.5, fill=WIRE)

    def lbl(self, x, y, txt, anchor="start", c="#8b0000"):
        self.text(x, y - 6, txt, 13, c, anchor, "bold", M)

    def power(self, x, y, txt="POWER (+5V)"):
        self.line(x, y, x, y - 18)
        self.poly([(x - 9, y - 18), (x + 9, y - 18), (x, y - 31)], fill=WIRE, stroke=WIRE)
        self.text(x, y - 36, txt, 11.5, "#111", "middle", "bold")

    def gnd(self, x, y):
        self.line(x, y, x, y + 16)
        self.line(x - 14, y + 16, x + 14, y + 16, WIRE, 2.5)
        self.line(x - 9, y + 22, x + 9, y + 22, WIRE, 2.5)
        self.line(x - 4, y + 28, x + 4, y + 28, WIRE, 2.5)

    def res_h(self, x, y, ref, val, L=90):
        self.line(x, y, x + 22, y)
        self.rect(x + 22, y - 8, L - 44, 16, fill="#fff6c4", stroke=STRK, sw=2)
        self.line(x + L - 22, y, x + L, y)
        self.text(x + L / 2, y - 12, ref, 11.5, "#00008b", "middle", "bold")
        self.text(x + L / 2, y + 22, val, 11.5, "#222", "middle")

    def res_v(self, x, y, ref, val, L=78):
        self.line(x, y, x, y + 20)
        self.rect(x - 8, y + 20, 16, L - 40, fill="#fff6c4", stroke=STRK, sw=2)
        self.line(x, y + L - 20, x, y + L)
        self.text(x + 13, y + L / 2 - 2, ref, 11.5, "#00008b", "start", "bold")
        self.text(x + 13, y + L / 2 + 12, val, 11.5, "#222", "start")

    def led_h(self, x, y, col, lit, ref):
        self.line(x, y, x + 16, y)
        self.poly([(x + 16, y - 12), (x + 16, y + 12), (x + 38, y)],
                  fill=col if lit else "#fff6c4", stroke=STRK, sw=2,
                  ex='filter="url(#glow)"' if lit else "")
        self.line(x + 38, y - 12, x + 38, y + 12, STRK, 2.5)
        self.line(x + 38, y, x + 56, y)
        for dx in (0, 8):
            self.line(x + 24 + dx, y - 14, x + 34 + dx, y - 24, STRK, 1.6)
            self.poly([(x + 34 + dx, y - 24), (x + 28 + dx, y - 23), (x + 33 + dx, y - 18)], fill=STRK)
        self.text(x + 27, y + 26, ref, 11.5, "#00008b", "middle", "bold")

    def button_v(self, x, y, ref, txt, sub=""):
        self.line(x, y, x, y + 20)
        self.circle(x, y + 24, 4, fill="#fff", stroke=STRK, sw=2)
        self.circle(x, y + 52, 4, fill="#fff", stroke=STRK, sw=2)
        self.line(x, y + 56, x, y + 76)
        self.line(x - 13, y + 16, x - 13, y + 60, STRK, 2.5)
        self.line(x - 13, y + 38, x - 24, y + 38, STRK, 2.5)
        self.line(x - 24, y + 31, x - 24, y + 45, STRK, 2.5)
        self.text(x + 12, y + 32, ref, 11.5, "#00008b", "start", "bold")
        self.text(x + 12, y + 48, txt, 12, "#111", "start", "bold")
        if sub:
            self.text(x + 12, y + 62, sub, 10.5, "#555", "start")

    def note_box(self, x, y, w, h, title, lines, header_col="#2f6690"):
        self.rect(x, y, w, h, fill="#fffdf5", stroke="#7a6f54", sw=1.8, rx=6, ex='filter="url(#sh)"')
        self.rect(x, y, w, 28, fill=header_col, rx=4)
        self.text(x + 12, y + 19, title, 12.5, "#fff", "start", "bold")
        for i, l in enumerate(lines):
            self.text(x + 14, y + 50 + i * 22, l, 12, "#222", "start")

    def pic_pin(self, x, y, num, name, side="right"):
        if side == "right":
            self.rect(x, y - 10, 28, 20, fill=PINBG, stroke=STRK, sw=1.2)
            self.text(x + 14, y + 4, str(num), 10.5, "#111", "middle")
            self.text(x - 8, y + 4, name, 11, "#111", "end", "bold", M)
        else:
            self.rect(x - 28, y - 10, 28, 20, fill=PINBG, stroke=STRK, sw=1.2)
            self.text(x - 14, y + 4, str(num), 10.5, "#111", "middle")
            self.text(x + 8, y + 4, name, 11, "#111", "start", "bold", M)

    def save(self, name):
        self.o.append("</svg>")
        with open(os.path.join(HERE, name), "w", encoding="utf-8") as f:
            f.write("\n".join(self.o))
        print("OK ->", name)


# ---------------- PASO 1: PIC18F4550 + MCLR + CLOCK ----------------
def paso1():
    s = P8SVG(1100, 620, "PASO 1: Colocar PIC18F4550 (U1), Reset MCLR y Reloj 8 MHz",
              "Busca PIC18F4550 y RES (10k) con 'P' | Coloca POWER desde Modo Terminales")
    # Cuerpo parcial/completo limpio del PIC
    ux, uy, uw, uh = 250, 125, 290, 440
    s.text(ux, uy - 10, "U1", 15, "#111", "start", "bold")
    s.rect(ux, uy, uw, uh, fill=BODY, stroke=STRK, sw=2.5)
    s.text(ux + uw / 2, uy + uh + 24, "PIC18F4550", 14, "#111", "middle", "bold")

    # Pines relevantes destacados
    s.pic_pin(ux, uy + 55, 14, "RA6/OSC2/CLKO", "left")
    s.pic_pin(ux, uy + 85, 13, "OSC1/CLKI", "left")
    s.text(ux - 38, uy + 74, "Sin cristal (INTOSC 8 MHz)", 11, "#555", "end", "italic")

    s.pic_pin(ux, uy + 235, 39, "RB6/KBI2/PGC", "left")
    s.pic_pin(ux, uy + 268, 40, "RB7/KBI3/PGD", "left")
    s.rect(ux - 220, uy + 216, 180, 68, fill="#fff8d6", stroke="#c9a400", sw=1.5, rx=5)
    s.text(ux - 130, uy + 243, "LIBRES EN PROTEUS", 11.5, "#7a5200", "middle", "bold")
    s.text(ux - 130, uy + 263, "(Exclusivos PICkit 3)", 11, "#555", "middle")

    s.pic_pin(ux + uw, uy + 390, 1, "RE3/MCLR/VPP", "right")
    # Conexion R1 10k a POWER
    s.line(ux + uw + 28, uy + 390, ux + uw + 110, uy + 390)
    s.res_v(ux + uw + 110, uy + 312, "R1", "10k", 78)
    s.power(ux + uw + 110, uy + 312, "POWER (+5V)")

    # Ventana simulada "Edit Component" de Proteus 8
    wx, wy = 710, 115
    s.rect(wx, wy, 350, 260, fill="#f4f4f4", stroke="#666", sw=1.8, rx=5, ex='filter="url(#sh)"')
    s.rect(wx, wy, 350, 30, fill="#2f6690", rx=4)
    s.text(wx + 12, wy + 20, "Edit Component - U1 (Doble clic en U1)", 12, "#fff", "start", "bold")
    fields = [
        ("Part Reference:", "U1"),
        ("Part Value:", "PIC18F4550"),
        ("Program File:", "Elevador.X.production.hex"),
        ("Processor Clock:", "8MHz  (CAMBIAR AQUI!)"),
    ]
    for i, (k, v) in enumerate(fields):
        fy = wy + 58 + i * 44
        s.text(wx + 14, fy, k, 11.5, "#222", "start", "bold")
        s.rect(wx + 135, fy - 16, 200, 24, fill="#fff" if i < 3 else "#fff3b0",
               stroke="#b3261e" if i == 3 else "#aaa", sw=2 if i == 3 else 1)
        s.text(wx + 142, fy, v, 11, "#b3261e" if i == 3 else "#111", "start", "bold" if i == 3 else "normal", M)
    s.text(wx + 175, wy + 238, "[ Aceptar ]", 12, "#003380", "middle", "bold")

    s.note_box(710, 405, 350, 175, "Checklist del Paso 1", [
        "1. VDD y VSS del PIC18F4550 vienen ocultos",
        "   y conectados automaticamente en Proteus.",
        "2. Conecta Pin 1 (MCLR) -> R1 (10k) -> POWER.",
        "3. NO pongas cristal en pines 13 y 14.",
        "4. Doble clic en U1 y pon Clock = 8MHz.",
    ])
    s.save("paso1_pic_mclr.svg")


# ---------------- PASO 2: LCD 16x2 (LM016L) + POT-HG 10k ----------------
def paso2():
    s = P8SVG(1200, 680, "PASO 2: Pantalla LCD 16x2 (LM016L) y Potenciometro 10k Lineal (POT-HG)",
              "Modo 4 bits: solo 6 cables desde PORTD (RD0..RD5) | D0..D3 quedan desconectados")
    # Seccion derecha de U1 (RD0..RD5)
    ux, uy, uw, uh = 60, 140, 210, 290
    s.rect(ux, uy, uw, uh, fill=BODY, stroke=STRK, sw=2.2)
    s.text(ux + uw / 2, uy + 24, "U1 (PIC18F4550)", 13, "#111", "middle", "bold")
    s.text(ux + uw / 2, uy + 42, "Seccion PORTD", 11, "#555", "middle")

    rd_pins = [(19, "RD0/SPP0", "RS"), (20, "RD1/SPP1", "E"), (21, "RD2/SPP2", "D4"),
               (22, "RD3/SPP3", "D5"), (27, "RD4/SPP4", "D6"), (28, "RD5/SPP5", "D7")]
    rpos = {}
    for i, (num, nm, lnm) in enumerate(rd_pins):
        py = uy + 76 + i * 34
        rpos[lnm] = py
        s.pic_pin(ux + uw, py, num, nm, "right")

    # LM016L grande y detallado
    lx, ly, lw, lh = 480, 115, 650, 230
    s.text(lx, ly - 10, "LCD1  (Buscar: LM016L)", 14, "#003380", "start", "bold")
    s.rect(lx, ly, lw, lh, fill="#2e6b3e", stroke="#173820", sw=2.5, rx=6, ex='filter="url(#sh)"')
    s.rect(lx + 26, ly + 22, lw - 52, 138, fill="#1b1f1c", stroke="#444", sw=2, rx=4)
    s.rect(lx + 42, ly + 36, lw - 84, 110, fill="#9be04a", stroke="#4b751d", sw=2, rx=2)
    s.text(lx + 62, ly + 82,  "E1:03^ E2:12v E3:01", 31, "#162e08", "start", "bold", M)
    s.text(lx + 62, ly + 128, "Piso: 15   [#=OK]",   31, "#162e08", "start", "bold", M)

    lpins = [(1, "VSS"), (2, "VDD"), (3, "VEE"), (4, "RS"), (5, "RW"), (6, "E"),
             (7, "D0"), (8, "D1"), (9, "D2"), (10, "D3"), (11, "D4"), (12, "D5"), (13, "D6"), (14, "D7")]
    pxs = {}
    for i, (pnum, pnm) in enumerate(lpins):
        px = lx + 42 + i * 43.5
        pxs[pnm] = px
        s.text(px, ly + lh - 14, pnm, 10.5, "#fff", "middle", "bold")
        s.line(px, ly + lh, px, ly + lh + 26, STRK, 2.2)
        s.text(px - 5, ly + lh + 17, str(pnum), 9.5, "#333", "end")
        if pnm in ("D0", "D1", "D2", "D3"):
            s.text(px, ly + lh + 42, "N.C.", 9.5, "#b3261e", "middle", "bold")

    # Alimentacion fija del LCD
    s.line(pxs["VSS"], ly + lh + 26, pxs["VSS"], ly + lh + 150)
    s.gnd(pxs["VSS"], ly + lh + 150)

    s.line(pxs["VDD"], ly + lh + 26, pxs["VDD"], ly + lh + 68)
    s.line(pxs["VDD"], ly + lh + 68, pxs["VDD"] - 22, ly + lh + 68)
    s.power(pxs["VDD"] - 22, ly + lh + 68, "+5V")

    s.line(pxs["RW"], ly + lh + 26, pxs["RW"], ly + lh + 76)
    s.gnd(pxs["RW"], ly + lh + 76)

    # POT-HG 10k lineal conectado a VEE
    pot_x = pxs["VEE"] + 8
    pot_y = ly + lh + 110
    s.line(pot_x, pot_y - 26, pot_x, pot_y)
    s.power(pot_x, pot_y - 26, "+5V")
    s.rect(pot_x - 9, pot_y, 18, 62, fill="#fff6c4", stroke=STRK, sw=2)
    s.line(pot_x, pot_y + 62, pot_x, pot_y + 82)
    s.gnd(pot_x, pot_y + 82)
    s.line(pxs["VEE"], ly + lh + 26, pxs["VEE"], pot_y + 31)
    s.line(pxs["VEE"], pot_y + 31, pot_x - 9, pot_y + 31)
    s.poly([(pot_x - 9, pot_y + 31), (pot_x - 18, pot_y + 25), (pot_x - 18, pot_y + 37)], fill=STRK)
    s.text(pot_x + 18, pot_y + 24, "RV1: POT-HG", 11.5, "#00008b", "start", "bold")
    s.text(pot_x + 18, pot_y + 40, "10k Lineal", 11, "#222", "start")
    s.text(pot_x + 18, pot_y + 55, "(Contraste)", 10, "#555", "start", "italic")

    # 6 cables RD0..RD5 -> RS, E, D4..D7
    for i, lnm in enumerate(["RS", "E", "D4", "D5", "D6", "D7"]):
        py_u = rpos[lnm]
        px_l = pxs[lnm]
        xb = 340 + i * 20
        yb = 520 + i * 24
        s.line(ux + uw + 28, py_u, xb, py_u)
        s.lbl(ux + uw + 36, py_u, f"LCD_{lnm}", "start", "#004499")
        s.line(xb, py_u, xb, yb)
        s.line(xb, yb, px_l, yb)
        s.line(px_l, yb, px_l, ly + lh + 26)

    s.note_box(55, 480, 260, 170, "Resumen Paso 2", [
        "RD0 -> RS (4)  |  RD1 -> E (6)",
        "RD2 -> D4 (11) |  RD3 -> D5 (12)",
        "RD4 -> D6 (13) |  RD5 -> D7 (14)",
        "VSS(1) y RW(5) -> GROUND",
        "VDD(2) -> POWER | VEE(3) -> RV1",
    ])
    s.save("paso2_lcd_pot.svg")


# ---------------- PASO 3: TECLADO MATRICIAL 4x4 + PULL-UPS ----------------
def paso3():
    s = P8SVG(1150, 680, "PASO 3: Teclado Matricial 4x4 (KEYPAD-SMALLCALC) y 4 Pull-Ups 10k",
              "Filas A..D van directo a RA0..RA3 | Columnas 1..4 van a RB0..RB3 con 4 resistencias de 10k a POWER")
    # KEYPAD1 grande
    kx, ky, kw, kh = 140, 155, 220, 265
    s.text(kx, ky - 10, "KEYPAD1  (KEYPAD-SMALLCALC)", 13, "#003380", "start", "bold")
    s.rect(kx, ky, kw, kh, fill="#d9d9d9", stroke=STRK, sw=2.2, rx=4, ex='filter="url(#sh)"')
    krows = [["7", "8", "9", "/"], ["4", "5", "6", "*"], ["1", "2", "3", "-"], ["ON/C", "0", "=", "+"]]
    kalt =  [["1", "2", "3", "A"], ["4", "5", "6", "B"], ["7", "8", "9", "C"], ["*", "0", "#", "D"]]
    for r in range(4):
        for c in range(4):
            bx, by = kx + 14 + c * 50, ky + 16 + r * 60
            bc = "#b85c5c" if (r == 3 and c == 0) else ("#5c78b8" if c == 3 else "#b8b8b8")
            s.rect(bx, by, 42, 50, fill=bc, stroke="#555", sw=1.4, rx=3)
            s.text(bx + 21, by + 25, kalt[r][c], 15, "#fff" if bc != "#b8b8b8" else "#111", "middle", "bold")
            s.text(bx + 21, by + 42, f"({krows[r][c]})" if kalt[r][c] != krows[r][c] else "", 9, "#eee", "middle")

    # U1 lado izquierdo (RA0..RA3 y RB0..RB3)
    ux, uy, uw, uh = 620, 100, 230, 390
    s.rect(ux, uy, uw, uh, fill=BODY, stroke=STRK, sw=2.2)
    s.text(ux + uw / 2, uy + 24, "U1 (PIC18F4550)", 13, "#111", "middle", "bold")
    s.text(ux + uw / 2, uy + 42, "PORTA y PORTB", 11, "#555", "middle")
    ra = [(2, "RA0/AN0"), (3, "RA1/AN1"), (4, "RA2/AN2"), (5, "RA3/AN3")]
    rb = [(33, "RB0/INT0"), (34, "RB1/INT1"), (35, "RB2/INT2"), (36, "RB3/AN9")]
    ra_y, rb_y = [], []
    for i, (num, nm) in enumerate(ra):
        py = uy + 72 + i * 32
        ra_y.append(py)
        s.pic_pin(ux, py, num, nm, "left")
    for i, (num, nm) in enumerate(rb):
        py = uy + 235 + i * 32
        rb_y.append(py)
        s.pic_pin(ux, py, num, nm, "left")

    # Filas A..D -> RA0..RA3 rodeando por arriba
    for r in range(4):
        py_k = ky + 41 + r * 60
        s.line(kx - 22, py_k, kx, py_k, STRK, 2.2)
        s.text(kx + 4, py_k + 4, chr(65 + r), 10, "#333", "start", "bold")
        xl = kx - 35 - r * 18
        yt = 100 + r * 16
        s.line(kx - 22, py_k, xl, py_k)
        s.line(xl, py_k, xl, yt)
        s.line(xl, yt, 505 - r * 16, yt)
        s.line(505 - r * 16, yt, 505 - r * 16, ra_y[r])
        s.line(505 - r * 16, ra_y[r], ux - 28, ra_y[r])
        s.lbl(ux - 95, ra_y[r], f"FILA{r + 1}", "start", "#8b0000")

    # Columnas 1..4 -> RB0..RB3 + Pull-ups 10k correctamente conectados (arriba a cada COL, abajo unidos a POWER +5V)
    y_res = 530
    y_pu = y_res + 78
    for c in range(4):
        cx = kx + 35 + c * 50
        s.line(cx, ky + kh, cx, ky + kh + 22, STRK, 2.2)
        s.text(cx, ky + kh - 4, str(c + 1), 10, "#333", "middle", "bold")
        yb = ky + kh + 88 - c * 16
        s.line(cx, ky + kh + 22, cx, yb)
        xt = 445 + c * 24
        s.line(cx, yb, xt, yb)
        s.junc(cx, yb)
        # Extremo superior de R -> columna; extremo inferior de R -> riel comun POWER (+5V)
        s.line(cx, yb, cx, y_res)
        s.res_v(cx, y_res, f"R{c + 2}", "10k", 78)
        if c == 0:
            s.line(cx, y_pu, cx + 3 * 50 + 55, y_pu)
        else:
            s.junc(cx, y_pu)
        # Sube a RB0..RB3
        s.line(xt, yb, xt, rb_y[c])
        s.line(xt, rb_y[c], ux - 28, rb_y[c])
        s.lbl(ux - 88, rb_y[c], f"COL{c + 1}", "start", "#006600")
    s.power(kx + 35 + 3 * 50 + 55, y_pu, "POWER (+5V)")

    s.note_box(880, 120, 245, 290, "Resumen Paso 3", [
        "Filas (Salidas PIC):",
        "  A -> RA0 | B -> RA1",
        "  C -> RA2 | D -> RA3",
        "Columnas (Entradas PIC):",
        "  1 -> RB0 | 2 -> RB1",
        "  3 -> RB2 | 4 -> RB3",
        "4 R de 10k a POWER en cols.",
        "A:Piso B:Abr C:Cer D:Borrar",
        "#:Confirmar  *:Emergencia",
    ])
    s.save("paso3_teclado.svg")


# ---------------- PASO 4: 9 LEDS (3 POR ELEVADOR: VERDE, AMARILLO ESPERA, ROJO) ----------------
def paso4():
    s = P8SVG(1150, 790, "PASO 4: Los 9 LEDs (3 por Elevador: Verde=Sube, Amarillo=Espera/Parpadea, Rojo=Baja)",
              "Busca LED-GREEN (x3), LED-YELLOW (x3), LED-RED (x3) y RES de 220 Ohm (x9) | Todos los catodos van a GROUND")
    ux, uy, uw, uh = 60, 95, 225, 610
    s.rect(ux, uy, uw, uh, fill=BODY, stroke=STRK, sw=2.2)
    s.text(ux + uw / 2, uy + 24, "U1 (PIC18F4550)", 13, "#111", "middle", "bold")
    s.text(ux + uw / 2, uy + 42, "PORTC, PORTD, PORTB, PORTE", 10.5, "#555", "middle")

    pins = [
        (15, "RC0", "E1_SUBE"),
        (29, "RD6", "E1_PUERTA"),
        (16, "RC1", "E1_BAJA"),
        (17, "RC2", "E2_SUBE"),
        (30, "RD7", "E2_PUERTA"),
        (8,  "RE0", "E2_BAJA"),
        (9,  "RE1", "E3_SUBE"),
        (37, "RB4", "E3_PUERTA"),
        (10, "RE2", "E3_BAJA"),
    ]
    leds = [
        ("#1fe01f", True,  "D1", "E1 SUBE (LED-GREEN)"),
        ("#ffd000", False, "D2", "E1 ESPERA / PARPADEA (LED-YELLOW)"),
        ("#ff2626", False, "D3", "E1 BAJA (LED-RED)"),
        ("#1fe01f", False, "D4", "E2 SUBE (LED-GREEN)"),
        ("#ffd000", True,  "D5", "E2 ESPERA / PARPADEA (LED-YELLOW)"),
        ("#ff2626", False, "D6", "E2 BAJA (LED-RED)"),
        ("#1fe01f", False, "D7", "E3 SUBE (LED-GREEN)"),
        ("#ffd000", False, "D8", "E3 ESPERA / PARPADEA (LED-YELLOW)"),
        ("#ff2626", True,  "D9", "E3 BAJA (LED-RED)"),
    ]
    xgnd = 735
    for i, ((pnum, pnm, net), (col, lit, dref, desc)) in enumerate(zip(pins, leds)):
        py = uy + 72 + i * 58
        s.pic_pin(ux + uw, py, pnum, pnm, "right")
        s.line(ux + uw + 28, py, 460, py)
        lbl_col = "#b58900" if "PUERTA" in net else ("#8b0000" if i >= 5 else "#111")
        s.lbl(340, py, net, "start", lbl_col)
        s.res_h(460, py, f"R{i + 6}", "220", 90)
        s.led_h(550, py, col, lit, dref)
        s.line(606, py, xgnd, py)
        if i < 8:
            s.junc(xgnd, py)
        s.text(xgnd + 18, py + 5, desc, 12.5, "#111", "start", "bold")
    s.line(xgnd, uy + 72, xgnd, uy + 72 + 8 * 58)
    s.gnd(xgnd, uy + 72 + 8 * 58)

    s.note_box(760, 668, 365, 102, "Tip en Proteus (9 LEDs)", [
        "Verde = Sube | Amarillo = Espera (parpadea)",
        "Rojo = Baja | Usa etiquetas DEFAULT en RD6,",
        "RD7, RB4 y RE0..RE2 para no cruzar cables.",
    ])
    s.save("paso4_leds.svg")


# ---------------- PASO 5: SOLO 2 BOTONES DE PASILLO + BUZZER 5V ----------------
def paso5():
    s = P8SVG(1200, 620, "PASO 5: Solo 2 Botones de Pasillo (SUBIR / BAJAR) + Buzzer 5 V",
              "Puertas (B/C), Borrar (D) y Emergencia (*) van en el Teclado 4x4 | El BUZZER debe cambiarse a 5V")
    # Solo 2 botones fisicos de pasillo
    btns = [
        ("BTN1", "BTN_SUBIR", "SUBIR (Pasillo)", "Pin 6 (RA4)"),
        ("BTN2", "BTN_BAJAR", "BAJAR (Pasillo)", "Pin 7 (RA5)"),
    ]
    ry = 155
    s.line(150, ry, 420, ry)
    s.power(150, ry, "POWER (+5V)")
    for i, (ref, net, txt, sub) in enumerate(btns):
        bx = 150 + i * 270
        if i > 0:
            s.junc(bx, ry)
        s.res_v(bx, ry, f"R{15 + i}", "10k", 78)
        ny = ry + 78
        s.junc(bx, ny)
        s.line(bx, ny, bx + 95, ny)
        s.lbl(bx + 10, ny, net, "start", "#8b008b")
        s.button_v(bx, ny, ref, txt, sub)
        s.gnd(bx, ny + 76)

    # Bloque Buzzer 5V a la derecha
    bzx, bzy = 875, 240
    s.rect(745, 115, 395, 260, fill="#fff8f8", stroke="#b3261e", sw=2, rx=6, ex='stroke-dasharray="7 5"')
    s.rect(745, 115, 395, 28, fill="#b3261e", rx=4)
    s.text(762, 134, "ALARMA SONORA (BUZZER ACTIVE 5V — RB5)", 11.5, "#fff", "start", "bold")
    s.line(775, bzy - 14, bzx - 10, bzy - 14)
    s.lbl(775, bzy - 14, "BUZZER", "start", "#b3261e")
    s.line(810, bzy + 14, bzx - 10, bzy + 14)
    s.line(810, bzy + 14, 810, bzy + 66)
    s.gnd(810, bzy + 66)
    s.a(f'<path d="M {bzx + 14} {bzy - 26} A 26 26 0 0 0 {bzx + 14} {bzy + 26} Z" fill="#cfc9ad" stroke="{STRK}" stroke-width="2.5"/>')
    s.text(bzx + 28, bzy - 10, "LS1 (BUZZER)", 12.5, "#00008b", "start", "bold")
    s.text(bzx + 28, bzy + 8,  "Libreria: ACTIVE", 11, "#111", "start", "bold")
    s.text(bzx + 28, bzy + 26, "Doble clic ->", 11, "#333", "start")
    s.text(bzx + 28, bzy + 44, "Cambiar 12V -> 5V", 11.5, "#b3261e", "start", "bold")

    s.note_box(55, 425, 1085, 165, "Botones fisicos vs. Teclado 4x4 (Version Definitiva)", [
        "• Solo hay 2 botones fisicos: BTN1 (SUBIR - RA4) y BTN2 (BAJAR - RA5), con pull-up 10k a POWER y boton a GROUND.",
        "• Ningun elevador se despacha hasta presionar SUBIR o BAJAR (despues de ingresar tu piso con 'A' + '#' en el teclado).",
        "• Abrir puerta ('B'), Cerrar ('C'), Borrar ('D') y Paro de Emergencia ('*') se controlan desde el Teclado 4x4.",
        "• Al activar Emergencia ('*'), se congelan los 3 elevadores, parpadean los 3 LEDs rojos y suena el BUZZER 5V (RB5).",
    ])
    s.save("paso5_botones_buzzer.svg")


# ---------------- PASO 6: COMPIM (UART -> PYTHON GUI) ----------------
def paso6():
    s = P8SVG(1150, 620, "PASO 6: Puerto Serial COMPIM (Enlace en vivo con Python)",
              "Conecta SOLO 2 pines (Pin 3 TXD y Pin 2 RXD) del COMPIM | En fisico esto se reemplaza por el Modulo USB-TTL")
    # U1 pines RC6/RC7
    ux, uy, uw, uh = 70, 145, 225, 210
    s.rect(ux, uy, uw, uh, fill=BODY, stroke=STRK, sw=2.2)
    s.text(ux + uw / 2, uy + 26, "U1 (PIC18F4550)", 13, "#111", "middle", "bold")
    s.text(ux + uw / 2, uy + 44, "Modulo EUSART", 11, "#555", "middle")
    py_tx, py_rx = uy + 95, uy + 145
    s.pic_pin(ux + uw, py_tx, 25, "RC6/TX/CK", "right")
    s.pic_pin(ux + uw, py_rx, 26, "RC7/RX/DT", "right")

    # Simbolo DB9 realista de COMPIM en Proteus 8
    cx, cy, cw, ch = 505, 115, 175, 285
    s.text(cx + cw / 2, cy - 10, "P1 (COMPIM)", 14, "#003380", "middle", "bold")
    s.rect(cx, cy, cw, ch, fill="#f3eedc", stroke=STRK, sw=2.5)
    cpins = [(1, "DCD"), (6, "DSR"), (2, "RXD"), (7, "RTS"), (3, "TXD"), (8, "CTS"), (4, "DTR"), (9, "RI")]
    cpos = {}
    for i, (num, nm) in enumerate(cpins):
        py = cy + 28 + i * 28
        cpos[nm] = py
        s.line(cx - 32, py, cx, py, STRK, 2.2)
        s.text(cx - 18, py - 5, str(num), 11, "#111", "middle", "bold")
        s.text(cx + 8, py + 4, nm, 11.5, "#003380" if nm in ("TXD", "RXD") else "#666",
               "start", "bold" if nm in ("TXD", "RXD") else "normal", M)
        if nm not in ("TXD", "RXD"):
            s.text(cx - 42, py + 4, "N.C.", 9.5, "#999", "end")
    # Dibujo decorativo DB9 derecha + ERROR
    s.rect(cx + 95, cy + 25, 58, 195, fill="none", stroke=STRK, sw=2, rx=14)
    for k in range(5):
        s.circle(cx + 135, cy + 46 + k * 36, 7, stroke=STRK, sw=1.8)
    for k in range(4):
        s.circle(cx + 112, cy + 64 + k * 36, 7, stroke=STRK, sw=1.8)
    s.rect(cx + 14, cy + 245, 18, 18, fill="#fff", stroke=STRK, sw=1.8)
    s.rect(cx + 142, cy + 245, 18, 18, fill="#fff", stroke=STRK, sw=1.8)
    s.text(cx + 87, cy + 260, "ERROR", 13, STRK, "middle", "bold")

    # Conexion directa: RC6/TX -> Pin 3 TXD | RC7/RX -> Pin 2 RXD
    s.line(ux + uw + 28, py_tx, 395, py_tx)
    s.line(395, py_tx, 395, cpos["TXD"])
    s.line(395, cpos["TXD"], cx - 32, cpos["TXD"])
    s.lbl(330, py_tx, "UART_TX -> Pin 3 (TXD)", "start", "#0055aa")

    s.line(ux + uw + 28, py_rx, 375, py_rx)
    s.line(375, py_rx, 375, cpos["RXD"])
    s.line(375, cpos["RXD"], cx - 32, cpos["RXD"])
    s.lbl(330, py_rx + 20, "UART_RX -> Pin 2 (RXD)", "start", "#007a00")

    # Ventana de propiedades COMPIM
    wx, wy = 735, 115
    s.rect(wx, wy, 380, 270, fill="#f4f4f4", stroke="#666", sw=1.8, rx=5, ex='filter="url(#sh)"')
    s.rect(wx, wy, 380, 30, fill="#2f6690", rx=4)
    s.text(wx + 12, wy + 20, "Edit Component - COMPIM (Doble clic)", 12, "#fff", "start", "bold")
    flds = [
        ("Physical Port:", "COM1  (par com0com)"),
        ("Physical Baud Rate:", "9600"),
        ("Physical Data Bits:", "8  | Parity: None | Stop: 1"),
        ("Virtual Baud Rate:", "9600"),
        ("Virtual Data Bits:", "8  | Parity: None | Stop: 1"),
    ]
    for i, (k, v) in enumerate(flds):
        fy = wy + 60 + i * 40
        s.text(wx + 12, fy, k, 11, "#222", "start", "bold")
        s.rect(wx + 150, fy - 15, 216, 22, fill="#fff3b0" if i in (0, 1, 3) else "#fff",
               stroke="#b3261e" if i in (0, 1, 3) else "#aaa", sw=1.5)
        s.text(wx + 156, fy, v, 10.5, "#111", "start", "bold" if i in (0, 1, 3) else "normal", M)

    s.note_box(70, 435, 1045, 155, "Atencion: Diferencia entre Proteus (COMPIM) y Protoboard Fisico (USB-TTL)", [
        "• En PROTEUS (COMPIM): los pines van DIRECTOS -> RC6/TX (Pin 25) con Pin 3 TXD, y RC7/RX (Pin 26) con Pin 2 RXD.",
        "• En FISICO (Modulo USB-TTL CP2102/CH340): los pines van CRUZADOS -> RC6/TX con RX del modulo, RC7/RX con TX del modulo, y GND con GND.",
        "• Con com0com creas el par COM1 y COM2: Proteus usa COM1 y tu programa de Python (simulador_elevador.py) abre COM2 a 9600 baudios.",
    ], header_col="#0055aa")
    s.save("paso6_compim_uart.svg")


if __name__ == "__main__":
    paso1()
    paso2()
    paso3()
    paso4()
    paso5()
    paso6()
