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
/*                      BITS DE CONFIGURACIÓN                                   */ 
/********************************************************************************/
/* SE DESACTIVA EL CLOCK SWITCHING Y EL FAIL-SAFE CLOCK MONITOR (FSCM) Y SE     */
/* ACTIVA EL OSCILADOR INTERNO (FAST RC) PARA TRABAJAR                          */
/* FSCM: PERMITE AL DISPOSITIVO CONTINUAR OPERANDO AUN CUANDO OCURRA UNA FALLA  */
/* EN EL OSCILADOR. CUANDO OCURRE UNA FALLA EN EL OSCILADOR SE GENERA UNA       */
/* TRAMPA Y SE CAMBIA EL RELOJ AL OSCILADOR FRC                                 */
/********************************************************************************/
//_FOSC(CSW_FSCM_OFF & FRC); 
#pragma config FOSFPR = FRC             // Oscillator (Internal Fast RC (No change to Primary Osc Mode bits))
#pragma config FCKSMEN = CSW_FSCM_OFF   // Clock Switching and Monitor (Sw Disabled, Mon Disabled)/********************************************************************************/
/* SE DESACTIVA EL WATCHDOG                                                     */
/********************************************************************************/
//_FWDT(WDT_OFF); 
#pragma config WDT = WDT_OFF            // Watchdog Timer (Disabled)
/********************************************************************************/
/* SE ACTIVA EL POWER ON RESET (POR), BROWN OUT RESET (BOR),                    */ 
/* POWER UP TIMER (PWRT) Y EL MASTER CLEAR (MCLR)                               */
/* POR: AL MOMENTO DE ALIMENTAR EL DSPIC OCURRE UN RESET CUANDO EL VOLTAJE DE   */ 
/* ALIMENTACIÓN ALCANZA UN VOLTAJE DE UMBRAL (VPOR), EL CUAL ES 1.85V           */
/* BOR: ESTE MODULO GENERA UN RESET CUANDO EL VOLTAJE DE ALIMENTACIÓN DECAE     */
/* POR DEBAJO DE UN CIERTO UMBRAL ESTABLECIDO (2.7V)                            */
/* PWRT: MANTIENE AL DSPIC EN RESET POR UN CIERTO TIEMPO ESTABLECIDO, ESTO      */
/* AYUDA A ASEGURAR QUE EL VOLTAJE DE ALIMENTACIÓN SE HA ESTABILIZADO (16ms)    */
/********************************************************************************/
//_FBORPOR( PBOR_ON & BORV27 & PWRT_16 & MCLR_EN ); 
// FBORPOR
#pragma config FPWRT  = PWRT_16          // POR Timer Value (16ms)
#pragma config BODENV = BORV20           // Brown Out Voltage (2.7V)
#pragma config BOREN  = PBOR_ON          // PBOR Enable (Enabled)
#pragma config MCLRE  = MCLR_EN          // Master Clear Enable (Enabled)
/********************************************************************************/
/*SE DESACTIVA EL CÓDIGO DE PROTECCIÓN                                          */
/********************************************************************************/
//_FGS(CODE_PROT_OFF);      
// FGS
#pragma config GWRP = GWRP_OFF          // General Code Segment Write Protect (Disabled)
#pragma config GCP = CODE_PROT_OFF      // General Segment Code Protection (Disabled)
 
/********************************************************************************/
/* SECCIÓN DE DECLARACIÓN DE CONSTANTES CON DEFINE                              */
/********************************************************************************/
#define EVER 1
#define MUESTRAS 64
 
/********************************************************************************/
/* DECLARACIONES GLOBALES                                                       */
/********************************************************************************/
/*DECLARACIÓN DE LA ISR DEL TIMER 1 USANDO __attribute__                        */
/********************************************************************************/
void __attribute__((__interrupt__)) _T1Interrupt( void );
 
/********************************************************************************/
/* CONSTANTES ALMACENADAS EN EL ESPACIO DE LA MEMORIA DE PROGRAMA               */
/********************************************************************************/
int ps_coeff __attribute__ ((aligned (2), space(prog)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS EN EL ESPACIO X DE LA MEMORIA DE DATOS            */
/********************************************************************************/
int x_input[MUESTRAS] __attribute__ ((space(xmemory)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS EN EL ESPACIO Y DE LA MEMORIA DE DATOS            */
/********************************************************************************/
int y_input[MUESTRAS] __attribute__ ((space(ymemory)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS LA MEMORIA DE DATOS CERCANA (NEAR), LOCALIZADA    */
/* EN LOS PRIMEROS 8KB DE RAM                                                   */
/********************************************************************************/
int var1 __attribute__ ((near));
//Arreglo de valores para arreglo
const unsigned short int seno [] = {
    2048,3496,4095,3496,2048,600,0,600
};
int CONT = 0;
char flag = 1;
//Para que el arreglo se coloque en memoria de programa se debe agregar la 
//palara const. Al hacer el arreglo constante lo mete a la memoria flash al 
//momento de programarlo
void iniPerifericos( void );
void iniInterrupciones( void );
void RETARDO_1S(void);
void RETARDO_15ms(void);
void RETARDO_5S(void);
void WR_DAC(int CONT);

int main (void){
    /*Configurar el timer 1  y el timer 3 
     * Generar la frecuencia de reloj MAX295
     * frecuencia de la senial es de 1 khz f = 1khz
     * fs = 8khz
     * fc = 1152 hz para recuperar la componente fundamental
     * FCLK = 50fc = 50*1152 = 57600
     * FT1IF = frecuencia de interrupcion del timer 1
     * FT1IF = FCLK * 2 = 115200
      */
    /**
     * Timer 3
     * Generar la Frecuencia de muestreo fs
     * cada vez que se genere una interrupcion se manda un dato hacia 
     * el DAC del arreglo
     * f = 1khz
     * fs  8khz
     * FT1IF = fs = 8khz
     * @return 
     */ 
    /**
     * Configurar DAC
     */
    /**
     * Configurar interrupciones 
     * timer 1 y 3
     * IFSO, T1IF
     * IFS0, T3IF 
     */
    iniPerifericos();
    iniInterrupciones();

            
  for(;EVER;){
      //Aplicacion con push para diente de sierra y triangular
      
      if(!PORTDbits.RD1){
          WR_DAC(CONT);
          CONT++;
      }
      else{
          WR_DAC(CONT);
          CONT++;
          if(CONT == 0x0FFF){
          while(CONT != 0){
             CONT--;
             WR_DAC(CONT); 
          }
      }
      }
      
      Nop();
  }
    return 0;
}
/****************************************************************************/
/* DESCRICION:  ESTA RUTINA INICIALIZA LAS INTERRPCIONES                    */
/* PARAMETROS: NINGUNO                                                      */
/* RETORNO: NINGUNO                                                         */
/****************************************************************************/



void iniPerifericos( void ){
    //CONFIGURACION DE LOS PUERTOS 
    //Se puedo camibiar para hacer bit por bit
    PORTA = 0; 
    Nop();
    LATA = 0;
    Nop();
    TRISA = 0;
    Nop();
 
    PORTD = 0;
    Nop();
    LATD = 0;
    Nop();
    TRISD = 0;
    Nop();
    
    
    PORTF = 0;
    Nop();
    LATF = 0;
    Nop();
    TRISF = 0;
    Nop();
    
    
    PORTAbits.RA11 = 0;
    Nop();
    PORTDbits.RD0 = 0;
    Nop();
    PORTFbits.RF3 = 0;
    Nop();
    PORTFbits.RF6 = 0;
    Nop();
    
    SPI1STAT = 0;
    SPI1CON = 0X053F;
    SPI1STATbits.SPIEN = 1;
}
void iniInterrupciones( void )
{
    IFS0bits.T1IF = 0; //Apaga la bandera 
    IEC0bits.T1IE = 1; //Enciende el bit que activa el    
}
void RETARDO_5S(void){
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
}

/********************************************************************************/
/* DESCRICION:  ISR (INTERRUPT SERVICE ROUTINE) DEL TIMER 1                     */
/* LA RUTINA TIENE QUE SER GLOBAL PARA SER UNA ISR                              */ 
/* SE USA PUSH.S PARA GUARDAR LOS REGISTROS W0, W1, W2, W3, C, Z, N Y DC EN LOS */
/* REGISTROS SOMBRA                                                             */
/********************************************************************************/

