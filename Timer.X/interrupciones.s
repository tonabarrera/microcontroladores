        .include "p30F4013.inc"

	.global __INT0Interrupt
	.global _NOTA_DO
	.global _NOTA_RE
	.global _NOTA_MI
	.global _NOTA_FA
	.global _NOTA_SOL
	.global _NOTA_LA
	.global _NOTA_SI

	
/**@brief LAS SIGUIENTES FUNCIONES SON LAS NOTAS A UTILIZAR
; */
_NOTA_DO:
    CLR TMR1
    MOV #55, PR1
    MOV #0X8020, T1CON
    RETURN
    
_NOTA_RE:
    CLR TMR1
    MOV #49, PR1
    MOV #0X8020, T1CON
    RETURN

_NOTA_MI:
    CLR TMR1
    MOV #11, PR1
    MOV #0X8020, T1CON
    RETURN

_NOTA_FA:
    CLR TMR1
    MOV #2639, PR1
    MOV #0X8020, T1CON
    RETURN
    
_NOTA_SOL:
    CLR TMR1
    MOV #2351, PR1
    MOV #0X8020, T1CON
    RETURN
    
_NOTA_LA:
    CLR TMR1
    MOV #8, PR1
    MOV #0X8020, T1CON
    RETURN
    
_NOTA_SI:
    CLR TMR1
    MOV #1866, PR1
    MOV #0X8020, T1CON
    RETURN
    
/**@brief Esta rutina se usa como contador respecto a una interrupcion
; *    generada por un sensor
; * @PARAM: W0, VALOR A CONVERTIR
; */
__INT0Interrupt:
    PUSH W0
    BGT LATD, #RD3
    BCLR    IFS0,   #INT0IF
    POP	    W0
    RETFIE
    