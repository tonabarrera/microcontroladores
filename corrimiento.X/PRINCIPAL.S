;/**@brief ESTE PROGRAMA MUESTRA LOS BLOQUES QUE FORMAN UN PROGRAMA 
; * EN ENSAMBLADOR, LOS BLOQUES SON:
; * BLOQUE 1. OPCIONES DE CONFIGURACION DEL DSC: OSCILADOR, WATCHDOG,
; *	BROWN OUT RESET, POWER ON RESET Y CODIGO DE PROTECCION
; * BLOQUE 2. EQUIVALENCIAS Y DECLARACIONES GLOBALES
; * BLOQUE 3. ESOACIOS DE MEMORIA: PROGRAMA, DATOS X, DATOS Y, DATOS NEAR
; * BLOQUE 4. C�DIGO DE APLICACI�N
; * @device: DSPIC30F4013
; * @oscilator: FRC, 7.3728MHz
; */
        .equ __30F4013, 1
        .include "p30F4013.inc"
;******************************************************************************
; BITS DE CONFIGURACI�N
;******************************************************************************
;..............................................................................
;SE DESACTIVA EL CLOCK SWITCHING Y EL FAIL-SAFE CLOCK MONITOR (FSCM) Y SE 
;ACTIVA EL OSCILADOR INTERNO (FAST RC) PARA TRABAJAR
;FSCM: PERMITE AL DISPOSITIVO CONTINUAR OPERANDO AUN CUANDO OCURRA UNA FALLA 
;EN EL OSCILADOR. CUANDO OCURRE UNA FALLA EN EL OSCILADOR SE GENERA UNA TRAMPA
;Y SE CAMBIA EL RELOJ AL OSCILADOR FRC  
;..............................................................................
        config __FOSC, CSW_FSCM_OFF & FRC   
;..............................................................................
;SE DESACTIVA EL WATCHDOG
;..............................................................................
        config __FWDT, WDT_OFF 
;..............................................................................
;SE ACTIVA EL POWER ON RESET (POR), BROWN OUT RESET (BOR), POWER UP TIMER (PWRT)
;Y EL MASTER CLEAR (MCLR)
;POR: AL MOMENTO DE ALIMENTAR EL DSPIC OCURRE UN RESET CUANDO EL VOLTAJE DE 
;ALIMENTACI�N ALCANZA UN VOLTAJE DE UMBRAL (VPOR), EL CUAL ES 1.85V
;BOR: ESTE MODULO GENERA UN RESET CUANDO EL VOLTAJE DE ALIMENTACI�N DECAE
;POR DEBAJO DE UN CIERTO UMBRAL ESTABLECIDO (2.7V) 
;PWRT: MANTIENE AL DSPIC EN RESET POR UN CIERTO TIEMPO ESTABLECIDO, ESTO AYUDA
;A ASEGURAR QUE EL VOLTAJE DE ALIMENTACI�N SE HA ESTABILIZADO (16ms) 
;..............................................................................
        config __FBORPOR, PBOR_ON & BORV27 & PWRT_16 & MCLR_EN
;..............................................................................
;SE DESACTIVA EL C�DIGO DE PROTECCI�N
;..............................................................................
   	config __FGS, CODE_PROT_OFF & GWRP_OFF      

;******************************************************************************
; SECCI�N DE DECLARACI�N DE CONSTANTES CON LA DIRECTIVA .EQU (= DEFINE EN C)
;******************************************************************************
        .equ MUESTRAS, 64         ;N�MERO DE MUESTRAS

;******************************************************************************
; DECLARACIONES GLOBALES
;******************************************************************************
;..............................................................................
;PROPORCIONA ALCANCE GLOBAL A LA FUNCI�N _wreg_init, ESTO PERMITE LLAMAR A LA 
;FUNCI�N DESDE UN OTRO PROGRAMA EN ENSAMBLADOR O EN C COLOCANDO LA DECLARACI�N
;"EXTERN"
;..............................................................................
        .global _wreg_init     
;..............................................................................
;ETIQUETA DE LA PRIMER LINEA DE C�DIGO
;..............................................................................
        .global __reset          
;..............................................................................
;DECLARACI�N DE LA ISR DEL TIMER 1 COMO GLOBAL
;..............................................................................
        .global __T1Interrupt    

;******************************************************************************
;CONSTANTES ALMACENADAS EN EL ESPACIO DE LA MEMORIA DE PROGRAMA
;******************************************************************************
        .section .myconstbuffer, code
;..............................................................................
;ALINEA LA SIGUIENTE PALABRA ALMACENADA EN LA MEMORIA 
;DE PROGRAMA A UNA DIRECCION MULTIPLO DE 2
;..............................................................................
        .palign 2                

ps_coeff:
        .hword   0x0002, 0x0003, 0x0005, 0x000A

;******************************************************************************
;VARIABLES NO INICIALIZADAS EN EL ESPACIO X DE LA MEMORIA DE DATOS
;******************************************************************************
         .section .xbss, bss, xmemory

x_input: .space 2*MUESTRAS        ;RESERVANDO ESPACIO (EN BYTES) A LA VARIABLE

;******************************************************************************
;VARIABLES NO INICIALIZADAS EN EL ESPACIO Y DE LA MEMORIA DE DATOS
;******************************************************************************

          .section .ybss, bss, ymemory

y_input:  .space 2*MUESTRAS       ;RESERVANDO ESPACIO (EN BYTES) A LA VARIABLE
;******************************************************************************
;VARIABLES NO INICIALIZADAS LA MEMORIA DE DATOS CERCANA (NEAR), LOCALIZADA
;EN LOS PRIMEROS 8KB DE RAM
;******************************************************************************
          .section .nbss, bss, near

var1:     .space 2               ;LA VARIABLE VAR1 RESERVA 1 WORD DE ESPACIO

;******************************************************************************
;SECCION DE CODIGO EN LA MEMORIA DE PROGRAMA
;******************************************************************************
.text					;INICIO DE LA SECCION DE CODIGO

__reset:
        MOV	#__SP_init, 	W15	;INICIALIZA EL STACK POINTER

        MOV 	#__SPLIM_init, 	W0     	;INICIALIZA EL REGISTRO STACK POINTER LIMIT 
        MOV 	W0, 		SPLIM

        NOP                       	;UN NOP DESPUES DE LA INICIALIZACION DE SPLIM

        CALL 	_WREG_INIT          	;SE LLAMA A LA RUTINA DE INICIALIZACION DE REGISTROS
                                  	;OPCIONALMENTE USAR RCALL EN LUGAR DE CALL
        CALL    INI_PERIFERICOS
	
CORRIMIENTO:
    MOV #0X0001, W0
    MOV W0, W1
    MOV W0, PORTB
    
    CICLO:
	;CALL RETARDO_1S
	;CALL RETARDO_1S
	;CALL RETARDO_1S
	;CALL RETARDO_1S
	NOP
	MOV PORTF, W2 ; PONEMOS EL VALOR DEL PUERTO F EN W2
	XOR W2, #0X0001, W3 ; NEGAMOS EL BIT MENOS SIGNIFICATIVO Y LO PONEMOS EN W3
	BTSS W3, #0X0000 ; VEMOS SI EL BIT MENOS SIGNIFICATIVO W3 ES 1, OSEA QUE NO PULSO EL BOTON
	GOTO VALIDAR
	
	APLICAR_CORRIMIENTO:
	    BTSS W1, #0X0
	    GOTO CORRIMIENTO_IZQ
	    GOTO CORRIMIENTO_DER
	    
	    
	    
	LEL:
	    SL W2, W2
	    AND #0X001, W1
	    ADD W1, W2, W1
	    MOV W0, PORTB
	    NOP
	    GOTO CICLO
	    
VALIDAR:
    BTSS W1, #0X1
    XOR W1, #0X0001, W1
    
    GOTO APLICAR_CORRIMIENTO
    
CORRIMIENTO_IZQ:
    SL W0, W0
    MOV #0X0080, W3
    CP W0, W3
    BRA Z, REINICIAR
    
    GOTO LEL

CORRIMIENTO_DER:
    LSR W0, W0
    CP W0, #0X0000
    BRA Z, REINICIAR2
    
    GOTO LEL
	
REINICIAR:
    MOV #0X0001, W0
    GOTO LEL
    
REINICIAR2:
    MOV #0X0040, W0
    GOTO LEL
    
RETARDO_1S:
    CLR W2
    NOP
    CICLO_1S:
	DEC W2, W2
	BRA NZ, CICLO_1S
    RETURN
	
;/**@brief ESTA RUTINA INICIALIZA LOS PERIFERICOS DEL DSC
; */
INI_PERIFERICOS:
	CLR PORTD ;DESPUES DEL CLEAR VA UN NOP POR BEST PRACTICE
	NOP
	CLR LATD
	NOP
	SETM TRISD
	NOP
	
	CLR PORTB
	NOP
	CLR LATB
	NOP
	CLR TRISB
	NOP
	
	SETM ADPCFG ; PUERTO DIGITAL
	
	CLR PORTF
	NOP
	
	CLR LATF
	NOP
	
	BSET TRISF, #TRISF0
	NOP
	
        RETURN

;/**@brief ESTA RUTINA INICIALIZA LOS REGISTROS Wn A 0X0000
; */
_WREG_INIT: ; EL GUION BAJO "_" ES PARA DECIR QUE LAS FUNCIONES ESTAN COMPARTIDAS ENTRE C Y ASM
        CLR 	W0
        MOV 	W0, 				W14
        REPEAT 	#12
        MOV 	W0, 				[++W14]
        CLR 	W14
        RETURN

;/**@brief ISR (INTERRUPT SERVICE ROUTINE) DEL TIMER 1
; * SE USA PUSH.S PARA GUARDAR LOS REGISTROS W0, W1, W2, W3, 
; * C, Z, N Y DC EN LOS REGISTROS SOMBRA
; */
__T1Interrupt:
        PUSH.S 


        BCLR IFS0, #T1IF           ;SE LIMPIA LA BANDERA DE INTERRUPCION DEL TIMER 1

        POP.S

        RETFIE                     ;REGRESO DE LA ISR


.END                               ;TERMINACION DEL CODIGO DE PROGRAMA EN ESTE ARCHIVO






