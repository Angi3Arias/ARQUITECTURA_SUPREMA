subtitle "Microchip MPLAB XC8 C Compiler v3.10 (Free license) build 20250813170317 Og9 "

pagewidth 120

	opt flic

	processor	18F4550
include "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc\18f4550.cgen.inc"
getbyte	macro	val,pos
	(((val) >> (8 * pos)) and 0xff)
endm
byte0	macro	val
	(getbyte(val,0))
endm
byte1	macro	val
	(getbyte(val,1))
endm
byte2	macro	val
	(getbyte(val,2))
endm
byte3	macro	val
	(getbyte(val,3))
endm
byte4	macro	val
	(getbyte(val,4))
endm
byte5	macro	val
	(getbyte(val,5))
endm
byte6	macro	val
	(getbyte(val,6))
endm
byte7	macro	val
	(getbyte(val,7))
endm
getword	macro	val,pos
	(((val) >> (8 * pos)) and 0xffff)
endm
word0	macro	val
	(getword(val,0))
endm
word1	macro	val
	(getword(val,2))
endm
word2	macro	val
	(getword(val,4))
endm
word3	macro	val
	(getword(val,6))
endm
gettword	macro	val,pos
	(((val) >> (8 * pos)) and 0xffffff)
endm
tword0	macro	val
	(gettword(val,0))
endm
tword1	macro	val
	(gettword(val,3))
endm
tword2	macro	val
	(gettword(val,6))
endm
getdword	macro	val,pos
	(((val) >> (8 * pos)) and 0xffffffff)
endm
dword0	macro	val
	(getdword(val,0))
endm
dword1	macro	val
	(getdword(val,4))
endm
clrc   macro
	bcf	status,0
endm
setc   macro
	bsf	status,0
endm
clrz   macro
	bcf	status,2
endm
setz   macro
	bsf	status,2
endm
skipnz macro
	btfsc	status,2
endm
skipz  macro
	btfss	status,2
endm
skipnc macro
	btfsc	status,0
endm
skipc  macro
	btfss	status,0
endm
pushw macro
	movwf postinc1
endm
pushf macro arg1
	movff arg1, postinc1
endm
popw macro
	movf postdec1,f
	movf indf1,w
endm
popf macro arg1
	movf postdec1,f
	movff indf1,arg1
endm
popfc macro arg1
	movff plusw1,arg1
	decfsz fsr1,f
endm
skiprom24 macro arg1
	btfsc arg1,7
endm
	global	__ramtop
	global	__accesstop
# 54 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SPPDATA equ 0F62h ;# 
# 74 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SPPCFG equ 0F63h ;# 
# 151 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SPPEPS equ 0F64h ;# 
# 225 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SPPCON equ 0F65h ;# 
# 251 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UFRM equ 0F66h ;# 
# 258 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UFRML equ 0F66h ;# 
# 336 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UFRMH equ 0F67h ;# 
# 376 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UIR equ 0F68h ;# 
# 432 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UIE equ 0F69h ;# 
# 488 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEIR equ 0F6Ah ;# 
# 539 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEIE equ 0F6Bh ;# 
# 590 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
USTAT equ 0F6Ch ;# 
# 650 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UCON equ 0F6Dh ;# 
# 701 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UADDR equ 0F6Eh ;# 
# 765 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UCFG equ 0F6Fh ;# 
# 844 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP0 equ 0F70h ;# 
# 952 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP1 equ 0F71h ;# 
# 1060 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP2 equ 0F72h ;# 
# 1168 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP3 equ 0F73h ;# 
# 1276 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP4 equ 0F74h ;# 
# 1384 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP5 equ 0F75h ;# 
# 1492 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP6 equ 0F76h ;# 
# 1600 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP7 equ 0F77h ;# 
# 1708 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP8 equ 0F78h ;# 
# 1784 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP9 equ 0F79h ;# 
# 1860 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP10 equ 0F7Ah ;# 
# 1936 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP11 equ 0F7Bh ;# 
# 2012 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP12 equ 0F7Ch ;# 
# 2088 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP13 equ 0F7Dh ;# 
# 2164 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP14 equ 0F7Eh ;# 
# 2240 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
UEP15 equ 0F7Fh ;# 
# 2316 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PORTA equ 0F80h ;# 
# 2455 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PORTB equ 0F81h ;# 
# 2565 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PORTC equ 0F82h ;# 
# 2707 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PORTD equ 0F83h ;# 
# 2828 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PORTE equ 0F84h ;# 
# 2975 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
LATA equ 0F89h ;# 
# 3075 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
LATB equ 0F8Ah ;# 
# 3187 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
LATC equ 0F8Bh ;# 
# 3265 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
LATD equ 0F8Ch ;# 
# 3377 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
LATE equ 0F8Dh ;# 
# 3429 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TRISA equ 0F92h ;# 
# 3434 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
DDRA equ 0F92h ;# 
# 3627 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TRISB equ 0F93h ;# 
# 3632 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
DDRB equ 0F93h ;# 
# 3849 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TRISC equ 0F94h ;# 
# 3854 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
DDRC equ 0F94h ;# 
# 4003 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TRISD equ 0F95h ;# 
# 4008 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
DDRD equ 0F95h ;# 
# 4225 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TRISE equ 0F96h ;# 
# 4230 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
DDRE equ 0F96h ;# 
# 4327 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
OSCTUNE equ 0F9Bh ;# 
# 4386 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PIE1 equ 0F9Dh ;# 
# 4470 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PIR1 equ 0F9Eh ;# 
# 4554 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
IPR1 equ 0F9Fh ;# 
# 4638 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PIE2 equ 0FA0h ;# 
# 4709 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PIR2 equ 0FA1h ;# 
# 4780 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
IPR2 equ 0FA2h ;# 
# 4851 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
EECON1 equ 0FA6h ;# 
# 4917 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
EECON2 equ 0FA7h ;# 
# 4924 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
EEDATA equ 0FA8h ;# 
# 4931 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
EEADR equ 0FA9h ;# 
# 4938 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
RCSTA equ 0FABh ;# 
# 4943 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
RCSTA1 equ 0FABh ;# 
# 5148 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TXSTA equ 0FACh ;# 
# 5153 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TXSTA1 equ 0FACh ;# 
# 5404 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TXREG equ 0FADh ;# 
# 5409 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TXREG1 equ 0FADh ;# 
# 5416 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
RCREG equ 0FAEh ;# 
# 5421 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
RCREG1 equ 0FAEh ;# 
# 5428 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SPBRG equ 0FAFh ;# 
# 5433 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SPBRG1 equ 0FAFh ;# 
# 5440 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SPBRGH equ 0FB0h ;# 
# 5447 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
T3CON equ 0FB1h ;# 
# 5568 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TMR3 equ 0FB2h ;# 
# 5575 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TMR3L equ 0FB2h ;# 
# 5582 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TMR3H equ 0FB3h ;# 
# 5589 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CMCON equ 0FB4h ;# 
# 5679 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CVRCON equ 0FB5h ;# 
# 5764 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
ECCP1AS equ 0FB6h ;# 
# 5769 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CCP1AS equ 0FB6h ;# 
# 5926 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
ECCP1DEL equ 0FB7h ;# 
# 5931 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CCP1DEL equ 0FB7h ;# 
# 6064 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
BAUDCON equ 0FB8h ;# 
# 6069 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
BAUDCTL equ 0FB8h ;# 
# 6244 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CCP2CON equ 0FBAh ;# 
# 6308 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CCPR2 equ 0FBBh ;# 
# 6315 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CCPR2L equ 0FBBh ;# 
# 6322 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CCPR2H equ 0FBCh ;# 
# 6329 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CCP1CON equ 0FBDh ;# 
# 6334 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
ECCP1CON equ 0FBDh ;# 
# 6491 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CCPR1 equ 0FBEh ;# 
# 6498 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CCPR1L equ 0FBEh ;# 
# 6505 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
CCPR1H equ 0FBFh ;# 
# 6512 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
ADCON2 equ 0FC0h ;# 
# 6583 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
ADCON1 equ 0FC1h ;# 
# 6668 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
ADCON0 equ 0FC2h ;# 
# 6787 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
ADRES equ 0FC3h ;# 
# 6794 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
ADRESL equ 0FC3h ;# 
# 6801 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
ADRESH equ 0FC4h ;# 
# 6808 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SSPCON2 equ 0FC5h ;# 
# 6870 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SSPCON1 equ 0FC6h ;# 
# 6940 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SSPSTAT equ 0FC7h ;# 
# 7188 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SSPADD equ 0FC8h ;# 
# 7195 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
SSPBUF equ 0FC9h ;# 
# 7202 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
T2CON equ 0FCAh ;# 
# 7300 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PR2 equ 0FCBh ;# 
# 7305 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
MEMCON equ 0FCBh ;# 
# 7410 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TMR2 equ 0FCCh ;# 
# 7417 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
T1CON equ 0FCDh ;# 
# 7520 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TMR1 equ 0FCEh ;# 
# 7527 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TMR1L equ 0FCEh ;# 
# 7534 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TMR1H equ 0FCFh ;# 
# 7541 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
RCON equ 0FD0h ;# 
# 7690 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
WDTCON equ 0FD1h ;# 
# 7718 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
HLVDCON equ 0FD2h ;# 
# 7723 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
LVDCON equ 0FD2h ;# 
# 7988 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
OSCCON equ 0FD3h ;# 
# 8071 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
T0CON equ 0FD5h ;# 
# 8141 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TMR0 equ 0FD6h ;# 
# 8148 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TMR0L equ 0FD6h ;# 
# 8155 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TMR0H equ 0FD7h ;# 
# 8162 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
STATUS equ 0FD8h ;# 
# 8233 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
FSR2 equ 0FD9h ;# 
# 8240 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
FSR2L equ 0FD9h ;# 
# 8247 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
FSR2H equ 0FDAh ;# 
# 8254 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PLUSW2 equ 0FDBh ;# 
# 8261 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PREINC2 equ 0FDCh ;# 
# 8268 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
POSTDEC2 equ 0FDDh ;# 
# 8275 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
POSTINC2 equ 0FDEh ;# 
# 8282 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
INDF2 equ 0FDFh ;# 
# 8289 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
BSR equ 0FE0h ;# 
# 8296 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
FSR1 equ 0FE1h ;# 
# 8303 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
FSR1L equ 0FE1h ;# 
# 8310 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
FSR1H equ 0FE2h ;# 
# 8317 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PLUSW1 equ 0FE3h ;# 
# 8324 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PREINC1 equ 0FE4h ;# 
# 8331 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
POSTDEC1 equ 0FE5h ;# 
# 8338 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
POSTINC1 equ 0FE6h ;# 
# 8345 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
INDF1 equ 0FE7h ;# 
# 8352 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
WREG equ 0FE8h ;# 
# 8359 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
FSR0 equ 0FE9h ;# 
# 8366 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
FSR0L equ 0FE9h ;# 
# 8373 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
FSR0H equ 0FEAh ;# 
# 8380 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PLUSW0 equ 0FEBh ;# 
# 8387 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PREINC0 equ 0FECh ;# 
# 8394 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
POSTDEC0 equ 0FEDh ;# 
# 8401 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
POSTINC0 equ 0FEEh ;# 
# 8408 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
INDF0 equ 0FEFh ;# 
# 8415 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
INTCON3 equ 0FF0h ;# 
# 8507 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
INTCON2 equ 0FF1h ;# 
# 8584 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
INTCON equ 0FF2h ;# 
# 8701 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PROD equ 0FF3h ;# 
# 8708 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PRODL equ 0FF3h ;# 
# 8715 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PRODH equ 0FF4h ;# 
# 8722 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TABLAT equ 0FF5h ;# 
# 8731 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TBLPTR equ 0FF6h ;# 
# 8738 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TBLPTRL equ 0FF6h ;# 
# 8745 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TBLPTRH equ 0FF7h ;# 
# 8752 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TBLPTRU equ 0FF8h ;# 
# 8761 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PCLAT equ 0FF9h ;# 
# 8768 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PC equ 0FF9h ;# 
# 8775 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PCL equ 0FF9h ;# 
# 8782 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PCLATH equ 0FFAh ;# 
# 8789 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
PCLATU equ 0FFBh ;# 
# 8796 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
STKPTR equ 0FFCh ;# 
# 8872 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TOS equ 0FFDh ;# 
# 8879 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TOSL equ 0FFDh ;# 
# 8886 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TOSH equ 0FFEh ;# 
# 8893 "D:\PROGRAMAS\ARQ\MPLAB_VERSION_6.20\packs\Microchip\PIC18Fxxxx_DFP\1.6.159\xc8\pic\include\proc/pic18f4550.h"
TOSU equ 0FFFh ;# 
	debug_source C
	FNCALL	_main,_LCD_Init
	FNCALL	_main,_UART_EnviarEstado
	FNCALL	_main,_UART_Init
	FNCALL	_main,_UART_ProcessRx
	FNCALL	_main,_UART_PumpTx
	FNCALL	_main,_actualizar_todo
	FNCALL	_main,_leer_teclado
	FNCALL	_main,_llamar_pasillo
	FNCALL	_main,_memset
	FNCALL	_main,_procesar_tecla
	FNCALL	_actualizar_todo,_LCD_Linea
	FNCALL	_actualizar_todo,_UART_EnviarEstado
	FNCALL	_actualizar_todo,___awdiv
	FNCALL	_actualizar_todo,_atender_llegada
	FNCALL	_actualizar_todo,_contar_destinos
	FNCALL	_actualizar_todo,_dig
	FNCALL	_actualizar_todo,_elev_esperando
	FNCALL	_actualizar_todo,_memcpy
	FNCALL	_actualizar_todo,_msg_elev
	FNCALL	_actualizar_todo,_poner_2d
	FNCALL	_actualizar_todo,_quitar_cola_espera
	FNCALL	_actualizar_todo,_siguiente_objetivo
	FNCALL	_actualizar_todo,_strcpy
	FNCALL	_actualizar_todo,_strncmp
	FNCALL	_actualizar_todo,_tiene_paradas
	FNCALL	_atender_llegada,_UART_EmitDeq
	FNCALL	_atender_llegada,_UART_EnviarEstado
	FNCALL	_atender_llegada,_agregar_cola_espera
	FNCALL	_atender_llegada,_beep
	FNCALL	_atender_llegada,_msg_elev
	FNCALL	_UART_EmitDeq,_UART_Put2d
	FNCALL	_UART_EmitDeq,_UART_PutChar
	FNCALL	_UART_EmitDeq,_UART_PutStr
	FNCALL	_UART_EmitDeq,_UART_TxFree
	FNCALL	_UART_EmitDeq,_dig
	FNCALL	_LCD_Linea,_LCD_Byte
	FNCALL	_LCD_Linea,_memcpy
	FNCALL	_LCD_Linea,_strncmp
	FNCALL	_UART_ProcessRx,_cambiar_num_pisos
	FNCALL	_UART_ProcessRx,_encolar_destino_cabina
	FNCALL	_UART_ProcessRx,_llamar_pasillo
	FNCALL	_UART_ProcessRx,_llamar_pasillo_piso
	FNCALL	_UART_ProcessRx,_parse_2d
	FNCALL	_UART_ProcessRx,_procesar_tecla
	FNCALL	_UART_ProcessRx,_reiniciar_sistema
	FNCALL	_reiniciar_sistema,_UART_EnviarEstado
	FNCALL	_reiniciar_sistema,_UART_PutStr
	FNCALL	_reiniciar_sistema,_UART_TxFree
	FNCALL	_reiniciar_sistema,___awdiv
	FNCALL	_reiniciar_sistema,_memset
	FNCALL	_reiniciar_sistema,_poner_msg
	FNCALL	_procesar_tecla,_UART_EmitEmg
	FNCALL	_procesar_tecla,_UART_EnviarEstado
	FNCALL	_procesar_tecla,_beep
	FNCALL	_procesar_tecla,_elev_esperando
	FNCALL	_procesar_tecla,_encolar_destino_cabina
	FNCALL	_procesar_tecla,_msg_elev
	FNCALL	_procesar_tecla,_poner_msg
	FNCALL	_procesar_tecla,_quitar_cola_espera
	FNCALL	_procesar_tecla,_siguiente_objetivo
	FNCALL	_procesar_tecla,_tiene_paradas
	FNCALL	_encolar_destino_cabina,_UART_EmitEnq
	FNCALL	_encolar_destino_cabina,_UART_EnviarEstado
	FNCALL	_encolar_destino_cabina,_beep
	FNCALL	_encolar_destino_cabina,_msg_elev
	FNCALL	_encolar_destino_cabina,_poner_msg
	FNCALL	_encolar_destino_cabina,_siguiente_objetivo
	FNCALL	_elev_esperando,_quitar_cola_espera
	FNCALL	_UART_EmitEmg,_UART_PutChar
	FNCALL	_UART_EmitEmg,_UART_PutStr
	FNCALL	_UART_EmitEmg,_UART_TxFree
	FNCALL	_llamar_pasillo,_beep
	FNCALL	_llamar_pasillo,_llamar_pasillo_piso
	FNCALL	_llamar_pasillo,_poner_msg
	FNCALL	_llamar_pasillo_piso,_UART_EmitDsp
	FNCALL	_llamar_pasillo_piso,_UART_EmitEnq
	FNCALL	_llamar_pasillo_piso,_UART_EnviarEstado
	FNCALL	_llamar_pasillo_piso,_agregar_cola_espera
	FNCALL	_llamar_pasillo_piso,_beep
	FNCALL	_llamar_pasillo_piso,_costo_elevador
	FNCALL	_llamar_pasillo_piso,_msg_elev
	FNCALL	_llamar_pasillo_piso,_siguiente_objetivo
	FNCALL	_costo_elevador,_contar_paradas
	FNCALL	_costo_elevador,_vabs
	FNCALL	_UART_EmitEnq,_UART_Put2d
	FNCALL	_UART_EmitEnq,_UART_PutChar
	FNCALL	_UART_EmitEnq,_UART_PutStr
	FNCALL	_UART_EmitEnq,_UART_TxFree
	FNCALL	_UART_EmitEnq,_dig
	FNCALL	_UART_EmitDsp,_UART_Put2d
	FNCALL	_UART_EmitDsp,_UART_PutChar
	FNCALL	_UART_EmitDsp,_UART_PutInt
	FNCALL	_UART_EmitDsp,_UART_PutStr
	FNCALL	_UART_EmitDsp,_UART_TxFree
	FNCALL	_UART_EmitDsp,_dig
	FNCALL	_cambiar_num_pisos,_UART_EmitCfg
	FNCALL	_cambiar_num_pisos,_UART_EnviarEstado
	FNCALL	_cambiar_num_pisos,_beep
	FNCALL	_cambiar_num_pisos,_msg_elev
	FNCALL	_cambiar_num_pisos,_siguiente_objetivo
	FNCALL	_cambiar_num_pisos,_tiene_paradas
	FNCALL	_siguiente_objetivo,_vabs
	FNCALL	_msg_elev,_dig
	FNCALL	_msg_elev,_poner_2d
	FNCALL	_msg_elev,_poner_msg
	FNCALL	_msg_elev,_strcpy
	FNCALL	_poner_2d,___awdiv
	FNCALL	_poner_2d,_dig
	FNCALL	_UART_EnviarEstado,_UART_Put2d
	FNCALL	_UART_EnviarEstado,_UART_PutChar
	FNCALL	_UART_EnviarEstado,_UART_PutHex5
	FNCALL	_UART_EnviarEstado,_UART_PutStr
	FNCALL	_UART_EnviarEstado,_UART_TxFree
	FNCALL	_UART_EnviarEstado,_estado_char
	FNCALL	_UART_EnviarEstado,_puerta_nivel
	FNCALL	_puerta_nivel,___awdiv
	FNCALL	_puerta_nivel,_dig
	FNCALL	_UART_PutHex5,_UART_PutChar
	FNCALL	_UART_EmitCfg,_UART_Put2d
	FNCALL	_UART_EmitCfg,_UART_PutChar
	FNCALL	_UART_EmitCfg,_UART_PutInt
	FNCALL	_UART_EmitCfg,_UART_PutStr
	FNCALL	_UART_EmitCfg,_UART_TxFree
	FNCALL	_UART_PutStr,_UART_PutChar
	FNCALL	_UART_PutInt,_UART_PutChar
	FNCALL	_UART_PutInt,___awdiv
	FNCALL	_UART_PutInt,_dig
	FNCALL	_UART_Put2d,_UART_PutChar
	FNCALL	_UART_Put2d,___awdiv
	FNCALL	_UART_Put2d,_dig
	FNCALL	_dig,___awmod
	FNCALL	_LCD_Init,_LCD_Byte
	FNCALL	_LCD_Init,_LCD_Nib
	FNCALL	_LCD_Byte,_LCD_Nib
	FNROOT	_main
	FNCALL	intlevel2,_isr
	global	intlevel2
	FNROOT	intlevel2
	global	_num_pisos
	global	_cola_espera
	global	_piso
	global	_bajar_ant
	global	_subir_ant
	global	_parpadeo
	global	_msg_lcd
psect	idataCOMRAM,class=CODE,space=0,delta=1,noexec
global __pidataCOMRAM
__pidataCOMRAM:
	file	"LOGIC_TEST.c"
	line	47

;initializer for _num_pisos
	dw	(0Ch)&0ffffh
psect	idataBANK0,class=CODE,space=0,delta=1,noexec
global __pidataBANK0
__pidataBANK0:
	line	60

;initializer for _cola_espera
	dw	(-1)&0ffffh
	dw	(-1)&0ffffh
	dw	(-1)&0ffffh
	line	48

;initializer for _piso
	dw	(01h)&0ffffh
	dw	(06h)&0ffffh
	dw	(0Ch)&0ffffh
	line	74

;initializer for _bajar_ant
	dw	(01h)&0ffffh

;initializer for _subir_ant
	dw	(01h)&0ffffh
	line	68

;initializer for _parpadeo
	db	low(01h)
psect	idataBANK1,class=CODE,space=0,delta=1,noexec
global __pidataBANK1
__pidataBANK1:
	line	72

;initializer for _msg_lcd
	db	low(050h)
	db	low(072h)
	db	low(065h)
	db	low(073h)
	db	low(069h)
	db	low(06Fh)
	db	low(06Eh)
	db	low(061h)
	db	low(020h)
	db	low(041h)
	db	low(03Ah)
	db	low(020h)
	db	low(050h)
	db	low(069h)
	db	low(073h)
	db	low(06Fh)
	db	low(0)
	global	UART_PutHex5@HEX
psect	mediumconst,class=MEDIUMCONST,space=0,reloc=2,noexec
global __pmediumconst
__pmediumconst:
	db	0
	file	"LOGIC_TEST.c"
	line	230
UART_PutHex5@HEX:
	db	low(030h)
	db	low(031h)
	db	low(032h)
	db	low(033h)
	db	low(034h)
	db	low(035h)
	db	low(036h)
	db	low(037h)
	db	low(038h)
	db	low(039h)
	db	low(041h)
	db	low(042h)
	db	low(043h)
	db	low(044h)
	db	low(045h)
	db	low(046h)
	global __end_ofUART_PutHex5@HEX
__end_ofUART_PutHex5@HEX:
	global	_TECLAS
psect	mediumconst
	file	"LOGIC_TEST.c"
	line	168
_TECLAS:
	db	low(031h)
	db	low(032h)
	db	low(033h)
	db	low(041h)
	db	low(034h)
	db	low(035h)
	db	low(036h)
	db	low(042h)
	db	low(037h)
	db	low(038h)
	db	low(039h)
	db	low(043h)
	db	low(02Ah)
	db	low(030h)
	db	low(023h)
	db	low(044h)
	global __end_of_TECLAS
__end_of_TECLAS:
	global	UART_PutHex5@HEX
	global	_TECLAS
	global	_modo
	global	_emergencia
	global	_encolados
	global	_reloj_puerta
	global	_reloj_piso
	global	_objetivo
	global	_direccion
	global	_estado
	global	_buf
	global	_cont_uart
	global	_cont_buzz
	global	_cont_parp
	global	_buf_len
	global	_elev_activo
	global	_piso_usr
	global	_cola_esp_len
	global	_uart_rx_len
	global	_tx_tail
	global	_tx_head
	global	_rx_tail
	global	_rx_head
	global	_tecla_ant
	global	_uart_rx
	global	_rx_ring
	global	_paradas
	global	_prev_l2
	global	_prev_l1
	global	_tx_ring
	global	_PORTBbits
_PORTBbits	set	0xF81
	global	_LATE
_LATE	set	0xF8D
	global	_LATD
_LATD	set	0xF8C
	global	_LATC
_LATC	set	0xF8B
	global	_LATB
_LATB	set	0xF8A
	global	_TRISEbits
_TRISEbits	set	0xF96
	global	_TRISD
_TRISD	set	0xF95
	global	_TRISBbits
_TRISBbits	set	0xF93
	global	_SPPCON
_SPPCON	set	0xF65
	global	_CMCON
_CMCON	set	0xFB4
	global	_ADCON1
_ADCON1	set	0xFC1
	global	_ADCON0
_ADCON0	set	0xFC2
	global	_OSCCONbits
_OSCCONbits	set	0xFD3
	global	_LATCbits
_LATCbits	set	0xF8B
	global	_LATAbits
_LATAbits	set	0xF89
	global	_LATEbits
_LATEbits	set	0xF8D
	global	_TXREG
_TXREG	set	0xFAD
	global	_INTCONbits
_INTCONbits	set	0xFF2
	global	_BAUDCONbits
_BAUDCONbits	set	0xFB8
	global	_TXSTAbits
_TXSTAbits	set	0xFAC
	global	_SPBRG
_SPBRG	set	0xFAF
	global	_TRISCbits
_TRISCbits	set	0xF94
	global	_PORTEbits
_PORTEbits	set	0xF84
	global	_PORTAbits
_PORTAbits	set	0xF80
	global	_LATA
_LATA	set	0xF89
	global	_TRISA
_TRISA	set	0xF92
	global	_LATDbits
_LATDbits	set	0xF8C
	global	_LATBbits
_LATBbits	set	0xF8A
	global	_RCREG
_RCREG	set	0xFAE
	global	_RCSTAbits
_RCSTAbits	set	0xFAB
	global	_PIR1bits
_PIR1bits	set	0xF9E
	global	_PIE1bits
_PIE1bits	set	0xF9D
	
STR_29:
	db	69	;'E'
	db	49	;'1'
	db	45
	db	62	;'>'
	db	68	;'D'
	db	101	;'e'
	db	115	;'s'
	db	116	;'t'
	db	32
	db	80	;'P'
	db	48	;'0'
	db	48	;'0'
	db	32
	db	32
	db	32
	db	32
	db	0
	
STR_21:
	db	89	;'Y'
	db	97	;'a'
	db	32
	db	101	;'e'
	db	110	;'n'
	db	32
	db	80	;'P'
	db	105	;'i'
	db	115	;'s'
	db	111	;'o'
	db	32
	db	48	;'0'
	db	48	;'0'
	db	33
	db	32
	db	32
	db	0
	
STR_13:
	db	78	;'N'
	db	69	;'E'
	db	87	;'W'
	db	32
	db	80	;'P'
	db	73	;'I'
	db	83	;'S'
	db	79	;'O'
	db	83	;'S'
	db	32
	db	61	;'='
	db	32
	db	48	;'0'
	db	48	;'0'
	db	32
	db	32
	db	0
	
STR_33:
	db	69	;'E'
	db	49	;'1'
	db	32
	db	108	;'l'
	db	108	;'l'
	db	101	;'e'
	db	103	;'g'
	db	111	;'o'
	db	32
	db	97	;'a'
	db	32
	db	80	;'P'
	db	48	;'0'
	db	48	;'0'
	db	32
	db	32
	db	0
	
STR_23:
	db	83	;'S'
	db	105	;'i'
	db	115	;'s'
	db	116	;'t'
	db	101	;'e'
	db	109	;'m'
	db	97	;'a'
	db	32
	db	110	;'n'
	db	111	;'o'
	db	114	;'r'
	db	109	;'m'
	db	97	;'a'
	db	108	;'l'
	db	32
	db	32
	db	0
	
STR_16:
	db	69	;'E'
	db	49	;'1'
	db	32
	db	80	;'P'
	db	48	;'0'
	db	48	;'0'
	db	32
	db	65	;'A'
	db	98	;'b'
	db	105	;'i'
	db	101	;'e'
	db	114	;'r'
	db	116	;'t'
	db	111	;'o'
	db	32
	db	32
	db	0
	
STR_18:
	db	69	;'E'
	db	49	;'1'
	db	45
	db	62	;'>'
	db	80	;'P'
	db	48	;'0'
	db	48	;'0'
	db	32
	db	40
	db	66	;'B'
	db	65	;'A'
	db	74	;'J'
	db	65	;'A'
	db	82	;'R'
	db	41
	db	32
	db	0
	
STR_17:
	db	69	;'E'
	db	49	;'1'
	db	45
	db	62	;'>'
	db	80	;'P'
	db	48	;'0'
	db	48	;'0'
	db	32
	db	40
	db	83	;'S'
	db	85	;'U'
	db	66	;'B'
	db	73	;'I'
	db	82	;'R'
	db	41
	db	32
	db	0
	
STR_43:
	db	69	;'E'
	db	49	;'1'
	db	32
	db	68	;'D'
	db	101	;'e'
	db	115	;'s'
	db	116	;'t'
	db	58	;':'
	db	95	;'_'
	db	95	;'_'
	db	32
	db	35
	db	61	;'='
	db	79	;'O'
	db	75	;'K'
	db	32
	db	0
	
STR_31:
	db	69	;'E'
	db	110	;'n'
	db	116	;'t'
	db	114	;'r'
	db	97	;'a'
	db	100	;'d'
	db	97	;'a'
	db	32
	db	98	;'b'
	db	111	;'o'
	db	114	;'r'
	db	114	;'r'
	db	97	;'a'
	db	100	;'d'
	db	97	;'a'
	db	32
	db	0
	
STR_22:
	db	69	;'E'
	db	49	;'1'
	db	32
	db	43
	db	80	;'P'
	db	48	;'0'
	db	48	;'0'
	db	32
	db	101	;'e'
	db	110	;'n'
	db	32
	db	99	;'c'
	db	111	;'o'
	db	108	;'l'
	db	97	;'a'
	db	32
	db	0
	
STR_42:
	db	69	;'E'
	db	49	;'1'
	db	32
	db	81	;'Q'
	db	58	;':'
	db	48	;'0'
	db	48	;'0'
	db	32
	db	48	;'0'
	db	115	;'s'
	db	32
	db	67	;'C'
	db	61	;'='
	db	73	;'I'
	db	114	;'r'
	db	32
	db	0
	
STR_35:
	db	33
	db	33
	db	32
	db	69	;'E'
	db	77	;'M'
	db	69	;'E'
	db	82	;'R'
	db	71	;'G'
	db	69	;'E'
	db	78	;'N'
	db	67	;'C'
	db	73	;'I'
	db	65	;'A'
	db	32
	db	33
	db	33
	db	0
	
STR_19:
	db	80	;'P'
	db	114	;'r'
	db	105	;'i'
	db	109	;'m'
	db	101	;'e'
	db	114	;'r'
	db	111	;'o'
	db	32
	db	112	;'p'
	db	117	;'u'
	db	108	;'l'
	db	115	;'s'
	db	97	;'a'
	db	32
	db	65	;'A'
	db	33
	db	0
	
STR_20:
	db	69	;'E'
	db	82	;'R'
	db	82	;'R'
	db	79	;'O'
	db	82	;'R'
	db	58	;':'
	db	78	;'N'
	db	111	;'o'
	db	32
	db	101	;'e'
	db	120	;'x'
	db	105	;'i'
	db	115	;'s'
	db	116	;'t'
	db	101	;'e'
	db	33
	db	0
	
STR_30:
	db	69	;'E'
	db	49	;'1'
	db	32
	db	80	;'P'
	db	117	;'u'
	db	101	;'e'
	db	114	;'r'
	db	116	;'t'
	db	97	;'a'
	db	32
	db	67	;'C'
	db	69	;'E'
	db	82	;'R'
	db	82	;'R'
	db	65	;'A'
	db	46
	db	0
	
STR_28:
	db	69	;'E'
	db	49	;'1'
	db	32
	db	80	;'P'
	db	117	;'u'
	db	101	;'e'
	db	114	;'r'
	db	116	;'t'
	db	97	;'a'
	db	32
	db	65	;'A'
	db	66	;'B'
	db	73	;'I'
	db	69	;'E'
	db	82	;'R'
	db	46
	db	0
	
STR_37:
	db	49	;'1'
	db	58	;':'
	db	48	;'0'
	db	48	;'0'
	db	32
	db	32
	db	50	;'2'
	db	58	;':'
	db	48	;'0'
	db	48	;'0'
	db	32
	db	32
	db	51	;'3'
	db	58	;':'
	db	48	;'0'
	db	48	;'0'
	db	0
	
STR_38:
	db	83	;'S'
	db	101	;'e'
	db	108	;'l'
	db	46
	db	80	;'P'
	db	105	;'i'
	db	115	;'s'
	db	111	;'o'
	db	58	;':'
	db	95	;'_'
	db	95	;'_'
	db	32
	db	35
	db	61	;'='
	db	79	;'O'
	db	75	;'K'
	db	0
	
STR_24:
	db	80	;'P'
	db	48	;'0'
	db	48	;'0'
	db	58	;':'
	db	32
	db	83	;'S'
	db	85	;'U'
	db	66	;'B'
	db	73	;'I'
	db	82	;'R'
	db	47
	db	66	;'B'
	db	65	;'A'
	db	74	;'J'
	db	65	;'A'
	db	82	;'R'
	db	0
	
STR_14:
	db	80	;'P'
	db	114	;'r'
	db	101	;'e'
	db	115	;'s'
	db	105	;'i'
	db	111	;'o'
	db	110	;'n'
	db	97	;'a'
	db	32
	db	65	;'A'
	db	58	;':'
	db	32
	db	80	;'P'
	db	105	;'i'
	db	115	;'s'
	db	111	;'o'
	db	0
	
STR_36:
	db	80	;'P'
	db	117	;'u'
	db	108	;'l'
	db	115	;'s'
	db	97	;'a'
	db	32
	db	42
	db	32
	db	114	;'r'
	db	101	;'e'
	db	97	;'a'
	db	110	;'n'
	db	117	;'u'
	db	100	;'d'
	db	97	;'a'
	db	114	;'r'
	db	0
	
STR_15:
	db	69	;'E'
	db	44
	db	82	;'R'
	db	83	;'S'
	db	84	;'T'
	db	13
	db	10
	db	0
	
STR_7:
	db	69	;'E'
	db	44
	db	67	;'C'
	db	70	;'F'
	db	71	;'G'
	db	44
	db	0
	
STR_9:
	db	69	;'E'
	db	44
	db	69	;'E'
	db	77	;'M'
	db	71	;'G'
	db	44
	db	0
	
STR_5:
	db	69	;'E'
	db	44
	db	68	;'D'
	db	83	;'S'
	db	80	;'P'
	db	44
	db	0
	
STR_3:
	db	69	;'E'
	db	44
	db	68	;'D'
	db	69	;'E'
	db	81	;'Q'
	db	44
	db	0
	
STR_1:
	db	69	;'E'
	db	44
	db	69	;'E'
	db	78	;'N'
	db	81	;'Q'
	db	44
	db	0
	
STR_11:
	db	83	;'S'
	db	44
	db	0
STR_25	equ	STR_14+0
STR_27	equ	STR_24+0
STR_39	equ	STR_24+0
STR_26	equ	STR_20+0
STR_40	equ	STR_20+0
STR_41	equ	STR_20+0
STR_32	equ	STR_16+0
STR_34	equ	STR_29+0
STR_2	equ	STR_15+5
STR_4	equ	STR_15+5
STR_6	equ	STR_15+5
STR_8	equ	STR_15+5
STR_10	equ	STR_15+5
STR_12	equ	STR_15+5
; #config settings
	config pad_punits      = on
	config apply_mask      = off
	config ignore_cmsgs    = off
	config default_configs = off
	config default_idlocs  = off
	config PLLDIV = "1"
	config CPUDIV = "OSC1_PLL2"
	config USBDIV = "1"
	config FOSC = "INTOSCIO_EC"
	config FCMEN = "OFF"
	config IESO = "OFF"
	config PWRT = "OFF"
	config BOR = "ON"
	config BORV = "3"
	config VREGEN = "OFF"
	config WDT = "OFF"
	config WDTPS = "32768"
	config CCP2MX = "ON"
	config PBADEN = "OFF"
	config LPT1OSC = "OFF"
	config MCLRE = "OFF"
	config STVREN = "ON"
	config LVP = "OFF"
	config ICPRT = "OFF"
	config XINST = "OFF"
	config CP0 = "OFF"
	config CP1 = "OFF"
	config CP2 = "OFF"
	config CP3 = "OFF"
	config CPB = "OFF"
	config CPD = "OFF"
	config WRT0 = "OFF"
	config WRT1 = "OFF"
	config WRT2 = "OFF"
	config WRT3 = "OFF"
	config WRTC = "OFF"
	config WRTB = "OFF"
	config WRTD = "OFF"
	config EBTR0 = "OFF"
	config EBTR1 = "OFF"
	config EBTR2 = "OFF"
	config EBTR3 = "OFF"
	config EBTRB = "OFF"
	file	"Elevador_Supremo.s"
	line	#
psect	cinit,class=CODE,delta=1,reloc=2
global __pcinit
__pcinit:
global start_initialization
start_initialization:

global __initialization
__initialization:
psect	bssCOMRAM,class=COMRAM,space=1,noexec,lowdata
global __pbssCOMRAM
__pbssCOMRAM:
	global	_modo
_modo:
       ds      2
	global	_emergencia
_emergencia:
       ds      1
psect	dataCOMRAM,class=COMRAM,space=1,noexec,lowdata
global __pdataCOMRAM
__pdataCOMRAM:
	file	"LOGIC_TEST.c"
	line	47
	global	_num_pisos
_num_pisos:
       ds      2
psect	bssBANK0,class=BANK0,space=1,noexec,lowdata
global __pbssBANK0
__pbssBANK0:
	global	_encolados
_encolados:
       ds      6
	global	_reloj_puerta
_reloj_puerta:
       ds      6
	global	_reloj_piso
_reloj_piso:
       ds      6
	global	_objetivo
_objetivo:
       ds      6
	global	_direccion
_direccion:
       ds      6
	global	_estado
_estado:
       ds      6
	global	_buf
_buf:
       ds      3
	global	_cont_uart
_cont_uart:
       ds      2
	global	_cont_buzz
_cont_buzz:
       ds      2
	global	_cont_parp
_cont_parp:
       ds      2
	global	_buf_len
_buf_len:
       ds      2
	global	_elev_activo
_elev_activo:
       ds      2
	global	_piso_usr
_piso_usr:
       ds      2
	global	_cola_esp_len
_cola_esp_len:
       ds      2
	global	_uart_rx_len
_uart_rx_len:
       ds      1
	global	_tx_tail
_tx_tail:
       ds      1
	global	_tx_head
_tx_head:
       ds      1
	global	_rx_tail
_rx_tail:
       ds      1
	global	_rx_head
_rx_head:
       ds      1
	global	_tecla_ant
_tecla_ant:
       ds      1
	global	_uart_rx
_uart_rx:
       ds      20
psect	dataBANK0,class=BANK0,space=1,noexec,lowdata
global __pdataBANK0
__pdataBANK0:
	file	"LOGIC_TEST.c"
	line	60
	global	_cola_espera
_cola_espera:
       ds      6
psect	dataBANK0
	file	"LOGIC_TEST.c"
	line	48
	global	_piso
_piso:
       ds      6
psect	dataBANK0
	file	"LOGIC_TEST.c"
	line	74
	global	_bajar_ant
_bajar_ant:
       ds      2
psect	dataBANK0
	file	"LOGIC_TEST.c"
	line	74
	global	_subir_ant
_subir_ant:
       ds      2
psect	dataBANK0
	file	"LOGIC_TEST.c"
	line	68
	global	_parpadeo
_parpadeo:
       ds      1
psect	bssBANK1,class=BANK1,space=1,noexec,lowdata
global __pbssBANK1
__pbssBANK1:
	global	_rx_ring
_rx_ring:
       ds      64
	global	_paradas
_paradas:
       ds      63
	global	_prev_l2
_prev_l2:
       ds      17
	global	_prev_l1
_prev_l1:
       ds      17
psect	dataBANK1,class=BANK1,space=1,noexec,lowdata
global __pdataBANK1
__pdataBANK1:
	file	"LOGIC_TEST.c"
	line	72
	global	_msg_lcd
_msg_lcd:
       ds      17
psect	bssBANK2,class=BANK2,space=1,noexec,lowdata
global __pbssBANK2
__pbssBANK2:
	global	_tx_ring
_tx_ring:
       ds      256
	file	"Elevador_Supremo.s"
	line	#
psect	cinit
; Initialize objects allocated to BANK1 (17 bytes)
	global __pidataBANK1
	; load TBLPTR registers with __pidataBANK1
	movlw	low (__pidataBANK1)
	movwf	tblptrl
	movlw	high(__pidataBANK1)
	movwf	tblptrh
	movlw	low highword(__pidataBANK1)
	movwf	tblptru
	lfsr	0,__pdataBANK1
	lfsr	1,17
	copy_data0:
	tblrd	*+
	movff	tablat, postinc0
	movf	postdec1,w
	movf	fsr1l,w
	bnz	copy_data0
; Initialize objects allocated to BANK0 (17 bytes)
	global __pidataBANK0
	; load TBLPTR registers with __pidataBANK0
	movlw	low (__pidataBANK0)
	movwf	tblptrl
	movlw	high(__pidataBANK0)
	movwf	tblptrh
	movlw	low highword(__pidataBANK0)
	movwf	tblptru
	lfsr	0,__pdataBANK0
	lfsr	1,17
	copy_data1:
	tblrd	*+
	movff	tablat, postinc0
	movf	postdec1,w
	movf	fsr1l,w
	bnz	copy_data1
; Initialize objects allocated to COMRAM (2 bytes)
	global __pidataCOMRAM
	; load TBLPTR registers with __pidataCOMRAM
	movlw	low (__pidataCOMRAM)
	movwf	tblptrl
	movlw	high(__pidataCOMRAM)
	movwf	tblptrh
	movlw	low highword(__pidataCOMRAM)
	movwf	tblptru
	tblrd*+ ;fetch initializer
	movff	tablat, __pdataCOMRAM+0		
	tblrd*+ ;fetch initializer
	movff	tablat, __pdataCOMRAM+1		
	line	#
; Clear objects allocated to BANK2 (256 bytes)
	global __pbssBANK2
lfsr	0,__pbssBANK2
lfsr	1,256
clear_0:
clrf	postinc0,c
movf	postdec1,w
movf	fsr1l,w
bnz	clear_0
movf	fsr1h,w
bnz	clear_0
; Clear objects allocated to BANK1 (161 bytes)
	global __pbssBANK1
lfsr	0,__pbssBANK1
movlw	161
clear_1:
clrf	postinc0,c
decf	wreg
bnz	clear_1
; Clear objects allocated to BANK0 (79 bytes)
	global __pbssBANK0
lfsr	0,__pbssBANK0
movlw	79
clear_2:
clrf	postinc0,c
decf	wreg
bnz	clear_2
; Clear objects allocated to COMRAM (3 bytes)
	global __pbssCOMRAM
clrf	(__pbssCOMRAM+2)&0xffh,c
clrf	(__pbssCOMRAM+1)&0xffh,c
clrf	(__pbssCOMRAM+0)&0xffh,c
psect cinit,class=CODE,delta=1
global end_of_initialization,__end_of__initialization

;End of C runtime variable initialization code

end_of_initialization:
__end_of__initialization:
	bcf int$flags,0,c ;clear compiler interrupt flag (level 1)
	bcf int$flags,1,c ;clear compiler interrupt flag (level 2)
	GLOBAL	__Lmediumconst
	movlw	low highword(__Lmediumconst)
	movwf	tblptru
movlb 0
goto _main	;jump to C main() function
psect	cstackBANK0,class=BANK0,space=1,noexec,lowdata
global __pcstackBANK0
__pcstackBANK0:
	global	llamar_pasillo@fl
llamar_pasillo@fl:	; 2 bytes @ 0x0
	global	actualizar_todo@l1
actualizar_todo@l1:	; 17 bytes @ 0x0
	ds   2
	global	UART_ProcessRx@fl
UART_ProcessRx@fl:	; 2 bytes @ 0x2
	ds   2
	global	UART_ProcessRx@fl_1225
UART_ProcessRx@fl_1225:	; 2 bytes @ 0x4
	ds   2
	global	_UART_ProcessRx$1223
_UART_ProcessRx$1223:	; 2 bytes @ 0x6
	ds   2
	global	UART_ProcessRx@e
UART_ProcessRx@e:	; 2 bytes @ 0x8
	ds   2
	global	UART_ProcessRx@c
UART_ProcessRx@c:	; 1 bytes @ 0xA
	ds   1
	global	UART_ProcessRx@d
UART_ProcessRx@d:	; 1 bytes @ 0xB
	ds   6
	global	actualizar_todo@l2
actualizar_todo@l2:	; 17 bytes @ 0x11
	ds   17
	global	_actualizar_todo$1202
_actualizar_todo$1202:	; 2 bytes @ 0x22
	ds   2
	global	_actualizar_todo$1206
_actualizar_todo$1206:	; 2 bytes @ 0x24
	ds   2
	global	_actualizar_todo$1210
_actualizar_todo$1210:	; 2 bytes @ 0x26
	ds   2
	global	_actualizar_todo$1187
_actualizar_todo$1187:	; 1 bytes @ 0x28
	ds   1
	global	_actualizar_todo$1195
_actualizar_todo$1195:	; 1 bytes @ 0x29
	ds   1
	global	_actualizar_todo$1203
_actualizar_todo$1203:	; 1 bytes @ 0x2A
	ds   1
	global	_actualizar_todo$1204
_actualizar_todo$1204:	; 1 bytes @ 0x2B
	ds   1
	global	_actualizar_todo$1205
_actualizar_todo$1205:	; 1 bytes @ 0x2C
	ds   1
	global	_actualizar_todo$1207
_actualizar_todo$1207:	; 1 bytes @ 0x2D
	ds   1
	global	_actualizar_todo$1208
_actualizar_todo$1208:	; 1 bytes @ 0x2E
	ds   1
	global	_actualizar_todo$1209
_actualizar_todo$1209:	; 1 bytes @ 0x2F
	ds   1
	global	_actualizar_todo$1211
_actualizar_todo$1211:	; 1 bytes @ 0x30
	ds   1
	global	actualizar_todo@w
actualizar_todo@w:	; 2 bytes @ 0x31
	ds   2
	global	actualizar_todo@e
actualizar_todo@e:	; 2 bytes @ 0x33
	ds   2
??_main:	; 1 bytes @ 0x35
	ds   1
	global	main@ms
main@ms:	; 2 bytes @ 0x36
	ds   2
	global	main@t
main@t:	; 1 bytes @ 0x38
	ds   1
psect	cstackCOMRAM,class=COMRAM,space=1,noexec,lowdata
global __pcstackCOMRAM
__pcstackCOMRAM:
?_isr:	; 1 bytes @ 0x0
?_LCD_Nib:	; 1 bytes @ 0x0
?_LCD_Init:	; 1 bytes @ 0x0
?_leer_teclado:	; 1 bytes @ 0x0
?_UART_Init:	; 1 bytes @ 0x0
?_UART_TxFree:	; 1 bytes @ 0x0
?_UART_PutChar:	; 1 bytes @ 0x0
?_UART_PumpTx:	; 1 bytes @ 0x0
?_UART_EmitEmg:	; 1 bytes @ 0x0
?_UART_EnviarEstado:	; 1 bytes @ 0x0
?_reiniciar_sistema:	; 1 bytes @ 0x0
?_procesar_tecla:	; 1 bytes @ 0x0
?_actualizar_todo:	; 1 bytes @ 0x0
?_UART_ProcessRx:	; 1 bytes @ 0x0
?_main:	; 1 bytes @ 0x0
??_isr:	; 1 bytes @ 0x0
	ds   2
	global	isr@dummy
isr@dummy:	; 1 bytes @ 0x2
	ds   1
	global	isr@c
isr@c:	; 1 bytes @ 0x3
	ds   1
	global	isr@next
isr@next:	; 1 bytes @ 0x4
	ds   1
?_strcpy:	; 1 bytes @ 0x5
?_beep:	; 1 bytes @ 0x5
?_poner_msg:	; 1 bytes @ 0x5
?_estado_char:	; 1 bytes @ 0x5
?_agregar_cola_espera:	; 1 bytes @ 0x5
?_quitar_cola_espera:	; 1 bytes @ 0x5
	global	?_strncmp
?_strncmp:	; 2 bytes @ 0x5
?_memcpy:	; 2 bytes @ 0x5
?_memset:	; 2 bytes @ 0x5
	global	?___awdiv
?___awdiv:	; 2 bytes @ 0x5
	global	?___awmod
?___awmod:	; 2 bytes @ 0x5
	global	?_vabs
?_vabs:	; 2 bytes @ 0x5
	global	?_tiene_paradas
?_tiene_paradas:	; 2 bytes @ 0x5
	global	?_contar_paradas
?_contar_paradas:	; 2 bytes @ 0x5
	global	?_contar_destinos
?_contar_destinos:	; 2 bytes @ 0x5
	global	?_parse_2d
?_parse_2d:	; 2 bytes @ 0x5
	global	parse_2d@s
parse_2d@s:	; 1 bytes @ 0x5
	global	strcpy@dest
strcpy@dest:	; 1 bytes @ 0x5
	global	vabs@x
vabs@x:	; 2 bytes @ 0x5
	global	beep@t
beep@t:	; 2 bytes @ 0x5
	global	poner_msg@s
poner_msg@s:	; 2 bytes @ 0x5
	global	estado_char@e
estado_char@e:	; 2 bytes @ 0x5
	global	agregar_cola_espera@e
agregar_cola_espera@e:	; 2 bytes @ 0x5
	global	quitar_cola_espera@e
quitar_cola_espera@e:	; 2 bytes @ 0x5
	global	tiene_paradas@e
tiene_paradas@e:	; 2 bytes @ 0x5
	global	contar_paradas@e
contar_paradas@e:	; 2 bytes @ 0x5
	global	contar_destinos@e
contar_destinos@e:	; 2 bytes @ 0x5
	global	___awdiv@dividend
___awdiv@dividend:	; 2 bytes @ 0x5
	global	___awmod@dividend
___awmod@dividend:	; 2 bytes @ 0x5
	global	memcpy@d1
memcpy@d1:	; 2 bytes @ 0x5
	global	memset@dest
memset@dest:	; 2 bytes @ 0x5
	global	strncmp@l
strncmp@l:	; 2 bytes @ 0x5
??_LCD_Nib:	; 1 bytes @ 0x5
??_leer_teclado:	; 1 bytes @ 0x5
??_UART_Init:	; 1 bytes @ 0x5
??_UART_TxFree:	; 1 bytes @ 0x5
??_UART_PumpTx:	; 1 bytes @ 0x5
	ds   1
	global	LCD_Nib@n
LCD_Nib@n:	; 1 bytes @ 0x6
	global	strcpy@src
strcpy@src:	; 2 bytes @ 0x6
	ds   1
?_LCD_Byte:	; 1 bytes @ 0x7
	global	LCD_Byte@dato
LCD_Byte@dato:	; 1 bytes @ 0x7
	global	leer_teclado@t
leer_teclado@t:	; 1 bytes @ 0x7
	global	___awdiv@divisor
___awdiv@divisor:	; 2 bytes @ 0x7
	global	___awmod@divisor
___awmod@divisor:	; 2 bytes @ 0x7
	global	memcpy@s1
memcpy@s1:	; 2 bytes @ 0x7
	global	memset@c
memset@c:	; 2 bytes @ 0x7
	global	strncmp@r
strncmp@r:	; 2 bytes @ 0x7
??_vabs:	; 1 bytes @ 0x7
??_beep:	; 1 bytes @ 0x7
??_poner_msg:	; 1 bytes @ 0x7
??_estado_char:	; 1 bytes @ 0x7
??_agregar_cola_espera:	; 1 bytes @ 0x7
??_quitar_cola_espera:	; 1 bytes @ 0x7
??_tiene_paradas:	; 1 bytes @ 0x7
??_contar_paradas:	; 1 bytes @ 0x7
??_contar_destinos:	; 1 bytes @ 0x7
??_parse_2d:	; 1 bytes @ 0x7
	ds   1
	global	strcpy@d
strcpy@d:	; 1 bytes @ 0x8
	global	leer_teclado@f
leer_teclado@f:	; 2 bytes @ 0x8
??_strcpy:	; 1 bytes @ 0x8
??_LCD_Byte:	; 1 bytes @ 0x8
	ds   1
?_siguiente_objetivo:	; 1 bytes @ 0x9
	global	LCD_Byte@v
LCD_Byte@v:	; 1 bytes @ 0x9
	global	___awdiv@counter
___awdiv@counter:	; 1 bytes @ 0x9
	global	___awmod@counter
___awmod@counter:	; 1 bytes @ 0x9
	global	poner_msg@i
poner_msg@i:	; 2 bytes @ 0x9
	global	_estado_char$994
_estado_char$994:	; 2 bytes @ 0x9
	global	agregar_cola_espera@i
agregar_cola_espera@i:	; 2 bytes @ 0x9
	global	quitar_cola_espera@i
quitar_cola_espera@i:	; 2 bytes @ 0x9
	global	siguiente_objetivo@e
siguiente_objetivo@e:	; 2 bytes @ 0x9
	global	memcpy@n
memcpy@n:	; 2 bytes @ 0x9
	global	memset@n
memset@n:	; 2 bytes @ 0x9
	global	strncmp@n
strncmp@n:	; 2 bytes @ 0x9
??___awdiv:	; 1 bytes @ 0x9
??___awmod:	; 1 bytes @ 0x9
	ds   1
	global	___awdiv@sign
___awdiv@sign:	; 1 bytes @ 0xA
	global	___awmod@sign
___awmod@sign:	; 1 bytes @ 0xA
	global	parse_2d@v
parse_2d@v:	; 2 bytes @ 0xA
??_LCD_Init:	; 1 bytes @ 0xA
	ds   1
	global	memcpy@tmp
memcpy@tmp:	; 1 bytes @ 0xB
	global	quitar_cola_espera@j
quitar_cola_espera@j:	; 2 bytes @ 0xB
	global	tiene_paradas@p
tiene_paradas@p:	; 2 bytes @ 0xB
	global	contar_paradas@c
contar_paradas@c:	; 2 bytes @ 0xB
	global	contar_destinos@c
contar_destinos@c:	; 2 bytes @ 0xB
	global	___awdiv@quotient
___awdiv@quotient:	; 2 bytes @ 0xB
	global	memset@p
memset@p:	; 2 bytes @ 0xB
??_strncmp:	; 1 bytes @ 0xB
??_memcpy:	; 1 bytes @ 0xB
??_memset:	; 1 bytes @ 0xB
??_siguiente_objetivo:	; 1 bytes @ 0xB
	ds   1
	global	memcpy@d
memcpy@d:	; 2 bytes @ 0xC
	ds   1
?_dig:	; 1 bytes @ 0xD
	global	?_elev_esperando
?_elev_esperando:	; 2 bytes @ 0xD
	global	dig@v
dig@v:	; 2 bytes @ 0xD
	global	contar_paradas@p
contar_paradas@p:	; 2 bytes @ 0xD
	global	contar_destinos@p
contar_destinos@p:	; 2 bytes @ 0xD
	ds   1
	global	memcpy@s
memcpy@s:	; 2 bytes @ 0xE
	ds   1
?_poner_2d:	; 1 bytes @ 0xF
?_puerta_nivel:	; 1 bytes @ 0xF
	global	?_costo_elevador
?_costo_elevador:	; 2 bytes @ 0xF
	global	poner_2d@p
poner_2d@p:	; 1 bytes @ 0xF
	global	puerta_nivel@e
puerta_nivel@e:	; 2 bytes @ 0xF
	global	costo_elevador@e
costo_elevador@e:	; 2 bytes @ 0xF
??_dig:	; 1 bytes @ 0xF
??_elev_esperando:	; 1 bytes @ 0xF
	ds   1
?_LCD_Linea:	; 1 bytes @ 0x10
	global	LCD_Linea@txt
LCD_Linea@txt:	; 1 bytes @ 0x10
	global	poner_2d@v
poner_2d@v:	; 2 bytes @ 0x10
	ds   1
	global	elev_esperando@e
elev_esperando@e:	; 2 bytes @ 0x11
	global	siguiente_objetivo@d
siguiente_objetivo@d:	; 2 bytes @ 0x11
	global	costo_elevador@p_usr
costo_elevador@p_usr:	; 2 bytes @ 0x11
	global	LCD_Linea@l
LCD_Linea@l:	; 17 bytes @ 0x11
??_LCD_Linea:	; 1 bytes @ 0x11
??_puerta_nivel:	; 1 bytes @ 0x11
	ds   1
?_msg_elev:	; 1 bytes @ 0x12
	global	msg_elev@e
msg_elev@e:	; 2 bytes @ 0x12
??_poner_2d:	; 1 bytes @ 0x12
	ds   1
	global	_puerta_nivel$998
_puerta_nivel$998:	; 2 bytes @ 0x13
	global	_siguiente_objetivo$1075
_siguiente_objetivo$1075:	; 2 bytes @ 0x13
	global	costo_elevador@dir
costo_elevador@dir:	; 2 bytes @ 0x13
	ds   1
	global	msg_elev@plantilla
msg_elev@plantilla:	; 2 bytes @ 0x14
	ds   1
	global	_puerta_nivel$999
_puerta_nivel$999:	; 2 bytes @ 0x15
	global	_siguiente_objetivo$1076
_siguiente_objetivo$1076:	; 2 bytes @ 0x15
??_costo_elevador:	; 1 bytes @ 0x15
	ds   1
	global	msg_elev@pos_num
msg_elev@pos_num:	; 2 bytes @ 0x16
	ds   1
	global	puerta_nivel@r
puerta_nivel@r:	; 2 bytes @ 0x17
	global	siguiente_objetivo@mejor
siguiente_objetivo@mejor:	; 2 bytes @ 0x17
	ds   1
	global	msg_elev@num
msg_elev@num:	; 2 bytes @ 0x18
	ds   1
	global	UART_PutChar@c
UART_PutChar@c:	; 1 bytes @ 0x19
	global	siguiente_objetivo@min_p
siguiente_objetivo@min_p:	; 2 bytes @ 0x19
??_UART_PutChar:	; 1 bytes @ 0x19
	ds   1
	global	UART_PutChar@next
UART_PutChar@next:	; 1 bytes @ 0x1A
	global	msg_elev@m
msg_elev@m:	; 17 bytes @ 0x1A
??_msg_elev:	; 1 bytes @ 0x1A
	ds   1
?_UART_PutStr:	; 1 bytes @ 0x1B
?_UART_Put2d:	; 1 bytes @ 0x1B
?_UART_PutInt:	; 1 bytes @ 0x1B
?_UART_PutHex5:	; 1 bytes @ 0x1B
	global	UART_PutStr@s
UART_PutStr@s:	; 2 bytes @ 0x1B
	global	UART_Put2d@v
UART_Put2d@v:	; 2 bytes @ 0x1B
	global	UART_PutInt@v
UART_PutInt@v:	; 2 bytes @ 0x1B
	global	siguiente_objetivo@max_p
siguiente_objetivo@max_p:	; 2 bytes @ 0x1B
	global	UART_PutHex5@mask
UART_PutHex5@mask:	; 4 bytes @ 0x1B
	ds   2
?_UART_EmitEnq:	; 1 bytes @ 0x1D
?_UART_EmitDeq:	; 1 bytes @ 0x1D
	global	UART_EmitEnq@e
UART_EmitEnq@e:	; 2 bytes @ 0x1D
	global	UART_EmitDeq@e
UART_EmitDeq@e:	; 2 bytes @ 0x1D
	global	siguiente_objetivo@p
siguiente_objetivo@p:	; 2 bytes @ 0x1D
	global	UART_PutInt@tmp
UART_PutInt@tmp:	; 7 bytes @ 0x1D
??_UART_PutStr:	; 1 bytes @ 0x1D
??_UART_Put2d:	; 1 bytes @ 0x1D
??_UART_PutInt:	; 1 bytes @ 0x1D
??_UART_EmitEmg:	; 1 bytes @ 0x1D
	ds   1
	global	UART_EmitEmg@act
UART_EmitEmg@act:	; 1 bytes @ 0x1E
	ds   1
	global	UART_EmitEnq@fl
UART_EmitEnq@fl:	; 2 bytes @ 0x1F
	global	UART_EmitDeq@fl
UART_EmitDeq@fl:	; 2 bytes @ 0x1F
	global	_UART_EmitEmg$1033
_UART_EmitEmg$1033:	; 2 bytes @ 0x1F
??_UART_PutHex5:	; 1 bytes @ 0x1F
	ds   2
	global	UART_EmitEnq@tipo
UART_EmitEnq@tipo:	; 1 bytes @ 0x21
	global	UART_EmitDeq@tipo
UART_EmitDeq@tipo:	; 1 bytes @ 0x21
	ds   1
	global	_LCD_Linea$925
_LCD_Linea$925:	; 2 bytes @ 0x22
??_UART_EmitEnq:	; 1 bytes @ 0x22
??_UART_EmitDeq:	; 1 bytes @ 0x22
??_UART_EnviarEstado:	; 1 bytes @ 0x22
	ds   2
	global	LCD_Linea@fila
LCD_Linea@fila:	; 1 bytes @ 0x24
	global	UART_PutInt@i
UART_PutInt@i:	; 2 bytes @ 0x24
	ds   1
	global	LCD_Linea@cache
LCD_Linea@cache:	; 2 bytes @ 0x25
	ds   1
?_UART_EmitDsp:	; 1 bytes @ 0x26
?_UART_EmitCfg:	; 1 bytes @ 0x26
	global	UART_EmitDsp@fl
UART_EmitDsp@fl:	; 2 bytes @ 0x26
	global	UART_EmitCfg@n
UART_EmitCfg@n:	; 2 bytes @ 0x26
	ds   1
	global	LCD_Linea@i
LCD_Linea@i:	; 2 bytes @ 0x27
	global	costo_elevador@carga
costo_elevador@carga:	; 2 bytes @ 0x27
	global	UART_EnviarEstado@pk
UART_EnviarEstado@pk:	; 4 bytes @ 0x27
	ds   1
	global	UART_EmitDsp@dir_c
UART_EmitDsp@dir_c:	; 1 bytes @ 0x28
	global	UART_EmitCfg@podadas
UART_EmitCfg@podadas:	; 2 bytes @ 0x28
	ds   1
	global	UART_EmitDsp@chosen
UART_EmitDsp@chosen:	; 2 bytes @ 0x29
	global	costo_elevador@lejano
costo_elevador@lejano:	; 2 bytes @ 0x29
	ds   1
??_UART_EmitCfg:	; 1 bytes @ 0x2A
	ds   1
	global	UART_EmitDsp@c0
UART_EmitDsp@c0:	; 2 bytes @ 0x2B
	global	costo_elevador@inter
costo_elevador@inter:	; 2 bytes @ 0x2B
	global	UART_EnviarEstado@ds
UART_EnviarEstado@ds:	; 4 bytes @ 0x2B
	ds   2
	global	UART_EmitDsp@c1
UART_EmitDsp@c1:	; 2 bytes @ 0x2D
	global	costo_elevador@p
costo_elevador@p:	; 2 bytes @ 0x2D
	ds   2
	global	UART_EmitDsp@c2
UART_EmitDsp@c2:	; 2 bytes @ 0x2F
	global	_UART_EnviarEstado$1041
_UART_EnviarEstado$1041:	; 2 bytes @ 0x2F
	ds   2
	global	UART_EnviarEstado@p
UART_EnviarEstado@p:	; 2 bytes @ 0x31
??_UART_EmitDsp:	; 1 bytes @ 0x31
	ds   2
	global	UART_EnviarEstado@e
UART_EnviarEstado@e:	; 2 bytes @ 0x33
	ds   2
?_cambiar_num_pisos:	; 1 bytes @ 0x35
?_llamar_pasillo_piso:	; 1 bytes @ 0x35
?_encolar_destino_cabina:	; 1 bytes @ 0x35
?_atender_llegada:	; 1 bytes @ 0x35
	global	cambiar_num_pisos@n
cambiar_num_pisos@n:	; 2 bytes @ 0x35
	global	llamar_pasillo_piso@fl
llamar_pasillo_piso@fl:	; 2 bytes @ 0x35
	global	encolar_destino_cabina@w
encolar_destino_cabina@w:	; 2 bytes @ 0x35
	global	atender_llegada@e
atender_llegada@e:	; 2 bytes @ 0x35
??_reiniciar_sistema:	; 1 bytes @ 0x35
	ds   1
	global	_reiniciar_sistema$1100
_reiniciar_sistema$1100:	; 2 bytes @ 0x36
	ds   1
	global	llamar_pasillo_piso@dir
llamar_pasillo_piso@dir:	; 2 bytes @ 0x37
	global	encolar_destino_cabina@num
encolar_destino_cabina@num:	; 2 bytes @ 0x37
??_cambiar_num_pisos:	; 1 bytes @ 0x37
??_atender_llegada:	; 1 bytes @ 0x37
	ds   1
	global	reiniciar_sistema@e
reiniciar_sistema@e:	; 2 bytes @ 0x38
	ds   1
??_llamar_pasillo_piso:	; 1 bytes @ 0x39
??_encolar_destino_cabina:	; 1 bytes @ 0x39
	ds   2
	global	atender_llegada@had_dest
atender_llegada@had_dest:	; 1 bytes @ 0x3B
	global	cambiar_num_pisos@podadas
cambiar_num_pisos@podadas:	; 2 bytes @ 0x3B
	ds   1
	global	atender_llegada@mas_arriba
atender_llegada@mas_arriba:	; 2 bytes @ 0x3C
	ds   1
	global	llamar_pasillo_piso@nueva
llamar_pasillo_piso@nueva:	; 1 bytes @ 0x3D
	global	encolar_destino_cabina@nueva
encolar_destino_cabina@nueva:	; 1 bytes @ 0x3D
	global	cambiar_num_pisos@p
cambiar_num_pisos@p:	; 2 bytes @ 0x3D
	ds   1
	global	llamar_pasillo_piso@best
llamar_pasillo_piso@best:	; 2 bytes @ 0x3E
	global	atender_llegada@mas_abajo
atender_llegada@mas_abajo:	; 2 bytes @ 0x3E
??_procesar_tecla:	; 1 bytes @ 0x3E
	ds   1
	global	cambiar_num_pisos@e
cambiar_num_pisos@e:	; 2 bytes @ 0x3F
	ds   1
	global	atender_llegada@had_pickup
atender_llegada@had_pickup:	; 1 bytes @ 0x40
	global	_llamar_pasillo_piso$1111
_llamar_pasillo_piso$1111:	; 2 bytes @ 0x40
	global	_procesar_tecla$1146
_procesar_tecla$1146:	; 2 bytes @ 0x40
	ds   1
	global	atender_llegada@p
atender_llegada@p:	; 2 bytes @ 0x41
	ds   1
	global	_llamar_pasillo_piso$1113
_llamar_pasillo_piso$1113:	; 2 bytes @ 0x42
	global	procesar_tecla@w
procesar_tecla@w:	; 2 bytes @ 0x42
	ds   1
	global	atender_llegada@mask
atender_llegada@mask:	; 1 bytes @ 0x43
	ds   1
	global	_llamar_pasillo_piso$1123
_llamar_pasillo_piso$1123:	; 2 bytes @ 0x44
	global	procesar_tecla@num
procesar_tecla@num:	; 2 bytes @ 0x44
	global	atender_llegada@fl
atender_llegada@fl:	; 2 bytes @ 0x44
	ds   2
	global	procesar_tecla@k
procesar_tecla@k:	; 1 bytes @ 0x46
	global	llamar_pasillo_piso@costos
llamar_pasillo_piso@costos:	; 6 bytes @ 0x46
??_actualizar_todo:	; 1 bytes @ 0x46
	ds   1
	global	procesar_tecla@e
procesar_tecla@e:	; 2 bytes @ 0x47
	ds   5
	global	llamar_pasillo_piso@dir_c
llamar_pasillo_piso@dir_c:	; 1 bytes @ 0x4C
	ds   1
	global	llamar_pasillo_piso@bit
llamar_pasillo_piso@bit:	; 1 bytes @ 0x4D
	ds   1
	global	llamar_pasillo_piso@e
llamar_pasillo_piso@e:	; 2 bytes @ 0x4E
	ds   2
	global	llamar_pasillo_piso@mejor
llamar_pasillo_piso@mejor:	; 2 bytes @ 0x50
	ds   2
?_llamar_pasillo:	; 1 bytes @ 0x52
	global	llamar_pasillo@dir
llamar_pasillo@dir:	; 2 bytes @ 0x52
	ds   2
??_llamar_pasillo:	; 1 bytes @ 0x54
??_UART_ProcessRx:	; 1 bytes @ 0x54
;!
;!Data Sizes:
;!    Strings     420
;!    Constant    32
;!    Data        36
;!    BSS         499
;!    Persistent  0
;!    Stack       0
;!
;!Auto Spaces:
;!    Space          Size  Autos    Used
;!    COMRAM           94     84      89
;!    BANK0           160     57     153
;!    BANK1           256      0     178
;!    BANK2           256      0     256
;!    BANK3           256      0       0
;!    BANK4           256      0       0
;!    BANK5           256      0       0
;!    BANK6           256      0       0
;!    BANK7           256      0       0

;!
;!Pointer List with Targets:
;!
;!    LCD_Linea@cache	PTR unsigned char  size(2) Largest target is 17
;!		 -> prev_l1(BANK1[17]), prev_l2(BANK1[17]), 
;!
;!    LCD_Linea@txt	PTR const unsigned char  size(1) Largest target is 17
;!		 -> actualizar_todo@l1(BANK0[17]), actualizar_todo@l2(BANK0[17]), 
;!
;!    llamar_pasillo_piso$1123	PTR const unsigned char  size(2) Largest target is 17
;!		 -> STR_17(CODE[17]), STR_18(CODE[17]), 
;!
;!    memcpy@d	PTR unsigned char  size(2) Largest target is 17
;!		 -> actualizar_todo@l2(BANK0[17]), prev_l1(BANK1[17]), prev_l2(BANK1[17]), 
;!
;!    memcpy@d1	PTR void  size(2) Largest target is 17
;!		 -> actualizar_todo@l2(BANK0[17]), prev_l1(BANK1[17]), prev_l2(BANK1[17]), 
;!
;!    memcpy@s	PTR const unsigned char  size(2) Largest target is 17
;!		 -> LCD_Linea@l(COMRAM[17]), msg_lcd(BANK1[17]), 
;!
;!    memcpy@s1	PTR const void  size(2) Largest target is 17
;!		 -> LCD_Linea@l(COMRAM[17]), msg_lcd(BANK1[17]), 
;!
;!    memset@dest	PTR void  size(2) Largest target is 63
;!		 -> paradas(BANK1[63]), 
;!
;!    memset@p	PTR unsigned char  size(2) Largest target is 63
;!		 -> paradas(BANK1[63]), 
;!
;!    msg_elev@plantilla	PTR const unsigned char  size(2) Largest target is 17
;!		 -> STR_13(CODE[17]), STR_16(CODE[17]), STR_17(CODE[17]), STR_18(CODE[17]), 
;!		 -> STR_21(CODE[17]), STR_22(CODE[17]), STR_24(CODE[17]), STR_27(CODE[17]), 
;!		 -> STR_28(CODE[17]), STR_29(CODE[17]), STR_30(CODE[17]), STR_32(CODE[17]), 
;!		 -> STR_33(CODE[17]), STR_34(CODE[17]), 
;!
;!    parse_2d@s	PTR const unsigned char  size(1) Largest target is 20
;!		 -> uart_rx(BANK0[20]), 
;!
;!    poner_2d@p	PTR unsigned char  size(1) Largest target is 17
;!		 -> actualizar_todo@l1(BANK0[17]), actualizar_todo@l2(BANK0[17]), msg_elev@m(COMRAM[17]), 
;!
;!    poner_msg@s	PTR const unsigned char  size(2) Largest target is 17
;!		 -> msg_elev@m(COMRAM[17]), STR_14(CODE[17]), STR_19(CODE[17]), STR_20(CODE[17]), 
;!		 -> STR_23(CODE[17]), STR_25(CODE[17]), STR_26(CODE[17]), STR_31(CODE[17]), 
;!
;!    sp__memcpy	PTR void  size(2) Largest target is 17
;!		 -> actualizar_todo@l2(BANK0[17]), prev_l1(BANK1[17]), prev_l2(BANK1[17]), 
;!
;!    sp__memset	PTR void  size(2) Largest target is 63
;!		 -> paradas(BANK1[63]), 
;!
;!    sp__strcpy	PTR unsigned char  size(1) Largest target is 17
;!		 -> actualizar_todo@l1(BANK0[17]), actualizar_todo@l2(BANK0[17]), msg_elev@m(COMRAM[17]), 
;!
;!    strcpy@d	PTR unsigned char  size(1) Largest target is 17
;!		 -> actualizar_todo@l1(BANK0[17]), actualizar_todo@l2(BANK0[17]), msg_elev@m(COMRAM[17]), 
;!
;!    strcpy@dest	PTR unsigned char  size(1) Largest target is 17
;!		 -> actualizar_todo@l1(BANK0[17]), actualizar_todo@l2(BANK0[17]), msg_elev@m(COMRAM[17]), 
;!
;!    strcpy@src	PTR const unsigned char  size(2) Largest target is 17
;!		 -> STR_13(CODE[17]), STR_16(CODE[17]), STR_17(CODE[17]), STR_18(CODE[17]), 
;!		 -> STR_21(CODE[17]), STR_22(CODE[17]), STR_24(CODE[17]), STR_27(CODE[17]), 
;!		 -> STR_28(CODE[17]), STR_29(CODE[17]), STR_30(CODE[17]), STR_32(CODE[17]), 
;!		 -> STR_33(CODE[17]), STR_34(CODE[17]), STR_35(CODE[17]), STR_36(CODE[17]), 
;!		 -> STR_37(CODE[17]), STR_38(CODE[17]), STR_39(CODE[17]), STR_41(CODE[17]), 
;!		 -> STR_42(CODE[17]), STR_43(CODE[17]), 
;!
;!    strncmp@l	PTR const unsigned char  size(2) Largest target is 17
;!		 -> msg_lcd(BANK1[17]), prev_l1(BANK1[17]), prev_l2(BANK1[17]), 
;!
;!    strncmp@r	PTR const unsigned char  size(2) Largest target is 17
;!		 -> LCD_Linea@l(COMRAM[17]), STR_40(CODE[17]), 
;!
;!    UART_PutStr@s	PTR const unsigned char  size(2) Largest target is 8
;!		 -> STR_1(CODE[7]), STR_10(CODE[3]), STR_11(CODE[3]), STR_12(CODE[3]), 
;!		 -> STR_15(CODE[8]), STR_2(CODE[3]), STR_3(CODE[7]), STR_4(CODE[3]), 
;!		 -> STR_5(CODE[7]), STR_6(CODE[3]), STR_7(CODE[7]), STR_8(CODE[3]), 
;!		 -> STR_9(CODE[7]), 
;!


;!
;!Critical Paths under _main in COMRAM
;!
;!    _main->_llamar_pasillo
;!    _actualizar_todo->_atender_llegada
;!    _atender_llegada->_UART_EnviarEstado
;!    _UART_EmitDeq->_UART_Put2d
;!    _UART_EmitDeq->_UART_PutStr
;!    _LCD_Linea->_memcpy
;!    _UART_ProcessRx->_llamar_pasillo
;!    _reiniciar_sistema->_UART_EnviarEstado
;!    _procesar_tecla->_encolar_destino_cabina
;!    _encolar_destino_cabina->_UART_EnviarEstado
;!    _elev_esperando->_quitar_cola_espera
;!    _UART_EmitEmg->_UART_PutStr
;!    _llamar_pasillo->_llamar_pasillo_piso
;!    _llamar_pasillo_piso->_UART_EnviarEstado
;!    _costo_elevador->_contar_paradas
;!    _UART_EmitEnq->_UART_Put2d
;!    _UART_EmitEnq->_UART_PutStr
;!    _UART_EmitDsp->_UART_PutInt
;!    _cambiar_num_pisos->_UART_EnviarEstado
;!    _siguiente_objetivo->_vabs
;!    _msg_elev->_poner_2d
;!    _poner_2d->_contar_destinos
;!    _poner_2d->_dig
;!    _UART_EnviarEstado->_UART_PutHex5
;!    _puerta_nivel->_dig
;!    _UART_PutHex5->_UART_PutChar
;!    _UART_EmitCfg->_UART_PutInt
;!    _UART_PutStr->_UART_PutChar
;!    _UART_PutInt->_UART_PutChar
;!    _UART_Put2d->_UART_PutChar
;!    _dig->___awdiv
;!    _UART_PutChar->_puerta_nivel
;!    _LCD_Init->_LCD_Byte
;!    _LCD_Byte->_LCD_Nib
;!
;!Critical Paths under _isr in COMRAM
;!
;!    None.
;!
;!Critical Paths under _main in BANK0
;!
;!    _main->_actualizar_todo
;!    _UART_ProcessRx->_llamar_pasillo
;!
;!Critical Paths under _isr in BANK0
;!
;!    None.
;!
;!Critical Paths under _main in BANK1
;!
;!    None.
;!
;!Critical Paths under _isr in BANK1
;!
;!    None.
;!
;!Critical Paths under _main in BANK2
;!
;!    None.
;!
;!Critical Paths under _isr in BANK2
;!
;!    None.
;!
;!Critical Paths under _main in BANK3
;!
;!    None.
;!
;!Critical Paths under _isr in BANK3
;!
;!    None.
;!
;!Critical Paths under _main in BANK4
;!
;!    None.
;!
;!Critical Paths under _isr in BANK4
;!
;!    None.
;!
;!Critical Paths under _main in BANK5
;!
;!    None.
;!
;!Critical Paths under _isr in BANK5
;!
;!    None.
;!
;!Critical Paths under _main in BANK6
;!
;!    None.
;!
;!Critical Paths under _isr in BANK6
;!
;!    None.
;!
;!Critical Paths under _main in BANK7
;!
;!    None.
;!
;!Critical Paths under _isr in BANK7
;!
;!    None.

;;
;;Main: autosize = 0, tempsize = 1, incstack = 0, save=0
;;

;!
;!Call Graph Tables:
;!
;! ---------------------------------------------------------------------------------
;! (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;! ---------------------------------------------------------------------------------
;! (0) _main                                                 4     4      0  179783
;!                                             53 BANK0      4     4      0
;!                           _LCD_Init
;!                  _UART_EnviarEstado
;!                          _UART_Init
;!                     _UART_ProcessRx
;!                        _UART_PumpTx
;!                    _actualizar_todo
;!                       _leer_teclado
;!                     _llamar_pasillo
;!                             _memset
;!                     _procesar_tecla
;! ---------------------------------------------------------------------------------
;! (1) _leer_teclado                                         5     5      0     269
;!                                              5 COMRAM     5     5      0
;! ---------------------------------------------------------------------------------
;! (1) _actualizar_todo                                     58    58      0   29526
;!                                             70 COMRAM     5     5      0
;!                                              0 BANK0     53    53      0
;!                          _LCD_Linea
;!                  _UART_EnviarEstado
;!                            ___awdiv
;!                    _atender_llegada
;!                    _contar_destinos
;!                                _dig
;!                     _elev_esperando
;!                             _memcpy
;!                           _msg_elev
;!                           _poner_2d
;!                 _quitar_cola_espera
;!                 _siguiente_objetivo
;!                             _strcpy
;!                            _strncmp
;!                      _tiene_paradas
;! ---------------------------------------------------------------------------------
;! (2) _contar_destinos                                     10     8      2     139
;!                                              5 COMRAM    10     8      2
;! ---------------------------------------------------------------------------------
;! (2) _atender_llegada                                     17    15      2   11525
;!                                             53 COMRAM    17    15      2
;!                       _UART_EmitDeq
;!                  _UART_EnviarEstado
;!                _agregar_cola_espera
;!                               _beep
;!                           _msg_elev
;! ---------------------------------------------------------------------------------
;! (3) _UART_EmitDeq                                         6     1      5    2264
;!                                             29 COMRAM     6     1      5
;!                         _UART_Put2d
;!                       _UART_PutChar
;!                        _UART_PutStr
;!                        _UART_TxFree
;!                                _dig
;! ---------------------------------------------------------------------------------
;! (2) _LCD_Linea                                           25    24      1    1721
;!                                             16 COMRAM    25    24      1
;!                           _LCD_Byte
;!                             _memcpy
;!                            _strncmp
;! ---------------------------------------------------------------------------------
;! (3) _strncmp                                              8     2      6     275
;!                                              5 COMRAM     8     2      6
;! ---------------------------------------------------------------------------------
;! (3) _memcpy                                              11     5      6     226
;!                                              5 COMRAM    11     5      6
;! ---------------------------------------------------------------------------------
;! (1) _UART_PumpTx                                          0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _UART_ProcessRx                                      10    10      0   98889
;!                                              2 BANK0     10    10      0
;!                  _cambiar_num_pisos
;!             _encolar_destino_cabina
;!                     _llamar_pasillo
;!                _llamar_pasillo_piso
;!                           _parse_2d
;!                     _procesar_tecla
;!                  _reiniciar_sistema
;! ---------------------------------------------------------------------------------
;! (2) _reiniciar_sistema                                    5     5      0    5591
;!                                             53 COMRAM     5     5      0
;!                  _UART_EnviarEstado
;!                        _UART_PutStr
;!                        _UART_TxFree
;!                            ___awdiv
;!                             _memset
;!                          _poner_msg
;! ---------------------------------------------------------------------------------
;! (3) _memset                                               8     2      6     155
;!                                              5 COMRAM     8     2      6
;! ---------------------------------------------------------------------------------
;! (2) _procesar_tecla                                      11    11      0   25557
;!                                             62 COMRAM    11    11      0
;!                       _UART_EmitEmg
;!                  _UART_EnviarEstado
;!                               _beep
;!                     _elev_esperando
;!             _encolar_destino_cabina
;!                           _msg_elev
;!                          _poner_msg
;!                 _quitar_cola_espera
;!                 _siguiente_objetivo
;!                      _tiene_paradas
;! ---------------------------------------------------------------------------------
;! (3) _encolar_destino_cabina                               9     5      4   12878
;!                                             53 COMRAM     9     5      4
;!                       _UART_EmitEnq
;!                  _UART_EnviarEstado
;!                               _beep
;!                           _msg_elev
;!                          _poner_msg
;!                 _siguiente_objetivo
;! ---------------------------------------------------------------------------------
;! (3) _elev_esperando                                       6     4      2     461
;!                                             13 COMRAM     6     4      2
;!                 _quitar_cola_espera
;! ---------------------------------------------------------------------------------
;! (4) _quitar_cola_espera                                   8     6      2     303
;!                                              5 COMRAM     8     6      2
;! ---------------------------------------------------------------------------------
;! (3) _UART_EmitEmg                                         4     4      0     412
;!                                             29 COMRAM     4     4      0
;!                       _UART_PutChar
;!                        _UART_PutStr
;!                        _UART_TxFree
;! ---------------------------------------------------------------------------------
;! (2) _parse_2d                                             7     5      2     266
;!                                              5 COMRAM     7     5      2
;! ---------------------------------------------------------------------------------
;! (2) _llamar_pasillo                                       4     2      2   20471
;!                                             82 COMRAM     2     0      2
;!                                              0 BANK0      2     2      0
;!                               _beep
;!                _llamar_pasillo_piso
;!                          _poner_msg
;! ---------------------------------------------------------------------------------
;! (3) _llamar_pasillo_piso                                 29    25      4   20021
;!                                             53 COMRAM    29    25      4
;!                       _UART_EmitDsp
;!                       _UART_EmitEnq
;!                  _UART_EnviarEstado
;!                _agregar_cola_espera
;!                               _beep
;!                     _costo_elevador
;!                           _msg_elev
;!                 _siguiente_objetivo
;! ---------------------------------------------------------------------------------
;! (4) _costo_elevador                                      32    26      6    2331
;!                                             15 COMRAM    32    26      6
;!                     _contar_paradas
;!                               _vabs
;! ---------------------------------------------------------------------------------
;! (5) _contar_paradas                                      10     8      2     139
;!                                              5 COMRAM    10     8      2
;! ---------------------------------------------------------------------------------
;! (4) _agregar_cola_espera                                  6     4      2     136
;!                                              5 COMRAM     6     4      2
;! ---------------------------------------------------------------------------------
;! (4) _UART_EmitEnq                                         6     1      5    2219
;!                                             29 COMRAM     6     1      5
;!                         _UART_Put2d
;!                       _UART_PutChar
;!                        _UART_PutStr
;!                        _UART_TxFree
;!                                _dig
;! ---------------------------------------------------------------------------------
;! (4) _UART_EmitDsp                                        12     1     11    3834
;!                                             38 COMRAM    12     1     11
;!                         _UART_Put2d
;!                       _UART_PutChar
;!                        _UART_PutInt
;!                        _UART_PutStr
;!                        _UART_TxFree
;!                                _dig
;! ---------------------------------------------------------------------------------
;! (2) _cambiar_num_pisos                                   12    10      2   13712
;!                                             53 COMRAM    12    10      2
;!                       _UART_EmitCfg
;!                  _UART_EnviarEstado
;!                               _beep
;!                           _msg_elev
;!                           _parse_2d (ARG)
;!                 _siguiente_objetivo
;!                      _tiene_paradas
;! ---------------------------------------------------------------------------------
;! (3) _tiene_paradas                                        8     6      2     111
;!                                              5 COMRAM     8     6      2
;! ---------------------------------------------------------------------------------
;! (4) _siguiente_objetivo                                  22    20      2    2662
;!                                              9 COMRAM    22    20      2
;!                               _vabs
;! ---------------------------------------------------------------------------------
;! (5) _vabs                                                 4     2      2     117
;!                                              5 COMRAM     4     2      2
;! ---------------------------------------------------------------------------------
;! (4) _msg_elev                                            25    17      8    2710
;!                                             18 COMRAM    25    17      8
;!                                _dig
;!                           _poner_2d
;!                          _poner_msg
;!                             _strcpy
;! ---------------------------------------------------------------------------------
;! (5) _strcpy                                               4     1      3     157
;!                                              5 COMRAM     4     1      3
;! ---------------------------------------------------------------------------------
;! (5) _poner_msg                                            6     4      2     312
;!                                              5 COMRAM     6     4      2
;! ---------------------------------------------------------------------------------
;! (5) _poner_2d                                             3     0      3    1233
;!                                             15 COMRAM     3     0      3
;!                            ___awdiv
;!                    _contar_destinos (ARG)
;!                                _dig
;! ---------------------------------------------------------------------------------
;! (4) _beep                                                 2     0      2      61
;!                                              5 COMRAM     2     0      2
;! ---------------------------------------------------------------------------------
;! (4) _UART_EnviarEstado                                   19    19      0    4124
;!                                             34 COMRAM    19    19      0
;!                         _UART_Put2d
;!                       _UART_PutChar
;!                       _UART_PutHex5
;!                        _UART_PutStr
;!                        _UART_TxFree
;!                        _estado_char
;!                       _puerta_nivel
;! ---------------------------------------------------------------------------------
;! (5) _puerta_nivel                                        10     8      2    1491
;!                                             15 COMRAM    10     8      2
;!                            ___awdiv
;!                                _dig
;! ---------------------------------------------------------------------------------
;! (5) _estado_char                                          6     4      2     164
;!                                              5 COMRAM     6     4      2
;! ---------------------------------------------------------------------------------
;! (5) _UART_PutHex5                                         7     3      4     279
;!                                             27 COMRAM     7     3      4
;!                       _UART_PutChar
;! ---------------------------------------------------------------------------------
;! (3) _UART_EmitCfg                                         5     1      4    3186
;!                                             38 COMRAM     5     1      4
;!                         _UART_Put2d
;!                       _UART_PutChar
;!                        _UART_PutInt
;!                        _UART_PutStr
;!                        _UART_TxFree
;! ---------------------------------------------------------------------------------
;! (5) _UART_TxFree                                          1     1      0       0
;!                                              5 COMRAM     1     1      0
;! ---------------------------------------------------------------------------------
;! (5) _UART_PutStr                                          2     0      2     216
;!                                             27 COMRAM     2     0      2
;!                       _UART_PutChar
;! ---------------------------------------------------------------------------------
;! (5) _UART_PutInt                                         11     9      2    1522
;!                                             27 COMRAM    11     9      2
;!                       _UART_PutChar
;!                            ___awdiv
;!                                _dig
;! ---------------------------------------------------------------------------------
;! (5) _UART_Put2d                                           2     0      2    1268
;!                                             27 COMRAM     2     0      2
;!                       _UART_PutChar
;!                            ___awdiv
;!                                _dig
;! ---------------------------------------------------------------------------------
;! (6) _dig                                                  2     0      2     512
;!                                             13 COMRAM     2     0      2
;!                            ___awdiv (ARG)
;!                            ___awmod
;! ---------------------------------------------------------------------------------
;! (7) ___awmod                                              6     2      4     439
;!                                              5 COMRAM     6     2      4
;! ---------------------------------------------------------------------------------
;! (6) ___awdiv                                              8     4      4     493
;!                                              5 COMRAM     8     4      4
;! ---------------------------------------------------------------------------------
;! (6) _UART_PutChar                                         2     2      0     112
;!                                             25 COMRAM     2     2      0
;!                            ___awdiv (ARG)
;!                                _dig (ARG)
;!                        _estado_char (ARG)
;!                       _puerta_nivel (ARG)
;! ---------------------------------------------------------------------------------
;! (1) _UART_Init                                            0     0      0       0
;! ---------------------------------------------------------------------------------
;! (1) _LCD_Init                                             1     1      0     597
;!                                             10 COMRAM     1     1      0
;!                           _LCD_Byte
;!                            _LCD_Nib
;! ---------------------------------------------------------------------------------
;! (3) _LCD_Byte                                             3     2      1     409
;!                                              7 COMRAM     3     2      1
;!                            _LCD_Nib
;! ---------------------------------------------------------------------------------
;! (4) _LCD_Nib                                              2     2      0     188
;!                                              5 COMRAM     2     2      0
;! ---------------------------------------------------------------------------------
;! Estimated maximum stack depth 7
;! ---------------------------------------------------------------------------------
;! (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;! ---------------------------------------------------------------------------------
;! (8) _isr                                                  5     5      0      69
;!                                              0 COMRAM     5     5      0
;! ---------------------------------------------------------------------------------
;! Estimated maximum stack depth 8
;! ---------------------------------------------------------------------------------
;!
;! Call Graph Graphs:
;!
;! _main (ROOT)
;!   _LCD_Init
;!     _LCD_Byte
;!       _LCD_Nib
;!     _LCD_Nib
;!   _UART_EnviarEstado
;!     _UART_Put2d
;!       _UART_PutChar
;!         ___awdiv (ARG)
;!         _dig (ARG)
;!           ___awdiv (ARG)
;!           ___awmod (ARG)
;!         _estado_char (ARG)
;!         _puerta_nivel (ARG)
;!           ___awdiv
;!           _dig
;!       ___awdiv
;!       _dig
;!     _UART_PutChar
;!     _UART_PutHex5
;!       _UART_PutChar
;!     _UART_PutStr
;!       _UART_PutChar
;!     _UART_TxFree
;!     _estado_char
;!     _puerta_nivel
;!   _UART_Init
;!   _UART_ProcessRx
;!     _cambiar_num_pisos
;!       _UART_EmitCfg
;!         _UART_Put2d
;!         _UART_PutChar
;!         _UART_PutInt
;!           _UART_PutChar
;!           ___awdiv
;!           _dig
;!         _UART_PutStr
;!         _UART_TxFree
;!       _UART_EnviarEstado
;!       _beep
;!       _msg_elev
;!         _dig
;!         _poner_2d
;!           ___awdiv
;!           _contar_destinos (ARG)
;!           _dig (ARG)
;!         _poner_msg
;!         _strcpy
;!       _parse_2d (ARG)
;!       _siguiente_objetivo (ARG)
;!         _vabs
;!       _tiene_paradas (ARG)
;!     _encolar_destino_cabina
;!       _UART_EmitEnq
;!         _UART_Put2d
;!         _UART_PutChar
;!         _UART_PutStr
;!         _UART_TxFree
;!         _dig
;!       _UART_EnviarEstado
;!       _beep
;!       _msg_elev
;!       _poner_msg
;!       _siguiente_objetivo
;!     _llamar_pasillo
;!       _beep
;!       _llamar_pasillo_piso
;!         _UART_EmitDsp
;!           _UART_Put2d
;!           _UART_PutChar
;!           _UART_PutInt
;!           _UART_PutStr
;!           _UART_TxFree
;!           _dig
;!         _UART_EmitEnq
;!         _UART_EnviarEstado
;!         _agregar_cola_espera
;!         _beep
;!         _costo_elevador
;!           _contar_paradas
;!           _vabs
;!         _msg_elev
;!         _siguiente_objetivo
;!       _poner_msg
;!     _llamar_pasillo_piso
;!     _parse_2d
;!     _procesar_tecla
;!       _UART_EmitEmg
;!         _UART_PutChar
;!         _UART_PutStr
;!         _UART_TxFree
;!       _UART_EnviarEstado
;!       _beep
;!       _elev_esperando
;!         _quitar_cola_espera
;!       _encolar_destino_cabina
;!       _msg_elev
;!       _poner_msg
;!       _quitar_cola_espera
;!       _siguiente_objetivo
;!       _tiene_paradas
;!     _reiniciar_sistema
;!       _UART_EnviarEstado
;!       _UART_PutStr
;!       _UART_TxFree
;!       ___awdiv
;!       _memset
;!       _poner_msg
;!   _UART_PumpTx
;!   _actualizar_todo
;!     _LCD_Linea
;!       _LCD_Byte
;!       _memcpy
;!       _strncmp
;!     _UART_EnviarEstado
;!     ___awdiv
;!     _atender_llegada
;!       _UART_EmitDeq
;!         _UART_Put2d
;!         _UART_PutChar
;!         _UART_PutStr
;!         _UART_TxFree
;!         _dig
;!       _UART_EnviarEstado
;!       _agregar_cola_espera
;!       _beep
;!       _msg_elev
;!     _contar_destinos
;!     _dig
;!     _elev_esperando
;!     _memcpy
;!     _msg_elev
;!     _poner_2d
;!     _quitar_cola_espera
;!     _siguiente_objetivo
;!     _strcpy
;!     _strncmp
;!     _tiene_paradas
;!   _leer_teclado
;!   _llamar_pasillo
;!   _memset
;!   _procesar_tecla
;!
;! _isr (ROOT)
;!

;!Address spaces:

;!Name               Size   Autos  Total    Usage
;!BIGRAM            2047      0       0      0.0%
;!BITBANK7           256      0       0      0.0%
;!BANK7              256      0       0      0.0%
;!BITBANK6           256      0       0      0.0%
;!BANK6              256      0       0      0.0%
;!BITBANK5           256      0       0      0.0%
;!BANK5              256      0       0      0.0%
;!BITBANK4           256      0       0      0.0%
;!BANK4              256      0       0      0.0%
;!BITBANK3           256      0       0      0.0%
;!BANK3              256      0       0      0.0%
;!BITBANK2           256      0       0      0.0%
;!BANK2              256      0     256    100.0%
;!BITBANK1           256      0       0      0.0%
;!BANK1              256      0     178     69.5%
;!BITBANK0           160      0       0      0.0%
;!BANK0              160     57     153     95.6%
;!BITCOMRAM           94      0       0      0.0%
;!COMRAM              94     84      89     94.7%
;!BITBIGSFRh          82      0       0      0.0%
;!BITBIGSFRlh         43      0       0      0.0%
;!BITBIGSFRllh        27      0       0      0.0%
;!BITBIGSFRlll         5      0       0      0.0%
;!STACK                0      0       0      0.0%
;!DATA                 0      0     677      0.0%

	global	_main

;; *************** function _main *****************
;; Defined at:
;;		line 919 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  ms              2   54[BANK0 ] int 
;;  t               1   56[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       3       0       0       0       0       0       0       0
;;      Temps:          0       1       0       0       0       0       0       0       0
;;      Totals:         0       4       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels required when called: 6
;; This function calls:
;;		_LCD_Init
;;		_UART_EnviarEstado
;;		_UART_Init
;;		_UART_ProcessRx
;;		_UART_PumpTx
;;		_actualizar_todo
;;		_leer_teclado
;;		_llamar_pasillo
;;		_memset
;;		_procesar_tecla
;; This function is called by:
;;		Startup code after reset
;; This function uses a non-reentrant model
;;
psect	text0,class=CODE,space=0,reloc=2,group=0
	file	"LOGIC_TEST.c"
	line	919
global __ptext0
__ptext0:
psect	text0
	file	"LOGIC_TEST.c"
	line	919
	
_main:
;incstack = 0
	callstack 25
	line	920
	
l7655:
	movlw	(07h & ((1<<3)-1))<<4
	iorwf	((c:4051))^0f00h,c	;volatile
	line	921
	
l7657:
	clrf	((c:4034))^0f00h,c	;volatile
	movlw	low(0Fh)
	movwf	((c:4033))^0f00h,c	;volatile
	movlw	low(07h)
	movwf	((c:4020))^0f00h,c	;volatile
	
l7659:
	clrf	((c:3941))^0f00h,c	;volatile
	line	925
	movlw	low(03Fh)
	movwf	((c:3986))^0f00h,c	;volatile
	line	927
	
l7661:
	bcf	((c:3987))^0f00h,c,0	;volatile
	
l7663:
	bcf	((c:3987))^0f00h,c,1	;volatile
	
l7665:
	bcf	((c:3987))^0f00h,c,2	;volatile
	line	928
	
l7667:
	bsf	((c:3987))^0f00h,c,3	;volatile
	
l7669:
	bsf	((c:3987))^0f00h,c,4	;volatile
	line	929
	
l7671:
	bcf	((c:3987))^0f00h,c,5	;volatile
	line	930
	
l7673:
	bsf	((c:3987))^0f00h,c,6	;volatile
	
l7675:
	bsf	((c:3987))^0f00h,c,7	;volatile
	line	932
	
l7677:
	bcf	((c:3988))^0f00h,c,0	;volatile
	
l7679:
	bcf	((c:3988))^0f00h,c,1	;volatile
	
l7681:
	bcf	((c:3988))^0f00h,c,2	;volatile
	line	934
	
l7683:
	clrf	((c:3989))^0f00h,c	;volatile
	line	936
	
l7685:
	bsf	((c:3990))^0f00h,c,0	;volatile
	
l7687:
	bsf	((c:3990))^0f00h,c,1	;volatile
	
l7689:
	bcf	((c:3990))^0f00h,c,2	;volatile
	line	938
	
l7691:
	clrf	((c:3977))^0f00h,c	;volatile
	
l7693:
	clrf	((c:3978))^0f00h,c	;volatile
	
l7695:
	clrf	((c:3979))^0f00h,c	;volatile
	
l7697:
	clrf	((c:3980))^0f00h,c	;volatile
	
l7699:
	clrf	((c:3981))^0f00h,c	;volatile
	line	939
	
l7701:
		movlw	low(_paradas)
	movwf	((c:memset@dest))^00h,c
	movlw	high(_paradas)
	movwf	((c:memset@dest+1))^00h,c

	clrf	((c:memset@c+1))^00h,c
	movlw	low(0)
	movwf	((c:memset@c))^00h,c
	clrf	((c:memset@n+1))^00h,c
	movlw	low(03Fh)
	movwf	((c:memset@n))^00h,c
	call	_memset	;wreg free
	line	941
	
l7703:
	call	_LCD_Init	;wreg free
	line	942
	
l7705:
	call	_UART_Init	;wreg free
	line	943
	
l7707:
	call	_actualizar_todo	;wreg free
	line	944
	
l7709:
	call	_UART_EnviarEstado	;wreg free
	line	947
	
l7711:
	call	_leer_teclado	;wreg free
	movlb	0	; () banked
	movwf	((main@t))&0ffh
	line	948
	
l7713:; BSR set to: 0

	movf	((main@t))&0ffh,w
	btfsc	status,2
	goto	u11351
	goto	u11350
u11351:
	goto	l7719
u11350:
	
l7715:; BSR set to: 0

	movf	((_tecla_ant))&0ffh,w
xorwf	((main@t))&0ffh,w
	btfsc	status,2
	goto	u11361
	goto	u11360

u11361:
	goto	l7719
u11360:
	
l7717:; BSR set to: 0

	movf	((main@t))&0ffh,w
	
	call	_procesar_tecla
	line	949
	
l7719:
	movff	(main@t),(_tecla_ant)
	line	952
	
l7721:
	btfsc	((c:3969))^0f00h,c,4	;volatile
	goto	u11371
	goto	u11370
u11371:
	goto	l7727
u11370:
	
l7723:
	movlb	0	; () banked
		decf	((_subir_ant))&0ffh,w
iorwf	((_subir_ant+1))&0ffh,w
	btfss	status,2
	goto	u11381
	goto	u11380

u11381:
	goto	l7727
u11380:
	
l7725:; BSR set to: 0

	clrf	((c:llamar_pasillo@dir+1))^00h,c
	movlw	low(01h)
	movwf	((c:llamar_pasillo@dir))^00h,c
	call	_llamar_pasillo	;wreg free
	line	953
	
l7727:
	btfsc	((c:3969))^0f00h,c,4	;volatile
	goto	u11391
	goto	u11390
u11391:
	movlb	0	; () banked
	clrf	(??_main+0)&0ffh
	incf	(??_main+0)&0ffh
	goto	u11398
u11390:
	movlb	0	; () banked
	clrf	(??_main+0)&0ffh
u11398:
	movf	(??_main+0)&0ffh,w
	movwf	((_subir_ant))&0ffh
	clrf	((_subir_ant+1))&0ffh
	line	954
	
l7729:; BSR set to: 0

	btfsc	((c:3969))^0f00h,c,3	;volatile
	goto	u11401
	goto	u11400
u11401:
	goto	l7735
u11400:
	
l7731:; BSR set to: 0

		decf	((_bajar_ant))&0ffh,w
iorwf	((_bajar_ant+1))&0ffh,w
	btfss	status,2
	goto	u11411
	goto	u11410

u11411:
	goto	l7735
u11410:
	
l7733:; BSR set to: 0

	clrf	((c:llamar_pasillo@dir+1))^00h,c
	movlw	low(02h)
	movwf	((c:llamar_pasillo@dir))^00h,c
	call	_llamar_pasillo	;wreg free
	line	955
	
l7735:
	btfsc	((c:3969))^0f00h,c,3	;volatile
	goto	u11421
	goto	u11420
u11421:
	movlb	0	; () banked
	clrf	(??_main+0)&0ffh
	incf	(??_main+0)&0ffh
	goto	u11428
u11420:
	movlb	0	; () banked
	clrf	(??_main+0)&0ffh
u11428:
	movf	(??_main+0)&0ffh,w
	movwf	((_bajar_ant))&0ffh
	clrf	((_bajar_ant+1))&0ffh
	line	958
	
l7737:; BSR set to: 0

	clrf	((main@ms+1))&0ffh
	movlw	low(0)
	movwf	((main@ms))&0ffh
	line	959
	
l7743:; BSR set to: 0

	call	_UART_PumpTx	;wreg free
	line	960
	
l7745:
	call	_UART_ProcessRx	;wreg free
	line	961
	
l7747:; BSR set to: 0

	asmopt push
asmopt off
	movlw	200
u11457:
	nop2
decfsz	wreg,f
	bra	u11457
asmopt pop

	line	962
	
l7749:
	call	_UART_PumpTx	;wreg free
	line	963
	
l7751:
	asmopt push
asmopt off
	movlw	200
u11467:
	nop2
decfsz	wreg,f
	bra	u11467
asmopt pop

	line	964
	
l7753:
	movlb	0	; () banked
	infsnz	((main@ms))&0ffh
	incf	((main@ms+1))&0ffh
	
l7755:; BSR set to: 0

	btfsc	((main@ms+1))&0ffh,7
	goto	u11431
	movf	((main@ms+1))&0ffh,w
	bnz	u11430
	movlw	10
	subwf	 ((main@ms))&0ffh,w
	btfss	status,0
	goto	u11431
	goto	u11430

u11431:
	goto	l7743
u11430:
	line	966
	
l7757:; BSR set to: 0

	call	_actualizar_todo	;wreg free
	line	967
	
l7759:
	movlb	0	; () banked
	infsnz	((_cont_uart))&0ffh
	incf	((_cont_uart+1))&0ffh
	btfsc	((_cont_uart+1))&0ffh,7
	goto	u11441
	movf	((_cont_uart+1))&0ffh,w
	bnz	u11440
	movlw	25
	subwf	 ((_cont_uart))&0ffh,w
	btfss	status,0
	goto	u11441
	goto	u11440

u11441:
	goto	l7711
u11440:
	
l7761:; BSR set to: 0

	clrf	((_cont_uart+1))&0ffh
	movlw	low(0)
	movwf	((_cont_uart))&0ffh
	goto	l7709
	global	start
	goto	start
	callstack 0
	line	969
GLOBAL	__end_of_main
	__end_of_main:
	signat	_main,89
	global	_leer_teclado

;; *************** function _leer_teclado *****************
;; Defined at:
;;		line 172 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  f               2    8[COMRAM] int 
;;  t               1    7[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0, tblptrl, tblptrh, tblptru
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         3       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         5       0       0       0       0       0       0       0       0
;;Total ram usage:        5 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text1,class=CODE,space=0,reloc=2,group=0
	line	172
global __ptext1
__ptext1:
psect	text1
	file	"LOGIC_TEST.c"
	line	172
	
_leer_teclado:; BSR set to: 0

;incstack = 0
	callstack 29
	line	174
	
l7231:
	clrf	((c:leer_teclado@t))^00h,c
	line	176
	
l7233:
	clrf	((c:leer_teclado@f+1))^00h,c
	movlw	low(0)
	movwf	((c:leer_teclado@f))^00h,c
	line	177
	
l7239:
	movlw	(0Fh)&0ffh
	iorwf	((c:3986))^0f00h,c	;volatile
	movlw	(0F0h)&0ffh
	andwf	((c:3977))^0f00h,c	;volatile
	line	178
	movff	(c:leer_teclado@f),??_leer_teclado+0
	movlw	(01h)&0ffh
	movwf	(??_leer_teclado+1)^00h,c
	incf	(??_leer_teclado+0)^00h,c
	goto	u10234
u10235:
	bcf	status,0
	rlcf	((??_leer_teclado+1))^00h,c
u10234:
	decfsz	(??_leer_teclado+0)^00h,c
	goto	u10235
	movf	((??_leer_teclado+1))^00h,c,w
	xorlw	0ffh
	andwf	((c:3986))^0f00h,c	;volatile
	line	179
	
l7241:
	asmopt push
asmopt off
	movlw	10
u11477:
decfsz	wreg,f
	bra	u11477
asmopt pop

	line	180
	
l7243:
	btfsc	((c:3968))^0f00h,c,4	;volatile
	goto	u10241
	goto	u10240
u10241:
	goto	l225
u10240:
	
l7245:
	movff	(c:leer_teclado@f),??_leer_teclado+0
	movff	(c:leer_teclado@f+1),??_leer_teclado+0+1
	bcf	status,0
	rlcf	(??_leer_teclado+0)^00h,c
	rlcf	(??_leer_teclado+0+1)^00h,c
	bcf	status,0
	rlcf	(??_leer_teclado+0)^00h,c
	rlcf	(??_leer_teclado+0+1)^00h,c
	movlw	low((_TECLAS))
	addwf	(??_leer_teclado+0)^00h,c,w
	movwf	tblptrl
	movlw	high((_TECLAS))
	addwfc	(??_leer_teclado+0+1)^00h,c,w
	movwf	tblptrh
	if	0	;There are less than 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd	*
	
	movff	tablat,(c:leer_teclado@t)
	goto	l7257
	
l225:
	line	181
	btfsc	((c:3968))^0f00h,c,5	;volatile
	goto	u10251
	goto	u10250
u10251:
	goto	l226
u10250:
	
l7247:
	movff	(c:leer_teclado@f),??_leer_teclado+0
	movff	(c:leer_teclado@f+1),??_leer_teclado+0+1
	bcf	status,0
	rlcf	(??_leer_teclado+0)^00h,c
	rlcf	(??_leer_teclado+0+1)^00h,c
	bcf	status,0
	rlcf	(??_leer_teclado+0)^00h,c
	rlcf	(??_leer_teclado+0+1)^00h,c
	movlw	01h
	addwf	(??_leer_teclado+0)^00h,c
	movlw	0
	addwfc	(??_leer_teclado+0+1)^00h,c
	movlw	low((_TECLAS))
	addwf	(??_leer_teclado+0)^00h,c,w
	movwf	tblptrl
	movlw	high((_TECLAS))
	addwfc	(??_leer_teclado+0+1)^00h,c,w
	movwf	tblptrh
	if	0	;There are less than 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd	*
	
	movff	tablat,(c:leer_teclado@t)
	goto	l7257
	
l226:
	line	182
	btfsc	((c:3972))^0f00h,c,0	;volatile
	goto	u10261
	goto	u10260
u10261:
	goto	l227
u10260:
	
l7249:
	movff	(c:leer_teclado@f),??_leer_teclado+0
	movff	(c:leer_teclado@f+1),??_leer_teclado+0+1
	bcf	status,0
	rlcf	(??_leer_teclado+0)^00h,c
	rlcf	(??_leer_teclado+0+1)^00h,c
	bcf	status,0
	rlcf	(??_leer_teclado+0)^00h,c
	rlcf	(??_leer_teclado+0+1)^00h,c
	movlw	02h
	addwf	(??_leer_teclado+0)^00h,c
	movlw	0
	addwfc	(??_leer_teclado+0+1)^00h,c
	movlw	low((_TECLAS))
	addwf	(??_leer_teclado+0)^00h,c,w
	movwf	tblptrl
	movlw	high((_TECLAS))
	addwfc	(??_leer_teclado+0+1)^00h,c,w
	movwf	tblptrh
	if	0	;There are less than 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd	*
	
	movff	tablat,(c:leer_teclado@t)
	goto	l7257
	
l227:
	line	183
	btfsc	((c:3972))^0f00h,c,1	;volatile
	goto	u10271
	goto	u10270
u10271:
	goto	l7253
u10270:
	
l7251:
	movff	(c:leer_teclado@f),??_leer_teclado+0
	movff	(c:leer_teclado@f+1),??_leer_teclado+0+1
	bcf	status,0
	rlcf	(??_leer_teclado+0)^00h,c
	rlcf	(??_leer_teclado+0+1)^00h,c
	bcf	status,0
	rlcf	(??_leer_teclado+0)^00h,c
	rlcf	(??_leer_teclado+0+1)^00h,c
	movlw	03h
	addwf	(??_leer_teclado+0)^00h,c
	movlw	0
	addwfc	(??_leer_teclado+0+1)^00h,c
	movlw	low((_TECLAS))
	addwf	(??_leer_teclado+0)^00h,c,w
	movwf	tblptrl
	movlw	high((_TECLAS))
	addwfc	(??_leer_teclado+0+1)^00h,c,w
	movwf	tblptrh
	if	0	;There are less than 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd	*
	
	movff	tablat,(c:leer_teclado@t)
	goto	l7257
	line	184
	
l7253:
	infsnz	((c:leer_teclado@f))^00h,c
	incf	((c:leer_teclado@f+1))^00h,c
	
l7255:
	btfsc	((c:leer_teclado@f+1))^00h,c,7
	goto	u10281
	movf	((c:leer_teclado@f+1))^00h,c,w
	bnz	u10280
	movlw	4
	subwf	 ((c:leer_teclado@f))^00h,c,w
	btfss	status,0
	goto	u10281
	goto	u10280

u10281:
	goto	l7239
u10280:
	line	185
	
l7257:
	movlw	(0Fh)&0ffh
	iorwf	((c:3986))^0f00h,c	;volatile
	line	186
	
l7259:
	movf	((c:leer_teclado@t))^00h,c,w
	line	187
	
l229:
	return	;funcret
	callstack 0
GLOBAL	__end_of_leer_teclado
	__end_of_leer_teclado:
	signat	_leer_teclado,89
	global	_actualizar_todo

;; *************** function _actualizar_todo *****************
;; Defined at:
;;		line 767 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  l2             17   17[BANK0 ] unsigned char [17]
;;  l1             17    0[BANK0 ] unsigned char [17]
;;  e               2   51[BANK0 ] int 
;;  w               2   49[BANK0 ] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0      53       0       0       0       0       0       0       0
;;      Temps:          5       0       0       0       0       0       0       0       0
;;      Totals:         5      53       0       0       0       0       0       0       0
;;Total ram usage:       58 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 4
;; This function calls:
;;		_LCD_Linea
;;		_UART_EnviarEstado
;;		___awdiv
;;		_atender_llegada
;;		_contar_destinos
;;		_dig
;;		_elev_esperando
;;		_memcpy
;;		_msg_elev
;;		_poner_2d
;;		_quitar_cola_espera
;;		_siguiente_objetivo
;;		_strcpy
;;		_strncmp
;;		_tiene_paradas
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text2,class=CODE,space=0,reloc=2,group=0
	line	767
global __ptext2
__ptext2:
psect	text2
	file	"LOGIC_TEST.c"
	line	767
	
_actualizar_todo:
;incstack = 0
	callstack 26
	line	771
	
l7293:
	movlb	0	; () banked
	infsnz	((_cont_parp))&0ffh
	incf	((_cont_parp+1))&0ffh
	btfsc	((_cont_parp+1))&0ffh,7
	goto	u10311
	movf	((_cont_parp+1))&0ffh,w
	bnz	u10310
	movlw	35
	subwf	 ((_cont_parp))&0ffh,w
	btfss	status,0
	goto	u10311
	goto	u10310

u10311:
	goto	l637
u10310:
	
l7295:; BSR set to: 0

	clrf	((_cont_parp+1))&0ffh
	movlw	low(0)
	movwf	((_cont_parp))&0ffh
	movf	((_parpadeo))&0ffh,w
	btfsc	status,2
	goto	u10321
	goto	u10320
u10321:
	movlw	1
	goto	u10330
u10320:
	movlw	0
u10330:
	movwf	((_parpadeo))&0ffh
	
l637:; BSR set to: 0

	line	772
	movf	((c:_emergencia))^00h,c,w
	btfsc	status,2
	goto	u10341
	goto	u10340
u10341:
	goto	l7299
u10340:
	line	773
	
l7297:; BSR set to: 0

	btfsc	(_parpadeo)&0ffh,0
	bra	u10355
	bcf	((c:3978))^0f00h,c,5	;volatile
	bra	u10356
	u10355:
	bsf	((c:3978))^0f00h,c,5	;volatile
	u10356:

	line	774
	goto	l7389
	line	775
	
l7299:; BSR set to: 0

	btfsc	((_cont_buzz+1))&0ffh,7
	goto	u10361
	movf	((_cont_buzz+1))&0ffh,w
	bnz	u10360
	decf	((_cont_buzz))&0ffh,w
	btfss	status,0
	goto	u10361
	goto	u10360

u10361:
	goto	l7305
u10360:
	
l7301:; BSR set to: 0

	decf	((_cont_buzz))&0ffh
	btfss	status,0
	decf	((_cont_buzz+1))&0ffh
	movf	((_cont_buzz))&0ffh,w
iorwf	((_cont_buzz+1))&0ffh,w
	btfss	status,2
	goto	u10371
	goto	u10370

u10371:
	goto	l7305
u10370:
	
l7303:; BSR set to: 0

	bcf	((c:3978))^0f00h,c,5	;volatile
	line	777
	
l7305:; BSR set to: 0

	clrf	((actualizar_todo@e+1))&0ffh
	movlw	low(0)
	movwf	((actualizar_todo@e))&0ffh
	line	778
	
l7311:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	3
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u10381
	goto	u10380

u10381:
	goto	l7327
u10380:
	line	779
	
l7313:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movlw	1
	btfsc	plusw2,7
	goto	u10391
	movlw	1
	movf	plusw2,w
	bnz	u10390
	decf	postinc2,w
	btfss	status,0
	goto	u10391
	goto	u10390

u10391:
	goto	l7385
u10390:
	
l7315:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2
	movlw	0
	subwfb	postdec2
	movf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u10401
	goto	u10400

u10401:
	goto	l7385
u10400:
	line	780
	
l7317:; BSR set to: 0

	movff	(actualizar_todo@e),(c:tiene_paradas@e)
	movff	(actualizar_todo@e+1),(c:tiene_paradas@e+1)
	call	_tiene_paradas	;wreg free
	movf	(0+?_tiene_paradas)^00h,c,w
iorwf	(1+?_tiene_paradas)^00h,c,w
	btfsc	status,2
	goto	u10411
	goto	u10410

u10411:
	goto	l7323
u10410:
	line	781
	
l7319:
	movlb	0	; () banked
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	movwf	postinc2,c
	movlw	high(01h)
	movwf	postdec2,c
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_piso)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	
l7321:; BSR set to: 0

	movff	(actualizar_todo@e),(c:siguiente_objetivo@e)
	movff	(actualizar_todo@e+1),(c:siguiente_objetivo@e+1)
	call	_siguiente_objetivo	;wreg free
	line	782
	goto	l7325
	line	783
	
l7323:
	movlb	0	; () banked
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	785
	
l7325:
	call	_UART_EnviarEstado	;wreg free
	goto	l7385
	line	787
	
l7327:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	2
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u10421
	goto	u10420

u10421:
	goto	l7351
u10420:
	line	788
	
l7329:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	movlw	1
	btfsc	plusw2,7
	goto	u10431
	movlw	1
	movf	plusw2,w
	bnz	u10430
	decf	postinc2,w
	btfss	status,0
	goto	u10431
	goto	u10430

u10431:
	goto	l7385
u10430:
	
l7331:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movlw	1
	btfsc	plusw2,7
	goto	u10441
	movlw	1
	movf	plusw2,w
	bnz	u10440
	decf	postinc2,w
	btfss	status,0
	goto	u10441
	goto	u10440

u10441:
	goto	l7385
u10440:
	
l7333:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2
	movlw	0
	subwfb	postdec2
	movf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u10451
	goto	u10450

u10451:
	goto	l7385
u10450:
	line	789
	
l7335:; BSR set to: 0

	movff	(actualizar_todo@e),(c:quitar_cola_espera@e)
	movff	(actualizar_todo@e+1),(c:quitar_cola_espera@e+1)
	call	_quitar_cola_espera	;wreg free
	line	790
	
l7337:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	791
	
l7339:; BSR set to: 0

	movff	(actualizar_todo@e),(c:tiene_paradas@e)
	movff	(actualizar_todo@e+1),(c:tiene_paradas@e+1)
	call	_tiene_paradas	;wreg free
	movf	(0+?_tiene_paradas)^00h,c,w
iorwf	(1+?_tiene_paradas)^00h,c,w
	btfsc	status,2
	goto	u10461
	goto	u10460

u10461:
	goto	l7323
u10460:
	line	792
	
l7341:
	movlb	0	; () banked
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	movwf	postinc2,c
	movlw	high(01h)
	movwf	postdec2,c
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_piso)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	
l7343:; BSR set to: 0

	movff	(actualizar_todo@e),(c:siguiente_objetivo@e)
	movff	(actualizar_todo@e+1),(c:siguiente_objetivo@e+1)
	call	_siguiente_objetivo	;wreg free
	line	793
	
l7345:
	movff	(actualizar_todo@e),(c:msg_elev@e)
	movff	(actualizar_todo@e+1),(c:msg_elev@e+1)
		movlw	low(STR_34)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_34)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(0Ah)
	movwf	((c:msg_elev@pos_num))^00h,c
	movlb	0	; () banked
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:msg_elev@num)
	movff	postdec2,(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	line	794
	goto	l7325
	line	799
	
l7351:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u10471
	goto	u10470

u10471:
	goto	l7385
u10470:
	line	800
	
l7353:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u10481
	goto	u10480

u10481:
	goto	l7357
u10480:
	
l7355:; BSR set to: 0

	movff	(actualizar_todo@e),(c:siguiente_objetivo@e)
	movff	(actualizar_todo@e+1),(c:siguiente_objetivo@e+1)
	call	_siguiente_objetivo	;wreg free
	line	801
	
l7357:
	movlb	0	; () banked
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u10491
	goto	u10490

u10491:
	goto	l7361
u10490:
	goto	l7385
	line	804
	
l7361:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr1l
	clrf	fsr1h
	movf	postinc2,w
xorwf	postinc1,w
	bnz	u10501
movf	postinc2,w
xorwf	postinc1,w
	btfss	status,2
	goto	u10501
	goto	u10500

u10501:
	goto	l7367
u10500:
	line	805
	
l7363:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_piso)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	806
	
l7365:; BSR set to: 0

	movff	(actualizar_todo@e),(c:atender_llegada@e)
	movff	(actualizar_todo@e+1),(c:atender_llegada@e+1)
	call	_atender_llegada	;wreg free
	line	807
	goto	l7385
	line	810
	
l7367:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_piso)
	movwf	fsr2l
	clrf	fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	movlw	1
	btfsc	plusw2,7
	goto	u10510
	movlw	1
	movf	plusw2,w
	bnz	u10511
	movlw	200
	subwf	 postinc2,w
	btfsc	status,0
	goto	u10511
	goto	u10510

u10511:
	goto	l7371
u10510:
	goto	l7385
	line	811
	
l7371:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_piso)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	813
	
l7373:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr1l
	clrf	fsr1h
		movf	postinc2,w
	subwf	postinc1,w
	movf	postinc1,w
	xorlw	80h
	movwf	(??_actualizar_todo+4)^00h,c
	movf	postinc2,w
	xorlw	80h
	subwfb	(??_actualizar_todo+4)^00h,c,w
	btfsc	status,0
	goto	u10521
	goto	u10520

u10521:
	goto	l7377
u10520:
	
l7375:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	movwf	postinc2,c
	movlw	high(01h)
	movwf	postdec2,c
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	goto	l7381
	line	814
	
l7377:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr1l
	clrf	fsr1h
		movf	postinc2,w
	subwf	postinc1,w
	movf	postinc1,w
	xorlw	80h
	movwf	(??_actualizar_todo+4)^00h,c
	movf	postinc2,w
	xorlw	80h
	subwfb	(??_actualizar_todo+4)^00h,c,w
	btfsc	status,0
	goto	u10531
	goto	u10530

u10531:
	goto	l7381
u10530:
	
l7379:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(02h)
	movwf	postinc2,c
	movlw	high(02h)
	movwf	postdec2,c
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2
	movlw	0
	subwfb	postdec2
	line	816
	
l7381:; BSR set to: 0

	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movf	((actualizar_todo@e))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr1l
	clrf	fsr1h
	movf	postinc2,w
xorwf	postinc1,w
	bnz	u10541
movf	postinc2,w
xorwf	postinc1,w
	btfss	status,2
	goto	u10541
	goto	u10540

u10541:
	goto	l7385
u10540:
	goto	l7365
	line	820
	
l7385:
	movlb	0	; () banked
	infsnz	((actualizar_todo@e))&0ffh
	incf	((actualizar_todo@e+1))&0ffh
	
l7387:; BSR set to: 0

	btfsc	((actualizar_todo@e+1))&0ffh,7
	goto	u10551
	movf	((actualizar_todo@e+1))&0ffh,w
	bnz	u10550
	movlw	3
	subwf	 ((actualizar_todo@e))&0ffh,w
	btfss	status,0
	goto	u10551
	goto	u10550

u10551:
	goto	l7311
u10550:
	line	824
	
l7389:
	movf	((c:_emergencia))^00h,c,w
	btfsc	status,2
	goto	u10561
	goto	u10560
u10561:
	goto	l7393
u10560:
	line	825
	
l7391:
		movlw	low(actualizar_todo@l1)
	movwf	((c:strcpy@dest))^00h,c

		movlw	low(STR_35)
	movwf	((c:strcpy@src))^00h,c
	movlw	high(STR_35)
	movwf	((c:strcpy@src+1))^00h,c

	call	_strcpy	;wreg free
		movlw	low(actualizar_todo@l2)
	movwf	((c:strcpy@dest))^00h,c

		movlw	low(STR_36)
	movwf	((c:strcpy@src))^00h,c
	movlw	high(STR_36)
	movwf	((c:strcpy@src+1))^00h,c

	call	_strcpy	;wreg free
	line	826
	goto	l7455
	line	827
	
l7393:
		movlw	low(actualizar_todo@l1)
	movwf	((c:strcpy@dest))^00h,c

		movlw	low(STR_37)
	movwf	((c:strcpy@src))^00h,c
	movlw	high(STR_37)
	movwf	((c:strcpy@src+1))^00h,c

	call	_strcpy	;wreg free
	line	828
	
l7395:
		movlw	low(actualizar_todo@l1+02h)
	movwf	((c:poner_2d@p))^00h,c

	movff	(_piso),(c:poner_2d@v)
	movff	(_piso+1),(c:poner_2d@v+1)
	call	_poner_2d	;wreg free
	line	829
	
l7397:
		movlw	low(actualizar_todo@l1+08h)
	movwf	((c:poner_2d@p))^00h,c

	movff	0+(_piso+02h),(c:poner_2d@v)
	movff	1+(_piso+02h),(c:poner_2d@v+1)
	call	_poner_2d	;wreg free
	line	830
	
l7399:
		movlw	low(actualizar_todo@l1+0Eh)
	movwf	((c:poner_2d@p))^00h,c

	movff	0+(_piso+04h),(c:poner_2d@v)
	movff	1+(_piso+04h),(c:poner_2d@v+1)
	call	_poner_2d	;wreg free
	line	832
	
l7401:
	call	_elev_esperando	;wreg free
	movff	0+?_elev_esperando,(actualizar_todo@w)
	movff	1+?_elev_esperando,(actualizar_todo@w+1)
	line	833
	
l7403:; BSR set to: 0

		decf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u10571
	goto	u10570

u10571:
	goto	l7415
u10570:
	line	834
	
l7405:; BSR set to: 0

		movlw	low(actualizar_todo@l2)
	movwf	((c:strcpy@dest))^00h,c

		movlw	low(STR_38)
	movwf	((c:strcpy@src))^00h,c
	movlw	high(STR_38)
	movwf	((c:strcpy@src+1))^00h,c

	call	_strcpy	;wreg free
	line	835
	
l7407:
	movlb	0	; () banked
	btfsc	((_buf_len+1))&0ffh,7
	goto	u10581
	movf	((_buf_len+1))&0ffh,w
	bnz	u10580
	decf	((_buf_len))&0ffh,w
	btfss	status,0
	goto	u10581
	goto	u10580

u10581:
	goto	l7411
u10580:
	
l7409:; BSR set to: 0

	movff	(_buf),0+(actualizar_todo@l2+09h)
	line	836
	
l7411:; BSR set to: 0

	btfsc	((_buf_len+1))&0ffh,7
	goto	u10591
	movf	((_buf_len+1))&0ffh,w
	bnz	u10590
	movlw	2
	subwf	 ((_buf_len))&0ffh,w
	btfss	status,0
	goto	u10591
	goto	u10590

u10591:
	goto	l7455
u10590:
	
l7413:; BSR set to: 0

	movff	0+(_buf+01h),0+(actualizar_todo@l2+0Ah)
	goto	l7455
	line	837
	
l7415:; BSR set to: 0

		movlw	2
	xorwf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u10601
	goto	u10600

u10601:
	goto	l7421
u10600:
	line	838
	
l7417:; BSR set to: 0

		movlw	low(actualizar_todo@l2)
	movwf	((c:strcpy@dest))^00h,c

		movlw	low(STR_39)
	movwf	((c:strcpy@src))^00h,c
	movlw	high(STR_39)
	movwf	((c:strcpy@src+1))^00h,c

	call	_strcpy	;wreg free
	
l7419:
		movlw	low(actualizar_todo@l2+01h)
	movwf	((c:poner_2d@p))^00h,c

	movff	(_piso_usr),(c:poner_2d@v)
	movff	(_piso_usr+1),(c:poner_2d@v+1)
	call	_poner_2d	;wreg free
	line	839
	goto	l7455
	
l7421:; BSR set to: 0

	btfsc	((actualizar_todo@w+1))&0ffh,7
	goto	u10611
	goto	u10610

u10611:
	goto	l7453
u10610:
	line	840
	
l7423:; BSR set to: 0

		movlw	low(_msg_lcd)
	movwf	((c:strncmp@l))^00h,c
	movlw	high(_msg_lcd)
	movwf	((c:strncmp@l+1))^00h,c

		movlw	low(STR_40)
	movwf	((c:strncmp@r))^00h,c
	movlw	high(STR_40)
	movwf	((c:strncmp@r+1))^00h,c

	clrf	((c:strncmp@n+1))^00h,c
	movlw	low(010h)
	movwf	((c:strncmp@n))^00h,c
	call	_strncmp	;wreg free
	movf	(0+?_strncmp)^00h,c,w
iorwf	(1+?_strncmp)^00h,c,w
	btfss	status,2
	goto	u10621
	goto	u10620

u10621:
	goto	l7429
u10620:
	
l7425:
	movlb	0	; () banked
	movf	((_buf_len))&0ffh,w
iorwf	((_buf_len+1))&0ffh,w
	btfss	status,2
	goto	u10631
	goto	u10630

u10631:
	goto	l7429
u10630:
	
l7427:; BSR set to: 0

		movlw	low(actualizar_todo@l2)
	movwf	((c:strcpy@dest))^00h,c

		movlw	low(STR_41)
	movwf	((c:strcpy@src))^00h,c
	movlw	high(STR_41)
	movwf	((c:strcpy@src+1))^00h,c

	call	_strcpy	;wreg free
	goto	l7455
	line	841
	
l7429:
	movlb	0	; () banked
	movf	((actualizar_todo@w))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	movlw	1
	btfsc	plusw2,7
	goto	u10641
	movlw	1
	movf	plusw2,w
	bnz	u10640
	decf	postinc2,w
	btfss	status,0
	goto	u10641
	goto	u10640

u10641:
	goto	l7441
u10640:
	
l7431:; BSR set to: 0

	movf	((_buf_len))&0ffh,w
iorwf	((_buf_len+1))&0ffh,w
	btfss	status,2
	goto	u10651
	goto	u10650

u10651:
	goto	l7441
u10650:
	line	842
	
l7433:; BSR set to: 0

		movlw	low(actualizar_todo@l2)
	movwf	((c:strcpy@dest))^00h,c

		movlw	low(STR_42)
	movwf	((c:strcpy@src))^00h,c
	movlw	high(STR_42)
	movwf	((c:strcpy@src+1))^00h,c

	call	_strcpy	;wreg free
	line	843
	
l7435:
	movlw	low(01h)
	movlb	0	; () banked
	addwf	((actualizar_todo@w))&0ffh,w
	movwf	((c:dig@v))^00h,c
	movlw	high(01h)
	addwfc	((actualizar_todo@w+1))&0ffh,w
	movwf	1+((c:dig@v))^00h,c
	call	_dig	;wreg free
	movlb	0	; () banked
	movwf	(0+(actualizar_todo@l2+01h))&0ffh
	line	844
	
l7437:; BSR set to: 0

		movlw	low(actualizar_todo@l2+05h)
	movwf	((c:poner_2d@p))^00h,c

	movff	(actualizar_todo@w),(c:contar_destinos@e)
	movff	(actualizar_todo@w+1),(c:contar_destinos@e+1)
	call	_contar_destinos	;wreg free
	movff	0+?_contar_destinos,(c:poner_2d@v)
	movff	1+?_contar_destinos,(c:poner_2d@v+1)
	call	_poner_2d	;wreg free
	line	845
	
l7439:
	movlb	0	; () banked
	movf	((actualizar_todo@w))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_actualizar_todo+0
	movff	postdec2,??_actualizar_todo+0+1
	movlw	low(063h)
	addwf	(??_actualizar_todo+0)^00h,c,w
	movwf	((c:___awdiv@dividend))^00h,c
	movlw	high(063h)
	addwfc	(??_actualizar_todo+0+1)^00h,c,w
	movwf	1+((c:___awdiv@dividend))^00h,c
	clrf	((c:___awdiv@divisor+1))^00h,c
	movlw	low(064h)
	movwf	((c:___awdiv@divisor))^00h,c
	call	___awdiv	;wreg free
	movff	0+?___awdiv,(c:dig@v)
	movff	1+?___awdiv,(c:dig@v+1)
	call	_dig	;wreg free
	movlb	0	; () banked
	movwf	(0+(actualizar_todo@l2+08h))&0ffh
	line	846
	goto	l7455
	line	847
	
l7441:; BSR set to: 0

		movlw	low(actualizar_todo@l2)
	movwf	((c:strcpy@dest))^00h,c

		movlw	low(STR_43)
	movwf	((c:strcpy@src))^00h,c
	movlw	high(STR_43)
	movwf	((c:strcpy@src+1))^00h,c

	call	_strcpy	;wreg free
	
l7443:
	movlw	low(01h)
	movlb	0	; () banked
	addwf	((actualizar_todo@w))&0ffh,w
	movwf	((c:dig@v))^00h,c
	movlw	high(01h)
	addwfc	((actualizar_todo@w+1))&0ffh,w
	movwf	1+((c:dig@v))^00h,c
	call	_dig	;wreg free
	movlb	0	; () banked
	movwf	(0+(actualizar_todo@l2+01h))&0ffh
	line	848
	
l7445:; BSR set to: 0

	btfsc	((_buf_len+1))&0ffh,7
	goto	u10661
	movf	((_buf_len+1))&0ffh,w
	bnz	u10660
	decf	((_buf_len))&0ffh,w
	btfss	status,0
	goto	u10661
	goto	u10660

u10661:
	goto	l7449
u10660:
	
l7447:; BSR set to: 0

	movff	(_buf),0+(actualizar_todo@l2+08h)
	line	849
	
l7449:; BSR set to: 0

	btfsc	((_buf_len+1))&0ffh,7
	goto	u10671
	movf	((_buf_len+1))&0ffh,w
	bnz	u10670
	movlw	2
	subwf	 ((_buf_len))&0ffh,w
	btfss	status,0
	goto	u10671
	goto	u10670

u10671:
	goto	l7455
u10670:
	
l7451:; BSR set to: 0

	movff	0+(_buf+01h),0+(actualizar_todo@l2+09h)
	goto	l7455
	line	851
	
l7453:; BSR set to: 0

		movlw	low(actualizar_todo@l2)
	movwf	((c:memcpy@d1))^00h,c
	clrf	((c:memcpy@d1+1))^00h,c

		movlw	low(_msg_lcd)
	movwf	((c:memcpy@s1))^00h,c
	movlw	high(_msg_lcd)
	movwf	((c:memcpy@s1+1))^00h,c

	clrf	((c:memcpy@n+1))^00h,c
	movlw	low(011h)
	movwf	((c:memcpy@n))^00h,c
	call	_memcpy	;wreg free
	line	853
	
l7455:
		movlw	low(actualizar_todo@l1)
	movwf	((c:LCD_Linea@txt))^00h,c

	movlw	(0)&0ffh
	
	call	_LCD_Linea
	
l7457:
		movlw	low(actualizar_todo@l2)
	movwf	((c:LCD_Linea@txt))^00h,c

	movlw	(01h)&0ffh
	
	call	_LCD_Linea
	line	857
	
l7459:
	movlb	0	; () banked
	clrf	((_actualizar_todo$1187))&0ffh
	
l7461:; BSR set to: 0

	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u10681
	goto	u10680
u10681:
	goto	l7469
u10680:
	
l7463:; BSR set to: 0

		decf	((_estado))&0ffh,w
iorwf	((_estado+1))&0ffh,w
	btfss	status,2
	goto	u10691
	goto	u10690

u10691:
	goto	l7469
u10690:
	
l7465:; BSR set to: 0

		decf	((_direccion))&0ffh,w
iorwf	((_direccion+1))&0ffh,w
	btfss	status,2
	goto	u10701
	goto	u10700

u10701:
	goto	l7469
u10700:
	
l7467:; BSR set to: 0

	movlw	low(01h)
	movwf	((_actualizar_todo$1187))&0ffh
	
l7469:; BSR set to: 0

	btfsc	(_actualizar_todo$1187)&0ffh,0
	bra	u10715
	bcf	((c:3981))^0f00h,c,2	;volatile
	bra	u10716
	u10715:
	bsf	((c:3981))^0f00h,c,2	;volatile
	u10716:

	line	858
	
l7471:
	movlb	0	; () banked
	clrf	((_actualizar_todo$1195))&0ffh
	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u10721
	goto	u10720
u10721:
	goto	l7481
u10720:
	
l7473:; BSR set to: 0

		movlw	2
	xorwf	((_estado))&0ffh,w
iorwf	((_estado+1))&0ffh,w
	btfsc	status,2
	goto	u10731
	goto	u10730

u10731:
	goto	l7477
u10730:
	
l7475:; BSR set to: 0

		movlw	3
	xorwf	((_estado))&0ffh,w
iorwf	((_estado+1))&0ffh,w
	btfss	status,2
	goto	u10741
	goto	u10740

u10741:
	goto	l7481
u10740:
	
l7477:; BSR set to: 0

	movf	((_parpadeo))&0ffh,w
	btfsc	status,2
	goto	u10751
	goto	u10750
u10751:
	goto	l7481
u10750:
	
l7479:; BSR set to: 0

	movlw	low(01h)
	movwf	((_actualizar_todo$1195))&0ffh
	
l7481:; BSR set to: 0

	btfsc	(_actualizar_todo$1195)&0ffh,0
	bra	u10765
	bcf	((c:3977))^0f00h,c,6	;volatile
	bra	u10766
	u10765:
	bsf	((c:3977))^0f00h,c,6	;volatile
	u10766:

	line	859
	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u10771
	goto	u10770
u10771:
	goto	l684
u10770:
	
l7483:
	movlb	0	; () banked
	clrf	((_actualizar_todo$1203))&0ffh
	
l7485:; BSR set to: 0

		decf	((_estado))&0ffh,w
iorwf	((_estado+1))&0ffh,w
	btfss	status,2
	goto	u10781
	goto	u10780

u10781:
	goto	l7491
u10780:
	
l7487:; BSR set to: 0

		movlw	2
	xorwf	((_direccion))&0ffh,w
iorwf	((_direccion+1))&0ffh,w
	btfss	status,2
	goto	u10791
	goto	u10790

u10791:
	goto	l7491
u10790:
	
l7489:; BSR set to: 0

	movlw	low(01h)
	movwf	((_actualizar_todo$1203))&0ffh
	
l7491:; BSR set to: 0

	movff	(_actualizar_todo$1203),(_actualizar_todo$1202)
	clrf	((_actualizar_todo$1202+1))&0ffh
	goto	l686
	
l684:
	movff	(_parpadeo),(_actualizar_todo$1202)
	movlb	0	; () banked
	clrf	((_actualizar_todo$1202+1))&0ffh
	
l686:; BSR set to: 0

	btfsc	(_actualizar_todo$1202)&0ffh,0
	bra	u10805
	bcf	((c:3979))^0f00h,c,0	;volatile
	bra	u10806
	u10805:
	bsf	((c:3979))^0f00h,c,0	;volatile
	u10806:

	line	862
	movlb	0	; () banked
	clrf	((_actualizar_todo$1204))&0ffh
	
l7493:; BSR set to: 0

	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u10811
	goto	u10810
u10811:
	goto	l7501
u10810:
	
l7495:; BSR set to: 0

		decf	(0+(_estado+02h))&0ffh,w
iorwf	(1+(_estado+02h))&0ffh,w
	btfss	status,2
	goto	u10821
	goto	u10820

u10821:
	goto	l7501
u10820:
	
l7497:; BSR set to: 0

		decf	(0+(_direccion+02h))&0ffh,w
iorwf	(1+(_direccion+02h))&0ffh,w
	btfss	status,2
	goto	u10831
	goto	u10830

u10831:
	goto	l7501
u10830:
	
l7499:; BSR set to: 0

	movlw	low(01h)
	movwf	((_actualizar_todo$1204))&0ffh
	
l7501:; BSR set to: 0

	btfsc	(_actualizar_todo$1204)&0ffh,0
	bra	u10845
	bcf	((c:3979))^0f00h,c,2	;volatile
	bra	u10846
	u10845:
	bsf	((c:3979))^0f00h,c,2	;volatile
	u10846:

	line	863
	
l7503:
	movlb	0	; () banked
	clrf	((_actualizar_todo$1205))&0ffh
	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u10851
	goto	u10850
u10851:
	goto	l7513
u10850:
	
l7505:; BSR set to: 0

		movlw	2
	xorwf	(0+(_estado+02h))&0ffh,w
iorwf	(1+(_estado+02h))&0ffh,w
	btfsc	status,2
	goto	u10861
	goto	u10860

u10861:
	goto	l7509
u10860:
	
l7507:; BSR set to: 0

		movlw	3
	xorwf	(0+(_estado+02h))&0ffh,w
iorwf	(1+(_estado+02h))&0ffh,w
	btfss	status,2
	goto	u10871
	goto	u10870

u10871:
	goto	l7513
u10870:
	
l7509:; BSR set to: 0

	movf	((_parpadeo))&0ffh,w
	btfsc	status,2
	goto	u10881
	goto	u10880
u10881:
	goto	l7513
u10880:
	
l7511:; BSR set to: 0

	movlw	low(01h)
	movwf	((_actualizar_todo$1205))&0ffh
	
l7513:; BSR set to: 0

	btfsc	(_actualizar_todo$1205)&0ffh,0
	bra	u10895
	bcf	((c:3980))^0f00h,c,3	;volatile
	bra	u10896
	u10895:
	bsf	((c:3980))^0f00h,c,3	;volatile
	u10896:

	line	864
	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u10901
	goto	u10900
u10901:
	goto	l694
u10900:
	
l7515:
	movlb	0	; () banked
	clrf	((_actualizar_todo$1207))&0ffh
	
l7517:; BSR set to: 0

		decf	(0+(_estado+02h))&0ffh,w
iorwf	(1+(_estado+02h))&0ffh,w
	btfss	status,2
	goto	u10911
	goto	u10910

u10911:
	goto	l7523
u10910:
	
l7519:; BSR set to: 0

		movlw	2
	xorwf	(0+(_direccion+02h))&0ffh,w
iorwf	(1+(_direccion+02h))&0ffh,w
	btfss	status,2
	goto	u10921
	goto	u10920

u10921:
	goto	l7523
u10920:
	
l7521:; BSR set to: 0

	movlw	low(01h)
	movwf	((_actualizar_todo$1207))&0ffh
	
l7523:; BSR set to: 0

	movff	(_actualizar_todo$1207),(_actualizar_todo$1206)
	clrf	((_actualizar_todo$1206+1))&0ffh
	goto	l696
	
l694:
	movff	(_parpadeo),(_actualizar_todo$1206)
	movlb	0	; () banked
	clrf	((_actualizar_todo$1206+1))&0ffh
	
l696:; BSR set to: 0

	btfsc	(_actualizar_todo$1206)&0ffh,0
	bra	u10935
	bcf	((c:3980))^0f00h,c,2	;volatile
	bra	u10936
	u10935:
	bsf	((c:3980))^0f00h,c,2	;volatile
	u10936:

	line	867
	movlb	0	; () banked
	clrf	((_actualizar_todo$1208))&0ffh
	
l7525:; BSR set to: 0

	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u10941
	goto	u10940
u10941:
	goto	l7533
u10940:
	
l7527:; BSR set to: 0

		decf	(0+(_estado+04h))&0ffh,w
iorwf	(1+(_estado+04h))&0ffh,w
	btfss	status,2
	goto	u10951
	goto	u10950

u10951:
	goto	l7533
u10950:
	
l7529:; BSR set to: 0

		decf	(0+(_direccion+04h))&0ffh,w
iorwf	(1+(_direccion+04h))&0ffh,w
	btfss	status,2
	goto	u10961
	goto	u10960

u10961:
	goto	l7533
u10960:
	
l7531:; BSR set to: 0

	movlw	low(01h)
	movwf	((_actualizar_todo$1208))&0ffh
	
l7533:; BSR set to: 0

	btfsc	(_actualizar_todo$1208)&0ffh,0
	bra	u10975
	bcf	((c:3980))^0f00h,c,7	;volatile
	bra	u10976
	u10975:
	bsf	((c:3980))^0f00h,c,7	;volatile
	u10976:

	line	868
	
l7535:
	movlb	0	; () banked
	clrf	((_actualizar_todo$1209))&0ffh
	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u10981
	goto	u10980
u10981:
	goto	l7545
u10980:
	
l7537:; BSR set to: 0

		movlw	2
	xorwf	(0+(_estado+04h))&0ffh,w
iorwf	(1+(_estado+04h))&0ffh,w
	btfsc	status,2
	goto	u10991
	goto	u10990

u10991:
	goto	l7541
u10990:
	
l7539:; BSR set to: 0

		movlw	3
	xorwf	(0+(_estado+04h))&0ffh,w
iorwf	(1+(_estado+04h))&0ffh,w
	btfss	status,2
	goto	u11001
	goto	u11000

u11001:
	goto	l7545
u11000:
	
l7541:; BSR set to: 0

	movf	((_parpadeo))&0ffh,w
	btfsc	status,2
	goto	u11011
	goto	u11010
u11011:
	goto	l7545
u11010:
	
l7543:; BSR set to: 0

	movlw	low(01h)
	movwf	((_actualizar_todo$1209))&0ffh
	
l7545:; BSR set to: 0

	btfsc	(_actualizar_todo$1209)&0ffh,0
	bra	u11025
	bcf	((c:3980))^0f00h,c,6	;volatile
	bra	u11026
	u11025:
	bsf	((c:3980))^0f00h,c,6	;volatile
	u11026:

	line	869
	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u11031
	goto	u11030
u11031:
	goto	l704
u11030:
	
l7547:
	movlb	0	; () banked
	clrf	((_actualizar_todo$1211))&0ffh
	
l7549:; BSR set to: 0

		decf	(0+(_estado+04h))&0ffh,w
iorwf	(1+(_estado+04h))&0ffh,w
	btfss	status,2
	goto	u11041
	goto	u11040

u11041:
	goto	l7555
u11040:
	
l7551:; BSR set to: 0

		movlw	2
	xorwf	(0+(_direccion+04h))&0ffh,w
iorwf	(1+(_direccion+04h))&0ffh,w
	btfss	status,2
	goto	u11051
	goto	u11050

u11051:
	goto	l7555
u11050:
	
l7553:; BSR set to: 0

	movlw	low(01h)
	movwf	((_actualizar_todo$1211))&0ffh
	
l7555:; BSR set to: 0

	movff	(_actualizar_todo$1211),(_actualizar_todo$1210)
	clrf	((_actualizar_todo$1210+1))&0ffh
	goto	l706
	
l704:
	movff	(_parpadeo),(_actualizar_todo$1210)
	movlb	0	; () banked
	clrf	((_actualizar_todo$1210+1))&0ffh
	
l706:; BSR set to: 0

	btfsc	(_actualizar_todo$1210)&0ffh,0
	bra	u11065
	bcf	((c:3980))^0f00h,c,5	;volatile
	bra	u11066
	u11065:
	bsf	((c:3980))^0f00h,c,5	;volatile
	u11066:

	line	870
	
l709:
	return	;funcret
	callstack 0
GLOBAL	__end_of_actualizar_todo
	__end_of_actualizar_todo:
	signat	_actualizar_todo,89
	global	_contar_destinos

;; *************** function _contar_destinos *****************
;; Defined at:
;;		line 375 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2    5[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  p               2   13[COMRAM] int 
;;  c               2   11[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  2    5[COMRAM] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         4       0       0       0       0       0       0       0       0
;;      Temps:          4       0       0       0       0       0       0       0       0
;;      Totals:        10       0       0       0       0       0       0       0       0
;;Total ram usage:       10 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text3,class=CODE,space=0,reloc=2,group=0
	line	375
global __ptext3
__ptext3:
psect	text3
	file	"LOGIC_TEST.c"
	line	375
	
_contar_destinos:
;incstack = 0
	callstack 28
	line	376
	
l6743:; BSR set to: 0

	clrf	((c:contar_destinos@c+1))^00h,c
	movlw	low(0)
	movwf	((c:contar_destinos@c))^00h,c
	line	377
	clrf	((c:contar_destinos@p+1))^00h,c
	movlw	low(01h)
	movwf	((c:contar_destinos@p))^00h,c
	goto	l6749
	
l6745:; BSR set to: 0

	movlw	low(015h)
	mulwf	((c:contar_destinos@e))^00h,c
	movff	prodl,??_contar_destinos+0
	movff	prodh,??_contar_destinos+0+1
	mulwf	((c:contar_destinos@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_contar_destinos+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_contar_destinos+0)^00h,c,w
	movwf	(??_contar_destinos+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_contar_destinos+0+1)^00h,c,w
	movwf	1+(??_contar_destinos+2)^00h,c
	movf	((c:contar_destinos@p))^00h,c,w
	addwf	(??_contar_destinos+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:contar_destinos@p+1))^00h,c,w
	addwfc	(??_contar_destinos+2+1)^00h,c,w
	movwf	1+c:fsr2l
	btfss	indf2,(2)&7
	goto	u9381
	goto	u9380
u9381:
	goto	l387
u9380:
	
l6747:; BSR set to: 0

	infsnz	((c:contar_destinos@c))^00h,c
	incf	((c:contar_destinos@c+1))^00h,c
	
l387:; BSR set to: 0

	infsnz	((c:contar_destinos@p))^00h,c
	incf	((c:contar_destinos@p+1))^00h,c
	
l6749:; BSR set to: 0

		movf	((c:contar_destinos@p))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_contar_destinos+0)^00h,c
	movf	((c:contar_destinos@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_contar_destinos+0)^00h,c,w
	btfsc	status,0
	goto	u9391
	goto	u9390

u9391:
	goto	l6745
u9390:
	
l388:; BSR set to: 0

	line	378
	movff	(c:contar_destinos@c),(c:?_contar_destinos)
	movff	(c:contar_destinos@c+1),(c:?_contar_destinos+1)
	line	379
	
l389:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_contar_destinos
	__end_of_contar_destinos:
	signat	_contar_destinos,4218
	global	_atender_llegada

;; *************** function _atender_llegada *****************
;; Defined at:
;;		line 697 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2   53[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  fl              2   68[COMRAM] int 
;;  p               2   65[COMRAM] int 
;;  mas_abajo       2   62[COMRAM] int 
;;  mas_arriba      2   60[COMRAM] int 
;;  mask            1   67[COMRAM] unsigned char 
;;  had_pickup      1   64[COMRAM] unsigned char 
;;  had_dest        1   59[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:        11       0       0       0       0       0       0       0       0
;;      Temps:          4       0       0       0       0       0       0       0       0
;;      Totals:        17       0       0       0       0       0       0       0       0
;;Total ram usage:       17 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 3
;; This function calls:
;;		_UART_EmitDeq
;;		_UART_EnviarEstado
;;		_agregar_cola_espera
;;		_beep
;;		_msg_elev
;; This function is called by:
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text4,class=CODE,space=0,reloc=2,group=0
	line	697
global __ptext4
__ptext4:
psect	text4
	file	"LOGIC_TEST.c"
	line	697
	
_atender_llegada:; BSR set to: 0

;incstack = 0
	callstack 26
	line	698
	
l7077:
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:atender_llegada@fl)
	movff	postdec2,(c:atender_llegada@fl+1)
	line	699
	movlw	low(015h)
	mulwf	((c:atender_llegada@e))^00h,c
	movff	prodl,??_atender_llegada+0
	movff	prodh,??_atender_llegada+0+1
	mulwf	((c:atender_llegada@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_atender_llegada+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_atender_llegada+0)^00h,c,w
	movwf	(??_atender_llegada+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_atender_llegada+0+1)^00h,c,w
	movwf	1+(??_atender_llegada+2)^00h,c
	movf	((c:atender_llegada@fl))^00h,c,w
	addwf	(??_atender_llegada+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:atender_llegada@fl+1))^00h,c,w
	addwfc	(??_atender_llegada+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	movwf	((c:atender_llegada@mask))^00h,c
	line	700
	
l7079:
	clrf	((c:atender_llegada@had_pickup))^00h,c
	line	701
	
l7081:
	
	btfsc	((c:atender_llegada@mask))^00h,c,(2)&7
	goto	u9991
	goto	u9990
u9991:
	movlw	1
	goto	u10000
u9990:
	movlw	0
u10000:
	movwf	((c:atender_llegada@had_dest))^00h,c
	line	702
	
l7083:
	clrf	((c:atender_llegada@mas_arriba+1))^00h,c
	movlw	low(0)
	movwf	((c:atender_llegada@mas_arriba))^00h,c
	
l7085:
	clrf	((c:atender_llegada@mas_abajo+1))^00h,c
	movlw	low(0)
	movwf	((c:atender_llegada@mas_abajo))^00h,c
	line	704
	
l7087:
	movlw	low(01h)
	addwf	((c:atender_llegada@fl))^00h,c,w
	movwf	((c:atender_llegada@p))^00h,c
	movlw	high(01h)
	addwfc	((c:atender_llegada@fl+1))^00h,c,w
	movwf	1+((c:atender_llegada@p))^00h,c
	goto	l7095
	
l7089:
	movlw	low(015h)
	mulwf	((c:atender_llegada@e))^00h,c
	movff	prodl,??_atender_llegada+0
	movff	prodh,??_atender_llegada+0+1
	mulwf	((c:atender_llegada@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_atender_llegada+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_atender_llegada+0)^00h,c,w
	movwf	(??_atender_llegada+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_atender_llegada+0+1)^00h,c,w
	movwf	1+(??_atender_llegada+2)^00h,c
	movf	((c:atender_llegada@p))^00h,c,w
	addwf	(??_atender_llegada+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:atender_llegada@p+1))^00h,c,w
	addwfc	(??_atender_llegada+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u10011
	goto	u10010
u10011:
	goto	l7093
u10010:
	
l7091:
	clrf	((c:atender_llegada@mas_arriba+1))^00h,c
	movlw	low(01h)
	movwf	((c:atender_llegada@mas_arriba))^00h,c
	goto	l7097
	
l7093:
	infsnz	((c:atender_llegada@p))^00h,c
	incf	((c:atender_llegada@p+1))^00h,c
	
l7095:
		movf	((c:atender_llegada@p))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_atender_llegada+0)^00h,c
	movf	((c:atender_llegada@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_atender_llegada+0)^00h,c,w
	btfsc	status,0
	goto	u10021
	goto	u10020

u10021:
	goto	l7089
u10020:
	line	705
	
l7097:
	movlw	low(-1)
	addwf	((c:atender_llegada@fl))^00h,c,w
	movwf	((c:atender_llegada@p))^00h,c
	movlw	high(-1)
	addwfc	((c:atender_llegada@fl+1))^00h,c,w
	movwf	1+((c:atender_llegada@p))^00h,c
	btfsc	((c:atender_llegada@p+1))^00h,c,7
	goto	u10030
	movf	((c:atender_llegada@p+1))^00h,c,w
	bnz	u10031
	decf	((c:atender_llegada@p))^00h,c,w
	btfsc	status,0
	goto	u10031
	goto	u10030

u10031:
	goto	l7101
u10030:
	goto	l7109
	
l7101:
	movlw	low(015h)
	mulwf	((c:atender_llegada@e))^00h,c
	movff	prodl,??_atender_llegada+0
	movff	prodh,??_atender_llegada+0+1
	mulwf	((c:atender_llegada@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_atender_llegada+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_atender_llegada+0)^00h,c,w
	movwf	(??_atender_llegada+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_atender_llegada+0+1)^00h,c,w
	movwf	1+(??_atender_llegada+2)^00h,c
	movf	((c:atender_llegada@p))^00h,c,w
	addwf	(??_atender_llegada+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:atender_llegada@p+1))^00h,c,w
	addwfc	(??_atender_llegada+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u10041
	goto	u10040
u10041:
	goto	l7105
u10040:
	
l7103:
	clrf	((c:atender_llegada@mas_abajo+1))^00h,c
	movlw	low(01h)
	movwf	((c:atender_llegada@mas_abajo))^00h,c
	goto	l7109
	
l7105:
	decf	((c:atender_llegada@p))^00h,c
	btfss	status,0
	decf	((c:atender_llegada@p+1))^00h,c
	
l7107:
	btfsc	((c:atender_llegada@p+1))^00h,c,7
	goto	u10050
	movf	((c:atender_llegada@p+1))^00h,c,w
	bnz	u10051
	decf	((c:atender_llegada@p))^00h,c,w
	btfsc	status,0
	goto	u10051
	goto	u10050

u10051:
	goto	l7101
u10050:
	line	707
	
l7109:
	movlw	low(015h)
	mulwf	((c:atender_llegada@e))^00h,c
	movff	prodl,??_atender_llegada+0
	movff	prodh,??_atender_llegada+0+1
	mulwf	((c:atender_llegada@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_atender_llegada+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_atender_llegada+0)^00h,c,w
	movwf	(??_atender_llegada+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_atender_llegada+0+1)^00h,c,w
	movwf	1+(??_atender_llegada+2)^00h,c
	movf	((c:atender_llegada@fl))^00h,c,w
	addwf	(??_atender_llegada+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:atender_llegada@fl+1))^00h,c,w
	addwfc	(??_atender_llegada+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movlw	0FBh
	andwf	indf2
	line	708
	
l7111:
	movf	((c:atender_llegada@had_dest))^00h,c,w
	btfsc	status,2
	goto	u10061
	goto	u10060
u10061:
	goto	l7115
u10060:
	
l7113:
	movff	(c:atender_llegada@e),(c:UART_EmitDeq@e)
	movff	(c:atender_llegada@e+1),(c:UART_EmitDeq@e+1)
	movff	(c:atender_llegada@fl),(c:UART_EmitDeq@fl)
	movff	(c:atender_llegada@fl+1),(c:UART_EmitDeq@fl+1)
	movlw	low(043h)
	movwf	((c:UART_EmitDeq@tipo))^00h,c
	call	_UART_EmitDeq	;wreg free
	line	710
	
l7115:
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u10071
	goto	u10070

u10071:
	goto	l7137
u10070:
	line	711
	
l7117:
	
	btfss	((c:atender_llegada@mask))^00h,c,(0)&7
	goto	u10081
	goto	u10080
u10081:
	goto	l7125
u10080:
	line	712
	
l7119:
	movlw	low(015h)
	mulwf	((c:atender_llegada@e))^00h,c
	movff	prodl,??_atender_llegada+0
	movff	prodh,??_atender_llegada+0+1
	mulwf	((c:atender_llegada@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_atender_llegada+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_atender_llegada+0)^00h,c,w
	movwf	(??_atender_llegada+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_atender_llegada+0+1)^00h,c,w
	movwf	1+(??_atender_llegada+2)^00h,c
	movf	((c:atender_llegada@fl))^00h,c,w
	addwf	(??_atender_llegada+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:atender_llegada@fl+1))^00h,c,w
	addwfc	(??_atender_llegada+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movlw	0FEh
	andwf	indf2
	line	713
	
l7121:
	movlw	low(01h)
	movwf	((c:atender_llegada@had_pickup))^00h,c
	line	714
	
l7123:
	movff	(c:atender_llegada@e),(c:UART_EmitDeq@e)
	movff	(c:atender_llegada@e+1),(c:UART_EmitDeq@e+1)
	movff	(c:atender_llegada@fl),(c:UART_EmitDeq@fl)
	movff	(c:atender_llegada@fl+1),(c:UART_EmitDeq@fl+1)
	movlw	low(055h)
	movwf	((c:UART_EmitDeq@tipo))^00h,c
	call	_UART_EmitDeq	;wreg free
	line	716
	
l7125:
	movf	((c:atender_llegada@mas_arriba))^00h,c,w
iorwf	((c:atender_llegada@mas_arriba+1))^00h,c,w
	btfss	status,2
	goto	u10091
	goto	u10090

u10091:
	goto	l7179
u10090:
	
l7127:
	
	btfss	((c:atender_llegada@mask))^00h,c,(1)&7
	goto	u10101
	goto	u10100
u10101:
	goto	l7179
u10100:
	line	717
	
l7129:
	movlw	low(015h)
	mulwf	((c:atender_llegada@e))^00h,c
	movff	prodl,??_atender_llegada+0
	movff	prodh,??_atender_llegada+0+1
	mulwf	((c:atender_llegada@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_atender_llegada+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_atender_llegada+0)^00h,c,w
	movwf	(??_atender_llegada+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_atender_llegada+0+1)^00h,c,w
	movwf	1+(??_atender_llegada+2)^00h,c
	movf	((c:atender_llegada@fl))^00h,c,w
	addwf	(??_atender_llegada+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:atender_llegada@fl+1))^00h,c,w
	addwfc	(??_atender_llegada+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movlw	0FDh
	andwf	indf2
	line	718
	
l7131:
	movlw	low(01h)
	movwf	((c:atender_llegada@had_pickup))^00h,c
	line	719
	
l7133:
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(02h)
	movwf	postinc2,c
	movlw	high(02h)
	movwf	postdec2,c
	line	720
	
l7135:
	movff	(c:atender_llegada@e),(c:UART_EmitDeq@e)
	movff	(c:atender_llegada@e+1),(c:UART_EmitDeq@e+1)
	movff	(c:atender_llegada@fl),(c:UART_EmitDeq@fl)
	movff	(c:atender_llegada@fl+1),(c:UART_EmitDeq@fl+1)
	movlw	low(044h)
	movwf	((c:UART_EmitDeq@tipo))^00h,c
	call	_UART_EmitDeq	;wreg free
	goto	l7179
	line	722
	
l7137:
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movlw	2
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u10111
	goto	u10110

u10111:
	goto	l625
u10110:
	line	723
	
l7139:
	
	btfss	((c:atender_llegada@mask))^00h,c,(1)&7
	goto	u10121
	goto	u10120
u10121:
	goto	l7147
u10120:
	line	724
	
l7141:
	movlw	low(015h)
	mulwf	((c:atender_llegada@e))^00h,c
	movff	prodl,??_atender_llegada+0
	movff	prodh,??_atender_llegada+0+1
	mulwf	((c:atender_llegada@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_atender_llegada+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_atender_llegada+0)^00h,c,w
	movwf	(??_atender_llegada+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_atender_llegada+0+1)^00h,c,w
	movwf	1+(??_atender_llegada+2)^00h,c
	movf	((c:atender_llegada@fl))^00h,c,w
	addwf	(??_atender_llegada+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:atender_llegada@fl+1))^00h,c,w
	addwfc	(??_atender_llegada+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movlw	0FDh
	andwf	indf2
	line	725
	
l7143:
	movlw	low(01h)
	movwf	((c:atender_llegada@had_pickup))^00h,c
	line	726
	
l7145:
	movff	(c:atender_llegada@e),(c:UART_EmitDeq@e)
	movff	(c:atender_llegada@e+1),(c:UART_EmitDeq@e+1)
	movff	(c:atender_llegada@fl),(c:UART_EmitDeq@fl)
	movff	(c:atender_llegada@fl+1),(c:UART_EmitDeq@fl+1)
	movlw	low(044h)
	movwf	((c:UART_EmitDeq@tipo))^00h,c
	call	_UART_EmitDeq	;wreg free
	line	728
	
l7147:
	movf	((c:atender_llegada@mas_abajo))^00h,c,w
iorwf	((c:atender_llegada@mas_abajo+1))^00h,c,w
	btfss	status,2
	goto	u10131
	goto	u10130

u10131:
	goto	l7179
u10130:
	
l7149:
	
	btfss	((c:atender_llegada@mask))^00h,c,(0)&7
	goto	u10141
	goto	u10140
u10141:
	goto	l7179
u10140:
	line	729
	
l7151:
	movlw	low(015h)
	mulwf	((c:atender_llegada@e))^00h,c
	movff	prodl,??_atender_llegada+0
	movff	prodh,??_atender_llegada+0+1
	mulwf	((c:atender_llegada@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_atender_llegada+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_atender_llegada+0)^00h,c,w
	movwf	(??_atender_llegada+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_atender_llegada+0+1)^00h,c,w
	movwf	1+(??_atender_llegada+2)^00h,c
	movf	((c:atender_llegada@fl))^00h,c,w
	addwf	(??_atender_llegada+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:atender_llegada@fl+1))^00h,c,w
	addwfc	(??_atender_llegada+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movlw	0FEh
	andwf	indf2
	line	730
	
l7153:
	movlw	low(01h)
	movwf	((c:atender_llegada@had_pickup))^00h,c
	line	731
	
l7155:
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	movwf	postinc2,c
	movlw	high(01h)
	movwf	postdec2,c
	line	732
	
l7157:
	movff	(c:atender_llegada@e),(c:UART_EmitDeq@e)
	movff	(c:atender_llegada@e+1),(c:UART_EmitDeq@e+1)
	movff	(c:atender_llegada@fl),(c:UART_EmitDeq@fl)
	movff	(c:atender_llegada@fl+1),(c:UART_EmitDeq@fl+1)
	movlw	low(055h)
	movwf	((c:UART_EmitDeq@tipo))^00h,c
	call	_UART_EmitDeq	;wreg free
	goto	l7179
	line	734
	
l625:
	line	735
	
	btfss	((c:atender_llegada@mask))^00h,c,(0)&7
	goto	u10151
	goto	u10150
u10151:
	goto	l7167
u10150:
	line	736
	
l7159:
	movlw	low(015h)
	mulwf	((c:atender_llegada@e))^00h,c
	movff	prodl,??_atender_llegada+0
	movff	prodh,??_atender_llegada+0+1
	mulwf	((c:atender_llegada@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_atender_llegada+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_atender_llegada+0)^00h,c,w
	movwf	(??_atender_llegada+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_atender_llegada+0+1)^00h,c,w
	movwf	1+(??_atender_llegada+2)^00h,c
	movf	((c:atender_llegada@fl))^00h,c,w
	addwf	(??_atender_llegada+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:atender_llegada@fl+1))^00h,c,w
	addwfc	(??_atender_llegada+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movlw	0FEh
	andwf	indf2
	line	737
	
l7161:
	movlw	low(01h)
	movwf	((c:atender_llegada@had_pickup))^00h,c
	line	738
	
l7163:
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	movwf	postinc2,c
	movlw	high(01h)
	movwf	postdec2,c
	line	739
	
l7165:
	movff	(c:atender_llegada@e),(c:UART_EmitDeq@e)
	movff	(c:atender_llegada@e+1),(c:UART_EmitDeq@e+1)
	movff	(c:atender_llegada@fl),(c:UART_EmitDeq@fl)
	movff	(c:atender_llegada@fl+1),(c:UART_EmitDeq@fl+1)
	movlw	low(055h)
	movwf	((c:UART_EmitDeq@tipo))^00h,c
	call	_UART_EmitDeq	;wreg free
	line	741
	
l7167:
	
	btfss	((c:atender_llegada@mask))^00h,c,(1)&7
	goto	u10161
	goto	u10160
u10161:
	goto	l7179
u10160:
	line	742
	
l7169:
	movlw	low(015h)
	mulwf	((c:atender_llegada@e))^00h,c
	movff	prodl,??_atender_llegada+0
	movff	prodh,??_atender_llegada+0+1
	mulwf	((c:atender_llegada@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_atender_llegada+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_atender_llegada+0)^00h,c,w
	movwf	(??_atender_llegada+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_atender_llegada+0+1)^00h,c,w
	movwf	1+(??_atender_llegada+2)^00h,c
	movf	((c:atender_llegada@fl))^00h,c,w
	addwf	(??_atender_llegada+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:atender_llegada@fl+1))^00h,c,w
	addwfc	(??_atender_llegada+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movlw	0FDh
	andwf	indf2
	line	743
	
l7171:
	movlw	low(01h)
	movwf	((c:atender_llegada@had_pickup))^00h,c
	line	744
	
l7173:
	
	btfsc	((c:atender_llegada@mask))^00h,c,(0)&7
	goto	u10171
	goto	u10170
u10171:
	goto	l7135
u10170:
	goto	l7133
	line	749
	
l7179:
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	750
	
l7181:
	movff	(c:atender_llegada@e),(_elev_activo)
	movff	(c:atender_llegada@e+1),(_elev_activo+1)
	line	751
	
l7183:
	clrf	((c:beep@t+1))^00h,c
	movlw	low(0Ch)
	movwf	((c:beep@t))^00h,c
	call	_beep	;wreg free
	line	753
	
l7185:
	movf	((c:atender_llegada@had_pickup))^00h,c,w
	btfsc	status,2
	goto	u10181
	goto	u10180
u10181:
	goto	l7193
u10180:
	line	754
	
l7187:
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(02h)
	movwf	postinc2,c
	movlw	high(02h)
	movwf	postdec2,c
	line	755
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	756
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	757
	
l7189:
	movff	(c:atender_llegada@e),(c:agregar_cola_espera@e)
	movff	(c:atender_llegada@e+1),(c:agregar_cola_espera@e+1)
	call	_agregar_cola_espera	;wreg free
	line	758
	
l7191:; BSR set to: 0

	movff	(c:atender_llegada@e),(c:msg_elev@e)
	movff	(c:atender_llegada@e+1),(c:msg_elev@e+1)
		movlw	low(STR_32)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_32)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(04h)
	movwf	((c:msg_elev@pos_num))^00h,c
	movff	(c:atender_llegada@fl),(c:msg_elev@num)
	movff	(c:atender_llegada@fl+1),(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	line	759
	goto	l7197
	line	760
	
l7193:
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(03h)
	movwf	postinc2,c
	movlw	high(03h)
	movwf	postdec2,c
	line	761
	movf	((c:atender_llegada@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(0DCh)
	movwf	postinc2,c
	movlw	high(0DCh)
	movwf	postdec2,c
	line	762
	
l7195:
	movff	(c:atender_llegada@e),(c:msg_elev@e)
	movff	(c:atender_llegada@e+1),(c:msg_elev@e+1)
		movlw	low(STR_33)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_33)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(0Ch)
	movwf	((c:msg_elev@pos_num))^00h,c
	movff	(c:atender_llegada@fl),(c:msg_elev@num)
	movff	(c:atender_llegada@fl+1),(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	line	764
	
l7197:; BSR set to: 1

	call	_UART_EnviarEstado	;wreg free
	line	765
	
l634:
	return	;funcret
	callstack 0
GLOBAL	__end_of_atender_llegada
	__end_of_atender_llegada:
	signat	_atender_llegada,4217
	global	_UART_EmitDeq

;; *************** function _UART_EmitDeq *****************
;; Defined at:
;;		line 276 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2   29[COMRAM] int 
;;  fl              2   31[COMRAM] int 
;;  tipo            1   33[COMRAM] unsigned char 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         5       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:         6       0       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		_UART_Put2d
;;		_UART_PutChar
;;		_UART_PutStr
;;		_UART_TxFree
;;		_dig
;; This function is called by:
;;		_atender_llegada
;; This function uses a non-reentrant model
;;
psect	text5,class=CODE,space=0,reloc=2,group=0
	line	276
global __ptext5
__ptext5:
psect	text5
	file	"LOGIC_TEST.c"
	line	276
	
_UART_EmitDeq:
;incstack = 0
	callstack 26
	line	277
	
l6471:
	call	_UART_TxFree	;wreg free
	movwf	(??_UART_EmitDeq+0)^00h,c
		movlw	010h-0
	cpfslt	((??_UART_EmitDeq+0))^00h,c
	goto	u8911
	goto	u8910

u8911:
	goto	l6475
u8910:
	goto	l311
	line	278
	
l6475:; BSR set to: 0

		movlw	low(STR_3)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_3)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	279
	
l6477:
	movff	(c:UART_EmitDeq@e),(c:dig@v)
	movff	(c:UART_EmitDeq@e+1),(c:dig@v+1)
	call	_dig	;wreg free
	
	call	_UART_PutChar
	
l6479:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	280
	
l6481:; BSR set to: 0

	movff	(c:UART_EmitDeq@fl),(c:UART_Put2d@v)
	movff	(c:UART_EmitDeq@fl+1),(c:UART_Put2d@v+1)
	call	_UART_Put2d	;wreg free
	
l6483:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	281
	
l6485:; BSR set to: 0

	movf	((c:UART_EmitDeq@tipo))^00h,c,w
	
	call	_UART_PutChar
	
l6487:; BSR set to: 0

		movlw	low(STR_4)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_4)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	282
	
l311:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_EmitDeq
	__end_of_UART_EmitDeq:
	signat	_UART_EmitDeq,12409
	global	_LCD_Linea

;; *************** function _LCD_Linea *****************
;; Defined at:
;;		line 154 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  fila            1    wreg     unsigned char 
;;  txt             1   16[COMRAM] PTR const unsigned char 
;;		 -> actualizar_todo@l2(17), actualizar_todo@l1(17), 
;; Auto vars:     Size  Location     Type
;;  fila            1   36[COMRAM] unsigned char 
;;  l              17   17[COMRAM] unsigned char [17]
;;  i               2   39[COMRAM] int 
;;  cache           2   37[COMRAM] PTR unsigned char 
;;		 -> prev_l2(17), prev_l1(17), 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         1       0       0       0       0       0       0       0       0
;;      Locals:        24       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:        25       0       0       0       0       0       0       0       0
;;Total ram usage:       25 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		_LCD_Byte
;;		_memcpy
;;		_strncmp
;; This function is called by:
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text6,class=CODE,space=0,reloc=2,group=0
	line	154
global __ptext6
__ptext6:
psect	text6
	file	"LOGIC_TEST.c"
	line	154
	
_LCD_Linea:
;incstack = 0
	callstack 27
	movwf	((c:LCD_Linea@fila))^00h,c
	line	155
	
l6693:
	movf	((c:LCD_Linea@fila))^00h,c,w
	btfsc	status,2
	goto	u9311
	goto	u9310
u9311:
	goto	l6697
u9310:
	
l6695:
		movlw	low(_prev_l2)
	movwf	((c:LCD_Linea@cache))^00h,c
	movlw	high(_prev_l2)
	movwf	((c:LCD_Linea@cache+1))^00h,c

	goto	l203
	
l6697:
		movlw	low(_prev_l1)
	movwf	((c:LCD_Linea@cache))^00h,c
	movlw	high(_prev_l1)
	movwf	((c:LCD_Linea@cache+1))^00h,c

	
l203:
	line	158
	clrf	((c:LCD_Linea@i+1))^00h,c
	movlw	low(0)
	movwf	((c:LCD_Linea@i))^00h,c
	goto	l6703
	
l6699:
	movf	((c:LCD_Linea@txt))^00h,c,w
	addwf	((c:LCD_Linea@i))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
	movf	((c:LCD_Linea@i))^00h,c,w
	addlw	low(LCD_Linea@l)
	movwf	fsr1l
	clrf	fsr1h
	movff	indf2,indf1
	
l6701:
	infsnz	((c:LCD_Linea@i))^00h,c
	incf	((c:LCD_Linea@i+1))^00h,c
	
l6703:
	btfsc	((c:LCD_Linea@i+1))^00h,c,7
	goto	u9320
	movf	((c:LCD_Linea@i+1))^00h,c,w
	bnz	u9321
	movlw	16
	subwf	 ((c:LCD_Linea@i))^00h,c,w
	btfsc	status,0
	goto	u9321
	goto	u9320

u9321:
	goto	l6707
u9320:
	
l6705:
	movf	((c:LCD_Linea@txt))^00h,c,w
	addwf	((c:LCD_Linea@i))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
	movf	indf2,w
	btfss	status,2
	goto	u9331
	goto	u9330
u9331:
	goto	l6699
u9330:
	line	159
	
l6707:
	btfsc	((c:LCD_Linea@i+1))^00h,c,7
	goto	u9341
	movf	((c:LCD_Linea@i+1))^00h,c,w
	bnz	u9340
	movlw	16
	subwf	 ((c:LCD_Linea@i))^00h,c,w
	btfss	status,0
	goto	u9341
	goto	u9340

u9341:
	goto	l6711
u9340:
	goto	l210
	
l6711:
	movf	((c:LCD_Linea@i))^00h,c,w
	addlw	low(LCD_Linea@l)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(020h)
	movwf	indf2
	
l6713:
	infsnz	((c:LCD_Linea@i))^00h,c
	incf	((c:LCD_Linea@i+1))^00h,c
	goto	l6707
	
l210:
	line	160
	clrf	(0+((c:LCD_Linea@l)+010h))^00h,c
	line	161
	
l6717:
		movff	(c:LCD_Linea@cache),(c:strncmp@l)
	movff	(c:LCD_Linea@cache+1),(c:strncmp@l+1)

		movlw	low(LCD_Linea@l)
	movwf	((c:strncmp@r))^00h,c
	clrf	((c:strncmp@r+1))^00h,c

	clrf	((c:strncmp@n+1))^00h,c
	movlw	low(010h)
	movwf	((c:strncmp@n))^00h,c
	call	_strncmp	;wreg free
	movf	(0+?_strncmp)^00h,c,w
iorwf	(1+?_strncmp)^00h,c,w
	btfss	status,2
	goto	u9351
	goto	u9350

u9351:
	goto	l6721
u9350:
	goto	l212
	line	162
	
l6721:
		movff	(c:LCD_Linea@cache),(c:memcpy@d1)
	movff	(c:LCD_Linea@cache+1),(c:memcpy@d1+1)

		movlw	low(LCD_Linea@l)
	movwf	((c:memcpy@s1))^00h,c
	clrf	((c:memcpy@s1+1))^00h,c

	clrf	((c:memcpy@n+1))^00h,c
	movlw	low(011h)
	movwf	((c:memcpy@n))^00h,c
	call	_memcpy	;wreg free
	line	163
	
l6723:
	movf	((c:LCD_Linea@fila))^00h,c,w
	btfss	status,2
	goto	u9361
	goto	u9360
u9361:
	goto	l6727
u9360:
	
l6725:
	clrf	((c:_LCD_Linea$925+1))^00h,c
	movlw	low(080h)
	movwf	((c:_LCD_Linea$925))^00h,c
	goto	l6729
	
l6727:
	clrf	((c:_LCD_Linea$925+1))^00h,c
	movlw	low(0C0h)
	movwf	((c:_LCD_Linea$925))^00h,c
	
l6729:
	movlw	low(0)
	movwf	((c:LCD_Byte@dato))^00h,c
	movf	((c:_LCD_Linea$925))^00h,c,w
	
	call	_LCD_Byte
	line	164
	
l6731:
	clrf	((c:LCD_Linea@i+1))^00h,c
	movlw	low(0)
	movwf	((c:LCD_Linea@i))^00h,c
	
l6737:
	movlw	low(01h)
	movwf	((c:LCD_Byte@dato))^00h,c
	movf	((c:LCD_Linea@i))^00h,c,w
	addlw	low(LCD_Linea@l)
	movwf	fsr2l
	clrf	fsr2h
	movf	indf2,w
	
	call	_LCD_Byte
	
l6739:
	infsnz	((c:LCD_Linea@i))^00h,c
	incf	((c:LCD_Linea@i+1))^00h,c
	
l6741:
	btfsc	((c:LCD_Linea@i+1))^00h,c,7
	goto	u9371
	movf	((c:LCD_Linea@i+1))^00h,c,w
	bnz	u9370
	movlw	16
	subwf	 ((c:LCD_Linea@i))^00h,c,w
	btfss	status,0
	goto	u9371
	goto	u9370

u9371:
	goto	l6737
u9370:
	line	165
	
l212:
	return	;funcret
	callstack 0
GLOBAL	__end_of_LCD_Linea
	__end_of_LCD_Linea:
	signat	_LCD_Linea,8313
	global	_strncmp

;; *************** function _strncmp *****************
;; Defined at:
;;		line 3 in file "D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\strncmp.c"
;; Parameters:    Size  Location     Type
;;  l               2    5[COMRAM] PTR const unsigned char 
;;		 -> prev_l2(17), prev_l1(17), msg_lcd(17), 
;;  r               2    7[COMRAM] PTR const unsigned char 
;;		 -> STR_40(17), LCD_Linea@l(17), 
;;  n               2    9[COMRAM] unsigned int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2    5[COMRAM] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         6       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         8       0       0       0       0       0       0       0       0
;;Total ram usage:        8 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_LCD_Linea
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text7,class=CODE,space=0,reloc=2,group=2
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\strncmp.c"
	line	3
global __ptext7
__ptext7:
psect	text7
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\strncmp.c"
	line	3
	
_strncmp:
;incstack = 0
	callstack 27
	line	5
	
l6439:
	decf	((c:strncmp@n))^00h,c
	btfss	status,0
	decf	((c:strncmp@n+1))^00h,c
		incf	((c:strncmp@n))^00h,c,w
	bnz	u8821
	incf	((c:strncmp@n+1))^00h,c,w
	btfss	status,2
	goto	u8821
	goto	u8820

u8821:
	goto	l6447
u8820:
	
l6441:
	clrf	((c:?_strncmp+1))^00h,c
	movlw	low(0)
	movwf	((c:?_strncmp))^00h,c
	goto	l1568
	line	6
	
l6445:
	infsnz	((c:strncmp@l))^00h,c
	incf	((c:strncmp@l+1))^00h,c
	infsnz	((c:strncmp@r))^00h,c
	incf	((c:strncmp@r+1))^00h,c
	decf	((c:strncmp@n))^00h,c
	btfss	status,0
	decf	((c:strncmp@n+1))^00h,c
	
l6447:
	movff	(c:strncmp@l),fsr2l
	movff	(c:strncmp@l+1),fsr2h
	movf	indf2,w
	btfsc	status,2
	goto	u8831
	goto	u8830
u8831:
	goto	l6455
u8830:
	
l6449:
	movff	(c:strncmp@r),tblptrl
	movff	(c:strncmp@r+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	u8847

	tblrd	*
	
	movf	tablat,w
	bra	u8840
u8847:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
u8840:
	iorlw	0
	btfsc	status,2
	goto	u8851
	goto	u8850
u8851:
	goto	l6455
u8850:
	
l6451:
	movf	((c:strncmp@n))^00h,c,w
iorwf	((c:strncmp@n+1))^00h,c,w
	btfsc	status,2
	goto	u8861
	goto	u8860

u8861:
	goto	l6455
u8860:
	
l6453:
	movff	(c:strncmp@l),fsr2l
	movff	(c:strncmp@l+1),fsr2h
	movf	indf2,w
	movwf	(??_strncmp+0)^00h,c
	movff	(c:strncmp@r),tblptrl
	movff	(c:strncmp@r+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	u8877

	tblrd	*
	
	movf	tablat,w
	bra	u8870
u8877:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
u8870:
	xorwf	((??_strncmp+0))^00h,c,w

	btfsc	status,2
	goto	u8881
	goto	u8880
u8881:
	goto	l6445
u8880:
	line	7
	
l6455:
	movff	(c:strncmp@l),fsr2l
	movff	(c:strncmp@l+1),fsr2h
	movf	indf2,w
	movwf	(??_strncmp+0)^00h,c
	movff	(c:strncmp@r),tblptrl
	movff	(c:strncmp@r+1),tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	u8897

	tblrd	*
	
	movf	tablat,w
	bra	u8890
u8897:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
u8890:
	movwf	(??_strncmp+1)^00h,c
	movf	((??_strncmp+1))^00h,c,w
	subwf	((??_strncmp+0))^00h,c,w
	movwf	((c:?_strncmp))^00h,c
	clrf	1+((c:?_strncmp))^00h,c
	btfss	status,0
	decf	1+((c:?_strncmp))^00h,c
	
	line	8
	
l1568:
	return	;funcret
	callstack 0
GLOBAL	__end_of_strncmp
	__end_of_strncmp:
	signat	_strncmp,12410
	global	_memcpy

;; *************** function _memcpy *****************
;; Defined at:
;;		line 4 in file "D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\memcpy.c"
;; Parameters:    Size  Location     Type
;;  d1              2    5[COMRAM] PTR void 
;;		 -> actualizar_todo@l2(17), prev_l2(17), prev_l1(17), 
;;  s1              2    7[COMRAM] PTR const void 
;;		 -> LCD_Linea@l(17), msg_lcd(17), 
;;  n               2    9[COMRAM] unsigned int 
;; Auto vars:     Size  Location     Type
;;  s               2   14[COMRAM] PTR const unsigned char 
;;		 -> LCD_Linea@l(17), msg_lcd(17), 
;;  d               2   12[COMRAM] PTR unsigned char 
;;		 -> actualizar_todo@l2(17), prev_l2(17), prev_l1(17), 
;;  tmp             1   11[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  2    5[COMRAM] PTR void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         6       0       0       0       0       0       0       0       0
;;      Locals:         5       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:        11       0       0       0       0       0       0       0       0
;;Total ram usage:       11 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_LCD_Linea
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text8,class=CODE,space=0,reloc=2,group=2
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\memcpy.c"
	line	4
global __ptext8
__ptext8:
psect	text8
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\memcpy.c"
	line	4
	
_memcpy:
;incstack = 0
	callstack 27
	line	11
	
l6459:
		movff	(c:memcpy@s1),(c:memcpy@s)
	movff	(c:memcpy@s1+1),(c:memcpy@s+1)

	line	12
		movff	(c:memcpy@d1),(c:memcpy@d)
	movff	(c:memcpy@d1+1),(c:memcpy@d+1)

	line	13
	goto	l6469
	line	14
	
l6461:
	movff	(c:memcpy@s),fsr2l
	movff	(c:memcpy@s+1),fsr2h
	movf	indf2,w
	movwf	((c:memcpy@tmp))^00h,c
	
l6463:
	infsnz	((c:memcpy@s))^00h,c
	incf	((c:memcpy@s+1))^00h,c
	line	15
	
l6465:
	movff	(c:memcpy@d),fsr2l
	movff	(c:memcpy@d+1),fsr2h
	movff	(c:memcpy@tmp),indf2

	
l6467:
	infsnz	((c:memcpy@d))^00h,c
	incf	((c:memcpy@d+1))^00h,c
	line	13
	
l6469:
	decf	((c:memcpy@n))^00h,c
	btfss	status,0
	decf	((c:memcpy@n+1))^00h,c
		incf	((c:memcpy@n))^00h,c,w
	bnz	u8901
	incf	((c:memcpy@n+1))^00h,c,w
	btfss	status,2
	goto	u8901
	goto	u8900

u8901:
	goto	l6461
u8900:
	line	18
	
l1552:
	return	;funcret
	callstack 0
GLOBAL	__end_of_memcpy
	__end_of_memcpy:
	signat	_memcpy,12410
	global	_UART_PumpTx

;; *************** function _UART_PumpTx *****************
;; Defined at:
;;		line 238 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text9,class=CODE,space=0,reloc=2,group=0
	file	"LOGIC_TEST.c"
	line	238
global __ptext9
__ptext9:
psect	text9
	file	"LOGIC_TEST.c"
	line	238
	
_UART_PumpTx:
;incstack = 0
	callstack 29
	line	239
	
l7285:
	btfss	((c:3998))^0f00h,c,4	;volatile
	goto	u10291
	goto	u10290
u10291:
	goto	l272
u10290:
	
l7287:
	movlb	0	; () banked
	movf	((_tx_head))&0ffh,w
xorwf	((_tx_tail))&0ffh,w
	btfsc	status,2
	goto	u10301
	goto	u10300

u10301:
	goto	l272
u10300:
	line	240
	
l7289:; BSR set to: 0

	movlw	low(_tx_ring)
	addwf	((_tx_tail))&0ffh,w
	movwf	c:fsr2l
	clrf	1+c:fsr2l
	movlw	high(_tx_ring)
	addwfc	1+c:fsr2l
	movf	indf2,w
	movwf	((c:4013))^0f00h,c	;volatile
	
l7291:; BSR set to: 0

	incf	((_tx_tail))&0ffh
	line	242
	
l272:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_PumpTx
	__end_of_UART_PumpTx:
	signat	_UART_PumpTx,89
	global	_UART_ProcessRx

;; *************** function _UART_ProcessRx *****************
;; Defined at:
;;		line 882 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  e               2    8[BANK0 ] int 
;;  fl              2    4[BANK0 ] int 
;;  fl              2    2[BANK0 ] int 
;;  d               1   11[BANK0 ] unsigned char 
;;  c               1   10[BANK0 ] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0      10       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0      10       0       0       0       0       0       0       0
;;Total ram usage:       10 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 5
;; This function calls:
;;		_cambiar_num_pisos
;;		_encolar_destino_cabina
;;		_llamar_pasillo
;;		_llamar_pasillo_piso
;;		_parse_2d
;;		_procesar_tecla
;;		_reiniciar_sistema
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text10,class=CODE,space=0,reloc=2,group=0
	line	882
global __ptext10
__ptext10:
psect	text10
	file	"LOGIC_TEST.c"
	line	882
	
_UART_ProcessRx:
;incstack = 0
	callstack 25
	line	883
	
l7557:
	goto	l7653
	line	884
	
l7559:; BSR set to: 0

	movlw	low(_rx_ring)
	addwf	((_rx_tail))&0ffh,w	;volatile
	movwf	c:fsr2l
	clrf	1+c:fsr2l
	movlw	high(_rx_ring)
	addwfc	1+c:fsr2l
	movf	indf2,w
	movwf	((UART_ProcessRx@c))&0ffh
	line	885
	
l7561:; BSR set to: 0

	incf	((_rx_tail))&0ffh,w	;volatile
	andlw	low(03Fh)
	movwf	((_rx_tail))&0ffh	;volatile
	line	887
	
l7563:; BSR set to: 0

		movlw	13
	xorwf	((UART_ProcessRx@c))&0ffh,w
	btfsc	status,2
	goto	u11071
	goto	u11070

u11071:
	goto	l7567
u11070:
	
l7565:; BSR set to: 0

		movlw	10
	xorwf	((UART_ProcessRx@c))&0ffh,w
	btfss	status,2
	goto	u11081
	goto	u11080

u11081:
	goto	l7647
u11080:
	line	888
	
l7567:; BSR set to: 0

	movf	((_uart_rx_len))&0ffh,w
	btfss	status,2
	goto	u11091
	goto	u11090
u11091:
	goto	l7571
u11090:
	goto	l7653
	line	889
	
l7571:; BSR set to: 0

	movf	((_uart_rx_len))&0ffh,w
	addlw	low(_uart_rx)
	movwf	fsr2l
	clrf	fsr2h
	clrf	indf2
	line	891
	
l7573:; BSR set to: 0

		movlw	03h-1
	cpfsgt	((_uart_rx_len))&0ffh
	goto	u11101
	goto	u11100

u11101:
	goto	l7581
u11100:
	
l7575:; BSR set to: 0

		movlw	78
	xorwf	((_uart_rx))&0ffh,w
	btfss	status,2
	goto	u11111
	goto	u11110

u11111:
	goto	l7581
u11110:
	
l7577:; BSR set to: 0

		movlw	58
	xorwf	(0+(_uart_rx+01h))&0ffh,w
	btfss	status,2
	goto	u11121
	goto	u11120

u11121:
	goto	l7581
u11120:
	line	892
	
l7579:; BSR set to: 0

		movlw	low(_uart_rx+02h)
	movwf	((c:parse_2d@s))^00h,c

	call	_parse_2d	;wreg free
	movff	0+?_parse_2d,(c:cambiar_num_pisos@n)
	movff	1+?_parse_2d,(c:cambiar_num_pisos@n+1)
	call	_cambiar_num_pisos	;wreg free
	line	893
	goto	l7645
	
l7581:; BSR set to: 0

		movlw	03h-1
	cpfsgt	((_uart_rx_len))&0ffh
	goto	u11131
	goto	u11130

u11131:
	goto	l7589
u11130:
	
l7583:; BSR set to: 0

		movlw	75
	xorwf	((_uart_rx))&0ffh,w
	btfss	status,2
	goto	u11141
	goto	u11140

u11141:
	goto	l7589
u11140:
	
l7585:; BSR set to: 0

		movlw	58
	xorwf	(0+(_uart_rx+01h))&0ffh,w
	btfss	status,2
	goto	u11151
	goto	u11150

u11151:
	goto	l7589
u11150:
	line	894
	
l7587:; BSR set to: 0

	movf	(0+(_uart_rx+02h))&0ffh,w
	
	call	_procesar_tecla
	line	895
	goto	l7645
	
l7589:; BSR set to: 0

		movlw	03h-1
	cpfsgt	((_uart_rx_len))&0ffh
	goto	u11161
	goto	u11160

u11161:
	goto	l7603
u11160:
	
l7591:; BSR set to: 0

		movlw	72
	xorwf	((_uart_rx))&0ffh,w
	btfss	status,2
	goto	u11171
	goto	u11170

u11171:
	goto	l7603
u11170:
	
l7593:; BSR set to: 0

		movlw	58
	xorwf	(0+(_uart_rx+01h))&0ffh,w
	btfss	status,2
	goto	u11181
	goto	u11180

u11181:
	goto	l7603
u11180:
	line	896
	
l7595:; BSR set to: 0

		movlw	85
	xorwf	(0+(_uart_rx+02h))&0ffh,w
	btfss	status,2
	goto	u11191
	goto	u11190

u11191:
	goto	l7599
u11190:
	
l7597:; BSR set to: 0

	clrf	((c:llamar_pasillo@dir+1))^00h,c
	movlw	low(01h)
	movwf	((c:llamar_pasillo@dir))^00h,c
	call	_llamar_pasillo	;wreg free
	goto	l7645
	line	897
	
l7599:; BSR set to: 0

		movlw	68
	xorwf	(0+(_uart_rx+02h))&0ffh,w
	btfss	status,2
	goto	u11201
	goto	u11200

u11201:
	goto	l7645
u11200:
	
l7601:; BSR set to: 0

	clrf	((c:llamar_pasillo@dir+1))^00h,c
	movlw	low(02h)
	movwf	((c:llamar_pasillo@dir))^00h,c
	call	_llamar_pasillo	;wreg free
	goto	l7645
	line	898
	
l7603:; BSR set to: 0

		movlw	06h-1
	cpfsgt	((_uart_rx_len))&0ffh
	goto	u11211
	goto	u11210

u11211:
	goto	l7625
u11210:
	
l7605:; BSR set to: 0

		movlw	67
	xorwf	((_uart_rx))&0ffh,w
	btfss	status,2
	goto	u11221
	goto	u11220

u11221:
	goto	l7625
u11220:
	
l7607:; BSR set to: 0

		movlw	58
	xorwf	(0+(_uart_rx+01h))&0ffh,w
	btfss	status,2
	goto	u11231
	goto	u11230

u11231:
	goto	l7625
u11230:
	line	900
	
l7609:; BSR set to: 0

		movlw	low(_uart_rx+02h)
	movwf	((c:parse_2d@s))^00h,c

	call	_parse_2d	;wreg free
	movff	0+?_parse_2d,(UART_ProcessRx@fl)
	movff	1+?_parse_2d,(UART_ProcessRx@fl+1)
	line	901
	
l7611:; BSR set to: 0

	movff	0+(_uart_rx+05h),(UART_ProcessRx@d)
	line	902
	
l7613:; BSR set to: 0

		movlw	85
	xorwf	((UART_ProcessRx@d))&0ffh,w
	btfsc	status,2
	goto	u11241
	goto	u11240

u11241:
	goto	l7617
u11240:
	
l7615:; BSR set to: 0

		movlw	68
	xorwf	((UART_ProcessRx@d))&0ffh,w
	btfss	status,2
	goto	u11251
	goto	u11250

u11251:
	goto	l7645
u11250:
	
l7617:; BSR set to: 0

		movlw	85
	xorwf	((UART_ProcessRx@d))&0ffh,w
	btfsc	status,2
	goto	u11261
	goto	u11260

u11261:
	goto	l7621
u11260:
	
l7619:; BSR set to: 0

	clrf	((_UART_ProcessRx$1223+1))&0ffh
	movlw	low(02h)
	movwf	((_UART_ProcessRx$1223))&0ffh
	goto	l7623
	
l7621:; BSR set to: 0

	clrf	((_UART_ProcessRx$1223+1))&0ffh
	movlw	low(01h)
	movwf	((_UART_ProcessRx$1223))&0ffh
	
l7623:; BSR set to: 0

	movff	(UART_ProcessRx@fl),(c:llamar_pasillo_piso@fl)
	movff	(UART_ProcessRx@fl+1),(c:llamar_pasillo_piso@fl+1)
	movff	(_UART_ProcessRx$1223),(c:llamar_pasillo_piso@dir)
	movff	(_UART_ProcessRx$1223+1),(c:llamar_pasillo_piso@dir+1)
	call	_llamar_pasillo_piso	;wreg free
	goto	l7645
	line	903
	
l7625:; BSR set to: 0

		movlw	06h-1
	cpfsgt	((_uart_rx_len))&0ffh
	goto	u11271
	goto	u11270

u11271:
	goto	l7641
u11270:
	
l7627:; BSR set to: 0

		movlw	68
	xorwf	((_uart_rx))&0ffh,w
	btfss	status,2
	goto	u11281
	goto	u11280

u11281:
	goto	l7641
u11280:
	
l7629:; BSR set to: 0

		movlw	58
	xorwf	(0+(_uart_rx+01h))&0ffh,w
	btfss	status,2
	goto	u11291
	goto	u11290

u11291:
	goto	l7641
u11290:
	line	905
	
l7631:; BSR set to: 0

	movlw	low(0FFCFh)
	addwf	(0+(_uart_rx+02h))&0ffh,w
	movwf	((UART_ProcessRx@e))&0ffh
	clrf	1+((UART_ProcessRx@e))&0ffh
	movlw	high(0FFCFh)
	addwfc	1+((UART_ProcessRx@e))&0ffh
	line	906
	
l7633:; BSR set to: 0

		movlw	low(_uart_rx+04h)
	movwf	((c:parse_2d@s))^00h,c

	call	_parse_2d	;wreg free
	movff	0+?_parse_2d,(UART_ProcessRx@fl_1225)
	movff	1+?_parse_2d,(UART_ProcessRx@fl_1225+1)
	line	907
	
l7635:; BSR set to: 0

	btfsc	((UART_ProcessRx@e+1))&0ffh,7
	goto	u11301
	goto	u11300

u11301:
	goto	l7645
u11300:
	
l7637:; BSR set to: 0

	btfsc	((UART_ProcessRx@e+1))&0ffh,7
	goto	u11310
	movf	((UART_ProcessRx@e+1))&0ffh,w
	bnz	u11311
	movlw	3
	subwf	 ((UART_ProcessRx@e))&0ffh,w
	btfsc	status,0
	goto	u11311
	goto	u11310

u11311:
	goto	l7645
u11310:
	
l7639:; BSR set to: 0

	movff	(UART_ProcessRx@e),(c:encolar_destino_cabina@w)
	movff	(UART_ProcessRx@e+1),(c:encolar_destino_cabina@w+1)
	movff	(UART_ProcessRx@fl_1225),(c:encolar_destino_cabina@num)
	movff	(UART_ProcessRx@fl_1225+1),(c:encolar_destino_cabina@num+1)
	call	_encolar_destino_cabina	;wreg free
	goto	l7645
	line	908
	
l7641:; BSR set to: 0

		movlw	82
	xorwf	((_uart_rx))&0ffh,w
	btfss	status,2
	goto	u11321
	goto	u11320

u11321:
	goto	l7645
u11320:
	line	909
	
l7643:; BSR set to: 0

	call	_reiniciar_sistema	;wreg free
	line	911
	
l7645:
	movlb	0	; () banked
	clrf	((_uart_rx_len))&0ffh
	line	912
	goto	l7653
	
l7647:; BSR set to: 0

		movlw	012h-0
	cpfslt	((_uart_rx_len))&0ffh
	goto	u11331
	goto	u11330

u11331:
	goto	l7653
u11330:
	line	913
	
l7649:; BSR set to: 0

	movf	((_uart_rx_len))&0ffh,w
	addlw	low(_uart_rx)
	movwf	fsr2l
	clrf	fsr2h
	movff	(UART_ProcessRx@c),indf2

	
l7651:; BSR set to: 0

	incf	((_uart_rx_len))&0ffh
	line	883
	
l7653:
	movlb	0	; () banked
	movf	((_rx_head))&0ffh,w	;volatile
xorwf	((_rx_tail))&0ffh,w	;volatile
	btfss	status,2
	goto	u11341
	goto	u11340

u11341:
	goto	l7559
u11340:
	line	916
	
l748:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_ProcessRx
	__end_of_UART_ProcessRx:
	signat	_UART_ProcessRx,89
	global	_reiniciar_sistema

;; *************** function _reiniciar_sistema *****************
;; Defined at:
;;		line 522 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  e               2   56[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         4       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:         5       0       0       0       0       0       0       0       0
;;Total ram usage:        5 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		_UART_EnviarEstado
;;		_UART_PutStr
;;		_UART_TxFree
;;		___awdiv
;;		_memset
;;		_poner_msg
;; This function is called by:
;;		_UART_ProcessRx
;; This function uses a non-reentrant model
;;
psect	text11,class=CODE,space=0,reloc=2,group=0
	line	522
global __ptext11
__ptext11:
psect	text11
	file	"LOGIC_TEST.c"
	line	522
	
_reiniciar_sistema:; BSR set to: 0

;incstack = 0
	callstack 27
	line	524
	
l6817:; BSR set to: 0

	clrf	((c:_emergencia))^00h,c
	line	525
	
l6819:; BSR set to: 0

	clrf	((c:_modo+1))^00h,c
	movlw	low(0)
	movwf	((c:_modo))^00h,c
	clrf	((_piso_usr+1))&0ffh
	movlw	low(0)
	movwf	((_piso_usr))&0ffh
	clrf	((_elev_activo+1))&0ffh
	movlw	low(0)
	movwf	((_elev_activo))&0ffh
	clrf	((_buf_len+1))&0ffh
	movlw	low(0)
	movwf	((_buf_len))&0ffh
	
l6821:; BSR set to: 0

	clrf	((_buf))&0ffh
	line	526
	clrf	((_cola_esp_len+1))&0ffh
	movlw	low(0)
	movwf	((_cola_esp_len))&0ffh
	line	527
	
l6823:; BSR set to: 0

	setf	((_cola_espera))&0ffh
	setf	((_cola_espera+1))&0ffh
	
l6825:; BSR set to: 0

	setf	(0+(_cola_espera+02h))&0ffh
	setf	(1+(_cola_espera+02h))&0ffh
	
l6827:; BSR set to: 0

	setf	(0+(_cola_espera+04h))&0ffh
	setf	(1+(_cola_espera+04h))&0ffh
	line	528
	
l6829:; BSR set to: 0

		movlw	low(_paradas)
	movwf	((c:memset@dest))^00h,c
	movlw	high(_paradas)
	movwf	((c:memset@dest+1))^00h,c

	clrf	((c:memset@c+1))^00h,c
	movlw	low(0)
	movwf	((c:memset@c))^00h,c
	clrf	((c:memset@n+1))^00h,c
	movlw	low(03Fh)
	movwf	((c:memset@n))^00h,c
	call	_memset	;wreg free
	line	530
	
l6831:
	movlb	0	; () banked
	clrf	((_piso+1))&0ffh
	movlw	low(01h)
	movwf	((_piso))&0ffh
	line	531
	
l6833:; BSR set to: 0

	movff	(c:_num_pisos),(c:___awdiv@dividend)
	movff	(c:_num_pisos+1),(c:___awdiv@dividend+1)
	clrf	((c:___awdiv@divisor+1))^00h,c
	movlw	low(02h)
	movwf	((c:___awdiv@divisor))^00h,c
	call	___awdiv	;wreg free
	btfsc	(1+?___awdiv)^00h,c,7
	goto	u9540
	movf	(1+?___awdiv)^00h,c,w
	bnz	u9541
	movlw	2
	subwf	 (0+?___awdiv)^00h,c,w
	btfsc	status,0
	goto	u9541
	goto	u9540

u9541:
	goto	l6837
u9540:
	
l6835:
	clrf	((c:_reiniciar_sistema$1100+1))^00h,c
	movlw	low(01h)
	movwf	((c:_reiniciar_sistema$1100))^00h,c
	goto	l6839
	
l6837:
	movff	(c:_num_pisos),(c:___awdiv@dividend)
	movff	(c:_num_pisos+1),(c:___awdiv@dividend+1)
	clrf	((c:___awdiv@divisor+1))^00h,c
	movlw	low(02h)
	movwf	((c:___awdiv@divisor))^00h,c
	call	___awdiv	;wreg free
	movff	0+?___awdiv,(c:_reiniciar_sistema$1100)
	movff	1+?___awdiv,(c:_reiniciar_sistema$1100+1)
	
l6839:
	movff	(c:_reiniciar_sistema$1100),0+(_piso+02h)
	movff	(c:_reiniciar_sistema$1100+1),1+(_piso+02h)
	line	532
	
l6841:
	movff	(c:_num_pisos),0+(_piso+04h)
	movff	(c:_num_pisos+1),1+(_piso+04h)
	line	533
	
l6843:
	clrf	((c:reiniciar_sistema@e+1))^00h,c
	movlw	low(0)
	movwf	((c:reiniciar_sistema@e))^00h,c
	line	534
	
l6849:
	movf	((c:reiniciar_sistema@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	535
	movf	((c:reiniciar_sistema@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	536
	movf	((c:reiniciar_sistema@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	537
	movf	((c:reiniciar_sistema@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_piso)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	538
	movf	((c:reiniciar_sistema@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	539
	movf	((c:reiniciar_sistema@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	540
	
l6851:
	infsnz	((c:reiniciar_sistema@e))^00h,c
	incf	((c:reiniciar_sistema@e+1))^00h,c
	
l6853:
	btfsc	((c:reiniciar_sistema@e+1))^00h,c,7
	goto	u9551
	movf	((c:reiniciar_sistema@e+1))^00h,c,w
	bnz	u9550
	movlw	3
	subwf	 ((c:reiniciar_sistema@e))^00h,c,w
	btfss	status,0
	goto	u9551
	goto	u9550

u9551:
	goto	l6849
u9550:
	
l493:
	line	541
	bcf	((c:3978))^0f00h,c,5	;volatile
	
l6855:
	movlb	0	; () banked
	clrf	((_cont_buzz+1))&0ffh
	movlw	low(0)
	movwf	((_cont_buzz))&0ffh
	line	542
	
l6857:; BSR set to: 0

		movlw	low(STR_14)
	movwf	((c:poner_msg@s))^00h,c
	movlw	high(STR_14)
	movwf	((c:poner_msg@s+1))^00h,c

	call	_poner_msg	;wreg free
	line	543
	
l6859:; BSR set to: 1

	call	_UART_TxFree	;wreg free
	movwf	(??_reiniciar_sistema+0)^00h,c
		movlw	08h-1
	cpfsgt	((??_reiniciar_sistema+0))^00h,c
	goto	u9561
	goto	u9560

u9561:
	goto	l6863
u9560:
	
l6861:; BSR set to: 0

		movlw	low(STR_15)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_15)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	544
	
l6863:
	call	_UART_EnviarEstado	;wreg free
	line	545
	
l495:
	return	;funcret
	callstack 0
GLOBAL	__end_of_reiniciar_sistema
	__end_of_reiniciar_sistema:
	signat	_reiniciar_sistema,89
	global	_memset

;; *************** function _memset *****************
;; Defined at:
;;		line 3 in file "D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\memset.c"
;; Parameters:    Size  Location     Type
;;  dest            2    5[COMRAM] PTR void 
;;		 -> paradas(63), 
;;  c               2    7[COMRAM] int 
;;  n               2    9[COMRAM] unsigned int 
;; Auto vars:     Size  Location     Type
;;  p               2   11[COMRAM] PTR unsigned char 
;;		 -> paradas(63), 
;; Return value:  Size  Location     Type
;;                  2    5[COMRAM] PTR void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         6       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         8       0       0       0       0       0       0       0       0
;;Total ram usage:        8 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_reiniciar_sistema
;;		_main
;; This function uses a non-reentrant model
;;
psect	text12,class=CODE,space=0,reloc=2,group=2
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\memset.c"
	line	3
global __ptext12
__ptext12:
psect	text12
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\memset.c"
	line	3
	
_memset:
;incstack = 0
	callstack 27
	line	5
	
l6549:
		movff	(c:memset@dest),(c:memset@p)
	movff	(c:memset@dest+1),(c:memset@p+1)

	line	6
	goto	l6555
	line	7
	
l6551:
	movff	(c:memset@p),fsr2l
	movff	(c:memset@p+1),fsr2h
	movff	(c:memset@c),indf2

	
l6553:
	infsnz	((c:memset@p))^00h,c
	incf	((c:memset@p+1))^00h,c
	line	6
	
l6555:
	decf	((c:memset@n))^00h,c
	btfss	status,0
	decf	((c:memset@n+1))^00h,c
		incf	((c:memset@n))^00h,c,w
	bnz	u9011
	incf	((c:memset@n+1))^00h,c,w
	btfss	status,2
	goto	u9011
	goto	u9010

u9011:
	goto	l6551
u9010:
	line	10
	
l1558:
	return	;funcret
	callstack 0
GLOBAL	__end_of_memset
	__end_of_memset:
	signat	_memset,12410
	global	_procesar_tecla

;; *************** function _procesar_tecla *****************
;; Defined at:
;;		line 625 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  k               1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  k               1   70[COMRAM] unsigned char 
;;  e               2   71[COMRAM] int 
;;  num             2   68[COMRAM] int 
;;  w               2   66[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         9       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:        11       0       0       0       0       0       0       0       0
;;Total ram usage:       11 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_UART_EmitEmg
;;		_UART_EnviarEstado
;;		_beep
;;		_elev_esperando
;;		_encolar_destino_cabina
;;		_msg_elev
;;		_poner_msg
;;		_quitar_cola_espera
;;		_siguiente_objetivo
;;		_tiene_paradas
;; This function is called by:
;;		_UART_ProcessRx
;;		_main
;; This function uses a non-reentrant model
;;
psect	text13,class=CODE,space=0,reloc=2,group=0
	file	"LOGIC_TEST.c"
	line	625
global __ptext13
__ptext13:
psect	text13
	file	"LOGIC_TEST.c"
	line	625
	
_procesar_tecla:
;incstack = 0
	callstack 28
	movwf	((c:procesar_tecla@k))^00h,c
	line	627
	
l6883:
		movlw	42
	xorwf	((c:procesar_tecla@k))^00h,c,w
	btfss	status,2
	goto	u9601
	goto	u9600

u9601:
	goto	l6901
u9600:
	line	628
	
l6885:
	movf	((c:_emergencia))^00h,c,w
	btfsc	status,2
	goto	u9611
	goto	u9610
u9611:
	movlw	1
	goto	u9620
u9610:
	movlw	0
u9620:
	movwf	((c:_emergencia))^00h,c
	line	629
	clrf	((c:_modo+1))^00h,c
	movlw	low(0)
	movwf	((c:_modo))^00h,c
	movlb	0	; () banked
	clrf	((_buf_len+1))&0ffh
	movlw	low(0)
	movwf	((_buf_len))&0ffh
	
l6887:; BSR set to: 0

	clrf	((_buf))&0ffh
	clrf	((_piso_usr+1))&0ffh
	movlw	low(0)
	movwf	((_piso_usr))&0ffh
	line	630
	movf	((c:_emergencia))^00h,c,w
	btfsc	status,2
	goto	u9631
	goto	u9630
u9631:
	goto	l551
u9630:
	
l6889:; BSR set to: 0

	clrf	((c:beep@t+1))^00h,c
	movlw	low(019h)
	movwf	((c:beep@t))^00h,c
	call	_beep	;wreg free
	goto	l6895
	line	631
	
l551:; BSR set to: 0

	bcf	((c:3978))^0f00h,c,5	;volatile
	
l6891:; BSR set to: 0

	clrf	((_cont_buzz+1))&0ffh
	movlw	low(0)
	movwf	((_cont_buzz))&0ffh
	
l6893:; BSR set to: 0

		movlw	low(STR_23)
	movwf	((c:poner_msg@s))^00h,c
	movlw	high(STR_23)
	movwf	((c:poner_msg@s+1))^00h,c

	call	_poner_msg	;wreg free
	line	632
	
l6895:
	movf	((c:_emergencia))^00h,c,w
	
	call	_UART_EmitEmg
	line	633
	
l6897:
	call	_UART_EnviarEstado	;wreg free
	goto	l553
	line	636
	
l6901:
	movf	((c:_emergencia))^00h,c,w
	btfsc	status,2
	goto	u9641
	goto	u9640
u9641:
	goto	l6905
u9640:
	goto	l553
	line	637
	
l6905:
	clrf	((c:beep@t+1))^00h,c
	movlw	low(04h)
	movwf	((c:beep@t))^00h,c
	call	_beep	;wreg free
	line	639
	
l6907:
		movlw	65
	xorwf	((c:procesar_tecla@k))^00h,c,w
	btfss	status,2
	goto	u9651
	goto	u9650

u9651:
	goto	l6915
u9650:
	
l6909:
	clrf	((c:_modo+1))^00h,c
	movlw	low(01h)
	movwf	((c:_modo))^00h,c
	movlb	0	; () banked
	clrf	((_buf_len+1))&0ffh
	movlw	low(0)
	movwf	((_buf_len))&0ffh
	
l6911:; BSR set to: 0

	clrf	((_buf))&0ffh
	clrf	((_piso_usr+1))&0ffh
	movlw	low(0)
	movwf	((_piso_usr))&0ffh
	goto	l553
	line	641
	
l6915:
		movlw	030h-1
	cpfsgt	((c:procesar_tecla@k))^00h,c
	goto	u9661
	goto	u9660

u9661:
	goto	l6955
u9660:
	
l6917:
		movlw	03Ah-0
	cpfslt	((c:procesar_tecla@k))^00h,c
	goto	u9671
	goto	u9670

u9671:
	goto	l6955
u9670:
	line	642
	
l6919:
	call	_elev_esperando	;wreg free
	movff	0+?_elev_esperando,(c:procesar_tecla@w)
	movff	1+?_elev_esperando,(c:procesar_tecla@w+1)
	line	643
	
l6921:; BSR set to: 0

		decf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfsc	status,2
	goto	u9681
	goto	u9680

u9681:
	goto	l6927
u9680:
	
l6923:; BSR set to: 0

	movf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u9691
	goto	u9690

u9691:
	goto	l6947
u9690:
	
l6925:; BSR set to: 0

	btfsc	((c:procesar_tecla@w+1))^00h,c,7
	goto	u9701
	goto	u9700

u9701:
	goto	l6947
u9700:
	line	644
	
l6927:; BSR set to: 0

	btfsc	((_buf_len+1))&0ffh,7
	goto	u9711
	movf	((_buf_len+1))&0ffh,w
	bnz	u9710
	movlw	2
	subwf	 ((_buf_len))&0ffh,w
	btfss	status,0
	goto	u9711
	goto	u9710

u9711:
	goto	l6933
u9710:
	
l6929:; BSR set to: 0

	movff	(c:procesar_tecla@k),(_buf)
	clrf	(0+(_buf+01h))&0ffh
	
l6931:; BSR set to: 0

	clrf	((_buf_len+1))&0ffh
	movlw	low(01h)
	movwf	((_buf_len))&0ffh
	goto	l6939
	line	645
	
l6933:; BSR set to: 0

	movf	((_buf_len))&0ffh,w
	addlw	low(_buf)
	movwf	fsr2l
	clrf	fsr2h
	movff	(c:procesar_tecla@k),indf2

	
l6935:; BSR set to: 0

	infsnz	((_buf_len))&0ffh
	incf	((_buf_len+1))&0ffh
	
l6937:; BSR set to: 0

	movf	((_buf_len))&0ffh,w
	addlw	low(_buf)
	movwf	fsr2l
	clrf	fsr2h
	clrf	indf2
	line	646
	
l6939:; BSR set to: 0

	movf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u9721
	goto	u9720

u9721:
	goto	l553
u9720:
	
l6941:; BSR set to: 0

	btfsc	((c:procesar_tecla@w+1))^00h,c,7
	goto	u9731
	goto	u9730

u9731:
	goto	l553
u9730:
	
l6943:; BSR set to: 0

	movf	((c:procesar_tecla@w))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	movlw	1
	btfsc	plusw2,7
	goto	u9741
	movlw	1
	movf	plusw2,w
	bnz	u9740
	decf	postinc2,w
	btfss	status,0
	goto	u9741
	goto	u9740

u9741:
	goto	l553
u9740:
	
l6945:; BSR set to: 0

	movf	((c:procesar_tecla@w))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01C2h)
	movwf	postinc2,c
	movlw	high(01C2h)
	movwf	postdec2,c
	goto	l553
	line	647
	
l6947:; BSR set to: 0

		movlw	2
	xorwf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u9751
	goto	u9750

u9751:
	goto	l6951
u9750:
	
l6949:; BSR set to: 0

	movlw	high(-1)
	movwf	((c:msg_elev@e+1))^00h,c
	setf	((c:msg_elev@e))^00h,c
		movlw	low(STR_24)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_24)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(01h)
	movwf	((c:msg_elev@pos_num))^00h,c
	movff	(_piso_usr),(c:msg_elev@num)
	movff	(_piso_usr+1),(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	goto	l553
	line	648
	
l6951:; BSR set to: 0

		movlw	low(STR_25)
	movwf	((c:poner_msg@s))^00h,c
	movlw	high(STR_25)
	movwf	((c:poner_msg@s+1))^00h,c

	call	_poner_msg	;wreg free
	goto	l553
	line	652
	
l6955:
		movlw	35
	xorwf	((c:procesar_tecla@k))^00h,c,w
	btfss	status,2
	goto	u9761
	goto	u9760

u9761:
	goto	l6997
u9760:
	line	653
	
l6957:
	movlb	0	; () banked
		decf	((_buf_len))&0ffh,w
iorwf	((_buf_len+1))&0ffh,w
	btfsc	status,2
	goto	u9771
	goto	u9770

u9771:
	goto	l6967
u9770:
	
l6959:; BSR set to: 0

		movlw	2
	xorwf	((_buf_len))&0ffh,w
iorwf	((_buf_len+1))&0ffh,w
	btfsc	status,2
	goto	u9781
	goto	u9780

u9781:
	goto	l6963
u9780:
	
l6961:; BSR set to: 0

	clrf	((c:_procesar_tecla$1146+1))^00h,c
	movlw	low(0)
	movwf	((c:_procesar_tecla$1146))^00h,c
	goto	l6965
	
l6963:; BSR set to: 0

	movf	((_buf))&0ffh,w
	mullw	0Ah
	movff	prodl,??_procesar_tecla+0
	movff	prodh,??_procesar_tecla+0+1
	movf	(0+(_buf+01h))&0ffh,w
	addwf	(??_procesar_tecla+0)^00h,c
	movlw	0
	addwfc	(??_procesar_tecla+0+1)^00h,c
	movlw	low(0FDF0h)
	addwf	(??_procesar_tecla+0)^00h,c,w
	movwf	((c:_procesar_tecla$1146))^00h,c
	movlw	high(0FDF0h)
	addwfc	(??_procesar_tecla+0+1)^00h,c,w
	movwf	1+((c:_procesar_tecla$1146))^00h,c
	
l6965:; BSR set to: 0

	movff	(c:_procesar_tecla$1146),(c:procesar_tecla@num)
	movff	(c:_procesar_tecla$1146+1),(c:procesar_tecla@num+1)
	goto	l6969
	
l6967:; BSR set to: 0

	movlw	low(0FFD0h)
	addwf	((_buf))&0ffh,w
	movwf	((c:procesar_tecla@num))^00h,c
	clrf	1+((c:procesar_tecla@num))^00h,c
	movlw	high(0FFD0h)
	addwfc	1+((c:procesar_tecla@num))^00h,c
	line	655
	
l6969:; BSR set to: 0

	clrf	((_buf_len+1))&0ffh
	movlw	low(0)
	movwf	((_buf_len))&0ffh
	
l6971:; BSR set to: 0

	clrf	((_buf))&0ffh
	line	657
	
l6973:; BSR set to: 0

		decf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u9791
	goto	u9790

u9791:
	goto	l6989
u9790:
	line	658
	
l6975:; BSR set to: 0

	btfsc	((c:procesar_tecla@num+1))^00h,c,7
	goto	u9801
	movf	((c:procesar_tecla@num+1))^00h,c,w
	bnz	u9800
	decf	((c:procesar_tecla@num))^00h,c,w
	btfss	status,0
	goto	u9801
	goto	u9800

u9801:
	goto	l6979
u9800:
	
l6977:; BSR set to: 0

		movf	((c:procesar_tecla@num))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_procesar_tecla+0)^00h,c
	movf	((c:procesar_tecla@num+1))^00h,c,w
	xorlw	80h
	subwfb	(??_procesar_tecla+0)^00h,c,w
	btfsc	status,0
	goto	u9811
	goto	u9810

u9811:
	goto	l576
u9810:
	
l6979:; BSR set to: 0

	clrf	((c:_modo+1))^00h,c
	movlw	low(0)
	movwf	((c:_modo))^00h,c
	
l6981:; BSR set to: 0

		movlw	low(STR_26)
	movwf	((c:poner_msg@s))^00h,c
	movlw	high(STR_26)
	movwf	((c:poner_msg@s+1))^00h,c

	call	_poner_msg	;wreg free
	
l6983:; BSR set to: 1

	clrf	((c:beep@t+1))^00h,c
	movlw	low(012h)
	movwf	((c:beep@t))^00h,c
	call	_beep	;wreg free
	goto	l553
	line	659
	
l576:; BSR set to: 0

	movff	(c:procesar_tecla@num),(_piso_usr)
	movff	(c:procesar_tecla@num+1),(_piso_usr+1)
	
l6985:; BSR set to: 0

	clrf	((c:_modo+1))^00h,c
	movlw	low(02h)
	movwf	((c:_modo))^00h,c
	
l6987:; BSR set to: 0

	movlw	high(-1)
	movwf	((c:msg_elev@e+1))^00h,c
	setf	((c:msg_elev@e))^00h,c
		movlw	low(STR_27)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_27)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(01h)
	movwf	((c:msg_elev@pos_num))^00h,c
	movff	(c:procesar_tecla@num),(c:msg_elev@num)
	movff	(c:procesar_tecla@num+1),(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	goto	l553
	line	660
	
l6989:; BSR set to: 0

	movf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u9821
	goto	u9820

u9821:
	goto	l553
u9820:
	
l6991:; BSR set to: 0

	call	_elev_esperando	;wreg free
	movff	0+?_elev_esperando,(c:procesar_tecla@w)
	movff	1+?_elev_esperando,(c:procesar_tecla@w+1)
	btfsc	((c:procesar_tecla@w+1))^00h,c,7
	goto	u9831
	goto	u9830

u9831:
	goto	l553
u9830:
	line	661
	
l6993:; BSR set to: 0

	movff	(c:procesar_tecla@w),(c:encolar_destino_cabina@w)
	movff	(c:procesar_tecla@w+1),(c:encolar_destino_cabina@w+1)
	movff	(c:procesar_tecla@num),(c:encolar_destino_cabina@num)
	movff	(c:procesar_tecla@num+1),(c:encolar_destino_cabina@num+1)
	call	_encolar_destino_cabina	;wreg free
	goto	l553
	line	666
	
l6997:
		movlw	66
	xorwf	((c:procesar_tecla@k))^00h,c,w
	btfss	status,2
	goto	u9841
	goto	u9840

u9841:
	goto	l7023
u9840:
	line	667
	
l6999:
	call	_elev_esperando	;wreg free
	btfsc	(1+?_elev_esperando)^00h,c,7
	goto	u9850
	goto	u9851

u9851:
	goto	l7003
u9850:
	
l7001:; BSR set to: 0

	movff	(_elev_activo),(c:procesar_tecla@e)
	movff	(_elev_activo+1),(c:procesar_tecla@e+1)
	goto	l7005
	
l7003:; BSR set to: 0

	call	_elev_esperando	;wreg free
	movff	0+?_elev_esperando,(c:procesar_tecla@e)
	movff	1+?_elev_esperando,(c:procesar_tecla@e+1)
	line	668
	
l7005:; BSR set to: 0

	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfsc	status,2
	goto	u9861
	goto	u9860

u9861:
	goto	l553
u9860:
	line	669
	
l7007:; BSR set to: 0

	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfsc	status,2
	goto	u9871
	goto	u9870

u9871:
	goto	l7011
u9870:
	
l7009:; BSR set to: 0

	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	3
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u9881
	goto	u9880

u9881:
	goto	l7013
u9880:
	
l7011:; BSR set to: 0

	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(03h)
	movwf	postinc2,c
	movlw	high(03h)
	movwf	postdec2,c
	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(0DCh)
	movwf	postinc2,c
	movlw	high(0DCh)
	movwf	postdec2,c
	goto	l7017
	line	670
	
l7013:; BSR set to: 0

	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movlw	1
	btfsc	plusw2,7
	goto	u9891
	movlw	1
	movf	plusw2,w
	bnz	u9890
	decf	postinc2,w
	btfss	status,0
	goto	u9891
	goto	u9890

u9891:
	goto	l7017
u9890:
	
l7015:; BSR set to: 0

	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01C2h)
	movwf	postinc2,c
	movlw	high(01C2h)
	movwf	postdec2,c
	line	671
	
l7017:; BSR set to: 0

	movff	(c:procesar_tecla@e),(c:msg_elev@e)
	movff	(c:procesar_tecla@e+1),(c:msg_elev@e+1)
		movlw	low(STR_28)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_28)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	movlw	high(-1)
	movwf	((c:msg_elev@pos_num+1))^00h,c
	setf	((c:msg_elev@pos_num))^00h,c
	clrf	((c:msg_elev@num+1))^00h,c
	movlw	low(0)
	movwf	((c:msg_elev@num))^00h,c
	call	_msg_elev	;wreg free
	
l7019:; BSR set to: 1

	clrf	((c:beep@t+1))^00h,c
	movlw	low(07h)
	movwf	((c:beep@t))^00h,c
	call	_beep	;wreg free
	goto	l6897
	line	674
	
l7023:
		movlw	67
	xorwf	((c:procesar_tecla@k))^00h,c,w
	btfss	status,2
	goto	u9901
	goto	u9900

u9901:
	goto	l7061
u9900:
	line	675
	
l7025:
	call	_elev_esperando	;wreg free
	btfsc	(1+?_elev_esperando)^00h,c,7
	goto	u9910
	goto	u9911

u9911:
	goto	l7029
u9910:
	
l7027:; BSR set to: 0

	movff	(_elev_activo),(c:procesar_tecla@e)
	movff	(_elev_activo+1),(c:procesar_tecla@e+1)
	goto	l7031
	
l7029:; BSR set to: 0

	call	_elev_esperando	;wreg free
	movff	0+?_elev_esperando,(c:procesar_tecla@e)
	movff	1+?_elev_esperando,(c:procesar_tecla@e+1)
	line	676
	
l7031:; BSR set to: 0

	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	2
	xorwf	postinc2,w
iorwf	postinc2,w
	btfsc	status,2
	goto	u9921
	goto	u9920

u9921:
	goto	l7035
u9920:
	
l7033:; BSR set to: 0

	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	3
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u9931
	goto	u9930

u9931:
	goto	l553
u9930:
	line	677
	
l7035:; BSR set to: 0

	movff	(c:procesar_tecla@e),(c:quitar_cola_espera@e)
	movff	(c:procesar_tecla@e+1),(c:quitar_cola_espera@e+1)
	call	_quitar_cola_espera	;wreg free
	line	678
	
l7037:; BSR set to: 0

	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	
l7039:; BSR set to: 0

	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	
l7041:; BSR set to: 0

	clrf	((_buf_len+1))&0ffh
	movlw	low(0)
	movwf	((_buf_len))&0ffh
	
l7043:; BSR set to: 0

	clrf	((_buf))&0ffh
	line	679
	
l7045:; BSR set to: 0

	movff	(c:procesar_tecla@e),(c:tiene_paradas@e)
	movff	(c:procesar_tecla@e+1),(c:tiene_paradas@e+1)
	call	_tiene_paradas	;wreg free
	movf	(0+?_tiene_paradas)^00h,c,w
iorwf	(1+?_tiene_paradas)^00h,c,w
	btfsc	status,2
	goto	u9941
	goto	u9940

u9941:
	goto	l7053
u9940:
	line	680
	
l7047:
	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	movwf	postinc2,c
	movlw	high(01h)
	movwf	postdec2,c
	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_piso)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	
l7049:
	movff	(c:procesar_tecla@e),(c:siguiente_objetivo@e)
	movff	(c:procesar_tecla@e+1),(c:siguiente_objetivo@e+1)
	call	_siguiente_objetivo	;wreg free
	line	681
	
l7051:
	movff	(c:procesar_tecla@e),(c:msg_elev@e)
	movff	(c:procesar_tecla@e+1),(c:msg_elev@e+1)
		movlw	low(STR_29)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_29)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(0Ah)
	movwf	((c:msg_elev@pos_num))^00h,c
	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:msg_elev@num)
	movff	postdec2,(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	line	682
	goto	l7019
	line	683
	
l7053:
	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	movf	((c:procesar_tecla@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	684
	
l7055:
	movff	(c:procesar_tecla@e),(c:msg_elev@e)
	movff	(c:procesar_tecla@e+1),(c:msg_elev@e+1)
		movlw	low(STR_30)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_30)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	movlw	high(-1)
	movwf	((c:msg_elev@pos_num+1))^00h,c
	setf	((c:msg_elev@pos_num))^00h,c
	clrf	((c:msg_elev@num+1))^00h,c
	movlw	low(0)
	movwf	((c:msg_elev@num))^00h,c
	call	_msg_elev	;wreg free
	goto	l7019
	line	689
	
l7061:
		movlw	68
	xorwf	((c:procesar_tecla@k))^00h,c,w
	btfss	status,2
	goto	u9951
	goto	u9950

u9951:
	goto	l553
u9950:
	line	690
	
l7063:
	movlb	0	; () banked
	btfsc	((_buf_len+1))&0ffh,7
	goto	u9961
	movf	((_buf_len+1))&0ffh,w
	bnz	u9960
	decf	((_buf_len))&0ffh,w
	btfss	status,0
	goto	u9961
	goto	u9960

u9961:
	goto	l7067
u9960:
	
l7065:; BSR set to: 0

	decf	((_buf_len))&0ffh
	btfss	status,0
	decf	((_buf_len+1))&0ffh
	movf	((_buf_len))&0ffh,w
	addlw	low(_buf)
	movwf	fsr2l
	clrf	fsr2h
	clrf	indf2
	goto	l553
	line	691
	
l7067:; BSR set to: 0

		movlw	2
	xorwf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u9971
	goto	u9970

u9971:
	goto	l7071
u9970:
	
l7069:; BSR set to: 0

	clrf	((_piso_usr+1))&0ffh
	movlw	low(0)
	movwf	((_piso_usr))&0ffh
	clrf	((c:_modo+1))^00h,c
	movlw	low(01h)
	movwf	((c:_modo))^00h,c
	goto	l553
	line	692
	
l7071:; BSR set to: 0

		decf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u9981
	goto	u9980

u9981:
	goto	l553
u9980:
	
l7073:; BSR set to: 0

	clrf	((c:_modo+1))^00h,c
	movlw	low(0)
	movwf	((c:_modo))^00h,c
	
l7075:; BSR set to: 0

		movlw	low(STR_31)
	movwf	((c:poner_msg@s))^00h,c
	movlw	high(STR_31)
	movwf	((c:poner_msg@s+1))^00h,c

	call	_poner_msg	;wreg free
	line	694
	
l553:
	return	;funcret
	callstack 0
GLOBAL	__end_of_procesar_tecla
	__end_of_procesar_tecla:
	signat	_procesar_tecla,4217
	global	_encolar_destino_cabina

;; *************** function _encolar_destino_cabina *****************
;; Defined at:
;;		line 602 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  w               2   53[COMRAM] int 
;;  num             2   55[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  nueva           1   61[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         4       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0
;;      Temps:          4       0       0       0       0       0       0       0       0
;;      Totals:         9       0       0       0       0       0       0       0       0
;;Total ram usage:        9 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_UART_EmitEnq
;;		_UART_EnviarEstado
;;		_beep
;;		_msg_elev
;;		_poner_msg
;;		_siguiente_objetivo
;; This function is called by:
;;		_procesar_tecla
;;		_UART_ProcessRx
;; This function uses a non-reentrant model
;;
psect	text14,class=CODE,space=0,reloc=2,group=0
	line	602
global __ptext14
__ptext14:
psect	text14
	file	"LOGIC_TEST.c"
	line	602
	
_encolar_destino_cabina:
;incstack = 0
	callstack 27
	line	603
	
l6647:; BSR set to: 0

	btfsc	((c:encolar_destino_cabina@w+1))^00h,c,7
	goto	u9191
	goto	u9190

u9191:
	goto	l537
u9190:
	
l6649:; BSR set to: 0

	btfsc	((c:encolar_destino_cabina@w+1))^00h,c,7
	goto	u9200
	movf	((c:encolar_destino_cabina@w+1))^00h,c,w
	bnz	u9201
	movlw	3
	subwf	 ((c:encolar_destino_cabina@w))^00h,c,w
	btfsc	status,0
	goto	u9201
	goto	u9200

u9201:
	goto	l537
u9200:
	
l6651:; BSR set to: 0

	movf	((c:_emergencia))^00h,c,w
	btfsc	status,2
	goto	u9211
	goto	u9210
u9211:
	goto	l6653
u9210:
	goto	l537
	line	604
	
l6653:; BSR set to: 0

	btfsc	((c:encolar_destino_cabina@num+1))^00h,c,7
	goto	u9221
	movf	((c:encolar_destino_cabina@num+1))^00h,c,w
	bnz	u9220
	decf	((c:encolar_destino_cabina@num))^00h,c,w
	btfss	status,0
	goto	u9221
	goto	u9220

u9221:
	goto	l6657
u9220:
	
l6655:; BSR set to: 0

		movf	((c:encolar_destino_cabina@num))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_encolar_destino_cabina+0)^00h,c
	movf	((c:encolar_destino_cabina@num+1))^00h,c,w
	xorlw	80h
	subwfb	(??_encolar_destino_cabina+0)^00h,c,w
	btfsc	status,0
	goto	u9231
	goto	u9230

u9231:
	goto	l6663
u9230:
	
l6657:; BSR set to: 0

		movlw	low(STR_20)
	movwf	((c:poner_msg@s))^00h,c
	movlw	high(STR_20)
	movwf	((c:poner_msg@s+1))^00h,c

	call	_poner_msg	;wreg free
	
l6659:; BSR set to: 1

	clrf	((c:beep@t+1))^00h,c
	movlw	low(012h)
	movwf	((c:beep@t))^00h,c
	call	_beep	;wreg free
	goto	l537
	line	605
	
l6663:; BSR set to: 0

	movf	((c:encolar_destino_cabina@w))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movf	((c:encolar_destino_cabina@num))^00h,c,w
xorwf	postinc2,w
	bnz	u9241
movf	((c:encolar_destino_cabina@num+1))^00h,c,w
xorwf	postinc2,w
	btfss	status,2
	goto	u9241
	goto	u9240

u9241:
	goto	l6669
u9240:
	
l6665:; BSR set to: 0

	movlw	high(-1)
	movwf	((c:msg_elev@e+1))^00h,c
	setf	((c:msg_elev@e))^00h,c
		movlw	low(STR_21)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_21)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(0Bh)
	movwf	((c:msg_elev@pos_num))^00h,c
	movff	(c:encolar_destino_cabina@num),(c:msg_elev@num)
	movff	(c:encolar_destino_cabina@num+1),(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	goto	l537
	line	607
	
l6669:; BSR set to: 0

	movlw	low(015h)
	mulwf	((c:encolar_destino_cabina@w))^00h,c
	movff	prodl,??_encolar_destino_cabina+0
	movff	prodh,??_encolar_destino_cabina+0+1
	mulwf	((c:encolar_destino_cabina@w+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_encolar_destino_cabina+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_encolar_destino_cabina+0)^00h,c,w
	movwf	(??_encolar_destino_cabina+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_encolar_destino_cabina+0+1)^00h,c,w
	movwf	1+(??_encolar_destino_cabina+2)^00h,c
	movf	((c:encolar_destino_cabina@num))^00h,c,w
	addwf	(??_encolar_destino_cabina+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:encolar_destino_cabina@num+1))^00h,c,w
	addwfc	(??_encolar_destino_cabina+2+1)^00h,c,w
	movwf	1+c:fsr2l
	btfss	indf2,(2)&7
	goto	u9251
	goto	u9250
u9251:
	movlw	1
	goto	u9260
u9250:
	movlw	0
u9260:
	movwf	((c:encolar_destino_cabina@nueva))^00h,c
	line	608
	movlw	low(015h)
	mulwf	((c:encolar_destino_cabina@w))^00h,c
	movff	prodl,??_encolar_destino_cabina+0
	movff	prodh,??_encolar_destino_cabina+0+1
	mulwf	((c:encolar_destino_cabina@w+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_encolar_destino_cabina+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_encolar_destino_cabina+0)^00h,c,w
	movwf	(??_encolar_destino_cabina+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_encolar_destino_cabina+0+1)^00h,c,w
	movwf	1+(??_encolar_destino_cabina+2)^00h,c
	movf	((c:encolar_destino_cabina@num))^00h,c,w
	addwf	(??_encolar_destino_cabina+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:encolar_destino_cabina@num+1))^00h,c,w
	addwfc	(??_encolar_destino_cabina+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movlw	0+(2/8)
	bsf	plusw2,(2)&7
	line	609
	
l6671:; BSR set to: 0

	movf	((c:encolar_destino_cabina@nueva))^00h,c,w
	btfsc	status,2
	goto	u9271
	goto	u9270
u9271:
	goto	l6675
u9270:
	
l6673:; BSR set to: 0

	movff	(c:encolar_destino_cabina@w),(c:UART_EmitEnq@e)
	movff	(c:encolar_destino_cabina@w+1),(c:UART_EmitEnq@e+1)
	movff	(c:encolar_destino_cabina@num),(c:UART_EmitEnq@fl)
	movff	(c:encolar_destino_cabina@num+1),(c:UART_EmitEnq@fl+1)
	movlw	low(043h)
	movwf	((c:UART_EmitEnq@tipo))^00h,c
	call	_UART_EmitEnq	;wreg free
	line	611
	
l6675:
	movf	((c:encolar_destino_cabina@w))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	2
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u9281
	goto	u9280

u9281:
	goto	l6679
u9280:
	line	612
	
l6677:
	movf	((c:encolar_destino_cabina@w))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	incf	postinc2
	movlw	0
	addwfc	postdec2
	line	613
	movf	((c:encolar_destino_cabina@w))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01C2h)
	movwf	postinc2,c
	movlw	high(01C2h)
	movwf	postdec2,c
	line	614
	goto	l6689
	
l6679:
	movf	((c:encolar_destino_cabina@w))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u9291
	goto	u9290

u9291:
	goto	l6685
u9290:
	line	615
	
l6681:
	movf	((c:encolar_destino_cabina@w))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	movwf	postinc2,c
	movlw	high(01h)
	movwf	postdec2,c
	line	616
	movf	((c:encolar_destino_cabina@w))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_piso)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	617
	
l6683:
	movff	(c:encolar_destino_cabina@w),(c:siguiente_objetivo@e)
	movff	(c:encolar_destino_cabina@w+1),(c:siguiente_objetivo@e+1)
	call	_siguiente_objetivo	;wreg free
	line	618
	goto	l6689
	
l6685:
	movf	((c:encolar_destino_cabina@w))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u9301
	goto	u9300

u9301:
	goto	l6689
u9300:
	goto	l6683
	line	621
	
l6689:
	movff	(c:encolar_destino_cabina@w),(c:msg_elev@e)
	movff	(c:encolar_destino_cabina@w+1),(c:msg_elev@e+1)
		movlw	low(STR_22)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_22)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(05h)
	movwf	((c:msg_elev@pos_num))^00h,c
	movff	(c:encolar_destino_cabina@num),(c:msg_elev@num)
	movff	(c:encolar_destino_cabina@num+1),(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	line	622
	
l6691:; BSR set to: 1

	call	_UART_EnviarEstado	;wreg free
	line	623
	
l537:
	return	;funcret
	callstack 0
GLOBAL	__end_of_encolar_destino_cabina
	__end_of_encolar_destino_cabina:
	signat	_encolar_destino_cabina,8313
	global	_elev_esperando

;; *************** function _elev_esperando *****************
;; Defined at:
;;		line 354 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  e               2   17[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  2   13[COMRAM] int 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         6       0       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_quitar_cola_espera
;; This function is called by:
;;		_procesar_tecla
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text15,class=CODE,space=0,reloc=2,group=0
	line	354
global __ptext15
__ptext15:
psect	text15
	file	"LOGIC_TEST.c"
	line	354
	
_elev_esperando:
;incstack = 0
	callstack 27
	line	355
	
l6519:
	goto	l6531
	
l365:; BSR set to: 0

	line	356
	movff	(_cola_espera),(c:elev_esperando@e)
	movff	(_cola_espera+1),(c:elev_esperando@e+1)
	line	357
	
l6521:; BSR set to: 0

	btfsc	((c:elev_esperando@e+1))^00h,c,7
	goto	u8951
	goto	u8950

u8951:
	goto	l6529
u8950:
	
l6523:; BSR set to: 0

	btfsc	((c:elev_esperando@e+1))^00h,c,7
	goto	u8960
	movf	((c:elev_esperando@e+1))^00h,c,w
	bnz	u8961
	movlw	3
	subwf	 ((c:elev_esperando@e))^00h,c,w
	btfsc	status,0
	goto	u8961
	goto	u8960

u8961:
	goto	l6529
u8960:
	
l6525:; BSR set to: 0

	movf	((c:elev_esperando@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	2
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8971
	goto	u8970

u8971:
	goto	l6529
u8970:
	
l6527:; BSR set to: 0

	movff	(c:elev_esperando@e),(c:?_elev_esperando)
	movff	(c:elev_esperando@e+1),(c:?_elev_esperando+1)
	goto	l367
	line	358
	
l6529:; BSR set to: 0

	movff	(c:elev_esperando@e),(c:quitar_cola_espera@e)
	movff	(c:elev_esperando@e+1),(c:quitar_cola_espera@e+1)
	call	_quitar_cola_espera	;wreg free
	line	355
	
l6531:
	movlb	0	; () banked
	btfsc	((_cola_esp_len+1))&0ffh,7
	goto	u8980
	movf	((_cola_esp_len+1))&0ffh,w
	bnz	u8981
	decf	((_cola_esp_len))&0ffh,w
	btfsc	status,0
	goto	u8981
	goto	u8980

u8981:
	goto	l365
u8980:
	
l368:; BSR set to: 0

	line	360
	setf	((c:?_elev_esperando))^00h,c
	setf	((c:?_elev_esperando+1))^00h,c
	line	361
	
l367:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_elev_esperando
	__end_of_elev_esperando:
	signat	_elev_esperando,90
	global	_quitar_cola_espera

;; *************** function _quitar_cola_espera *****************
;; Defined at:
;;		line 345 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2    5[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  j               2   11[COMRAM] int 
;;  i               2    9[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, prodl, prodh
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         4       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         8       0       0       0       0       0       0       0       0
;;Total ram usage:        8 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_elev_esperando
;;		_procesar_tecla
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text16,class=CODE,space=0,reloc=2,group=0
	line	345
global __ptext16
__ptext16:
psect	text16
	file	"LOGIC_TEST.c"
	line	345
	
_quitar_cola_espera:; BSR set to: 0

;incstack = 0
	callstack 26
	line	346
	
l6169:
	clrf	((c:quitar_cola_espera@j+1))^00h,c
	movlw	low(0)
	movwf	((c:quitar_cola_espera@j))^00h,c
	line	347
	clrf	((c:quitar_cola_espera@i+1))^00h,c
	movlw	low(0)
	movwf	((c:quitar_cola_espera@i))^00h,c
	goto	l6179
	line	348
	
l6171:; BSR set to: 0

	movf	((c:quitar_cola_espera@i))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_cola_espera)
	movwf	fsr2l
	clrf	fsr2h
	movf	((c:quitar_cola_espera@e))^00h,c,w
xorwf	postinc2,w
	bnz	u8310
movf	((c:quitar_cola_espera@e+1))^00h,c,w
xorwf	postinc2,w
	btfsc	status,2
	goto	u8311
	goto	u8310

u8311:
	goto	l6177
u8310:
	
l6173:; BSR set to: 0

	movf	((c:quitar_cola_espera@i))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_cola_espera)
	movwf	fsr2l
	clrf	fsr2h
	movf	((c:quitar_cola_espera@j))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_cola_espera)
	movwf	fsr1l
	clrf	fsr1h
	movff	postinc2,postinc1
	movff	postdec2,postdec1
	
l6175:; BSR set to: 0

	infsnz	((c:quitar_cola_espera@j))^00h,c
	incf	((c:quitar_cola_espera@j+1))^00h,c
	line	349
	
l6177:; BSR set to: 0

	infsnz	((c:quitar_cola_espera@i))^00h,c
	incf	((c:quitar_cola_espera@i+1))^00h,c
	
l6179:
	movlb	0	; () banked
		movf	((_cola_esp_len))&0ffh,w
	subwf	((c:quitar_cola_espera@i))^00h,c,w
	movf	((c:quitar_cola_espera@i+1))^00h,c,w
	xorlw	80h
	movwf	(??_quitar_cola_espera+0)^00h,c
	movf	((_cola_esp_len+1))&0ffh,w
	xorlw	80h
	subwfb	(??_quitar_cola_espera+0)^00h,c,w
	btfss	status,0
	goto	u8321
	goto	u8320

u8321:
	goto	l6171
u8320:
	
l358:; BSR set to: 0

	line	350
	movff	(c:quitar_cola_espera@j),(_cola_esp_len)
	movff	(c:quitar_cola_espera@j+1),(_cola_esp_len+1)
	line	351
	
l6181:; BSR set to: 0

	btfsc	((c:quitar_cola_espera@j+1))^00h,c,7
	goto	u8331
	movf	((c:quitar_cola_espera@j+1))^00h,c,w
	bnz	u8330
	movlw	3
	subwf	 ((c:quitar_cola_espera@j))^00h,c,w
	btfss	status,0
	goto	u8331
	goto	u8330

u8331:
	goto	l6185
u8330:
	goto	l361
	
l6185:; BSR set to: 0

	movf	((c:quitar_cola_espera@j))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_cola_espera)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(-1)
	movwf	postinc2,c
	movlw	high(-1)
	movwf	postdec2,c
	
l6187:; BSR set to: 0

	infsnz	((c:quitar_cola_espera@j))^00h,c
	incf	((c:quitar_cola_espera@j+1))^00h,c
	goto	l6181
	line	352
	
l361:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_quitar_cola_espera
	__end_of_quitar_cola_espera:
	signat	_quitar_cola_espera,4217
	global	_UART_EmitEmg

;; *************** function _UART_EmitEmg *****************
;; Defined at:
;;		line 302 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  act             1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  act             1   30[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         3       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:         4       0       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		_UART_PutChar
;;		_UART_PutStr
;;		_UART_TxFree
;; This function is called by:
;;		_procesar_tecla
;; This function uses a non-reentrant model
;;
psect	text17,class=CODE,space=0,reloc=2,group=0
	line	302
global __ptext17
__ptext17:
psect	text17
	file	"LOGIC_TEST.c"
	line	302
	
_UART_EmitEmg:; BSR set to: 0

;incstack = 0
	callstack 26
	movwf	((c:UART_EmitEmg@act))^00h,c
	line	303
	
l6503:
	call	_UART_TxFree	;wreg free
	movwf	(??_UART_EmitEmg+0)^00h,c
		movlw	0Ah-0
	cpfslt	((??_UART_EmitEmg+0))^00h,c
	goto	u8931
	goto	u8930

u8931:
	goto	l6507
u8930:
	goto	l323
	line	304
	
l6507:; BSR set to: 0

		movlw	low(STR_9)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_9)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	305
	
l6509:
	movf	((c:UART_EmitEmg@act))^00h,c,w
	btfss	status,2
	goto	u8941
	goto	u8940
u8941:
	goto	l6513
u8940:
	
l6511:
	clrf	((c:_UART_EmitEmg$1033+1))^00h,c
	movlw	low(030h)
	movwf	((c:_UART_EmitEmg$1033))^00h,c
	goto	l6515
	
l6513:
	clrf	((c:_UART_EmitEmg$1033+1))^00h,c
	movlw	low(031h)
	movwf	((c:_UART_EmitEmg$1033))^00h,c
	
l6515:
	movf	((c:_UART_EmitEmg$1033))^00h,c,w
	
	call	_UART_PutChar
	line	306
	
l6517:; BSR set to: 0

		movlw	low(STR_10)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_10)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	307
	
l323:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_EmitEmg
	__end_of_UART_EmitEmg:
	signat	_UART_EmitEmg,4217
	global	_parse_2d

;; *************** function _parse_2d *****************
;; Defined at:
;;		line 873 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  s               1    5[COMRAM] PTR const unsigned char 
;;		 -> uart_rx(20), 
;; Auto vars:     Size  Location     Type
;;  v               2   10[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  2    5[COMRAM] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          3       0       0       0       0       0       0       0       0
;;      Totals:         7       0       0       0       0       0       0       0       0
;;Total ram usage:        7 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_UART_ProcessRx
;; This function uses a non-reentrant model
;;
psect	text18,class=CODE,space=0,reloc=2,group=0
	line	873
global __ptext18
__ptext18:
psect	text18
	file	"LOGIC_TEST.c"
	line	873
	
_parse_2d:
;incstack = 0
	callstack 28
	line	874
	
l7199:; BSR set to: 0

	clrf	((c:parse_2d@v+1))^00h,c
	movlw	low(0)
	movwf	((c:parse_2d@v))^00h,c
	line	875
	
l7201:; BSR set to: 0

	movf	((c:parse_2d@s))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
		movlw	030h-1
	cpfsgt	indf2
	goto	u10191
	goto	u10190

u10191:
	goto	l7211
u10190:
	
l7203:; BSR set to: 0

	movf	((c:parse_2d@s))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
		movlw	03Ah-0
	cpfslt	indf2
	goto	u10201
	goto	u10200

u10201:
	goto	l7211
u10200:
	line	876
	
l7205:; BSR set to: 0

	movf	((c:parse_2d@s))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
	movf	indf2,w
	movwf	(??_parse_2d+0)^00h,c
	movlw	low(0FFD0h)
	addwf	((??_parse_2d+0))^00h,c,w
	movwf	((c:parse_2d@v))^00h,c
	clrf	1+((c:parse_2d@v))^00h,c
	movlw	high(0FFD0h)
	addwfc	1+((c:parse_2d@v))^00h,c
	line	877
	movf	((c:parse_2d@s))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	addwf	fsr2l

		movlw	030h-1
	cpfsgt	indf2
	goto	u10211
	goto	u10210

u10211:
	goto	l7211
u10210:
	
l7207:; BSR set to: 0

	movf	((c:parse_2d@s))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	addwf	fsr2l

		movlw	03Ah-0
	cpfslt	indf2
	goto	u10221
	goto	u10220

u10221:
	goto	l7211
u10220:
	
l7209:; BSR set to: 0

	movlw	low(0Ah)
	mulwf	((c:parse_2d@v))^00h,c
	movff	prodl,??_parse_2d+0
	movff	prodh,??_parse_2d+0+1
	mulwf	((c:parse_2d@v+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_parse_2d+0+1)^00h,c,f
	movf	((c:parse_2d@s))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	addwf	fsr2l

	movf	indf2,w
	movwf	(??_parse_2d+2)^00h,c
	movf	((??_parse_2d+2))^00h,c,w
	addwf	(??_parse_2d+0)^00h,c
	movlw	0
	addwfc	(??_parse_2d+0+1)^00h,c
	movlw	low(-48)
	addwf	(??_parse_2d+0)^00h,c,w
	movwf	((c:parse_2d@v))^00h,c
	movlw	high(-48)
	addwfc	(??_parse_2d+0+1)^00h,c,w
	movwf	1+((c:parse_2d@v))^00h,c
	line	879
	
l7211:; BSR set to: 0

	movff	(c:parse_2d@v),(c:?_parse_2d)
	movff	(c:parse_2d@v+1),(c:?_parse_2d+1)
	line	880
	
l714:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_parse_2d
	__end_of_parse_2d:
	signat	_parse_2d,4218
	global	_llamar_pasillo

;; *************** function _llamar_pasillo *****************
;; Defined at:
;;		line 594 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  dir             2   82[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  fl              2    0[BANK0 ] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         0       2       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         2       2       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_beep
;;		_llamar_pasillo_piso
;;		_poner_msg
;; This function is called by:
;;		_UART_ProcessRx
;;		_main
;; This function uses a non-reentrant model
;;
psect	text19,class=CODE,space=0,reloc=2,group=0
	line	594
global __ptext19
__ptext19:
psect	text19
	file	"LOGIC_TEST.c"
	line	594
	
_llamar_pasillo:; BSR set to: 0

;incstack = 0
	callstack 28
	line	596
	
l6865:; BSR set to: 0

	movf	((c:_emergencia))^00h,c,w
	btfsc	status,2
	goto	u9571
	goto	u9570
u9571:
	goto	l6869
u9570:
	goto	l528
	line	597
	
l6869:; BSR set to: 0

		movlw	2
	xorwf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u9581
	goto	u9580

u9581:
	goto	l6873
u9580:
	
l6871:; BSR set to: 0

	movf	((_piso_usr))&0ffh,w
iorwf	((_piso_usr+1))&0ffh,w
	btfss	status,2
	goto	u9591
	goto	u9590

u9591:
	goto	l529
u9590:
	
l6873:; BSR set to: 0

		movlw	low(STR_19)
	movwf	((c:poner_msg@s))^00h,c
	movlw	high(STR_19)
	movwf	((c:poner_msg@s+1))^00h,c

	call	_poner_msg	;wreg free
	
l6875:; BSR set to: 1

	clrf	((c:beep@t+1))^00h,c
	movlw	low(0Ah)
	movwf	((c:beep@t))^00h,c
	call	_beep	;wreg free
	goto	l528
	
l529:; BSR set to: 0

	line	598
	movff	(_piso_usr),(llamar_pasillo@fl)
	movff	(_piso_usr+1),(llamar_pasillo@fl+1)
	
l6879:; BSR set to: 0

	clrf	((_piso_usr+1))&0ffh
	movlw	low(0)
	movwf	((_piso_usr))&0ffh
	clrf	((c:_modo+1))^00h,c
	movlw	low(0)
	movwf	((c:_modo))^00h,c
	line	599
	
l6881:; BSR set to: 0

	movff	(llamar_pasillo@fl),(c:llamar_pasillo_piso@fl)
	movff	(llamar_pasillo@fl+1),(c:llamar_pasillo_piso@fl+1)
	movff	(c:llamar_pasillo@dir),(c:llamar_pasillo_piso@dir)
	movff	(c:llamar_pasillo@dir+1),(c:llamar_pasillo_piso@dir+1)
	call	_llamar_pasillo_piso	;wreg free
	line	600
	
l528:
	return	;funcret
	callstack 0
GLOBAL	__end_of_llamar_pasillo
	__end_of_llamar_pasillo:
	signat	_llamar_pasillo,4217
	global	_llamar_pasillo_piso

;; *************** function _llamar_pasillo_piso *****************
;; Defined at:
;;		line 548 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  fl              2   53[COMRAM] int 
;;  dir             2   55[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  nueva           1   61[COMRAM] unsigned char 
;;  costos          6   70[COMRAM] int [3]
;;  mejor           2   80[COMRAM] int 
;;  e               2   78[COMRAM] int 
;;  best            2   62[COMRAM] int 
;;  bit             1   77[COMRAM] unsigned char 
;;  dir_c           1   76[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         4       0       0       0       0       0       0       0       0
;;      Locals:        21       0       0       0       0       0       0       0       0
;;      Temps:          4       0       0       0       0       0       0       0       0
;;      Totals:        29       0       0       0       0       0       0       0       0
;;Total ram usage:       29 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_UART_EmitDsp
;;		_UART_EmitEnq
;;		_UART_EnviarEstado
;;		_agregar_cola_espera
;;		_beep
;;		_costo_elevador
;;		_msg_elev
;;		_siguiente_objetivo
;; This function is called by:
;;		_llamar_pasillo
;;		_UART_ProcessRx
;; This function uses a non-reentrant model
;;
psect	text20,class=CODE,space=0,reloc=2,group=0
	line	548
global __ptext20
__ptext20:
psect	text20
	file	"LOGIC_TEST.c"
	line	548
	
_llamar_pasillo_piso:
;incstack = 0
	callstack 27
	line	549
	
l6557:; BSR set to: 0

	clrf	((c:llamar_pasillo_piso@mejor+1))^00h,c
	movlw	low(0)
	movwf	((c:llamar_pasillo_piso@mejor))^00h,c
	movlw	high(07530h)
	movwf	((c:llamar_pasillo_piso@best+1))^00h,c
	movlw	low(07530h)
	movwf	((c:llamar_pasillo_piso@best))^00h,c
	line	551
	
l6559:; BSR set to: 0

		decf	((c:llamar_pasillo_piso@dir))^00h,c,w
iorwf	((c:llamar_pasillo_piso@dir+1))^00h,c,w
	btfsc	status,2
	goto	u9021
	goto	u9020

u9021:
	goto	l6563
u9020:
	
l6561:; BSR set to: 0

	clrf	((c:_llamar_pasillo_piso$1111+1))^00h,c
	movlw	low(02h)
	movwf	((c:_llamar_pasillo_piso$1111))^00h,c
	goto	l6565
	
l6563:; BSR set to: 0

	clrf	((c:_llamar_pasillo_piso$1111+1))^00h,c
	movlw	low(01h)
	movwf	((c:_llamar_pasillo_piso$1111))^00h,c
	
l6565:; BSR set to: 0

	movff	(c:_llamar_pasillo_piso$1111),(c:llamar_pasillo_piso@bit)
	line	552
	
l6567:; BSR set to: 0

		decf	((c:llamar_pasillo_piso@dir))^00h,c,w
iorwf	((c:llamar_pasillo_piso@dir+1))^00h,c,w
	btfsc	status,2
	goto	u9031
	goto	u9030

u9031:
	goto	l6571
u9030:
	
l6569:; BSR set to: 0

	clrf	((c:_llamar_pasillo_piso$1113+1))^00h,c
	movlw	low(044h)
	movwf	((c:_llamar_pasillo_piso$1113))^00h,c
	goto	l6573
	
l6571:; BSR set to: 0

	clrf	((c:_llamar_pasillo_piso$1113+1))^00h,c
	movlw	low(055h)
	movwf	((c:_llamar_pasillo_piso$1113))^00h,c
	
l6573:; BSR set to: 0

	movff	(c:_llamar_pasillo_piso$1113),(c:llamar_pasillo_piso@dir_c)
	line	554
	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u9041
	goto	u9040
u9041:
	goto	l509
u9040:
	
l6575:; BSR set to: 0

	btfsc	((c:llamar_pasillo_piso@fl+1))^00h,c,7
	goto	u9051
	movf	((c:llamar_pasillo_piso@fl+1))^00h,c,w
	bnz	u9050
	decf	((c:llamar_pasillo_piso@fl))^00h,c,w
	btfss	status,0
	goto	u9051
	goto	u9050

u9051:
	goto	l509
u9050:
	
l6577:; BSR set to: 0

		movf	((c:llamar_pasillo_piso@fl))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_llamar_pasillo_piso+0)^00h,c
	movf	((c:llamar_pasillo_piso@fl+1))^00h,c,w
	xorlw	80h
	subwfb	(??_llamar_pasillo_piso+0)^00h,c,w
	btfsc	status,0
	goto	u9061
	goto	u9060

u9061:
	goto	l6579
u9060:
	goto	l509
	line	557
	
l6579:; BSR set to: 0

	clrf	((c:llamar_pasillo_piso@e+1))^00h,c
	movlw	low(0)
	movwf	((c:llamar_pasillo_piso@e))^00h,c
	line	558
	
l6585:
	movff	(c:llamar_pasillo_piso@e),(c:costo_elevador@e)
	movff	(c:llamar_pasillo_piso@e+1),(c:costo_elevador@e+1)
	movff	(c:llamar_pasillo_piso@fl),(c:costo_elevador@p_usr)
	movff	(c:llamar_pasillo_piso@fl+1),(c:costo_elevador@p_usr+1)
	movff	(c:llamar_pasillo_piso@dir),(c:costo_elevador@dir)
	movff	(c:llamar_pasillo_piso@dir+1),(c:costo_elevador@dir+1)
	call	_costo_elevador	;wreg free
	movf	((c:llamar_pasillo_piso@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(llamar_pasillo_piso@costos)
	movwf	fsr2l
	clrf	fsr2h
	movff	0+?_costo_elevador,postinc2
	movff	1+?_costo_elevador,postdec2

	line	559
	
l6587:
	movf	((c:llamar_pasillo_piso@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(llamar_pasillo_piso@costos)
	movwf	fsr2l
	clrf	fsr2h
		movf	((c:llamar_pasillo_piso@best))^00h,c,w
	subwf	postinc2,w
	movf	postinc2,w
	xorlw	80h
	movwf	(??_llamar_pasillo_piso+2)^00h,c
	movf	((c:llamar_pasillo_piso@best+1))^00h,c,w
	xorlw	80h
	subwfb	(??_llamar_pasillo_piso+2)^00h,c,w
	btfsc	status,0
	goto	u9071
	goto	u9070

u9071:
	goto	l6593
u9070:
	
l6589:
	movf	((c:llamar_pasillo_piso@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(llamar_pasillo_piso@costos)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:llamar_pasillo_piso@best)
	movff	postdec2,(c:llamar_pasillo_piso@best+1)
	
l6591:
	movff	(c:llamar_pasillo_piso@e),(c:llamar_pasillo_piso@mejor)
	movff	(c:llamar_pasillo_piso@e+1),(c:llamar_pasillo_piso@mejor+1)
	line	560
	
l6593:
	infsnz	((c:llamar_pasillo_piso@e))^00h,c
	incf	((c:llamar_pasillo_piso@e+1))^00h,c
	
l6595:
	btfsc	((c:llamar_pasillo_piso@e+1))^00h,c,7
	goto	u9081
	movf	((c:llamar_pasillo_piso@e+1))^00h,c,w
	bnz	u9080
	movlw	3
	subwf	 ((c:llamar_pasillo_piso@e))^00h,c,w
	btfss	status,0
	goto	u9081
	goto	u9080

u9081:
	goto	l6585
u9080:
	line	563
	
l6597:
	clrf	((c:llamar_pasillo_piso@e+1))^00h,c
	movlw	low(0)
	movwf	((c:llamar_pasillo_piso@e))^00h,c
	line	564
	
l6603:
	movlw	low(015h)
	mulwf	((c:llamar_pasillo_piso@e))^00h,c
	movff	prodl,??_llamar_pasillo_piso+0
	movff	prodh,??_llamar_pasillo_piso+0+1
	mulwf	((c:llamar_pasillo_piso@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_llamar_pasillo_piso+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_llamar_pasillo_piso+0)^00h,c,w
	movwf	(??_llamar_pasillo_piso+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_llamar_pasillo_piso+0+1)^00h,c,w
	movwf	1+(??_llamar_pasillo_piso+2)^00h,c
	movf	((c:llamar_pasillo_piso@fl))^00h,c,w
	addwf	(??_llamar_pasillo_piso+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:llamar_pasillo_piso@fl+1))^00h,c,w
	addwfc	(??_llamar_pasillo_piso+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	andwf	((c:llamar_pasillo_piso@bit))^00h,c,w
	iorlw	0
	btfsc	status,2
	goto	u9091
	goto	u9090
u9091:
	goto	l6607
u9090:
	line	565
	
l6605:
	movff	(c:llamar_pasillo_piso@e),(c:llamar_pasillo_piso@mejor)
	movff	(c:llamar_pasillo_piso@e+1),(c:llamar_pasillo_piso@mejor+1)
	line	566
	goto	l514
	line	568
	
l6607:
	infsnz	((c:llamar_pasillo_piso@e))^00h,c
	incf	((c:llamar_pasillo_piso@e+1))^00h,c
	
l6609:
	btfsc	((c:llamar_pasillo_piso@e+1))^00h,c,7
	goto	u9101
	movf	((c:llamar_pasillo_piso@e+1))^00h,c,w
	bnz	u9100
	movlw	3
	subwf	 ((c:llamar_pasillo_piso@e))^00h,c,w
	btfss	status,0
	goto	u9101
	goto	u9100

u9101:
	goto	l6603
u9100:
	
l514:
	line	570
	movff	(c:llamar_pasillo_piso@mejor),(_elev_activo)
	movff	(c:llamar_pasillo_piso@mejor+1),(_elev_activo+1)
	line	571
	
l6611:
	clrf	((c:beep@t+1))^00h,c
	movlw	low(08h)
	movwf	((c:beep@t))^00h,c
	call	_beep	;wreg free
	line	572
	
l6613:
	movff	(c:llamar_pasillo_piso@fl),(c:UART_EmitDsp@fl)
	movff	(c:llamar_pasillo_piso@fl+1),(c:UART_EmitDsp@fl+1)
	movff	(c:llamar_pasillo_piso@dir_c),(c:UART_EmitDsp@dir_c)
	movff	(c:llamar_pasillo_piso@mejor),(c:UART_EmitDsp@chosen)
	movff	(c:llamar_pasillo_piso@mejor+1),(c:UART_EmitDsp@chosen+1)
	movff	(c:llamar_pasillo_piso@costos),(c:UART_EmitDsp@c0)
	movff	(c:llamar_pasillo_piso@costos+1),(c:UART_EmitDsp@c0+1)
	movff	0+((c:llamar_pasillo_piso@costos)+02h),(c:UART_EmitDsp@c1)
	movff	1+((c:llamar_pasillo_piso@costos)+02h),(c:UART_EmitDsp@c1+1)
	movff	0+((c:llamar_pasillo_piso@costos)+04h),(c:UART_EmitDsp@c2)
	movff	1+((c:llamar_pasillo_piso@costos)+04h),(c:UART_EmitDsp@c2+1)
	call	_UART_EmitDsp	;wreg free
	line	574
	
l6615:
	movf	((c:llamar_pasillo_piso@mejor))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movf	((c:llamar_pasillo_piso@fl))^00h,c,w
xorwf	postinc2,w
	bnz	u9111
movf	((c:llamar_pasillo_piso@fl+1))^00h,c,w
xorwf	postinc2,w
	btfss	status,2
	goto	u9111
	goto	u9110

u9111:
	goto	l6625
u9110:
	
l6617:
	movf	((c:llamar_pasillo_piso@mejor))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfsc	status,2
	goto	u9121
	goto	u9120

u9121:
	goto	l6625
u9120:
	line	575
	
l6619:
	movf	((c:llamar_pasillo_piso@mejor))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(02h)
	movwf	postinc2,c
	movlw	high(02h)
	movwf	postdec2,c
	line	576
	movf	((c:llamar_pasillo_piso@mejor))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	577
	movf	((c:llamar_pasillo_piso@mejor))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	578
	
l6621:
	movff	(c:llamar_pasillo_piso@mejor),(c:agregar_cola_espera@e)
	movff	(c:llamar_pasillo_piso@mejor+1),(c:agregar_cola_espera@e+1)
	call	_agregar_cola_espera	;wreg free
	line	579
	
l6623:; BSR set to: 0

	movff	(c:llamar_pasillo_piso@mejor),(c:msg_elev@e)
	movff	(c:llamar_pasillo_piso@mejor+1),(c:msg_elev@e+1)
		movlw	low(STR_16)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_16)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(04h)
	movwf	((c:msg_elev@pos_num))^00h,c
	movff	(c:llamar_pasillo_piso@fl),(c:msg_elev@num)
	movff	(c:llamar_pasillo_piso@fl+1),(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	line	580
	goto	l6645
	line	581
	
l6625:
	movlw	low(015h)
	mulwf	((c:llamar_pasillo_piso@mejor))^00h,c
	movff	prodl,??_llamar_pasillo_piso+0
	movff	prodh,??_llamar_pasillo_piso+0+1
	mulwf	((c:llamar_pasillo_piso@mejor+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_llamar_pasillo_piso+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_llamar_pasillo_piso+0)^00h,c,w
	movwf	(??_llamar_pasillo_piso+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_llamar_pasillo_piso+0+1)^00h,c,w
	movwf	1+(??_llamar_pasillo_piso+2)^00h,c
	movf	((c:llamar_pasillo_piso@fl))^00h,c,w
	addwf	(??_llamar_pasillo_piso+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:llamar_pasillo_piso@fl+1))^00h,c,w
	addwfc	(??_llamar_pasillo_piso+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	andwf	((c:llamar_pasillo_piso@bit))^00h,c,w
	iorlw	0
	btfsc	status,2
	goto	u9131
	goto	u9130
u9131:
	movlw	1
	goto	u9140
u9130:
	movlw	0
u9140:
	movwf	((c:llamar_pasillo_piso@nueva))^00h,c
	line	582
	movlw	low(015h)
	mulwf	((c:llamar_pasillo_piso@mejor))^00h,c
	movff	prodl,??_llamar_pasillo_piso+0
	movff	prodh,??_llamar_pasillo_piso+0+1
	mulwf	((c:llamar_pasillo_piso@mejor+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_llamar_pasillo_piso+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_llamar_pasillo_piso+0)^00h,c,w
	movwf	(??_llamar_pasillo_piso+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_llamar_pasillo_piso+0+1)^00h,c,w
	movwf	1+(??_llamar_pasillo_piso+2)^00h,c
	movf	((c:llamar_pasillo_piso@fl))^00h,c,w
	addwf	(??_llamar_pasillo_piso+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:llamar_pasillo_piso@fl+1))^00h,c,w
	addwfc	(??_llamar_pasillo_piso+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	((c:llamar_pasillo_piso@bit))^00h,c,w
	iorwf	indf2
	line	583
	
l6627:
	movf	((c:llamar_pasillo_piso@nueva))^00h,c,w
	btfsc	status,2
	goto	u9151
	goto	u9150
u9151:
	goto	l6631
u9150:
	
l6629:
	movff	(c:llamar_pasillo_piso@mejor),(c:UART_EmitEnq@e)
	movff	(c:llamar_pasillo_piso@mejor+1),(c:UART_EmitEnq@e+1)
	movff	(c:llamar_pasillo_piso@fl),(c:UART_EmitEnq@fl)
	movff	(c:llamar_pasillo_piso@fl+1),(c:UART_EmitEnq@fl+1)
	movff	(c:llamar_pasillo_piso@dir_c),(c:UART_EmitEnq@tipo)
	call	_UART_EmitEnq	;wreg free
	line	584
	
l6631:
	movf	((c:llamar_pasillo_piso@mejor))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u9161
	goto	u9160

u9161:
	goto	l519
u9160:
	line	585
	
l6633:
	movf	((c:llamar_pasillo_piso@mejor))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	movwf	postinc2,c
	movlw	high(01h)
	movwf	postdec2,c
	line	586
	movf	((c:llamar_pasillo_piso@mejor))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_piso)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	587
	
l519:
	line	588
	movf	((c:llamar_pasillo_piso@mejor))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u9171
	goto	u9170

u9171:
	goto	l6637
u9170:
	
l6635:
	movff	(c:llamar_pasillo_piso@mejor),(c:siguiente_objetivo@e)
	movff	(c:llamar_pasillo_piso@mejor+1),(c:siguiente_objetivo@e+1)
	call	_siguiente_objetivo	;wreg free
	line	589
	
l6637:
		decf	((c:llamar_pasillo_piso@dir))^00h,c,w
iorwf	((c:llamar_pasillo_piso@dir+1))^00h,c,w
	btfsc	status,2
	goto	u9181
	goto	u9180

u9181:
	goto	l6641
u9180:
	
l6639:
		movlw	low(STR_18)
	movwf	((c:_llamar_pasillo_piso$1123))^00h,c
	movlw	high(STR_18)
	movwf	((c:_llamar_pasillo_piso$1123+1))^00h,c

	goto	l6643
	
l6641:
		movlw	low(STR_17)
	movwf	((c:_llamar_pasillo_piso$1123))^00h,c
	movlw	high(STR_17)
	movwf	((c:_llamar_pasillo_piso$1123+1))^00h,c

	
l6643:
	movff	(c:llamar_pasillo_piso@mejor),(c:msg_elev@e)
	movff	(c:llamar_pasillo_piso@mejor+1),(c:msg_elev@e+1)
		movff	(c:_llamar_pasillo_piso$1123),(c:msg_elev@plantilla)
	movff	(c:_llamar_pasillo_piso$1123+1),(c:msg_elev@plantilla+1)

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(05h)
	movwf	((c:msg_elev@pos_num))^00h,c
	movff	(c:llamar_pasillo_piso@fl),(c:msg_elev@num)
	movff	(c:llamar_pasillo_piso@fl+1),(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	line	591
	
l6645:; BSR set to: 1

	call	_UART_EnviarEstado	;wreg free
	line	592
	
l509:
	return	;funcret
	callstack 0
GLOBAL	__end_of_llamar_pasillo_piso
	__end_of_llamar_pasillo_piso:
	signat	_llamar_pasillo_piso,8313
	global	_costo_elevador

;; *************** function _costo_elevador *****************
;; Defined at:
;;		line 443 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2   15[COMRAM] int 
;;  p_usr           2   17[COMRAM] int 
;;  dir             2   19[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  p               2   45[COMRAM] int 
;;  inter           2   43[COMRAM] int 
;;  lejano          2   41[COMRAM] int 
;;  carga           2   39[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  2   15[COMRAM] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         6       0       0       0       0       0       0       0       0
;;      Locals:         8       0       0       0       0       0       0       0       0
;;      Temps:         18       0       0       0       0       0       0       0       0
;;      Totals:        32       0       0       0       0       0       0       0       0
;;Total ram usage:       32 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		_contar_paradas
;;		_vabs
;; This function is called by:
;;		_llamar_pasillo_piso
;; This function uses a non-reentrant model
;;
psect	text21,class=CODE,space=0,reloc=2,group=0
	line	443
global __ptext21
__ptext21:
psect	text21
	file	"LOGIC_TEST.c"
	line	443
	
_costo_elevador:
;incstack = 0
	callstack 25
	line	444
	
l6321:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:costo_elevador@lejano)
	movff	postdec2,(c:costo_elevador@lejano+1)
	
l6323:
	clrf	((c:costo_elevador@inter+1))^00h,c
	movlw	low(0)
	movwf	((c:costo_elevador@inter))^00h,c
	line	445
	
l6325:
	movff	(c:costo_elevador@e),(c:contar_paradas@e)
	movff	(c:costo_elevador@e+1),(c:contar_paradas@e+1)
	call	_contar_paradas	;wreg free
	movff	0+?_contar_paradas,(c:costo_elevador@carga)
	movff	1+?_contar_paradas,(c:costo_elevador@carga+1)
	line	447
	
l6327:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8601
	goto	u8600

u8601:
	goto	l6333
u8600:
	line	448
	
l6329:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_costo_elevador+0
	movff	postdec2,??_costo_elevador+0+1
	movf	((c:costo_elevador@p_usr))^00h,c,w
	subwf	(??_costo_elevador+0)^00h,c,w
	movwf	((c:vabs@x))^00h,c
	movf	((c:costo_elevador@p_usr+1))^00h,c,w
	subwfb	(??_costo_elevador+0+1)^00h,c,w
	movwf	1+((c:vabs@x))^00h,c
	call	_vabs	;wreg free
	movlw	low(0Ah)
	mulwf	(0+?_vabs)^00h,c
	movff	prodl,??_costo_elevador+2
	movff	prodh,??_costo_elevador+2+1
	mulwf	(1+?_vabs)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+2+1)^00h,c,f
	movff	??_costo_elevador+2,(c:?_costo_elevador)
	movff	??_costo_elevador+2+1,(c:?_costo_elevador+1)
	goto	l443
	line	450
	
l6333:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8611
	goto	u8610

u8611:
	goto	l6407
u8610:
	line	451
	
l6335:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8621
	goto	u8620

u8621:
	goto	l6367
u8620:
	line	452
	
l6337:
		decf	((c:costo_elevador@dir))^00h,c,w
iorwf	((c:costo_elevador@dir+1))^00h,c,w
	btfss	status,2
	goto	u8631
	goto	u8630

u8631:
	goto	l6353
u8630:
	
l6339:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
		movf	((c:costo_elevador@p_usr))^00h,c,w
	subwf	postinc2,w
	movf	postinc2,w
	xorlw	80h
	movwf	(??_costo_elevador+2)^00h,c
	movf	((c:costo_elevador@p_usr+1))^00h,c,w
	xorlw	80h
	subwfb	(??_costo_elevador+2)^00h,c,w
	btfsc	status,0
	goto	u8641
	goto	u8640

u8641:
	goto	l6353
u8640:
	line	453
	
l6341:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_costo_elevador+0
	movff	postdec2,??_costo_elevador+0+1
	movlw	low(01h)
	addwf	(??_costo_elevador+0)^00h,c,w
	movwf	((c:costo_elevador@p))^00h,c
	movlw	high(01h)
	addwfc	(??_costo_elevador+0+1)^00h,c,w
	movwf	1+((c:costo_elevador@p))^00h,c
	goto	l6347
	
l6343:
	movlw	low(015h)
	mulwf	((c:costo_elevador@e))^00h,c
	movff	prodl,??_costo_elevador+0
	movff	prodh,??_costo_elevador+0+1
	mulwf	((c:costo_elevador@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_costo_elevador+0)^00h,c,w
	movwf	(??_costo_elevador+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_costo_elevador+0+1)^00h,c,w
	movwf	1+(??_costo_elevador+2)^00h,c
	movf	((c:costo_elevador@p))^00h,c,w
	addwf	(??_costo_elevador+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:costo_elevador@p+1))^00h,c,w
	addwfc	(??_costo_elevador+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u8651
	goto	u8650
u8651:
	goto	l449
u8650:
	
l6345:
	infsnz	((c:costo_elevador@inter))^00h,c
	incf	((c:costo_elevador@inter+1))^00h,c
	
l449:
	infsnz	((c:costo_elevador@p))^00h,c
	incf	((c:costo_elevador@p+1))^00h,c
	
l6347:
		movf	((c:costo_elevador@p_usr))^00h,c,w
	subwf	((c:costo_elevador@p))^00h,c,w
	movf	((c:costo_elevador@p+1))^00h,c,w
	xorlw	80h
	movwf	(??_costo_elevador+0)^00h,c
	movf	((c:costo_elevador@p_usr+1))^00h,c,w
	xorlw	80h
	subwfb	(??_costo_elevador+0)^00h,c,w
	btfss	status,0
	goto	u8661
	goto	u8660

u8661:
	goto	l6343
u8660:
	line	454
	
l6349:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_costo_elevador+0
	movff	postdec2,??_costo_elevador+0+1
	movlw	low(-10)
	mulwf	(??_costo_elevador+0)^00h,c
	movff	prodl,??_costo_elevador+2
	movff	prodh,??_costo_elevador+2+1
	mulwf	(??_costo_elevador+0+1)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+2+1)^00h,c,f
	movlw	high(-10)
	mulwf	(??_costo_elevador+0)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+2+1)^00h,c,f
	movlw	low(05h)
	mulwf	((c:costo_elevador@inter))^00h,c
	movff	prodl,??_costo_elevador+4
	movff	prodh,??_costo_elevador+4+1
	mulwf	((c:costo_elevador@inter+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+4+1)^00h,c,f
	movlw	low(0Ah)
	mulwf	((c:costo_elevador@p_usr))^00h,c
	movff	prodl,??_costo_elevador+6
	movff	prodh,??_costo_elevador+6+1
	mulwf	((c:costo_elevador@p_usr+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+6+1)^00h,c,f
	movf	(??_costo_elevador+4)^00h,c,w
	addwf	(??_costo_elevador+6)^00h,c,w
	movwf	(??_costo_elevador+8)^00h,c
	movf	(??_costo_elevador+4+1)^00h,c,w
	addwfc	(??_costo_elevador+6+1)^00h,c,w
	movwf	1+(??_costo_elevador+8)^00h,c
	movf	(??_costo_elevador+2)^00h,c,w
	addwf	(??_costo_elevador+8)^00h,c,w
	movwf	((c:?_costo_elevador))^00h,c
	movf	(??_costo_elevador+2+1)^00h,c,w
	addwfc	(??_costo_elevador+8+1)^00h,c,w
	movwf	1+((c:?_costo_elevador))^00h,c
	goto	l443
	line	456
	
l6353:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:costo_elevador@p)
	movff	postdec2,(c:costo_elevador@p+1)
	goto	l6361
	line	457
	
l6355:
	movlw	low(015h)
	mulwf	((c:costo_elevador@e))^00h,c
	movff	prodl,??_costo_elevador+0
	movff	prodh,??_costo_elevador+0+1
	mulwf	((c:costo_elevador@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_costo_elevador+0)^00h,c,w
	movwf	(??_costo_elevador+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_costo_elevador+0+1)^00h,c,w
	movwf	1+(??_costo_elevador+2)^00h,c
	movf	((c:costo_elevador@p))^00h,c,w
	addwf	(??_costo_elevador+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:costo_elevador@p+1))^00h,c,w
	addwfc	(??_costo_elevador+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u8671
	goto	u8670
u8671:
	goto	l453
u8670:
	
l6357:
	movff	(c:costo_elevador@p),(c:costo_elevador@lejano)
	movff	(c:costo_elevador@p+1),(c:costo_elevador@lejano+1)
	
l6359:
	infsnz	((c:costo_elevador@inter))^00h,c
	incf	((c:costo_elevador@inter+1))^00h,c
	
l453:
	line	458
	infsnz	((c:costo_elevador@p))^00h,c
	incf	((c:costo_elevador@p+1))^00h,c
	
l6361:
		movf	((c:costo_elevador@p))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_costo_elevador+0)^00h,c
	movf	((c:costo_elevador@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_costo_elevador+0)^00h,c,w
	btfsc	status,0
	goto	u8681
	goto	u8680

u8681:
	goto	l6355
u8680:
	line	459
	
l6363:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_costo_elevador+0
	movff	postdec2,??_costo_elevador+0+1
	movlw	low(-10)
	mulwf	(??_costo_elevador+0)^00h,c
	movff	prodl,??_costo_elevador+2
	movff	prodh,??_costo_elevador+2+1
	mulwf	(??_costo_elevador+0+1)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+2+1)^00h,c,f
	movlw	high(-10)
	mulwf	(??_costo_elevador+0)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+2+1)^00h,c,f
	movff	(c:costo_elevador@inter),??_costo_elevador+4
	movff	(c:costo_elevador@inter+1),??_costo_elevador+4+1
	bcf	status,0
	rlcf	(??_costo_elevador+4)^00h,c
	rlcf	(??_costo_elevador+4+1)^00h,c
	bcf	status,0
	rlcf	(??_costo_elevador+4)^00h,c
	rlcf	(??_costo_elevador+4+1)^00h,c
	bcf	status,0
	rlcf	(??_costo_elevador+4)^00h,c
	rlcf	(??_costo_elevador+4+1)^00h,c
	movf	((c:costo_elevador@p_usr))^00h,c,w
	subwf	((c:costo_elevador@lejano))^00h,c,w
	movwf	((c:vabs@x))^00h,c
	movf	((c:costo_elevador@p_usr+1))^00h,c,w
	subwfb	((c:costo_elevador@lejano+1))^00h,c,w
	movwf	1+((c:vabs@x))^00h,c
	call	_vabs	;wreg free
	movlw	low(0Ah)
	mulwf	(0+?_vabs)^00h,c
	movff	prodl,??_costo_elevador+6
	movff	prodh,??_costo_elevador+6+1
	mulwf	(1+?_vabs)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+6+1)^00h,c,f
	movlw	low(0Ah)
	mulwf	((c:costo_elevador@lejano))^00h,c
	movff	prodl,??_costo_elevador+8
	movff	prodh,??_costo_elevador+8+1
	mulwf	((c:costo_elevador@lejano+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+8+1)^00h,c,f
	movf	(??_costo_elevador+6)^00h,c,w
	addwf	(??_costo_elevador+8)^00h,c,w
	movwf	(??_costo_elevador+10)^00h,c
	movf	(??_costo_elevador+6+1)^00h,c,w
	addwfc	(??_costo_elevador+8+1)^00h,c,w
	movwf	1+(??_costo_elevador+10)^00h,c
	movf	(??_costo_elevador+4)^00h,c,w
	addwf	(??_costo_elevador+10)^00h,c,w
	movwf	(??_costo_elevador+12)^00h,c
	movf	(??_costo_elevador+4+1)^00h,c,w
	addwfc	(??_costo_elevador+10+1)^00h,c,w
	movwf	1+(??_costo_elevador+12)^00h,c
	movf	(??_costo_elevador+2)^00h,c,w
	addwf	(??_costo_elevador+12)^00h,c,w
	movwf	(??_costo_elevador+14)^00h,c
	movf	(??_costo_elevador+2+1)^00h,c,w
	addwfc	(??_costo_elevador+12+1)^00h,c,w
	movwf	1+(??_costo_elevador+14)^00h,c
	movlw	low(0Ah)
	addwf	(??_costo_elevador+14)^00h,c,w
	movwf	((c:?_costo_elevador))^00h,c
	movlw	high(0Ah)
	addwfc	(??_costo_elevador+14+1)^00h,c,w
	movwf	1+((c:?_costo_elevador))^00h,c
	goto	l443
	line	461
	
l6367:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movlw	2
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8691
	goto	u8690

u8691:
	goto	l6403
u8690:
	line	462
	
l6369:
		movlw	2
	xorwf	((c:costo_elevador@dir))^00h,c,w
iorwf	((c:costo_elevador@dir+1))^00h,c,w
	btfss	status,2
	goto	u8701
	goto	u8700

u8701:
	goto	l6385
u8700:
	
l6371:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
		movf	postinc2,w
	subwf	((c:costo_elevador@p_usr))^00h,c,w
	movf	((c:costo_elevador@p_usr+1))^00h,c,w
	xorlw	80h
	movwf	(??_costo_elevador+2)^00h,c
	movf	postinc2,w
	xorlw	80h
	subwfb	(??_costo_elevador+2)^00h,c,w
	btfsc	status,0
	goto	u8711
	goto	u8710

u8711:
	goto	l6385
u8710:
	line	463
	
l6373:
	movlw	low(01h)
	addwf	((c:costo_elevador@p_usr))^00h,c,w
	movwf	((c:costo_elevador@p))^00h,c
	movlw	high(01h)
	addwfc	((c:costo_elevador@p_usr+1))^00h,c,w
	movwf	1+((c:costo_elevador@p))^00h,c
	goto	l6379
	
l6375:
	movlw	low(015h)
	mulwf	((c:costo_elevador@e))^00h,c
	movff	prodl,??_costo_elevador+0
	movff	prodh,??_costo_elevador+0+1
	mulwf	((c:costo_elevador@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_costo_elevador+0)^00h,c,w
	movwf	(??_costo_elevador+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_costo_elevador+0+1)^00h,c,w
	movwf	1+(??_costo_elevador+2)^00h,c
	movf	((c:costo_elevador@p))^00h,c,w
	addwf	(??_costo_elevador+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:costo_elevador@p+1))^00h,c,w
	addwfc	(??_costo_elevador+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u8721
	goto	u8720
u8721:
	goto	l459
u8720:
	
l6377:
	infsnz	((c:costo_elevador@inter))^00h,c
	incf	((c:costo_elevador@inter+1))^00h,c
	
l459:
	infsnz	((c:costo_elevador@p))^00h,c
	incf	((c:costo_elevador@p+1))^00h,c
	
l6379:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
		movf	postinc2,w
	subwf	((c:costo_elevador@p))^00h,c,w
	movf	((c:costo_elevador@p+1))^00h,c,w
	xorlw	80h
	movwf	(??_costo_elevador+2)^00h,c
	movf	postinc2,w
	xorlw	80h
	subwfb	(??_costo_elevador+2)^00h,c,w
	btfss	status,0
	goto	u8731
	goto	u8730

u8731:
	goto	l6375
u8730:
	line	464
	
l6381:
	movlw	low(-10)
	movwf	(??_costo_elevador+0)^00h,c
	movlw	high(-10)
	movwf	1+(??_costo_elevador+0)^00h,c
	movf	(??_costo_elevador+0)^00h,c,w
	mulwf	((c:costo_elevador@p_usr))^00h,c
	movff	prodl,??_costo_elevador+2
	movff	prodh,??_costo_elevador+2+1
	mulwf	((c:costo_elevador@p_usr+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+2+1)^00h,c,f
	movf	(??_costo_elevador+0+1)^00h,c,w
	mulwf	((c:costo_elevador@p_usr))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+2+1)^00h,c,f
	movlw	low(05h)
	mulwf	((c:costo_elevador@inter))^00h,c
	movff	prodl,??_costo_elevador+4
	movff	prodh,??_costo_elevador+4+1
	mulwf	((c:costo_elevador@inter+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+4+1)^00h,c,f
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_costo_elevador+6
	movff	postdec2,??_costo_elevador+6+1
	movlw	low(0Ah)
	mulwf	(??_costo_elevador+6)^00h,c
	movff	prodl,??_costo_elevador+8
	movff	prodh,??_costo_elevador+8+1
	mulwf	(??_costo_elevador+6+1)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+8+1)^00h,c,f
	movf	(??_costo_elevador+4)^00h,c,w
	addwf	(??_costo_elevador+8)^00h,c,w
	movwf	(??_costo_elevador+10)^00h,c
	movf	(??_costo_elevador+4+1)^00h,c,w
	addwfc	(??_costo_elevador+8+1)^00h,c,w
	movwf	1+(??_costo_elevador+10)^00h,c
	movf	(??_costo_elevador+2)^00h,c,w
	addwf	(??_costo_elevador+10)^00h,c,w
	movwf	((c:?_costo_elevador))^00h,c
	movf	(??_costo_elevador+2+1)^00h,c,w
	addwfc	(??_costo_elevador+10+1)^00h,c,w
	movwf	1+((c:?_costo_elevador))^00h,c
	goto	l443
	line	466
	
l6385:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:costo_elevador@p)
	movff	postdec2,(c:costo_elevador@p+1)
	
l6387:
	btfsc	((c:costo_elevador@p+1))^00h,c,7
	goto	u8740
	movf	((c:costo_elevador@p+1))^00h,c,w
	bnz	u8741
	decf	((c:costo_elevador@p))^00h,c,w
	btfsc	status,0
	goto	u8741
	goto	u8740

u8741:
	goto	l6391
u8740:
	goto	l6399
	line	467
	
l6391:
	movlw	low(015h)
	mulwf	((c:costo_elevador@e))^00h,c
	movff	prodl,??_costo_elevador+0
	movff	prodh,??_costo_elevador+0+1
	mulwf	((c:costo_elevador@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_costo_elevador+0)^00h,c,w
	movwf	(??_costo_elevador+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_costo_elevador+0+1)^00h,c,w
	movwf	1+(??_costo_elevador+2)^00h,c
	movf	((c:costo_elevador@p))^00h,c,w
	addwf	(??_costo_elevador+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:costo_elevador@p+1))^00h,c,w
	addwfc	(??_costo_elevador+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u8751
	goto	u8750
u8751:
	goto	l463
u8750:
	
l6393:
	movff	(c:costo_elevador@p),(c:costo_elevador@lejano)
	movff	(c:costo_elevador@p+1),(c:costo_elevador@lejano+1)
	
l6395:
	infsnz	((c:costo_elevador@inter))^00h,c
	incf	((c:costo_elevador@inter+1))^00h,c
	
l463:
	line	468
	decf	((c:costo_elevador@p))^00h,c
	btfss	status,0
	decf	((c:costo_elevador@p+1))^00h,c
	goto	l6387
	line	469
	
l6399:
	movlw	low(-10)
	movwf	(??_costo_elevador+0)^00h,c
	movlw	high(-10)
	movwf	1+(??_costo_elevador+0)^00h,c
	movf	(??_costo_elevador+0)^00h,c,w
	mulwf	((c:costo_elevador@lejano))^00h,c
	movff	prodl,??_costo_elevador+2
	movff	prodh,??_costo_elevador+2+1
	mulwf	((c:costo_elevador@lejano+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+2+1)^00h,c,f
	movf	(??_costo_elevador+0+1)^00h,c,w
	mulwf	((c:costo_elevador@lejano))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+2+1)^00h,c,f
	movff	(c:costo_elevador@inter),??_costo_elevador+4
	movff	(c:costo_elevador@inter+1),??_costo_elevador+4+1
	bcf	status,0
	rlcf	(??_costo_elevador+4)^00h,c
	rlcf	(??_costo_elevador+4+1)^00h,c
	bcf	status,0
	rlcf	(??_costo_elevador+4)^00h,c
	rlcf	(??_costo_elevador+4+1)^00h,c
	bcf	status,0
	rlcf	(??_costo_elevador+4)^00h,c
	rlcf	(??_costo_elevador+4+1)^00h,c
	movf	((c:costo_elevador@lejano))^00h,c,w
	subwf	((c:costo_elevador@p_usr))^00h,c,w
	movwf	((c:vabs@x))^00h,c
	movf	((c:costo_elevador@lejano+1))^00h,c,w
	subwfb	((c:costo_elevador@p_usr+1))^00h,c,w
	movwf	1+((c:vabs@x))^00h,c
	call	_vabs	;wreg free
	movlw	low(0Ah)
	mulwf	(0+?_vabs)^00h,c
	movff	prodl,??_costo_elevador+6
	movff	prodh,??_costo_elevador+6+1
	mulwf	(1+?_vabs)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+6+1)^00h,c,f
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_costo_elevador+8
	movff	postdec2,??_costo_elevador+8+1
	movlw	low(0Ah)
	mulwf	(??_costo_elevador+8)^00h,c
	movff	prodl,??_costo_elevador+10
	movff	prodh,??_costo_elevador+10+1
	mulwf	(??_costo_elevador+8+1)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+10+1)^00h,c,f
	movf	(??_costo_elevador+6)^00h,c,w
	addwf	(??_costo_elevador+10)^00h,c,w
	movwf	(??_costo_elevador+12)^00h,c
	movf	(??_costo_elevador+6+1)^00h,c,w
	addwfc	(??_costo_elevador+10+1)^00h,c,w
	movwf	1+(??_costo_elevador+12)^00h,c
	movf	(??_costo_elevador+4)^00h,c,w
	addwf	(??_costo_elevador+12)^00h,c,w
	movwf	(??_costo_elevador+14)^00h,c
	movf	(??_costo_elevador+4+1)^00h,c,w
	addwfc	(??_costo_elevador+12+1)^00h,c,w
	movwf	1+(??_costo_elevador+14)^00h,c
	movf	(??_costo_elevador+2)^00h,c,w
	addwf	(??_costo_elevador+14)^00h,c,w
	movwf	(??_costo_elevador+16)^00h,c
	movf	(??_costo_elevador+2+1)^00h,c,w
	addwfc	(??_costo_elevador+14+1)^00h,c,w
	movwf	1+(??_costo_elevador+16)^00h,c
	movlw	low(0Ah)
	addwf	(??_costo_elevador+16)^00h,c,w
	movwf	((c:?_costo_elevador))^00h,c
	movlw	high(0Ah)
	addwfc	(??_costo_elevador+16+1)^00h,c,w
	movwf	1+((c:?_costo_elevador))^00h,c
	goto	l443
	line	471
	
l6403:
	movff	(c:costo_elevador@carga),??_costo_elevador+0
	movff	(c:costo_elevador@carga+1),??_costo_elevador+0+1
	bcf	status,0
	rlcf	(??_costo_elevador+0)^00h,c
	rlcf	(??_costo_elevador+0+1)^00h,c
	bcf	status,0
	rlcf	(??_costo_elevador+0)^00h,c
	rlcf	(??_costo_elevador+0+1)^00h,c
	bcf	status,0
	rlcf	(??_costo_elevador+0)^00h,c
	rlcf	(??_costo_elevador+0+1)^00h,c
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_costo_elevador+2
	movff	postdec2,??_costo_elevador+2+1
	movf	((c:costo_elevador@p_usr))^00h,c,w
	subwf	(??_costo_elevador+2)^00h,c,w
	movwf	((c:vabs@x))^00h,c
	movf	((c:costo_elevador@p_usr+1))^00h,c,w
	subwfb	(??_costo_elevador+2+1)^00h,c,w
	movwf	1+((c:vabs@x))^00h,c
	call	_vabs	;wreg free
	movlw	low(0Ah)
	mulwf	(0+?_vabs)^00h,c
	movff	prodl,??_costo_elevador+4
	movff	prodh,??_costo_elevador+4+1
	mulwf	(1+?_vabs)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+4+1)^00h,c,f
	movf	(??_costo_elevador+0)^00h,c,w
	addwf	(??_costo_elevador+4)^00h,c,w
	movwf	((c:?_costo_elevador))^00h,c
	movf	(??_costo_elevador+0+1)^00h,c,w
	addwfc	(??_costo_elevador+4+1)^00h,c,w
	movwf	1+((c:?_costo_elevador))^00h,c
	goto	l443
	line	473
	
l6407:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	3
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8761
	goto	u8760

u8761:
	goto	l6419
u8760:
	line	474
	
l6409:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movf	((c:costo_elevador@p_usr))^00h,c,w
xorwf	postinc2,w
	bnz	u8771
movf	((c:costo_elevador@p_usr+1))^00h,c,w
xorwf	postinc2,w
	btfss	status,2
	goto	u8771
	goto	u8770

u8771:
	goto	l6415
u8770:
	
l6411:
	clrf	((c:?_costo_elevador+1))^00h,c
	movlw	low(04h)
	movwf	((c:?_costo_elevador))^00h,c
	goto	l443
	line	475
	
l6415:
	movff	(c:costo_elevador@carga),??_costo_elevador+0
	movff	(c:costo_elevador@carga+1),??_costo_elevador+0+1
	bcf	status,0
	rlcf	(??_costo_elevador+0)^00h,c
	rlcf	(??_costo_elevador+0+1)^00h,c
	bcf	status,0
	rlcf	(??_costo_elevador+0)^00h,c
	rlcf	(??_costo_elevador+0+1)^00h,c
	bcf	status,0
	rlcf	(??_costo_elevador+0)^00h,c
	rlcf	(??_costo_elevador+0+1)^00h,c
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_costo_elevador+2
	movff	postdec2,??_costo_elevador+2+1
	movf	((c:costo_elevador@p_usr))^00h,c,w
	subwf	(??_costo_elevador+2)^00h,c,w
	movwf	((c:vabs@x))^00h,c
	movf	((c:costo_elevador@p_usr+1))^00h,c,w
	subwfb	(??_costo_elevador+2+1)^00h,c,w
	movwf	1+((c:vabs@x))^00h,c
	call	_vabs	;wreg free
	movlw	low(0Ah)
	mulwf	(0+?_vabs)^00h,c
	movff	prodl,??_costo_elevador+4
	movff	prodh,??_costo_elevador+4+1
	mulwf	(1+?_vabs)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+4+1)^00h,c,f
	movf	(??_costo_elevador+0)^00h,c,w
	addwf	(??_costo_elevador+4)^00h,c,w
	movwf	(??_costo_elevador+6)^00h,c
	movf	(??_costo_elevador+0+1)^00h,c,w
	addwfc	(??_costo_elevador+4+1)^00h,c,w
	movwf	1+(??_costo_elevador+6)^00h,c
	movlw	low(012h)
	addwf	(??_costo_elevador+6)^00h,c,w
	movwf	((c:?_costo_elevador))^00h,c
	movlw	high(012h)
	addwfc	(??_costo_elevador+6+1)^00h,c,w
	movwf	1+((c:?_costo_elevador))^00h,c
	goto	l443
	line	478
	
l6419:
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movf	((c:costo_elevador@p_usr))^00h,c,w
xorwf	postinc2,w
	bnz	u8781
movf	((c:costo_elevador@p_usr+1))^00h,c,w
xorwf	postinc2,w
	btfss	status,2
	goto	u8781
	goto	u8780

u8781:
	goto	l6425
u8780:
	
l6421:
	clrf	((c:?_costo_elevador+1))^00h,c
	movlw	low(06h)
	movwf	((c:?_costo_elevador))^00h,c
	goto	l443
	line	479
	
l6425:
	movlw	low(0Ah)
	mulwf	((c:costo_elevador@carga))^00h,c
	movff	prodl,??_costo_elevador+0
	movff	prodh,??_costo_elevador+0+1
	mulwf	((c:costo_elevador@carga+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+0+1)^00h,c,f
	movf	((c:costo_elevador@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_costo_elevador+2
	movff	postdec2,??_costo_elevador+2+1
	movf	((c:costo_elevador@p_usr))^00h,c,w
	subwf	(??_costo_elevador+2)^00h,c,w
	movwf	((c:vabs@x))^00h,c
	movf	((c:costo_elevador@p_usr+1))^00h,c,w
	subwfb	(??_costo_elevador+2+1)^00h,c,w
	movwf	1+((c:vabs@x))^00h,c
	call	_vabs	;wreg free
	movlw	low(0Ah)
	mulwf	(0+?_vabs)^00h,c
	movff	prodl,??_costo_elevador+4
	movff	prodh,??_costo_elevador+4+1
	mulwf	(1+?_vabs)^00h,c
	movf	(prodl),c,w
	addwf	(??_costo_elevador+4+1)^00h,c,f
	movf	(??_costo_elevador+0)^00h,c,w
	addwf	(??_costo_elevador+4)^00h,c,w
	movwf	(??_costo_elevador+6)^00h,c
	movf	(??_costo_elevador+0+1)^00h,c,w
	addwfc	(??_costo_elevador+4+1)^00h,c,w
	movwf	1+(??_costo_elevador+6)^00h,c
	movlw	low(026h)
	addwf	(??_costo_elevador+6)^00h,c,w
	movwf	((c:?_costo_elevador))^00h,c
	movlw	high(026h)
	addwfc	(??_costo_elevador+6+1)^00h,c,w
	movwf	1+((c:?_costo_elevador))^00h,c
	line	480
	
l443:
	return	;funcret
	callstack 0
GLOBAL	__end_of_costo_elevador
	__end_of_costo_elevador:
	signat	_costo_elevador,12410
	global	_contar_paradas

;; *************** function _contar_paradas *****************
;; Defined at:
;;		line 369 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2    5[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  p               2   13[COMRAM] int 
;;  c               2   11[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  2    5[COMRAM] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         4       0       0       0       0       0       0       0       0
;;      Temps:          4       0       0       0       0       0       0       0       0
;;      Totals:        10       0       0       0       0       0       0       0       0
;;Total ram usage:       10 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_costo_elevador
;; This function uses a non-reentrant model
;;
psect	text22,class=CODE,space=0,reloc=2,group=0
	line	369
global __ptext22
__ptext22:
psect	text22
	file	"LOGIC_TEST.c"
	line	369
	
_contar_paradas:
;incstack = 0
	callstack 25
	line	370
	
l6009:
	clrf	((c:contar_paradas@c+1))^00h,c
	movlw	low(0)
	movwf	((c:contar_paradas@c))^00h,c
	line	371
	clrf	((c:contar_paradas@p+1))^00h,c
	movlw	low(01h)
	movwf	((c:contar_paradas@p))^00h,c
	goto	l6015
	
l6011:
	movlw	low(015h)
	mulwf	((c:contar_paradas@e))^00h,c
	movff	prodl,??_contar_paradas+0
	movff	prodh,??_contar_paradas+0+1
	mulwf	((c:contar_paradas@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_contar_paradas+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_contar_paradas+0)^00h,c,w
	movwf	(??_contar_paradas+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_contar_paradas+0+1)^00h,c,w
	movwf	1+(??_contar_paradas+2)^00h,c
	movf	((c:contar_paradas@p))^00h,c,w
	addwf	(??_contar_paradas+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:contar_paradas@p+1))^00h,c,w
	addwfc	(??_contar_paradas+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u8131
	goto	u8130
u8131:
	goto	l380
u8130:
	
l6013:
	infsnz	((c:contar_paradas@c))^00h,c
	incf	((c:contar_paradas@c+1))^00h,c
	
l380:
	infsnz	((c:contar_paradas@p))^00h,c
	incf	((c:contar_paradas@p+1))^00h,c
	
l6015:
		movf	((c:contar_paradas@p))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_contar_paradas+0)^00h,c
	movf	((c:contar_paradas@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_contar_paradas+0)^00h,c,w
	btfsc	status,0
	goto	u8141
	goto	u8140

u8141:
	goto	l6011
u8140:
	
l381:
	line	372
	movff	(c:contar_paradas@c),(c:?_contar_paradas)
	movff	(c:contar_paradas@c+1),(c:?_contar_paradas+1)
	line	373
	
l382:
	return	;funcret
	callstack 0
GLOBAL	__end_of_contar_paradas
	__end_of_contar_paradas:
	signat	_contar_paradas,4218
	global	_agregar_cola_espera

;; *************** function _agregar_cola_espera *****************
;; Defined at:
;;		line 339 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2    5[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  i               2    9[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         6       0       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_llamar_pasillo_piso
;;		_atender_llegada
;; This function uses a non-reentrant model
;;
psect	text23,class=CODE,space=0,reloc=2,group=0
	line	339
global __ptext23
__ptext23:
psect	text23
	file	"LOGIC_TEST.c"
	line	339
	
_agregar_cola_espera:
;incstack = 0
	callstack 26
	line	341
	
l6153:
	clrf	((c:agregar_cola_espera@i+1))^00h,c
	movlw	low(0)
	movwf	((c:agregar_cola_espera@i))^00h,c
	goto	l6161
	
l6155:; BSR set to: 0

	movf	((c:agregar_cola_espera@i))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_cola_espera)
	movwf	fsr2l
	clrf	fsr2h
	movf	((c:agregar_cola_espera@e))^00h,c,w
xorwf	postinc2,w
	bnz	u8281
movf	((c:agregar_cola_espera@e+1))^00h,c,w
xorwf	postinc2,w
	btfss	status,2
	goto	u8281
	goto	u8280

u8281:
	goto	l6159
u8280:
	goto	l350
	
l6159:; BSR set to: 0

	infsnz	((c:agregar_cola_espera@i))^00h,c
	incf	((c:agregar_cola_espera@i+1))^00h,c
	
l6161:
	movlb	0	; () banked
		movf	((_cola_esp_len))&0ffh,w
	subwf	((c:agregar_cola_espera@i))^00h,c,w
	movf	((c:agregar_cola_espera@i+1))^00h,c,w
	xorlw	80h
	movwf	(??_agregar_cola_espera+0)^00h,c
	movf	((_cola_esp_len+1))&0ffh,w
	xorlw	80h
	subwfb	(??_agregar_cola_espera+0)^00h,c,w
	btfss	status,0
	goto	u8291
	goto	u8290

u8291:
	goto	l6155
u8290:
	line	342
	
l6163:; BSR set to: 0

	btfsc	((_cola_esp_len+1))&0ffh,7
	goto	u8300
	movf	((_cola_esp_len+1))&0ffh,w
	bnz	u8301
	movlw	3
	subwf	 ((_cola_esp_len))&0ffh,w
	btfsc	status,0
	goto	u8301
	goto	u8300

u8301:
	goto	l350
u8300:
	
l6165:; BSR set to: 0

	movf	((_cola_esp_len))&0ffh,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_cola_espera)
	movwf	fsr2l
	clrf	fsr2h
	movff	(c:agregar_cola_espera@e),postinc2
	movff	(c:agregar_cola_espera@e+1),postdec2
	
l6167:; BSR set to: 0

	infsnz	((_cola_esp_len))&0ffh
	incf	((_cola_esp_len+1))&0ffh
	line	343
	
l350:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_agregar_cola_espera
	__end_of_agregar_cola_espera:
	signat	_agregar_cola_espera,4217
	global	_UART_EmitEnq

;; *************** function _UART_EmitEnq *****************
;; Defined at:
;;		line 268 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2   29[COMRAM] int 
;;  fl              2   31[COMRAM] int 
;;  tipo            1   33[COMRAM] unsigned char 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         5       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:         6       0       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_UART_Put2d
;;		_UART_PutChar
;;		_UART_PutStr
;;		_UART_TxFree
;;		_dig
;; This function is called by:
;;		_llamar_pasillo_piso
;;		_encolar_destino_cabina
;; This function uses a non-reentrant model
;;
psect	text24,class=CODE,space=0,reloc=2,group=0
	line	268
global __ptext24
__ptext24:
psect	text24
	file	"LOGIC_TEST.c"
	line	268
	
_UART_EmitEnq:; BSR set to: 0

;incstack = 0
	callstack 26
	line	269
	
l6041:
	call	_UART_TxFree	;wreg free
	movwf	(??_UART_EmitEnq+0)^00h,c
		movlw	010h-0
	cpfslt	((??_UART_EmitEnq+0))^00h,c
	goto	u8171
	goto	u8170

u8171:
	goto	l6045
u8170:
	goto	l307
	line	270
	
l6045:; BSR set to: 0

		movlw	low(STR_1)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_1)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	271
	
l6047:
	movff	(c:UART_EmitEnq@e),(c:dig@v)
	movff	(c:UART_EmitEnq@e+1),(c:dig@v+1)
	call	_dig	;wreg free
	
	call	_UART_PutChar
	
l6049:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	272
	
l6051:; BSR set to: 0

	movff	(c:UART_EmitEnq@fl),(c:UART_Put2d@v)
	movff	(c:UART_EmitEnq@fl+1),(c:UART_Put2d@v+1)
	call	_UART_Put2d	;wreg free
	
l6053:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	273
	
l6055:; BSR set to: 0

	movf	((c:UART_EmitEnq@tipo))^00h,c,w
	
	call	_UART_PutChar
	
l6057:; BSR set to: 0

		movlw	low(STR_2)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_2)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	274
	
l307:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_EmitEnq
	__end_of_UART_EmitEnq:
	signat	_UART_EmitEnq,12409
	global	_UART_EmitDsp

;; *************** function _UART_EmitDsp *****************
;; Defined at:
;;		line 284 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  fl              2   38[COMRAM] int 
;;  dir_c           1   40[COMRAM] unsigned char 
;;  chosen          2   41[COMRAM] int 
;;  c0              2   43[COMRAM] int 
;;  c1              2   45[COMRAM] int 
;;  c2              2   47[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:        11       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:        12       0       0       0       0       0       0       0       0
;;Total ram usage:       12 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		_UART_Put2d
;;		_UART_PutChar
;;		_UART_PutInt
;;		_UART_PutStr
;;		_UART_TxFree
;;		_dig
;; This function is called by:
;;		_llamar_pasillo_piso
;; This function uses a non-reentrant model
;;
psect	text25,class=CODE,space=0,reloc=2,group=0
	line	284
global __ptext25
__ptext25:
psect	text25
	file	"LOGIC_TEST.c"
	line	284
	
_UART_EmitDsp:
;incstack = 0
	callstack 25
	line	285
	
l6059:
	call	_UART_TxFree	;wreg free
	movwf	(??_UART_EmitDsp+0)^00h,c
		movlw	022h-0
	cpfslt	((??_UART_EmitDsp+0))^00h,c
	goto	u8181
	goto	u8180

u8181:
	goto	l6063
u8180:
	goto	l315
	line	286
	
l6063:; BSR set to: 0

		movlw	low(STR_5)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_5)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	287
	
l6065:
	movff	(c:UART_EmitDsp@fl),(c:UART_Put2d@v)
	movff	(c:UART_EmitDsp@fl+1),(c:UART_Put2d@v+1)
	call	_UART_Put2d	;wreg free
	
l6067:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	288
	
l6069:; BSR set to: 0

	movf	((c:UART_EmitDsp@dir_c))^00h,c,w
	
	call	_UART_PutChar
	
l6071:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	289
	
l6073:; BSR set to: 0

	movff	(c:UART_EmitDsp@chosen),(c:dig@v)
	movff	(c:UART_EmitDsp@chosen+1),(c:dig@v+1)
	call	_dig	;wreg free
	
	call	_UART_PutChar
	
l6075:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	290
	
l6077:; BSR set to: 0

	movff	(c:UART_EmitDsp@c0),(c:UART_PutInt@v)
	movff	(c:UART_EmitDsp@c0+1),(c:UART_PutInt@v+1)
	call	_UART_PutInt	;wreg free
	
l6079:
	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	291
	
l6081:; BSR set to: 0

	movff	(c:UART_EmitDsp@c1),(c:UART_PutInt@v)
	movff	(c:UART_EmitDsp@c1+1),(c:UART_PutInt@v+1)
	call	_UART_PutInt	;wreg free
	
l6083:
	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	292
	
l6085:; BSR set to: 0

	movff	(c:UART_EmitDsp@c2),(c:UART_PutInt@v)
	movff	(c:UART_EmitDsp@c2+1),(c:UART_PutInt@v+1)
	call	_UART_PutInt	;wreg free
	
l6087:
		movlw	low(STR_6)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_6)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	293
	
l315:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_EmitDsp
	__end_of_UART_EmitDsp:
	signat	_UART_EmitDsp,24697
	global	_cambiar_num_pisos

;; *************** function _cambiar_num_pisos *****************
;; Defined at:
;;		line 482 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  n               2   53[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  e               2   63[COMRAM] int 
;;  p               2   61[COMRAM] int 
;;  podadas         2   59[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         6       0       0       0       0       0       0       0       0
;;      Temps:          4       0       0       0       0       0       0       0       0
;;      Totals:        12       0       0       0       0       0       0       0       0
;;Total ram usage:       12 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 4
;; This function calls:
;;		_UART_EmitCfg
;;		_UART_EnviarEstado
;;		_beep
;;		_msg_elev
;;		_siguiente_objetivo
;;		_tiene_paradas
;; This function is called by:
;;		_UART_ProcessRx
;; This function uses a non-reentrant model
;;
psect	text26,class=CODE,space=0,reloc=2,group=0
	line	482
global __ptext26
__ptext26:
psect	text26
	file	"LOGIC_TEST.c"
	line	482
	
_cambiar_num_pisos:
;incstack = 0
	callstack 25
	line	483
	
l6751:; BSR set to: 0

	clrf	((c:cambiar_num_pisos@podadas+1))^00h,c
	movlw	low(0)
	movwf	((c:cambiar_num_pisos@podadas))^00h,c
	line	484
	
l6753:; BSR set to: 0

	btfsc	((c:cambiar_num_pisos@n+1))^00h,c,7
	goto	u9401
	movf	((c:cambiar_num_pisos@n+1))^00h,c,w
	bnz	u9400
	movlw	4
	subwf	 ((c:cambiar_num_pisos@n))^00h,c,w
	btfss	status,0
	goto	u9401
	goto	u9400

u9401:
	goto	l472
u9400:
	
l6755:; BSR set to: 0

	btfsc	((c:cambiar_num_pisos@n+1))^00h,c,7
	goto	u9411
	movf	((c:cambiar_num_pisos@n+1))^00h,c,w
	bnz	u9410
	movlw	21
	subwf	 ((c:cambiar_num_pisos@n))^00h,c,w
	btfss	status,0
	goto	u9411
	goto	u9410

u9411:
	goto	l469
u9410:
	goto	l472
	
l469:; BSR set to: 0

	line	485
	movff	(c:cambiar_num_pisos@n),(c:_num_pisos)
	movff	(c:cambiar_num_pisos@n+1),(c:_num_pisos+1)
	line	487
	
l6757:; BSR set to: 0

		movlw	2
	xorwf	((c:_modo))^00h,c,w
iorwf	((c:_modo+1))^00h,c,w
	btfss	status,2
	goto	u9421
	goto	u9420

u9421:
	goto	l473
u9420:
	
l6759:; BSR set to: 0

		movf	((_piso_usr))&0ffh,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_cambiar_num_pisos+0)^00h,c
	movf	((_piso_usr+1))&0ffh,w
	xorlw	80h
	subwfb	(??_cambiar_num_pisos+0)^00h,c,w
	btfsc	status,0
	goto	u9431
	goto	u9430

u9431:
	goto	l473
u9430:
	line	488
	
l6761:; BSR set to: 0

	clrf	((_piso_usr+1))&0ffh
	movlw	low(0)
	movwf	((_piso_usr))&0ffh
	line	489
	clrf	((c:_modo+1))^00h,c
	movlw	low(0)
	movwf	((c:_modo))^00h,c
	line	490
	
l473:; BSR set to: 0

	line	492
	clrf	((c:cambiar_num_pisos@e+1))^00h,c
	movlw	low(0)
	movwf	((c:cambiar_num_pisos@e))^00h,c
	line	493
	
l6767:
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
		movf	postinc2,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_cambiar_num_pisos+2)^00h,c
	movf	postinc2,w
	xorlw	80h
	subwfb	(??_cambiar_num_pisos+2)^00h,c,w
	btfsc	status,0
	goto	u9441
	goto	u9440

u9441:
	goto	l476
u9440:
	
l6769:
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	(c:_num_pisos),postinc2
	movff	(c:_num_pisos+1),postdec2
	
l476:
	line	494
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
		movf	postinc2,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_cambiar_num_pisos+2)^00h,c
	movf	postinc2,w
	xorlw	80h
	subwfb	(??_cambiar_num_pisos+2)^00h,c,w
	btfsc	status,0
	goto	u9451
	goto	u9450

u9451:
	goto	l6773
u9450:
	
l6771:
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	495
	
l6773:
	movlw	low(01h)
	addwf	((c:_num_pisos))^00h,c,w
	movwf	((c:cambiar_num_pisos@p))^00h,c
	movlw	high(01h)
	addwfc	((c:_num_pisos+1))^00h,c,w
	movwf	1+((c:cambiar_num_pisos@p))^00h,c
	
l6775:
	btfsc	((c:cambiar_num_pisos@p+1))^00h,c,7
	goto	u9461
	movf	((c:cambiar_num_pisos@p+1))^00h,c,w
	bnz	u9460
	movlw	21
	subwf	 ((c:cambiar_num_pisos@p))^00h,c,w
	btfss	status,0
	goto	u9461
	goto	u9460

u9461:
	goto	l6779
u9460:
	goto	l6789
	line	496
	
l6779:
	movlw	low(015h)
	mulwf	((c:cambiar_num_pisos@e))^00h,c
	movff	prodl,??_cambiar_num_pisos+0
	movff	prodh,??_cambiar_num_pisos+0+1
	mulwf	((c:cambiar_num_pisos@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_cambiar_num_pisos+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_cambiar_num_pisos+0)^00h,c,w
	movwf	(??_cambiar_num_pisos+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_cambiar_num_pisos+0+1)^00h,c,w
	movwf	1+(??_cambiar_num_pisos+2)^00h,c
	movf	((c:cambiar_num_pisos@p))^00h,c,w
	addwf	(??_cambiar_num_pisos+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:cambiar_num_pisos@p+1))^00h,c,w
	addwfc	(??_cambiar_num_pisos+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u9471
	goto	u9470
u9471:
	goto	l6785
u9470:
	line	497
	
l6781:
	movlw	low(015h)
	mulwf	((c:cambiar_num_pisos@e))^00h,c
	movff	prodl,??_cambiar_num_pisos+0
	movff	prodh,??_cambiar_num_pisos+0+1
	mulwf	((c:cambiar_num_pisos@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_cambiar_num_pisos+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_cambiar_num_pisos+0)^00h,c,w
	movwf	(??_cambiar_num_pisos+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_cambiar_num_pisos+0+1)^00h,c,w
	movwf	1+(??_cambiar_num_pisos+2)^00h,c
	movf	((c:cambiar_num_pisos@p))^00h,c,w
	addwf	(??_cambiar_num_pisos+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:cambiar_num_pisos@p+1))^00h,c,w
	addwfc	(??_cambiar_num_pisos+2+1)^00h,c,w
	movwf	1+c:fsr2l
	clrf	indf2
	line	498
	
l6783:
	infsnz	((c:cambiar_num_pisos@podadas))^00h,c
	incf	((c:cambiar_num_pisos@podadas+1))^00h,c
	line	500
	
l6785:
	infsnz	((c:cambiar_num_pisos@p))^00h,c
	incf	((c:cambiar_num_pisos@p+1))^00h,c
	goto	l6775
	line	501
	
l6789:
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u9481
	goto	u9480

u9481:
	goto	l6797
u9480:
	line	502
	
l6791:
	movff	(c:cambiar_num_pisos@e),(c:siguiente_objetivo@e)
	movff	(c:cambiar_num_pisos@e+1),(c:siguiente_objetivo@e+1)
	call	_siguiente_objetivo	;wreg free
	line	503
	
l6793:
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u9491
	goto	u9490

u9491:
	goto	l6805
u9490:
	line	504
	
l6795:
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	505
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	506
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_piso)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	goto	l6805
	line	508
	
l6797:
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	2
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u9501
	goto	u9500

u9501:
	goto	l6805
u9500:
	line	509
	
l6799:
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	movlw	1
	btfsc	plusw2,7
	goto	u9511
	movlw	1
	movf	plusw2,w
	bnz	u9510
	decf	postinc2,w
	btfss	status,0
	goto	u9511
	goto	u9510

u9511:
	goto	l6805
u9510:
	
l6801:
	movff	(c:cambiar_num_pisos@e),(c:tiene_paradas@e)
	movff	(c:cambiar_num_pisos@e+1),(c:tiene_paradas@e+1)
	call	_tiene_paradas	;wreg free
	movf	(0+?_tiene_paradas)^00h,c,w
iorwf	(1+?_tiene_paradas)^00h,c,w
	btfss	status,2
	goto	u9521
	goto	u9520

u9521:
	goto	l6805
u9520:
	line	510
	
l6803:
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	511
	movf	((c:cambiar_num_pisos@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	514
	
l6805:
	infsnz	((c:cambiar_num_pisos@e))^00h,c
	incf	((c:cambiar_num_pisos@e+1))^00h,c
	
l6807:
	btfsc	((c:cambiar_num_pisos@e+1))^00h,c,7
	goto	u9531
	movf	((c:cambiar_num_pisos@e+1))^00h,c,w
	bnz	u9530
	movlw	3
	subwf	 ((c:cambiar_num_pisos@e))^00h,c,w
	btfss	status,0
	goto	u9531
	goto	u9530

u9531:
	goto	l6767
u9530:
	line	516
	
l6809:
	movlw	high(-1)
	movwf	((c:msg_elev@e+1))^00h,c
	setf	((c:msg_elev@e))^00h,c
		movlw	low(STR_13)
	movwf	((c:msg_elev@plantilla))^00h,c
	movlw	high(STR_13)
	movwf	((c:msg_elev@plantilla+1))^00h,c

	clrf	((c:msg_elev@pos_num+1))^00h,c
	movlw	low(0Ch)
	movwf	((c:msg_elev@pos_num))^00h,c
	movff	(c:_num_pisos),(c:msg_elev@num)
	movff	(c:_num_pisos+1),(c:msg_elev@num+1)
	call	_msg_elev	;wreg free
	line	517
	
l6811:; BSR set to: 1

	clrf	((c:beep@t+1))^00h,c
	movlw	low(06h)
	movwf	((c:beep@t))^00h,c
	call	_beep	;wreg free
	line	518
	
l6813:
	movff	(c:_num_pisos),(c:UART_EmitCfg@n)
	movff	(c:_num_pisos+1),(c:UART_EmitCfg@n+1)
	movff	(c:cambiar_num_pisos@podadas),(c:UART_EmitCfg@podadas)
	movff	(c:cambiar_num_pisos@podadas+1),(c:UART_EmitCfg@podadas+1)
	call	_UART_EmitCfg	;wreg free
	line	519
	
l6815:
	call	_UART_EnviarEstado	;wreg free
	line	520
	
l472:
	return	;funcret
	callstack 0
GLOBAL	__end_of_cambiar_num_pisos
	__end_of_cambiar_num_pisos:
	signat	_cambiar_num_pisos,4217
	global	_tiene_paradas

;; *************** function _tiene_paradas *****************
;; Defined at:
;;		line 363 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2    5[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  p               2   11[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  2    5[COMRAM] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          4       0       0       0       0       0       0       0       0
;;      Totals:         8       0       0       0       0       0       0       0       0
;;Total ram usage:        8 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_cambiar_num_pisos
;;		_procesar_tecla
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text27,class=CODE,space=0,reloc=2,group=0
	line	363
global __ptext27
__ptext27:
psect	text27
	file	"LOGIC_TEST.c"
	line	363
	
_tiene_paradas:
;incstack = 0
	callstack 27
	line	365
	
l6533:
	clrf	((c:tiene_paradas@p+1))^00h,c
	movlw	low(01h)
	movwf	((c:tiene_paradas@p))^00h,c
	goto	l6543
	
l6535:
	movlw	low(015h)
	mulwf	((c:tiene_paradas@e))^00h,c
	movff	prodl,??_tiene_paradas+0
	movff	prodh,??_tiene_paradas+0+1
	mulwf	((c:tiene_paradas@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_tiene_paradas+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_tiene_paradas+0)^00h,c,w
	movwf	(??_tiene_paradas+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_tiene_paradas+0+1)^00h,c,w
	movwf	1+(??_tiene_paradas+2)^00h,c
	movf	((c:tiene_paradas@p))^00h,c,w
	addwf	(??_tiene_paradas+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:tiene_paradas@p+1))^00h,c,w
	addwfc	(??_tiene_paradas+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u8991
	goto	u8990
u8991:
	goto	l6541
u8990:
	
l6537:
	clrf	((c:?_tiene_paradas+1))^00h,c
	movlw	low(01h)
	movwf	((c:?_tiene_paradas))^00h,c
	goto	l374
	
l6541:
	infsnz	((c:tiene_paradas@p))^00h,c
	incf	((c:tiene_paradas@p+1))^00h,c
	
l6543:
		movf	((c:tiene_paradas@p))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_tiene_paradas+0)^00h,c
	movf	((c:tiene_paradas@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_tiene_paradas+0)^00h,c,w
	btfsc	status,0
	goto	u9001
	goto	u9000

u9001:
	goto	l6535
u9000:
	line	366
	
l6545:
	clrf	((c:?_tiene_paradas+1))^00h,c
	movlw	low(0)
	movwf	((c:?_tiene_paradas))^00h,c
	line	367
	
l374:
	return	;funcret
	callstack 0
GLOBAL	__end_of_tiene_paradas
	__end_of_tiene_paradas:
	signat	_tiene_paradas,4218
	global	_siguiente_objetivo

;; *************** function _siguiente_objetivo *****************
;; Defined at:
;;		line 381 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2    9[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  mejor           2   23[COMRAM] int 
;;  d               2   17[COMRAM] int 
;;  p               2   29[COMRAM] int 
;;  max_p           2   27[COMRAM] int 
;;  min_p           2   25[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:        14       0       0       0       0       0       0       0       0
;;      Temps:          6       0       0       0       0       0       0       0       0
;;      Totals:        22       0       0       0       0       0       0       0       0
;;Total ram usage:       22 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_vabs
;; This function is called by:
;;		_cambiar_num_pisos
;;		_llamar_pasillo_piso
;;		_encolar_destino_cabina
;;		_procesar_tecla
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text28,class=CODE,space=0,reloc=2,group=0
	line	381
global __ptext28
__ptext28:
psect	text28
	file	"LOGIC_TEST.c"
	line	381
	
_siguiente_objetivo:
;incstack = 0
	callstack 26
	line	382
	
l6191:
	clrf	((c:siguiente_objetivo@min_p+1))^00h,c
	movlw	low(063h)
	movwf	((c:siguiente_objetivo@min_p))^00h,c
	clrf	((c:siguiente_objetivo@max_p+1))^00h,c
	movlw	low(0)
	movwf	((c:siguiente_objetivo@max_p))^00h,c
	line	383
	clrf	((c:siguiente_objetivo@p+1))^00h,c
	movlw	low(01h)
	movwf	((c:siguiente_objetivo@p))^00h,c
	goto	l6205
	line	384
	
l6193:
	movlw	low(015h)
	mulwf	((c:siguiente_objetivo@e))^00h,c
	movff	prodl,??_siguiente_objetivo+0
	movff	prodh,??_siguiente_objetivo+0+1
	mulwf	((c:siguiente_objetivo@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_siguiente_objetivo+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_siguiente_objetivo+0)^00h,c,w
	movwf	(??_siguiente_objetivo+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_siguiente_objetivo+0+1)^00h,c,w
	movwf	1+(??_siguiente_objetivo+2)^00h,c
	movf	((c:siguiente_objetivo@p))^00h,c,w
	addwf	(??_siguiente_objetivo+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	addwfc	(??_siguiente_objetivo+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u8341
	goto	u8340
u8341:
	goto	l6203
u8340:
	line	385
	
l6195:
		movf	((c:siguiente_objetivo@min_p))^00h,c,w
	subwf	((c:siguiente_objetivo@p))^00h,c,w
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	xorlw	80h
	movwf	(??_siguiente_objetivo+0)^00h,c
	movf	((c:siguiente_objetivo@min_p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_siguiente_objetivo+0)^00h,c,w
	btfsc	status,0
	goto	u8351
	goto	u8350

u8351:
	goto	l6199
u8350:
	
l6197:
	movff	(c:siguiente_objetivo@p),(c:siguiente_objetivo@min_p)
	movff	(c:siguiente_objetivo@p+1),(c:siguiente_objetivo@min_p+1)
	line	386
	
l6199:
		movf	((c:siguiente_objetivo@p))^00h,c,w
	subwf	((c:siguiente_objetivo@max_p))^00h,c,w
	movf	((c:siguiente_objetivo@max_p+1))^00h,c,w
	xorlw	80h
	movwf	(??_siguiente_objetivo+0)^00h,c
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_siguiente_objetivo+0)^00h,c,w
	btfsc	status,0
	goto	u8361
	goto	u8360

u8361:
	goto	l6203
u8360:
	
l6201:
	movff	(c:siguiente_objetivo@p),(c:siguiente_objetivo@max_p)
	movff	(c:siguiente_objetivo@p+1),(c:siguiente_objetivo@max_p+1)
	line	388
	
l6203:
	infsnz	((c:siguiente_objetivo@p))^00h,c
	incf	((c:siguiente_objetivo@p+1))^00h,c
	
l6205:
		movf	((c:siguiente_objetivo@p))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_siguiente_objetivo+0)^00h,c
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_siguiente_objetivo+0)^00h,c,w
	btfsc	status,0
	goto	u8371
	goto	u8370

u8371:
	goto	l6193
u8370:
	line	389
	
l6207:
	movf	((c:siguiente_objetivo@max_p))^00h,c,w
iorwf	((c:siguiente_objetivo@max_p+1))^00h,c,w
	btfss	status,2
	goto	u8381
	goto	u8380

u8381:
	goto	l6215
u8380:
	line	390
	
l6209:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	391
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	line	392
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8391
	goto	u8390

u8391:
	goto	l400
u8390:
	
l6211:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	clrf	postinc2
	clrf	postdec2
	goto	l400
	line	395
	
l6215:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_siguiente_objetivo+0
	movff	postdec2,??_siguiente_objetivo+0+1
	movlw	low(015h)
	mulwf	((c:siguiente_objetivo@e))^00h,c
	movff	prodl,??_siguiente_objetivo+2
	movff	prodh,??_siguiente_objetivo+2+1
	mulwf	((c:siguiente_objetivo@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_siguiente_objetivo+2+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_siguiente_objetivo+2)^00h,c,w
	movwf	(??_siguiente_objetivo+4)^00h,c
	movlw	high(_paradas)
	addwfc	(??_siguiente_objetivo+2+1)^00h,c,w
	movwf	1+(??_siguiente_objetivo+4)^00h,c
	movf	(??_siguiente_objetivo+0)^00h,c,w
	addwf	(??_siguiente_objetivo+4)^00h,c,w
	movwf	c:fsr2l
	movf	(??_siguiente_objetivo+0+1)^00h,c,w
	addwfc	(??_siguiente_objetivo+4+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u8401
	goto	u8400
u8401:
	goto	l6221
u8400:
	line	396
	
l6217:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr1l
	clrf	fsr1h
	movff	postinc2,postinc1
	movff	postdec2,postdec1
	goto	l400
	line	399
	
l6221:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8411
	goto	u8410

u8411:
	goto	l6257
u8410:
	line	400
	
l6223:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_siguiente_objetivo+0
	movff	postdec2,??_siguiente_objetivo+0+1
	movlw	low(01h)
	addwf	(??_siguiente_objetivo+0)^00h,c,w
	movwf	((c:siguiente_objetivo@p))^00h,c
	movlw	high(01h)
	addwfc	(??_siguiente_objetivo+0+1)^00h,c,w
	movwf	1+((c:siguiente_objetivo@p))^00h,c
	goto	l6235
	line	401
	
l6225:
	movlw	low(015h)
	mulwf	((c:siguiente_objetivo@e))^00h,c
	movff	prodl,??_siguiente_objetivo+0
	movff	prodh,??_siguiente_objetivo+0+1
	mulwf	((c:siguiente_objetivo@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_siguiente_objetivo+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_siguiente_objetivo+0)^00h,c,w
	movwf	(??_siguiente_objetivo+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_siguiente_objetivo+0+1)^00h,c,w
	movwf	1+(??_siguiente_objetivo+2)^00h,c
	movf	((c:siguiente_objetivo@p))^00h,c,w
	addwf	(??_siguiente_objetivo+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	addwfc	(??_siguiente_objetivo+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	movwf	(??_siguiente_objetivo+4)^00h,c
	movlw	05h
	andwf	((??_siguiente_objetivo+4))^00h,c
	btfss	status,2
	goto	u8421
	goto	u8420
u8421:
	goto	l6229
u8420:
	
l6227:
	movf	((c:siguiente_objetivo@max_p))^00h,c,w
xorwf	((c:siguiente_objetivo@p))^00h,c,w
	bnz	u8431
movf	((c:siguiente_objetivo@max_p+1))^00h,c,w
xorwf	((c:siguiente_objetivo@p+1))^00h,c,w
	btfss	status,2
	goto	u8431
	goto	u8430

u8431:
	goto	l6233
u8430:
	line	402
	
l6229:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movff	(c:siguiente_objetivo@p),postinc2
	movff	(c:siguiente_objetivo@p+1),postdec2
	goto	l400
	line	405
	
l6233:
	infsnz	((c:siguiente_objetivo@p))^00h,c
	incf	((c:siguiente_objetivo@p+1))^00h,c
	
l6235:
		movf	((c:siguiente_objetivo@p))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_siguiente_objetivo+0)^00h,c
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_siguiente_objetivo+0)^00h,c,w
	btfsc	status,0
	goto	u8441
	goto	u8440

u8441:
	goto	l6225
u8440:
	line	406
	
l6237:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(02h)
	movwf	postinc2,c
	movlw	high(02h)
	movwf	postdec2,c
	line	407
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_siguiente_objetivo+0
	movff	postdec2,??_siguiente_objetivo+0+1
	movlw	low(-1)
	addwf	(??_siguiente_objetivo+0)^00h,c,w
	movwf	((c:siguiente_objetivo@p))^00h,c
	movlw	high(-1)
	addwfc	(??_siguiente_objetivo+0+1)^00h,c,w
	movwf	1+((c:siguiente_objetivo@p))^00h,c
	
l6239:
	btfsc	((c:siguiente_objetivo@p+1))^00h,c,7
	goto	u8450
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	bnz	u8451
	decf	((c:siguiente_objetivo@p))^00h,c,w
	btfsc	status,0
	goto	u8451
	goto	u8450

u8451:
	goto	l6243
u8450:
	goto	l6255
	line	408
	
l6243:
	movlw	low(015h)
	mulwf	((c:siguiente_objetivo@e))^00h,c
	movff	prodl,??_siguiente_objetivo+0
	movff	prodh,??_siguiente_objetivo+0+1
	mulwf	((c:siguiente_objetivo@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_siguiente_objetivo+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_siguiente_objetivo+0)^00h,c,w
	movwf	(??_siguiente_objetivo+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_siguiente_objetivo+0+1)^00h,c,w
	movwf	1+(??_siguiente_objetivo+2)^00h,c
	movf	((c:siguiente_objetivo@p))^00h,c,w
	addwf	(??_siguiente_objetivo+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	addwfc	(??_siguiente_objetivo+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	movwf	(??_siguiente_objetivo+4)^00h,c
	movlw	06h
	andwf	((??_siguiente_objetivo+4))^00h,c
	btfss	status,2
	goto	u8461
	goto	u8460
u8461:
	goto	l6229
u8460:
	
l6245:
	movf	((c:siguiente_objetivo@min_p))^00h,c,w
xorwf	((c:siguiente_objetivo@p))^00h,c,w
	bnz	u8471
movf	((c:siguiente_objetivo@min_p+1))^00h,c,w
xorwf	((c:siguiente_objetivo@p+1))^00h,c,w
	btfss	status,2
	goto	u8471
	goto	u8470

u8471:
	goto	l6251
u8470:
	goto	l6229
	line	412
	
l6251:
	decf	((c:siguiente_objetivo@p))^00h,c
	btfss	status,0
	decf	((c:siguiente_objetivo@p+1))^00h,c
	goto	l6239
	line	413
	
l6255:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movff	(c:siguiente_objetivo@max_p),postinc2
	movff	(c:siguiente_objetivo@max_p+1),postdec2
	line	414
	goto	l400
	
l6257:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movlw	2
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8481
	goto	u8480

u8481:
	goto	l415
u8480:
	line	415
	
l6259:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_siguiente_objetivo+0
	movff	postdec2,??_siguiente_objetivo+0+1
	movlw	low(-1)
	addwf	(??_siguiente_objetivo+0)^00h,c,w
	movwf	((c:siguiente_objetivo@p))^00h,c
	movlw	high(-1)
	addwfc	(??_siguiente_objetivo+0+1)^00h,c,w
	movwf	1+((c:siguiente_objetivo@p))^00h,c
	
l6261:
	btfsc	((c:siguiente_objetivo@p+1))^00h,c,7
	goto	u8490
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	bnz	u8491
	decf	((c:siguiente_objetivo@p))^00h,c,w
	btfsc	status,0
	goto	u8491
	goto	u8490

u8491:
	goto	l6265
u8490:
	goto	l6277
	line	416
	
l6265:
	movlw	low(015h)
	mulwf	((c:siguiente_objetivo@e))^00h,c
	movff	prodl,??_siguiente_objetivo+0
	movff	prodh,??_siguiente_objetivo+0+1
	mulwf	((c:siguiente_objetivo@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_siguiente_objetivo+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_siguiente_objetivo+0)^00h,c,w
	movwf	(??_siguiente_objetivo+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_siguiente_objetivo+0+1)^00h,c,w
	movwf	1+(??_siguiente_objetivo+2)^00h,c
	movf	((c:siguiente_objetivo@p))^00h,c,w
	addwf	(??_siguiente_objetivo+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	addwfc	(??_siguiente_objetivo+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	movwf	(??_siguiente_objetivo+4)^00h,c
	movlw	06h
	andwf	((??_siguiente_objetivo+4))^00h,c
	btfss	status,2
	goto	u8501
	goto	u8500
u8501:
	goto	l6229
u8500:
	
l6267:
	movf	((c:siguiente_objetivo@min_p))^00h,c,w
xorwf	((c:siguiente_objetivo@p))^00h,c,w
	bnz	u8511
movf	((c:siguiente_objetivo@min_p+1))^00h,c,w
xorwf	((c:siguiente_objetivo@p+1))^00h,c,w
	btfss	status,2
	goto	u8511
	goto	u8510

u8511:
	goto	l6273
u8510:
	goto	l6229
	line	420
	
l6273:
	decf	((c:siguiente_objetivo@p))^00h,c
	btfss	status,0
	decf	((c:siguiente_objetivo@p+1))^00h,c
	goto	l6261
	line	421
	
l6277:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	movwf	postinc2,c
	movlw	high(01h)
	movwf	postdec2,c
	line	422
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_siguiente_objetivo+0
	movff	postdec2,??_siguiente_objetivo+0+1
	movlw	low(01h)
	addwf	(??_siguiente_objetivo+0)^00h,c,w
	movwf	((c:siguiente_objetivo@p))^00h,c
	movlw	high(01h)
	addwfc	(??_siguiente_objetivo+0+1)^00h,c,w
	movwf	1+((c:siguiente_objetivo@p))^00h,c
	goto	l6289
	line	423
	
l6279:
	movlw	low(015h)
	mulwf	((c:siguiente_objetivo@e))^00h,c
	movff	prodl,??_siguiente_objetivo+0
	movff	prodh,??_siguiente_objetivo+0+1
	mulwf	((c:siguiente_objetivo@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_siguiente_objetivo+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_siguiente_objetivo+0)^00h,c,w
	movwf	(??_siguiente_objetivo+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_siguiente_objetivo+0+1)^00h,c,w
	movwf	1+(??_siguiente_objetivo+2)^00h,c
	movf	((c:siguiente_objetivo@p))^00h,c,w
	addwf	(??_siguiente_objetivo+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	addwfc	(??_siguiente_objetivo+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	movwf	(??_siguiente_objetivo+4)^00h,c
	movlw	05h
	andwf	((??_siguiente_objetivo+4))^00h,c
	btfss	status,2
	goto	u8521
	goto	u8520
u8521:
	goto	l6229
u8520:
	
l6281:
	movf	((c:siguiente_objetivo@max_p))^00h,c,w
xorwf	((c:siguiente_objetivo@p))^00h,c,w
	bnz	u8531
movf	((c:siguiente_objetivo@max_p+1))^00h,c,w
xorwf	((c:siguiente_objetivo@p+1))^00h,c,w
	btfss	status,2
	goto	u8531
	goto	u8530

u8531:
	goto	l6287
u8530:
	goto	l6229
	line	427
	
l6287:
	infsnz	((c:siguiente_objetivo@p))^00h,c
	incf	((c:siguiente_objetivo@p+1))^00h,c
	
l6289:
		movf	((c:siguiente_objetivo@p))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_siguiente_objetivo+0)^00h,c
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_siguiente_objetivo+0)^00h,c,w
	btfsc	status,0
	goto	u8541
	goto	u8540

u8541:
	goto	l6279
u8540:
	line	428
	
l6291:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movff	(c:siguiente_objetivo@min_p),postinc2
	movff	(c:siguiente_objetivo@min_p+1),postdec2
	line	429
	goto	l400
	
l415:
	line	430
	movff	(c:siguiente_objetivo@min_p),(c:siguiente_objetivo@mejor)
	movff	(c:siguiente_objetivo@min_p+1),(c:siguiente_objetivo@mejor+1)
	
l6293:
	clrf	((c:siguiente_objetivo@d+1))^00h,c
	movlw	low(063h)
	movwf	((c:siguiente_objetivo@d))^00h,c
	line	431
	clrf	((c:siguiente_objetivo@p+1))^00h,c
	movlw	low(01h)
	movwf	((c:siguiente_objetivo@p))^00h,c
	goto	l6305
	line	432
	
l6295:
	movlw	low(015h)
	mulwf	((c:siguiente_objetivo@e))^00h,c
	movff	prodl,??_siguiente_objetivo+0
	movff	prodh,??_siguiente_objetivo+0+1
	mulwf	((c:siguiente_objetivo@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_siguiente_objetivo+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_siguiente_objetivo+0)^00h,c,w
	movwf	(??_siguiente_objetivo+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_siguiente_objetivo+0+1)^00h,c,w
	movwf	1+(??_siguiente_objetivo+2)^00h,c
	movf	((c:siguiente_objetivo@p))^00h,c,w
	addwf	(??_siguiente_objetivo+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	addwfc	(??_siguiente_objetivo+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	btfsc	status,2
	goto	u8551
	goto	u8550
u8551:
	goto	l6303
u8550:
	
l6297:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_siguiente_objetivo+0
	movff	postdec2,??_siguiente_objetivo+0+1
	movf	(??_siguiente_objetivo+0)^00h,c,w
	subwf	((c:siguiente_objetivo@p))^00h,c,w
	movwf	((c:vabs@x))^00h,c
	movf	(??_siguiente_objetivo+0+1)^00h,c,w
	subwfb	((c:siguiente_objetivo@p+1))^00h,c,w
	movwf	1+((c:vabs@x))^00h,c
	call	_vabs	;wreg free
		movf	((c:siguiente_objetivo@d))^00h,c,w
	subwf	(0+?_vabs)^00h,c,w
	movf	(1+?_vabs)^00h,c,w
	xorlw	80h
	movwf	(??_siguiente_objetivo+2)^00h,c
	movf	((c:siguiente_objetivo@d+1))^00h,c,w
	xorlw	80h
	subwfb	(??_siguiente_objetivo+2)^00h,c,w
	btfsc	status,0
	goto	u8561
	goto	u8560

u8561:
	goto	l6303
u8560:
	line	433
	
l6299:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,??_siguiente_objetivo+0
	movff	postdec2,??_siguiente_objetivo+0+1
	movf	(??_siguiente_objetivo+0)^00h,c,w
	subwf	((c:siguiente_objetivo@p))^00h,c,w
	movwf	((c:vabs@x))^00h,c
	movf	(??_siguiente_objetivo+0+1)^00h,c,w
	subwfb	((c:siguiente_objetivo@p+1))^00h,c,w
	movwf	1+((c:vabs@x))^00h,c
	call	_vabs	;wreg free
	movff	0+?_vabs,(c:siguiente_objetivo@d)
	movff	1+?_vabs,(c:siguiente_objetivo@d+1)
	line	434
	
l6301:
	movff	(c:siguiente_objetivo@p),(c:siguiente_objetivo@mejor)
	movff	(c:siguiente_objetivo@p+1),(c:siguiente_objetivo@mejor+1)
	line	436
	
l6303:
	infsnz	((c:siguiente_objetivo@p))^00h,c
	incf	((c:siguiente_objetivo@p+1))^00h,c
	
l6305:
		movf	((c:siguiente_objetivo@p))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_siguiente_objetivo+0)^00h,c
	movf	((c:siguiente_objetivo@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_siguiente_objetivo+0)^00h,c,w
	btfsc	status,0
	goto	u8571
	goto	u8570

u8571:
	goto	l6295
u8570:
	line	437
	
l6307:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movff	(c:siguiente_objetivo@mejor),postinc2
	movff	(c:siguiente_objetivo@mejor+1),postdec2
	line	438
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
		movf	((c:siguiente_objetivo@mejor))^00h,c,w
	subwf	postinc2,w
	movf	postinc2,w
	xorlw	80h
	movwf	(??_siguiente_objetivo+2)^00h,c
	movf	((c:siguiente_objetivo@mejor+1))^00h,c,w
	xorlw	80h
	subwfb	(??_siguiente_objetivo+2)^00h,c,w
	btfss	status,0
	goto	u8581
	goto	u8580

u8581:
	goto	l6317
u8580:
	
l6309:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
		movf	postinc2,w
	subwf	((c:siguiente_objetivo@mejor))^00h,c,w
	movf	((c:siguiente_objetivo@mejor+1))^00h,c,w
	xorlw	80h
	movwf	(??_siguiente_objetivo+2)^00h,c
	movf	postinc2,w
	xorlw	80h
	subwfb	(??_siguiente_objetivo+2)^00h,c,w
	btfss	status,0
	goto	u8591
	goto	u8590

u8591:
	goto	l6313
u8590:
	
l6311:
	clrf	((c:_siguiente_objetivo$1076+1))^00h,c
	movlw	low(0)
	movwf	((c:_siguiente_objetivo$1076))^00h,c
	goto	l6315
	
l6313:
	clrf	((c:_siguiente_objetivo$1076+1))^00h,c
	movlw	low(02h)
	movwf	((c:_siguiente_objetivo$1076))^00h,c
	
l6315:
	movff	(c:_siguiente_objetivo$1076),(c:_siguiente_objetivo$1075)
	movff	(c:_siguiente_objetivo$1076+1),(c:_siguiente_objetivo$1075+1)
	goto	l6319
	
l6317:
	clrf	((c:_siguiente_objetivo$1075+1))^00h,c
	movlw	low(01h)
	movwf	((c:_siguiente_objetivo$1075))^00h,c
	
l6319:
	movf	((c:siguiente_objetivo@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	movff	(c:_siguiente_objetivo$1075),postinc2
	movff	(c:_siguiente_objetivo$1075+1),postdec2
	line	440
	
l400:
	return	;funcret
	callstack 0
GLOBAL	__end_of_siguiente_objetivo
	__end_of_siguiente_objetivo:
	signat	_siguiente_objetivo,4217
	global	_vabs

;; *************** function _vabs *****************
;; Defined at:
;;		line 107 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  x               2    5[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2    5[COMRAM] int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         4       0       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_siguiente_objetivo
;;		_costo_elevador
;; This function uses a non-reentrant model
;;
psect	text29,class=CODE,space=0,reloc=2,group=0
	line	107
global __ptext29
__ptext29:
psect	text29
	file	"LOGIC_TEST.c"
	line	107
	
_vabs:
;incstack = 0
	callstack 25
	
l5829:
	btfsc	((c:vabs@x+1))^00h,c,7
	goto	u7801
	goto	u7800

u7801:
	goto	l161
u7800:
	
l5831:
	movff	(c:vabs@x),(c:?_vabs)
	movff	(c:vabs@x+1),(c:?_vabs+1)
	goto	l164
	
l161:
	movff	(c:vabs@x),??_vabs+0
	movff	(c:vabs@x+1),??_vabs+0+1
	comf	(??_vabs+0)^00h,c
	comf	(??_vabs+0+1)^00h,c
	infsnz	(??_vabs+0)^00h,c
	incf	(??_vabs+0+1)^00h,c
	movff	??_vabs+0,(c:?_vabs)
	movff	??_vabs+0+1,(c:?_vabs+1)
	
l164:
	return	;funcret
	callstack 0
GLOBAL	__end_of_vabs
	__end_of_vabs:
	signat	_vabs,4218
	global	_msg_elev

;; *************** function _msg_elev *****************
;; Defined at:
;;		line 124 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2   18[COMRAM] int 
;;  plantilla       2   20[COMRAM] PTR const unsigned char 
;;		 -> STR_34(17), STR_33(17), STR_32(17), STR_30(17), 
;;		 -> STR_29(17), STR_28(17), STR_27(17), STR_24(17), 
;;		 -> STR_22(17), STR_21(17), STR_18(17), STR_17(17), 
;;		 -> STR_16(17), STR_13(17), 
;;  pos_num         2   22[COMRAM] int 
;;  num             2   24[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  m              17   26[COMRAM] unsigned char [17]
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         8       0       0       0       0       0       0       0       0
;;      Locals:        17       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:        25       0       0       0       0       0       0       0       0
;;Total ram usage:       25 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_dig
;;		_poner_2d
;;		_poner_msg
;;		_strcpy
;; This function is called by:
;;		_cambiar_num_pisos
;;		_llamar_pasillo_piso
;;		_encolar_destino_cabina
;;		_procesar_tecla
;;		_atender_llegada
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text30,class=CODE,space=0,reloc=2,group=0
	line	124
global __ptext30
__ptext30:
psect	text30
	file	"LOGIC_TEST.c"
	line	124
	
_msg_elev:
;incstack = 0
	callstack 26
	line	126
	
l6019:
		movlw	low(msg_elev@m)
	movwf	((c:strcpy@dest))^00h,c

		movff	(c:msg_elev@plantilla),(c:strcpy@src)
	movff	(c:msg_elev@plantilla+1),(c:strcpy@src+1)

	call	_strcpy	;wreg free
	line	127
	
l6021:
	btfsc	((c:msg_elev@e+1))^00h,c,7
	goto	u8151
	goto	u8150

u8151:
	goto	l6025
u8150:
	
l6023:
	movlw	low(01h)
	addwf	((c:msg_elev@e))^00h,c,w
	movwf	((c:dig@v))^00h,c
	movlw	high(01h)
	addwfc	((c:msg_elev@e+1))^00h,c,w
	movwf	1+((c:dig@v))^00h,c
	call	_dig	;wreg free
	movwf	(0+((c:msg_elev@m)+01h))^00h,c
	line	128
	
l6025:
	btfsc	((c:msg_elev@pos_num+1))^00h,c,7
	goto	u8161
	goto	u8160

u8161:
	goto	l6029
u8160:
	
l6027:
	movf	((c:msg_elev@pos_num))^00h,c,w
	addlw	low(msg_elev@m)
	movwf	((c:poner_2d@p))^00h,c
	movff	(c:msg_elev@num),(c:poner_2d@v)
	movff	(c:msg_elev@num+1),(c:poner_2d@v+1)
	call	_poner_2d	;wreg free
	line	129
	
l6029:
		movlw	low(msg_elev@m)
	movwf	((c:poner_msg@s))^00h,c
	clrf	((c:poner_msg@s+1))^00h,c

	call	_poner_msg	;wreg free
	line	130
	
l187:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_msg_elev
	__end_of_msg_elev:
	signat	_msg_elev,16505
	global	_strcpy

;; *************** function _strcpy *****************
;; Defined at:
;;		line 3 in file "D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\strcpy.c"
;; Parameters:    Size  Location     Type
;;  dest            1    5[COMRAM] PTR unsigned char 
;;		 -> actualizar_todo@l2(17), actualizar_todo@l1(17), msg_elev@m(17), 
;;  src             2    6[COMRAM] PTR const unsigned char 
;;		 -> STR_43(17), STR_42(17), STR_41(17), STR_39(17), 
;;		 -> STR_38(17), STR_37(17), STR_36(17), STR_35(17), 
;;		 -> STR_34(17), STR_33(17), STR_32(17), STR_30(17), 
;;		 -> STR_29(17), STR_28(17), STR_27(17), STR_24(17), 
;;		 -> STR_22(17), STR_21(17), STR_18(17), STR_17(17), 
;;		 -> STR_16(17), STR_13(17), 
;; Auto vars:     Size  Location     Type
;;  d               1    8[COMRAM] PTR unsigned char 
;;		 -> actualizar_todo@l2(17), actualizar_todo@l1(17), msg_elev@m(17), 
;; Return value:  Size  Location     Type
;;                  1    5[COMRAM] PTR unsigned char 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         3       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         4       0       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_msg_elev
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text31,class=CODE,space=0,reloc=2,group=2
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\strcpy.c"
	line	3
global __ptext31
__ptext31:
psect	text31
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\strcpy.c"
	line	3
	
_strcpy:; BSR set to: 1

;incstack = 0
	callstack 25
	line	5
	
l5865:
		movff	(c:strcpy@dest),(c:strcpy@d)

	line	6
	
l5867:
	movff	(c:strcpy@src),tblptrl
	movff	(c:strcpy@src+1),tblptrh
	infsnz	((c:strcpy@src))^00h,c
	incf	((c:strcpy@src+1))^00h,c
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	incf	((c:strcpy@d))^00h,c
	decf	((c:strcpy@d))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
	tblrd	*
	
	movff	tablat,indf2
	movf	indf2,w
	btfss	status,2
	goto	u7881
	goto	u7880
u7881:
	goto	l5867
u7880:
	line	8
	
l1564:
	return	;funcret
	callstack 0
GLOBAL	__end_of_strcpy
	__end_of_strcpy:
	signat	_strcpy,8314
	global	_poner_msg

;; *************** function _poner_msg *****************
;; Defined at:
;;		line 117 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  s               2    5[COMRAM] PTR const unsigned char 
;;		 -> STR_31(17), STR_26(17), STR_25(17), STR_23(17), 
;;		 -> STR_20(17), STR_19(17), STR_14(17), msg_elev@m(17), 
;; Auto vars:     Size  Location     Type
;;  i               2    9[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr1l, fsr1h, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/1
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         6       0       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_msg_elev
;;		_reiniciar_sistema
;;		_llamar_pasillo
;;		_encolar_destino_cabina
;;		_procesar_tecla
;; This function uses a non-reentrant model
;;
psect	text32,class=CODE,space=0,reloc=2,group=0
	file	"LOGIC_TEST.c"
	line	117
global __ptext32
__ptext32:
psect	text32
	file	"LOGIC_TEST.c"
	line	117
	
_poner_msg:
;incstack = 0
	callstack 25
	line	119
	
l5845:
	clrf	((c:poner_msg@i+1))^00h,c
	movlw	low(0)
	movwf	((c:poner_msg@i))^00h,c
	goto	l5851
	
l5847:
	movf	((c:poner_msg@i))^00h,c,w
	addwf	((c:poner_msg@s))^00h,c,w
	movwf	(??_poner_msg+0)^00h,c
	movf	((c:poner_msg@i+1))^00h,c,w
	addwfc	((c:poner_msg@s+1))^00h,c,w
	movwf	(??_poner_msg+0+1)^00h,c
	movff	??_poner_msg+0,tblptrl
	movff	??_poner_msg+0+1,tblptrh
	clrf	tblptru
	
	movlw	low(_msg_lcd)
	addwf	((c:poner_msg@i))^00h,c,w
	movwf	c:fsr2l
	movlw	high(_msg_lcd)
	addwfc	((c:poner_msg@i+1))^00h,c,w
	movwf	1+c:fsr2l
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	u7837

	tblrd	*
	
	movf	tablat,w
	bra	u7830
u7837:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
u7830:
	movwf	indf2
	
l5849:
	infsnz	((c:poner_msg@i))^00h,c
	incf	((c:poner_msg@i+1))^00h,c
	
l5851:
	btfsc	((c:poner_msg@i+1))^00h,c,7
	goto	u7840
	movf	((c:poner_msg@i+1))^00h,c,w
	bnz	u7841
	movlw	16
	subwf	 ((c:poner_msg@i))^00h,c,w
	btfsc	status,0
	goto	u7841
	goto	u7840

u7841:
	goto	l5855
u7840:
	
l5853:
	movf	((c:poner_msg@i))^00h,c,w
	addwf	((c:poner_msg@s))^00h,c,w
	movwf	(??_poner_msg+0)^00h,c
	movf	((c:poner_msg@i+1))^00h,c,w
	addwfc	((c:poner_msg@s+1))^00h,c,w
	movwf	(??_poner_msg+0+1)^00h,c
	movff	??_poner_msg+0,tblptrl
	movff	??_poner_msg+0+1,tblptrh
	clrf	tblptru
	
	movlw	high __ramtop-1
	cpfsgt	tblptrh
	bra	u7857

	tblrd	*
	
	movf	tablat,w
	bra	u7850
u7857:
	movff	tblptrl,fsr1l
	movff	tblptrh,fsr1h
	movf	indf1,w
u7850:
	iorlw	0
	btfss	status,2
	goto	u7861
	goto	u7860
u7861:
	goto	l5847
u7860:
	line	120
	
l5855:
	btfsc	((c:poner_msg@i+1))^00h,c,7
	goto	u7871
	movf	((c:poner_msg@i+1))^00h,c,w
	bnz	u7870
	movlw	16
	subwf	 ((c:poner_msg@i))^00h,c,w
	btfss	status,0
	goto	u7871
	goto	u7870

u7871:
	goto	l5859
u7870:
	goto	l181
	
l5859:
	movlw	low(_msg_lcd)
	addwf	((c:poner_msg@i))^00h,c,w
	movwf	c:fsr2l
	movlw	high(_msg_lcd)
	addwfc	((c:poner_msg@i+1))^00h,c,w
	movwf	1+c:fsr2l
	movlw	low(020h)
	movwf	indf2
	
l5861:
	infsnz	((c:poner_msg@i))^00h,c
	incf	((c:poner_msg@i+1))^00h,c
	goto	l5855
	
l181:
	line	121
	movlb	1	; () banked
	clrf	(0+(_msg_lcd+010h))&0ffh
	line	122
	
l182:; BSR set to: 1

	return	;funcret
	callstack 0
GLOBAL	__end_of_poner_msg
	__end_of_poner_msg:
	signat	_poner_msg,4217
	global	_poner_2d

;; *************** function _poner_2d *****************
;; Defined at:
;;		line 110 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  p               1   15[COMRAM] PTR unsigned char 
;;		 -> actualizar_todo@l2(17), actualizar_todo@l1(17), msg_elev@m(17), 
;;  v               2   16[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         3       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         3       0       0       0       0       0       0       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		___awdiv
;;		_dig
;; This function is called by:
;;		_msg_elev
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text33,class=CODE,space=0,reloc=2,group=0
	line	110
global __ptext33
__ptext33:
psect	text33
	file	"LOGIC_TEST.c"
	line	110
	
_poner_2d:; BSR set to: 1

;incstack = 0
	callstack 25
	line	111
	
l5833:
	btfsc	((c:poner_2d@v+1))^00h,c,7
	goto	u7810
	goto	u7811

u7811:
	goto	l5837
u7810:
	
l5835:
	clrf	((c:poner_2d@v+1))^00h,c
	movlw	low(0)
	movwf	((c:poner_2d@v))^00h,c
	line	112
	
l5837:
	btfsc	((c:poner_2d@v+1))^00h,c,7
	goto	u7821
	movf	((c:poner_2d@v+1))^00h,c,w
	bnz	u7820
	movlw	100
	subwf	 ((c:poner_2d@v))^00h,c,w
	btfss	status,0
	goto	u7821
	goto	u7820

u7821:
	goto	l5841
u7820:
	
l5839:
	clrf	((c:poner_2d@v+1))^00h,c
	movlw	low(063h)
	movwf	((c:poner_2d@v))^00h,c
	line	113
	
l5841:
	movf	((c:poner_2d@p))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
	movff	(c:poner_2d@v),(c:___awdiv@dividend)
	movff	(c:poner_2d@v+1),(c:___awdiv@dividend+1)
	clrf	((c:___awdiv@divisor+1))^00h,c
	movlw	low(0Ah)
	movwf	((c:___awdiv@divisor))^00h,c
	call	___awdiv	;wreg free
	movff	0+?___awdiv,(c:dig@v)
	movff	1+?___awdiv,(c:dig@v+1)
	call	_dig	;wreg free
	movwf	indf2,c

	line	114
	
l5843:
	movf	((c:poner_2d@p))^00h,c,w
	movwf	fsr2l
	clrf	fsr2h
	movlw	low(01h)
	addwf	fsr2l

	movff	(c:poner_2d@v),(c:dig@v)
	movff	(c:poner_2d@v+1),(c:dig@v+1)
	call	_dig	;wreg free
	movwf	indf2,c

	line	115
	
l172:
	return	;funcret
	callstack 0
GLOBAL	__end_of_poner_2d
	__end_of_poner_2d:
	signat	_poner_2d,8313
	global	_beep

;; *************** function _beep *****************
;; Defined at:
;;		line 108 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  t               2    5[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		None
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         2       0       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_cambiar_num_pisos
;;		_llamar_pasillo_piso
;;		_llamar_pasillo
;;		_encolar_destino_cabina
;;		_procesar_tecla
;;		_atender_llegada
;; This function uses a non-reentrant model
;;
psect	text34,class=CODE,space=0,reloc=2,group=0
	line	108
global __ptext34
__ptext34:
psect	text34
	file	"LOGIC_TEST.c"
	line	108
	
_beep:
;incstack = 0
	callstack 26
	
l6017:
	movff	(c:beep@t),(_cont_buzz)
	movff	(c:beep@t+1),(_cont_buzz+1)
	bsf	((c:3978))^0f00h,c,5	;volatile
	
l167:
	return	;funcret
	callstack 0
GLOBAL	__end_of_beep
	__end_of_beep:
	signat	_beep,4217
	global	_UART_EnviarEstado

;; *************** function _UART_EnviarEstado *****************
;; Defined at:
;;		line 309 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  ds              4   43[COMRAM] unsigned long 
;;  pk              4   39[COMRAM] unsigned long 
;;  e               2   51[COMRAM] int 
;;  p               2   49[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:        14       0       0       0       0       0       0       0       0
;;      Temps:          5       0       0       0       0       0       0       0       0
;;      Totals:        19       0       0       0       0       0       0       0       0
;;Total ram usage:       19 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_UART_Put2d
;;		_UART_PutChar
;;		_UART_PutHex5
;;		_UART_PutStr
;;		_UART_TxFree
;;		_estado_char
;;		_puerta_nivel
;; This function is called by:
;;		_cambiar_num_pisos
;;		_reiniciar_sistema
;;		_llamar_pasillo_piso
;;		_encolar_destino_cabina
;;		_procesar_tecla
;;		_atender_llegada
;;		_actualizar_todo
;;		_main
;; This function uses a non-reentrant model
;;
psect	text35,class=CODE,space=0,reloc=2,group=0
	line	309
global __ptext35
__ptext35:
psect	text35
	file	"LOGIC_TEST.c"
	line	309
	
_UART_EnviarEstado:
;incstack = 0
	callstack 26
	line	312
	
l6089:
	call	_UART_TxFree	;wreg free
	movwf	(??_UART_EnviarEstado+0)^00h,c
		movlw	048h-0
	cpfslt	((??_UART_EnviarEstado+0))^00h,c
	goto	u8191
	goto	u8190

u8191:
	goto	l6093
u8190:
	goto	l331
	line	313
	
l6093:; BSR set to: 0

		movlw	low(STR_11)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_11)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	314
	
l6095:
	clrf	((c:UART_EnviarEstado@e+1))^00h,c
	movlw	low(0)
	movwf	((c:UART_EnviarEstado@e))^00h,c
	line	315
	
l6101:
	movf	((c:UART_EnviarEstado@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_piso)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:UART_Put2d@v)
	movff	postdec2,(c:UART_Put2d@v+1)
	call	_UART_Put2d	;wreg free
	line	316
	movff	(c:UART_EnviarEstado@e),(c:estado_char@e)
	movff	(c:UART_EnviarEstado@e+1),(c:estado_char@e+1)
	call	_estado_char	;wreg free
	
	call	_UART_PutChar
	line	317
	movf	((c:UART_EnviarEstado@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_objetivo)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:UART_Put2d@v)
	movff	postdec2,(c:UART_Put2d@v+1)
	call	_UART_Put2d	;wreg free
	line	318
	movff	(c:UART_EnviarEstado@e),(c:puerta_nivel@e)
	movff	(c:UART_EnviarEstado@e+1),(c:puerta_nivel@e+1)
	call	_puerta_nivel	;wreg free
	
	call	_UART_PutChar
	line	319
	
l6103:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	320
	
l6105:; BSR set to: 0

	infsnz	((c:UART_EnviarEstado@e))^00h,c
	incf	((c:UART_EnviarEstado@e+1))^00h,c
	
l6107:; BSR set to: 0

	btfsc	((c:UART_EnviarEstado@e+1))^00h,c,7
	goto	u8201
	movf	((c:UART_EnviarEstado@e+1))^00h,c,w
	bnz	u8200
	movlw	3
	subwf	 ((c:UART_EnviarEstado@e))^00h,c,w
	btfss	status,0
	goto	u8201
	goto	u8200

u8201:
	goto	l6101
u8200:
	line	321
	
l6109:; BSR set to: 0

	movf	((c:_emergencia))^00h,c,w
	btfss	status,2
	goto	u8211
	goto	u8210
u8211:
	goto	l6113
u8210:
	
l6111:; BSR set to: 0

	clrf	((c:_UART_EnviarEstado$1041+1))^00h,c
	movlw	low(030h)
	movwf	((c:_UART_EnviarEstado$1041))^00h,c
	goto	l6115
	
l6113:; BSR set to: 0

	clrf	((c:_UART_EnviarEstado$1041+1))^00h,c
	movlw	low(031h)
	movwf	((c:_UART_EnviarEstado$1041))^00h,c
	
l6115:; BSR set to: 0

	movf	((c:_UART_EnviarEstado$1041))^00h,c,w
	
	call	_UART_PutChar
	line	322
	
l6117:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	323
	
l6119:; BSR set to: 0

	movff	(c:_num_pisos),(c:UART_Put2d@v)
	movff	(c:_num_pisos+1),(c:UART_Put2d@v+1)
	call	_UART_Put2d	;wreg free
	line	324
	
l6121:; BSR set to: 0

	clrf	((c:UART_EnviarEstado@e+1))^00h,c
	movlw	low(0)
	movwf	((c:UART_EnviarEstado@e))^00h,c
	line	325
	
l6127:; BSR set to: 0

	movlw	low(0)
	movwf	((c:UART_EnviarEstado@pk))^00h,c
	movlw	high(0)
	movwf	((c:UART_EnviarEstado@pk+1))^00h,c
	movlw	low highword(0)
	movwf	((c:UART_EnviarEstado@pk+2))^00h,c
	movlw	high highword(0)
	movwf	((c:UART_EnviarEstado@pk+3))^00h,c
	movlw	low(0)
	movwf	((c:UART_EnviarEstado@ds))^00h,c
	movlw	high(0)
	movwf	((c:UART_EnviarEstado@ds+1))^00h,c
	movlw	low highword(0)
	movwf	((c:UART_EnviarEstado@ds+2))^00h,c
	movlw	high highword(0)
	movwf	((c:UART_EnviarEstado@ds+3))^00h,c
	line	326
	clrf	((c:UART_EnviarEstado@p+1))^00h,c
	movlw	low(01h)
	movwf	((c:UART_EnviarEstado@p))^00h,c
	goto	l6139
	line	327
	
l6129:
	movlw	low(015h)
	mulwf	((c:UART_EnviarEstado@e))^00h,c
	movff	prodl,??_UART_EnviarEstado+0
	movff	prodh,??_UART_EnviarEstado+0+1
	mulwf	((c:UART_EnviarEstado@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_UART_EnviarEstado+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_UART_EnviarEstado+0)^00h,c,w
	movwf	(??_UART_EnviarEstado+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_UART_EnviarEstado+0+1)^00h,c,w
	movwf	1+(??_UART_EnviarEstado+2)^00h,c
	movf	((c:UART_EnviarEstado@p))^00h,c,w
	addwf	(??_UART_EnviarEstado+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:UART_EnviarEstado@p+1))^00h,c,w
	addwfc	(??_UART_EnviarEstado+2+1)^00h,c,w
	movwf	1+c:fsr2l
	movf	indf2,w
	movwf	(??_UART_EnviarEstado+4)^00h,c
	movlw	03h
	andwf	((??_UART_EnviarEstado+4))^00h,c
	btfsc	status,2
	goto	u8221
	goto	u8220
u8221:
	goto	l6133
u8220:
	
l6131:
	movff	(c:UART_EnviarEstado@p),??_UART_EnviarEstado+0
	movlw	-1
	addwf	(??_UART_EnviarEstado+0)^00h,c
	movlw	01h
	movwf	(??_UART_EnviarEstado+1)^00h,c
	clrf	(??_UART_EnviarEstado+1+1)^00h,c
	clrf	(??_UART_EnviarEstado+1+2)^00h,c
	clrf	(??_UART_EnviarEstado+1+3)^00h,c
	incf	(??_UART_EnviarEstado+0)^00h,c
	goto	u8230
u8235:
	bcf	status,0
	rlcf	(??_UART_EnviarEstado+1)^00h,c
	rlcf	(??_UART_EnviarEstado+1+1)^00h,c
	rlcf	(??_UART_EnviarEstado+1+2)^00h,c
	rlcf	(??_UART_EnviarEstado+1+3)^00h,c
u8230:
	decfsz	(??_UART_EnviarEstado+0)^00h,c
	goto	u8235
	movf	(??_UART_EnviarEstado+1)^00h,c,w
	iorwf	((c:UART_EnviarEstado@pk))^00h,c
	movf	(??_UART_EnviarEstado+1+1)^00h,c,w
	iorwf	((c:UART_EnviarEstado@pk+1))^00h,c
	movf	(??_UART_EnviarEstado+1+2)^00h,c,w
	iorwf	((c:UART_EnviarEstado@pk+2))^00h,c
	movf	(??_UART_EnviarEstado+1+3)^00h,c,w
	iorwf	((c:UART_EnviarEstado@pk+3))^00h,c

	line	328
	
l6133:
	movlw	low(015h)
	mulwf	((c:UART_EnviarEstado@e))^00h,c
	movff	prodl,??_UART_EnviarEstado+0
	movff	prodh,??_UART_EnviarEstado+0+1
	mulwf	((c:UART_EnviarEstado@e+1))^00h,c
	movf	(prodl),c,w
	addwf	(??_UART_EnviarEstado+0+1)^00h,c,f
	movlw	low(_paradas)
	addwf	(??_UART_EnviarEstado+0)^00h,c,w
	movwf	(??_UART_EnviarEstado+2)^00h,c
	movlw	high(_paradas)
	addwfc	(??_UART_EnviarEstado+0+1)^00h,c,w
	movwf	1+(??_UART_EnviarEstado+2)^00h,c
	movf	((c:UART_EnviarEstado@p))^00h,c,w
	addwf	(??_UART_EnviarEstado+2)^00h,c,w
	movwf	c:fsr2l
	movf	((c:UART_EnviarEstado@p+1))^00h,c,w
	addwfc	(??_UART_EnviarEstado+2+1)^00h,c,w
	movwf	1+c:fsr2l
	btfss	indf2,(2)&7
	goto	u8241
	goto	u8240
u8241:
	goto	l6137
u8240:
	
l6135:
	movff	(c:UART_EnviarEstado@p),??_UART_EnviarEstado+0
	movlw	-1
	addwf	(??_UART_EnviarEstado+0)^00h,c
	movlw	01h
	movwf	(??_UART_EnviarEstado+1)^00h,c
	clrf	(??_UART_EnviarEstado+1+1)^00h,c
	clrf	(??_UART_EnviarEstado+1+2)^00h,c
	clrf	(??_UART_EnviarEstado+1+3)^00h,c
	incf	(??_UART_EnviarEstado+0)^00h,c
	goto	u8250
u8255:
	bcf	status,0
	rlcf	(??_UART_EnviarEstado+1)^00h,c
	rlcf	(??_UART_EnviarEstado+1+1)^00h,c
	rlcf	(??_UART_EnviarEstado+1+2)^00h,c
	rlcf	(??_UART_EnviarEstado+1+3)^00h,c
u8250:
	decfsz	(??_UART_EnviarEstado+0)^00h,c
	goto	u8255
	movf	(??_UART_EnviarEstado+1)^00h,c,w
	iorwf	((c:UART_EnviarEstado@ds))^00h,c
	movf	(??_UART_EnviarEstado+1+1)^00h,c,w
	iorwf	((c:UART_EnviarEstado@ds+1))^00h,c
	movf	(??_UART_EnviarEstado+1+2)^00h,c,w
	iorwf	((c:UART_EnviarEstado@ds+2))^00h,c
	movf	(??_UART_EnviarEstado+1+3)^00h,c,w
	iorwf	((c:UART_EnviarEstado@ds+3))^00h,c

	line	329
	
l6137:
	infsnz	((c:UART_EnviarEstado@p))^00h,c
	incf	((c:UART_EnviarEstado@p+1))^00h,c
	
l6139:
		movf	((c:UART_EnviarEstado@p))^00h,c,w
	subwf	((c:_num_pisos))^00h,c,w
	movf	((c:_num_pisos+1))^00h,c,w
	xorlw	80h
	movwf	(??_UART_EnviarEstado+0)^00h,c
	movf	((c:UART_EnviarEstado@p+1))^00h,c,w
	xorlw	80h
	subwfb	(??_UART_EnviarEstado+0)^00h,c,w
	btfsc	status,0
	goto	u8261
	goto	u8260

u8261:
	goto	l6129
u8260:
	line	330
	
l6141:
	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	331
	
l6143:; BSR set to: 0

	movff	(c:UART_EnviarEstado@pk),(c:UART_PutHex5@mask)
	movff	(c:UART_EnviarEstado@pk+1),(c:UART_PutHex5@mask+1)
	movff	(c:UART_EnviarEstado@pk+2),(c:UART_PutHex5@mask+2)
	movff	(c:UART_EnviarEstado@pk+3),(c:UART_PutHex5@mask+3)
	call	_UART_PutHex5	;wreg free
	line	332
	
l6145:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	333
	movff	(c:UART_EnviarEstado@ds),(c:UART_PutHex5@mask)
	movff	(c:UART_EnviarEstado@ds+1),(c:UART_PutHex5@mask+1)
	movff	(c:UART_EnviarEstado@ds+2),(c:UART_PutHex5@mask+2)
	movff	(c:UART_EnviarEstado@ds+3),(c:UART_PutHex5@mask+3)
	call	_UART_PutHex5	;wreg free
	line	334
	
l6147:; BSR set to: 0

	infsnz	((c:UART_EnviarEstado@e))^00h,c
	incf	((c:UART_EnviarEstado@e+1))^00h,c
	
l6149:; BSR set to: 0

	btfsc	((c:UART_EnviarEstado@e+1))^00h,c,7
	goto	u8271
	movf	((c:UART_EnviarEstado@e+1))^00h,c,w
	bnz	u8270
	movlw	3
	subwf	 ((c:UART_EnviarEstado@e))^00h,c,w
	btfss	status,0
	goto	u8271
	goto	u8270

u8271:
	goto	l6127
u8270:
	line	335
	
l6151:; BSR set to: 0

		movlw	low(STR_12)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_12)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	336
	
l331:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_EnviarEstado
	__end_of_UART_EnviarEstado:
	signat	_UART_EnviarEstado,89
	global	_puerta_nivel

;; *************** function _puerta_nivel *****************
;; Defined at:
;;		line 252 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2   15[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  r               2   23[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         6       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:        10       0       0       0       0       0       0       0       0
;;Total ram usage:       10 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		___awdiv
;;		_dig
;; This function is called by:
;;		_UART_EnviarEstado
;; This function uses a non-reentrant model
;;
psect	text36,class=CODE,space=0,reloc=2,group=0
	line	252
global __ptext36
__ptext36:
psect	text36
	file	"LOGIC_TEST.c"
	line	252
	
_puerta_nivel:
;incstack = 0
	callstack 24
	line	254
	
l5955:; BSR set to: 0

	movf	((c:puerta_nivel@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfsc	status,2
	goto	u8041
	goto	u8040

u8041:
	goto	l5959
u8040:
	
l5957:; BSR set to: 0

	movf	((c:puerta_nivel@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8051
	goto	u8050

u8051:
	goto	l5963
u8050:
	
l5959:; BSR set to: 0

	movlw	(030h)&0ffh
	goto	l289
	line	255
	
l5963:; BSR set to: 0

	movf	((c:puerta_nivel@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	2
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8061
	goto	u8060

u8061:
	goto	l5985
u8060:
	line	256
	
l5965:; BSR set to: 0

	movf	((c:puerta_nivel@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_encolados)
	movwf	fsr2l
	clrf	fsr2h
	movf	postinc2,w
iorwf	postinc2,w
	btfsc	status,2
	goto	u8071
	goto	u8070

u8071:
	goto	l5969
u8070:
	
l5967:; BSR set to: 0

	movf	((c:puerta_nivel@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movlw	1
	btfsc	plusw2,7
	goto	u8081
	movlw	1
	movf	plusw2,w
	bnz	u8080
	movlw	46
	subwf	 postinc2,w
	btfss	status,0
	goto	u8081
	goto	u8080

u8081:
	goto	l5973
u8080:
	
l5969:; BSR set to: 0

	movlw	(039h)&0ffh
	goto	l289
	line	257
	
l5973:; BSR set to: 0

	movf	((c:puerta_nivel@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:___awdiv@dividend)
	movff	postdec2,(c:___awdiv@dividend+1)
	clrf	((c:___awdiv@divisor+1))^00h,c
	movlw	low(05h)
	movwf	((c:___awdiv@divisor))^00h,c
	call	___awdiv	;wreg free
	movff	0+?___awdiv,(c:puerta_nivel@r)
	movff	1+?___awdiv,(c:puerta_nivel@r+1)
	line	258
	
l5975:
	btfsc	((c:puerta_nivel@r+1))^00h,c,7
	goto	u8090
	movf	((c:puerta_nivel@r+1))^00h,c,w
	bnz	u8091
	movlw	10
	subwf	 ((c:puerta_nivel@r))^00h,c,w
	btfsc	status,0
	goto	u8091
	goto	u8090

u8091:
	goto	l5979
u8090:
	
l5977:
	movff	(c:puerta_nivel@r),(c:_puerta_nivel$998)
	movff	(c:puerta_nivel@r+1),(c:_puerta_nivel$998+1)
	goto	l5981
	
l5979:
	clrf	((c:_puerta_nivel$998+1))^00h,c
	movlw	low(09h)
	movwf	((c:_puerta_nivel$998))^00h,c
	
l5981:
	movff	(c:_puerta_nivel$998),(c:dig@v)
	movff	(c:_puerta_nivel$998+1),(c:dig@v+1)
	call	_dig	;wreg free
	goto	l289
	line	260
	
l5985:; BSR set to: 0

	movf	((c:puerta_nivel@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	3
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8101
	goto	u8100

u8101:
	goto	l5959
u8100:
	line	261
	
l5987:; BSR set to: 0

	movf	((c:puerta_nivel@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movlw	1
	btfsc	plusw2,7
	goto	u8111
	movlw	1
	movf	plusw2,w
	bnz	u8110
	movlw	46
	subwf	 postinc2,w
	btfss	status,0
	goto	u8111
	goto	u8110

u8111:
	goto	l5993
u8110:
	goto	l5969
	line	262
	
l5993:; BSR set to: 0

	movf	((c:puerta_nivel@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_reloj_puerta)
	movwf	fsr2l
	clrf	fsr2h
	movff	postinc2,(c:___awdiv@dividend)
	movff	postdec2,(c:___awdiv@dividend+1)
	clrf	((c:___awdiv@divisor+1))^00h,c
	movlw	low(05h)
	movwf	((c:___awdiv@divisor))^00h,c
	call	___awdiv	;wreg free
	movff	0+?___awdiv,(c:puerta_nivel@r)
	movff	1+?___awdiv,(c:puerta_nivel@r+1)
	line	263
	
l5995:
	btfsc	((c:puerta_nivel@r+1))^00h,c,7
	goto	u8120
	movf	((c:puerta_nivel@r+1))^00h,c,w
	bnz	u8121
	movlw	10
	subwf	 ((c:puerta_nivel@r))^00h,c,w
	btfsc	status,0
	goto	u8121
	goto	u8120

u8121:
	goto	l5999
u8120:
	
l5997:
	movff	(c:puerta_nivel@r),(c:_puerta_nivel$999)
	movff	(c:puerta_nivel@r+1),(c:_puerta_nivel$999+1)
	goto	l6001
	
l5999:
	clrf	((c:_puerta_nivel$999+1))^00h,c
	movlw	low(09h)
	movwf	((c:_puerta_nivel$999))^00h,c
	
l6001:
	movff	(c:_puerta_nivel$999),(c:dig@v)
	movff	(c:_puerta_nivel$999+1),(c:dig@v+1)
	call	_dig	;wreg free
	line	266
	
l289:
	return	;funcret
	callstack 0
GLOBAL	__end_of_puerta_nivel
	__end_of_puerta_nivel:
	signat	_puerta_nivel,4217
	global	_estado_char

;; *************** function _estado_char *****************
;; Defined at:
;;		line 244 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  e               2    5[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, prodl, prodh
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 3F/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         6       0       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_UART_EnviarEstado
;; This function uses a non-reentrant model
;;
psect	text37,class=CODE,space=0,reloc=2,group=0
	line	244
global __ptext37
__ptext37:
psect	text37
	file	"LOGIC_TEST.c"
	line	244
	
_estado_char:
;incstack = 0
	callstack 25
	line	245
	
l5923:; BSR set to: 0

	movf	((c:_emergencia))^00h,c,w
	btfsc	status,2
	goto	u7991
	goto	u7990
u7991:
	goto	l5929
u7990:
	
l5925:; BSR set to: 0

	movlw	(045h)&0ffh
	goto	l276
	line	246
	
l5929:; BSR set to: 0

	movf	((c:estado_char@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8001
	goto	u8000

u8001:
	goto	l5939
u8000:
	
l5931:; BSR set to: 0

	movf	((c:estado_char@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_direccion)
	movwf	fsr2l
	clrf	fsr2h
	decf	postinc2,w
iorwf	postinc2,w
	btfsc	status,2
	goto	u8011
	goto	u8010

u8011:
	goto	l5935
u8010:
	
l5933:; BSR set to: 0

	clrf	((c:_estado_char$994+1))^00h,c
	movlw	low(044h)
	movwf	((c:_estado_char$994))^00h,c
	goto	l281
	
l5935:; BSR set to: 0

	clrf	((c:_estado_char$994+1))^00h,c
	movlw	low(055h)
	movwf	((c:_estado_char$994))^00h,c
	
l281:; BSR set to: 0

	movf	((c:_estado_char$994))^00h,c,w
	goto	l276
	line	247
	
l5939:; BSR set to: 0

	movf	((c:estado_char@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	2
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8021
	goto	u8020

u8021:
	goto	l5945
u8020:
	
l5941:; BSR set to: 0

	movlw	(057h)&0ffh
	goto	l276
	line	248
	
l5945:; BSR set to: 0

	movf	((c:estado_char@e))^00h,c,w
	mullw	02h
	movf	(prodl)^0f00h,c,w
	addlw	low(_estado)
	movwf	fsr2l
	clrf	fsr2h
	movlw	3
	xorwf	postinc2,w
iorwf	postinc2,w
	btfss	status,2
	goto	u8031
	goto	u8030

u8031:
	goto	l5951
u8030:
	
l5947:; BSR set to: 0

	movlw	(04Fh)&0ffh
	goto	l276
	line	249
	
l5951:; BSR set to: 0

	movlw	(049h)&0ffh
	line	250
	
l276:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_estado_char
	__end_of_estado_char:
	signat	_estado_char,4217
	global	_UART_PutHex5

;; *************** function _UART_PutHex5 *****************
;; Defined at:
;;		line 229 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  mask            4   27[COMRAM] unsigned long 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         4       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          3       0       0       0       0       0       0       0       0
;;      Totals:         7       0       0       0       0       0       0       0       0
;;Total ram usage:        7 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 2
;; This function calls:
;;		_UART_PutChar
;; This function is called by:
;;		_UART_EnviarEstado
;; This function uses a non-reentrant model
;;
psect	text38,class=CODE,space=0,reloc=2,group=0
	line	229
global __ptext38
__ptext38:
psect	text38
	file	"LOGIC_TEST.c"
	line	229
	
_UART_PutHex5:; BSR set to: 0

;incstack = 0
	callstack 24
	line	231
	
l5921:; BSR set to: 0

	movlw	0Fh
	andwf	(0+((c:UART_PutHex5@mask)+02h))^00h,c,w
	movwf	(??_UART_PutHex5+0)^00h,c
	movlw	0
	andwf	(1+((c:UART_PutHex5@mask)+02h))^00h,c,w
	movwf	(??_UART_PutHex5+0+1)^00h,c
	movlw	low((UART_PutHex5@HEX))
	addwf	(??_UART_PutHex5+0)^00h,c,w
	movwf	tblptrl
	movlw	high((UART_PutHex5@HEX))
	addwfc	(??_UART_PutHex5+0+1)^00h,c,w
	movwf	tblptrh
	if	0	;There are less than 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd	*
	
	movf	tablat,w
	
	call	_UART_PutChar
	line	232
	movff	(c:UART_PutHex5@mask),??_UART_PutHex5+0
	movff	(c:UART_PutHex5@mask+1),??_UART_PutHex5+0+1
	movlw	0Ch
	movwf	(??_UART_PutHex5+2)^00h,c
u7975:
	bcf	status,0
	rrcf	(??_UART_PutHex5+0+1)^00h,c
	rrcf	(??_UART_PutHex5+0)^00h,c
	decfsz	(??_UART_PutHex5+2)^00h,c
	goto	u7975
	movlw	0Fh
	andwf	(??_UART_PutHex5+0)^00h,c
	movlw	0
	andwf	(??_UART_PutHex5+0+1)^00h,c
	movlw	low((UART_PutHex5@HEX))
	addwf	(??_UART_PutHex5+0)^00h,c,w
	movwf	tblptrl
	movlw	high((UART_PutHex5@HEX))
	addwfc	(??_UART_PutHex5+0+1)^00h,c,w
	movwf	tblptrh
	if	0	;There are less than 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd	*
	
	movf	tablat,w
	
	call	_UART_PutChar
	line	233
	movlw	0Fh
	andwf	(0+((c:UART_PutHex5@mask)+01h))^00h,c,w
	movwf	(??_UART_PutHex5+0)^00h,c
	movlw	0
	andwf	(1+((c:UART_PutHex5@mask)+01h))^00h,c,w
	movwf	(??_UART_PutHex5+0+1)^00h,c
	movlw	low((UART_PutHex5@HEX))
	addwf	(??_UART_PutHex5+0)^00h,c,w
	movwf	tblptrl
	movlw	high((UART_PutHex5@HEX))
	addwfc	(??_UART_PutHex5+0+1)^00h,c,w
	movwf	tblptrh
	if	0	;There are less than 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd	*
	
	movf	tablat,w
	
	call	_UART_PutChar
	line	234
	movff	(c:UART_PutHex5@mask),??_UART_PutHex5+0
	movff	(c:UART_PutHex5@mask+1),??_UART_PutHex5+0+1
	movlw	04h
	movwf	(??_UART_PutHex5+2)^00h,c
u7985:
	bcf	status,0
	rrcf	(??_UART_PutHex5+0+1)^00h,c
	rrcf	(??_UART_PutHex5+0)^00h,c
	decfsz	(??_UART_PutHex5+2)^00h,c
	goto	u7985
	movlw	0Fh
	andwf	(??_UART_PutHex5+0)^00h,c
	movlw	0
	andwf	(??_UART_PutHex5+0+1)^00h,c
	movlw	low((UART_PutHex5@HEX))
	addwf	(??_UART_PutHex5+0)^00h,c,w
	movwf	tblptrl
	movlw	high((UART_PutHex5@HEX))
	addwfc	(??_UART_PutHex5+0+1)^00h,c,w
	movwf	tblptrh
	if	0	;There are less than 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd	*
	
	movf	tablat,w
	
	call	_UART_PutChar
	line	235
	movlw	0Fh
	andwf	((c:UART_PutHex5@mask))^00h,c,w
	movwf	(??_UART_PutHex5+0)^00h,c
	movlw	0
	andwf	((c:UART_PutHex5@mask+1))^00h,c,w
	movwf	(??_UART_PutHex5+0+1)^00h,c
	movlw	low((UART_PutHex5@HEX))
	addwf	(??_UART_PutHex5+0)^00h,c,w
	movwf	tblptrl
	movlw	high((UART_PutHex5@HEX))
	addwfc	(??_UART_PutHex5+0+1)^00h,c,w
	movwf	tblptrh
	if	0	;There are less than 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd	*
	
	movf	tablat,w
	
	call	_UART_PutChar
	line	236
	
l268:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_PutHex5
	__end_of_UART_PutHex5:
	signat	_UART_PutHex5,4217
	global	_UART_EmitCfg

;; *************** function _UART_EmitCfg *****************
;; Defined at:
;;		line 295 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  n               2   38[COMRAM] int 
;;  podadas         2   40[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 0/1
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         4       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:         5       0       0       0       0       0       0       0       0
;;Total ram usage:        5 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 3
;; This function calls:
;;		_UART_Put2d
;;		_UART_PutChar
;;		_UART_PutInt
;;		_UART_PutStr
;;		_UART_TxFree
;; This function is called by:
;;		_cambiar_num_pisos
;; This function uses a non-reentrant model
;;
psect	text39,class=CODE,space=0,reloc=2,group=0
	line	295
global __ptext39
__ptext39:
psect	text39
	file	"LOGIC_TEST.c"
	line	295
	
_UART_EmitCfg:; BSR set to: 0

;incstack = 0
	callstack 25
	line	296
	
l6489:
	call	_UART_TxFree	;wreg free
	movwf	(??_UART_EmitCfg+0)^00h,c
		movlw	012h-0
	cpfslt	((??_UART_EmitCfg+0))^00h,c
	goto	u8921
	goto	u8920

u8921:
	goto	l6493
u8920:
	goto	l319
	line	297
	
l6493:; BSR set to: 0

		movlw	low(STR_7)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_7)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	298
	
l6495:
	movff	(c:UART_EmitCfg@n),(c:UART_Put2d@v)
	movff	(c:UART_EmitCfg@n+1),(c:UART_Put2d@v+1)
	call	_UART_Put2d	;wreg free
	
l6497:; BSR set to: 0

	movlw	(02Ch)&0ffh
	
	call	_UART_PutChar
	line	299
	
l6499:; BSR set to: 0

	movff	(c:UART_EmitCfg@podadas),(c:UART_PutInt@v)
	movff	(c:UART_EmitCfg@podadas+1),(c:UART_PutInt@v+1)
	call	_UART_PutInt	;wreg free
	
l6501:
		movlw	low(STR_8)
	movwf	((c:UART_PutStr@s))^00h,c
	movlw	high(STR_8)
	movwf	((c:UART_PutStr@s+1))^00h,c

	call	_UART_PutStr	;wreg free
	line	300
	
l319:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_EmitCfg
	__end_of_UART_EmitCfg:
	signat	_UART_EmitCfg,8313
	global	_UART_TxFree

;; *************** function _UART_TxFree *****************
;; Defined at:
;;		line 198 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:         1       0       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_UART_EmitEnq
;;		_UART_EmitDeq
;;		_UART_EmitDsp
;;		_UART_EmitCfg
;;		_UART_EmitEmg
;;		_UART_EnviarEstado
;;		_reiniciar_sistema
;; This function uses a non-reentrant model
;;
psect	text40,class=CODE,space=0,reloc=2,group=0
	line	198
global __ptext40
__ptext40:
psect	text40
	file	"LOGIC_TEST.c"
	line	198
	
_UART_TxFree:
;incstack = 0
	callstack 25
	line	199
	
l5869:
	movlb	0	; () banked
	movf	((_tx_head))&0ffh,w
	subwf	((_tx_tail))&0ffh,w
	movwf	(??_UART_TxFree+0)^00h,c
	decf	((??_UART_TxFree+0))^00h,c,w
	line	200
	
l235:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_TxFree
	__end_of_UART_TxFree:
	signat	_UART_TxFree,89
	global	_UART_PutStr

;; *************** function _UART_PutStr *****************
;; Defined at:
;;		line 209 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  s               2   27[COMRAM] PTR const unsigned char 
;;		 -> STR_15(8), STR_12(3), STR_11(3), STR_10(3), 
;;		 -> STR_9(7), STR_8(3), STR_7(7), STR_6(3), 
;;		 -> STR_5(7), STR_4(3), STR_3(7), STR_2(3), 
;;		 -> STR_1(7), 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         2       0       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_UART_PutChar
;; This function is called by:
;;		_UART_EmitEnq
;;		_UART_EmitDeq
;;		_UART_EmitDsp
;;		_UART_EmitCfg
;;		_UART_EmitEmg
;;		_UART_EnviarEstado
;;		_reiniciar_sistema
;; This function uses a non-reentrant model
;;
psect	text41,class=CODE,space=0,reloc=2,group=0
	line	209
global __ptext41
__ptext41:
psect	text41
	file	"LOGIC_TEST.c"
	line	209
	
_UART_PutStr:; BSR set to: 0

;incstack = 0
	callstack 25
	line	210
	
l5873:
	goto	l5879
	
l5875:
	movff	(c:UART_PutStr@s),tblptrl
	movff	(c:UART_PutStr@s+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	
	call	_UART_PutChar
	
l5877:; BSR set to: 0

	infsnz	((c:UART_PutStr@s))^00h,c
	incf	((c:UART_PutStr@s+1))^00h,c
	
l5879:
	movff	(c:UART_PutStr@s),tblptrl
	movff	(c:UART_PutStr@s+1),tblptrh
	if	0	;tblptru may be non-zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	iorlw	0
	btfss	status,2
	goto	u7891
	goto	u7890
u7891:
	goto	l5875
u7890:
	line	211
	
l245:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_PutStr
	__end_of_UART_PutStr:
	signat	_UART_PutStr,4217
	global	_UART_PutInt

;; *************** function _UART_PutInt *****************
;; Defined at:
;;		line 220 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  v               2   27[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  tmp             7   29[COMRAM] unsigned char [7]
;;  i               2   36[COMRAM] int 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 3F/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         9       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:        11       0       0       0       0       0       0       0       0
;;Total ram usage:       11 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_UART_PutChar
;;		___awdiv
;;		_dig
;; This function is called by:
;;		_UART_EmitDsp
;;		_UART_EmitCfg
;; This function uses a non-reentrant model
;;
psect	text42,class=CODE,space=0,reloc=2,group=0
	line	220
global __ptext42
__ptext42:
psect	text42
	file	"LOGIC_TEST.c"
	line	220
	
_UART_PutInt:
;incstack = 0
	callstack 25
	line	222
	
l5893:; BSR set to: 0

	clrf	((c:UART_PutInt@i+1))^00h,c
	movlw	low(0)
	movwf	((c:UART_PutInt@i))^00h,c
	line	223
	
l5895:; BSR set to: 0

	btfsc	((c:UART_PutInt@v+1))^00h,c,7
	goto	u7920
	goto	u7921

u7921:
	goto	l5901
u7920:
	
l5897:; BSR set to: 0

	movlw	(02Dh)&0ffh
	
	call	_UART_PutChar
	
l5899:; BSR set to: 0

	negf	((c:UART_PutInt@v))^00h,c
	comf	((c:UART_PutInt@v+1))^00h,c
	btfsc	status,0
	incf	((c:UART_PutInt@v+1))^00h,c
	line	224
	
l5901:; BSR set to: 0

	movf	((c:UART_PutInt@v))^00h,c,w
iorwf	((c:UART_PutInt@v+1))^00h,c,w
	btfss	status,2
	goto	u7931
	goto	u7930

u7931:
	goto	l5913
u7930:
	
l5903:; BSR set to: 0

	movlw	(030h)&0ffh
	
	call	_UART_PutChar
	goto	l255
	line	225
	
l5907:
	movf	((c:UART_PutInt@i))^00h,c,w
	addlw	low(UART_PutInt@tmp)
	movwf	fsr2l
	clrf	fsr2h
	movff	(c:UART_PutInt@v),(c:dig@v)
	movff	(c:UART_PutInt@v+1),(c:dig@v+1)
	call	_dig	;wreg free
	movwf	indf2,c

	
l5909:
	infsnz	((c:UART_PutInt@i))^00h,c
	incf	((c:UART_PutInt@i+1))^00h,c
	
l5911:
	movff	(c:UART_PutInt@v),(c:___awdiv@dividend)
	movff	(c:UART_PutInt@v+1),(c:___awdiv@dividend+1)
	clrf	((c:___awdiv@divisor+1))^00h,c
	movlw	low(0Ah)
	movwf	((c:___awdiv@divisor))^00h,c
	call	___awdiv	;wreg free
	movff	0+?___awdiv,(c:UART_PutInt@v)
	movff	1+?___awdiv,(c:UART_PutInt@v+1)
	
l5913:
	btfsc	((c:UART_PutInt@v+1))^00h,c,7
	goto	u7941
	movf	((c:UART_PutInt@v+1))^00h,c,w
	bnz	u7940
	decf	((c:UART_PutInt@v))^00h,c,w
	btfss	status,0
	goto	u7941
	goto	u7940

u7941:
	goto	l5919
u7940:
	
l5915:
	btfsc	((c:UART_PutInt@i+1))^00h,c,7
	goto	u7951
	movf	((c:UART_PutInt@i+1))^00h,c,w
	bnz	u7950
	movlw	6
	subwf	 ((c:UART_PutInt@i))^00h,c,w
	btfss	status,0
	goto	u7951
	goto	u7950

u7951:
	goto	l5907
u7950:
	goto	l5919
	line	226
	
l5917:
	decf	((c:UART_PutInt@i))^00h,c
	btfss	status,0
	decf	((c:UART_PutInt@i+1))^00h,c
	movf	((c:UART_PutInt@i))^00h,c,w
	addlw	low(UART_PutInt@tmp)
	movwf	fsr2l
	clrf	fsr2h
	movf	indf2,w
	
	call	_UART_PutChar
	
l5919:
	btfsc	((c:UART_PutInt@i+1))^00h,c,7
	goto	u7960
	movf	((c:UART_PutInt@i+1))^00h,c,w
	bnz	u7961
	decf	((c:UART_PutInt@i))^00h,c,w
	btfsc	status,0
	goto	u7961
	goto	u7960

u7961:
	goto	l5917
u7960:
	line	227
	
l255:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_PutInt
	__end_of_UART_PutInt:
	signat	_UART_PutInt,4217
	global	_UART_Put2d

;; *************** function _UART_Put2d *****************
;; Defined at:
;;		line 213 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  v               2   27[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         2       0       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_UART_PutChar
;;		___awdiv
;;		_dig
;; This function is called by:
;;		_UART_EmitEnq
;;		_UART_EmitDeq
;;		_UART_EmitDsp
;;		_UART_EmitCfg
;;		_UART_EnviarEstado
;; This function uses a non-reentrant model
;;
psect	text43,class=CODE,space=0,reloc=2,group=0
	line	213
global __ptext43
__ptext43:
psect	text43
	file	"LOGIC_TEST.c"
	line	213
	
_UART_Put2d:
;incstack = 0
	callstack 25
	line	214
	
l5881:
	btfsc	((c:UART_Put2d@v+1))^00h,c,7
	goto	u7900
	goto	u7901

u7901:
	goto	l5885
u7900:
	
l5883:
	clrf	((c:UART_Put2d@v+1))^00h,c
	movlw	low(0)
	movwf	((c:UART_Put2d@v))^00h,c
	line	215
	
l5885:
	btfsc	((c:UART_Put2d@v+1))^00h,c,7
	goto	u7911
	movf	((c:UART_Put2d@v+1))^00h,c,w
	bnz	u7910
	movlw	100
	subwf	 ((c:UART_Put2d@v))^00h,c,w
	btfss	status,0
	goto	u7911
	goto	u7910

u7911:
	goto	l5889
u7910:
	
l5887:
	clrf	((c:UART_Put2d@v+1))^00h,c
	movlw	low(063h)
	movwf	((c:UART_Put2d@v))^00h,c
	line	216
	
l5889:
	movff	(c:UART_Put2d@v),(c:___awdiv@dividend)
	movff	(c:UART_Put2d@v+1),(c:___awdiv@dividend+1)
	clrf	((c:___awdiv@divisor+1))^00h,c
	movlw	low(0Ah)
	movwf	((c:___awdiv@divisor))^00h,c
	call	___awdiv	;wreg free
	movff	0+?___awdiv,(c:dig@v)
	movff	1+?___awdiv,(c:dig@v+1)
	call	_dig	;wreg free
	
	call	_UART_PutChar
	line	217
	
l5891:; BSR set to: 0

	movff	(c:UART_Put2d@v),(c:dig@v)
	movff	(c:UART_Put2d@v+1),(c:dig@v+1)
	call	_dig	;wreg free
	
	call	_UART_PutChar
	line	218
	
l250:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_Put2d
	__end_of_UART_Put2d:
	signat	_UART_Put2d,4217
	global	_dig

;; *************** function _dig *****************
;; Defined at:
;;		line 106 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  v               2   13[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         2       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         2       0       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		___awmod
;; This function is called by:
;;		_poner_2d
;;		_msg_elev
;;		_UART_Put2d
;;		_UART_PutInt
;;		_puerta_nivel
;;		_UART_EmitEnq
;;		_UART_EmitDeq
;;		_UART_EmitDsp
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text44,class=CODE,space=0,reloc=2,group=0
	line	106
global __ptext44
__ptext44:
psect	text44
	file	"LOGIC_TEST.c"
	line	106
	
_dig:; BSR set to: 0

;incstack = 0
	callstack 24
	
l5773:
	movff	(c:dig@v),(c:___awmod@dividend)
	movff	(c:dig@v+1),(c:___awmod@dividend+1)
	clrf	((c:___awmod@divisor+1))^00h,c
	movlw	low(0Ah)
	movwf	((c:___awmod@divisor))^00h,c
	call	___awmod	;wreg free
	movf	(0+?___awmod)^00h,c,w
	addlw	low(030h)
	
l157:
	return	;funcret
	callstack 0
GLOBAL	__end_of_dig
	__end_of_dig:
	signat	_dig,4217
	global	___awmod

;; *************** function ___awmod *****************
;; Defined at:
;;		line 7 in file "D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\awmod.c"
;; Parameters:    Size  Location     Type
;;  dividend        2    5[COMRAM] int 
;;  divisor         2    7[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  sign            1   10[COMRAM] unsigned char 
;;  counter         1    9[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  2    5[COMRAM] int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         4       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         6       0       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_dig
;; This function uses a non-reentrant model
;;
psect	text45,class=CODE,space=0,reloc=2,group=1
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\awmod.c"
	line	7
global __ptext45
__ptext45:
psect	text45
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\awmod.c"
	line	7
	
___awmod:
;incstack = 0
	callstack 23
	line	12
	
l5737:
	clrf	((c:___awmod@sign))^00h,c
	line	13
	
l5739:
	btfsc	((c:___awmod@dividend+1))^00h,c,7
	goto	u7670
	goto	u7671

u7671:
	goto	l5745
u7670:
	line	14
	
l5741:
	negf	((c:___awmod@dividend))^00h,c
	comf	((c:___awmod@dividend+1))^00h,c
	btfsc	status,0
	incf	((c:___awmod@dividend+1))^00h,c
	line	15
	
l5743:
	movlw	low(01h)
	movwf	((c:___awmod@sign))^00h,c
	line	17
	
l5745:
	btfsc	((c:___awmod@divisor+1))^00h,c,7
	goto	u7680
	goto	u7681

u7681:
	goto	l5749
u7680:
	line	18
	
l5747:
	negf	((c:___awmod@divisor))^00h,c
	comf	((c:___awmod@divisor+1))^00h,c
	btfsc	status,0
	incf	((c:___awmod@divisor+1))^00h,c
	line	19
	
l5749:
	movf	((c:___awmod@divisor))^00h,c,w
iorwf	((c:___awmod@divisor+1))^00h,c,w
	btfsc	status,2
	goto	u7691
	goto	u7690

u7691:
	goto	l5765
u7690:
	line	20
	
l5751:
	movlw	low(01h)
	movwf	((c:___awmod@counter))^00h,c
	line	21
	goto	l5755
	line	22
	
l5753:
	bcf	status,0
	rlcf	((c:___awmod@divisor))^00h,c
	rlcf	((c:___awmod@divisor+1))^00h,c
	line	23
	incf	((c:___awmod@counter))^00h,c
	line	21
	
l5755:
	
	btfss	((c:___awmod@divisor+1))^00h,c,(15)&7
	goto	u7701
	goto	u7700
u7701:
	goto	l5753
u7700:
	line	26
	
l5757:
		movf	((c:___awmod@divisor))^00h,c,w
	subwf	((c:___awmod@dividend))^00h,c,w
	movf	((c:___awmod@divisor+1))^00h,c,w
	subwfb	((c:___awmod@dividend+1))^00h,c,w
	btfss	status,0
	goto	u7711
	goto	u7710

u7711:
	goto	l5761
u7710:
	line	27
	
l5759:
	movf	((c:___awmod@divisor))^00h,c,w
	subwf	((c:___awmod@dividend))^00h,c
	movf	((c:___awmod@divisor+1))^00h,c,w
	subwfb	((c:___awmod@dividend+1))^00h,c

	line	28
	
l5761:
	bcf	status,0
	rrcf	((c:___awmod@divisor+1))^00h,c
	rrcf	((c:___awmod@divisor))^00h,c
	line	29
	
l5763:
	decfsz	((c:___awmod@counter))^00h,c
	
	goto	l5757
	line	31
	
l5765:
	movf	((c:___awmod@sign))^00h,c,w
	btfsc	status,2
	goto	u7721
	goto	u7720
u7721:
	goto	l5769
u7720:
	line	32
	
l5767:
	negf	((c:___awmod@dividend))^00h,c
	comf	((c:___awmod@dividend+1))^00h,c
	btfsc	status,0
	incf	((c:___awmod@dividend+1))^00h,c
	line	33
	
l5769:
	movff	(c:___awmod@dividend),(c:?___awmod)
	movff	(c:___awmod@dividend+1),(c:?___awmod+1)
	line	34
	
l1119:
	return	;funcret
	callstack 0
GLOBAL	__end_of___awmod
	__end_of___awmod:
	signat	___awmod,8314
	global	___awdiv

;; *************** function ___awdiv *****************
;; Defined at:
;;		line 7 in file "D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\awdiv.c"
;; Parameters:    Size  Location     Type
;;  dividend        2    5[COMRAM] int 
;;  divisor         2    7[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;  quotient        2   11[COMRAM] int 
;;  sign            1   10[COMRAM] unsigned char 
;;  counter         1    9[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  2    5[COMRAM] int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         4       0       0       0       0       0       0       0       0
;;      Locals:         4       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         8       0       0       0       0       0       0       0       0
;;Total ram usage:        8 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_poner_2d
;;		_UART_Put2d
;;		_UART_PutInt
;;		_puerta_nivel
;;		_reiniciar_sistema
;;		_actualizar_todo
;; This function uses a non-reentrant model
;;
psect	text46,class=CODE,space=0,reloc=2,group=1
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\awdiv.c"
	line	7
global __ptext46
__ptext46:
psect	text46
	file	"D:\PROGRAMAS\ARQ\XC8_6.20\pic\sources\c99\common\awdiv.c"
	line	7
	
___awdiv:
;incstack = 0
	callstack 24
	line	13
	
l5785:
	clrf	((c:___awdiv@sign))^00h,c
	line	14
	
l5787:
	btfsc	((c:___awdiv@divisor+1))^00h,c,7
	goto	u7740
	goto	u7741

u7741:
	goto	l5793
u7740:
	line	15
	
l5789:
	negf	((c:___awdiv@divisor))^00h,c
	comf	((c:___awdiv@divisor+1))^00h,c
	btfsc	status,0
	incf	((c:___awdiv@divisor+1))^00h,c
	line	16
	
l5791:
	movlw	low(01h)
	movwf	((c:___awdiv@sign))^00h,c
	line	18
	
l5793:
	btfsc	((c:___awdiv@dividend+1))^00h,c,7
	goto	u7750
	goto	u7751

u7751:
	goto	l5799
u7750:
	line	19
	
l5795:
	negf	((c:___awdiv@dividend))^00h,c
	comf	((c:___awdiv@dividend+1))^00h,c
	btfsc	status,0
	incf	((c:___awdiv@dividend+1))^00h,c
	line	20
	
l5797:
	movlw	(01h)&0ffh
	xorwf	((c:___awdiv@sign))^00h,c
	line	22
	
l5799:
	clrf	((c:___awdiv@quotient+1))^00h,c
	movlw	low(0)
	movwf	((c:___awdiv@quotient))^00h,c
	line	23
	
l5801:
	movf	((c:___awdiv@divisor))^00h,c,w
iorwf	((c:___awdiv@divisor+1))^00h,c,w
	btfsc	status,2
	goto	u7761
	goto	u7760

u7761:
	goto	l5821
u7760:
	line	24
	
l5803:
	movlw	low(01h)
	movwf	((c:___awdiv@counter))^00h,c
	line	25
	goto	l5807
	line	26
	
l5805:
	bcf	status,0
	rlcf	((c:___awdiv@divisor))^00h,c
	rlcf	((c:___awdiv@divisor+1))^00h,c
	line	27
	incf	((c:___awdiv@counter))^00h,c
	line	25
	
l5807:
	
	btfss	((c:___awdiv@divisor+1))^00h,c,(15)&7
	goto	u7771
	goto	u7770
u7771:
	goto	l5805
u7770:
	line	30
	
l5809:
	bcf	status,0
	rlcf	((c:___awdiv@quotient))^00h,c
	rlcf	((c:___awdiv@quotient+1))^00h,c
	line	31
	
l5811:
		movf	((c:___awdiv@divisor))^00h,c,w
	subwf	((c:___awdiv@dividend))^00h,c,w
	movf	((c:___awdiv@divisor+1))^00h,c,w
	subwfb	((c:___awdiv@dividend+1))^00h,c,w
	btfss	status,0
	goto	u7781
	goto	u7780

u7781:
	goto	l5817
u7780:
	line	32
	
l5813:
	movf	((c:___awdiv@divisor))^00h,c,w
	subwf	((c:___awdiv@dividend))^00h,c
	movf	((c:___awdiv@divisor+1))^00h,c,w
	subwfb	((c:___awdiv@dividend+1))^00h,c

	line	33
	
l5815:
	bsf	(0+(0/8)+(c:___awdiv@quotient))^00h,c,(0)&7
	line	35
	
l5817:
	bcf	status,0
	rrcf	((c:___awdiv@divisor+1))^00h,c
	rrcf	((c:___awdiv@divisor))^00h,c
	line	36
	
l5819:
	decfsz	((c:___awdiv@counter))^00h,c
	
	goto	l5809
	line	38
	
l5821:
	movf	((c:___awdiv@sign))^00h,c,w
	btfsc	status,2
	goto	u7791
	goto	u7790
u7791:
	goto	l5825
u7790:
	line	39
	
l5823:
	negf	((c:___awdiv@quotient))^00h,c
	comf	((c:___awdiv@quotient+1))^00h,c
	btfsc	status,0
	incf	((c:___awdiv@quotient+1))^00h,c
	line	40
	
l5825:
	movff	(c:___awdiv@quotient),(c:?___awdiv)
	movff	(c:___awdiv@quotient+1),(c:?___awdiv+1)
	line	41
	
l1106:
	return	;funcret
	callstack 0
GLOBAL	__end_of___awdiv
	__end_of___awdiv:
	signat	___awdiv,8314
	global	_UART_PutChar

;; *************** function _UART_PutChar *****************
;; Defined at:
;;		line 202 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  c               1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  c               1   25[COMRAM] unsigned char 
;;  next            1   26[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 3F/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         2       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         2       0       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_UART_PutStr
;;		_UART_Put2d
;;		_UART_PutInt
;;		_UART_PutHex5
;;		_UART_EmitEnq
;;		_UART_EmitDeq
;;		_UART_EmitDsp
;;		_UART_EmitCfg
;;		_UART_EmitEmg
;;		_UART_EnviarEstado
;; This function uses a non-reentrant model
;;
psect	text47,class=CODE,space=0,reloc=2,group=0
	file	"LOGIC_TEST.c"
	line	202
global __ptext47
__ptext47:
psect	text47
	file	"LOGIC_TEST.c"
	line	202
	
_UART_PutChar:
;incstack = 0
	callstack 24
	movwf	((c:UART_PutChar@c))^00h,c
	line	203
	
l5777:
	movlb	0	; () banked
	incf	((_tx_head))&0ffh,w
	movwf	((c:UART_PutChar@next))^00h,c
	line	204
	movf	((_tx_tail))&0ffh,w
xorwf	((c:UART_PutChar@next))^00h,c,w
	btfss	status,2
	goto	u7731
	goto	u7730

u7731:
	goto	l5781
u7730:
	goto	l239
	line	205
	
l5781:; BSR set to: 0

	movlw	low(_tx_ring)
	addwf	((_tx_head))&0ffh,w
	movwf	c:fsr2l
	clrf	1+c:fsr2l
	movlw	high(_tx_ring)
	addwfc	1+c:fsr2l
	movff	(c:UART_PutChar@c),indf2

	line	206
	
l5783:; BSR set to: 0

	movff	(c:UART_PutChar@next),(_tx_head)
	line	207
	
l239:; BSR set to: 0

	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_PutChar
	__end_of_UART_PutChar:
	signat	_UART_PutChar,4217
	global	_UART_Init

;; *************** function _UART_Init *****************
;; Defined at:
;;		line 189 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text48,class=CODE,space=0,reloc=2,group=0
	line	189
global __ptext48
__ptext48:
psect	text48
	file	"LOGIC_TEST.c"
	line	189
	
_UART_Init:; BSR set to: 0

;incstack = 0
	callstack 29
	line	190
	
l7263:
	bsf	((c:3988))^0f00h,c,6	;volatile
	bsf	((c:3988))^0f00h,c,7	;volatile
	line	191
	
l7265:
	movlw	low(033h)
	movwf	((c:4015))^0f00h,c	;volatile
	
l7267:
	bsf	((c:4012))^0f00h,c,2	;volatile
	
l7269:
	bcf	((c:4012))^0f00h,c,4	;volatile
	
l7271:
	bcf	((c:4024))^0f00h,c,3	;volatile
	line	192
	
l7273:
	bsf	((c:4011))^0f00h,c,7	;volatile
	
l7275:
	bsf	((c:4012))^0f00h,c,5	;volatile
	
l7277:
	bsf	((c:4011))^0f00h,c,4	;volatile
	line	193
	
l7279:
	bsf	((c:3997))^0f00h,c,5	;volatile
	line	194
	
l7281:
	bsf	((c:4082))^0f00h,c,6	;volatile
	line	195
	
l7283:
	bsf	((c:4082))^0f00h,c,7	;volatile
	line	196
	
l232:
	return	;funcret
	callstack 0
GLOBAL	__end_of_UART_Init
	__end_of_UART_Init:
	signat	_UART_Init,89
	global	_LCD_Init

;; *************** function _LCD_Init *****************
;; Defined at:
;;		line 147 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:         1       0       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 3
;; This function calls:
;;		_LCD_Byte
;;		_LCD_Nib
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text49,class=CODE,space=0,reloc=2,group=0
	line	147
global __ptext49
__ptext49:
psect	text49
	file	"LOGIC_TEST.c"
	line	147
	
_LCD_Init:
;incstack = 0
	callstack 27
	line	148
	
l7215:
	bcf	((c:3980))^0f00h,c,0	;volatile
	bcf	((c:3980))^0f00h,c,1	;volatile
	
l7217:
	asmopt push
asmopt off
movlw	78
movwf	(??_LCD_Init+0)^00h,c
	movlw	235
u11487:
decfsz	wreg,f
	bra	u11487
	decfsz	(??_LCD_Init+0)^00h,c,f
	bra	u11487
	nop
asmopt pop

	line	149
	
l7219:
	movlw	(03h)&0ffh
	
	call	_LCD_Nib
	
l7221:
	asmopt push
asmopt off
movlw	13
movwf	(??_LCD_Init+0)^00h,c
	movlw	252
u11497:
decfsz	wreg,f
	bra	u11497
	decfsz	(??_LCD_Init+0)^00h,c,f
	bra	u11497
asmopt pop

	movlw	(03h)&0ffh
	
	call	_LCD_Nib
	
l7223:
	asmopt push
asmopt off
	movlw	100
u11507:
decfsz	wreg,f
	bra	u11507
asmopt pop

	line	150
	
l7225:
	movlw	(03h)&0ffh
	
	call	_LCD_Nib
	asmopt push
asmopt off
	movlw	100
u11517:
decfsz	wreg,f
	bra	u11517
asmopt pop

	
l7227:
	movlw	(02h)&0ffh
	
	call	_LCD_Nib
	
l7229:
	asmopt push
asmopt off
	movlw	100
u11527:
decfsz	wreg,f
	bra	u11527
asmopt pop

	line	151
	movlw	low(0)
	movwf	((c:LCD_Byte@dato))^00h,c
	movlw	(028h)&0ffh
	
	call	_LCD_Byte
	movlw	low(0)
	movwf	((c:LCD_Byte@dato))^00h,c
	movlw	(0Ch)&0ffh
	
	call	_LCD_Byte
	movlw	low(0)
	movwf	((c:LCD_Byte@dato))^00h,c
	movlw	(06h)&0ffh
	
	call	_LCD_Byte
	movlw	low(0)
	movwf	((c:LCD_Byte@dato))^00h,c
	movlw	(01h)&0ffh
	
	call	_LCD_Byte
	line	152
	
l197:
	return	;funcret
	callstack 0
GLOBAL	__end_of_LCD_Init
	__end_of_LCD_Init:
	signat	_LCD_Init,89
	global	_LCD_Byte

;; *************** function _LCD_Byte *****************
;; Defined at:
;;		line 141 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  v               1    wreg     unsigned char 
;;  dato            1    7[COMRAM] unsigned char 
;; Auto vars:     Size  Location     Type
;;  v               1    9[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         1       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:         3       0       0       0       0       0       0       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		_LCD_Nib
;; This function is called by:
;;		_LCD_Init
;;		_LCD_Linea
;; This function uses a non-reentrant model
;;
psect	text50,class=CODE,space=0,reloc=2,group=0
	line	141
global __ptext50
__ptext50:
psect	text50
	file	"LOGIC_TEST.c"
	line	141
	
_LCD_Byte:
;incstack = 0
	callstack 27
	movwf	((c:LCD_Byte@v))^00h,c
	line	142
	
l6429:
	btfsc	(c:LCD_Byte@dato)^00h,c,0
	bra	u8795
	bcf	((c:3980))^0f00h,c,0	;volatile
	bra	u8796
	u8795:
	bsf	((c:3980))^0f00h,c,0	;volatile
	u8796:

	line	143
	
l6431:
	swapf	((c:LCD_Byte@v))^00h,c,w
	andlw	(0ffh shr 4) & 0ffh
	
	call	_LCD_Nib
	movf	((c:LCD_Byte@v))^00h,c,w
	andlw	low(0Fh)
	
	call	_LCD_Nib
	line	144
	
l6433:
	movf	((c:LCD_Byte@dato))^00h,c,w
	btfss	status,2
	goto	u8801
	goto	u8800
u8801:
	goto	l194
u8800:
	
l6435:
		movlw	03h-0
	cpfslt	((c:LCD_Byte@v))^00h,c
	goto	u8811
	goto	u8810

u8811:
	goto	l194
u8810:
	
l6437:
	asmopt push
asmopt off
movlw	6
movwf	(??_LCD_Byte+0)^00h,c
	movlw	48
u11537:
decfsz	wreg,f
	bra	u11537
	decfsz	(??_LCD_Byte+0)^00h,c,f
	bra	u11537
	nop2
asmopt pop

	line	145
	
l194:
	return	;funcret
	callstack 0
GLOBAL	__end_of_LCD_Byte
	__end_of_LCD_Byte:
	signat	_LCD_Byte,8313
	global	_LCD_Nib

;; *************** function _LCD_Nib *****************
;; Defined at:
;;		line 132 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;  n               1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  n               1    6[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0
;;      Totals:         2       0       0       0       0       0       0       0       0
;;Total ram usage:        2 bytes
;; Hardware stack levels used: 1
;; Hardware stack levels required when called: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_LCD_Byte
;;		_LCD_Init
;; This function uses a non-reentrant model
;;
psect	text51,class=CODE,space=0,reloc=2,group=0
	line	132
global __ptext51
__ptext51:
psect	text51
	file	"LOGIC_TEST.c"
	line	132
	
_LCD_Nib:
;incstack = 0
	callstack 26
	movwf	((c:LCD_Nib@n))^00h,c
	line	134
	
l6031:
	movff	(c:LCD_Nib@n),??_LCD_Nib+0
	movlw	01h
	andwf	(??_LCD_Nib+0)^00h,c
	movf	((c:3978))^0f00h,c,w	;volatile
	xorwf	(??_LCD_Nib+0)^00h,c,w
	andlw	not ((1<<1)-1)
	xorwf	(??_LCD_Nib+0)^00h,c,w
	movwf	((c:3978))^0f00h,c	;volatile
	line	135
	movff	(c:LCD_Nib@n),??_LCD_Nib+0
	bcf	status,0
	rrcf	(??_LCD_Nib+0)^00h,c

	movlw	01h
	andwf	(??_LCD_Nib+0)^00h,c
	rlncf	(??_LCD_Nib+0)^00h,c
	movf	((c:3978))^0f00h,c,w	;volatile
	xorwf	(??_LCD_Nib+0)^00h,c,w
	andlw	not (((1<<1)-1)<<1)
	xorwf	(??_LCD_Nib+0)^00h,c,w
	movwf	((c:3978))^0f00h,c	;volatile
	line	136
	movff	(c:LCD_Nib@n),??_LCD_Nib+0
	bcf	status,0
	rrcf	(??_LCD_Nib+0)^00h,c
	bcf	status,0
	rrcf	(??_LCD_Nib+0)^00h,c

	movlw	01h
	andwf	(??_LCD_Nib+0)^00h,c
	swapf	(??_LCD_Nib+0)^00h,c
	movf	((c:3980))^0f00h,c,w	;volatile
	xorwf	(??_LCD_Nib+0)^00h,c,w
	andlw	not (((1<<1)-1)<<4)
	xorwf	(??_LCD_Nib+0)^00h,c,w
	movwf	((c:3980))^0f00h,c	;volatile
	line	137
	movff	(c:LCD_Nib@n),??_LCD_Nib+0
	bcf	status,0
	rrcf	(??_LCD_Nib+0)^00h,c
	bcf	status,0
	rrcf	(??_LCD_Nib+0)^00h,c
	bcf	status,0
	rrcf	(??_LCD_Nib+0)^00h,c

	movlw	01h
	andwf	(??_LCD_Nib+0)^00h,c
	rlncf	(??_LCD_Nib+0)^00h,c
	rlncf	(??_LCD_Nib+0)^00h,c
	movf	((c:3978))^0f00h,c,w	;volatile
	xorwf	(??_LCD_Nib+0)^00h,c,w
	andlw	not (((1<<1)-1)<<2)
	xorwf	(??_LCD_Nib+0)^00h,c,w
	movwf	((c:3978))^0f00h,c	;volatile
	line	138
	
l6033:
	bsf	((c:3980))^0f00h,c,1	;volatile
	
l6035:
	asmopt push
asmopt off
	movlw	3
u11547:
decfsz	wreg,f
	bra	u11547
	nop
asmopt pop

	
l6037:
	bcf	((c:3980))^0f00h,c,1	;volatile
	
l6039:
	asmopt push
asmopt off
	movlw	33
u11557:
decfsz	wreg,f
	bra	u11557
	nop
asmopt pop

	line	139
	
l190:
	return	;funcret
	callstack 0
GLOBAL	__end_of_LCD_Nib
	__end_of_LCD_Nib:
	signat	_LCD_Nib,4217
	global	_isr

;; *************** function _isr *****************
;; Defined at:
;;		line 85 in file "LOGIC_TEST.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  next            1    4[COMRAM] unsigned char 
;;  c               1    3[COMRAM] unsigned char 
;;  dummy           1    2[COMRAM] volatile unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7
;;      Params:         0       0       0       0       0       0       0       0       0
;;      Locals:         3       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0
;;      Totals:         5       0       0       0       0       0       0       0       0
;;Total ram usage:        5 bytes
;; Hardware stack levels used: 1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		Interrupt level 2
;; This function uses a non-reentrant model
;;
psect	intcode,class=CODE,space=0,reloc=2
	file	"Elevador_Supremo.s"
	line	#
global __pintcode
__pintcode:
psect	intcode
	file	"LOGIC_TEST.c"
	line	85
	
_isr:
;incstack = 0
	callstack 23
	bsf int$flags,1,c ;set compiler interrupt flag (level 2)
	global	int_func
	call	int_func,f	;refresh shadow registers
psect	intcode_body,class=CODE,space=0,reloc=2
global __pintcode_body
__pintcode_body:
int_func:

	pop	; remove dummy address from shadow register refresh
	movff	fsr2l+0,??_isr+0
	movff	fsr2h+0,??_isr+1
	line	86
	
i2l5603:
	btfss	((c:3997))^0f00h,c,5	;volatile
	goto	i2u752_41
	goto	i2u752_40
i2u752_41:
	goto	i2l154
i2u752_40:
	
i2l5605:
	btfss	((c:3998))^0f00h,c,5	;volatile
	goto	i2u753_41
	goto	i2u753_40
i2u753_41:
	goto	i2l154
i2u753_40:
	line	87
	
i2l5607:
	btfss	((c:4011))^0f00h,c,2	;volatile
	goto	i2u754_41
	goto	i2u754_40
i2u754_41:
	goto	i2l150
i2u754_40:
	line	88
	
i2l5609:
	movff	(c:4014),(c:isr@dummy)	;volatile
	line	90
	goto	i2l5617
	
i2l150:
	line	91
	movff	(c:4014),(c:isr@c)	;volatile
	line	92
	
i2l5611:
	movlb	0	; () banked
	incf	((_rx_head))&0ffh,w	;volatile
	andlw	low(03Fh)
	movwf	((c:isr@next))^00h,c
	line	93
	movf	((_rx_tail))&0ffh,w	;volatile
xorwf	((c:isr@next))^00h,c,w
	btfsc	status,2
	goto	i2u755_41
	goto	i2u755_40

i2u755_41:
	goto	i2l5617
i2u755_40:
	line	94
	
i2l5613:; BSR set to: 0

	movlw	low(_rx_ring)
	addwf	((_rx_head))&0ffh,w	;volatile
	movwf	c:fsr2l
	clrf	1+c:fsr2l
	movlw	high(_rx_ring)
	addwfc	1+c:fsr2l
	movff	(c:isr@c),indf2

	line	95
	
i2l5615:; BSR set to: 0

	movff	(c:isr@next),(_rx_head)	;volatile
	line	98
	
i2l5617:
	btfss	((c:4011))^0f00h,c,1	;volatile
	goto	i2u756_41
	goto	i2u756_40
i2u756_41:
	goto	i2l154
i2u756_40:
	line	99
	
i2l5619:
	bcf	((c:4011))^0f00h,c,4	;volatile
	line	100
	bsf	((c:4011))^0f00h,c,4	;volatile
	line	103
	
i2l154:
	movff	??_isr+1,fsr2h+0
	movff	??_isr+0,fsr2l+0
	bcf int$flags,1,c ;clear compiler interrupt flag (level 2)
	retfie f
	callstack 0
GLOBAL	__end_of_isr
	__end_of_isr:
	signat	_isr,89
psect	mediumconst
	db 0	; dummy byte at the end
	global	__smallconst
__smallconst	set	__pmediumconst
	global	__mediumconst
__mediumconst	set	__pmediumconst
	GLOBAL	__activetblptr
__activetblptr	EQU	2
	psect	intsave_regs,class=BIGRAM,space=1,noexec
	PSECT	rparam,class=COMRAM,space=1,noexec
	GLOBAL	__Lrparam
	FNCONF	rparam,??,?
	GLOBAL	___rparam_used
	___rparam_used EQU 1
	GLOBAL	___param_bank
	___param_bank EQU 0
GLOBAL	__Lparam, __Hparam
GLOBAL	__Lrparam, __Hrparam
__Lparam	EQU	__Lrparam
__Hparam	EQU	__Hrparam
	global	btemp
	btemp set 01h

	DABS	1,1,1	;btemp
	global	int$flags
	int$flags	set btemp
	global btemp0
	btemp0 set btemp+0
	global btemp1
	btemp1 set btemp+1
	end
