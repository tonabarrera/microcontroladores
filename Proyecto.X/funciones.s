        .include "p30F4013.inc"

	.global __U2RXInterrupt
	
__U2RXInterrupt:
    PUSH W0
    
    MOV U2RXREG, W0
    MOV W0, U1TXREG

    BCLR    IFS1,   #U2RXIF
    POP	    W0
    RETFIE
    
    