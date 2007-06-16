// $Id$

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Low level hardware access to the CC1000.
 *
 * @author Jaein Jeong
 * @author Philip Buonadonna
 */

/**
 * Low lever hardware simulation for CC1000 chip.  This file implements the 
 * functionality of CC1000 chip read and write to the internal cc1000 registers
 *
 * @author Venkatesh S
 * @author Prabhakar T V 
 *
 */
#include "Atm128Adc.h"
#include "CC1000Const.h"

module HplCC1000P {
  provides {
    interface Init as PlatformInit;
    interface HplCC1000;
    interface Atm128AdcConfig as RssiConfig;
  }
  uses {
    /* These are the CC1000 pin names */
    interface GeneralIO as CHP_OUT;
    interface GeneralIO as PALE;
    interface GeneralIO as PCLK;
    interface GeneralIO as PDATA;
  }
}
implementation
{
  
  void CheckCC1KReg(uint8_t addr);
  
  command error_t PlatformInit.init() {
    call CHP_OUT.makeInput();
    call PALE.makeOutput();
    call PCLK.makeOutput();
    call PDATA.makeOutput();
    call PALE.set();
    call PDATA.set();
    call PCLK.set();

    // MAIN register to power down mode. Shut everything off
    call HplCC1000.write(CC1K_MAIN,
			 1 << CC1K_RX_PD |
			 1 << CC1K_TX_PD | 
			 1 << CC1K_FS_PD |
			 1 << CC1K_CORE_PD |
			 1 << CC1K_BIAS_PD |
			 1 << CC1K_RESET_N);
    call HplCC1000.write(CC1K_PA_POW, 0);  // turn off rf amp
    
   //These values indicate the powerMode, 

	CC1K_RADIO_PowerMode[1] = -20;
	CC1K_RADIO_PowerMode[2] = -18;
	CC1K_RADIO_PowerMode[3] = -15;
	CC1K_RADIO_PowerMode[4] = -12;
	CC1K_RADIO_PowerMode[5] = -10;
	CC1K_RADIO_PowerMode[6] = -8;
	CC1K_RADIO_PowerMode[7] = -7;
	CC1K_RADIO_PowerMode[8] = -6;
	CC1K_RADIO_PowerMode[9] = -5;
	CC1K_RADIO_PowerMode[0xA] = -4;
	CC1K_RADIO_PowerMode[0xB] = -3;
	CC1K_RADIO_PowerMode[0xC] = -2;
	CC1K_RADIO_PowerMode[0xE] = -1;
	CC1K_RADIO_PowerMode[0xF] = 0;
	CC1K_RADIO_PowerMode[0x40] = 1;
	CC1K_RADIO_PowerMode[0x50] = 2;
	CC1K_RADIO_PowerMode[0x60] = 4;
	CC1K_RADIO_PowerMode[0x70] = 5;
	CC1K_RADIO_PowerMode[0x80] = 6;
	CC1K_RADIO_PowerMode[0x90] = 7;
	CC1K_RADIO_PowerMode[0xC0] = 8;
	CC1K_RADIO_PowerMode[0xE0] = 9;
	CC1K_RADIO_PowerMode[0xFF] = 10;
	    
    return SUCCESS;
  }
  
  command void HplCC1000.init() {
  }

  //********************************************************/
  // function: write                                       */
  // description: accepts a 7 bit address and 8 bit data,  */
  //    creates an array of ones and zeros for each, and   */
  //    uses a loop counting thru the arrays to get        */
  //    consistent timing for the chipcon radio control    */
  //    interface.  PALE active low, followed by 7 bits    */
  //    msb first of address, then lsb high for write      */
  //    cycle, followed by 8 bits of data msb first.  data */
  //    is clocked out on the falling edge of PCLK.        */
  // Input:  7 bit address, 8 bit data                     */
  //********************************************************/

  async command void HplCC1000.write(uint8_t addr, uint8_t data) {
    call PALE.set();
    call PDATA.set();
    call PCLK.set();
    CC1K_REG_ACCESS(addr) = data;
    //now check the addr and if any interrupts should be given, 
    //just issue the same or set the appropriate register 
    CheckCC1KReg(addr);
    dbg("HplCC1000P","Written data %hhx to addr %hhx\n",data,addr);
  }

  //********************************************************/
  // function: read                                        */
  // description: accepts a 7 bit address,                 */
  //    creates an array of ones and zeros for each, and   */
  //    uses a loop counting thru the arrays to get        */
  //    consistent timing for the chipcon radio control    */
  //    interface.  PALE active low, followed by 7 bits    */
  //    msb first of address, then lsb low for read        */
  //    cycle, followed by 8 bits of data msb first.  data */
  //    is clocked in on the falling edge of PCLK.         */
  // Input:  7 bit address                                 */
  // Output:  8 bit data                                   */
  //********************************************************/

  async command uint8_t HplCC1000.read(uint8_t addr) {
    uint8_t data;
    call PALE.set();
    call PDATA.makeOutput();
    call PDATA.set();
    data = CC1K_REG_ACCESS(addr);
    dbg("HplCC1000P","Read data as %hx from %hhx\n",data,addr);
    return data;
  }


  async command bool HplCC1000.getLOCK() {
    return call CHP_OUT.get();
  }

  async command uint8_t RssiConfig.getChannel() {
    return CHANNEL_RSSI;
  }

  async command uint8_t RssiConfig.getRefVoltage() {
    return ATM128_ADC_VREF_OFF;
  }

  async command uint8_t RssiConfig.getPrescaler() {
    return ATM128_ADC_PRESCALE;
  }
  
  void CheckCC1KReg(uint8_t addr) {
    switch (addr) {
      /* Callibration:  During the initialization of the radio, the software 
       * CC1000ControlP file, sets few parameters and then waits for a bit to 
       * be set, which indicates the completion of the Callibration.  Here, 
       * We donot really callibrate, but make that particular bit to high
       */
      case CC1K_CAL:
      				dbg("HplCC1000P","CC1k_CAL reg check\n");
      				CC1K_SET_BIT(CC1K_CAL,CC1K_CAL_COMPLETE);
      				break;
      case CC1K_MAIN:
					dbg("HplCC1000P","Main reg value is %hhx\n",CC1K_REG_ACCESS(CC1K_MAIN));
					break;
      default 	   :
      				//do nothing
    }
  
  }
}
  
