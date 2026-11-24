# -*- coding: utf-8 -*-
"""
ELEVADOR SUPREMO (Version Display LCD 16x2)
Simulador interactivo en Python (Tkinter) del funcionamiento fisico:
  - Pantalla LCD 16x2 (LM016L) + potenciometro 10k lineal de contraste
  - 9 LEDs fisicos (3 por elevador: Verde=Sube, Amarillo=Puerta abierta, Rojo=Baja)
  - 2 Botones fisicos de pasillo: SUBIR (RA4) y BAJAR (RA5)
  - Buzzer 5V (RB5) con sonido real en Windows (winsound)
  - Teclado Matricial 4x4:
      * A = Modo "Seleccion de piso" (piso donde esta el usuario) -> # confirma
      * SUBIR / BAJAR = Despacha el elevador libre mas cercano al usuario
      * Al llegar y abrir puerta (LED Amarillo ON), NO cierra hasta teclear el piso destino + # (SIN presionar A)
      * Multi-usuario: puedes presionar A en cualquier momento para simular otro usuario mientras un elevador esta en uso
      * B = Abrir puerta | C = Cerrar puerta | D = Borrar piso ingresado | * = Paro de Emergencia

Ejecutar:
    python simulador_elevador.py
"""
import tkinter as tk
from tkinter import ttk, messagebox
import threading
import time

try:
    import winsound
    HAS_SOUND = True
except ImportError:
    HAS_SOUND = False

try:
    import serial
    import serial.tools.list_ports
    HAS_SERIAL = True
except ImportError:
    HAS_SERIAL = False


def beep_async(freq: int, dur_ms: int):
    if not HAS_SOUND:
        return
    threading.Thread(target=lambda: winsound.Beep(freq, dur_ms), daemon=True).start()


class Elevator:
    def __init__(self, idx: int, start_floor: int = 1):
        self.idx = idx            # 1, 2, 3
        self.floor = start_floor
        self.pos = float(start_floor)
        self.target = None        # proximo piso objetivo inmediato
        self.pickup_stops = {}    # {piso: set("UP"/"DOWN")} llamadas de pasillo asignadas
        self.dest_stops = set()   # pisos destino ingresados desde cabina
        self.state = "IDLE"       # IDLE, MOVING, WAIT_DEST, ARRIVED_OPEN, EMERGENCY
        self.prev_state = "IDLE"  # para reanudar tras emergencia
        self.move_dir = ""        # "UP", "DOWN", ""
        self.door_timer = 0       # solo usado en ARRIVED_OPEN (en WAIT_DEST no cierra sola hasta >=1 destino)
        self.boarding_timer = 0   # ventana para que varios usuarios ingresen destinos (0 = espera indefinida)
        self.boarding_count = 0   # cuantos destinos se han encolado en esta parada actual
        self.door_open_pct = 0.0  # 0.0 cerrada -> 1.0 abierta

    @property
    def is_free(self) -> bool:
        return self.state == "IDLE" and not self.pickup_stops and not self.dest_stops

    @property
    def all_stops(self) -> set:
        return set(self.pickup_stops.keys()) | self.dest_stops

    @property
    def has_stops(self) -> bool:
        return bool(self.pickup_stops or self.dest_stops)

    @property
    def direction_char(self) -> str:
        if self.state == "EMERGENCY":
            return "!"
        if self.state == "MOVING":
            return "^" if self.move_dir == "UP" else ("v" if self.move_dir == "DOWN" else " ")
        if self.state in ("WAIT_DEST", "ARRIVED_OPEN"):
            return "O"
        return " "

    @property
    def green_on(self) -> bool:
        return self.state == "MOVING" and self.move_dir == "UP"

    @property
    def yellow_on(self) -> bool:
        return self.state in ("WAIT_DEST", "ARRIVED_OPEN")

    @property
    def red_on(self) -> bool:
        return self.state == "MOVING" and self.move_dir == "DOWN"


class ElevadorSupremoApp:
    def __init__(self, root: tk.Tk):
        self.root = root
        self.root.title("Elevador Supremo — Simulación Física Multi-Usuario (PIC18F4550 + LCD 16x2)")
        self.root.geometry("1320x780")
        self.root.minsize(1200, 720)
        self.root.configure(bg="#111622")

        self.num_floors = tk.IntVar(value=12)
        self.contrast_val = tk.DoubleVar(value=85.0)
        self.sound_enabled = tk.BooleanVar(value=True)
        self.mode_var = tk.StringVar(value="SIMULACION")

        self.elevators = [Elevator(1, 1), Elevator(2, 6), Elevator(3, 12)]
        self.active_elev_idx = 0

        # Maquina de estados de entrada del usuario:
        #   "IDLE"          -> si hay elevador en WAIT_DEST, digitos + # envian destino directo (sin pulsar A)
        #   "HALL_FLOOR"    -> usuario pulso 'A' para ingresar en que piso esta (espera digitos + '#')
        #   "WAIT_HALL_BTN" -> usuario confirmo su piso con '#' y ahora DEBE pulsar SUBIR o BAJAR
        self.input_mode = "IDLE"
        self.keypad_buffer = ""
        self.pending_user_floor = None
        self.waiting_dest_queue = []  # indices de elevadores con puerta abierta esperando destino

        self.emergency = False
        self.emg_blink = False
        self.blink_tick = 0
        self.wait_blink = True
        self.buzzer_active = False
        self.last_status_msg = "Presiona A: Piso"

        self._build_ui()
        self._log("Sistema listo (12 pisos, 3 elevadores).")
        self._log("Flujo: 1) Pulsa 'A' -> teclea TU piso + '#'  2) Pulsa SUBIR o BAJAR  3) Al abrir puerta, teclea piso destino + '#' (sin 'A').")
        self._log("Multi-usuario: puedes pulsar 'A' en cualquier momento mientras otro elevador está en viaje.")
        self._update_lcd_and_leds()
        self._draw_building()
        self._tick_loop()

    # ==================== CONSTRUCCION DE INTERFAZ ====================
    def _build_ui(self):
        top = tk.Frame(self.root, bg="#192236", height=54)
        top.pack(fill="x", side="top")
        top.pack_propagate(False)

        tk.Label(top, text="▲▼ ELEVADOR SUPREMO", font=("Segoe UI", 15, "bold"),
                 fg="#ffffff", bg="#192236").pack(side="left", padx=16)
        tk.Label(top, text="Simulador Físico Multi-Usuario (PIC18F4550 + LCD 16x2)", font=("Segoe UI", 10),
                 fg="#8fa3c7", bg="#192236").pack(side="left", padx=4)

        ctrl = tk.Frame(top, bg="#192236")
        ctrl.pack(side="right", padx=14)

        tk.Label(ctrl, text="Pisos (N):", fg="#c8d3ea", bg="#192236",
                 font=("Segoe UI", 10)).pack(side="left", padx=(0, 4))
        sp = tk.Spinbox(ctrl, from_=4, to=20, width=3, textvariable=self.num_floors,
                        command=self._on_floors_change, font=("Segoe UI", 10, "bold"),
                        bg="#0d1322", fg="#fff", buttonbackground="#2b3a5c", relief="flat")
        sp.pack(side="left", padx=(0, 12))

        tk.Checkbutton(ctrl, text="Sonido Buzzer", variable=self.sound_enabled,
                       fg="#c8d3ea", bg="#192236", selectcolor="#0d1322",
                       activebackground="#192236", activeforeground="#fff",
                       font=("Segoe UI", 9)).pack(side="left", padx=(0, 12))

        tk.Label(ctrl, text="Modo:", fg="#c8d3ea", bg="#192236",
                 font=("Segoe UI", 10)).pack(side="left", padx=(0, 4))
        mode_cb = ttk.Combobox(ctrl, textvariable=self.mode_var, state="readonly", width=15,
                               values=["SIMULACION", "SERIAL UART (COM)"])
        mode_cb.pack(side="left", padx=(0, 6))
        mode_cb.bind("<<ComboboxSelected>>", self._on_mode_change)

        tk.Button(ctrl, text="⟲ Reiniciar", command=self._reset_system,
                  bg="#334569", fg="#fff", relief="flat",
                  font=("Segoe UI", 9, "bold"), padx=10, pady=4, cursor="hand2").pack(side="left", padx=(4, 0))

        main = tk.Frame(self.root, bg="#111622")
        main.pack(fill="both", expand=True, padx=12, pady=10)

        # ---------------- PANEL IZQUIERDO: HARDWARE FISICO ----------------
        hw = tk.Frame(main, bg="#182032", bd=1, relief="solid", highlightbackground="#2b3a5c", highlightthickness=1)
        hw.pack(side="left", fill="y", padx=(0, 10))
        hw.configure(width=540)
        hw.pack_propagate(False)

        tk.Label(hw, text="PROTOBOARD FÍSICO (PIC18F4550)", font=("Segoe UI", 11, "bold"),
                 fg="#9ec1ff", bg="#182032").pack(anchor="w", padx=14, pady=(10, 4))

        # 1) PANTALLA LCD 16x2 (LM016L)
        lcd_outer = tk.Frame(hw, bg="#1f6f3d", padx=12, pady=10, highlightbackground="#0e3b1f", highlightthickness=2)
        lcd_outer.pack(fill="x", padx=14, pady=(2, 6))

        lcd_hdr = tk.Frame(lcd_outer, bg="#1f6f3d")
        lcd_hdr.pack(fill="x")
        tk.Label(lcd_hdr, text="LM016L — LCD 16x2 (RD0..RD5)", font=("Consolas", 9, "bold"),
                 fg="#d4f7dc", bg="#1f6f3d").pack(side="left")
        self.lbl_pot_pct = tk.Label(lcd_hdr, text="POT 10k: 85%", font=("Consolas", 9),
                                    fg="#d4f7dc", bg="#1f6f3d")
        self.lbl_pot_pct.pack(side="right")

        lcd_bezel = tk.Frame(lcd_outer, bg="#181c19", padx=8, pady=8)
        lcd_bezel.pack(fill="x", pady=(4, 2))
        self.lcd_screen = tk.Frame(lcd_bezel, bg="#9be04a", padx=10, pady=8)
        self.lcd_screen.pack(fill="x")

        self.lcd_line1 = tk.Label(self.lcd_screen, text="1:01  2:06  3:12",
                                  font=("Consolas", 19, "bold"), fg="#152b07", bg="#9be04a", anchor="w")
        self.lcd_line1.pack(fill="x")
        self.lcd_line2 = tk.Label(self.lcd_screen, text="Presiona A: Piso",
                                  font=("Consolas", 19, "bold"), fg="#152b07", bg="#9be04a", anchor="w")
        self.lcd_line2.pack(fill="x")

        # Control del potenciometro 10k lineal de contraste
        pot_row = tk.Frame(hw, bg="#182032")
        pot_row.pack(fill="x", padx=14, pady=(0, 8))
        tk.Label(pot_row, text="Potenciómetro 10k lineal (Contraste VEE):", font=("Segoe UI", 9),
                 fg="#a8bad9", bg="#182032").pack(side="left")
        tk.Scale(pot_row, from_=0, to=100, orient="horizontal", variable=self.contrast_val,
                 command=lambda _v: self._update_lcd_contrast(),
                 bg="#182032", fg="#fff", troughcolor="#0d1322", highlightthickness=0,
                 showvalue=False, length=160).pack(side="right")

        # 2) 9 LEDs FISICOS + BUZZER 5V
        led_frame = tk.Frame(hw, bg="#0f1626", padx=10, pady=8, highlightbackground="#2b3a5c", highlightthickness=1)
        led_frame.pack(fill="x", padx=14, pady=(0, 8))

        tk.Label(led_frame, text="9 LEDs (Verde=Sube, Amarillo=Espera/Parpadea, Rojo=Baja) + BUZZER 5V (RB5)",
                 font=("Segoe UI", 8, "bold"), fg="#8fa3c7", bg="#0f1626").pack(anchor="w", pady=(0, 6))

        self.led_canvas = tk.Canvas(led_frame, height=64, bg="#0f1626", highlightthickness=0)
        self.led_canvas.pack(fill="x")

        # 3) SOLO 2 BOTONES FISICOS DE PASILLO (SUBIR / BAJAR)
        btn_frame = tk.Frame(hw, bg="#0f1626", padx=10, pady=8, highlightbackground="#2b3a5c", highlightthickness=1)
        btn_frame.pack(fill="x", padx=14, pady=(0, 8))

        tk.Label(btn_frame, text="BOTONES FÍSICOS DE PASILLO (RA4 / RA5) — Llaman al elevador más cercano",
                 font=("Segoe UI", 8, "bold"), fg="#8fa3c7", bg="#0f1626").pack(anchor="w", pady=(0, 6))

        row_b1 = tk.Frame(btn_frame, bg="#0f1626")
        row_b1.pack(fill="x")

        self.btn_subir = tk.Button(row_b1, text="▲ SUBIR  (RA4)", command=lambda: self._press_hall("SUBIR"),
                                   bg="#1f6f43", fg="#fff", font=("Segoe UI", 10, "bold"),
                                   relief="flat", pady=7, cursor="hand2")
        self.btn_subir.pack(side="left", padx=(0, 8), expand=True, fill="x")

        self.btn_bajar = tk.Button(row_b1, text="▼ BAJAR  (RA5)", command=lambda: self._press_hall("BAJAR"),
                                   bg="#9e2a2b", fg="#fff", font=("Segoe UI", 10, "bold"),
                                   relief="flat", pady=7, cursor="hand2")
        self.btn_bajar.pack(side="left", expand=True, fill="x")

        # 4) TECLADO MATRICIAL 4x4
        kp_frame = tk.Frame(hw, bg="#0f1626", padx=10, pady=8, highlightbackground="#2b3a5c", highlightthickness=1)
        kp_frame.pack(fill="both", expand=True, padx=14, pady=(0, 12))

        tk.Label(kp_frame, text="TECLADO 4x4 — A: Sel.Piso | #: OK | B: Abrir | C: Cerrar | D: Borrar | *: Emerg.",
                 font=("Segoe UI", 8, "bold"), fg="#8fa3c7", bg="#0f1626").pack(anchor="w", pady=(0, 6))

        kp_grid = tk.Frame(kp_frame, bg="#0f1626")
        kp_grid.pack(expand=True)
        keys = [
            ["1", "2", "3", "A"],
            ["4", "5", "6", "B"],
            ["7", "8", "9", "C"],
            ["*", "0", "#", "D"],
        ]
        hints = {"A": "A\nSel.Piso", "B": "B\nAbrir", "C": "C\nCerrar", "D": "D\nBorrar", "*": "*\nEMERG.", "#": "#\nOK"}
        for r in range(4):
            for c in range(4):
                k = keys[r][c]
                bg = "#2b4c7e" if k in "ABC" else ("#b5651d" if k == "D" else ("#c91818" if k == "*" else ("#1f7a43" if k == "#" else "#273147")))
                tk.Button(kp_grid, text=hints.get(k, k), width=9, height=2,
                          command=lambda key=k: self._press_key(key),
                          bg=bg, fg="#ffffff", activebackground="#3d7bff", activeforeground="#fff",
                          font=("Segoe UI", 9, "bold"), relief="flat", cursor="hand2").grid(row=r, column=c, padx=5, pady=4)

        # ---------------- PANEL DERECHO: EDIFICIO ANIMADO + MONITOR ----------------
        right = tk.Frame(main, bg="#182032", highlightbackground="#2b3a5c", highlightthickness=1)
        right.pack(side="left", fill="both", expand=True)

        tk.Label(right, text="SIMULACIÓN EN VIVO DEL EDIFICIO (3 ELEVADORES, N PISOS)",
                 font=("Segoe UI", 11, "bold"), fg="#9ec1ff", bg="#182032").pack(anchor="w", padx=14, pady=(10, 4))

        self.bld_canvas = tk.Canvas(right, bg="#0f1420", highlightthickness=0)
        self.bld_canvas.pack(fill="both", expand=True, padx=14, pady=(0, 8))
        self.bld_canvas.bind("<Configure>", lambda _e: self._draw_building())

        log_box = tk.Frame(right, bg="#0b101c", height=130)
        log_box.pack(fill="x", padx=14, pady=(0, 12))
        log_box.pack_propagate(False)
        tk.Label(log_box, text="MONITOR EN VIVO (EVENTOS Y LÓGICA DE DESPACHO)",
                 font=("Consolas", 9, "bold"), fg="#7fa1d6", bg="#0b101c").pack(anchor="w", padx=8, pady=(4, 2))
        self.log_text = tk.Text(log_box, bg="#0b101c", fg="#c8d3ea", font=("Consolas", 9),
                                relief="flat", state="disabled", height=6)
        self.log_text.pack(fill="both", expand=True, padx=8, pady=(0, 4))

    # ==================== LOGICA PRINCIPAL ====================
    def _log(self, msg: str):
        ts = time.strftime("%H:%M:%S")
        self.log_text.configure(state="normal")
        self.log_text.insert("1.0", f"[{ts}] {msg}\n")
        self.log_text.configure(state="disabled")

    def _on_floors_change(self):
        n = self.num_floors.get()
        for e in self.elevators:
            if e.floor > n:
                e.floor = n
                e.pos = float(n)
            e.pickup_stops = {f: d for f, d in e.pickup_stops.items() if f <= n}
            e.dest_stops = {f for f in e.dest_stops if f <= n}
            if not e.has_stops and e.state == "MOVING":
                e.target = None
                e.move_dir = ""
                e.state = "IDLE"
            elif e.state == "MOVING":
                self._recompute_target(e)
        self._log(f"Edificio actualizado a N = {n} pisos.")
        self._update_lcd_and_leds()
        self._draw_building()

    def _on_mode_change(self, _evt=None):
        if self.mode_var.get() == "SERIAL UART (COM)":
            if not HAS_SERIAL:
                messagebox.showinfo(
                    "Modo Serial UART",
                    "Instala pyserial para conectar con Proteus (COMPIM) o el módulo USB-TTL:\n\n"
                    "    pip install pyserial\n\n"
                    "Mientras tanto usa Modo SIMULACION."
                )
                self.mode_var.set("SIMULACION")
            else:
                ports = [p.device for p in serial.tools.list_ports.comports()]
                messagebox.showinfo(
                    "Puertos COM detectados",
                    f"Puertos disponibles: {ports if ports else 'Ninguno conectado aún'}\n"
                    "Velocidad: 9600 bps (RC6/TX y RC7/RX)."
                )

    def _current_waiting_elev(self):
        """Devuelve el primer elevador que tiene la puerta abierta esperando destino."""
        while self.waiting_dest_queue:
            idx = self.waiting_dest_queue[0]
            if self.elevators[idx].state == "WAIT_DEST":
                return self.elevators[idx]
            self.waiting_dest_queue.pop(0)
        return None

    def _recompute_target(self, e: Elevator):
        """Algoritmo LOOK colectivo: elige el proximo piso parada en el sentido actual."""
        stops = e.all_stops
        if not stops:
            e.target = None
            e.move_dir = ""
            if e.state == "MOVING":
                e.state = "IDLE"
            return

        max_s = max(stops)
        min_s = min(stops)

        if e.move_dir == "UP":
            # Paradas por delante subiendo: destinos o llamadas SUBIR (o la parada mas alta antes de invertir)
            ahead = [
                f for f in stops
                if f >= e.pos - 0.01 and (
                    f in e.dest_stops or "UP" in e.pickup_stops.get(f, set()) or f == max_s
                )
            ]
            if ahead:
                e.target = min(ahead)
            else:
                e.move_dir = "DOWN"
                e.target = max_s
        elif e.move_dir == "DOWN":
            # Paradas por delante bajando: destinos o llamadas BAJAR (o la parada mas baja antes de invertir)
            ahead = [
                f for f in stops
                if f <= e.pos + 0.01 and (
                    f in e.dest_stops or "DOWN" in e.pickup_stops.get(f, set()) or f == min_s
                )
            ]
            if ahead:
                e.target = max(ahead)
            else:
                e.move_dir = "UP"
                e.target = min_s
        else:
            e.target = min(stops, key=lambda f: abs(f - e.pos))
            if e.target > e.pos:
                e.move_dir = "UP"
            elif e.target < e.pos:
                e.move_dir = "DOWN"

    def _dispatch_cost(self, e: Elevator, user_floor: int, req_dir: str) -> float:
        """
        Costo estimado (en pisos efectivos) para que el elevador `e` atienda al usuario.
        Evalua tanto elevadores libres como elevadores en movimiento para que el mas cercano
        (especialmente uno que ya va de paso en la misma direccion) recoja al usuario.
        """
        stops = e.all_stops

        if e.state == "IDLE":
            return abs(e.pos - user_floor)

        if e.state == "MOVING":
            if e.move_dir == "UP":
                far = max(stops) if stops else e.pos
                if req_dir == "UP" and user_floor >= e.pos + 0.15:
                    # Va de paso en la misma direccion!
                    inter = sum(1 for f in stops if e.pos < f < user_floor)
                    return (user_floor - e.pos) + 0.4 * inter
                if user_floor >= far:
                    # Esta mas arriba de su ultima parada: sigue de frente sin invertir
                    inter = sum(1 for f in stops if f > e.pos)
                    return (user_floor - e.pos) + 0.8 * inter
                # Debe llegar hasta su parada mas alta y luego bajar
                inter = sum(1 for f in stops if f >= e.pos)
                return max(0.0, far - e.pos) + abs(far - user_floor) + 0.8 * inter

            if e.move_dir == "DOWN":
                far = min(stops) if stops else e.pos
                if req_dir == "DOWN" and user_floor <= e.pos - 0.15:
                    # Va de paso en la misma direccion!
                    inter = sum(1 for f in stops if user_floor < f < e.pos)
                    return (e.pos - user_floor) + 0.4 * inter
                if user_floor <= far:
                    # Esta mas abajo de su ultima parada: sigue de frente sin invertir
                    inter = sum(1 for f in stops if f < e.pos)
                    return (e.pos - user_floor) + 0.8 * inter
                # Debe llegar hasta su parada mas baja y luego subir
                inter = sum(1 for f in stops if f <= e.pos)
                return max(0.0, e.pos - far) + abs(user_floor - far) + 0.8 * inter

            return abs(e.pos - user_floor)

        if e.state == "ARRIVED_OPEN":
            if e.floor == user_floor:
                return 0.2
            return abs(e.pos - user_floor) + 1.5

        if e.state == "WAIT_DEST":
            if e.floor == user_floor:
                return 0.5
            # Penalizacion moderada porque esta esperando que otro pasajero teclee su destino
            return abs(e.pos - user_floor) + 3.5

        return 999.0

    def _press_hall(self, direction: str):
        """Botones fisicos SUBIR (RA4) / BAJAR (RA5): despacho optimo colectivo entre los 3 elevadores."""
        if self.emergency:
            self._log("Bloqueado: Paro de emergencia activo (pulsa '*' para reanudar).")
            return
        if self.input_mode != "WAIT_HALL_BTN" or self.pending_user_floor is None:
            self.last_status_msg = "Primero pulsa A!"
            self._log(f"Botón {direction} ignorado: primero pulsa 'A', ingresa tu piso y confirma con '#'.")
            if self.sound_enabled.get():
                beep_async(400, 100)
            self._update_lcd_and_leds()
            return

        user_floor = self.pending_user_floor
        self.pending_user_floor = None
        self.input_mode = "IDLE"
        req_dir = "UP" if direction == "SUBIR" else "DOWN"

        # Evalua los 3 elevadores (libres y en movimiento) y elige el de menor costo efectivo
        scored = [(self._dispatch_cost(e, user_floor, req_dir), e) for e in self.elevators]
        best_cost, chosen = min(scored, key=lambda pair: pair[0])
        self.active_elev_idx = chosen.idx - 1

        if self.sound_enabled.get():
            beep_async(900 if direction == "SUBIR" else 650, 80)

        # Caso 1: el elegido ya esta detenido en ese mismo piso
        if chosen.floor == user_floor and chosen.state in ("IDLE", "ARRIVED_OPEN", "WAIT_DEST"):
            chosen.state = "WAIT_DEST"
            chosen.door_timer = 0
            chosen.boarding_timer = 0
            chosen.boarding_count = 0
            chosen.door_open_pct = 1.0
            if (chosen.idx - 1) not in self.waiting_dest_queue:
                self.waiting_dest_queue.append(chosen.idx - 1)
            self.buzzer_active = True
            self.last_status_msg = f"E{chosen.idx} P{user_floor:02d} abierto"
            self._log(f"Pasillo {direction} en P{user_floor:02d}: E{chosen.idx} ya estaba ahí -> Puerta ABIERTA (teclea uno o varios destinos + '#', sin 'A').")
        else:
            # Agrega parada de recogida a la ruta del elevador elegido
            was_moving = (chosen.state == "MOVING")
            chosen.pickup_stops.setdefault(user_floor, set()).add(req_dir)
            if chosen.state == "IDLE":
                chosen.state = "MOVING"
            if chosen.state == "MOVING":
                self._recompute_target(chosen)

            motivo = "en camino (más cercano)" if was_moving else f"libre más cercano desde P{chosen.floor:02d}"
            self.last_status_msg = f"E{chosen.idx} -> P{user_floor:02d} ({direction[:3]})"
            self._log(
                f"Pasillo {direction} en P{user_floor:02d}: asignado E{chosen.idx} ({motivo}, costo={best_cost:.1f} pisos)."
            )

        self._update_lcd_and_leds()
        self._draw_building()

    def _press_open_door(self):
        """Tecla B: Abrir/mantener abierta la puerta del elevador activo (si esta detenido)."""
        e = self._current_waiting_elev() or self.elevators[self.active_elev_idx]
        if e.state in ("IDLE", "ARRIVED_OPEN", "WAIT_DEST"):
            if e.state == "IDLE":
                e.state = "ARRIVED_OPEN"
                e.door_timer = 20
            elif e.state == "ARRIVED_OPEN":
                e.door_timer = 20
            elif e.state == "WAIT_DEST" and e.boarding_timer > 0:
                e.boarding_timer = 38  # extiende tiempo para que suban mas usuarios
            e.door_open_pct = 1.0
            self.last_status_msg = f"E{e.idx} Puerta ABIER."
            self._log(f"Tecla 'B' (Abrir): E{e.idx} mantiene puerta abierta en P{e.floor:02d} (LED Amarillo ON).")
            if self.sound_enabled.get():
                beep_async(1050, 70)
        else:
            self._log(f"Tecla 'B': E{e.idx} está en movimiento, no puede abrir puerta.")

    def _press_close_door(self):
        """Tecla C: Cerrar puerta manualmente (y arrancar de inmediato si hay peticiones en cola)."""
        e = self._current_waiting_elev() or self.elevators[self.active_elev_idx]
        if e.state in ("WAIT_DEST", "ARRIVED_OPEN"):
            if (e.idx - 1) in self.waiting_dest_queue:
                self.waiting_dest_queue.remove(e.idx - 1)
            e.door_timer = 0
            e.boarding_timer = 0
            e.boarding_count = 0
            e.door_open_pct = 0.0
            self.keypad_buffer = ""
            if e.has_stops:
                e.state = "MOVING"
                self._recompute_target(e)
                cola_txt = ", ".join(f"P{f:02d}" for f in sorted(e.all_stops))
                self.last_status_msg = f"E{e.idx} -> P{e.target:02d}"
                self._log(f"Tecla 'C' (Cerrar): E{e.idx} cierra puerta y arranca (cola: {cola_txt}).")
            else:
                e.state = "IDLE"
                e.move_dir = ""
                self.last_status_msg = f"E{e.idx} Puerta CERRA."
                self._log(f"Tecla 'C' (Cerrar): E{e.idx} cierra puerta y queda libre (LED Amarillo OFF).")
            if self.sound_enabled.get():
                beep_async(750, 70)

    def _toggle_emergency(self):
        self.emergency = not self.emergency
        self.input_mode = "IDLE"
        self.keypad_buffer = ""
        self.pending_user_floor = None
        if self.emergency:
            self.buzzer_active = True
            for e in self.elevators:
                e.prev_state = e.state
                e.state = "EMERGENCY"
            self._log("!! TECLA '*' !! PARO DE EMERGENCIA ACTIVADO — Todos los elevadores congelados + BUZZER ON.")
            if self.sound_enabled.get():
                beep_async(1600, 260)
        else:
            self.buzzer_active = False
            for e in self.elevators:
                e.state = e.prev_state if e.prev_state != "EMERGENCY" else "IDLE"
            self.last_status_msg = "Sistema normal"
            self._log("Emergencia desactivada con '*' — Reanudando servicio.")
        self._update_lcd_and_leds()
        self._draw_building()

    def _press_key(self, key: str):
        if key == "*":
            self._toggle_emergency()
            return
        if self.emergency:
            self._log("Bloqueado por Emergencia (presiona '*' para reanudar).")
            return

        if self.sound_enabled.get():
            beep_async(1200, 45)

        if key == "A":
            # En cualquier momento se puede pulsar 'A' para simular un nuevo usuario en pasillo
            self.input_mode = "HALL_FLOOR"
            self.keypad_buffer = ""
            self.pending_user_floor = None
            self._log("Tecla 'A': Nuevo usuario -> ingresa en qué piso estás + '#'.")

        elif key in "0123456789":
            wait_e = self._current_waiting_elev()
            if self.input_mode == "HALL_FLOOR":
                self.keypad_buffer = (self.keypad_buffer + key) if len(self.keypad_buffer) < 2 else key
            elif self.input_mode == "IDLE" and wait_e is not None:
                # Puerta abierta esperando uno o varios destinos: ingresa directo SIN presionar A
                self.keypad_buffer = (self.keypad_buffer + key) if len(self.keypad_buffer) < 2 else key
                if wait_e.boarding_count > 0:
                    wait_e.boarding_timer = 38  # reinicia ventana mientras escriben otro destino
            elif self.input_mode == "WAIT_HALL_BTN":
                self.last_status_msg = f"P{self.pending_user_floor:02d}:Pulsa SUB/BAJ"
            else:
                self.last_status_msg = "Presiona A: Piso"

        elif key == "#":
            n = self.num_floors.get()
            if self.input_mode == "HALL_FLOOR":
                # Confirmar en que piso esta el usuario (aun NO se mueve ningun elevador)
                if not self.keypad_buffer:
                    self.input_mode = "IDLE"
                    self.last_status_msg = "ERROR:No existe!"
                    if self.sound_enabled.get():
                        beep_async(350, 180)
                else:
                    fl = int(self.keypad_buffer)
                    self.keypad_buffer = ""
                    if fl < 1 or fl > n:
                        self.input_mode = "IDLE"
                        self.last_status_msg = "ERROR:No existe!"
                        self._log(f"ERROR: El piso {fl} no existe (edificio de 1 a {n}).")
                        if self.sound_enabled.get():
                            beep_async(350, 180)
                    else:
                        self.pending_user_floor = fl
                        self.input_mode = "WAIT_HALL_BTN"
                        self.last_status_msg = f"P{fl:02d}:Pulsa SUB/BAJ"
                        self._log(f"Usuario ubicado en Piso {fl:02d}. Esperando botón SUBIR o BAJAR para despachar elevador...")

            elif self.input_mode == "IDLE":
                # Si hay un elevador con puerta abierta (WAIT_DEST), confirmar piso destino
                wait_e = self._current_waiting_elev()
                if wait_e is not None:
                    if not self.keypad_buffer:
                        self.last_status_msg = "ERROR:No existe!"
                        if self.sound_enabled.get():
                            beep_async(350, 180)
                    else:
                        dest = int(self.keypad_buffer)
                        self.keypad_buffer = ""
                        if dest < 1 or dest > n:
                            self.last_status_msg = "ERROR:No existe!"
                            self._log(f"ERROR: Destino {dest} no existe (rango 1..{n}). Puerta de E{wait_e.idx} sigue abierta.")
                            if self.sound_enabled.get():
                                beep_async(350, 180)
                        elif dest == wait_e.floor:
                            self.last_status_msg = f"Ya en Piso {dest:02d}!"
                            self._log(f"E{wait_e.idx} ya está en Piso {dest:02d}. Elige otro piso o cierra con 'C'.")
                        else:
                            # Destino valido -> SE ENCOLA para permitir que varios usuarios ingresen sus pisos!
                            ya_estaba = dest in wait_e.dest_stops
                            wait_e.dest_stops.add(dest)
                            wait_e.boarding_count += 1
                            wait_e.boarding_timer = 38  # ~4.5 s para que otros usuarios tecleen su piso (o pulsen C)
                            cola_txt = ", ".join(f"P{f:02d}" for f in sorted(wait_e.dest_stops))
                            if ya_estaba:
                                self.last_status_msg = f"P{dest:02d} ya en cola"
                                self._log(f"E{wait_e.idx}: P{dest:02d} ya estaba en cola [{cola_txt}]. Ingresa otro piso + '#' o pulsa 'C' para arrancar.")
                            else:
                                self.last_status_msg = f"E{wait_e.idx} +P{dest:02d} (C=Ir)"
                                self._log(f"E{wait_e.idx} encoló destino P{dest:02d} -> Cola actual: [{cola_txt}]. Puedes agregar más pisos + '#' o pulsar 'C' para salir ya.")

        elif key == "B":
            self._press_open_door()
        elif key == "C":
            self._press_close_door()
        elif key == "D":
            # Borrar ultimo digito ingresado (o cancelar si ya estaba vacio)
            if self.keypad_buffer:
                self.keypad_buffer = self.keypad_buffer[:-1]
                self._log(f"Tecla 'D' (Borrar): entrada actual '{self.keypad_buffer or '__'}'.")
            elif self.input_mode == "WAIT_HALL_BTN":
                self.pending_user_floor = None
                self.input_mode = "HALL_FLOOR"
                self._log("Tecla 'D' (Borrar): vuelve a ingresar el piso.")
            elif self.input_mode == "HALL_FLOOR":
                self.input_mode = "IDLE"
                self.last_status_msg = "Entrada borrada"
                self._log("Tecla 'D' (Borrar): selección cancelada.")

        self._update_lcd_and_leds()
        self._draw_building()

    def _reset_system(self):
        self.emergency = False
        self.buzzer_active = False
        self.input_mode = "IDLE"
        self.keypad_buffer = ""
        self.pending_user_floor = None
        self.waiting_dest_queue.clear()
        n = self.num_floors.get()
        starts = [1, max(1, n // 2), n]
        for e, st in zip(self.elevators, starts):
            e.floor = st
            e.pos = float(st)
            e.target = None
            e.pickup_stops.clear()
            e.dest_stops.clear()
            e.state = "IDLE"
            e.prev_state = "IDLE"
            e.move_dir = ""
            e.door_timer = 0
            e.boarding_timer = 0
            e.boarding_count = 0
            e.door_open_pct = 0.0
        self.last_status_msg = "Presiona A: Piso"
        self._log("Sistema reiniciado (E1=P01, E2=Pmedio, E3=Pn).")
        self._update_lcd_and_leds()
        self._draw_building()

    # ==================== CICLO DE SIMULACION (TIEMPO REAL) ====================
    def _tick_loop(self):
        self.blink_tick = (self.blink_tick + 1) % 6
        self.wait_blink = (self.blink_tick < 3)  # ~360 ms ON / 360 ms OFF para parpadeo de espera
        if self.emergency:
            self.emg_blink = not self.emg_blink
            if self.emg_blink and self.sound_enabled.get():
                beep_async(1500, 90)
        else:
            self.emg_blink = False
            self.buzzer_active = False
            step = 0.055  # ~2.2 segundos por piso (mas realista y da tiempo para multi-usuario)

            for e in self.elevators:
                if e.state == "ARRIVED_OPEN":
                    # Llego a un destino: abre ~2.2 s para bajar y luego continua (o queda IDLE)
                    e.door_timer -= 1
                    e.door_open_pct = 1.0 if e.door_timer > 3 else max(0.0, e.door_timer / 3.0)
                    if e.door_timer <= 0:
                        e.door_open_pct = 0.0
                        if e.has_stops:
                            e.state = "MOVING"
                            self._recompute_target(e)
                            self._log(f"E{e.idx} cerró puertas en P{e.floor:02d} y continúa hacia P{e.target:02d}.")
                        else:
                            e.state = "IDLE"
                            e.move_dir = ""
                            self._log(f"E{e.idx} cerró puertas en P{e.floor:02d} y quedó LIBRE.")
                    continue

                if e.state == "WAIT_DEST":
                    # Si aun no ingresan ningun piso, NO cierra nunca.
                    # Si ya ingresaron >=1 piso, da una ventana para encolar mas peticiones antes de cerrar.
                    if e.boarding_count > 0 and e.boarding_timer > 0:
                        e.boarding_timer -= 1
                        e.door_open_pct = 1.0 if e.boarding_timer > 3 else max(0.0, e.boarding_timer / 3.0)
                        if e.boarding_timer <= 0:
                            if (e.idx - 1) in self.waiting_dest_queue:
                                self.waiting_dest_queue.remove(e.idx - 1)
                            e.boarding_count = 0
                            e.door_open_pct = 0.0
                            if e.has_stops:
                                e.state = "MOVING"
                                self._recompute_target(e)
                                cola_txt = ", ".join(f"P{f:02d}" for f in sorted(e.all_stops))
                                self.last_status_msg = f"E{e.idx} -> P{e.target:02d}"
                                self._log(f"E{e.idx} cerró puerta y arranca atendiendo cola [{cola_txt}] (próxima: P{e.target:02d}).")
                            else:
                                e.state = "IDLE"
                                e.move_dir = ""
                    else:
                        e.door_open_pct = 1.0
                    continue

                if e.state == "MOVING":
                    if e.target is None:
                        self._recompute_target(e)
                    if e.target is None:
                        continue
                    dest = e.target
                    if abs(e.pos - dest) <= step:
                        e.pos = float(dest)
                        e.floor = dest
                        e.target = None
                        e.door_open_pct = 1.0
                        self.active_elev_idx = e.idx - 1
                        self.buzzer_active = True
                        if self.sound_enabled.get():
                            beep_async(1400, 120)

                        had_pickup = dest in e.pickup_stops
                        had_dest = dest in e.dest_stops
                        e.pickup_stops.pop(dest, None)
                        e.dest_stops.discard(dest)

                        if had_pickup:
                            # Llego por uno o varios usuarios en pasillo -> abre puerta y NO cierra hasta elegir >=1 destino
                            e.state = "WAIT_DEST"
                            e.boarding_timer = 0
                            e.boarding_count = 0
                            if (e.idx - 1) not in self.waiting_dest_queue:
                                self.waiting_dest_queue.append(e.idx - 1)
                            self.last_status_msg = f"E{e.idx} P{dest:02d} abierto"
                            extra = " (pasajero bajó y suben nuevos)" if had_dest else ""
                            self._log(f"E{e.idx} llegó por usuario(s) a P{dest:02d}{extra} -> Puerta ABIERTA (teclea destinos + '#', sin 'A').")
                        else:
                            # Llego a un destino final -> baja el pasajero
                            e.state = "ARRIVED_OPEN"
                            e.door_timer = 18
                            self.last_status_msg = f"E{e.idx} llego P{dest:02d}"
                            self._log(f"E{e.idx} llegó al destino P{dest:02d} -> Pasajero desciende.")
                    elif dest > e.pos:
                        e.move_dir = "UP"
                        e.pos += step
                        e.floor = int(round(e.pos))
                    else:
                        e.move_dir = "DOWN"
                        e.pos -= step
                        e.floor = int(round(e.pos))

        self._update_lcd_and_leds()
        self._draw_building()
        self.root.after(120, self._tick_loop)

    # ==================== ACTUALIZACION VISUAL ====================
    def _update_lcd_contrast(self):
        v = self.contrast_val.get()
        self.lbl_pot_pct.configure(text=f"POT 10k: {int(v)}%")
        if v < 15:
            fg, bg = "#9be04a", "#9be04a"
        elif v < 55:
            fg, bg = "#659c2b", "#9be04a"
        elif v <= 95:
            fg, bg = "#152b07", "#9be04a"
        else:
            fg, bg = "#091403", "#4f7a1f"
        self.lcd_screen.configure(bg=bg)
        self.lcd_line1.configure(fg=fg, bg=bg)
        self.lcd_line2.configure(fg=fg, bg=bg)

    def _update_lcd_and_leds(self):
        if self.emergency:
            l1 = "!! EMERGENCIA !!"
            l2 = "Pulsa * reanudar"
        else:
            e1, e2, e3 = self.elevators
            l1 = f"1:{e1.floor:02d}{e1.direction_char} 2:{e2.floor:02d}{e2.direction_char} 3:{e3.floor:02d}{e3.direction_char}"
            wait_e = self._current_waiting_elev()
            if self.input_mode == "HALL_FLOOR":
                p_txt = self.keypad_buffer.ljust(2, "_")
                l2 = f"Sel.Piso:{p_txt} #=OK"
            elif self.input_mode == "WAIT_HALL_BTN" and self.pending_user_floor is not None:
                l2 = f"P{self.pending_user_floor:02d}:Pulsa SUB/BAJ"
            elif wait_e is not None:
                if self.last_status_msg == "ERROR:No existe!" and not self.keypad_buffer:
                    l2 = "ERROR:No existe!"
                elif wait_e.boarding_count > 0 and not self.keypad_buffer:
                    secs = max(1, int((wait_e.boarding_timer * 120) / 1000) + 1)
                    l2 = f"E{wait_e.idx} Cola:{len(wait_e.dest_stops)} {secs}s C"
                else:
                    d_txt = self.keypad_buffer.ljust(2, "_")
                    l2 = f"E{wait_e.idx} Dest:{d_txt} #=OK"
            else:
                l2 = self.last_status_msg[:16]
        self.lcd_line1.configure(text=l1[:16].ljust(16))
        self.lcd_line2.configure(text=l2[:16].ljust(16))
        self._update_lcd_contrast()

        # 9 LEDs fisicos + Buzzer
        c = self.led_canvas
        c.delete("all")
        pins = [("RC0", "RD6", "RC1"), ("RC2", "RD7", "RE0"), ("RE1", "RB4", "RE2")]
        for i, e in enumerate(self.elevators):
            x0 = 14 + i * 140
            c.create_text(x0 + 52, 10, text=f"ELEVADOR {e.idx}", fill="#c8d3ea", font=("Segoe UI", 8, "bold"))
            g_on = e.green_on and not self.emergency
            y_on = e.yellow_on and self.wait_blink and not self.emergency
            r_on = (e.red_on and not self.emergency) or (self.emergency and self.emg_blink)

            c.create_oval(x0, 20, x0 + 22, 42, fill="#22ee44" if g_on else "#1c3b24", outline="#557a5e", width=1.5)
            c.create_text(x0 + 11, 54, text=pins[i][0], fill="#8fa3c7", font=("Consolas", 7))
            c.create_oval(x0 + 38, 20, x0 + 60, 42, fill="#ffd000" if y_on else "#3d3512", outline="#7a6d33", width=1.5)
            c.create_text(x0 + 49, 54, text=pins[i][1], fill="#8fa3c7", font=("Consolas", 7))
            c.create_oval(x0 + 76, 20, x0 + 98, 42, fill="#ff3333" if r_on else "#421c1c", outline="#7a5555", width=1.5)
            c.create_text(x0 + 87, 54, text=pins[i][2], fill="#8fa3c7", font=("Consolas", 7))

        bx = 446
        bz_on = self.buzzer_active or (self.emergency and self.emg_blink)
        c.create_text(bx + 18, 10, text="BUZZER", fill="#ffaa00" if bz_on else "#8fa3c7", font=("Segoe UI", 8, "bold"))
        c.create_oval(bx, 18, bx + 36, 54, fill="#ffaa00" if bz_on else "#222630",
                      outline="#ffcc44" if bz_on else "#555", width=2)
        c.create_text(bx + 18, 36, text=")))" if bz_on else "RB5",
                      fill="#111" if bz_on else "#aaa", font=("Consolas", 8, "bold"))

    def _draw_building(self):
        c = self.bld_canvas
        c.delete("all")
        w = max(500, c.winfo_width())
        h = max(400, c.winfo_height())
        n = self.num_floors.get()

        margin_l, margin_r, margin_t, margin_b = 76, 24, 48, 22
        usable_h = h - margin_t - margin_b
        fh = usable_h / n
        shaft_w = min(150, (w - margin_l - margin_r - 60) / 3)
        gap = (w - margin_l - margin_r - 3 * shaft_w) / 4

        for f in range(1, n + 1):
            y_bot = h - margin_b - (f - 1) * fh
            y_top = y_bot - fh
            c.create_line(margin_l - 8, y_bot, w - margin_r, y_bot, fill="#22304d", width=1)
            col_f = "#ffb300" if self.pending_user_floor == f else "#9eb2d6"
            c.create_text(margin_l - 14, (y_top + y_bot) / 2, text=f"P{f:02d}",
                          fill=col_f, font=("Consolas", 9, "bold"), anchor="e")

        state_lbl = {
            "IDLE": "LIBRE", "MOVING": "EN CAMINO", "WAIT_DEST": "ABORDANDO",
            "ARRIVED_OPEN": "LLEGÓ", "EMERGENCY": "EMERGENCIA"
        }
        for idx, e in enumerate(self.elevators):
            sx = margin_l + gap + idx * (shaft_w + gap)
            c.create_rectangle(sx, margin_t, sx + shaft_w, h - margin_b,
                               fill="#141c2d", outline="#2b3a5c", width=2)
            st_col = "#ff3b30" if e.state == "EMERGENCY" else (
                "#ffd000" if e.state in ("WAIT_DEST", "ARRIVED_OPEN") else (
                    "#22ee44" if e.green_on else ("#ff4d4d" if e.red_on else "#8fa3c7")
                )
            )
            c.create_text(sx + shaft_w / 2, 14, text=f"E{e.idx} [P{e.floor:02d}] {state_lbl[e.state]}",
                          fill=st_col, font=("Segoe UI", 8, "bold"))
            if e.has_stops:
                cola_str = ",".join(f"P{f:02d}" for f in sorted(e.all_stops))
                c.create_text(sx + shaft_w / 2, 32, text=f"Cola: {cola_str}",
                              fill="#4cc9f0", font=("Consolas", 8))

            # Marcar todas las paradas pendientes: naranja = recogida pasillo, cian = destino cabina
            for pf in e.pickup_stops:
                ty = h - margin_b - (pf - 0.5) * fh
                c.create_oval(sx + shaft_w / 2 - 7, ty - 7, sx + shaft_w / 2 + 7, ty + 7,
                              outline="#ffb300", width=2)
            for df in e.dest_stops:
                ty = h - margin_b - (df - 0.5) * fh
                c.create_oval(sx + shaft_w / 2 - 4, ty - 4, sx + shaft_w / 2 + 4, ty + 4,
                              outline="#4cc9f0", width=2)

            cy_bot = h - margin_b - (e.pos - 1.0) * fh
            cy_top = cy_bot - fh
            pad_x, pad_y = 12, max(2, fh * 0.08)
            cab_x1, cab_y1 = sx + pad_x, cy_top + pad_y
            cab_x2, cab_y2 = sx + shaft_w - pad_x, cy_bot - pad_y
            cab_w = cab_x2 - cab_x1

            c.create_line(sx + shaft_w / 2, margin_t, sx + shaft_w / 2, cab_y1, fill="#4c5c7a", width=2)
            border = "#ff3b30" if e.state == "EMERGENCY" else ("#ffd000" if e.state == "WAIT_DEST" else "#b8c4d9")
            c.create_rectangle(cab_x1, cab_y1, cab_x2, cab_y2, fill="#d7e0ed", outline=border, width=2)

            open_w = (cab_w - 8) * 0.7 * e.door_open_pct
            if open_w > 2:
                mx = (cab_x1 + cab_x2) / 2
                c.create_rectangle(mx - open_w / 2, cab_y1 + 4, mx + open_w / 2, cab_y2 - 3,
                                   fill="#ffe89e", outline="")

            door_w = max(4, (cab_w - 8 - open_w) / 2)
            c.create_rectangle(cab_x1 + 4, cab_y1 + 4, cab_x1 + 4 + door_w, cab_y2 - 3,
                               fill="#64748f", outline="#44526b")
            c.create_rectangle(cab_x2 - 4 - door_w, cab_y1 + 4, cab_x2 - 4, cab_y2 - 3,
                               fill="#64748f", outline="#44526b")

            c.create_text((cab_x1 + cab_x2) / 2, (cab_y1 + cab_y2) / 2,
                          text=f"E{e.idx}{e.direction_char}", fill="#0b101c",
                          font=("Segoe UI", max(8, int(min(12, fh * 0.32))), "bold"))


if __name__ == "__main__":
    root = tk.Tk()
    app = ElevadorSupremoApp(root)
    root.mainloop()
