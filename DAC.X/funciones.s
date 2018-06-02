        .include "p30F4013.inc"

        .global _RD_WR_SPI
	
/**@brief 
; * @PARAM:
; */
_RD_WR_SPI:
    MOV	SPI1BUF, W0
    BCLR IFS0, #SPI1IF
CICLO:
    BTSS IFS0,	#SPI1IF
    GOTO CICLO
    MOV	W0,	SPI1BUF
    
    RETURN
    
_WR_DAC:
    AND W0, #0X0FFF
    BSET W0, #12
    CALL RD_WR_SPI
    NOP
    
    RETURN
    
    