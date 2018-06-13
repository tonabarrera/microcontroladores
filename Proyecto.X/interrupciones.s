        .include "p30F4013.inc"

	.global __U2RXInterrupt
	.global __T3Interrupt
	.global __ADCInterrupt

;/**@brief interrupcion del timer 3 para poder observar
; * la frecuencia con la que se esta trabajando
; */    
__T3Interrupt:
    BTG	    LATD,   #LATD0
    NOP
    BCLR    IFS0,   #T3IF
    
    RETFIE
	
;/**@brief interrupcion encargada de transmitir los datos del modulo
; * wifi al uart 1
; */
__U2RXInterrupt:
    PUSH    W0
    
    MOV	    U2RXREG, W0
    MOV	    W0,	    U1TXREG
    NOP

    BCLR    IFS1,   #U2RXIF
    POP	    W0
    RETFIE
    
;/**@brief interrupcion encargada de transmitir las muestras del adc al
; * modulo wifi
; */   
__ADCInterrupt:
    PUSH    W0
    PUSH    W1
    
    MOV	    ADCBUF0, W0
    MOV	    W0,	    W1
    AND	    #0x003F, W0 ; PARTE BAJA EN W0
    LSR	    W1,	    #6,	    W1 ; PARTE ALTA EN W1
    BSET    W1,	    #7
    MOV	    W0,	    U2TXREG ; PRIMERO SE MANDA LA PARTE BAJA
    NOP
    MOV	    W1,	    U2TXREG ; LUEGO LA PARTE ALTA
    NOP
    BCLR    IFS0,   #ADIF
    
    POP W1
    POP W0
    RETFIE


