# Interfaz Gráfica Metálica — Elevador Supremo (`PIC18F4550` + `PICkit™ 3`)

Esta interfaz en paleta **gris metálico** se conecta en tiempo real al **PIC18F4550** (programado previamente con tu **PICkit™ 3** usando `MPLAB/Elevador_Supremo.hex`) a través de comunicación serial `UART` (`9600 bps`).

---

## 📖 Guía Detallada de Conexión
Para ver el diagrama de conexiones paso a paso, pines del PIC18F4550, configuración de `COMPIM` en Proteus 8 y puente virtual con `com0com`, consulta:
👉 **[GUIA_CONEXION_INTERFAZ.md](file:///d:/UNIVERSIDAD/UNIVERSIDAD/Arq/Elevador_Supremo_version_display/interfaz/GUIA_CONEXION_INTERFAZ.md)**

---

## Qué permite hacer
- **Configurar la cantidad de pisos ($N = 4 \text{ a } 20$):** mueve el deslizador o usa los botones `+` / `−` y presiona **`APLICAR PISOS AL PIC18F4550`** para enviar `N:XX` al microcontrolador en vivo.
- **Monitoreo en vivo:** muestra la posición exacta de los 3 elevadores, sus **9 LEDs físicos** (Verde = Sube, Amarillo = Espera, Rojo = Baja) y alertas de emergencia (`*`).
- **Modo Demo:** permite probar la interfaz aunque todavía no tengas conectado el hardware.

---

## Cómo abrirla
```bash
python interfaz_elevador.py
```
*(Si `pyserial` no está instalado aún, la propia ventana incluye un botón directo de **Instalar** o puedes ejecutar `pip install pyserial`).*
