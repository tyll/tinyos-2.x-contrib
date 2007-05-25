
#ifndef lib_extra_AT91SAM7S256_H
#define lib_extra_AT91SAM7S256_H
/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
// Some extra functions in relation to those found in lib_AT91SAM7S256.
// Various methods from different files.
// @author rup

/* *****************************************************************************
                SOFTWARE API FOR AIC
   ***************************************************************************** */

//*----------------------------------------------------------------------------
//* \fn    AT91F_AIC_ActiveID
//* \brief Return id of active interupt
//*----------------------------------------------------------------------------
__inline unsigned int AT91F_AIC_ActiveID (
  AT91PS_AIC pAic)     // \arg pointer to the AIC registers
{
  return pAic->AIC_ISR;
}

/* *****************************************************************************
                SOFTWARE API FOR TIMER/COUNTER
   ***************************************************************************** */

/*-----------------*/
/* Clock Selection */
/*-----------------*/
#define TC_CLKS                  0x7
#define TC_CLKS_MCK2             0x0  //RC = 24027,42 tics ~ 24028
#define TC_CLKS_MCK8             0x1
#define TC_CLKS_MCK32            0x2
#define TC_CLKS_MCK128           0x3
#define TC_CLKS_MCK1024          0x4
//TODO: Make it configurable
#define TIMER0_INTERRUPT_LEVEL    1
#define TIMER1_INTERRUPT_LEVEL    4

//*----------------------------------------------------------------------------
//* Function Name       : AT91F_TC_Open
//* Object              : Initialize Timer Counter Channel and enable is clock
//* Input Parameters    : <tc_pt> = TC Channel Descriptor Pointer
//*                       <mode> = Timer Counter Mode
//*                     : <TimerId> = Timer peripheral ID definitions
//* Output Parameters   : None
//*----------------------------------------------------------------------------
void AT91F_TC_Open ( AT91PS_TC TC_pt, unsigned int Mode, unsigned int TimerId)
{
  unsigned int dummy;

  //* First, enable the clock of the TIMER
  // rup: testing
  //AT91F_PMC_EnablePeriphClock ( AT91C_BASE_PMC, 1<< TimerId ) ;

  //* Disable the clock and the interrupts
  TC_pt->TC_CCR = AT91C_TC_CLKDIS ;
  TC_pt->TC_IDR = 0xFFFFFFFF ;

  //* Clear status bit
  dummy = TC_pt->TC_SR;
  //* Suppress warning variable "dummy" was set but never used
  dummy = dummy;

  //* Set the Mode of the Timer Counter
  TC_pt->TC_CMR = Mode ;

  //* Enable the clock
  TC_pt->TC_CCR = AT91C_TC_CLKEN ;
}


//*----------------------------------------------------------------------------
//* \fn    AT91F_TC_IntEnable
//* \brief Return none
//*----------------------------------------------------------------------------
__inline void AT91_TC_IntEnable(
  AT91PS_TC pTC,           // \arg pointer to the timer base
  unsigned int Mask)          // \arg which interupts to enable
{
  pTC->TC_IER = Mask;
}

//*----------------------------------------------------------------------------
//* \fn    AT91F_TC_IntDisable
//* \brief Return none
//*----------------------------------------------------------------------------
__inline void AT91_TC_IntDisable(
  AT91PS_TC pTC,           // \arg pointer to the timer base
  unsigned int Mask)          // \arg which interupts to disable
{
  pTC->TC_IDR = Mask;
}

#endif // lib_extra_AT91SAM7S256_H
