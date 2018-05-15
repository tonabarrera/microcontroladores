        .include "p30F4013.inc"
	
	.global __U1RXInterrupt
	.global __ADCInterrupt
	.global _dato
	.global _datoRCU

;/**@brief INTERRUPCION DEL ADC
; */
__ADCInterrupt:
    PUSH W0
    
    POP W0
    RETFIE
	
;/**@brief INTERRUPCION DEL UART
; */
__U1RXInterrupt:
    PUSH W0
    PUSH W1
    
    POP W1
    POP W0
    
    RETFIE
    
    