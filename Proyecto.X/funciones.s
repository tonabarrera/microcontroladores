        .include "p30F4013.inc"

	.global _comandoAT
    
_comandoAT:
    MOV	    W0,	    W1
OTRO_CICLO:
    CLR	    W0 ; Duda
    MOV.B   [W1++], W0
    CP0	    W0 ; CP0
    BRA	    Z,	    SALIR
    BCLR    IFS1,   #U2TXIF
    MOV	    W0,	    U2TXREG
    NOP
CICLO:
    BTSS    IFS1, #U2TXIF ; SI ES UNO BRINCA
    GOTO    CICLO
    GOTO    OTRO_CICLO
SALIR:
    RETURN
	
    
    