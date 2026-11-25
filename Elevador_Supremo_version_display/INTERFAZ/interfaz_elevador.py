# -*- coding: utf-8 -*-
"""
ELEVADOR SUPREMO — INTERFAZ GRAFICA METALICA (PIC18F4550 + PICkit 3 + UART 9600 bps)
Diseno industrial en gris metalico con rieles, guias centrales, cabinas iluminadas
y LEDs con efecto glow, conectado en vivo al PIC18F4550 por UART.

Ejecutar:
    python interfaz_elevador.py
"""
import tkinter as tk
from tkinter import ttk, messagebox
import subprocess
import sys
import time

try:
    import serial
    import serial.tools.list_ports
    HAS_SERIAL = True
except ImportError:
    HAS_SERIAL = False


# ===================== PALETA GRIS METALICO INDUSTRIAL =====================
PAL = {
    "bg_dark":     "#1b1e23",   # Grafito oscuro exterior
    "bg_panel":    "#282c34",   # Gris acero pizarra
    "bg_card":     "#313640",   # Aluminio anodizado oscuro
    "bg_recess":   "#15181d",   # Pozo hundido
    "border_hi":   "#636c7a",   # Bisel metalico claro
    "border_mid":  "#464d59",   # Bisel medio
    "btn_bg":      "#3d434f",   # Boton acero cepillado
    "btn_hover":   "#4f5766",
    "btn_silver":  "#e6e9ef",   # Boton primario plata brillante
    "txt_primary": "#f0f3f7",   # Blanco plata
    "txt_muted":   "#a9b2c0",   # Gris aluminio
    "txt_dim":     "#737c8a",
    "rail":        "#7b8494",   # Rieles verticales
    "rail_dark":   "#3b414c",
    "cab_outer":   "#9da6b5",   # Marco exterior cabina
    "cab_inner":   "#bfc6d1",   # Cuerpo aluminio pulido
    "cab_edge":    "#e2e7ef",   # Borde iluminado cabina
    "cab_door":    "#8b94a3",   # Hojas de puerta
    "led_green":   "#2aff64",
    "led_yellow":  "#ffd028",
    "led_red":     "#ff3b3b",
    "led_cyan":    "#38d6ff",
    "led_off":     "#262a32",
}


class InterfazElevadorApp:
    def __init__(self, root: tk.Tk):
        self.root = root
        self.root.title("Elevador Supremo — Consola Metálica (PIC18F4550 / PICkit 3)")
        self.root.geometry("1220x760")
        self.root.minsize(1100, 700)
        self.root.configure(bg=PAL["bg_dark"])

        self.ser = None
        self.connected = False
        self.demo_mode = tk.BooleanVar(value=False)

        self.num_floors = tk.IntVar(value=12)
        self.port_var = tk.StringVar(value="")
        self.baud_var = tk.StringVar(value="9600")

        # Estado en vivo recibido del PIC18F4550: S,01I,06U,12D,0,12
        self.floors = [1, 6, 12]
        self.pos = [1.0, 6.0, 12.0]
        self.states = ["I", "I", "I"]   # I=Libre, U=Sube, D=Baja, W=Espera, E=Emergencia
        self.emergency = False
        self.blink_on = True
        self.rx_buffer = ""

        self._configure_styles()
        self._build_ui()
        self._refresh_ports()
        self._log("Interfaz metálica lista. Programa el PIC18F4550 con PICkit 3 y conecta el puerto COM a 9600 bps.")
        self._tick()

    def _configure_styles(self):
        style = ttk.Style()
        style.theme_use("clam")
        style.configure(
            "Metal.TCombobox",
            fieldbackground=PAL["bg_recess"],
            background=PAL["btn_bg"],
            foreground=PAL["txt_primary"],
            bordercolor=PAL["border_hi"],
            arrowcolor=PAL["txt_primary"],
        )

    # ===================== CONSTRUCCION DE INTERFAZ =====================
    def _build_ui(self):
        # Barra superior metalica
        top = tk.Frame(
            self.root, bg=PAL["bg_panel"], height=64,
            highlightbackground=PAL["border_hi"], highlightthickness=1
        )
        top.pack(fill="x", side="top", padx=8, pady=(8, 4))
        top.pack_propagate(False)

        # Icono de elevador a la izquierda
        ico = tk.Canvas(top, width=44, height=44, bg=PAL["bg_panel"], highlightthickness=0)
        ico.pack(side="left", padx=(14, 10))
        ico.create_rectangle(4, 4, 40, 40, fill=PAL["bg_recess"], outline=PAL["border_hi"], width=1.5)
        ico.create_rectangle(9, 10, 22, 36, fill=PAL["btn_bg"], outline=PAL["txt_muted"])
        ico.create_rectangle(22, 10, 35, 36, fill=PAL["btn_bg"], outline=PAL["txt_muted"])
        ico.create_text(22, 7, text="▲▼", fill=PAL["txt_primary"], font=("Segoe UI", 6, "bold"))

        tk.Label(
            top, text="ELEVADOR SUPREMO", font=("Segoe UI", 17, "bold"),
            fg=PAL["txt_primary"], bg=PAL["bg_panel"]
        ).pack(side="left", padx=(0, 12))
        tk.Label(
            top, text="CONSOLA DE CONTROL EN VIVO • PIC18F4550 + PICkit™ 3",
            font=("Segoe UI", 9, "bold"), fg=PAL["txt_muted"], bg=PAL["bg_panel"]
        ).pack(side="left", pady=(4, 0))

        # Estado de conexion a la derecha
        status_box = tk.Frame(top, bg=PAL["bg_panel"])
        status_box.pack(side="right", padx=18)

        mon_ico = tk.Canvas(status_box, width=24, height=20, bg=PAL["bg_panel"], highlightthickness=0)
        mon_ico.pack(side="left", padx=(0, 8))
        mon_ico.create_rectangle(2, 2, 22, 15, fill=PAL["bg_recess"], outline=PAL["txt_muted"], width=1.5)
        mon_ico.create_line(5, 10, 9, 10, 11, 6, 14, 12, 16, 8, 19, 8, fill=PAL["txt_muted"], width=1.4)
        mon_ico.create_line(8, 18, 16, 18, fill=PAL["txt_muted"], width=2)

        self.conn_dot = tk.Canvas(status_box, width=18, height=18, bg=PAL["bg_panel"], highlightthickness=0)
        self.conn_dot.pack(side="left", padx=(0, 6))
        self.conn_dot.create_oval(2, 2, 16, 16, fill="#441818", outline="", tags="halo")
        self.conn_dot.create_oval(4, 4, 14, 14, fill=PAL["led_red"], outline="", tags="dot")

        self.lbl_conn = tk.Label(
            status_box, text="DESCONECTADO", font=("Consolas", 10, "bold"),
            fg=PAL["txt_muted"], bg=PAL["bg_panel"]
        )
        self.lbl_conn.pack(side="left")

        # Cuerpo principal
        main = tk.Frame(self.root, bg=PAL["bg_dark"])
        main.pack(fill="both", expand=True, padx=8, pady=(4, 8))

        # ---------------- PANEL IZQUIERDO ----------------
        left = tk.Frame(
            main, bg=PAL["bg_panel"], width=420,
            highlightbackground=PAL["border_hi"], highlightthickness=1
        )
        left.pack(side="left", fill="y", padx=(0, 8))
        left.pack_propagate(False)

        # 1) CONEXION HARDWARE
        f_con = self._make_card(left, "CONEXIÓN HARDWARE (UART 9600 BPS)", "HARDWARE INTERFACE")

        row_p = tk.Frame(f_con, bg=PAL["bg_card"])
        row_p.pack(fill="x", pady=(2, 8))
        tk.Label(row_p, text="Puerto COM:", font=("Segoe UI", 9, "bold"),
                 fg=PAL["txt_primary"], bg=PAL["bg_card"]).pack(side="left")
        self.cb_port = ttk.Combobox(row_p, textvariable=self.port_var, state="readonly",
                                    width=15, style="Metal.TCombobox")
        self.cb_port.pack(side="left", padx=8)
        self._metal_btn(row_p, "↻", self._refresh_ports, width=3).pack(side="left")

        row_btns = tk.Frame(f_con, bg=PAL["bg_card"])
        row_btns.pack(fill="x", pady=(0, 4))
        self.btn_connect = tk.Button(
            row_btns, text="CONECTAR PIC", command=self._toggle_connect,
            bg=PAL["btn_silver"], fg="#181b20",
            activebackground="#ffffff", activeforeground="#000000",
            font=("Segoe UI", 10, "bold"), relief="raised", bd=1, pady=6, cursor="hand2"
        )
        self.btn_connect.pack(side="left", fill="x", expand=True, padx=(0, 10))

        tk.Checkbutton(
            row_btns, text="Modo Demo", variable=self.demo_mode,
            command=self._on_demo_toggle,
            fg=PAL["txt_primary"], bg=PAL["bg_card"], selectcolor=PAL["bg_recess"],
            activebackground=PAL["bg_card"], activeforeground="#fff",
            font=("Segoe UI", 9, "bold")
        ).pack(side="right")

        if not HAS_SERIAL:
            warn = tk.Frame(f_con, bg=PAL["bg_recess"], highlightbackground=PAL["border_mid"], highlightthickness=1)
            warn.pack(fill="x", pady=(6, 0))
            tk.Label(warn, text="pyserial no instalado (solo lectura COM requiere pyserial)",
                     font=("Segoe UI", 8), fg=PAL["txt_muted"], bg=PAL["bg_recess"]).pack(side="left", padx=8, pady=5)
            tk.Button(
                warn, text="Instalar", command=self._install_pyserial,
                bg=PAL["bg_recess"], fg=PAL["txt_primary"], relief="flat",
                font=("Segoe UI", 8, "bold", "underline"), cursor="hand2"
            ).pack(side="right", padx=6)

        # 2) CONFIGURACION DEL EDIFICIO
        f_pisos = self._make_card(left, "CONFIGURACIÓN DEL EDIFICIO", "N = 4..20 PISOS")

        tk.Label(f_pisos, text="Cantidad de pisos activos (N = 4 a 20):",
                 font=("Segoe UI", 9), fg=PAL["txt_muted"], bg=PAL["bg_card"]).pack(anchor="w")

        row_n = tk.Frame(f_pisos, bg=PAL["bg_card"])
        row_n.pack(fill="x", pady=(8, 8))

        self._metal_btn(row_n, "−", lambda: self._step_floors(-1), width=3).pack(side="left")
        self.lbl_n_big = tk.Label(
            row_n, text="12", font=("Consolas", 22, "bold"),
            fg="#ffffff", bg=PAL["bg_recess"], width=4,
            highlightbackground=PAL["border_hi"], highlightthickness=1
        )
        self.lbl_n_big.pack(side="left", padx=8)
        self._metal_btn(row_n, "+", lambda: self._step_floors(1), width=3).pack(side="left")

        # Deslizador con regla graduada metalica
        slider_box = tk.Frame(row_n, bg=PAL["bg_card"])
        slider_box.pack(side="right", fill="x", expand=True, padx=(10, 0))
        self.scale_n = tk.Scale(
            slider_box, from_=4, to=20, orient="horizontal",
            variable=self.num_floors, command=self._on_scale_n,
            bg=PAL["bg_card"], fg=PAL["txt_primary"],
            troughcolor=PAL["bg_recess"], activebackground=PAL["btn_silver"],
            highlightthickness=0, showvalue=False, sliderlength=20, width=14
        )
        self.scale_n.pack(fill="x")
        ticks_cv = tk.Canvas(slider_box, height=10, bg=PAL["bg_card"], highlightthickness=0)
        ticks_cv.pack(fill="x")
        ticks_cv.bind("<Configure>", lambda e: self._draw_ruler_ticks(ticks_cv, e.width))

        self._metal_btn(
            f_pisos, "APLICAR PISOS AL PIC18F4550  (N:XX)",
            self._send_floors_to_pic, bg=PAL["btn_bg"], fg=PAL["txt_primary"]
        ).pack(fill="x", pady=(2, 2))

        # 3) ESTADO EN VIVO (9 LEDs FISICOS)
        f_leds = self._make_card(left, "ESTADO EN VIVO (9 LEDs FÍSICOS)", "MONITOR DE SEGURIDAD")
        self.led_canvas = tk.Canvas(
            f_leds, height=82, bg=PAL["bg_recess"],
            highlightbackground=PAL["border_mid"], highlightthickness=1
        )
        self.led_canvas.pack(fill="x")

        # 4) MONITOR SERIAL UART
        f_log = self._make_card(left, "MONITOR SERIAL UART", "SYSTEM STATUS", expand=True)
        self.log_box = tk.Text(
            f_log, bg=PAL["bg_recess"], fg="#cdd5e0",
            font=("Consolas", 8), relief="flat", state="disabled", height=7,
            highlightbackground=PAL["border_mid"], highlightthickness=1
        )
        self.log_box.pack(fill="both", expand=True)

        # ---------------- PANEL DERECHO: TORRE METALICA EN VIVO ----------------
        right = tk.Frame(
            main, bg=PAL["bg_panel"],
            highlightbackground=PAL["border_hi"], highlightthickness=1
        )
        right.pack(side="left", fill="both", expand=True)

        hdr_r = tk.Frame(right, bg=PAL["bg_panel"])
        hdr_r.pack(fill="x", padx=14, pady=(10, 6))
        tk.Label(
            hdr_r, text="TORRE DE ELEVADORES EN TIEMPO REAL",
            font=("Segoe UI", 11, "bold"), fg=PAL["txt_primary"], bg=PAL["bg_panel"]
        ).pack(side="left")
        self.lbl_emg_banner = tk.Label(
            hdr_r, text="", font=("Consolas", 10, "bold"),
            fg=PAL["led_red"], bg=PAL["bg_panel"]
        )
        self.lbl_emg_banner.pack(side="right")

        self.bld_canvas = tk.Canvas(
            right, bg=PAL["bg_recess"],
            highlightbackground=PAL["border_hi"], highlightthickness=1
        )
        self.bld_canvas.pack(fill="both", expand=True, padx=14, pady=(0, 14))
        self.bld_canvas.bind("<Configure>", lambda _e: self._draw_building())

    def _draw_ruler_ticks(self, cv: tk.Canvas, w: int):
        cv.delete("all")
        for i in range(17):
            x = 10 + (w - 20) * (i / 16)
            h = 7 if i % 4 == 0 else 4
            cv.create_line(x, 0, x, h, fill=PAL["txt_dim"], width=1)

    def _make_card(self, parent, title: str, subtitle: str = "", expand: bool = False):
        outer = tk.Frame(
            parent, bg=PAL["bg_card"], padx=10, pady=8,
            highlightbackground=PAL["border_hi"], highlightthickness=1
        )
        outer.pack(
            fill="both" if expand else "x", expand=expand,
            padx=10, pady=(10, 0) if not expand else (10, 10)
        )
        hdr = tk.Frame(outer, bg=PAL["bg_card"])
        hdr.pack(fill="x", pady=(0, 6))
        tk.Label(hdr, text=title, font=("Segoe UI", 8, "bold"),
                 fg=PAL["txt_primary"], bg=PAL["bg_card"]).pack(side="left")
        if subtitle:
            tk.Label(hdr, text=subtitle, font=("Segoe UI", 7),
                     fg=PAL["txt_dim"], bg=PAL["bg_card"]).pack(side="right")
        return outer

    def _metal_btn(self, parent, text, cmd, bg=None, fg=None, width=None):
        kw = dict(
            text=text, command=cmd,
            bg=bg or PAL["btn_bg"], fg=fg or PAL["txt_primary"],
            activebackground=PAL["btn_hover"], activeforeground="#ffffff",
            font=("Segoe UI", 9, "bold"), relief="raised", bd=1,
            pady=5, cursor="hand2"
        )
        if width is not None:
            kw["width"] = width
        return tk.Button(parent, **kw)

    def _log(self, msg: str):
        ts = time.strftime("%H:%M:%S")
        self.log_box.configure(state="normal")
        self.log_box.insert("1.0", f"[{ts}] {msg}\n")
        self.log_box.configure(state="disabled")

    # ===================== CONTROL DE PISOS Y SERIAL =====================
    def _step_floors(self, delta: int):
        n = max(4, min(20, self.num_floors.get() + delta))
        self.num_floors.set(n)
        self.lbl_n_big.configure(text=f"{n:02d}")
        self._clamp_positions()
        self._draw_building()

    def _on_scale_n(self, _val=None):
        n = self.num_floors.get()
        self.lbl_n_big.configure(text=f"{n:02d}")
        self._clamp_positions()
        self._draw_building()

    def _clamp_positions(self):
        n = self.num_floors.get()
        for i in range(3):
            if self.floors[i] > n:
                self.floors[i] = n
            if self.pos[i] > n:
                self.pos[i] = float(n)

    def _send_floors_to_pic(self):
        n = self.num_floors.get()
        self._clamp_positions()
        self._draw_building()
        if self.connected and self.ser is not None:
            try:
                self.ser.write(f"N:{n:02d}\n".encode("ascii"))
                self._log(f"TX -> Enviado al PIC18F4550: N:{n:02d} ({n} pisos activos).")
            except Exception as ex:
                self._log(f"Error al enviar N:{n:02d}: {ex}")
        else:
            self._log(f"Configurado localmente a N = {n} pisos (conecta el puerto COM para enviarlo al PIC).")

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
            messagebox.showinfo("pyserial instalado", "pyserial se instaló correctamente. Reinicia esta interfaz para usarlo.")
        except Exception as ex:
            messagebox.showerror("Error", f"No se pudo instalar pyserial:\n{ex}")

    def _set_conn_status(self, text: str, dot_col: str, halo_col: str, txt_col: str):
        self.conn_dot.itemconfig("halo", fill=halo_col)
        self.conn_dot.itemconfig("dot", fill=dot_col)
        self.lbl_conn.configure(text=text, fg=txt_col)

    def _toggle_connect(self):
        if self.connected:
            self._disconnect()
            return
        if not HAS_SERIAL:
            messagebox.showwarning("Falta pyserial", "Instala pyserial primero o activa 'Modo Demo'.")
            return
        port = self.port_var.get()
        if not port or "Sin " in port:
            messagebox.showinfo("Puerto COM", "Conecta tu módulo USB-TTL (o com0com de Proteus) y presiona '↻'.")
            return
        try:
            self.ser = serial.Serial(port, int(self.baud_var.get()), timeout=0.02)
            self.connected = True
            self.demo_mode.set(False)
            self.btn_connect.configure(text="DESCONECTAR", bg="#8c3333", fg="#ffffff")
            self._set_conn_status(f"CONECTADO ({port})", PAL["led_green"], "#164a26", PAL["led_green"])
            self._log(f"Conectado a {port} @ 9600 bps. Escuchando al PIC18F4550...")
            self._send_floors_to_pic()
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
        self.btn_connect.configure(text="CONECTAR PIC", bg=PAL["btn_silver"], fg="#181b20")
        self._set_conn_status("DESCONECTADO", PAL["led_red"], "#441818", PAL["txt_muted"])
        self._log("Puerto serial desconectado.")

    def _on_demo_toggle(self):
        if self.demo_mode.get():
            if self.connected:
                self._disconnect()
            self._set_conn_status("MODO DEMO", PAL["led_yellow"], "#4a3e12", PAL["led_yellow"])
            self._log("Modo Demo activado para probar la vista metálica sin hardware conectado.")
        else:
            self._set_conn_status("DESCONECTADO", PAL["led_red"], "#441818", PAL["txt_muted"])

    # ===================== LECTURA UART Y ANIMACION =====================
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
                    self._parse_telemetry(line.strip())
        except Exception as ex:
            self._log(f"Pérdida de conexión: {ex}")
            self._disconnect()

    def _parse_telemetry(self, line: str):
        if not line.startswith("S,"):
            return
        parts = line.split(",")
        if len(parts) < 5:
            return
        try:
            for i in range(3):
                tok = parts[1 + i].strip()
                fl = int(tok[:2])
                st = tok[2] if len(tok) >= 3 else "I"
                self.floors[i] = max(1, min(20, fl))
                self.states[i] = st
            self.emergency = (parts[4].strip() == "1")
            if len(parts) >= 6:
                pic_n = int(parts[5].strip())
                if 4 <= pic_n <= 20 and pic_n != self.num_floors.get():
                    self.num_floors.set(pic_n)
                    self.lbl_n_big.configure(text=f"{pic_n:02d}")
        except ValueError:
            pass

    def _tick(self):
        self.blink_on = not self.blink_on
        self._poll_serial()

        if self.demo_mode.get():
            n = self.num_floors.get()
            t = int(time.time()) % (n * 2)
            self.floors[0] = 1 + (t if t < n else (2 * n - t - 1))
            self.states[0] = "U" if t < n else "D"
            t2 = (int(time.time()) + n // 2) % (n * 2)
            self.floors[1] = 1 + (t2 if t2 < n else (2 * n - t2 - 1))
            self.states[1] = "U" if t2 < n else "D"
            self.floors[2] = n
            self.states[2] = "I"

        for i in range(3):
            diff = self.floors[i] - self.pos[i]
            if abs(diff) < 0.05:
                self.pos[i] = float(self.floors[i])
            else:
                self.pos[i] += diff * 0.35

        self.lbl_emg_banner.configure(
            text="!! PARO DE EMERGENCIA !!" if self.emergency else ""
        )
        self._draw_leds()
        self._draw_building()
        self.root.after(150, self._tick)

    def _draw_glow_led(self, c: tk.Canvas, cx: float, cy: float, on: bool, col: str, halo1: str, halo2: str):
        if on:
            c.create_oval(cx - 14, cy - 14, cx + 14, cy + 14, fill=halo2, outline="")
            c.create_oval(cx - 11, cy - 11, cx + 11, cy + 11, fill=halo1, outline="")
            c.create_oval(cx - 8, cy - 8, cx + 8, cy + 8, fill=col, outline="#ffffff", width=1)
        else:
            c.create_oval(cx - 8, cy - 8, cx + 8, cy + 8, fill=PAL["led_off"], outline=PAL["border_mid"], width=1)

    def _draw_leds(self):
        c = self.led_canvas
        c.delete("all")
        w = max(360, c.winfo_width())
        card_w = (w - 24) / 3
        for i in range(3):
            x0 = 6 + i * (card_w + 6)
            x1 = x0 + card_w
            cx = (x0 + x1) / 2
            c.create_rectangle(x0, 6, x1, 76, fill="#1c2027", outline=PAL["border_mid"], width=1)

            st = self.states[i]
            g = (st == "U") and not self.emergency
            y = (st == "W") and self.blink_on and not self.emergency
            r = ((st == "D") and not self.emergency) or (self.emergency and self.blink_on)

            c.create_text(cx, 18, text=f"ELEVADOR {i + 1}", fill=PAL["txt_muted"], font=("Segoe UI", 8, "bold"))
            self._draw_glow_led(c, cx - 32, 42, g, PAL["led_green"],  "#1d6b34", "#153820")
            self._draw_glow_led(c, cx,      42, y, PAL["led_yellow"], "#6e5a16", "#3b3010")
            self._draw_glow_led(c, cx + 32, 42, r, PAL["led_red"],    "#731c1c", "#3d1212")

            c.create_text(cx - 32, 64, text="SUB", fill=PAL["led_green"] if g else PAL["txt_dim"], font=("Consolas", 7, "bold" if g else "normal"))
            c.create_text(cx,      64, text="ESP", fill=PAL["led_yellow"] if y else PAL["txt_dim"], font=("Consolas", 7, "bold" if y else "normal"))
            c.create_text(cx + 32, 64, text="BAJ", fill=PAL["led_red"] if r else PAL["txt_dim"], font=("Consolas", 7, "bold" if r else "normal"))

    def _draw_building(self):
        c = self.bld_canvas
        c.delete("all")
        w = max(480, c.winfo_width())
        h = max(420, c.winfo_height())
        n = self.num_floors.get()

        ml, mr, mt, mb = 60, 22, 44, 22
        fh = (h - mt - mb) / n
        shaft_w = min(176, (w - ml - mr - 72) / 3)
        gap = (w - ml - mr - 3 * shaft_w) / 4

        # Lineas horizontales y etiquetas de pisos
        for f in range(1, n + 1):
            yb = h - mb - (f - 1) * fh
            yt = yb - fh
            c.create_line(ml - 8, yb, w - mr, yb, fill="#252a33", width=1)
            c.create_text(ml - 14, (yt + yb) / 2, text=f"P{f:02d}",
                          fill=PAL["txt_muted"], font=("Consolas", 9, "bold"), anchor="e")

        st_txt = {"I": "LIBRE", "U": "SUBIENDO ▲", "D": "BAJANDO ▼", "W": "ESPERA ●", "E": "EMERGENCIA !"}
        st_col = {"I": PAL["led_cyan"], "U": PAL["led_green"], "D": PAL["led_red"],
                  "W": PAL["led_yellow"], "E": PAL["led_red"]}

        for i in range(3):
            sx = ml + gap + i * (shaft_w + gap)
            sx2 = sx + shaft_w
            cx = (sx + sx2) / 2

            # Fondo del pozo
            c.create_rectangle(sx, mt, sx2, h - mb, fill="#12151a", outline=PAL["border_mid"], width=2)

            # Rieles metalicos laterales (izquierdo y derecho)
            for rx in (sx + 6, sx2 - 12):
                c.create_rectangle(rx, mt + 2, rx + 6, h - mb - 2, fill=PAL["rail_dark"], outline=PAL["rail"], width=1)
                c.create_line(rx + 3, mt + 2, rx + 3, h - mb - 2, fill=PAL["rail"], width=1)

            # Escalerilla / guia central metalica
            c.create_line(cx - 7, mt + 2, cx - 7, h - mb - 2, fill="#3c434f", width=2)
            c.create_line(cx + 7, mt + 2, cx + 7, h - mb - 2, fill="#3c434f", width=2)
            step_px = max(8, int(fh / 3))
            y_rung = int(mt + 6)
            while y_rung < h - mb - 4:
                c.create_line(cx - 7, y_rung, cx + 7, y_rung, fill="#4e5766", width=1.5)
                y_rung += step_px

            # Encabezado arriba de cada pozo
            st = "E" if self.emergency else self.states[i]
            col_st = st_col.get(st, PAL["txt_muted"])
            c.create_text(cx, 20, text=f"E{i + 1} [P{self.floors[i]:02d}] {st_txt.get(st, '')}",
                          fill=col_st, font=("Segoe UI", 9, "bold"))

            # Cabina metalica detallada (al menos 38px de alto para que siempre se vea robusta)
            cab_h = max(38.0, min(fh * 1.4, 72.0))
            yb_pos = h - mb - (self.pos[i] - 0.5) * fh
            y1 = max(mt + 4, yb_pos - cab_h / 2)
            y2 = min(h - mb - 4, y1 + cab_h)
            x1, x2 = sx + 18, sx2 - 18

            # Halo luminoso segun direccion/estado
            glow_col = {"U": "#1d7a36", "D": "#8a2020", "W": "#8a6d14", "I": "#1a6882", "E": "#9e1c1c"}.get(st, "#3a404a")
            c.create_rectangle(x1 - 3, y1 - 3, x2 + 3, y2 + 3, fill="", outline=glow_col, width=3)
            c.create_rectangle(x1 + 8, y1 - 5, x2 - 8, y1, fill=col_st, outline="")

            # Cuerpo de la cabina en aluminio pulido
            c.create_rectangle(x1, y1, x2, y2, fill=PAL["cab_outer"], outline=PAL["cab_edge"], width=1.5)
            c.create_rectangle(x1 + 4, y1 + 4, x2 - 4, y2 - 4, fill=PAL["cab_inner"], outline="#68707d", width=1)

            # Letrero superior de cabina (E1 ▲ / E2 ▼ / E3 ▼)
            arrow = "▲" if st == "U" else ("▼" if st == "D" else ("!" if st == "E" else "●"))
            c.create_text(cx - 8, y1 + 11, text=f"E{i + 1}", fill="#181b20", font=("Segoe UI", 9, "bold"))
            c.create_text(cx + 12, y1 + 11, text=arrow, fill=col_st if st != "I" else "#1f789c", font=("Segoe UI", 9, "bold"))

            # Puertas metalicas dobles con manijas
            dy1, dy2 = y1 + 20, y2 - 5
            if dy2 > dy1 + 8:
                c.create_rectangle(x1 + 10, dy1, cx - 1, dy2, fill=PAL["cab_door"], outline="#525a66")
                c.create_rectangle(cx + 1, dy1, x2 - 10, dy2, fill=PAL["cab_door"], outline="#525a66")
                c.create_line(cx - 4, dy1 + 5, cx - 4, dy2 - 5, fill="#2d323b", width=1.5)
                c.create_line(cx + 4, dy1 + 5, cx + 4, dy2 - 5, fill="#2d323b", width=1.5)


if __name__ == "__main__":
    root = tk.Tk()
    app = InterfazElevadorApp(root)
    root.mainloop()
