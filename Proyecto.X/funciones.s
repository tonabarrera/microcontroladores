        .include "p30F4013.inc"

	.global __U2RXInterrupt
	.global _enviarAT
	
	.EQU	RS_AT,	    RD1
	.EQU	E_AT,	    RD2
	
_datoAT:
    BSET    PORTD,	#RS_AT
    NOP
    BCLR    PORTD,	#RW_AT
    NOP
    BSET    PORTD,	#E_AT
    NOP
    MOV   WREG,	U2TXREG ; MANDAMOS EL COMANDO O DATO
    NOP
    BCLR    PORTD,	#E_AT
    NOP
    
    RETURN
    
_enviarAT:
    PUSH    W1 ; NO ESTOY SEGURO DE ESTA PARTE
    MOV	    W0,	    W1
    CLR	    W0
RECORRER:
    MOV.B   [W1++], W0
    ; PREGUNTAR POR CERO
    CP0.B   W0
    BRA Z, SALIR
    CALL    _datoAT
    GOTO    RECORRER
SALIR:
    POP	    W1
    RETURN
    
;__T3Interrupt:
;    BTG	LATD, #LATD0
;    NOP
;    BCLR IFS0, #T3IF
;    
;    RETFIE
	
__U2RXInterrupt:
    PUSH W0
    
    MOV U2RXREG, W0
    MOV W0, U1TXREG

    BCLR    IFS1,   #U2RXIF
    POP	    W0
    RETFIE
    
    