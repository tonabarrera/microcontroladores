        .include "p30F4013.inc"

	.global __U2RXInterrupt
	.global _comandoAT
    
_comandoAT:
    PUSH    W1 ; NO ESTOY SEGURO DE ESTA PARTE
    MOV	    W0,	    W1
OTRO_CICLO:
    CLR	    W0
    MOV.B   [W1++], W0
    ; PREGUNTAR POR CERO
    CP0.B   W0
    BRA	    Z,	    SALIR
    BCLR    IFS1,   #U2TXIF
    MOV	    W0,	    U2TXREG
CICLO:
    BTSS IFS1, #1 ; SI ES UNO BRINCA
    GOTO CICLO
    GOTO OTRO_CICLO
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
    
    