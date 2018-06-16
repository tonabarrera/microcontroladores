        .include "p30F4013.inc"

	.global __T3Interrupt
	.global __T1Interrupt

__T1Interrupt:
    BTG	    LATD,   #LATD0
    NOP
    BCLR    IFS0    ,	#T1IF
    RETFIE
		
__T3Interrupt:
    MOV	    [W1++], W0
    CALL    _WR_DAC
    NOP
    BCLR    IFS0    ,	#T3IF
    RETFIE
    
    