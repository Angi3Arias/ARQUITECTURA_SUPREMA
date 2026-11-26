# -*- coding: utf-8 -*-
"""
ELEVADOR SUPREMO — INTERFAZ RESPONSIVA EN VIVO (PIC18F4550 + UART 9600 bps)
Diseno limpio estilo Simulador, adaptable desde ventanas compactas junto a Proteus
(440x480) hasta pantalla completa:
  - Torre animada de 3 elevadores y N pisos (4..20) con apertura/cierre suave de puertas.
  - Aros por peticion con degradado de tonalidad (1a peticion = tono fuerte -> posteriores = tono suave)
    y aros concentricos si confluyen en un mismo piso.
  - Panel lateral/inferior responsivo con 3 pestanas limpias sin ruido visual:
      1) Colas y Flujo   : carriles activos E1/E2/E3 + flujo en vivo (+ENCOLAR / -DESENCOLAR).
      2) Algoritmo LOOK  : etapas activas, comparacion de costos E1/E2/E3 y regla actual.
      3) Conexion/Control: enlace UART 9600 bps, LCD espejo, botones de prueba y log serial.

Ejecutar:
    python interfaz_elevador.py
"""
from collections import deque
from dataclasses import dataclass, field
import random
import subprocess
import sys
import time
import tkinter as tk
from tkinter import messagebox, ttk

try:
    import serial
    import serial.tools.list_ports
    HAS_SERIAL = True
except ImportError:
    HAS_SERIAL = False


# ===================== PALETA LIMPIA ESTILO SIMULADOR =====================
PAL = {
    "bg_root":     "#111622",
    "bg_header":   "#171f31",
    "bg_panel":    "#182032",
    "bg_card":     "#121929",
    "bg_canvas":   "#0f1420",
    "bg_shaft":    "#141c2d",
    "bg_log":      "#0c111d",
    "border":      "#263350",
    "grid":        "#1e2a44",
    "cable":       "#475675",
    "txt_main":    "#f1f5fc",
    "txt_title":   "#9ec1ff",
    "txt_sub":     "#8fa3c7",
    "txt_soft":    "#c8d3ea",
    "txt_dim":     "#667896",
    "btn_bg":      "#243047",
    "btn_hover":   "#334463",
    "btn_blue":    "#2b4c7e",
    "btn_green":   "#1f6f43",
    "btn_red":     "#9e2a2b",
    "btn_emg":     "#c91818",
    "btn_amber":   "#a85e1a",
    "cab_body":    "#d7e0ed",
    "cab_door":    "#64748f",
    "cab_door_bd": "#44526b",
    "cab_lit":     "#ffe89e",
    "cab_border":  "#b8c4d9",
    "green":       "#22ee44",
    "yellow":      "#ffd000",
    "red":         "#ff3b30",
    "cyan":        "#4cc9f0",
    "orange":      "#ffb300",
}


def ring_tone(kind: str, rank: int, total: int):
    """
    Devuelve (color_aro, color_halo, grosor) segun orden de peticion.
    rank=0 -> tono mas fuerte y vivo; conforme aumenta rank va bajando la tonalidad.
    """
    denom = max(5, total - 1)
    t = min(1.0, max(0.0, rank / float(denom)))
    if kind in ("U", "D"):
        # Naranja vivo (#ff8c00) -> Ambar suave (#85643c)
        r = int(255 + (133 - 255) * t)
        g = int(142 + (100 - 142) * t)
        b = int(0   + (60  - 0)   * t)
    else:
        # Cian vivo (#00e5ff) -> Azul acero suave (#4a7c91)
        r = int(0   + (74  - 0)   * t)
        g = int(232 + (124 - 232) * t)
        b = int(255 + (145 - 255) * t)

    col = f"#{r:02x}{g:02x}{b:02x}"
    halo = f"#{int(r * 0.42):02x}{int(g * 0.42):02x}{int(b * 0.42):02x}"
    width = round(max(1.4, 3.0 - 1.4 * t), 2)
    return col, halo, width


@dataclass
class RequestItem:
    req_id: int
    elev: int       # 0, 1, 2
    floor: int      # 1..20
    kind: str       # "U", "D", "C"
    ts: float = field(default_factory=time.time)


@dataclass
class SimElevator:
    idx: int
    floor: int
    pos: float = 1.0
    target: int = 0
    pickup_stops: dict = field(default_factory=dict)
    dest_stops: set = field(default_factory=set)
    state: str = "I"          # I, U, D, W, O, E
    prev_state: str = "I"
    move_dir: str = ""        # "U", "D", ""
    door_timer: int = 0
    boarding_timer: int = 0
    boarding_count: int = 0
    door_open_pct: float = 0.0

    def __post_init__(self):
        self.pos = float(self.floor)

    @property
    def all_stops(self) -> set:
        return set(self.pickup_stops.keys()) | self.dest_stops

    @property
    def has_stops(self) -> bool:
        return bool(self.pickup_stops or self.dest_stops)


class InterfazElevadorApp:
    def __init__(self, root: tk.Tk):
        self.root = root
        self.root.title("Elevador Supremo — Monitor en Vivo (PIC18F4550)")
        self.root.geometry("980x660")
        self.root.minsize(440, 480)
        self.root.configure(bg=PAL["bg_root"])

        # Conexion y modo
        self.ser = None
        self.connected = False
        self.mode_var = tk.StringVar(value="SIMULACION")
        self.port_var = tk.StringVar(value="")
        self.baud_var = tk.StringVar(value="9600")
        self.num_floors = tk.IntVar(value=12)
        self.quick_floor_var = tk.IntVar(value=5)
        self.dest_floor_var = tk.IntVar(value=9)
        self.always_on_top = tk.BooleanVar(value=False)

        # Cola serializada UART y debounce de cambio de pisos
        self.tx_queue = deque()
        self.rx_buffer = ""
        self._pending_n_value = None
        self._pending_n_until = 0.0
        self._pic_synced_n = False
        self._user_editing_n = False
        self._n_debounce_id = None

        # Layout responsivo ("horizontal" o "vertical")
        self._layout_orient = None

        # Estado visual compartido
        self.floors = [1, 6, 12]
        self.pos = [1.0, 6.0, 12.0]
        self.states = ["I", "I", "I"]
        self.targets = [0, 0, 0]
        self.door_open_pct = [0.0, 0.0, 0.0]
        self.door_target_pct = [0.0, 0.0, 0.0]
        self.emergency = False
        self.buzzer_active = False
        self.blink_on = True
        self._blink_counter = 0

        # LCD espejo
        self.lcd_line1_txt = "1:01  2:06  3:12"
        self.lcd_line2_txt = "Listo (LOOK 3E) "
        self.last_status_msg = "Listo (LOOK 3E)"

        # Seguimiento ordenado de peticiones (aros graduados + flujo)
        self.req_seq = 0
        self.active_requests: list[RequestItem] = []
        self.total_enqueued = 0
        self.total_dequeued = 0
        self.lane_flash = [("", 0.0), ("", 0.0), ("", 0.0)]

        # Visualizador del algoritmo LOOK
        self.algo_stage = 0
        self.algo_stage_until = 0.0
        self.last_dispatch = {
            "floor": None,
            "dir": "",
            "chosen": None,
            "costs": [0.0, 0.0, 0.0],
            "reasons": ["En reposo", "En reposo", "En reposo"],
            "summary": "En espera de la primera llamada de pasillo...",
        }

        # Motor local de simulacion
        self.sim_elevs = [SimElevator(1, 1), SimElevator(2, 6), SimElevator(3, 12)]
        self.sim_wait_queue: list[int] = []
        self.sim_active_idx = 0

        # Firmas para redibujado eficiente
        self._last_bld_sig = None
        self._last_queue_sig = None
        self._last_algo_sig = None

        self._configure_styles()
        self._build_ui()
        self._refresh_ports()
        self._sync_spinbox_limits()
        self._log_uart("Listo en modo SIMULACIÓN. Conecta un puerto COM en la pestaña 'Control / PIC' para enlazar con Proteus o PIC18F4550.")
        self._log_flow("info", "Sistema listo (12 pisos, 3 elevadores, LOOK colectivo).")
        self._apply_responsive_layout(980, 660)
        self._draw_all_initial()
        self._tick()

    def _configure_styles(self):
        style = ttk.Style()
        try:
            style.theme_use("clam")
        except Exception:
            pass

        style.configure(
            "Sim.TCombobox",
            fieldbackground=PAL["bg_log"],
            background=PAL["btn_bg"],
            foreground=PAL["txt_main"],
            bordercolor=PAL["border"],
            arrowcolor=PAL["txt_title"],
        )
        style.configure(
            "Clean.TNotebook",
            background=PAL["bg_panel"],
            borderwidth=0,
            tabmargins=[2, 4, 2, 0],
        )
        style.configure(
            "Clean.TNotebook.Tab",
            background=PAL["bg_card"],
            foreground=PAL["txt_sub"],
            padding=[10, 5],
            font=("Segoe UI", 8, "bold"),
            borderwidth=0,
        )
        style.map(
            "Clean.TNotebook.Tab",
            background=[("selected", PAL["btn_blue"]), ("active", PAL["btn_bg"])],
            foreground=[("selected", "#ffffff"), ("active", PAL["txt_main"])],
        )

    # ===================== CONSTRUCCION DE INTERFAZ LIMPIA =====================
    def _build_ui(self):
        # -------- BARRA SUPERIOR MINIMALISTA Y RESPONSIVA --------
        self.top_bar = tk.Frame(
            self.root, bg=PAL["bg_header"], height=46,
            highlightbackground=PAL["border"], highlightthickness=1
        )
        self.top_bar.pack(fill="x", side="top")
        self.top_bar.pack_propagate(False)

        self.lbl_title = tk.Label(
            self.top_bar, text="▲▼ ELEVADOR SUPREMO", font=("Segoe UI", 12, "bold"),
            fg=PAL["txt_main"], bg=PAL["bg_header"]
        )
        self.lbl_title.pack(side="left", padx=(12, 6))

        # Controles compactos a la derecha
        ctrl = tk.Frame(self.top_bar, bg=PAL["bg_header"])
        ctrl.pack(side="right", padx=8)

        self.btn_pin = tk.Button(
            ctrl, text="📌", command=self._toggle_pin, width=3,
            bg=PAL["btn_bg"], fg=PAL["txt_sub"], activebackground=PAL["btn_hover"],
            activeforeground="#fff", relief="flat", font=("Segoe UI", 9),
            pady=2, cursor="hand2"
        )
        self.btn_pin.pack(side="right", padx=(4, 0))

        tk.Button(
            ctrl, text="⟲", command=self._reset_system, width=3,
            bg=PAL["btn_bg"], fg=PAL["txt_main"], activebackground=PAL["btn_hover"],
            activeforeground="#fff", relief="flat", font=("Segoe UI", 9, "bold"),
            pady=2, cursor="hand2"
        ).pack(side="right", padx=(4, 0))

        self.lbl_conn_pill = tk.Label(
            ctrl, text="● SIM", font=("Consolas", 8, "bold"),
            fg=PAL["yellow"], bg="#2b2714", padx=7, pady=3, cursor="hand2"
        )
        self.lbl_conn_pill.pack(side="right", padx=(6, 0))
        self.lbl_conn_pill.bind("<Button-1>", lambda _e: self.notebook.select(2))

        # Control unico de pisos (N = 4..20)
        tk.Button(
            ctrl, text="+", command=lambda: self._step_floors(1), width=2,
            bg=PAL["btn_bg"], fg="#fff", relief="flat", font=("Segoe UI", 9, "bold"),
            cursor="hand2"
        ).pack(side="right")
        self.lbl_n_top = tk.Label(
            ctrl, text="12", font=("Consolas", 10, "bold"), fg="#fff", bg=PAL["bg_log"],
            width=3, highlightbackground=PAL["border"], highlightthickness=1
        )
        self.lbl_n_top.pack(side="right", padx=2)
        tk.Button(
            ctrl, text="−", command=lambda: self._step_floors(-1), width=2,
            bg=PAL["btn_bg"], fg="#fff", relief="flat", font=("Segoe UI", 9, "bold"),
            cursor="hand2"
        ).pack(side="right")
        self.lbl_pisos_txt = tk.Label(
            ctrl, text="Pisos:", font=("Segoe UI", 8, "bold"),
            fg=PAL["txt_sub"], bg=PAL["bg_header"]
        )
        self.lbl_pisos_txt.pack(side="right", padx=(0, 4))

        # -------- CONTENEDOR PRINCIPAL RESPONSIVO (HORIZONTAL / VERTICAL) --------
        self.body = tk.Frame(self.root, bg=PAL["bg_root"])
        self.body.pack(fill="both", expand=True, padx=6, pady=6)

        self.paned = tk.PanedWindow(
            self.body, orient="horizontal", bg=PAL["bg_root"],
            sashwidth=6, sashrelief="flat", bd=0
        )
        self.paned.pack(fill="both", expand=True)

        # ======== ZONA PRINCIPAL: TORRE DE ELEVADORES (PROTAGONISTA) ========
        self.tower_frame = tk.Frame(
            self.paned, bg=PAL["bg_panel"],
            highlightbackground=PAL["border"], highlightthickness=1
        )

        hdr_t = tk.Frame(self.tower_frame, bg=PAL["bg_panel"])
        hdr_t.pack(fill="x", padx=10, pady=(6, 2))
        self.lbl_tower_hdr = tk.Label(
            hdr_t, text="EDIFICIO EN VIVO", font=("Segoe UI", 9, "bold"),
            fg=PAL["txt_title"], bg=PAL["bg_panel"]
        )
        self.lbl_tower_hdr.pack(side="left")
        self.lbl_emg_banner = tk.Label(
            hdr_t, text="", font=("Consolas", 8, "bold"),
            fg=PAL["red"], bg=PAL["bg_panel"]
        )
        self.lbl_emg_banner.pack(side="right")

        self.bld_canvas = tk.Canvas(self.tower_frame, bg=PAL["bg_canvas"], highlightthickness=0)
        self.bld_canvas.pack(fill="both", expand=True, padx=8, pady=(0, 4))
        self.bld_canvas.bind("<Configure>", lambda _e: self._draw_building())

        self.legend_canvas = tk.Canvas(
            self.tower_frame, height=28, bg=PAL["bg_card"], highlightthickness=0
        )
        self.legend_canvas.pack(fill="x", padx=8, pady=(0, 6))
        self.legend_canvas.bind("<Configure>", lambda _e: self._draw_legend())

        # ======== ZONA SECUNDARIA: PANEL CON 3 PESTAÑAS LIMPIAS ========
        self.side_frame = tk.Frame(
            self.paned, bg=PAL["bg_panel"],
            highlightbackground=PAL["border"], highlightthickness=1
        )

        self.notebook = ttk.Notebook(self.side_frame, style="Clean.TNotebook")
        self.notebook.pack(fill="both", expand=True, padx=4, pady=4)

        # ---- PESTAÑA 1: COLAS Y FLUJO ----
        tab_q = tk.Frame(self.notebook, bg=PAL["bg_panel"])
        self.notebook.add(tab_q, text="  Colas y Flujo  ")

        kpi = tk.Frame(tab_q, bg=PAL["bg_card"], padx=6, pady=5,
                       highlightbackground=PAL["border"], highlightthickness=1)
        kpi.pack(fill="x", padx=6, pady=(6, 6))
        self.lbl_kpi_enq = tk.Label(kpi, text="Encoladas: 0", font=("Consolas", 8, "bold"),
                                    fg=PAL["cyan"], bg=PAL["bg_card"])
        self.lbl_kpi_enq.pack(side="left", expand=True)
        self.lbl_kpi_act = tk.Label(kpi, text="Activas: 0", font=("Consolas", 8, "bold"),
                                    fg=PAL["orange"], bg=PAL["bg_card"])
        self.lbl_kpi_act.pack(side="left", expand=True)
        self.lbl_kpi_deq = tk.Label(kpi, text="Atendidas: 0", font=("Consolas", 8, "bold"),
                                    fg=PAL["green"], bg=PAL["bg_card"])
        self.lbl_kpi_deq.pack(side="left", expand=True)

        self.queue_canvas = tk.Canvas(
            tab_q, height=116, bg=PAL["bg_canvas"],
            highlightbackground=PAL["border"], highlightthickness=1
        )
        self.queue_canvas.pack(fill="x", padx=6, pady=(0, 6))
        self.queue_canvas.bind("<Configure>", lambda _e: self._draw_queue_lanes())

        flow_wrap = tk.Frame(tab_q, bg=PAL["bg_log"],
                             highlightbackground=PAL["border"], highlightthickness=1)
        flow_wrap.pack(fill="both", expand=True, padx=6, pady=(0, 6))
        self.flow_text = tk.Text(
            flow_wrap, bg=PAL["bg_log"], fg=PAL["txt_soft"], font=("Consolas", 8),
            relief="flat", state="disabled", wrap="word", padx=6, pady=4
        )
        flow_sb = ttk.Scrollbar(flow_wrap, orient="vertical", command=self.flow_text.yview)
        self.flow_text.configure(yscrollcommand=flow_sb.set)
        self.flow_text.pack(side="left", fill="both", expand=True)
        flow_sb.pack(side="right", fill="y")

        self.flow_text.tag_configure("enq_hall", foreground="#ffb300")
        self.flow_text.tag_configure("enq_cab",  foreground="#38e8ff")
        self.flow_text.tag_configure("deq",      foreground="#22ee44")
        self.flow_text.tag_configure("prune",    foreground="#ff6b6b")
        self.flow_text.tag_configure("emg",      foreground="#ff3b30")
        self.flow_text.tag_configure("info",     foreground="#9eb2d6")

        # ---- PESTAÑA 2: ALGORITMO LOOK ----
        tab_a = tk.Frame(self.notebook, bg=PAL["bg_panel"])
        self.notebook.add(tab_a, text="  Algoritmo LOOK  ")

        tk.Label(tab_a, text="ETAPA ACTIVA", font=("Segoe UI", 8, "bold"),
                 fg=PAL["txt_sub"], bg=PAL["bg_panel"]).pack(anchor="w", padx=8, pady=(8, 3))
        self.algo_stage_canvas = tk.Canvas(
            tab_a, height=46, bg=PAL["bg_canvas"],
            highlightbackground=PAL["border"], highlightthickness=1
        )
        self.algo_stage_canvas.pack(fill="x", padx=6, pady=(0, 8))
        self.algo_stage_canvas.bind("<Configure>", lambda _e: self._draw_algo_panel())

        tk.Label(tab_a, text="EVALUACIÓN DE COSTO (DESPACHO ÓPTIMO)", font=("Segoe UI", 8, "bold"),
                 fg=PAL["txt_sub"], bg=PAL["bg_panel"]).pack(anchor="w", padx=8, pady=(0, 3))
        self.algo_cost_canvas = tk.Canvas(
            tab_a, height=112, bg=PAL["bg_canvas"],
            highlightbackground=PAL["border"], highlightthickness=1
        )
        self.algo_cost_canvas.pack(fill="x", padx=6, pady=(0, 8))
        self.algo_cost_canvas.bind("<Configure>", lambda _e: self._draw_algo_panel())

        tk.Label(tab_a, text="REGLA LOOK POR ELEVADOR", font=("Segoe UI", 8, "bold"),
                 fg=PAL["txt_sub"], bg=PAL["bg_panel"]).pack(anchor="w", padx=8, pady=(0, 3))
        rules_wrap = tk.Frame(tab_a, bg=PAL["bg_log"],
                              highlightbackground=PAL["border"], highlightthickness=1)
        rules_wrap.pack(fill="both", expand=True, padx=6, pady=(0, 6))
        self.algo_rules_box = tk.Text(
            rules_wrap, bg=PAL["bg_log"], fg=PAL["txt_soft"], font=("Consolas", 8),
            relief="flat", state="disabled", wrap="word", padx=8, pady=6
        )
        self.algo_rules_box.pack(fill="both", expand=True)
        self.algo_rules_box.tag_configure("e_hdr", foreground="#9ec1ff")
        self.algo_rules_box.tag_configure("e_act", foreground="#4cc9f0")
        self.algo_rules_box.tag_configure("e_open", foreground="#ffd000")
        self.algo_rules_box.tag_configure("e_idle", foreground="#8fa3c7")

        # ---- PESTAÑA 3: CONTROL Y CONEXION PIC (CON SCROLL AUTOMATICO) ----
        tab_c_outer = tk.Frame(self.notebook, bg=PAL["bg_panel"])
        self.notebook.add(tab_c_outer, text="  Control / PIC  ")

        self.ctl_canvas = tk.Canvas(tab_c_outer, bg=PAL["bg_panel"], highlightthickness=0, bd=0)
        self.ctl_scroll = ttk.Scrollbar(tab_c_outer, orient="vertical", command=self.ctl_canvas.yview)
        self.ctl_canvas.configure(yscrollcommand=self.ctl_scroll.set)
        self.ctl_canvas.pack(side="left", fill="both", expand=True)

        tab_c = tk.Frame(self.ctl_canvas, bg=PAL["bg_panel"])
        self._ctl_win_id = self.ctl_canvas.create_window((0, 0), window=tab_c, anchor="nw")

        def _sync_ctl_scroll(_e=None):
            self.ctl_canvas.configure(scrollregion=self.ctl_canvas.bbox("all"))
            if tab_c.winfo_reqheight() > self.ctl_canvas.winfo_height() + 2:
                if not self.ctl_scroll.winfo_ismapped():
                    self.ctl_scroll.pack(side="right", fill="y")
            elif self.ctl_scroll.winfo_ismapped():
                self.ctl_scroll.pack_forget()

        tab_c.bind("<Configure>", _sync_ctl_scroll)
        self.ctl_canvas.bind(
            "<Configure>",
            lambda e: (self.ctl_canvas.itemconfig(self._ctl_win_id, width=e.width), _sync_ctl_scroll())
        )

        # Tarjeta: Conexion PIC18F4550
        c_uart = self._make_card(tab_c, "CONEXIÓN PIC18F4550 (UART 9600)")
        row_m = tk.Frame(c_uart, bg=PAL["bg_card"])
        row_m.pack(fill="x", pady=(0, 6))
        tk.Label(row_m, text="Modo:", font=("Segoe UI", 8, "bold"),
                 fg=PAL["txt_soft"], bg=PAL["bg_card"]).pack(side="left")
        mode_cb = ttk.Combobox(
            row_m, textvariable=self.mode_var, state="readonly", width=15,
            values=["SIMULACION", "PIC UART (COM)"], style="Sim.TCombobox"
        )
        mode_cb.pack(side="left", fill="x", expand=True, padx=(6, 0))
        mode_cb.bind("<<ComboboxSelected>>", self._on_mode_change)

        row_p = tk.Frame(c_uart, bg=PAL["bg_card"])
        row_p.pack(fill="x", pady=(0, 6))
        tk.Label(row_p, text="COM:", font=("Segoe UI", 8, "bold"),
                 fg=PAL["txt_soft"], bg=PAL["bg_card"]).pack(side="left")
        self.cb_port = ttk.Combobox(row_p, textvariable=self.port_var, state="readonly",
                                    width=11, style="Sim.TCombobox")
        self.cb_port.pack(side="left", fill="x", expand=True, padx=6)
        tk.Button(row_p, text="↻", command=self._refresh_ports, width=3,
                  bg=PAL["btn_bg"], fg="#fff", relief="flat", font=("Segoe UI", 9, "bold"),
                  cursor="hand2").pack(side="right")

        self.btn_connect = tk.Button(
            c_uart, text="CONECTAR PIC (9600 bps)", command=self._toggle_connect,
            bg=PAL["btn_blue"], fg="#fff", activebackground="#3d6cb0", activeforeground="#fff",
            font=("Segoe UI", 8, "bold"), relief="flat", pady=5, cursor="hand2"
        )
        self.btn_connect.pack(fill="x")

        if not HAS_SERIAL:
            warn = tk.Frame(c_uart, bg=PAL["bg_log"], highlightbackground=PAL["border"], highlightthickness=1)
            warn.pack(fill="x", pady=(6, 0))
            tk.Label(warn, text="pyserial no instalado", font=("Segoe UI", 8),
                     fg=PAL["orange"], bg=PAL["bg_log"]).pack(side="left", padx=6, pady=3)
            tk.Button(warn, text="Instalar", command=self._install_pyserial,
                      bg=PAL["bg_log"], fg=PAL["cyan"], relief="flat",
                      font=("Segoe UI", 8, "bold", "underline"), cursor="hand2").pack(side="right", padx=6)

        # Tarjeta: LCD Espejo compacto
        c_lcd = self._make_card(tab_c, "LCD 16x2 (ESPEJO)")
        lcd_scr = tk.Frame(c_lcd, bg="#9be04a", padx=8, pady=5,
                           highlightbackground="#1f6f3d", highlightthickness=2)
        lcd_scr.pack(fill="x")
        self.lbl_lcd1 = tk.Label(lcd_scr, text=self.lcd_line1_txt, font=("Consolas", 11, "bold"),
                                 fg="#152b07", bg="#9be04a", anchor="w")
        self.lbl_lcd1.pack(fill="x")
        self.lbl_lcd2 = tk.Label(lcd_scr, text=self.lcd_line2_txt, font=("Consolas", 11, "bold"),
                                 fg="#152b07", bg="#9be04a", anchor="w")
        self.lbl_lcd2.pack(fill="x")

        # Tarjeta: Controles de peticion
        c_ctl = self._make_card(tab_c, "PETICIONES Y PUERTAS")
        row_h = tk.Frame(c_ctl, bg=PAL["bg_card"])
        row_h.pack(fill="x", pady=(0, 5))
        tk.Label(row_h, text="Piso:", font=("Segoe UI", 8, "bold"),
                 fg=PAL["txt_soft"], bg=PAL["bg_card"]).pack(side="left")
        self.sp_hall = tk.Spinbox(
            row_h, from_=1, to=12, width=3, textvariable=self.quick_floor_var,
            font=("Consolas", 9, "bold"), bg=PAL["bg_log"], fg="#fff",
            buttonbackground=PAL["border"], relief="flat"
        )
        self.sp_hall.pack(side="left", padx=(4, 6))
        tk.Button(
            row_h, text="▲ SUBIR", command=lambda: self._send_hall_call("U"),
            bg=PAL["btn_green"], fg="#fff", font=("Segoe UI", 8, "bold"),
            relief="flat", pady=4, cursor="hand2"
        ).pack(side="left", expand=True, fill="x", padx=(0, 4))
        tk.Button(
            row_h, text="▼ BAJAR", command=lambda: self._send_hall_call("D"),
            bg=PAL["btn_red"], fg="#fff", font=("Segoe UI", 8, "bold"),
            relief="flat", pady=4, cursor="hand2"
        ).pack(side="left", expand=True, fill="x")

        row_d = tk.Frame(c_ctl, bg=PAL["bg_card"])
        row_d.pack(fill="x", pady=(0, 5))
        tk.Label(row_d, text="Dest:", font=("Segoe UI", 8, "bold"),
                 fg=PAL["txt_soft"], bg=PAL["bg_card"]).pack(side="left")
        self.sp_dest = tk.Spinbox(
            row_d, from_=1, to=12, width=3, textvariable=self.dest_floor_var,
            font=("Consolas", 9, "bold"), bg=PAL["bg_log"], fg="#fff",
            buttonbackground=PAL["border"], relief="flat"
        )
        self.sp_dest.pack(side="left", padx=(4, 6))
        tk.Button(
            row_d, text="● ENCOLAR DESTINO (#)", command=self._send_cabin_dest,
            bg="#1a6a85", fg="#fff", font=("Segoe UI", 8, "bold"),
            relief="flat", pady=4, cursor="hand2"
        ).pack(side="left", expand=True, fill="x")

        row_b = tk.Frame(c_ctl, bg=PAL["bg_card"])
        row_b.pack(fill="x", pady=(0, 5))
        tk.Button(
            row_b, text="Abrir (B)", command=lambda: self._send_key("B"),
            bg=PAL["btn_blue"], fg="#fff", font=("Segoe UI", 8, "bold"),
            relief="flat", pady=4, cursor="hand2"
        ).pack(side="left", expand=True, fill="x", padx=(0, 4))
        tk.Button(
            row_b, text="Cerrar (C)", command=lambda: self._send_key("C"),
            bg=PAL["btn_amber"], fg="#fff", font=("Segoe UI", 8, "bold"),
            relief="flat", pady=4, cursor="hand2"
        ).pack(side="left", expand=True, fill="x", padx=(0, 4))
        tk.Button(
            row_b, text="EMERG (*)", command=lambda: self._send_key("*"),
            bg=PAL["btn_emg"], fg="#fff", font=("Segoe UI", 8, "bold"),
            relief="flat", pady=4, cursor="hand2"
        ).pack(side="left", expand=True, fill="x")

        tk.Button(
            c_ctl, text="⚡ RÁFAGA DE 6 PETICIONES", command=self._burst_test,
            bg="#3b2f63", fg="#e6dcff", activebackground="#52418a", activeforeground="#fff",
            font=("Segoe UI", 8, "bold"), relief="flat", pady=4, cursor="hand2"
        ).pack(fill="x")

        # Tarjeta: Log UART compacto
        c_log = self._make_card(tab_c, "REGISTRO SERIAL UART")
        self.uart_log = tk.Text(
            c_log, bg=PAL["bg_log"], fg=PAL["txt_soft"], font=("Consolas", 8),
            relief="flat", state="disabled", height=6, wrap="word"
        )
        self.uart_log.pack(fill="x")

        self.root.bind("<Configure>", self._on_root_resize)

    def _make_card(self, parent, title: str):
        outer = tk.Frame(
            parent, bg=PAL["bg_card"], padx=8, pady=7,
            highlightbackground=PAL["border"], highlightthickness=1
        )
        outer.pack(fill="x", padx=6, pady=(6, 0))
        tk.Label(outer, text=title, font=("Segoe UI", 8, "bold"),
                 fg=PAL["txt_title"], bg=PAL["bg_card"]).pack(anchor="w", pady=(0, 5))
        return outer

    def _on_root_resize(self, event):
        if event.widget is not self.root:
            return
        self._apply_responsive_layout(event.width, event.height)

    def _apply_responsive_layout(self, w: int, h: int):
        # Adaptar titulo y etiquetas de la barra superior en ventanas angostas
        if w < 540:
            self.lbl_title.configure(text="▲▼ ELEVADOR", font=("Segoe UI", 10, "bold"))
            if self.lbl_pisos_txt.winfo_ismapped():
                self.lbl_pisos_txt.pack_forget()
        elif w < 760:
            self.lbl_title.configure(text="▲▼ ELEVADOR SUPREMO", font=("Segoe UI", 11, "bold"))
            if not self.lbl_pisos_txt.winfo_ismapped():
                self.lbl_pisos_txt.pack(side="right", padx=(0, 4))
        else:
            self.lbl_title.configure(text="▲▼ ELEVADOR SUPREMO", font=("Segoe UI", 12, "bold"))
            if not self.lbl_pisos_txt.winfo_ismapped():
                self.lbl_pisos_txt.pack(side="right", padx=(0, 4))

        # Cambiar automaticamente entre vista Lado-a-Lado (>=760px) y Arriba/Abajo (<760px)
        target_orient = "horizontal" if w >= 760 else "vertical"
        if target_orient != self._layout_orient:
            self._layout_orient = target_orient
            for pane in list(self.paned.panes()):
                self.paned.forget(pane)
            self.paned.configure(orient=target_orient)
            if target_orient == "horizontal":
                side_w = max(310, min(420, int(w * 0.40)))
                self.paned.add(self.tower_frame, minsize=280, stretch="always")
                self.paned.add(self.side_frame, minsize=290, width=side_w, stretch="never")
            else:
                side_h = max(190, min(260, int(h * 0.40)))
                self.paned.add(self.tower_frame, minsize=220, stretch="always")
                self.paned.add(self.side_frame, minsize=175, height=side_h, stretch="never")
            self._invalidate_views()

    def _toggle_pin(self):
        val = not self.always_on_top.get()
        self.always_on_top.set(val)
        try:
            self.root.attributes("-topmost", val)
        except Exception:
            pass
        self.btn_pin.configure(
            bg=PAL["btn_blue"] if val else PAL["btn_bg"],
            fg="#ffffff" if val else PAL["txt_sub"],
        )

    def _draw_all_initial(self):
        self._draw_building()
        self._draw_legend()
        self._draw_queue_lanes()
        self._draw_algo_panel()

    # ===================== LOGS Y REGISTRO DE PETICIONES =====================
    def _log_uart(self, msg: str):
        ts = time.strftime("%H:%M:%S")
        self.uart_log.configure(state="normal")
        self.uart_log.insert("1.0", f"[{ts}] {msg}\n")
        if int(self.uart_log.index("end-1c").split(".")[0]) > 180:
            self.uart_log.delete("160.0", "end")
        self.uart_log.configure(state="disabled")

    def _log_flow(self, tag: str, msg: str):
        ts = time.strftime("%H:%M:%S")
        self.flow_text.configure(state="normal")
        self.flow_text.insert("1.0", f"[{ts}] {msg}\n", (tag,))
        if int(self.flow_text.index("end-1c").split(".")[0]) > 220:
            self.flow_text.delete("200.0", "end")
        self.flow_text.configure(state="disabled")

    def _set_algo_stage(self, stage: int, hold_sec: float = 2.0):
        self.algo_stage = stage
        self.algo_stage_until = time.time() + hold_sec
        self._last_algo_sig = None

    def _register_enqueue(self, elev: int, floor: int, kind: str) -> RequestItem:
        for r in self.active_requests:
            if r.elev == elev and r.floor == floor and r.kind == kind:
                return r
        self.req_seq += 1
        item = RequestItem(req_id=self.req_seq, elev=elev, floor=floor, kind=kind)
        self.active_requests.append(item)
        self.total_enqueued += 1
        self.lane_flash[elev] = ("+ENC", time.time() + 1.3)

        kind_txt = "SUBIR ▲" if kind == "U" else ("BAJAR ▼" if kind == "D" else "DEST ●")
        cola_txt = self._format_elev_queue(elev)
        tag = "enq_hall" if kind in ("U", "D") else "enq_cab"
        self._log_flow(tag, f"+ ENCOLAR #{item.req_id} P{floor:02d} ({kind_txt}) → E{elev + 1}  [{cola_txt}]")
        self._set_algo_stage(3, 1.8)
        self._invalidate_views()
        return item

    def _register_dequeue(self, elev: int, floor: int, kind: str, detail: str = ""):
        removed = []
        kept = []
        for r in self.active_requests:
            if r.elev == elev and r.floor == floor and (kind == "*" or r.kind == kind):
                removed.append(r)
            else:
                kept.append(r)
        self.active_requests = kept

        if removed:
            self.total_dequeued += len(removed)
            self.lane_flash[elev] = ("-DES", time.time() + 1.3)
            ids = ",".join(f"#{r.req_id}" for r in removed)
            extra = f" · {detail}" if detail else ""
            self._log_flow("deq", f"- DESENCOLAR {ids} P{floor:02d} en E{elev + 1}{extra}")
            self._set_algo_stage(5, 2.0)
            self._invalidate_views()

    def _prune_requests_above(self, n: int) -> int:
        kept, removed = [], []
        for r in self.active_requests:
            (kept if r.floor <= n else removed).append(r)
        self.active_requests = kept
        if removed:
            pisos = ", ".join(f"P{r.floor:02d}" for r in removed)
            self._log_flow("prune", f"✕ PODAR (N={n}): eliminadas {pisos}")
            self._invalidate_views()
        return len(removed)

    def _format_elev_queue(self, elev: int) -> str:
        ordered = self._ordered_requests_for_elev(elev)
        return " → ".join(f"P{r.floor:02d}" for r in ordered) if ordered else "vacía"

    def _ordered_requests_for_elev(self, elev: int) -> list[RequestItem]:
        items = [r for r in self.active_requests if r.elev == elev]
        if not items:
            return []
        cur = self.pos[elev]
        st = self.states[elev]
        tgt = self.targets[elev]

        if st == "U":
            ahead = sorted([r for r in items if r.floor >= cur - 0.1], key=lambda r: (r.floor, r.req_id))
            behind = sorted([r for r in items if r.floor < cur - 0.1], key=lambda r: (-r.floor, r.req_id))
            ordered = ahead + behind
        elif st == "D":
            ahead = sorted([r for r in items if r.floor <= cur + 0.1], key=lambda r: (-r.floor, r.req_id))
            behind = sorted([r for r in items if r.floor > cur + 0.1], key=lambda r: (r.floor, r.req_id))
            ordered = ahead + behind
        else:
            ordered = sorted(items, key=lambda r: (abs(r.floor - cur), r.req_id))

        if tgt > 0:
            pri = [r for r in ordered if r.floor == tgt]
            rest = [r for r in ordered if r.floor != tgt]
            ordered = pri + rest
        return ordered

    def _invalidate_views(self):
        self._last_bld_sig = None
        self._last_queue_sig = None
        self._last_algo_sig = None

    # ===================== CONTROL DE PISOS Y CONEXION UART =====================
    def _sync_spinbox_limits(self):
        n = self.num_floors.get()
        self.lbl_n_top.configure(text=f"{n:02d}")
        self.sp_hall.configure(to=n)
        self.sp_dest.configure(to=n)
        if self.quick_floor_var.get() > n:
            self.quick_floor_var.set(n)
        if self.dest_floor_var.get() > n:
            self.dest_floor_var.set(n)

    def _step_floors(self, delta: int):
        n = max(4, min(20, self.num_floors.get() + delta))
        self.num_floors.set(n)
        self._sync_spinbox_limits()
        if self.connected and self.ser is not None:
            # Debounce de 260 ms para no saturar UART si el usuario presiona varias veces seguidas
            self._user_editing_n = True
            self._clamp_visual_state(n)
            self._prune_requests_above(n)
            self._invalidate_views()
            if self._n_debounce_id is not None:
                self.root.after_cancel(self._n_debounce_id)
            self._n_debounce_id = self.root.after(260, self._apply_floors)
        else:
            self._apply_floors()

    def _clamp_visual_state(self, n: int):
        for i in range(3):
            if self.floors[i] > n:
                self.floors[i] = n
            if self.pos[i] > n:
                self.pos[i] = float(n)
            if self.targets[i] > n:
                self.targets[i] = 0

    def _apply_floors(self):
        self._n_debounce_id = None
        n = max(4, min(20, self.num_floors.get()))
        self.num_floors.set(n)
        self._sync_spinbox_limits()

        if self.connected and self.ser is not None:
            self._pending_n_value = n
            self._pending_n_until = time.time() + 2.8
            self._clamp_visual_state(n)
            self._prune_requests_above(n)
            self._queue_tx(f"N:{n:02d}\n")
            self._log_uart(f"TX -> N:{n:02d} ({n} pisos enviados al PIC18F4550).")
            self._log_flow("info", f"Pisos enviados al PIC: N = {n}.")
        else:
            self._apply_floors_sim(n)
        self._invalidate_views()

    def _apply_floors_sim(self, n: int):
        pruned = self._prune_requests_above(n)
        for e in self.sim_elevs:
            if e.floor > n:
                e.floor = n
                e.pos = float(n)
            if e.pos > n:
                e.pos = float(n)
            e.pickup_stops = {f: dirs for f, dirs in e.pickup_stops.items() if f <= n}
            e.dest_stops = {f for f in e.dest_stops if f <= n}
            if e.target > n:
                e.target = 0
            if e.state in ("U", "D"):
                self._sim_recompute_target(e)
            elif e.state == "W" and e.boarding_count > 0 and not e.has_stops:
                e.boarding_count = 0
                e.boarding_timer = 0
        self._sync_from_sim()
        self.last_status_msg = f"NEW PISOS = {n:02d}"
        self._log_flow("info", f"Edificio ajustado a N = {n} pisos" + (f" ({pruned} podadas)." if pruned else "."))

    def _queue_tx(self, text: str):
        if not self.connected or self.ser is None:
            return
        self.tx_queue.append(text.encode("ascii"))

    def _pump_tx(self):
        if not self.connected or self.ser is None or not self.tx_queue:
            return
        cmd = self.tx_queue.popleft()
        try:
            self.ser.write(cmd)
            self.ser.flush()
        except Exception as ex:
            self._log_uart(f"Error TX serial: {ex}")
            self._disconnect()

    def _refresh_ports(self):
        if not HAS_SERIAL:
            self.cb_port["values"] = ["(Sin pyserial)"]
            self.port_var.set("(Sin pyserial)")
            return
        ports = [p.device for p in serial.tools.list_ports.comports()]
        if not ports:
            self.cb_port["values"] = ["Sin puertos COM"]
            self.port_var.set("Sin puertos COM")
        else:
            self.cb_port["values"] = ports
            if self.port_var.get() not in ports:
                self.port_var.set(ports[0])

    def _install_pyserial(self):
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "pyserial"])
            messagebox.showinfo("pyserial instalado", "pyserial instalado correctamente. Reinicia la ventana.")
        except Exception as ex:
            messagebox.showerror("Error", f"No se pudo instalar pyserial:\n{ex}")

    def _on_mode_change(self, _evt=None):
        if self.mode_var.get() == "SIMULACION":
            if self.connected:
                self._disconnect()
            self._set_conn_pill("● SIM", PAL["yellow"], "#2b2714")
        elif not self.connected:
            self._set_conn_pill("● OFF", PAL["red"], "#36161a")

    def _set_conn_pill(self, text: str, fg: str, bg: str):
        self.lbl_conn_pill.configure(text=text, fg=fg, bg=bg)

    def _toggle_connect(self):
        if self.connected:
            self._disconnect()
            return
        if not HAS_SERIAL:
            messagebox.showwarning("Falta pyserial", "Instala pyserial primero o usa el modo SIMULACION.")
            return
        port = self.port_var.get()
        if not port or "Sin " in port:
            messagebox.showinfo("Puerto COM", "Conecta tu USB-TTL o com0com de Proteus y pulsa '↻'.")
            return
        try:
            self.ser = serial.Serial(port, int(self.baud_var.get()), timeout=0, write_timeout=0.15)
            self.connected = True
            self.mode_var.set("PIC UART (COM)")
            self.rx_buffer = ""
            self.tx_queue.clear()
            self._pic_synced_n = False
            self._pending_n_value = None
            self._user_editing_n = False
            self.active_requests.clear()
            self.btn_connect.configure(text="DESCONECTAR PIC", bg=PAL["btn_red"])
            self._set_conn_pill(f"● {port}", PAL["green"], "#13361e")
            self._log_uart(f"Conectado a {port} @ 9600 bps.")
            self._log_flow("info", f"Conectado al PIC por {port} (9600 bps).")
        except Exception as ex:
            messagebox.showerror("Error de conexión", f"No se pudo abrir {port}:\n{ex}")

    def _disconnect(self):
        try:
            if self.ser is not None:
                self.ser.close()
        except Exception:
            pass
        self.ser = None
        self.connected = False
        self.tx_queue.clear()
        self.btn_connect.configure(text="CONECTAR PIC (9600 bps)", bg=PAL["btn_blue"])
        if self.mode_var.get() == "SIMULACION":
            self._set_conn_pill("● SIM", PAL["yellow"], "#2b2714")
        else:
            self._set_conn_pill("● OFF", PAL["red"], "#36161a")
        self._log_uart("Puerto serial desconectado.")

    # ===================== COMANDOS DE USUARIO =====================
    def _send_hall_call(self, dir_c: str):
        n = self.num_floors.get()
        try:
            fl = int(self.quick_floor_var.get())
        except Exception:
            fl = 1
        fl = max(1, min(n, fl))
        self.quick_floor_var.set(fl)

        if self.connected:
            self._queue_tx(f"C:{fl:02d},{dir_c}\n")
            self._log_uart(f"TX -> C:{fl:02d},{dir_c}")
            self._set_algo_stage(1, 1.5)
        else:
            self.mode_var.set("SIMULACION")
            self._sim_hall_call(fl, dir_c)

    def _send_cabin_dest(self):
        n = self.num_floors.get()
        try:
            fl = int(self.dest_floor_var.get())
        except Exception:
            fl = 1
        fl = max(1, min(n, fl))
        self.dest_floor_var.set(fl)

        if self.connected:
            target_e = next((i for i in range(3) if self.states[i] == "W"), 0)
            self._queue_tx(f"D:{target_e + 1},{fl:02d}\n")
            self._log_uart(f"TX -> D:{target_e + 1},{fl:02d}")
            self._set_algo_stage(3, 1.5)
        else:
            self.mode_var.set("SIMULACION")
            self._sim_cabin_dest(fl)

    def _send_key(self, key: str):
        if self.connected:
            self._queue_tx(f"K:{key}\n")
            self._log_uart(f"TX -> K:{key}")
        else:
            self.mode_var.set("SIMULACION")
            if key == "*":
                self._sim_toggle_emergency()
            elif key == "B":
                self._sim_open_door()
            elif key == "C":
                self._sim_close_door()

    def _burst_test(self):
        n = self.num_floors.get()
        if self.emergency:
            self._log_flow("emg", "! Emergencia activa: desactiva (*) primero.")
            return
        pool = list(range(1, n + 1))
        random.shuffle(pool)
        chosen = pool[:min(6, len(pool))]
        self._log_flow("info", f"⚡ Ráfaga ({len(chosen)} peticiones): {', '.join(f'P{f:02d}' for f in chosen)}")
        for idx, fl in enumerate(chosen):
            d = "U" if fl < n and (fl == 1 or random.random() < 0.5) else "D"
            self.root.after(idx * 150, lambda f=fl, dr=d: self._dispatch_burst_item(f, dr))

    def _dispatch_burst_item(self, fl: int, dr: str):
        if self.connected:
            self._queue_tx(f"C:{fl:02d},{dr}\n")
        else:
            self._sim_hall_call(fl, dr)

    def _reset_system(self):
        self.active_requests.clear()
        self.req_seq = 0
        self.total_enqueued = 0
        self.total_dequeued = 0
        self.emergency = False
        self.buzzer_active = False
        self.last_dispatch = {
            "floor": None,
            "dir": "",
            "chosen": None,
            "costs": [0.0, 0.0, 0.0],
            "reasons": ["En reposo", "En reposo", "En reposo"],
            "summary": "Sistema reiniciado. En espera de peticiones...",
        }
        self._set_algo_stage(0, 0.0)

        if self.connected:
            self._queue_tx("R\n")
            self._log_uart("TX -> R (reinicio)")
        else:
            n = self.num_floors.get()
            starts = [1, max(1, n // 2), n]
            self.sim_elevs = [SimElevator(i + 1, starts[i]) for i in range(3)]
            self.sim_wait_queue.clear()
            self.sim_active_idx = 0
            self.last_status_msg = "Listo (LOOK 3E)"
            self._sync_from_sim()

        self._log_flow("info", "⟲ Sistema reiniciado.")
        self._invalidate_views()

    # ===================== LECTURA Y PARSEO UART DEL PIC =====================
    def _poll_serial(self):
        if not self.connected or self.ser is None:
            return
        try:
            waiting = self.ser.in_waiting
            if waiting > 0:
                chunk = self.ser.read(waiting).decode("ascii", errors="ignore")
                self.rx_buffer += chunk
                while "\n" in self.rx_buffer:
                    line, self.rx_buffer = self.rx_buffer.split("\n", 1)
                    line = line.strip()
                    if line:
                        self._parse_uart_line(line)
        except Exception as ex:
            self._log_uart(f"Desconexión serial: {ex}")
            self._disconnect()

    def _parse_uart_line(self, line: str):
        if line.startswith("S,"):
            self._parse_state_frame(line)
        elif line.startswith("E,"):
            self._parse_event_frame(line)

    def _parse_event_frame(self, line: str):
        parts = line.split(",")
        if len(parts) < 2:
            return
        ev = parts[1]
        try:
            if ev == "DSP" and len(parts) >= 8:
                fl = int(parts[2])
                dr = parts[3]
                chosen = int(parts[4])
                costs = [int(parts[5]) / 10.0, int(parts[6]) / 10.0, int(parts[7]) / 10.0]
                reasons = [self._describe_cost_reason(i, fl, dr) for i in range(3)]
                dir_lbl = "SUBIR ▲" if dr == "U" else "BAJAR ▼"
                self.last_dispatch = {
                    "floor": fl,
                    "dir": dr,
                    "chosen": chosen,
                    "costs": costs,
                    "reasons": reasons,
                    "summary": f"P{fl:02d} ({dir_lbl}) → E{chosen + 1} (costo {costs[chosen]:.1f})",
                }
                self._set_algo_stage(2, 2.2)
            elif ev == "ENQ" and len(parts) >= 5:
                e, fl, tp = int(parts[2]), int(parts[3]), parts[4]
                if 0 <= e <= 2 and 1 <= fl <= self.num_floors.get():
                    self._register_enqueue(e, fl, tp)
            elif ev == "DEQ" and len(parts) >= 5:
                e, fl, tp = int(parts[2]), int(parts[3]), parts[4]
                detail = "Puerta abierta (aborda)" if tp in ("U", "D") else "Puerta abierta (baja)"
                if 0 <= e <= 2:
                    self._register_dequeue(e, fl, tp, detail)
            elif ev == "CFG" and len(parts) >= 4:
                n, pruned = int(parts[2]), int(parts[3])
                if 4 <= n <= 20:
                    self.num_floors.set(n)
                    self._sync_spinbox_limits()
                    self._pending_n_value = None
                    self._user_editing_n = False
                    self._pic_synced_n = True
                    self._clamp_visual_state(n)
                    self._prune_requests_above(n)
                    self._log_uart(f"RX <- PIC confirmó N={n} (podadas={pruned}).")
            elif ev == "EMG" and len(parts) >= 3:
                act = (parts[2] == "1")
                self.emergency = act
                self._log_flow("emg", "! EMERGENCIA activada." if act else "✓ Emergencia desactivada.")
            elif ev == "RST":
                self.active_requests.clear()
                self._log_flow("info", "PIC reiniciado.")
        except ValueError:
            pass
        self._invalidate_views()

    def _parse_state_frame(self, line: str):
        parts = line.split(",")
        if len(parts) < 5:
            return
        try:
            if len(parts) >= 6:
                pic_n = int(parts[5].strip())
                if 4 <= pic_n <= 20:
                    now = time.time()
                    if self._pending_n_value is not None:
                        if pic_n == self._pending_n_value:
                            self._pending_n_value = None
                            self._user_editing_n = False
                            self._pic_synced_n = True
                        elif now > self._pending_n_until:
                            self._pending_n_value = None
                            self._user_editing_n = False
                    elif not self._user_editing_n and (not self._pic_synced_n or pic_n != self.num_floors.get()):
                        self._pic_synced_n = True
                        self.num_floors.set(pic_n)
                        self._sync_spinbox_limits()
                        self._prune_requests_above(pic_n)

            n_active = self.num_floors.get()
            for i in range(3):
                tok = parts[1 + i].strip()
                fl = int(tok[:2])
                st = tok[2] if len(tok) >= 3 else "I"
                self.floors[i] = max(1, min(n_active, fl))
                self.states[i] = st
                if len(tok) >= 6:
                    tgt = int(tok[3:5])
                    door_lvl = int(tok[5])
                    self.targets[i] = tgt if 1 <= tgt <= n_active else 0
                    self.door_target_pct[i] = max(0.0, min(1.0, door_lvl / 9.0))
                else:
                    self.door_target_pct[i] = 1.0 if st in ("W", "O") else 0.0

            self.emergency = (parts[4].strip() == "1")
            if len(parts) >= 12:
                self._reconcile_stop_masks(parts[6:12], n_active)

            if self.emergency:
                self.lcd_line1_txt = "!! EMERGENCIA !!"
                self.lcd_line2_txt = "Pulsa * reanudar"
            else:
                d_ch = [self._dir_char_for(i) for i in range(3)]
                self.lcd_line1_txt = f"1:{self.floors[0]:02d}{d_ch[0]} 2:{self.floors[1]:02d}{d_ch[1]} 3:{self.floors[2]:02d}{d_ch[2]}"
                w_idx = next((i for i in range(3) if self.states[i] == "W"), -1)
                if w_idx >= 0:
                    cnt = sum(1 for r in self.active_requests if r.elev == w_idx and r.kind == "C")
                    self.lcd_line2_txt = f"E{w_idx + 1} Abierto Q:{cnt:02d}"
                else:
                    self.lcd_line2_txt = f"PIC Vivo Q:{len(self.active_requests):02d}   "
        except ValueError:
            pass

    def _reconcile_stop_masks(self, hex_tokens: list[str], n_active: int):
        expected_pairs = set()
        for e in range(3):
            pk_mask = int(hex_tokens[e * 2], 16)
            ds_mask = int(hex_tokens[e * 2 + 1], 16)
            for f in range(1, n_active + 1):
                bit = 1 << (f - 1)
                if pk_mask & bit:
                    expected_pairs.add((e, f, "PK"))
                    if not any(r.elev == e and r.floor == f and r.kind in ("U", "D") for r in self.active_requests):
                        self._register_enqueue(e, f, "U" if f <= n_active // 2 else "D")
                if ds_mask & bit:
                    expected_pairs.add((e, f, "DS"))
                    if not any(r.elev == e and r.floor == f and r.kind == "C" for r in self.active_requests):
                        self._register_enqueue(e, f, "C")

        for r in list(self.active_requests):
            cat = "PK" if r.kind in ("U", "D") else "DS"
            if (r.elev, r.floor, cat) not in expected_pairs:
                self._register_dequeue(r.elev, r.floor, r.kind, "sync PIC")

    # ===================== MOTOR LOCAL DE SIMULACION (LOOK) =====================
    def _sim_current_waiting(self):
        while self.sim_wait_queue:
            idx = self.sim_wait_queue[0]
            if self.sim_elevs[idx].state == "W":
                return self.sim_elevs[idx]
            self.sim_wait_queue.pop(0)
        return None

    def _sim_recompute_target(self, e: SimElevator):
        stops = e.all_stops
        if not stops:
            e.target = 0
            e.move_dir = ""
            if e.state in ("U", "D"):
                e.state = "I"
            return

        if e.floor in stops and abs(e.pos - e.floor) < 0.08:
            e.target = e.floor
            return

        max_s, min_s = max(stops), min(stops)
        if e.move_dir == "U":
            ahead = [
                f for f in stops
                if f >= e.pos - 0.02 and (f in e.dest_stops or "U" in e.pickup_stops.get(f, set()) or f == max_s)
            ]
            if ahead:
                e.target = min(ahead)
                e.state = "U"
            else:
                e.move_dir = "D"
                e.state = "D"
                below = [
                    f for f in stops
                    if f <= e.pos + 0.02 and (f in e.dest_stops or "D" in e.pickup_stops.get(f, set()) or f == min_s)
                ]
                e.target = max(below) if below else max_s
        elif e.move_dir == "D":
            ahead = [
                f for f in stops
                if f <= e.pos + 0.02 and (f in e.dest_stops or "D" in e.pickup_stops.get(f, set()) or f == min_s)
            ]
            if ahead:
                e.target = max(ahead)
                e.state = "D"
            else:
                e.move_dir = "U"
                e.state = "U"
                above = [
                    f for f in stops
                    if f >= e.pos - 0.02 and (f in e.dest_stops or "U" in e.pickup_stops.get(f, set()) or f == max_s)
                ]
                e.target = min(above) if above else min_s
        else:
            e.target = min(stops, key=lambda f: abs(f - e.pos))
            if e.target > e.pos:
                e.move_dir = "U"
                e.state = "U"
            elif e.target < e.pos:
                e.move_dir = "D"
                e.state = "D"
            else:
                e.state = "U" if e.move_dir != "D" else "D"

    def _sim_dispatch_cost(self, e: SimElevator, user_floor: int, req_dir: str) -> tuple[float, str]:
        stops = e.all_stops
        load = len(stops)
        if e.state == "I":
            return abs(e.pos - user_floor), f"Libre P{e.floor:02d}"
        if e.state in ("U", "D"):
            if e.move_dir == "U":
                far = max(stops) if stops else e.pos
                if req_dir == "U" and user_floor >= e.pos + 0.15:
                    inter = sum(1 for f in stops if e.pos < f < user_floor)
                    return (user_floor - e.pos) + 0.5 * inter, f"De paso ▲ ({inter} int.)"
                inter = sum(1 for f in stops if f >= e.pos)
                return max(0.0, far - e.pos) + abs(far - user_floor) + 0.8 * inter + 1.0, f"Sube a P{int(far):02d} y baja"
            if e.move_dir == "D":
                far = min(stops) if stops else e.pos
                if req_dir == "D" and user_floor <= e.pos - 0.15:
                    inter = sum(1 for f in stops if user_floor < f < e.pos)
                    return (e.pos - user_floor) + 0.5 * inter, f"De paso ▼ ({inter} int.)"
                inter = sum(1 for f in stops if f <= e.pos)
                return max(0.0, e.pos - far) + abs(user_floor - far) + 0.8 * inter + 1.0, f"Baja a P{int(far):02d} y sube"
        if e.state == "O":
            if e.floor == user_floor:
                return 0.4, f"Abierto en P{user_floor:02d}"
            return abs(e.pos - user_floor) + 1.8 + 0.8 * load, f"Descenso (carga={load})"
        if e.state == "W":
            if e.floor == user_floor:
                return 0.6, f"Abordando P{user_floor:02d}"
            return abs(e.pos - user_floor) + 3.8 + 1.0 * load, f"Espera (carga={load})"
        return 99.0, "No disponible"

    def _describe_cost_reason(self, elev: int, fl: int, dr: str) -> str:
        st, cur = self.states[elev], self.floors[elev]
        load = sum(1 for r in self.active_requests if r.elev == elev)
        if st == "I":
            return f"Libre P{cur:02d}"
        if st == "U":
            return f"De paso ▲ (q={load})" if (dr == "U" and fl > cur) else f"Subiendo (q={load})"
        if st == "D":
            return f"De paso ▼ (q={load})" if (dr == "D" and fl < cur) else f"Bajando (q={load})"
        if st == "W":
            return f"Abordando P{cur:02d}"
        if st == "O":
            return f"Descenso P{cur:02d}"
        return "Emergencia"

    def _sim_hall_call(self, user_floor: int, req_dir: str):
        if self.emergency:
            self._log_flow("emg", "! Bloqueado por emergencia.")
            return
        self._set_algo_stage(2, 2.2)

        scored = [self._sim_dispatch_cost(e, user_floor, req_dir) for e in self.sim_elevs]
        costs = [c for c, _ in scored]
        reasons = [r for _, r in scored]
        chosen_idx = min(range(3), key=lambda i: costs[i])

        for i, e in enumerate(self.sim_elevs):
            if req_dir in e.pickup_stops.get(user_floor, set()):
                chosen_idx = i
                reasons[i] = "Ya asignado"
                break

        chosen = self.sim_elevs[chosen_idx]
        self.sim_active_idx = chosen_idx
        dir_lbl = "SUBIR ▲" if req_dir == "U" else "BAJAR ▼"
        self.last_dispatch = {
            "floor": user_floor,
            "dir": req_dir,
            "chosen": chosen_idx,
            "costs": costs,
            "reasons": reasons,
            "summary": f"P{user_floor:02d} ({dir_lbl}) → E{chosen_idx + 1} (costo {costs[chosen_idx]:.1f})",
        }

        if chosen.floor == user_floor and chosen.state in ("I", "O", "W"):
            chosen.state = "W"
            chosen.door_timer = 0
            chosen.boarding_timer = 0
            chosen.boarding_count = 0
            if chosen_idx not in self.sim_wait_queue:
                self.sim_wait_queue.append(chosen_idx)
            self.last_status_msg = f"E{chosen.idx} P{user_floor:02d} Abierto"
            self._log_flow("deq", f"● E{chosen.idx} ya en P{user_floor:02d} → Puerta ABIERTA.")
            self._set_algo_stage(5, 2.0)
        else:
            chosen.pickup_stops.setdefault(user_floor, set()).add(req_dir)
            self._register_enqueue(chosen_idx, user_floor, req_dir)
            if chosen.state == "I":
                chosen.state = "U" if user_floor >= chosen.pos else "D"
                chosen.move_dir = chosen.state
            if chosen.state in ("U", "D"):
                self._sim_recompute_target(chosen)
            self.last_status_msg = f"E{chosen.idx}->P{user_floor:02d} ({dir_lbl[:3]})"
            self._set_algo_stage(4, 2.0)

        self._sync_from_sim()
        self._invalidate_views()

    def _sim_cabin_dest(self, dest: int):
        if self.emergency:
            return
        e = self._sim_current_waiting() or self.sim_elevs[self.sim_active_idx]
        if dest == e.floor:
            self.last_status_msg = f"Ya en Piso {dest:02d}!"
            return

        e.dest_stops.add(dest)
        self._register_enqueue(e.idx - 1, dest, "C")
        if e.state == "W":
            e.boarding_count += 1
            e.boarding_timer = 110
        elif e.state == "I":
            e.state = "U" if dest > e.pos else "D"
            e.move_dir = e.state
            self._sim_recompute_target(e)
        elif e.state in ("U", "D"):
            self._sim_recompute_target(e)

        self.last_status_msg = f"E{e.idx} +P{dest:02d} en cola"
        self._set_algo_stage(4, 1.8)
        self._sync_from_sim()
        self._invalidate_views()

    def _sim_open_door(self):
        if self.emergency:
            return
        e = self._sim_current_waiting() or self.sim_elevs[self.sim_active_idx]
        if e.state in ("I", "O", "W"):
            if e.state in ("I", "O"):
                e.state = "O"
                e.door_timer = 65
            elif e.state == "W" and e.boarding_timer > 0:
                e.boarding_timer = 110
            self.last_status_msg = f"E{e.idx} Puerta ABIER."
            self._sync_from_sim()

    def _sim_close_door(self):
        if self.emergency:
            return
        e = self._sim_current_waiting() or self.sim_elevs[self.sim_active_idx]
        if e.state in ("W", "O"):
            if (e.idx - 1) in self.sim_wait_queue:
                self.sim_wait_queue.remove(e.idx - 1)
            e.door_timer = 0
            e.boarding_timer = 0
            e.boarding_count = 0
            if e.has_stops:
                e.state = "U" if e.move_dir != "D" else "D"
                self._sim_recompute_target(e)
                self.last_status_msg = f"E{e.idx}->Dest P{e.target:02d}"
            else:
                e.state = "I"
                e.move_dir = ""
                e.target = 0
                self.last_status_msg = f"E{e.idx} Puerta CERRA."
            self._sync_from_sim()

    def _sim_toggle_emergency(self):
        self.emergency = not self.emergency
        if self.emergency:
            self.buzzer_active = True
            for e in self.sim_elevs:
                e.prev_state = e.state
                e.state = "E"
            self._log_flow("emg", "! EMERGENCIA activada.")
        else:
            self.buzzer_active = False
            for e in self.sim_elevs:
                e.state = e.prev_state if e.prev_state != "E" else "I"
            self.last_status_msg = "Sistema normal"
            self._log_flow("info", "✓ Emergencia desactivada.")
        self._sync_from_sim()

    def _sim_step(self):
        if self.emergency:
            return
        self.buzzer_active = False
        step = 0.022

        for e in self.sim_elevs:
            idx = e.idx - 1
            if e.state == "O":
                e.door_timer -= 1
                e.door_open_pct = 1.0 if e.door_timer > 14 else max(0.0, e.door_timer / 14.0)
                if e.door_timer <= 0:
                    e.door_open_pct = 0.0
                    if e.has_stops:
                        e.state = "U" if e.move_dir != "D" else "D"
                        self._sim_recompute_target(e)
                    else:
                        e.state = "I"
                        e.move_dir = ""
                        e.target = 0
                continue

            if e.state == "W":
                if e.boarding_count > 0 and e.boarding_timer > 0:
                    e.boarding_timer -= 1
                    e.door_open_pct = 1.0 if e.boarding_timer > 14 else max(0.0, e.boarding_timer / 14.0)
                    if e.boarding_timer <= 0:
                        if idx in self.sim_wait_queue:
                            self.sim_wait_queue.remove(idx)
                        e.boarding_count = 0
                        e.door_open_pct = 0.0
                        if e.has_stops:
                            e.state = "U" if e.move_dir != "D" else "D"
                            self._sim_recompute_target(e)
                            self.last_status_msg = f"E{e.idx}->Dest P{e.target:02d}"
                        else:
                            e.state = "I"
                            e.move_dir = ""
                            e.target = 0
                else:
                    e.door_open_pct = min(1.0, e.door_open_pct + 0.08)
                continue

            if e.state in ("U", "D"):
                e.door_open_pct = max(0.0, e.door_open_pct - 0.1)
                if e.target == 0:
                    self._sim_recompute_target(e)
                if e.target == 0:
                    continue

                dest = e.target
                if abs(e.pos - dest) <= step:
                    e.pos = float(dest)
                    e.floor = dest
                    e.target = 0
                    self.sim_active_idx = idx
                    self.buzzer_active = True

                    all_s = e.all_stops
                    has_above = any(f > dest for f in all_s)
                    has_below = any(f < dest for f in all_s)

                    had_dest = dest in e.dest_stops
                    e.dest_stops.discard(dest)
                    if had_dest:
                        self._register_dequeue(idx, dest, "C", "pasajero baja")

                    p_dirs = e.pickup_stops.get(dest, set())
                    had_pickup = False
                    if e.move_dir == "U":
                        if "U" in p_dirs:
                            p_dirs.discard("U")
                            had_pickup = True
                            self._register_dequeue(idx, dest, "U", "aborda ▲")
                        if not has_above and "D" in p_dirs:
                            p_dirs.discard("D")
                            had_pickup = True
                            e.move_dir = "D"
                            self._register_dequeue(idx, dest, "D", "giro LOOK ▼")
                    elif e.move_dir == "D":
                        if "D" in p_dirs:
                            p_dirs.discard("D")
                            had_pickup = True
                            self._register_dequeue(idx, dest, "D", "aborda ▼")
                        if not has_below and "U" in p_dirs:
                            p_dirs.discard("U")
                            had_pickup = True
                            e.move_dir = "U"
                            self._register_dequeue(idx, dest, "U", "giro LOOK ▲")
                    else:
                        for d_rem in list(p_dirs):
                            p_dirs.discard(d_rem)
                            had_pickup = True
                            e.move_dir = d_rem
                            self._register_dequeue(idx, dest, d_rem, "aborda")

                    if not p_dirs and dest in e.pickup_stops:
                        e.pickup_stops.pop(dest, None)

                    if had_pickup:
                        e.state = "W"
                        e.boarding_count = 0
                        e.boarding_timer = 0
                        if idx not in self.sim_wait_queue:
                            self.sim_wait_queue.append(idx)
                        self.last_status_msg = f"E{e.idx} P{dest:02d} Abierto"
                    else:
                        e.state = "O"
                        e.door_timer = 65
                        self.last_status_msg = f"E{e.idx} llego P{dest:02d}"
                elif dest > e.pos:
                    e.move_dir = "U"
                    e.state = "U"
                    e.pos += step
                    e.floor = int(round(e.pos))
                else:
                    e.move_dir = "D"
                    e.state = "D"
                    e.pos -= step
                    e.floor = int(round(e.pos))
            else:
                e.door_open_pct = max(0.0, e.door_open_pct - 0.1)

        self._sync_from_sim()

    def _sync_from_sim(self):
        for i, e in enumerate(self.sim_elevs):
            self.floors[i] = e.floor
            self.pos[i] = e.pos
            self.states[i] = "E" if self.emergency else e.state
            self.targets[i] = e.target
            self.door_target_pct[i] = 1.0 if (e.state in ("W", "O") and e.door_open_pct >= 0.99) else e.door_open_pct

        if self.emergency:
            self.lcd_line1_txt = "!! EMERGENCIA !!"
            self.lcd_line2_txt = "Pulsa * reanudar"
        else:
            d_ch = [self._dir_char_for(i) for i in range(3)]
            self.lcd_line1_txt = f"1:{self.floors[0]:02d}{d_ch[0]} 2:{self.floors[1]:02d}{d_ch[1]} 3:{self.floors[2]:02d}{d_ch[2]}"
            w_e = self._sim_current_waiting()
            if w_e is not None:
                if w_e.boarding_count > 0:
                    secs = max(1, int((w_e.boarding_timer * 33) / 1000) + 1)
                    self.lcd_line2_txt = f"E{w_e.idx} Q:{len(w_e.dest_stops):02d} {secs}s C=Ir"
                else:
                    self.lcd_line2_txt = f"E{w_e.idx} Dest:__ #=OK"
            else:
                self.lcd_line2_txt = self.last_status_msg[:16]

    def _dir_char_for(self, i: int) -> str:
        st = self.states[i]
        return "!" if st == "E" else ("^" if st == "U" else ("v" if st == "D" else ("O" if st in ("W", "O") else " ")))

    # ===================== BUCLE PRINCIPAL (30 FPS) =====================
    def _tick(self):
        self._blink_counter += 1
        if self._blink_counter >= 10:
            self._blink_counter = 0
            self.blink_on = not self.blink_on

        if self.connected:
            self._pump_tx()
            self._poll_serial()
            for i in range(3):
                diff = self.floors[i] - self.pos[i]
                if abs(diff) < 0.015:
                    self.pos[i] = float(self.floors[i])
                else:
                    step = diff * 0.14
                    if abs(step) < 0.018:
                        step = 0.018 if diff > 0 else -0.018
                    self.pos[i] += step
        else:
            self._sim_step()

        # Animacion suave de apertura y cierre de puertas
        for i in range(3):
            dd = self.door_target_pct[i] - self.door_open_pct[i]
            if abs(dd) <= 0.07:
                self.door_open_pct[i] = self.door_target_pct[i]
            else:
                self.door_open_pct[i] += 0.075 if dd > 0 else -0.075

        now = time.time()
        if self.algo_stage != 0 and now > self.algo_stage_until:
            self.algo_stage = 4 if any(s in ("U", "D") for s in self.states) else (
                5 if any(s in ("W", "O") for s in self.states) else 0
            )

        self.lbl_lcd1.configure(text=self.lcd_line1_txt[:16].ljust(16))
        self.lbl_lcd2.configure(text=self.lcd_line2_txt[:16].ljust(16))
        self.lbl_emg_banner.configure(text="!! EMERGENCIA !!" if self.emergency else "")
        self.lbl_kpi_enq.configure(text=f"Encoladas: {self.total_enqueued}")
        self.lbl_kpi_act.configure(text=f"Activas: {len(self.active_requests)}")
        self.lbl_kpi_deq.configure(text=f"Atendidas: {self.total_dequeued}")

        req_sig = tuple((r.req_id, r.elev, r.floor, r.kind) for r in self.active_requests)
        bld_sig = (
            tuple(round(p, 2) for p in self.pos),
            tuple(self.floors),
            tuple(self.states),
            tuple(self.targets),
            tuple(round(d, 2) for d in self.door_open_pct),
            req_sig,
            self.emergency,
            self.blink_on if (self.emergency or any(s in ("W", "O") for s in self.states)) else False,
            self.num_floors.get(),
            self.bld_canvas.winfo_width(),
            self.bld_canvas.winfo_height(),
        )
        if bld_sig != self._last_bld_sig:
            self._last_bld_sig = bld_sig
            self._draw_building()

        flash_sig = tuple((lbl if now < exp else "") for lbl, exp in self.lane_flash)
        queue_sig = (req_sig, tuple(self.targets), tuple(self.states), flash_sig, self.queue_canvas.winfo_width())
        if queue_sig != self._last_queue_sig:
            self._last_queue_sig = queue_sig
            self._draw_queue_lanes()

        algo_sig = (
            self.algo_stage,
            self.last_dispatch["summary"],
            tuple(self.floors),
            tuple(self.states),
            tuple(self.targets),
            len(self.active_requests),
            self.algo_stage_canvas.winfo_width(),
        )
        if algo_sig != self._last_algo_sig:
            self._last_algo_sig = algo_sig
            self._draw_algo_panel()

        self.root.after(33, self._tick)

    # ===================== RENDERIZADO VISUAL LIMPIO =====================
    def _draw_legend(self):
        c = self.legend_canvas
        c.delete("all")
        w = max(240, c.winfo_width())
        h = max(24, c.winfo_height())
        ym = h / 2.0

        x = 8
        c.create_text(x, ym, text="Pasillo:", fill=PAL["txt_sub"], font=("Segoe UI", 7, "bold"), anchor="w")
        x += 40
        for rk in range(4):
            col, _, wd = ring_tone("U", rk, 4)
            c.create_oval(x - 4.5, ym - 4.5, x + 4.5, ym + 4.5, outline=col, width=max(1.2, wd * 0.8))
            x += 13

        x += 8
        c.create_text(x, ym, text="Destino:", fill=PAL["txt_sub"], font=("Segoe UI", 7, "bold"), anchor="w")
        x += 44
        for rk in range(4):
            col, _, wd = ring_tone("C", rk, 4)
            c.create_oval(x - 4, ym - 4, x + 4, ym + 4, outline=col, width=max(1.2, wd * 0.8))
            x += 12

        if w >= 390:
            c.create_text(x + 6, ym, text="(1º fuerte → suave)", fill=PAL["txt_dim"],
                          font=("Segoe UI", 7), anchor="w")

        if w >= 470:
            c.create_rectangle(w - 92, ym - 4.5, w - 78, ym + 4.5, fill=PAL["cab_lit"], outline=PAL["yellow"], width=1)
            c.create_text(w - 72, ym, text="Puerta abierta", fill=PAL["txt_sub"],
                          font=("Segoe UI", 7), anchor="w")

    def _draw_building(self):
        c = self.bld_canvas
        c.delete("all")
        w = max(200, c.winfo_width())
        h = max(120, c.winfo_height())
        n = self.num_floors.get()

        compact = w < 380
        ml = 36 if compact else 48
        mr = 10 if compact else 16
        mt = 40
        mb = 12

        usable_h = max(90.0, h - mt - mb)
        fh = usable_h / n
        avail_w = max(140.0, w - ml - mr)
        min_gap = 8 if compact else 14
        shaft_w = min(156.0, max(48.0, (avail_w - 4 * min_gap) / 3.0))
        gap = max(6.0, (avail_w - 3 * shaft_w) / 4.0)

        sorted_reqs = sorted(self.active_requests, key=lambda r: r.req_id)
        total_reqs = len(sorted_reqs)
        rank_by_id = {r.req_id: idx for idx, r in enumerate(sorted_reqs)}

        # Lineas de pisos (omite etiquetas intermedias si hay muchos pisos en ventana bajita)
        floor_font = 7 if (fh < 15 or compact) else 8
        label_step = 1 if fh >= 13 else 2
        for f in range(1, n + 1):
            y_bot = h - mb - (f - 1) * fh
            y_top = y_bot - fh
            c.create_line(ml - 4, y_bot, w - mr, y_bot, fill=PAL["grid"], width=1)
            has_req_f = any(r.floor == f for r in sorted_reqs)
            if has_req_f or f == 1 or f == n or (f % label_step == 0):
                c.create_text(ml - 8, (y_top + y_bot) / 2.0, text=f"P{f:02d}",
                              fill=PAL["orange"] if has_req_f else PAL["txt_sub"],
                              font=("Consolas", floor_font, "bold"), anchor="e")

        st_long = {"I": "LIBRE", "U": "SUBE ▲", "D": "BAJA ▼", "W": "ABIERTO", "O": "LLEGÓ", "E": "EMERG!"}
        st_short = {"I": "LIB", "U": "▲", "D": "▼", "W": "●", "O": "○", "E": "!"}

        for idx in range(3):
            sx = ml + gap + idx * (shaft_w + gap)
            sx2 = sx + shaft_w
            cx = sx + shaft_w / 2.0
            st = "E" if self.emergency else self.states[idx]

            # Pozo limpio estilo simulador
            c.create_rectangle(sx, mt, sx2, h - mb,
                               fill=PAL["bg_shaft"], outline=PAL["border"], width=1.6)

            # Encabezado limpio (1 linea de estado + 3 mini LEDs integrados verde/amarillo/rojo)
            st_col = (
                PAL["red"] if st in ("E", "D") else (
                    PAL["yellow"] if st in ("W", "O") else (
                        PAL["green"] if st == "U" else PAL["txt_sub"]
                    )
                )
            )
            lbl_st = st_long[st] if shaft_w >= 104 else st_short[st]
            c.create_text(cx, 12, text=f"E{idx + 1} P{self.floors[idx]:02d} {lbl_st}",
                          fill=st_col, font=("Segoe UI", 8 if shaft_w >= 86 else 7, "bold"))

            # Mini LEDs fisicos integrados (Verde=Sube, Amarillo=Espera, Rojo=Baja/Emerg)
            g_on = (st == "U") and not self.emergency
            y_on = (st in ("W", "O")) and self.blink_on and not self.emergency
            r_on = ((st == "D") and not self.emergency) or (self.emergency and self.blink_on)
            for j, (on, c_on, c_off) in enumerate((
                (g_on, PAL["green"],  "#1c3523"),
                (y_on, PAL["yellow"], "#362f14"),
                (r_on, PAL["red"],    "#3b1b1d"),
            )):
                lx = cx + (j - 1) * 14
                c.create_oval(lx - 3.5, 24, lx + 3.5, 31,
                              fill=c_on if on else c_off, outline="")

            # ---- AROS CON DEGRADADO DE TONALIDAD ----
            elev_reqs = self._ordered_requests_for_elev(idx)
            by_floor: dict[int, list[RequestItem]] = {}
            for r in elev_reqs:
                if 1 <= r.floor <= n:
                    by_floor.setdefault(r.floor, []).append(r)

            max_r = max(5.0, min(12.5, fh * 0.40, shaft_w * 0.22))
            for fl, rlist in by_floor.items():
                ty = h - mb - (fl - 0.5) * fh
                rlist_sorted = sorted(rlist, key=lambda r: r.req_id)
                for k, req in enumerate(rlist_sorted):
                    rk = rank_by_id.get(req.req_id, 0)
                    col, halo, wd = ring_tone(req.kind, rk, total_reqs)
                    rad = max(3.5, max_r - k * 2.8)
                    if rk == 0:
                        c.create_oval(cx - rad - 2, ty - rad - 2, cx + rad + 2, ty + rad + 2,
                                      outline=halo, width=1.0)
                    c.create_oval(cx - rad, ty - rad, cx + rad, ty + rad, outline=col, width=wd)

                if shaft_w >= 72:
                    r0 = rlist_sorted[0]
                    col0, _, _ = ring_tone(r0.kind, rank_by_id.get(r0.req_id, 0), total_reqs)
                    c.create_text(cx + max_r + 4, ty, text=f"#{r0.req_id}",
                                  fill=col0, font=("Consolas", 7, "bold"), anchor="w")

            # ---- CABINA CON PUERTAS DESLIZANTES ANIMADAS ----
            cy_bot = h - mb - (self.pos[idx] - 1.0) * fh
            cy_top = cy_bot - fh
            pad_x = max(5.0, shaft_w * 0.11)
            pad_y = max(1.5, fh * 0.08)
            cab_h = max(16.0, fh - 2 * pad_y)
            cab_mid = (cy_top + cy_bot) / 2.0
            cab_y1 = max(mt + 2.0, cab_mid - cab_h / 2.0)
            cab_y2 = min(h - mb - 2.0, cab_y1 + cab_h)
            cab_x1, cab_x2 = sx + pad_x, sx2 - pad_x
            cab_w = cab_x2 - cab_x1

            # Cable
            c.create_line(cx, mt, cx, cab_y1, fill=PAL["cable"], width=1.6)

            # Cuerpo de cabina
            border = (
                PAL["red"] if st == "E" else (
                    PAL["yellow"] if st in ("W", "O") else PAL["cab_border"]
                )
            )
            c.create_rectangle(cab_x1, cab_y1, cab_x2, cab_y2,
                               fill=PAL["cab_body"], outline=border, width=1.8)

            # Puertas que se abren y cierran suavemente (interior iluminado)
            dp = self.door_open_pct[idx]
            inner_w = max(6.0, cab_w - 6.0)
            open_w = inner_w * 0.74 * dp
            if open_w > 1.5:
                c.create_rectangle(cx - open_w / 2.0, cab_y1 + 2.5, cx + open_w / 2.0, cab_y2 - 2.5,
                                   fill=PAL["cab_lit"], outline="")

            door_w = max(2.5, (inner_w - open_w) / 2.0)
            c.create_rectangle(cab_x1 + 3, cab_y1 + 2.5, cab_x1 + 3 + door_w, cab_y2 - 2.5,
                               fill=PAL["cab_door"], outline=PAL["cab_door_bd"], width=1)
            c.create_rectangle(cab_x2 - 3 - door_w, cab_y1 + 2.5, cab_x2 - 3, cab_y2 - 2.5,
                               fill=PAL["cab_door"], outline=PAL["cab_door_bd"], width=1)

            d_ch = self._dir_char_for(idx)
            lbl_sz = max(7, int(min(10, cab_h * 0.36)))
            c.create_text(cx, (cab_y1 + cab_y2) / 2.0, text=f"E{idx + 1}{d_ch}",
                          fill="#0b101c", font=("Segoe UI", lbl_sz, "bold"))

    def _draw_queue_lanes(self):
        c = self.queue_canvas
        c.delete("all")
        w = max(240, c.winfo_width())
        h = max(106, c.winfo_height())
        row_h = (h - 8) / 3.0

        sorted_all = sorted(self.active_requests, key=lambda r: r.req_id)
        total_reqs = len(sorted_all)
        rank_by_id = {r.req_id: idx for idx, r in enumerate(sorted_all)}
        now = time.time()

        for i in range(3):
            y0 = 4 + i * row_h
            y1 = y0 + row_h - 3
            ym = (y0 + y1) / 2.0
            c.create_rectangle(5, y0, w - 5, y1, fill="#131a2a", outline=PAL["grid"], width=1)

            st = self.states[i]
            e_col = PAL["green"] if st == "U" else (PAL["red"] if st in ("D", "E") else (PAL["yellow"] if st in ("W", "O") else PAL["txt_sub"]))
            c.create_text(12, ym, text=f"E{i + 1}", fill=e_col, font=("Consolas", 9, "bold"), anchor="w")

            ordered = self._ordered_requests_for_elev(i)
            x = 36
            if not ordered:
                c.create_text(x, ym, text="Cola vacía", fill=PAL["txt_dim"], font=("Consolas", 8), anchor="w")
            else:
                for pos_k, r in enumerate(ordered):
                    if x > w - 68:
                        c.create_text(x, ym, text=f"+{len(ordered) - pos_k}", fill=PAL["txt_sub"],
                                      font=("Consolas", 8, "bold"), anchor="w")
                        break
                    rk = rank_by_id.get(r.req_id, 0)
                    col, _, _ = ring_tone(r.kind, rk, total_reqs)
                    sym = "▲" if r.kind == "U" else ("▼" if r.kind == "D" else "●")
                    is_next = (pos_k == 0 and self.targets[i] == r.floor)
                    txt = f"{'▶' if is_next else ''}#{r.req_id} P{r.floor:02d}{sym}"
                    pw = max(52, len(txt) * 6 + 8)
                    c.create_rectangle(x, y0 + 4, x + pw, y1 - 4,
                                       fill="#1c2a42" if is_next else "#151f33",
                                       outline=col, width=1.8 if is_next else 1.2)
                    c.create_text(x + pw / 2.0, ym, text=txt, fill=col, font=("Consolas", 7, "bold"))
                    x += pw + 4
                    if pos_k < len(ordered) - 1 and x < w - 72:
                        c.create_text(x + 3, ym, text="→", fill=PAL["txt_dim"], font=("Consolas", 7))
                        x += 9

            fl_lbl, fl_exp = self.lane_flash[i]
            if fl_lbl and now < fl_exp:
                fl_col = PAL["cyan"] if fl_lbl.startswith("+") else PAL["green"]
                c.create_text(w - 10, ym, text=fl_lbl, fill=fl_col, font=("Consolas", 7, "bold"), anchor="e")

    def _draw_algo_panel(self):
        # 1) Etapas activas
        sc = self.algo_stage_canvas
        sc.delete("all")
        w = max(240, sc.winfo_width())
        h = max(40, sc.winfo_height())
        stages = [
            (1, "1.Pedir" if w < 330 else "1.Petición"),
            (2, "2.Costo"),
            (3, "3.Cola" if w < 330 else "3.Encolar"),
            (4, "4.LOOK"),
            (5, "5.Puerta"),
        ]
        n_st = len(stages)
        gap_s = 6
        box_w = (w - 12 - (n_st - 1) * gap_s) / n_st
        ym = h / 2.0
        for idx, (st_id, lbl) in enumerate(stages):
            x0 = 6 + idx * (box_w + gap_s)
            x1 = x0 + box_w
            active = (self.algo_stage == st_id)
            sc.create_rectangle(x0, 7, x1, h - 7,
                                fill="#1f3c5c" if active else "#131a2a",
                                outline=PAL["cyan"] if active else PAL["border"],
                                width=1.8 if active else 1)
            sc.create_text((x0 + x1) / 2.0, ym, text=lbl,
                           fill="#ffffff" if active else PAL["txt_sub"],
                           font=("Segoe UI", 7, "bold"))

        # 2) Comparacion de costos
        cc = self.algo_cost_canvas
        cc.delete("all")
        cw = max(240, cc.winfo_width())
        d = self.last_dispatch
        cc.create_text(8, 12, text=d["summary"],
                       fill=PAL["orange"] if d["chosen"] is not None else PAL["txt_sub"],
                       font=("Consolas", 8, "bold"), anchor="w")

        max_cost = max([1.0] + [c for c in d["costs"] if c < 90])
        for i in range(3):
            y = 30 + i * 26
            cost = d["costs"][i]
            chosen = (d["chosen"] == i)
            cc.create_text(8, y + 6, text=f"E{i + 1}",
                           fill=PAL["green"] if chosen else PAL["txt_soft"],
                           font=("Consolas", 8, "bold"), anchor="w")

            bx0 = 28
            bmax = max(54, cw * 0.36)
            frac = min(1.0, cost / max(4.0, max_cost)) if d["chosen"] is not None else 0.0
            bw = max(4, bmax * frac) if d["chosen"] is not None else 0
            cc.create_rectangle(bx0, y, bx0 + bmax, y + 12, fill="#121826", outline=PAL["grid"])
            if bw > 0:
                cc.create_rectangle(bx0, y, bx0 + bw, y + 12,
                                    fill=PAL["green"] if chosen else "#3b5882", outline="")

            c_txt = f"{cost:4.1f}p {'★ ' if chosen else ''}{d['reasons'][i]}"
            cc.create_text(bx0 + bmax + 8, y + 6, text=c_txt,
                           fill=PAL["green"] if chosen else PAL["txt_sub"],
                           font=("Consolas", 7, "bold" if chosen else "normal"), anchor="w")

        # 3) Reglas LOOK activas
        tb = self.algo_rules_box
        tb.configure(state="normal")
        tb.delete("1.0", "end")
        for i in range(3):
            st, fl, tgt = self.states[i], self.floors[i], self.targets[i]
            cnt = sum(1 for r in self.active_requests if r.elev == i)
            if st == "E":
                rule, tag = "EMERGENCIA: detenido por '*'", "e_open"
            elif st == "U":
                rule, tag = f"Barrido ▲ → P{tgt:02d} ({cnt} en cola)", "e_act"
            elif st == "D":
                rule, tag = f"Barrido ▼ → P{tgt:02d} ({cnt} en cola)", "e_act"
            elif st == "W":
                rule, tag = f"Puerta ABIERTA: esperando destino ({cnt} pend.)", "e_open"
            elif st == "O":
                rule, tag = "Puerta ABIERTA: descenso de pasajero", "e_open"
            else:
                rule, tag = "LIBRE: costo = distancia directa", "e_idle"
            tb.insert("end", f"E{i + 1} [P{fl:02d}] ", ("e_hdr",))
            tb.insert("end", rule + ("\n" if i < 2 else ""), (tag,))
        tb.configure(state="disabled")


if __name__ == "__main__":
    root = tk.Tk()
    app = InterfazElevadorApp(root)
    root.mainloop()
