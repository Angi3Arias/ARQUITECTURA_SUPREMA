# Potenciómetro Supremo

```c
// --- FUN: Config ADC

void ADC_Init(void) {
    ADCON1bits.VCFG = 0b00; // Vss, Vdd
    ADCON1bits.PCFG = 0b1000; // hasta AN6

    ADCON2bits.ACQT = 0b010; // Tiempo de adquisicion
    ADCON2bits.ADCS = 0b001; // Tiempo de conversion

    ADCON2bits.ADFM = 0; // Justificado a la izquierda

    ADCON0bits.ADON = 1; // Encender ADC
}
```

# Versión 1.0

```c
/*
 * File:   main.c
 * Author: santo
 *
 * Potenciometro
 */
#define _XTAL_FREQ 8000000UL
#include "config.h"
#include <xc.h>

// --- FUN: Config ADC

void ADC_Init(void) {
    ADCON1bits.VCFG = 0b00; // Vss, Vdd
    ADCON1bits.PCFG = 0b1000; // hasta AN6

    ADCON2bits.ACQT = 0b010; // Tiempo de adquisicion
    ADCON2bits.ADCS = 0b001; // Tiempo de conversion

    ADCON2bits.ADFM = 1; // Justificado a la derecha

    ADCON0bits.ADON = 1; // Encender ADC
}

int16_t ADC_Read(unsigned char chanel) {
    // Seleccionar canal
    // Limpiamos los bits actuales y ponemos el nuevo canal
    ADCON0 &= 0b11000011;

    ADCON0 |= (chanel << 2); // CHS : ALL
    //ADCON0bits.CHS = 0b0000; // CHS : AN0

    // Iniciar conversion (Bit GO/DONE a 1)
    ADCON0bits.GO = 1;

    // Esperar a que termine
    while (ADCON0bits.GO == 1);

    // Devolver resultado (Unir parte Alta y Baja)
    // Como son 10 bits, unimos ADRESH (2 bits) y ADRESL (8 bits)
    return ((ADRESH << 8) + ADRESL); // Justificado a la derecha
}

void main(void) {  
    // Selecciona 8Mhz en los registros 
    OSCCONbits.IRCF =0b111;
    
    ADC_Init();
    
    TRISDbits.TRISD0 = 0; //1
    TRISDbits.TRISD7= 0; //2do
    TRISDbits.TRISD6= 0; //3
    TRISDbits.TRISD5 = 0; //4
    
    int valor = 0;
    
    while(1){
        valor = ADC_Read(6);
        if (valor > 1) {
            LATDbits.LATD0 = 1;
        }
    }
    
    return;
}
```

## Versión final del código

```notion
/*
 * File:   main.c
 * Author: santo
 *
 * Potenciometro
 */
#define _XTAL_FREQ 8000000UL
#include "config.h"
#include <xc.h>

// --- FUN: Config ADC

void ADC_Init(void) {
    ADCON1bits.VCFG = 0b00; // Vss, Vdd
    ADCON1bits.PCFG = 0b1000; // hasta AN6

    ADCON2bits.ACQT = 0b010; // Tiempo de adquisicion
    ADCON2bits.ADCS = 0b001; // Tiempo de conversion

    ADCON2bits.ADFM = 1; // Justificado a la derecha

    ADCON0bits.ADON = 1; // Encender ADC
}

int16_t ADC_Read(unsigned char chanel) {
    // Seleccionar canal
    // Limpiamos los bits actuales y ponemos el nuevo canal
    ADCON0 &= 0b11000011;

    ADCON0 |= (chanel << 2); // CHS : ALL
    //ADCON0bits.CHS = 0b0000; // CHS : AN0

    // Iniciar conversion (Bit GO/DONE a 1)
    ADCON0bits.GO = 1;

    // Esperar a que termine
    while (ADCON0bits.GO == 1);

    // Devolver resultado (Unir parte Alta y Baja)
    // Como son 10 bits, unimos ADRESH (2 bits) y ADRESL (8 bits)
    return ((ADRESH << 8) + ADRESL); // Justificado a la derecha
}

void main(void) {  
    // Selecciona 8Mhz en los registros 
    OSCCONbits.IRCF =0b111;
    
    ADC_Init();
    
    TRISDbits.TRISD0 = 0; //1
    TRISDbits.TRISD7= 0; //2do
    TRISDbits.TRISD6= 0; //3
    TRISDbits.TRISD5 = 0; //4
    
    int valor = 0;
    
    while(1){
        valor = ADC_Read(6);
        if (valor > 1) {
            LATDbits.LATD0 = 1;
        } else LATDbits.LATD0 = 0; 
        
        if (valor > 256) {
            LATDbits.LATD6 = 1;
        } else LATDbits.LATD6 = 0;
        
        if (valor > 512) {
            LATDbits.LATD7 = 1;
        } else LATDbits.LATD7 = 0;
        
        if (valor > 768) {
            LATDbits.LATD5 = 1;
        } else LATDbits.LATD5 = 0;
    }
    
    return;
}
```