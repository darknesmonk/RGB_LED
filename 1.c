/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 30.08.2015
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 2,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#define L PORTD
#include "led.c"
#include <mega8.h>
#include <delay.h>
#include <sleep.h>
#define ALL 13 + 1

  volatile unsigned char count=0,step=0,sr=0;
  unsigned char rgb[38][3][8] = {0}; 
  eeprom unsigned char type;
 
// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here

      
}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
     
    #asm("cli")
        if(count>8) count=0;
    OCR2=rgb[step][0][count];      //RED
    OCR1A=rgb[step][1][count];     // GREEN
    OCR1B=rgb[step][2][count];     //BLUE    
     L = (1<<count++);  
       #asm("sei")    
             
}
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
 TCNT0=180;
step=(step>=sr)?0:(step+1); 
               
}

// Declare your global variables here
void sleep()
{
//unsigned char x;
//x = (MCUCR & ~(1 << BODSE)) | (1 << BODS); // подготовка бит
//MCUCR = x | (1 << BODSE); // процедура отключения BOD
//MCUCR = x;
MCUCR=0x00; 
#asm("cli");
 sleep_enable(); 
 powerdown();
}
void conv(flash unsigned char *pic,unsigned int so )
{
unsigned int ii=0,c;
unsigned char i,j;
register unsigned char r=0,g=0,b=0;
sr=so/16;

for (j=0;j<=sr; j++)
{
for(i=0; i<8 ; i++)
{   if(ii>=so) ii=0;  
 c=pic[ii++]|(pic[ii++]<<8);
       
 r=(0xF800 & c)>>11;
 g=(0x07E0 & c) >>5;
 b=(0x001F & c);  
 
 rgb[j][0][i] =(float)r/31 * 130;
 rgb[j][1][i] =(float)g/63  * 150;
 rgb[j][2][i] = (float)b/31 * 150;  
 
}
}
}
void main(void)
{
unsigned char i=0;
    #asm("cli")
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=T 
PORTB=0x00;
DDRB=0x0E;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=P State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x40;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0xFF;




// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 250,000 kHz
TCCR0=0x03;
TCNT0=180;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 2000,000 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xF1;
//TCCR1B=0x09;
TCCR1B=0x01;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 2000,000 kHz
// Mode: Fast PWM top=0xFF
// OC2 output: Non-Inverted PWM
ASSR=0x00;
//TCCR2=0x79;
 TCCR2=0x71;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x45;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
 
if ((MCUCSR & 1)) { MCUCSR=0; 

   OCR2=100;
 for (i=0; i<8; i++) {  L   =1<<i; delay_ms(100);} OCR2=OCR1A=OCR1B=0;  
  
  OCR1A=100;
 for (i=0; i<8; i++) {  L   =1<<i;  delay_ms(100); } OCR2=OCR1A=OCR1B=0;  

  OCR1B=100;
 for (i=0; i<8; i++) {  L   =1<<i;  delay_ms(100); }   OCR2=OCR1A=OCR1B=0;  
  L=0;  
  type=0;
sleep();}      


if ((MCUCSR & 2))
{
type=(type>ALL)?1:(type+1);
MCUCSR=0; if(type>=ALL) {  type=0; sleep(); }
}


  switch(type)
  {
  case 1:  conv(pp,sizeof(pp)); break; 
   case 2:  conv(pp2,sizeof(pp2)); break;
    case 3: conv(pp3,sizeof(pp3)); break;
     case 4:  conv(pp4,sizeof(pp4)); break;
      case 5:  conv(pp5,sizeof(pp5)); break;
       case 6:  conv(pp6,sizeof(pp6)); break;
        case 7:  conv(pp7,sizeof(pp7)); break;     
        case 8:  conv(pp8,sizeof(pp8)); break;  
         case 9:  conv(pp9,sizeof(pp9)); break;
          case 10:  conv(pp10,sizeof(pp10)); break;      
           case 11:  conv(pp11,sizeof(pp11)); break;
            case 12:  conv(pp12,sizeof(pp12)); break;   
            case 13:  conv(pp13,sizeof(pp13)); break;
  }
   
 #asm("sei")
  while(1){     }

 
}
