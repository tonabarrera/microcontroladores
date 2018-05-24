        .include "p30F4013.inc"

	.global __U2RXInterrupt
	.global _comandoAT
	
	.EQU	RS_AT,	    RD1
	.EQU	RW_AT,	    RD1
	.EQU	E_AT,	    RD2
	
_comandoAT:
    BCLR    PORTD, #RS_AT
    NOP
    BCLR    PORTD, #RW_AT
    NOP
    BSET    PORTD, #E_AT
    NOP
    MOV.B   WREG, PORTB
    NOP
    BCLR    PORTD, #E_AT
    NOP
    
    RETURN
	
__U2RXInterrupt:
    PUSH W0
    
    MOV U2RXREG, W0
    MOV W0, U1TXREG

    BCLR    IFS1,   #U2RXIF
    POP	    W0
    RETFIE
    
    