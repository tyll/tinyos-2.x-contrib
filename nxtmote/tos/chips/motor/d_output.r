#define MOTOR_A_DIR		 AT91C_PIO_PA1
#define MOTOR_A_INT		 AT91C_PIO_PA15

#define MOTOR_B_DIR		 AT91C_PIO_PA9
#define MOTOR_B_INT		 AT91C_PIO_PA26

#define MOTOR_C_DIR		 AT91C_PIO_PA8
#define MOTOR_C_INT		 AT91C_PIO_PA0

#define FORWARD			 0x01
#define REVERSE			 -0x01

#define TIMER_0_ID12	(1L << AT91C_ID_TC0)
#define TIMER_1_ID13	(1L << AT91C_ID_TC1)
#define TIMER_2_ID14	(1L << AT91C_ID_TC2)

typedef   struct
{
  SLONG TachoCountTable;
  SLONG TachoCountTableOld;
  SBYTE MotorDirection;
}TACHOPARAMETERS;

static TACHOPARAMETERS MotorTachoValue[3];

#define   OUTPUTInit                     {\
                                          UBYTE Tmp;\
                                          for (Tmp = 0; Tmp < NOS_OF_AVR_OUTPUTS; Tmp++)\
                                          {\
                                            IoToAvr.PwmValue[Tmp] = 0;\
                                          }\
                                          IoToAvr.OutputMode = 0x00;\
                                          IoToAvr.PwmFreq    = 8;\
                                        }

#define   INSERTSpeed(Motor, Speed)     IoToAvr.PwmValue[Motor] = Speed

#define   INSERTMode(Motor, Mode)       if (Mode & 0x02)\
                                        {\
                                          IoToAvr.OutputMode |=  (0x01 << Motor);\
                                        }\
                                        else\
                                        {\
                                          IoToAvr.OutputMode &= ~(0x01 << Motor);\
                                        }

#define   ENABLEDebugOutput				{\
                                          *AT91C_PIOA_PER   = 0x20000000;                /* Enable PIO on PA029 */\
                                          *AT91C_PIOA_OER   = 0x20000000;                /* PA029 set to Output  */\
                                        }

#define   SETDebugOutputHigh			*AT91C_PIOA_SODR	= 0x20000000

#define   SETDebugOutputLow				*AT91C_PIOA_CODR	= 0x20000000

#define   ENABLECaptureMotorA           {\
                                          *AT91C_PIOA_PDR    = MOTOR_A_INT;					                    /* Disable PIO on PA15 */\
                                          *AT91C_PIOA_BSR    = MOTOR_A_INT;					                    /* Enable Peripheral B on PA15 */\
                                          *AT91C_PIOA_PPUDR  = MOTOR_A_INT | MOTOR_A_DIR;	                    /* Disable Pull Up resistor on PA15 & PA1 */\
                                          *AT91C_PIOA_PER    = MOTOR_A_DIR;					                    /* Enable PIO on PA1 */\
                                          *AT91C_PIOA_ODR    = MOTOR_A_DIR;					                    /* PA1 set to input  */\
                                          *AT91C_PIOA_IFER   = MOTOR_A_INT | MOTOR_A_DIR;	                    /* Enable filter on PA15 & PA1 */\
										  *AT91C_PMC_PCER    = TIMER_1_ID13;				                    /* Enable clock for TC1*/\
										  *AT91C_TCB_BMR     = AT91C_TCB_TC1XC1S_NONE;  	                    /* No external clock signal XC2 */\
										  *AT91C_TCB_BCR     = 0x0;							                    /* Clear SYNC */\
										  *AT91C_TC1_CMR	 = *AT91C_TC1_CMR & 0X00000000;                     /* Clear all bits in TC1_CMR */\
										  *AT91C_TC1_CMR     = *AT91C_TC1_CMR & 0xFFFF7FFF;                     /* Enable capture mode */\
                                          *AT91C_TC1_CMR     = *AT91C_TC1_CMR | AT91C_TC_CLKS_TIMER_DIV5_CLOCK; /* Set clock for timer to Clock5 = div 1024*/\
                                          *AT91C_TC1_CMR     = *AT91C_TC1_CMR | AT91C_TC_ABETRG;                /* Use external trigger for TIO1*/\
                                          *AT91C_TC1_CMR     = *AT91C_TC1_CMR | AT91C_TC_EEVTEDG_BOTH;          /* Trigger on both edges */\
                                          *AT91C_TC1_CMR     = *AT91C_TC1_CMR | AT91C_TC_LDRA_RISING;           /* RA loading register set */\
                                          *AT91C_AIC_IDCR    = TIMER_1_ID13;				                    /* Irq controller setup */\
                                           AT91C_AIC_SVR[13] = (unsigned int)CaptureAInt; \
                                           AT91C_AIC_SMR[13] = 0x05;						                    /* Enable trigger on level */\
                                          *AT91C_AIC_ICCR    = TIMER_1_ID13;				                    /* Clear interrupt register PID13*/\
                                          *AT91C_TC1_IDR     = 0xFF;						                    /* Disable all interrupt from TC1 */\
                                          *AT91C_TC1_IER     = 0x80;						                    /* Enable interrupt from external trigger */\
                                          *AT91C_AIC_IECR    = TIMER_1_ID13;				                    /* Enable interrupt from TC1 */\
                                          *AT91C_TC1_CCR     = 0x00;						                    /* Clear registers before setting */\
                                          *AT91C_TC1_CCR     = AT91C_TC_CLKEN;						            /* Enable clock */\
                                        }

#define   ENABLECaptureMotorB           {\
                                          *AT91C_PIOA_PDR    = MOTOR_B_INT;					                    /* Disable PIO on PA26 */\
                                          *AT91C_PIOA_BSR    = MOTOR_B_INT;					                    /* Enable Peripheral B on PA26 */\
                                          *AT91C_PIOA_PER    = MOTOR_B_DIR;					                    /* Enable PIO on PA09 */\
                                          *AT91C_PIOA_PPUDR  = MOTOR_B_INT | MOTOR_B_DIR;   					/* Disable Pull Up resistor on PA26 & PA09  */\
                                          *AT91C_PIOA_ODR    = MOTOR_B_DIR;					                    /* PA09 set to input  */\
                                          *AT91C_PIOA_IFER   = MOTOR_B_INT | MOTOR_B_DIR;					    /* Enable filter on PA26 & PA09 */\
										  *AT91C_PMC_PCER    = TIMER_2_ID14;						            /* Enable clock for TC2*/\
										  *AT91C_TCB_BMR     = AT91C_TCB_TC2XC2S_NONE;      					/* No external clock signal */\
										  *AT91C_TCB_BCR     = 0x0;							                    /* Clear SYNC */\
										  *AT91C_TC2_CMR	 = *AT91C_TC2_CMR & 0X00000000;                     /* Clear all bits in TC1_CMR */\
										  *AT91C_TC2_CMR     = *AT91C_TC2_CMR & 0xFFFF7FFF;                     /* Enable capture mode */\
										  *AT91C_TC2_CMR     = *AT91C_TC2_CMR | AT91C_TC_CLKS_TIMER_DIV5_CLOCK; /* Set clock for timer to Clock5 = div 1024*/\
                                          *AT91C_TC2_CMR     = *AT91C_TC2_CMR | AT91C_TC_ABETRG;                /* Use external trigger for TIO2*/\
										  *AT91C_TC2_CMR     = *AT91C_TC2_CMR | AT91C_TC_EEVTEDG_BOTH;          /* Trigger on both edges */\
                                          *AT91C_TC2_CMR     = *AT91C_TC2_CMR | AT91C_TC_LDRA_RISING;           /* RA loading register set */\
                                          *AT91C_AIC_IDCR    = TIMER_2_ID14;						                    /* Irq controller setup */\
                                           AT91C_AIC_SVR[14] = (unsigned int)CaptureBInt; \
                                           AT91C_AIC_SMR[14] = 0x05;						                    /* Enable trigger on level */\
                                          *AT91C_AIC_ICCR    = TIMER_2_ID14;						            /* Clear interrupt register PID14*/\
                                          *AT91C_TC2_IDR     = 0xFF;						                    /* Disable all interrupt from TC2 */\
                                          *AT91C_TC2_IER     = 0x80;						                    /* Enable interrupts from external trigger */\
                                          *AT91C_AIC_IECR    = TIMER_2_ID14;						            /* Enable interrupt from TC2 */\
                                          *AT91C_TC2_CCR     = 0x00;						                    /* Clear registers before setting */\
                                          *AT91C_TC2_CCR     = AT91C_TC_CLKEN;						            /* Enable clock */\
                                        }

  #define   ENABLECaptureMotorC           {\
                                          *AT91C_PIOA_PDR    = MOTOR_C_INT;					                    /* Disable PIO on PA0 */\
                                          *AT91C_PIOA_BSR    = MOTOR_C_INT;					                    /* Enable Peripheral B on PA0 */\
                                          *AT91C_PIOA_PER    = MOTOR_C_DIR;					                    /* Enable PIO on PA08 */\
                                          *AT91C_PIOA_PPUDR  = MOTOR_C_INT | MOTOR_C_DIR;					    /* Disable Pull Up resistor on PA0 & PA08  */\
                                          *AT91C_PIOA_ODR    = MOTOR_C_DIR;					                    /* PA08 set to input  */\
                                          *AT91C_PIOA_IFER   = MOTOR_C_INT | MOTOR_C_DIR;					    /* Enable filter on PA26 & PA09 */\
										  *AT91C_PMC_PCER    = TIMER_0_ID12;				                    /* Enable clock for TC0*/\
										  *AT91C_TCB_BMR     = AT91C_TCB_TC0XC0S_NONE;					        /* No external clock signal */\
										  *AT91C_TC0_CMR	 = *AT91C_TC0_CMR & 0X00000000;                     /* Clear all bits in TC0_CMR */\
										  *AT91C_TC0_CMR     = *AT91C_TC0_CMR & 0xFFFF7FFF;                     /* Enable capture mode */\
										  *AT91C_TC0_CMR     = *AT91C_TC0_CMR | AT91C_TC_CLKS_TIMER_DIV5_CLOCK; /* Set clock for timer to Clock5 = div 1024*/\
										  *AT91C_TC0_CMR     = *AT91C_TC0_CMR | AT91C_TC_ABETRG;                /* Use external trigger for TI0*/\
										  *AT91C_TC0_CMR     = *AT91C_TC0_CMR | AT91C_TC_EEVTEDG_BOTH;          /* Trigger on both edges */\
                                          *AT91C_TC0_CMR     = *AT91C_TC0_CMR | AT91C_TC_LDRA_RISING;           /* RA loading register set */\
                                          *AT91C_AIC_IDCR    = TIMER_0_ID12;				                    /* Disable interrupt */\
                                           AT91C_AIC_SVR[12] = (unsigned int)CaptureCInt; \
                                           AT91C_AIC_SMR[12] = 0x05;						                    /* Enable trigger on level */\
                                          *AT91C_AIC_ICCR    = TIMER_0_ID12;						            /* Clear interrupt register PID12*/\
                                          *AT91C_TC0_IDR     = 0xFF;						                    /* Disable all interrupt from TC0 */\
                                          *AT91C_TC0_IER     = 0x80;						                    /* Enable interrupts from external trigger */\
                                          *AT91C_AIC_IECR    = TIMER_0_ID12;				                    /* Enable interrupt from TC0 */\
                                          *AT91C_TC0_CCR     = 0x00;						                    /* Clear registers before setting */\
                                          *AT91C_TC0_CCR     = AT91C_TC_CLKEN;						            /* Enable clock */\
                                        }

/*__ramfunc*/ void CaptureAInt()
{
  if (*AT91C_TC1_SR & AT91C_TC_MTIOA)
  {	
	if (*AT91C_PIOA_PDSR & MOTOR_A_DIR)
	{
	  MotorTachoValue[0].MotorDirection = REVERSE; //Motor is running reverse	
	  MotorTachoValue[0].TachoCountTable--;
	}
	else
	{
	  MotorTachoValue[0].MotorDirection = FORWARD; //Motor is running forward 	
	  MotorTachoValue[0].TachoCountTable++;
	}	
  }
  else
  {
  	if (*AT91C_PIOA_PDSR & MOTOR_A_DIR)
	{
	  MotorTachoValue[0].MotorDirection = FORWARD;
	  MotorTachoValue[0].TachoCountTable++;
	}
	else
	{
	  MotorTachoValue[0].MotorDirection = REVERSE;
	  MotorTachoValue[0].TachoCountTable--;
	}
  }
}

/*__ramfunc*/ void CaptureBInt()
{
  if (*AT91C_TC2_SR & AT91C_TC_MTIOA)
  {	
	if (*AT91C_PIOA_PDSR & MOTOR_B_DIR)
	{
	  MotorTachoValue[1].MotorDirection = REVERSE; //Motor is running reverse	
	  MotorTachoValue[1].TachoCountTable--;
	}
	else
	{
	  MotorTachoValue[1].MotorDirection = FORWARD; //Motor is running forward 	
	  MotorTachoValue[1].TachoCountTable++;
	}	
  }
  else
  {
  	if (*AT91C_PIOA_PDSR & MOTOR_B_DIR)
	{
	  MotorTachoValue[1].MotorDirection = FORWARD;
	  MotorTachoValue[1].TachoCountTable++;
	}
	else
	{
	  MotorTachoValue[1].MotorDirection = REVERSE;
	  MotorTachoValue[1].TachoCountTable--;
	}
  }
}


//__ramfunc void CaptureBInt(void)
//{
//  if (((bool)(*AT91C_TC2_SR & AT91C_TC_MTIOA))==((bool)(*AT91C_PIOA_PDSR & MOTOR_B_DIR)))
//  {
//    MotorTachoValue[1].MotorDirection = REVERSE; //Motor is running reverse	
//	MotorTachoValue[1].TachoCountTable--;
//  }
//  else
//  {
//    MotorTachoValue[1].MotorDirection = FORWARD; //Motor is running reverse	
//    MotorTachoValue[1].TachoCountTable++;
//  }
//}


/*__ramfunc*/ void CaptureCInt()
{
  if (*AT91C_TC0_SR & AT91C_TC_MTIOA)
  {
    if (*AT91C_PIOA_PDSR & MOTOR_C_DIR)
	{
	  MotorTachoValue[2].MotorDirection = REVERSE; //Motor is running reverse	
	  MotorTachoValue[2].TachoCountTable--;
	}
	else
	{
	  MotorTachoValue[2].MotorDirection = FORWARD; //Motor is running forward 	
	  MotorTachoValue[2].TachoCountTable++;
	}	
  }
  else
  {
    if (*AT91C_PIOA_PDSR & MOTOR_C_DIR)
	{
	  MotorTachoValue[2].MotorDirection = FORWARD;
	  MotorTachoValue[2].TachoCountTable++;
	}
	else
	{
	  MotorTachoValue[2].MotorDirection = REVERSE;
	  MotorTachoValue[2].TachoCountTable--;
	}
  }
}

#define   OUTPUTExit				    {\
										  *AT91C_AIC_IDCR   = TIMER_0_ID12 | TIMER_1_ID13 | TIMER_2_ID14; /* Disable interrupts for the timers */\
										  *AT91C_AIC_ICCR   = TIMER_0_ID12 | TIMER_1_ID13 | TIMER_2_ID14; /* Clear penting interrupt register for timers*/\
										  *AT91C_PMC_PCDR   = TIMER_0_ID12 | TIMER_1_ID13 | TIMER_2_ID14; /* Disable the clock for each of the timers*/\
										  *AT91C_PIOA_PER   = MOTOR_A_DIR | MOTOR_A_INT | MOTOR_B_DIR | MOTOR_B_INT | MOTOR_C_DIR | MOTOR_C_INT; /* Enable PIO on PA15, PA11, PA26, PA09, PA27 & PA08 */\
										  *AT91C_PIOA_ODR   = MOTOR_A_DIR | MOTOR_A_INT | MOTOR_B_DIR | MOTOR_B_INT | MOTOR_C_DIR | MOTOR_C_INT; /* Set to input PA15, PA11, PA26, PA09, PA27 & PA08 */\
										  *AT91C_PIOA_PPUDR = MOTOR_A_DIR | MOTOR_A_INT | MOTOR_B_DIR | MOTOR_B_INT | MOTOR_C_DIR | MOTOR_C_INT; /* Enable Pullup on PA15, PA11, PA26, PA09, PA27 & PA08 */\
										}


#define TACHOCountReset(MotorNr)		 {\
										   MotorTachoValue[MotorNr].TachoCountTable = 0;\
										   MotorTachoValue[MotorNr].TachoCountTableOld = 0;\
										 }
										
#define TACHOCaptureReadResetAll(MotorDataA,MotorDataB,MotorDataC){\
										   MotorDataA = (MotorTachoValue[MOTOR_A].TachoCountTable - MotorTachoValue[MOTOR_A].TachoCountTableOld);\
										   MotorTachoValue[MOTOR_A].TachoCountTableOld = MotorTachoValue[MOTOR_A].TachoCountTable;\
										   MotorDataB = (MotorTachoValue[MOTOR_B].TachoCountTable - MotorTachoValue[MOTOR_B].TachoCountTableOld);\
										   MotorTachoValue[MOTOR_B].TachoCountTableOld = MotorTachoValue[MOTOR_B].TachoCountTable;\
										   MotorDataC = (MotorTachoValue[MOTOR_C].TachoCountTable - MotorTachoValue[MOTOR_C].TachoCountTableOld);\
										   MotorTachoValue[MOTOR_C].TachoCountTableOld = MotorTachoValue[MOTOR_C].TachoCountTable;\
    									 }




#define GetMotorDirection(MotorNr)		 MotorTachoValue[MotorNr].MotorDirection
