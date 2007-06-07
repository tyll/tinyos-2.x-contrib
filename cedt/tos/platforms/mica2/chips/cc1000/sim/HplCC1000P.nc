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

  void writeCC1000Defaults() {
    /*call HplCC1000.write(CC1K_FREQ_2A,0x75);
    call HplCC1000.write(CC1K_FREQ_1A,0xA0);
    call HplCC1000.write(CC1K_FREQ_0A,0xCB);
    call HplCC1000.write(CC1K_FREQ_2B,0x75);
    call HplCC1000.write(CC1K_FREQ_1B,0xA5);
    call HplCC1000.write(CC1K_FREQ_0B,0x4E);
    call HplCC1000.write(CC1K_FSEP1,0x00);
    call HplCC1000.write(CC1K_FSEP0,0x59);
    call HplCC1000.write(CC1K_CURRENT,0xCA);
    call HplCC1000.write(CC1K_FRONT_END,0x08);
    call HplCC1000.write(CC1K_PA_POW,0x0F);
    call HplCC1000.write(CC1K_PLL,0x10);
    call HplCC1000.write(CC1K_LOCK,0x00);
    call HplCC1000.write(CC1K_CAL,0x05);
    call HplCC1000.write(CC1K_MODEM2,0x96);
    call HplCC1000.write(CC1K_MODEM1,0x67);
    call HplCC1000.write(CC1K_MODEM0,0x54);
    call HplCC1000.write(CC1K_MATCH,0x00);
    call HplCC1000.write(CC1K_FSCTRL,0x01);
    call HplCC1000.write(CC1K_PRESCALER,0x00);
    /*call HplCC1000.write(TEST6,);
    call HplCC1000.write(TEST5,);
    call HplCC1000.write(TEST4,);
    call HplCC1000.write(TEST3,);
    call HplCC1000.write(TEST2,);
    call HplCC1000.write(TEST1,);
    call HplCC1000.write(TEST0,);*/   
    
    
   //these are the values representing the current consumption for Tx

	CC1K_RADIO_TxCURRENT[1] = 0.0053; //-20 dbm to -19 dbm
	CC1K_RADIO_TxCURRENT[2] = 0.0071; //-18 dbm to -16dbm
	CC1K_RADIO_TxCURRENT[3] = 0.0074; //-15 dbm to -13 dbm
	CC1K_RADIO_TxCURRENT[4] = 0.0076; //-12 to -11 dbm
	CC1K_RADIO_TxCURRENT[5] = 0.0079; //-10 to -9 dbm
	CC1K_RADIO_TxCURRENT[6] = 0.0082;
	CC1K_RADIO_TxCURRENT[7] = 0.0084;
	CC1K_RADIO_TxCURRENT[8] = 0.0087;
	CC1K_RADIO_TxCURRENT[9] = 0.0089;
	CC1K_RADIO_TxCURRENT[0xA] = 0.0096;
	CC1K_RADIO_TxCURRENT[0xB] = 0.0094;
	CC1K_RADIO_TxCURRENT[0xC] = 0.0097;
	CC1K_RADIO_TxCURRENT[0xE] = 0.0102;
	CC1K_RADIO_TxCURRENT[0xF] = 0.0104; //0 dbm
	CC1K_RADIO_TxCURRENT[0x40] = 0.0118; //1 dbm
	CC1K_RADIO_TxCURRENT[0x50] = 0.0128;
	CC1K_RADIO_TxCURRENT[0x60] = 0.0138;
	CC1K_RADIO_TxCURRENT[0x70] = 0.0148;
	CC1K_RADIO_TxCURRENT[0x80] = 0.0158;
	CC1K_RADIO_TxCURRENT[0x90] = 0.0168;
	CC1K_RADIO_TxCURRENT[0xC0] = 0.0200;
	CC1K_RADIO_TxCURRENT[0xE0] = 0.0221;
	CC1K_RADIO_TxCURRENT[0xFF] = 0.0267; //10 dbm

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
	
  }

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
    writeCC1000Defaults();
    return SUCCESS;
  }
  
  command void HplCC1000.init() {
  }

  async command void HplCC1000.write(uint8_t addr, uint8_t data) {
    //assign for addr using CC1K_reg array
    CC1K_REG_ACCESS(addr) = data;
    dbg("HplCC1kP","Writing to pAddr=%hX with data=%02hhx\n",addr,data);
  }

  async command uint8_t HplCC1000.read(uint8_t addr) {
    //returns the value of the reg array of specified addr
    uint8_t data = 0;
    data = CC1K_REG_ACCESS(addr);
    dbg("HplCC1kP","Reading the pAddr=%hX with data=%02hhx\n",addr,data);
    return data;
  }


  async command bool HplCC1000.getLOCK() {
    /*always false*/
    return FALSE;
    /*return call CHP_OUT.get();*/
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
}
  
