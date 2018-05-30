        .include "p30F4013.inc"

	.global __U2RXInterrupt
    
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
    
    


