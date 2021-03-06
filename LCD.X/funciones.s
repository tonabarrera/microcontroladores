        .include "p30F4013.inc"

        .global _CONV_CODIGO
	.global _INT0Interrupt
	.global _uni
	.global _dece
	.global _cen
	.global _umi
	
/**@brief ESTA RUTINA REALIZA UN CONVERTIDOR DE CODIGO
; * @PARAM: W0, VALOR A CONVERTIR
; */
_CONV_CODIGO:
    BRA W0
    RETLW #0X6D, W0 ; DIGITO 2
    RETLW #0X7E, W0 ; DIGITO 0
    RETLW #0X30, W0 ; DIGITO 1
    RETLW #0X5F, W0 ; DIGITO 6
    RETLW #0X5F, W0 ; DIGITO 6
    RETLW #0X79, W0 ; DIGITO 3
    RETLW #0X7E, W0 ; DIGITO 0
    RETLW #0X7E, W0 ; DIGITO 0
    RETLW #0X6D, W0 ; DIGITO 2
    RETLW #0X79, W0 ; DIGITO 3
    
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
    
    