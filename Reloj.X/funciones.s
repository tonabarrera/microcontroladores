.include "p30F4013.inc"
.global _PASO_DE_LA_MUERTE 
.global __T1Interrupt
    
.global _USEG
.global _DSEG
.global _UMIN
.global _DMIN
.global _UHR
.global _DHR


__T1Interrupt:
    PUSH W0
    
    INC.B _USEG
    MOV #10, W0
    CP.B _USEG
    BRA NZ, FIN_INTERRUPCION
    
    CLR.B _USEG
    INC.B _DSEG
    MOV #6, W0
    CP.B _DSEG
    BRA NZ, FIN_INTERRUPCION
    
    CLR.B _DSEG
    INC.B _UMIN
    MOV #10, W0
    CP.B _UMIN
    BRA NZ, FIN_INTERRUPCION
    
    CLR.B _UMIN
    INC.B _DMIN
    MOV #6, W0
    CP.B _DMIN
    BRA NZ, FIN_INTERRUPCION
    
    CLR.B _DMIN
    INC.B _UHR
    MOV #4, W0
    CP.B _UHR
    BRA Z, ARREGLAR_HORA
    
    PROSEGUIR_NORMAL:
    MOV #10, W0
    CP.B _UHR
    BRA NZ, FIN_INTERRUPCION
    
    CLR.B _UHR
    INC.B _DHR
    
    FIN_INTERRUPCION:
    BCLR    IFS0,   #T1IF
    
    POP W0
    RETFIE

ARREGLAR_HORA:
    MOV #2, W0
    CP.B _DHR
    BRA NZ, PROSEGUIR_NORMAL
    CLR.B _UHR
    CLR.B _DHR
    GOTO FIN_INTERRUPCION
    
    
_PASO_DE_LA_MUERTE:
    PUSH W0
    PUSH W1
    PUSH W2
    CLR TMR1
    MOV #0X8000, W0
    MOV W0, PR1
    MOV	#0X0002, W0
    MOV W0, T1CON
    MOV	#OSCCONL, W2
    MOV	#0X46, W0
    MOV	#0X57, W1
    MOV.B W0, [W2]
    MOV.B W1, [W2]
    BSET OSCCONL, #LPOSCEN
    POP W2
    POP W1
    POP W0
    RETURN
    
    
    
    


