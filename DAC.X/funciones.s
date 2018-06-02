        .include "p30F4013.inc"

        .global _CONV_CODIGO
	
/**@brief 
; * @PARAM:
; */
_CONV_CODIGO:
    MOV	SPI1BUF, W0
    BCLR IFS0, #SPI1IF
CICLO:
    BTSS IFS0,	#SPI1IF
    GOTO CICLO
    MOV	W0,	SPI1BUF
    
    RETURN
    
    