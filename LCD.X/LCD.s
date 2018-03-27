        .include "p30F4013.inc"
	
	.global _comandoLCD
        .global _datoLCD
	.global _busyFlag
	.global _iniLCD8bits
	.global _imprimeLCD
 
	.EQU	RS_LCD,	    RD0
	.EQU	RW_LCD,	    RD1
	.EQU	E_LCD,	    RD2
	.EQU	BF_LCD,	    RB7

;/**@brief ESTA RUTINA MANDA UN DATO A UN LCD
; * @param: W0, dato a anviar
; */
_datoLCD:
    BSET    PORTD,	#RS_LCD
    NOP
    BCLR    PORTD,	#RW_LCD
    NOP
    BSET    PORTD,	#E_LCD
    NOP
    MOV.B   WREG,	PORTB ; MANDAMOS EL COMANDO O DATO
    NOP
    BCLR    PORTD,	#E_LCD
    NOP
    
    RETURN
    
;/**@brief ESTA RUTINA MANDA UN COMANDO A UN LCD
; * @param: W0, comando a enviar
; */
_comandoLCD:
    BCLR    PORTD,	#RS_LCD
    NOP
    BCLR    PORTD,	#RW_LCD
    NOP
    BSET    PORTD,	#E_LCD
    NOP
    MOV.B   WREG,	PORTB ; MANDAMOS EL COMANDO O DATO
    NOP
    BCLR    PORTD,	#E_LCD
    NOP
    
    RETURN

;/**@brief ESTA RUTINA VERIFICA LA BANDERA BF DEL LCD
; */
_busyFlag:
    PUSH    W0 ; HACERLO EN RUTINAS E INTERRUPCIONES
    MOV	    #0X00FF,	W0
    IOR	    TRISB ; EL REGISTRO TRISB ES VARIABLE POR ESTAR MAPEADO EN LA MEMORIA
    NOP
    BCLR    PORTD,	#RS_LCD
    NOP
    BSET    PORTD,	#RW_LCD
    NOP
    BSET    PORTD,	#E_LCD
    NOP
CICLO:
    BTSC    PORTB,	#BF_LCD
    GOTO    CICLO
    
    BCLR    PORTD,	#E_LCD
    NOP
    MOV	    #0XFF00,	W0
    AND	    TRISB
    NOP
    BCLR    PORTD,	#RW_LCD

    POP W0
    RETURN

;/**@brief ESTA RUTINA INICIALIZA EL LCD EN MODO
; * DE 8 BITS
; */
_iniLCD8bits:
    PUSH W0
    CALL    _RETARDO_15ms
    MOV	    #0X30,	W0
    CALL    _comandoLCD
    
    CALL    _RETARDO_15ms
    MOV	    #0X30,	W0
    CALL    _comandoLCD
    
    CALL    _RETARDO_15ms
    MOV	    #0X30,	W0
    CALL    _comandoLCD

    CALL    _busyFlag
    MOV	    #0X38,	W0
    CALL    _comandoLCD
    
    CALL    _busyFlag
    MOV	    #0X08,	W0
    CALL    _comandoLCD
    
    CALL    _busyFlag
    MOV	    #0X01,	W0
    CALL    _comandoLCD
    
    CALL    _busyFlag
    MOV	    #0X06,	W0
    CALL    _comandoLCD
   
    CALL    _busyFlag
    MOV	    #0X0F,	W0
    CALL    _comandoLCD
    
    POP W0
    RETURN

;/**@brief ESTA RUTINA MUESTRA UN MENSAJE EN LA LCD
; * @param W0, APUNTADOR DEL MENSAJE A MOSTRAR
; */
_imprimeLCD:
    PUSH    W1 ; NO ESTOY SEGURO DE ESTA PARTE
    MOV	    W0,	    W1
    CLR	    W0
RECORRER:
    MOV.B   [W1++], W0
    ; PREGUNTAR POR CERO
    CP0.B   W0
    BRA Z, SALIR
    CALL    _busyFlag
    CALL    _datoLCD
    GOTO    RECORRER
SALIR:
    POP	    W1
    RETURN
