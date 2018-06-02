/**@brief: Este programa muestra los bloques de un 
 * programa en C embebido para el DSPIC, los bloques son:
 * BLOQUE 1. OPCIONES DE CONFIGURACION DEL DSC: OSCILADOR, WATCHDOG,
 * BROWN OUT RESET, POWER ON RESET Y CODIGO DE PROTECCION
 * BLOQUE 2. EQUIVALENCIAS Y DECLARACIONES GLOBALES
 * BLOQUE 3. ESPACIOS DE MEMORIA: PROGRAMA, DATOS X, DATOS Y, DATOS NEAR
 * BLOQUE 4. CÓDIGO DE APLICACIÓN
 * @device: DSPIC30F4013
 * @oscillator: FRC, 7.3728MHz
 */
#include "p30F4013.h"
/********************************************************************************/
/* 						BITS DE CONFIGURACIÓN									*/	
/********************************************************************************/
/* SE DESACTIVA EL CLOCK SWITCHING Y EL FAIL-SAFE CLOCK MONITOR (FSCM) Y SE 	*/
/* ACTIVA EL OSCILADOR INTERNO (FAST RC) PARA TRABAJAR							*/
/* FSCM: PERMITE AL DISPOSITIVO CONTINUAR OPERANDO AUN CUANDO OCURRA UNA FALLA 	*/
/* EN EL OSCILADOR. CUANDO OCURRE UNA FALLA EN EL OSCILADOR SE GENERA UNA 		*/
/* TRAMPA Y SE CAMBIA EL RELOJ AL OSCILADOR FRC  								*/
/********************************************************************************/
//_FOSC(CSW_FSCM_OFF & FRC); 
#pragma config FOSFPR = FRC             // Oscillator (Internal Fast RC (No change to Primary Osc Mode bits))
#pragma config FCKSMEN = CSW_FSCM_OFF   // Clock Switching and Monitor (Sw Disabled, Mon Disabled)/********************************************************************************/
/* SE DESACTIVA EL WATCHDOG														*/
/********************************************************************************/
//_FWDT(WDT_OFF); 
#pragma config WDT = WDT_OFF            // Watchdog Timer (Disabled)
/********************************************************************************/
/* SE ACTIVA EL POWER ON RESET (POR), BROWN OUT RESET (BOR), 					*/	
/* POWER UP TIMER (PWRT) Y EL MASTER CLEAR (MCLR)								*/
/* POR: AL MOMENTO DE ALIMENTAR EL DSPIC OCURRE UN RESET CUANDO EL VOLTAJE DE 	*/	
/* ALIMENTACIÓN ALCANZA UN VOLTAJE DE UMBRAL (VPOR), EL CUAL ES 1.85V			*/
/* BOR: ESTE MODULO GENERA UN RESET CUANDO EL VOLTAJE DE ALIMENTACIÓN DECAE		*/
/* POR DEBAJO DE UN CIERTO UMBRAL ESTABLECIDO (2.7V) 							*/
/* PWRT: MANTIENE AL DSPIC EN RESET POR UN CIERTO TIEMPO ESTABLECIDO, ESTO 		*/
/* AYUDA A ASEGURAR QUE EL VOLTAJE DE ALIMENTACIÓN SE HA ESTABILIZADO (16ms) 	*/
/********************************************************************************/
//_FBORPOR( PBOR_ON & BORV27 & PWRT_16 & MCLR_EN ); 
// FBORPOR
#pragma config FPWRT  = PWRT_16          // POR Timer Value (16ms)
#pragma config BODENV = BORV20           // Brown Out Voltage (2.7V)
#pragma config BOREN  = PBOR_ON          // PBOR Enable (Enabled)
#pragma config MCLRE  = MCLR_EN          // Master Clear Enable (Enabled)
/********************************************************************************/
/*SE DESACTIVA EL CÓDIGO DE PROTECCIÓN											*/
/********************************************************************************/
//_FGS(CODE_PROT_OFF);      
// FGS
#pragma config GWRP = GWRP_OFF          // General Code Segment Write Protect (Disabled)
#pragma config GCP = CODE_PROT_OFF      // General Segment Code Protection (Disabled)

/********************************************************************************/
/* SECCIÓN DE DECLARACIÓN DE CONSTANTES CON DEFINE								*/
/********************************************************************************/
#define EVER 1
#define MUESTRAS 64

/********************************************************************************/
/* DECLARACIONES GLOBALES														*/
/********************************************************************************/
/*DECLARACIÓN DE LA ISR DEL TIMER 1 USANDO __attribute__						*/
/********************************************************************************/
void __attribute__((__interrupt__)) _T1Interrupt( void );

/********************************************************************************/
/* CONSTANTES ALMACENADAS EN EL ESPACIO DE LA MEMORIA DE PROGRAMA				*/
/********************************************************************************/
int ps_coeff __attribute__ ((aligned (2), space(prog)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS EN EL ESPACIO X DE LA MEMORIA DE DATOS			*/
/********************************************************************************/
int x_input[MUESTRAS] __attribute__ ((space(xmemory)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS EN EL ESPACIO Y DE LA MEMORIA DE DATOS			*/
/********************************************************************************/
int y_input[MUESTRAS] __attribute__ ((space(ymemory)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS LA MEMORIA DE DATOS CERCANA (NEAR), LOCALIZADA	*/
/* EN LOS PRIMEROS 8KB DE RAM													*/
/********************************************************************************/
int var1 __attribute__ ((near));

void iniPuertos( void );
void iniWIFI(void);
void configWIFI(void);
void iniInterrupciones( void );
void RETARDO_1S(void);
void comandoAT(unsigned char []); // Talvez es unsigned

int main (void) {
    iniPuertos();
    
    // TIMER3 fT3IF = 512 Hz con FCY, la preescala es 1 (PENDIENTE)
    T3CON = 0x0000;
    PR3 = 3600;
    TMR3 = 0;
    
    // UART1 baudios = 115200 (PENDIENTE)
    U1MODE = 0x0420;
    U1STA = 0X8000;
    U1BRG = 0;
    
    // UART2 (PENDIENTE)
    U2MODE = 0x0020;
    U2STA = 0x8000;
    U2BRG = 0;
    
    // ADC
    ADCON1 = 0x0044;
    ADCON2 = 0x0000; //0x6000 referencias externas
    ADCON3 = 0x0F02;
    ADCHS = 2;
    ADPCFG = 0xFFF8;
    ADCSSL = 0;
    
    iniInterrupciones();
    
    // Habilitacion de perifericos
    
    // Habilitar TIMER3
    T3CONbits.TON = 1;
    
    // Habilitar UART2
    U2MODEbits.UARTEN = 1;
    U2STAbits.UTXEN = 1;
    
     // Habilitar UART1
    U1MODEbits.UARTEN = 1;
    U1STAbits.UTXEN = 1;
    
    // Habilitar ADC
    ADCON1bits.ADON = 1;
    
    // INICIALIZAR WIFI
    iniWIFI();
    
    // CONFIGURAR WIFI
    configWIFI();
    
    for(;EVER;) {
        Nop();
    }
    
    /*---------------------FIN VERSION 2---------------------*/
    return 0;
}

void configWIFI(void) {
    comandoAT("ATE0\r\n");
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    comandoAT("AT+RST\r\n");
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    comandoAT("AT+CWMODE=3\r\n"); // modo softap
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    comandoAT("AT+CIPMUX=0\r\n"); // conexion simple
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    comandoAT("AT+CWJAP=\"Tenda_06DEC0\",\"MqZe5RY4\"\r\n");
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    comandoAT("AT+CIFSR\r\n"); // optener ip local  
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    comandoAT("AT+CIPSTART=\"TCP\",\"192.168.0.117\",7200\r\n");
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    // El maximo de ethernet 1500
    comandoAT("AT+CIPSEND=2048\r\n"); // cantidad de bytes a mandar el max es 2048
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
}

void iniWIFI(void) {
    PORTBbits.RB8 = 1;
    Nop();
    
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();

    
    PORTDbits.RD1 = 1;
    Nop();
    
    RETARDO_1S();
    
    PORTDbits.RD1 = 0;
    Nop();
    
    RETARDO_1S();
    RETARDO_1S();

    
    PORTDbits.RD1 = 1;
    Nop();
    
    RETARDO_1S();
    RETARDO_1S();
}

/****************************************************************************/
/* DESCRICION:	ESTA RUTINA INICIALIZA LAS INTERRPCIONES    				*/
/* PARAMETROS: NINGUNO                                                      */
/* RETORNO: NINGUNO															*/
/****************************************************************************/
void iniInterrupciones( void ) {
    // TIMER 3
    IFS0bits.T3IF = 0;
    IEC0bits.T3IE = 1;
    // ADC
    IFS0bits.ADIF = 0;
    IEC0bits.ADIE = 1;
    // UART2
    IFS1bits.U2RXIF = 0;
    IEC1bits.U2RXIE = 1;
}
/****************************************************************************/
/* DESCRICION:	ESTA RUTINA INICIALIZA LOS PUERTOS						*/
/* PARAMETROS: NINGUNO                                                      */
/* RETORNO: NINGUNO															*/
/****************************************************************************/
void iniPuertos( void ) {
    PORTB = 0;
    Nop();
    LATB = 0;
    Nop();
    
    PORTC = 0;
    Nop();
    LATC = 0;
    Nop();
    
    PORTD = 0;
    Nop();
    LATD = 0;
    Nop();
    
    PORTF = 0;
    Nop();
    LATF = 0;
    Nop();
    
    // UART1
    // Tx
    TRISCbits.TRISC13 = 0;
    Nop();
    
    // Rx
    TRISCbits.TRISC14 = 1;
    Nop();
    
    // UART2 (WIFI)
    // Tx
    TRISFbits.TRISF5 = 1;
    Nop();
    
    // Rx
    TRISFbits.TRISF4 = 0;
    Nop();
    
    // CS
    TRISBbits.TRISB8 = 0;
    Nop();

    // RST
    TRISDbits.TRISD1 = 0;
    Nop();
    
    // TIMER 3 de prueba
    TRISDbits.TRISD0 = 0;
    Nop();
    
    // ADC
    TRISBbits.TRISB0 = 1;
    Nop();
    TRISBbits.TRISB1 = 1;
    Nop();
    TRISBbits.TRISB2 = 1;
    Nop();
}