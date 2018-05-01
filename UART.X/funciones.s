        .include "p30F4013.inc"
	
	.global __U1RXInterrupt
	.global _dato
	.global _datoRCU
  
;/**@brief ESTA RUTINA GENERA UN RETARDO DE 1 SEG APROX
; */
__U1RXInterrupt:
    PUSH W0
    MOV U1RXREG,    W0
    MOV.B WREG,	    _dato
    MOV #1,	    W0
    MOV.B WREG,	    _datoRCU
    
    BCLR IFS0,	    #U1RXIF
    POP W0
    
    RETFIE
    
    