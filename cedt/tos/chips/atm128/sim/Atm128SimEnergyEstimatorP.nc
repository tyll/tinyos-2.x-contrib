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

#include <sim_energy_estimate.h>
#include <atm128hardware.h>
#include <atm128current.h>
module Atm128SimEnergyEstimatorP {
  provides {
    interface Atm128SimEnergyEstimator;
  }
}

implementation {

  enum {
    ATM128_POWER_ACTIVE = 6,
  };

  
  async command void Atm128SimEnergyEstimator.computeCPUEnergy(sim_time_t diff,uint8_t mcu_state) {
    double temp=0.0;
    switch(mcu_state) {
      case ATM128_POWER_ACTIVE:	 temp = VOLTAGE * MCU_POWER_ON_CURRENT * (float) diff/ sim_ticks_per_sec() ;
				sim_update_cpuOnEnergy(temp);	
      				break;
      case ATM128_POWER_IDLE:  	temp = VOLTAGE * MCU_POWER_IDLE_CURRENT * (float) diff/sim_ticks_per_sec();
				sim_update_cpuIdleEnergy(temp);
				break;
      case ATM128_POWER_ADC_NR:	temp += VOLTAGE * MCU_POWER_ADC_NR_CURRENT ;
				sim_update_cpuAdcEnergy(temp);
				break;
      case ATM128_POWER_EXT_STANDBY: temp= VOLTAGE * MCU_POWER_EXT_STANDBY_CURRENT * (float) diff/sim_ticks_per_sec();
				sim_update_cpuExtStandbyEnergy(temp);
				break;
      case ATM128_POWER_SAVE:	temp = VOLTAGE * MCU_POWER_SAVE_CURRENT * (float) diff/sim_ticks_per_sec();
				sim_update_cpuSaveEnergy(temp);
				break;
      case ATM128_POWER_STANDBY: temp= VOLTAGE * MCU_POWER_STANDBY_CURRENT * (float) diff/sim_ticks_per_sec();
				sim_update_cpuStandbyEnergy(temp);
				break;
      case ATM128_POWER_DOWN:  	temp = VOLTAGE * MCU_POWER_DOWN_CURRENT * (float) diff/sim_ticks_per_sec();
				sim_update_cpuPowerDownEnergy(temp);
				break;

      default:			break;
    
    }
  }
  
  async command void Atm128SimEnergyEstimator.setCompute(uint8_t port, uint8_t pin, sim_time_t diff) {
    if(port == LED_PORTA) {
      switch (pin) {
        case LED_PORTA_1 : 
                     break;
        case LED_PORTA_2 : 
                     break;
        case LED_PORTA_3 : 
                     break;
      }
    }
  }
  
  async command void Atm128SimEnergyEstimator.clearCompute(uint8_t port, uint8_t pin, sim_time_t diff) {
    //dbg("LedsPower","Led toggle in port %X\n & %X pin\n",port,pin);
    if(port == LED_PORTA) {
      switch (pin) {
        case LED_PORTA_1 : 
		     				sim_update_led2Energy(VOLTAGE*LED_CURRENT*(float)diff/sim_ticks_per_sec());
                     		break;
        case LED_PORTA_2 : 
		     				sim_update_led1Energy(VOLTAGE*LED_CURRENT*(float)diff/sim_ticks_per_sec());
                     		break;
        case LED_PORTA_3 : 
		     				sim_update_led0Energy(VOLTAGE*LED_CURRENT*(float)diff/sim_ticks_per_sec());
                    		break;
      }
    }
  }


}
