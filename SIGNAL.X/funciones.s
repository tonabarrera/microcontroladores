        .include "p30F4013.inc"
	
	.global __T3Interrupt
	.global __ADCInterrupt
	.global _dato
	.global _datoRCU

;/**@brief INTERRUPCION DEL ADC
; */
__ADCInterrupt:
    PUSH W0
    PUSH W1
    
    MOV ADCBUF0, W0
    MOV W0, W1
    AND #0x003F, W0 ; PARTE BAJA EN W0
    LSR W1, #6, W1 ; PARTE ALTA EN W1
    BSET W1, #7
    MOV W0, U1TXREG ; PRIMERO SE MANDA LA PARTE BAJA
    MOV W1, U1TXREG ; LUEGO LA PARTE ALTA
    BCLR IFS0, #ADIF
    
    POP W1
    POP W0
    RETFIE
	
;/**@brief INTERRUPCION DEL UART
; */
__T3Interrupt:
    BTG	LATD, #LATD0
    NOP
    BCLR IFS0, #T3IF
    
    RETFIE
    
    