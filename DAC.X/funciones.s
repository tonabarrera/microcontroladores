        .include "p30F4013.inc"

        .global _RD_WR_SPI
	.global _WR_DAC
	
	.EQU	CS_DAC,	    RA11
	.EQU	LDAC,	    RD0
	
/** @brief 
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

/** @brief 
; * @PARAM:
; */
_WR_DAC:
    MOV #0X0FFF, W1
    AND  W1, W0, W0
    BSET W0,	#12
    BCLR PORTA,	    #CS_DAC
    NOP
    BSET PORTD,	    #LDAC
    NOP
    CALL _RD_WR_SPI
    BSET PORTA,	    #CS_DAC
    NOP
    BSET PORTD,	    #LDAC
    NOP
    BSET PORTD,	    #LDAC
    NOP
    
    RETURN
    
    