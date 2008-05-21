/* Copyright (c) 2007, Tor Petterson <motor@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Implementation of TEP 112 for the Hcs08 micro controler.
 * We only support the WAIT and STOP3 power states.
 * 
 * @author Tor Petterson <motor@diku.dk>
 * Inspired by the MSP430 version.
*/

module McuSleepC
{
  provides interface McuSleep;
  provides interface McuPowerState;

  uses interface McuPowerOverride;
}
implementation
{
  bool dirty = TRUE;
  mcu_power_t powerState = HCS08_POWER_WAIT;
  
  mcu_power_t getPowerState()
  {
  	/* If any onboard modules are active we use WAIT mode 
  	 * if not we use STOP3
  	 */
  	if(SPIC1_SPE 		|| //spi
  	   SCI1C2_TE 		|| //UART0
  	   SCI1C2_RE 		||
  	   SCI2C2_TE 		|| //UART1
  	   SCI2C2_RE 		||
  	   ATDC_ATDPU 		|| //ADC
  	   TPM1C0SC_CH0IE	|| //Timer 1 channels
  	   TPM1C1SC_CH1IE	||
  	   TPM1C2SC_CH2IE	||
  	   TPM2C0SC_CH0IE	|| //timer 2 channels
  	   TPM2C1SC_CH1IE	||
  	   TPM2C2SC_CH2IE	||
  	   TPM2C3SC_CH3IE	||
  	   TPM2C4SC_CH4IE)
  	{
  	  return HCS08_POWER_WAIT;
  	} 
  	else 
  	{
  	  return HCS08_POWER_STOP3;
  	}
  }
  
  void computePowerState()
  {
    powerState = mcombine(getPowerState(),
			  call McuPowerOverride.lowestState());
  }
  
  void setStopMode()
  {
  	if(powerState == HCS08_POWER_STOP3)
  	{
  	  SPMSC2_PDC = 0;
  	  return;
  	}
  	
  	SPMSC2_PDC = 1;
  	
  	if(powerState == HCS08_POWER_STOP2)
  	{
  	  SPMSC2_PPDC = 1;
  	  return;
  	}
  	SPMSC2_PPDC = 0;
  }
  
  async command void McuSleep.sleep()
  {
  	if(dirty)
  	{
  	  computePowerState();
  	  dirty = 0;
  	  if(powerState > HCS08_POWER_WAIT)
  	    setStopMode();
  	}
  	
  	if(powerState == HCS08_POWER_WAIT)
  	{
	  asm( "WAIT" );
	}
	else
	{
	  asm( "STOP" );
	}
    return;
  }

  async command void McuPowerState.update()
  {
    atomic dirty = TRUE;
  }

  default async command mcu_power_t McuPowerOverride.lowestState()
  {
    return HCS08_POWER_STOP1;
  }
}
