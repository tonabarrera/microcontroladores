        .include "p30F4013.inc"

	.global __T3Interrupt
	.global __T1Interrupt

__T1Interrupt:
    PUSH W0
    
    RETFIE
		
__T3Interrupt:
    PUSH W0
    
    RETFIE
    
    