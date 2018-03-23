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
    ;CONTINUARA...
    return
    
;/**@brief ESTA RUTINA MANDA UN COMANDO A UN LCD
; * @param: W0, comando a enviar
; */
_comandoLCD:
    BCLR PORTD ,#RS_LCD
    NOP
    BCLR PORTD, #RW_LCD
    NOP
    BSET PORTD, #E_LCD
    NOP
    MOV.B WREG, PORTB ; MANDAMOS EL COMANDO O DATO
    NOP
    BCLR PORTC, #E_LCD
    NOP
    
    return
;/**@brief ESTA RUTINA VERIFICA LA BANDERA BF DEL LCD
; */
_busyFlag:
    PUSH W0 ; HACERLO EN RUTINAS E INTERRUPCIONES
    SETM.B	TRISB ; El registro TRISB ES VARIABLE POR ESTAR MAPEADO EN LA MEMORIA
    NOP
    BSET	PORTD,	    #RW_LCD
    NOP
    ;RS = 0, TERMINEN
    BSET	PORTD,	    #E_LCD
    NOP
    
    POP W0
    RETURN
    
PROCESA:
    BTSC	PORTB,	    #BF_LCD
    GOTO	PROCESA
    ;CONTINUARA...
    return

;/**@brief ESTA RUTINA INICIALIZA EL LCD EN MODO
; * DE 8 BITS
; */
_iniLCD8bits:
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
   
    ;CONTINUARA...
    RETURN

;/**@brief ESTA RUTINA MUESTRA UN MENSAJE EN LA LCD
; * @param W0, APUNTADOR DEL MENSAJE A MOSTRAR
; */
_imprimeMensaje:
    PUSH W1 ; NO ESTOY SEGURO DE ESTA PARTE
    MOV W0, W1
    MOV.B [W1++], W0
    ; PREGUNTAR POR CERO
    CALL _busyFlag
    CALL _datoLCD
    ; CONTINUARA ...
    POP W1
    RETURN
