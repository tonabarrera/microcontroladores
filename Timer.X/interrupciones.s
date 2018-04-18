        .include "p30F4013.inc"

	.global __T1Interrupt
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
    PUSH W0
    CLR TMR1
    MOV #55, W0
    MOV W0, PR1
    MOV #0X8020, W0
    MOV W0, T1CON
    POP W0
    RETURN
    
_NOTA_RE:
    PUSH W0
    CLR TMR1
    MOV #49, W0
    MOV W0, PR1
    MOV #0X8020, W0
    MOV W0, T1CON
    POP W0
    RETURN

_NOTA_MI:
    PUSH W0
    CLR TMR1
    MOV #11, W0
    MOV W0, PR1
    MOV #0X8020, W0
    MOV W0, T1CON
    POP W0
    RETURN

_NOTA_FA:
    PUSH W0
    CLR TMR1
    MOV #2639, W0
    MOV W0, PR1
    MOV #0X8020, W0
    MOV W0, T1CON
    POP W0
    RETURN
    
_NOTA_SOL:
    PUSH W0
    CLR TMR1
    MOV #2351, W0
    MOV W0, PR1
    MOV #0X8020, W0
    MOV W0, T1CON
    POP W0
    RETURN
    
_NOTA_LA:
    PUSH W0
    CLR TMR1
    MOV #8, W0
    MOV W0, PR1
    MOV #0X8020, W0
    MOV W0, T1CON
    POP W0
    RETURN
    
_NOTA_SI:
    PUSH W0
    CLR TMR1
    MOV #1866, W0
    MOV W0, PR1
    MOV #0X8020, W0
    MOV W0, T1CON
    POP W0
    RETURN
    
/**@brief Esta es la rutina del timer 1
; */
__T1Interrupt:
    PUSH W0
    BTG LATD, #RD3
    NOP
    BCLR    IFS0,   #T1IF
    POP	    W0
    RETFIE
    