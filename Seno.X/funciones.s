        .include "p30F4013.inc"

        .global _RD_WR_SPI
	.global _WR_DAC
	.global _configDSP
	.global	_seno
	
	.EQU	CS_DAC,	    RA11
	.EQU	LDAC,	    RD0

/** @brief SE ACTIVA EL PSV Y SE COLOCA W1 COMO APUNTADOR
; * CONFIGURACION DEL MODO DE DIRECCIONAMIENTO CIRCULAR
; * W1 ES EL APUNTADOR DEL BUFFER CIRCULAR
; * @PARAM:
; */
_configDSP:
    BSET    CORCON, #PSV
    MOV	    #psvpage(_seno),	W0
    MOV	    W0,	    PSVPAG
    MOV	    #psvoffset(_seno),	W1
    
    MOV	    W1,	    XMODSRT
    MOV	    #64*2-1,	    W2  ;#MUESTRAS*2-1
    ADD	    W2,	    W1,	    W2
    MOV	    W2,	    XMODEND
    MOV	    #0X8001, W0
    MOV	    W0,	    MODCON
    RETURN
    
/** @brief 
; * @PARAM:
; */
_RD_WR_SPI:
    MOV	W0,	SPI1BUF
    BCLR IFS0, #SPI1IF
CICLO:
    BTSS IFS0,	#SPI1IF ; Pendiente
    GOTO CICLO
    MOV	W0,	SPI1BUF
    MOV	SPI1BUF, W0

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
    
    