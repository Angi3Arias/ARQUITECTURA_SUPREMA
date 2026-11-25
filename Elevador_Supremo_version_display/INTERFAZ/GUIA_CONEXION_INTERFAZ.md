# Guía Paso a Paso: Conexión de la Interfaz Metálica con Proteus y PIC18F4550 Físico

Esta guía explica en detalle cómo conectar la interfaz gráfica en Python (`interfaz_elevador.py`) tanto a la **simulación en Proteus 8** como al **circuito físico con el PIC18F4550** (programado mediante **PICkit™ 3**).

---

## 📋 Resumen del Protocolo Serial (UART)

* **Velocidad (Baud rate):** `9600 bps`
* **Formato:** `8 bits de datos`, `Sin paridad`, `1 bit de parada` (8-N-1)
* **Telemetría enviada por el PIC hacia la interfaz:**
  ```text
  S,01I,04U,12D,0,12\r\n
  ```
  *(Significado: Elevador 1 en Piso 01 Idle, Elevador 2 en Piso 04 Subiendo, Elevador 3 en Piso 12 Bajando, Alarma 0, Pisos totales 12)*.
* **Comandos enviados desde la interfaz hacia el PIC:**
  - `N:XX\n` -> Configura la cantidad de pisos (ejemplo: `N:15\n` para 15 pisos).

---

## 🔵 OPCIÓN 1: Conexión con Proteus 8 (Simulación en PC)

Proteus no puede hablar directamente por memoria con Python; necesita un **puente de puertos COM virtuales** para comunicarse con la interfaz.

```mermaid
flowchart LR
    A[Proteus 8<br>Componente COMPIM<br>Puerto COM1] <===>|Par Virtual<br>com0com| B[Interfaz Python<br>interfaz_elevador.py<br>Puerto COM2]
```

### Paso 1.1: Instalar puertos COM virtuales
1. Descarga e instala **com0com** (gratuito y de código abierto) o **Virtual Serial Port Driver (VSPD)**.
2. Crea un par enlazado, por ejemplo:
   - **Extremo A:** `COM1`
   - **Extremo B:** `COM2`
   *(Si com0com nombra los puertos como `CNCA0` y `CNCB0`, cámbiales el nombre a `COM1` y `COM2` en el Setup de com0com).*

### Paso 1.2: Configurar el componente `COMPIM` en Proteus
1. En tu diagrama de Proteus (`Elevador_Supremo_version_display.pdsprj`), busca el componente **COMPIM** (etiquetado como `P1`).
2. Conexión de pines al PIC18F4550:
   - **COMPIM Pin 2 (RXD)** ➔ Pin 25 del PIC (`RC6/TX/CK`)
   - **COMPIM Pin 3 (TXD)** ➔ Pin 26 del PIC (`RC7/RX/DT/SDO`)
3. Haz **doble clic sobre el COMPIM** y configura exactamente los siguientes parámetros:
   - **Physical Port:** `COM1`
   - **Physical Baud Rate:** `9600`
   - **Physical Data Bits:** `8`
   - **Physical Parity:** `NONE`
   - **Physical Stop Bits:** `1`
   - **Virtual Baud Rate:** `9600`
   - **Virtual Data Bits:** `8`
   - **Virtual Parity:** `NONE`
   - **Virtual Stop Bits:** `1`
4. Haz clic en **Aceptar**.

### Paso 1.3: Ejecutar la Interfaz y Conectar
1. Abre una terminal de comandos en la carpeta de la interfaz y ejecútala:
   ```bash
   python interfaz_elevador.py
   ```
2. En la barra izquierda de la interfaz:
   - En el selector de **Puerto COM**, selecciona **`COM2`**.
   - Haz clic en el botón **`CONECTAR PIC`**.
3. En Proteus, presiona el botón **Play (Iniciar Simulación)**.
4. **¡Listo!** Verás que:
   - La consola serial en la interfaz comienza a recibir las tramas del PIC.
   - Las cabinas metálicas se mueven sincronizadas con el LCD y los LEDs de Proteus.
   - Si cambias los pisos con el control deslizante a `18` y presionas **`APLICAR PISOS AL PIC18F4550`**, Proteus recibirá el comando `N:18` en vivo.

---

## 🟢 OPCIÓN 2: Conexión con el PIC18F4550 Físico (Protoboard)

Para conectar el circuito físico con la computadora, se utiliza un **módulo conversor USB a Serial TTL** (como `CP2102`, `CH340`, `FT232RL` o `PL2303`).

> [!IMPORTANT]
> El conector tipo USB soldado directamente en el diagrama de Proteus (`AU-Y1007-R` hacia pines `RC4/D-` y `RC5/D+`) corresponde a la interfaz USB nativa de bajo nivel del PIC. Para este proyecto utilizamos la comunicación estándar UART por hardware en los pines `RC6/TX` y `RC7/RX` mediante un módulo USB-TTL, que es universal, estable y compatible directamente con Python.

```mermaid
flowchart LR
    subgraph PIC18F4550 [PIC18F4550 en Protoboard]
        TX[Pin 25: RC6/TX]
        RX[Pin 26: RC7/RX]
        GND_PIC[Pines 12 y 31: VSS/GND]
    end
    subgraph USB_TTL [Módulo USB-TTL CP2102/CH340]
        RX_MOD[Pin RXD]
        TX_MOD[Pin TXD]
        GND_MOD[Pin GND]
    end
    subgraph PC [Computadora]
        GUI[interfaz_elevador.py<br>Puerto COM físico]
    end

    TX -->|Cable Cruzado| RX_MOD
    RX <--|Cable Cruzado| TX_MOD
    GND_PIC <===>|Tierra Común| GND_MOD
    USB_TTL <===>|Cable USB| PC
```

### Paso 2.1: Grabar el microcontrolador con PICkit™ 3
1. Conecta el **PICkit™ 3** a los pines ICSP del PIC18F4550:
   - **Pin 1 (MCLR/VPP):** Flecha 1 del PICkit 3.
   - **Pin 2 (VDD / +5V):** Pines 11 y 32 del PIC.
   - **Pin 3 (VSS / GND):** Pines 12 y 31 del PIC.
   - **Pin 4 (PGD):** Pin 40 (`RB7/PGD`) del PIC.
   - **Pin 5 (PGC):** Pin 39 (`RB6/PGC`) del PIC.
2. Abre **MPLAB X IPE** o **MPLAB X IDE**.
3. Carga el archivo compilado:
   `d:\UNIVERSIDAD\UNIVERSIDAD\Arq\Elevador_Supremo_version_display\MPLAB\Elevador_Supremo.hex`
4. Presiona **Program**. Una vez completado (`Programming/Verify complete`), desconecta el programador o desactiva su VPP.

### Paso 2.2: Cableado del módulo USB-TTL al PIC18F4550
Conecta los cables entre el módulo USB-TTL y el PIC18F4550 de forma **cruzada**:

| Pin del PIC18F4550 | Nombre de Pin | Conectar al Pin del Módulo USB-TTL | Función |
| :--- | :--- | :--- | :--- |
| **Pin 25** | `RC6/TX` | **RXD** (o `RX`) | El PIC transmite datos al PC |
| **Pin 26** | `RC7/RX` | **TXD** (o `TX`) | El PIC recibe comandos del PC |
| **Pines 12 y 31** | `VSS` (GND) | **GND** | **Masa común imprescindible** |

> [!CAUTION]
> **Tierra común obligatoria:** El pin `GND` del módulo USB-TTL **DEBE** unirse a la línea de tierra (`GND/VSS`) de tu protoboard. Si no comparten tierra, la señal serial se corromperá y no habrá comunicación.

### Paso 2.3: Conectar a la Interfaz Python
1. Conecta el módulo USB a cualquier puerto USB de tu computadora.
2. Abre el **Administrador de Dispositivos de Windows**:
   - Expande la sección **Puertos (COM y LPT)**.
   - Observa qué puerto fue asignado (por ejemplo, `Silicon Labs CP210x USB to UART Bridge (COM4)` o `USB-SERIAL CH340 (COM5)`).
3. Abre la interfaz:
   ```bash
   python interfaz_elevador.py
   ```
4. Haz clic en el botón de actualizar puertos (ícono `🔄`).
5. Selecciona el puerto COM correspondiente (ejemplo: `COM4`).
6. Presiona **`CONECTAR PIC`**.
7. Verás los mensajes en la consola de la interfaz indicando la conexión exitosa y la sincronización inmediata con las cabinas físicas.

---

## 🛠️ Diagnóstico y Solución de Problemas

| Síntoma | Causa Probable | Solución |
| :--- | :--- | :--- |
| **Error: `pyserial no instalado`** | No está instalada la librería en Python | Presiona el botón **Instalar** dentro de la ventana de la interfaz o ejecuta en consola: `pip install pyserial`. |
| **No aparecen puertos COM en la lista** | Driver USB-TTL no instalado o com0com no iniciado | Instala el driver del módulo (`CH340 Driver` o `CP210x Driver`) o verifica en el Administrador de Dispositivos. |
| **La interfaz conecta pero no se mueven las cabinas** | Líneas TX/RX no cruzadas o tierra desconectada | Verifica que `TX` del PIC vaya a `RX` del módulo y viceversa. Asegura que el pin `GND` esté conectado a la tierra del protoboard. En Proteus, confirma que ambos baudrates de COMPIM estén en `9600`. |
| **El microcontrolador no responde a los botones** | Pin MCLR flotante | Asegúrate de tener la resistencia pull-up de $10\text{ k}\Omega$ conectada entre el Pin 1 (`MCLR`) y $+5\text{V}$. |

---

## 📁 Archivos Relacionados
- [interfaz_elevador.py](file:///d:/UNIVERSIDAD/UNIVERSIDAD/Arq/Elevador_Supremo_version_display/interfaz/interfaz_elevador.py): Código fuente de la interfaz gráfica metálica.
- [LOGIC_TEST.c](file:///d:/UNIVERSIDAD/UNIVERSIDAD/Arq/Elevador_Supremo_version_display/MPLAB/LOGIC_TEST.c): Código firmware en C (XC8) para el PIC18F4550.
- [Elevador_Supremo.hex](file:///d:/UNIVERSIDAD/UNIVERSIDAD/Arq/Elevador_Supremo_version_display/MPLAB/Elevador_Supremo.hex): Archivo binario hexadecimal listo para grabar en Proteus y PICkit™ 3.
- [README_INTERFAZ.md](file:///d:/UNIVERSIDAD/UNIVERSIDAD/Arq/Elevador_Supremo_version_display/interfaz/README_INTERFAZ.md): Resumen rápido de la interfaz.
