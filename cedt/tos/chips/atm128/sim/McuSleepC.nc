/*
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * TOSSIM Implementation of TEP 112 (Microcontroller Power Management)
 * for the Atmega128. 
 *
 * <pre>
 *  $Id$
 * </pre>
 *
 * @author Philip Levis
 * @date   October 26, 2005
 *
 */

/**
 * "Copyright (c) 2007 CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc.
 *  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc BE LIABLE TO
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc HAS BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc SPECIFICALLY DISCLAIMS
 * ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND CENTRE FOR ELECTRONICS
 * AND DESIGN TECHNOLOGY,IISc HAS NO OBLIGATION TO PROVIDE MAINTENANCE,
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */
 
/**
 *
 * @author Venkatesh S
 * @author Prabhakar T V
 */

#include<atm128_sim.h>
#include<atm128hardware.h>

module McuSleepC {
  provides {
    interface McuSleep;
    interface McuPowerState;
    //should be called only once by Atm128SimEnergyEstimatorC
    interface Init @exactlyonce();
  }
  uses {
    interface McuPowerOverride;
    interface Atm128SimEnergyEstimator;
  }
}
implementation {

  //Number of states the MCU [including an extra ACTIVE state
  enum {
    MAX_MCU_STATES = 7,
    ATM128_POWER_ACTIVE = 6, //This has been included as one more state just for simulation purpose
  };
  
  bool dirty = TRUE;
  mcu_power_t powerState = ATM128_POWER_IDLE;
  bool mcuState[MAX_MCU_STATES];
  uint8_t currentState,prevState;
  
  /*
   * ATM128_POWER_IDLE        = 0,
   * ATM128_POWER_ADC_NR      = 1,
   * ATM128_POWER_EXT_STANDBY = 2,
   * ATM128_POWER_SAVE        = 3,
   * ATM128_POWER_DOWN        = 5
   * ATM128_POWER_STANDBY     = 4,
   * ATM128_POWER_ACTIVE	   = 6,
  */
    
  sim_time_t time1[MAX_MCU_STATES];
  sim_time_t time2[MAX_MCU_STATES];
  sim_time_t totalTime[MAX_MCU_STATES];
    
  command error_t Init.init()  {
    currentState = ATM128_POWER_ACTIVE; 
    prevState = currentState;
    mcuState[currentState] = TRUE;
    time1[currentState]=sim_time();
    return SUCCESS;
  }  
  
  void printPowerState(uint8_t state) {
    switch (state) {
      case ATM128_POWER_IDLE:	dbg("MCU","McuSleepC: State %d ATM_POWER_IDLE for %f sec \n",state,(float)
      								totalTime[ATM128_POWER_IDLE]/sim_ticks_per_sec());
      				break;
      case ATM128_POWER_ADC_NR: dbg("MCU","McuSleepC: State %d  ATM_POWER_ADC_NR for %f sec\n",state,(float)
      								totalTime[ATM128_POWER_ADC_NR]/sim_ticks_per_sec());
      				break;
      case ATM128_POWER_EXT_STANDBY: dbg("MCU","McuSleepC: State %d ATM_POWER_EXT_STANDBY for %f sec\n",state, (float)
      								 totalTime[ATM128_POWER_EXT_STANDBY]/sim_ticks_per_sec());
      				break;
      case ATM128_POWER_SAVE:dbg("MCU","McuSleepC: State %d ATM_POWER_SAVE for %f sec\n",state, (float)
      									 totalTime[ATM128_POWER_SAVE]/sim_ticks_per_sec());
      				break;
      case ATM128_POWER_DOWN: dbg("MCU","McuSleepC: State %d ATM_POWER_DOWN for %f sec\n",state, (float)
      									 totalTime[ATM128_POWER_DOWN]/sim_ticks_per_sec());
      				break;
      case ATM128_POWER_STANDBY: dbg("MCU","McuSleepC: State %d ATM_POWER_STANDBY for %f sec\n",state, (float)
      									 totalTime[ATM128_POWER_STANDBY]/sim_ticks_per_sec());
      				break;
      //apart from other states, it will be in active state
      default : dbg("MCU","McuSleepC: State %d ATM_POWER_ACTIVE for %f sec\n",state, (float)
      										 totalTime[ATM128_POWER_ACTIVE]/sim_ticks_per_sec());
      				break;
    }
  }  
  
  /* Note that the power values are maintained in an order
   * based on their active components, NOT on their values.
   * Look at atm128hardware.h and page 42 of the ATmeg128
   * manual (figure 17).*/
  // NOTE: This table should be in progmem.
  const uint8_t atm128PowerBits[ATM128_POWER_DOWN + 1] = {
    0,
    (1 << SM0),
    (1 << SM2) | (1 << SM1) | (1 << SM0),
    (1 << SM1) | (1 << SM0),
    (1 << SM2) | (1 << SM1),
    (1 << SM1)};
      
  mcu_power_t getPowerState() {
    uint8_t diff;
    // Are external timers running?  
    if (TIMSK & ~((1 << OCIE0) | ( 1 << TOIE0))) {
      dbg("McuSleepC","External Timers Running, putting to IDLE state\n");
      return ATM128_POWER_IDLE;
    }
    // SPI (Radio stack on mica/micaZ
    else if (SPCR & (1 << SPIE)) { 
      dbg("McuSleepC","Radio SPI enabled, putting to IDLE state\n");
      return ATM128_POWER_IDLE;
    }
    // UARTs are active
    else if (UCSR0B & ((1 << TXCIE) | (1 << RXCIE))) { // UART
      dbg("McuSleepC","UART0 active, putting to IDLE state\n");
      return ATM128_POWER_IDLE;
    }
    else if (UCSR1B & ((1 << TXCIE) | (1 << RXCIE))) { // UART
      dbg("McuSleepC","UART1 active, putting to IDLE state\n");    
      return ATM128_POWER_IDLE;
    }
    // ADC is enbaled
    else if (READ_BIT(ADCSRA, ADEN)) {
      dbg("McuSleepC","ADC enabled, putting to ADC_NR state\n");     
      return ATM128_POWER_ADC_NR;
    }
    // How soon for the timer to go off?
    else if (TIMSK & ((1<<OCIE0) | (1<<TOIE0))) {
      diff = OCR0 - TCNT0;
      if (diff < 16) {
      dbg("McuSleepC","Timer is running, putting to IDLE state\n");      
	return ATM128_POWER_IDLE; 
	  }
      dbg("McuSleepC","Can Save Now, putting to SAVE state\n");	  
      return ATM128_POWER_SAVE;
    }
    else {
      dbg("McuSleepC","Can down the MCU, putting to DOWN state\n");    
      return ATM128_POWER_DOWN;
    }
  }
  
  void computePowerState() {
    powerState = mcombine(getPowerState(),
			  call McuPowerOverride.lowestState());
  }
  
  async command void McuSleep.sleep() {
    if (dirty) {
      uint8_t temp,sleepMode=0;
      computePowerState();

      //dirty = 0;
      temp = MCUCR;
      temp &= 0xe3;
      dbg("MCU","PowerState is %d\n",powerState);
      temp |= atm128PowerBits[powerState] | (1 << SE);
      MCUCR = temp;
      sleepMode = MCUCR & 0x1c; //last 3 bits specify which mode the MCU is!
      switch (powerState) {
        case 0 :  prevState = currentState;
        	  currentState = ATM128_POWER_IDLE;
        	  break;
        case 1 :  prevState = currentState;
        	  currentState = ATM128_POWER_ADC_NR;
        	  break;
        
        case 2 :  prevState = currentState;
        	  currentState = ATM128_POWER_EXT_STANDBY;
        	  break;
        	  
        case 3 :  prevState = currentState;
        	  currentState = ATM128_POWER_SAVE;
        	  break;
        	  
        case 4 :  prevState = currentState;
       		  currentState = ATM128_POWER_STANDBY;
       		  break;
       		  
        case 5 :  prevState = currentState;
        	  currentState = ATM128_POWER_DOWN;
        	  break;
        	  
        default : prevState = currentState;
              currentState = ATM128_POWER_ACTIVE;
              break;
      }
      
        time2[prevState] = sim_time();
        totalTime[prevState] = time2[prevState] - time1[prevState];
        printPowerState(prevState);
        call Atm128SimEnergyEstimator.computeCPUEnergy(totalTime[prevState],prevState);
        mcuState[prevState] = FALSE;
        time1[currentState] = sim_time();
        mcuState[currentState] = TRUE;                  
    }
    sei();
    /*no sleep instruction*/
    //asm volatile ("sleep");
    cli();
  }

  async command void McuPowerState.update() {
    atomic dirty = 1;
    call McuSleep.sleep();
  }

 default async command mcu_power_t McuPowerOverride.lowestState() {
   return ATM128_POWER_DOWN;
 }

}
