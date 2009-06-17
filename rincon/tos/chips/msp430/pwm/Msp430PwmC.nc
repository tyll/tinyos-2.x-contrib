
#include "Msp430Timer.h"

/**
 * This pulse width modulator implementation allows you to choose
 * a clock source and divisor, set the period and the amount of time
 * a pulse is 'on'.  It provides the Out1 IO's as a convenience to you,
 * and you'll need to make them outputs and selectModuleFunc() before
 * they'll output the PWM from TimerA.
 *
 * It's not too configurable, but if you need to do something
 * different you should modify the code to keep the code size at a 
 * minimum.
 *
 * @author David Moss
 */
 
#warning "Using TimerA"

configuration Msp430PwmC {
  provides {
    interface Msp430Pwm;
    
    // Out1:
    interface HplMsp430GeneralIO as Out1_Port12;
    interface HplMsp430GeneralIO as Out1_Port16;
    interface HplMsp430GeneralIO as Out1_Port23;

  }
}

implementation {
  
  components Msp430PwmP;
  Msp430Pwm = Msp430PwmP;
  
  components HplMsp430GeneralIOC;
  Out1_Port12 = HplMsp430GeneralIOC.Port12;
  Out1_Port16 = HplMsp430GeneralIOC.Port16;
  Out1_Port23 = HplMsp430GeneralIOC.Port23;
  
  // For reference...
  //Out0_Port11 = HplMsp430GeneralIOC.Port11;
  //Out0_Port15 = HplMsp430GeneralIOC.Port15;
  //Out0_Port27 = HplMsp430GeneralIOC.Port27;
  //Out2_Port13 = HplMsp430GeneralIOC.Port13;
  //Out2_Port17 = HplMsp430GeneralIOC.Port17;
  //Out2_Port24 = HplMsp430GeneralIOC.Port24;
  
  components Msp430TimerC;
  Msp430PwmP.TimerA -> Msp430TimerC.TimerA;
  Msp430PwmP.ControlA0 -> Msp430TimerC.ControlA0;
  Msp430PwmP.ControlA1 -> Msp430TimerC.ControlA1;
  Msp430PwmP.CompareA0 -> Msp430TimerC.CompareA0;
  Msp430PwmP.CompareA1 -> Msp430TimerC.CompareA1;
  
}
