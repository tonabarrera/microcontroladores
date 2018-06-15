	    .include "p30F4013.inc"
	    .global _WR_DAC
	    .global _RD_WR_SPI
	    .global _seno
	    .global _T1Interrupt
	    .global _T3Interrupt
	    .global _configDSP
	    
;_T1Interrupt:
 ;   BTG		LATD,	    #LATD0
  ;  NOP
   ; RETFIE

;;_T3Interrupt:
  ;  MOV		[W1++],		W0
   ; CALL	_WR_DAC
    ;RETFIE
	    
_WR_DAC:
    MOV		#0X0FFF,	W1
    AND		W0,	    W1,		W0
    BSET	W0,	    #12
    BCLR	PORTA,	    #RA11
    NOP
    BSET	PORTD,	    #RD0
    NOP
    CALL	_RD_WR_SPI
    BSET	PORTA,	    #RA11
    NOP
    BCLR	PORTD,	    #RD0
    NOP
    BSET	PORTD,	    #RD0
    NOP
    RETURN
    
_RD_WR_SPI:
    MOV		W0,	    SPI1BUF
    BCLR	IFS0,	    #SPI1IF
FIN: 
    BTSS	IFS0,	    #SPI1IF
    GOTO	FIN
    MOV		SPI1BUF,	W0
    RETURN
    

;_configDSP:
    ;SE ACTIVA EL PSV Y SE COLOCA W1 COMO APUNTADOR
 ;   BSET	CORCON,		#PSV
  ;  MOV		#psvpage(_seno),	W0
   ; MOV		W0,	    PSVPAG
    ;MOV		#psvoffset(_seno),	W1
    ;CONFIGURACION DEL MODO DE DIRECCIONAMIENTO CIRCULAR
    ;W1 ES EL APUNTADOR DEL BUFFER CIRCULAR
   ; MOV		W1,	    XMODSRT
    ;MOV		#64*2-1,	    W2  ;#MUESTRAS*2-1
    ;ADD		W2,	    W1,		W2
    ;MOV		W2,	    XMODEND
    ;MOV		#0X8001,	W0
    ;MOV		W0,	    MODCON
    ;RETURN
    


    
    