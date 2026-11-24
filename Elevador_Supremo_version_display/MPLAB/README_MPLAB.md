# Código MPLAB X (XC8) — Elevador Supremo (`PIC18F4550`)

Esta carpeta contiene los archivos listos para tu proyecto **`TEST_20`** en **MPLAB X IDE** y el archivo `.hex` precompilado para **Proteus 8** / **PICkit™ 3**:

| Archivo | Dónde va en tu proyecto `TEST_20` |
| :--- | :--- |
| `config.h` | Carpeta **`Header Files`** $\rightarrow$ `config.h` |
| `LOGIC_TEST.c` | Carpeta **`Source Files`** $\rightarrow$ `LOGIC_TEST.c` |
| `Elevador_Supremo.hex` | Listo para cargar directo en `U1` (`PIC18F4550`) en Proteus 8 (`Processor Clock = 8MHz`) |

---

## Cómo cargarlo en `TEST_20` (MPLAB X IDE)

1. Abre **`config.h`** dentro de `TEST_20 -> Header Files` y reemplaza su contenido con el de `MPLAB/config.h`.
2. Abre **`LOGIC_TEST.c`** dentro de `TEST_20 -> Source Files` y reemplaza su contenido con el de `MPLAB/LOGIC_TEST.c`.
3. *(Opcional)* Si quieres cambiar el número de pisos $N$ (por defecto **`12`**, soporta hasta `20`), edita la línea `#define NUM_PISOS_DEFAULT 12U` al inicio de `LOGIC_TEST.c`.
4. Presiona **Clean and Build Main Project** (icono del martillo con escoba) para generar el `.hex` en `TEST_20.X/dist/default/production/TEST_20.X.production.hex` (o carga directamente `MPLAB/Elevador_Supremo.hex` en Proteus).

---

## Resumen de la Lógica Integrada en el PIC18F4550

- **Oscilador interno a `8 MHz`** (`OSCCON = 8 MHz`) y conversión total de pines a **digitales** (`ADCON1 = 0x0F`, `CMCON = 0x07`, `SPPCON = 0x00`), compatible con tu `config.h` (`PBADEN = ON`, `MCLRE = OFF`, `LVP = OFF`).
- **Teclado Matricial 4x4 (`RA0..RA3` / `RB0..RB3`):**
  - **`A`** $\rightarrow$ Modo *Selección de piso* (`1..N`) + **`#`** confirma (`ERROR:No existe!` si está fuera de rango). Ningún elevador se mueve todavía.
  - **`D`** $\rightarrow$ Borrar último dígito ingresado (o cancelar selección).
  - **`B`** $\rightarrow$ Abrir / extender puerta abierta.
  - **`C`** $\rightarrow$ Cerrar puerta manualmente (y arrancar de inmediato si ya hay destinos en cola).
  - **`*`** $\rightarrow$ **Paro de Emergencia** inmediato: congela los 3 elevadores, parpadean los 3 LEDs rojos y suena el `BUZZER` 5 V (`RB5`). Pulsar `*` de nuevo reanuda el servicio.
- **2 Botones Físicos de Pasillo (`RA4 = SUBIR`, `RA5 = BAJAR`):**
  - Despacho óptimo colectivo (**algoritmo LOOK**): evalúa a los **3 elevadores (libres y en movimiento)** para que el más cercano (incluyendo uno que ya venga de paso en el mismo sentido) recoja al usuario.
- **Encolado múltiple de destinos simultáneos:**
  - Al llegar por usuarios, abre puerta (**LED Amarillo parpadea en espera**) y **no cierra** hasta que se teclee al menos un destino + `#` (sin presionar `A`).
  - Al ingresar el primer destino, abre una ventana de **4.5 s** (`E1 Cola:2 4s C`) reiniciable con cada dígito para que **varios usuarios que subieron juntos** encolen todos sus pisos antes de partir (o presionen `C` para salir al instante).
- **UART 9600 bps (`RC6/TX`, `RC7/RX`):** 100% no bloqueante (funciona igual aunque aún no actives los puertos `COM` en Proteus).
