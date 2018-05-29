        .include "p30F4013.inc"

	.global __U2RXInterrupt
	.global _comandoAT
    
_comandoAT:
    MOV	    W0,	    W1
OTRO_CICLO:
    CLR	    W0 ; Duda
    MOV.B   [W1++], W0
    CP0   W0 ; CP0
    BRA	    Z,	    SALIR
    BCLR    IFS1,   #U2TXIF
    MOV	    W0,	    U2TXREG
    NOP
CICLO:
    BTSS IFS1, #U2TXIF ; SI ES UNO BRINCA
    GOTO CICLO
    GOTO OTRO_CICLO
SALIR:
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
    MOV W0,	U1TXREG
    NOP

    BCLR    IFS1,   #U2RXIF
    POP	    W0
    RETFIE
    
    