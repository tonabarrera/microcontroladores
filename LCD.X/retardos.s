        .include "p30F4013.inc"

        .global _RETARDO_1S
        .global _RETARDO_5ms
	.global _RETARDO_15ms
	.global _RETARDO_30ms
  
;/**@brief ESTA RUTINA GENERA UN RETARDO DE 1 SEG APROX
; */
_RETARDO_1S:
	PUSH	W0  ; PUSH.D W0
	PUSH	W1
	
	MOV	#5,	    W1
CICLO2_1S:
    
	CLR	W0	
CICLO1_1S:	
	DEC	W0,	    W0
	BRA	NZ,	    CICLO1_1S	
    
	DEC	W1,	    W1
	BRA	NZ,	    CICLO2_1S
	
	POP	W1  ; POP.D W0
	POP	W0
	RETURN
	
;/**@brief ESTA RUTINA GENERA UN RETARDO DE 5ms
; */
_RETARDO_5ms:
	PUSH W0
	MOV #3276, W0
CICLO_5ms:
	DEC W0, W0
	BRA NZ, CICLO_5ms
	
	POP W0
	RETURN

;/**@brief ESTA RUTINA GENERA UN RETARDO DE 15ms
; */
_RETARDO_15ms:
	CALL _RETARDO_5ms
	CALL _RETARDO_5ms
	CALL _RETARDO_5ms
	RETURN

;/**@brief ESTA RUTINA GENERA UN RETARDO DE 30ms
; */
_RETARDO_30ms:
	CALL _RETARDO_15ms
	CALL _RETARDO_15ms
	RETURN
