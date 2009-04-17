/**
 * Implementation of TEP 112 (Microcontroller Power Management).
 *
 * @author Henrik Makitaavola
 * @author Fan Zhang <fanzha@ltu.se>
 */
// TODO(henrik) Add the stop mode for the lowest power saving state.
// TODO(Fan Zhang ) Add the wait mode for the MCU power saving state.
#include "m_printf.h"

module McuSleepP
{
  provides interface McuSleep;
  provides interface McuPowerState;

  uses interface McuPowerOverride;
  uses interface M16c62pClockCtrl;
}
implementation
{
  // Fan Zhang 2009-01-27
  //#ifdef ENABLE_STOP_MODE
  uint8_t powermode = M16C62P_POWER_WAIT;
  
  void updatePowerState(){
  	if(1){	//READ_BIT(TB5IC.BYTE, BIT3) || READ_BIT(TA0IC.BYTE, BIT3) ) {
    	atomic powermode = M16C62P_POWER_WAIT;
    	//_printf("powermode = M16C62P_POWER_WAIT\n");
    	
    }
    else {
    	atomic powermode = M16C62P_POWER_STOP;
    	//_printf("powermode = M16C62P_POWER_STOP\n");
    	
    }
  }
  	
  mcu_power_t getPowerState() {
    // Note: we go to sleep even if timer 1, 2, or 3's overflow interrupt
    // is enabled - this allows using these timers as TinyOS "Alarm"s
    // while still having power management.

    // Are external timers running?  
    //if (TABSR.BIT.TA0S ){	//| TABSR.BIT.TA1S | TABSR.BIT.TA2S | TABSR.BIT.TA3S |TABSR.BIT.TA4S) {
    //  return M16C62P_POWER_WAIT;
    //}
    if(1){  //READ_BIT(TB5IC.BYTE, BIT3) || READ_BIT(S1RIC.BYTE, BIT3) ) {
    	return M16C62P_POWER_WAIT;
    }
    // SPI (Radio stack on mica/micaZ
    
    // A UART is active
    //else if (READ_BIT(S1TIC.BYTE, 0)) { // UART READ_BIT(S1TIC.BYTE, 0);(UCSR0B | UCSR1B) & (1 << TXCIE | 1 << RXCIE)
    //  return M16C62P_POWER_WAIT;
    //} //commet by fanzha 2009-3-15 at office just for labview test
    // I2C (Two-wire) is active
    
    // ADC is enabled
    
    else {
      
      return M16C62P_POWER_STOP;
    }
  }
  
  async command void McuSleep.sleep()
  {
    // added Fan Zhang 2009-01-27
    uint8_t powerState = M16C62P_POWER_WAIT;
	
    atomic powerState = mcombine(getPowerState(), call McuPowerOverride.lowestState());
    //_printf("PD0= %x, PD1= %x, PD2= %x, PD3= %x, PD4= %x, PD5= %x, PD6= %x, PD7= %x, PD8= %x, PD9= %x, PD10= %x\n", PD0.BYTE, PD1.BYTE, PD2.BYTE, PD3.BYTE, PD4.BYTE, PD5.BYTE, PD6.BYTE, PD7.BYTE, PD8.BYTE, PD9.BYTE, PD10.BYTE);
    //_printf("P0= %x, P1= %x, P2= %x, P3= %x, P4= %x, P5= %x, P6= %x, P7= %x, P8= %x, P9= %x, P10= %x\n", P0.BYTE, P1.BYTE, P2.BYTE, P3.BYTE, P4.BYTE, P5.BYTE, P6.BYTE, P7.BYTE, P8.BYTE, P9.BYTE, P10.BYTE);
    PRCR.BIT.PRC0 = 1; // Turn off protection of system clock control registers 0 & 1
    if(powerState == M16C62P_POWER_WAIT)
    {
    	//P4.BIT.P4_3 = 0;
    	//P4.BIT.P4_7 = 0;
    	//P3.BIT.P3_5 = 0; 
    	/*
    	
    	CM0.BIT.CM0_3 = 0;
    	CM0.BIT.CM0_7 = 1;
    	CM2.BIT.CM2_0 = 0;
    	CM0.BIT.CM0_5 = 0;
    	TABSR.BIT.TB2S = 1;  //INT0IC.BYTE = 0x01;
    	
    	__nesc_enable_interrupt();
        asm ("wait");
        asm ("nop");asm ("nop");asm ("nop");asm ("nop");
        PRCR.BIT.PRC0 = 1; // Turn off protection of system clock control registers 0 & 1
        CM0.BIT.CM0_5 = 0;
        asm ("nop");asm ("nop");asm ("nop");asm ("nop");
        CM0.BIT.CM0_7 = 0;
        CM0.BIT.CM0_6 = 0;
        CM0.BIT.CM0_4 = 0;
        PRCR.BIT.PRC0 = 0; // Turn on protection of system clock control registers 0 & 1
        */
        //PD0.BYTE = 1;  P0.BYTE = 0;
        ///PD1.BYTE = 1;  P1.BYTE = 0;
        ///PD2.BYTE = 1;  P2.BYTE = 0;
        //PD3.BYTE = 1;  P3.BYTE = 0;
        ///PD7.BYTE = 1;  
        //P7.BIT.P7_6 = 1;
        //P7.BIT.P7_7 = 1;
        ///PD3.BYTE = 1;
        //P3.BIT.P3_2 = 0;	
        //P3.BIT.P3_5 = 0; 
        ///PD4.BIT.PD4_7 = 1;	
        //P4.BIT.P4_7 = 0;
        //P4.BIT.P4_3 = 0;
        
        __nesc_enable_interrupt();
        asm ("wait");
        //asm ("nop");asm ("nop");asm ("nop");asm ("nop");
        
    }
    else if(powerState == M16C62P_POWER_STOP)
    {
    	PRCR.BIT.PRC0 = 0; // Turn on protection of system clock control registers 0 & 1
    	/*
    	P3.BIT.P3_7 = 1;
    	__nesc_disable_interrupt();	//__nesc_enable_interrupt();
    	TABSR.BIT.TB2S = 1; //INT0IC.BYTE = 0x01;
    	PRCR.BIT.PRC0 = 1;  // Turn off protection of system clock control registers 0 & 1
    	asm ("nop");
    	CM1.BIT.CM1_1 = 0;
    	PLC0.BIT.PLC07 = 0;
    	//CM2.BIT.CM2_0 = 0;
    	__nesc_enable_interrupt();	
    	CM1.BIT.CM1_0 = 1;
    	//CM1.BYTE &= ~16;  //xIN DRIVE Capacity = low
    	//CM1.BYTE |= 1; // STOP MODE
    	asm ("nop");asm ("nop");asm ("nop");asm ("nop");
    	P3.BIT.P3_7 = 0;
    	*/
        
    	__nesc_enable_interrupt();
    	CM2.BIT.CM2_0 = 0;
    	//CM1.BIT.CM1_1 = 0;
    	CM1.BIT.CM1_0 = 1;
    	
    }
    // All of memory may change at this point...
    //asm volatile ("" : : : "memory");
    PRCR.BIT.PRC0 = 0; // Turn on protection of system clock control registers 0 & 1
    __nesc_disable_interrupt();
    if(powerState == M16C62P_POWER_STOP)
    {
    	call M16c62pClockCtrl.reInit(); 
    }
    // added Fan Zhang 2009-01-27
  }

  async command void McuPowerState.update()
  {
  	// Fan Zhang 2009-01-27 updatePowerState();
  }

  default async command mcu_power_t McuPowerOverride.lowestState()
  {// Fan Zhang 2009-01-27
    return M16C62P_POWER_STOP;
  }
}
