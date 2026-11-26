# Interfaz Gráfica en Vivo — Elevador Supremo (`PIC18F4550` + `UART 9600 bps`)

Interfaz estilo **simulador** conectada en tiempo real al **PIC18F4550** (Proteus `COMPIM` o módulo USB-TTL a `9600 bps`), con modo **Simulación Local** integrado para pruebas rápidas sin hardware.

---

## Novedades y Correcciones

- **Corrección ante ráfagas de peticiones y cambio de pisos ($N = 4 \text{ a } 20$):**
  - En el firmware (`MPLAB/LOGIC_TEST.c` $\rightarrow$ `MPLAB/Elevador_Supremo.hex`): recepción `UART` por interrupción (`64 B`), transmisión no bloqueante (`256 B`), máscara de bits en paradas (`BIT_UP | BIT_DOWN | BIT_DEST`), cola FIFO para elevadores esperando destino (`ESPERA_DEST`), balanceo de carga en el cálculo de costo y poda/recalculo seguro al cambiar `N`.
  - En la interfaz (`interfaz_elevador.py`): cola de transmisión serializada sin solapamiento de bytes, sincronización protegida de `N` pisos y recorte seguro de paradas fuera de rango.
- **Aros con degradado de tonalidad por orden de petición:**
  - Cada petición dibuja un aro en el piso correspondiente (`Naranja` = llamada de pasillo, `Cian` = destino de cabina).
  - La primera petición activa muestra el **tono más fuerte** y conforme se acumulan peticiones la tonalidad va bajando progresivamente (con etiqueta `#orden` y aros concéntricos si coinciden varias peticiones en el mismo piso).
- **Animación de apertura y cierre de puertas:**
  - Las hojas de puerta de cada cabina se deslizan mostrando el interior iluminado al abrirse (`ABORDANDO` / `LLEGÓ`) y al cerrarse suavemente antes de partir.
- **Sección de Flujo de Peticiones (Encolado / Desencolado):**
  - Carriles visuales de las colas activas por elevador (`E1`, `E2`, `E3`), contadores (`Encoladas`, `En Cola`, `Desencoladas`) e historial en vivo con códigos de color.
- **Sección del Algoritmo LOOK Colectivo:**
  - Diagrama de etapas en vivo (`Petición → Costo → Encolar → LOOK → Puerta/Deq`), barras comparativas de costo entre `E1`, `E2` y `E3` en el último despacho, y regla activa de cada elevador.

---

## Cómo abrirla

```bash
python interfaz_elevador.py
```

Para la conexión física o con Proteus 8 (`COMPIM` + `com0com`), consulta **[GUIA_CONEXION_INTERFAZ.md](file:///d:/UNIVERSIDAD/UNIVERSIDAD/Arq/Elevador_Supremo_version_display/INTERFAZ/GUIA_CONEXION_INTERFAZ.md)**.
