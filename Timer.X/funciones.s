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
    SETM PR1
    MOV #0X8020, T1CON
    RETURN
    
_NOTA_RE:
    CLR TMR1
    SETM PR1
    MOV #0X8020, T1CON
    RETURN

_NOTA_MI:
    CLR TMR1
    SETM PR1
    MOV #0X8020, T1CON
    RETURN

_NOTA_FA:
    CLR TMR1
    SETM PR1
    MOV #0X8020, T1CON
    RETURN
    
_NOTA_SOL:
    CLR TMR1
    SETM PR1
    MOV #0X8020, T1CON
    RETURN
    
_NOTA_LA:
    CLR TMR1
    SETM PR1
    MOV #0X8020, T1CON
    RETURN
    
_NOTA_SI:
    CLR TMR1
    SETM PR1
    MOV #0X8020, T1CON
    RETURN
    
/**@brief Esta rutina se usa como contador respecto a una interrupcion
; *    generada por un sensor
; * @PARAM: W0, VALOR A CONVERTIR
; */
__INT0Interrupt:
    PUSH W0
    INC _uni
    CP _uni, #10
    BRA NZ, FIN_INTERRUPCION ; SI NO ES IGUAL A 10 SALTA
    CLR _uni
    INC _dece
    CP _dece, #10
    BRA NZ, FIN_INTERRUPCION
    CLR _dece
    INC _cen
    CP _cen, #10
    BRA NZ, FIN_INTERRUPCION
    CLR _cen
    INC _umi
    CP _umi, #10
    BRA NZ, FIN_INTERRUPCION
    CLR _umi
    
FIN_INTERRUPCION:
    BCLR    IFS0,   #INT0IF
    POP	    W0
    RETFIE
    
    