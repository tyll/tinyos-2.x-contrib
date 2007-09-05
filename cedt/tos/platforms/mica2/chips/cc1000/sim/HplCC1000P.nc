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
 * Low lever hardware simulation for CC1000 chip.  This file implements the 
 * functionality of CC1000 chip read and write to the internal cc1000 registers
 *
 * @author Venkatesh S
 * @author Prabhakar T V 
 *
 */
//#include "Atm128Adc.h"
#include "CC1000Const.h"
#include "CC1000Current.h"

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
    interface CC1000SimEnergyEstimator;
  }
}
implementation
{
  enum {
    MAX_RADIO_STATES = 8,
  };

  sim_time_t time1[MAX_RADIO_STATES];
  sim_time_t time2[MAX_RADIO_STATES];
  sim_time_t totalTime[MAX_RADIO_STATES];
  
  bool CC1K_MAINREG_STATE[MAX_RADIO_STATES];
  
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

  
   //These values indicate the powerMode in step of 1, 

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
      /* Keep a track of main register for the following:
       * RX/TX,7 is done at the SPI level
       * F_REG, do nothing
       */
      case CC1K_MAIN:
					dbg("main","Main reg value is %hhx\n",CC1K_REG_ACCESS(CC1K_MAIN));
					//RX_TX
					if(CC1K_REG_ACCESS(CC1K_MAIN) & (1<<CC1K_RXTX)) {
					//Tx state
					  time2[CC1K_RXTX] = sim_time();
					  totalTime[CC1K_RXTX] = time2[CC1K_RXTX] - time1[CC1K_RXTX];
					  dbg("rxtime","Total rxtime = %f\n",(double)totalTime[CC1K_RXTX]/sim_ticks_per_sec());
					  call CC1000SimEnergyEstimator.rxEnergy(totalTime[CC1K_RXTX]);
					}
					else {
					//Rx state
					  time1[CC1K_RXTX] = sim_time();
					}
					//RX_PD,5 Power down of LNA, 
					//Mixer, IF, demodulator, Rx part of signal interface
					if(CC1K_REG_ACCESS(CC1K_MAIN) & (1<<CC1K_RX_PD)) {
					  //Rx power down, update till it was on and estimate the power
					  dbg("main","Rx_PD set\n");
					  if(CC1K_MAINREG_STATE[CC1K_RX_PD]) {	
					    time2[CC1K_RX_PD] = sim_time();
					    totalTime[CC1K_RX_PD] += time2[CC1K_RX_PD] - time1[CC1K_RX_PD];	
					    dbg("mainTime","RX_PD On for %f time\n",(double)totalTime[CC1K_RX_PD]/sim_ticks_per_sec());				    					    					    
					    CC1K_MAINREG_STATE[CC1K_RX_PD] = FALSE;
					  }					  					  
					}
					else {
					  //if not, then start the time till it goes down!
					  if(!CC1K_MAINREG_STATE[CC1K_RX_PD]) {
					    time1[CC1K_RX_PD] = sim_time();
					    CC1K_MAINREG_STATE[CC1K_RX_PD] = TRUE;
					  }
					  else {
					    time2[CC1K_RX_PD] = sim_time();
					    totalTime[CC1K_RX_PD] += time2[CC1K_RX_PD] - time1[CC1K_RX_PD];					    					    
					    dbg("mainTime","RX_PD On for %f time\n",(double)totalTime[CC1K_RX_PD]/sim_ticks_per_sec());
						time1[CC1K_RX_PD] = sim_time();					    
					  }					  
					  dbg("main","Rx_PD not set\n");
					}					

       				//TX_PD,4 Power down 
       				//Off TX part of signal interface and PA					
					if(CC1K_REG_ACCESS(CC1K_MAIN) & (1<<CC1K_TX_PD)) {
					  //Tx power down, update till it was on and estimate the power
					  dbg("main","Tx_PD set\n");	
					  if(CC1K_MAINREG_STATE[CC1K_TX_PD]) {	
					    time2[CC1K_TX_PD] = sim_time();
					    totalTime[CC1K_TX_PD] += time2[CC1K_TX_PD] - time1[CC1K_TX_PD];	
					    dbg("mainTime","TX_PD On for %f time\n",(double)totalTime[CC1K_TX_PD]/sim_ticks_per_sec());				    					    					    
					    CC1K_MAINREG_STATE[CC1K_TX_PD] = FALSE;
					  }					  				  
					}
					else {
					  //start the timer
					  if(!CC1K_MAINREG_STATE[CC1K_TX_PD]) {
					    time1[CC1K_TX_PD] = sim_time();
					    CC1K_MAINREG_STATE[CC1K_TX_PD] = TRUE;
					  }
					  else {
					    time2[CC1K_TX_PD] = sim_time();
					    totalTime[CC1K_TX_PD] += time2[CC1K_TX_PD] - time1[CC1K_TX_PD];					    					    
					    dbg("mainTime","TX_PD On for %f time\n",(double)totalTime[CC1K_TX_PD]/sim_ticks_per_sec());
						time1[CC1K_TX_PD] = sim_time();					    
					  }
					  dbg("main","Tx_PD not set\n");					  
					}

			        //FS_PD,3 
			        //Power down frequency synthesizer					
					if(CC1K_REG_ACCESS(CC1K_MAIN) &(1<<CC1K_FS_PD)) {
					  if(CC1K_MAINREG_STATE[CC1K_FS_PD]) {	
					    time2[CC1K_FS_PD] = sim_time();
					    totalTime[CC1K_FS_PD] = time2[CC1K_FS_PD] - time1[CC1K_FS_PD];
					    if(CC1K_MAINREG_STATE[CC1K_BIAS_PD] && CC1K_MAINREG_STATE[CC1K_CORE_PD])
					      call CC1000SimEnergyEstimator.crysOscBiasSynEnergy(totalTime[CC1K_FS_PD]);
					    dbg("mainTime","FS_PD On for %f time\n",(double)totalTime[CC1K_FS_PD]/sim_ticks_per_sec());				    					    					    
					    CC1K_MAINREG_STATE[CC1K_FS_PD] = FALSE;
					  }						 
					  dbg("main","Fs_PD set\n");					
					}
					else {
					  if(!CC1K_MAINREG_STATE[CC1K_FS_PD]) {
					    time1[CC1K_FS_PD] = sim_time();
					    CC1K_MAINREG_STATE[CC1K_FS_PD] = TRUE;
					  }
					  else {
					    time2[CC1K_FS_PD] = sim_time();
					    totalTime[CC1K_FS_PD] = time2[CC1K_FS_PD] - time1[CC1K_FS_PD];	
					    if(CC1K_MAINREG_STATE[CC1K_BIAS_PD] && CC1K_MAINREG_STATE[CC1K_CORE_PD])
					      call CC1000SimEnergyEstimator.crysOscBiasEnergy(totalTime[CC1K_FS_PD]);				    					    
					    dbg("mainTime","FS_PD On for %f time\n",(double)totalTime[CC1K_FS_PD]/sim_ticks_per_sec());
						time1[CC1K_FS_PD] = sim_time();					    
					  }					
					  dbg("main","FS_PD not set\n");					
					}
					
       				//BIAS_PD,1 
       				//Power down BIAS and Crystal Osc Buffer.					
					if(CC1K_REG_ACCESS(CC1K_MAIN) & (1<<CC1K_BIAS_PD)) {
					  dbg("main","BIAS_PD set\n");
					  if(CC1K_MAINREG_STATE[CC1K_BIAS_PD]) {	
					    time2[CC1K_BIAS_PD] = sim_time();
					    totalTime[CC1K_BIAS_PD] = time2[CC1K_BIAS_PD] - time1[CC1K_BIAS_PD];					    					    					    
					    if(CC1K_MAINREG_STATE[CC1K_CORE_PD])
					      call CC1000SimEnergyEstimator.crysOscBiasEnergy(totalTime[CC1K_BIAS_PD]);					    
						dbg("mainTime","Bias On for %f time\n",(double)totalTime[CC1K_BIAS_PD]/sim_ticks_per_sec());
					    CC1K_MAINREG_STATE[CC1K_BIAS_PD] = FALSE;
					  }					  					
					}
					else {
					  if(!CC1K_MAINREG_STATE[CC1K_BIAS_PD]) {
					    time1[CC1K_BIAS_PD] = sim_time();
					    CC1K_MAINREG_STATE[CC1K_BIAS_PD] = TRUE;
					  }
					  else {
					    time2[CC1K_BIAS_PD] = sim_time();
					    totalTime[CC1K_BIAS_PD] = time2[CC1K_BIAS_PD] - time1[CC1K_BIAS_PD];					    					    
					    if(CC1K_MAINREG_STATE[CC1K_CORE_PD])
					      call CC1000SimEnergyEstimator.crysOscBiasEnergy(totalTime[CC1K_BIAS_PD]);					    
					    dbg("mainTime","Bias On for %f time\n",(double)totalTime[CC1K_BIAS_PD]/sim_ticks_per_sec());
						time1[CC1K_BIAS_PD] = sim_time();					    
					  }					
					  dbg("main","Bias_PD not set\n");					
					}

		       		//CORE_PD,2 
		       		//Power down Crystal Osc core
					if(CC1K_REG_ACCESS(CC1K_MAIN) & (1<<CC1K_CORE_PD)) {
					  dbg("main","Core_PD set\n");				
					  if(CC1K_MAINREG_STATE[CC1K_CORE_PD]) {	
					    time2[CC1K_CORE_PD] = sim_time();
					    totalTime[CC1K_CORE_PD] = time2[CC1K_CORE_PD] - time1[CC1K_CORE_PD];					    					    					    
					    call CC1000SimEnergyEstimator.crysOscEnergy(totalTime[CC1K_CORE_PD]);
					    dbg("mainTime","core On for %f time\n",(double)totalTime[CC1K_CORE_PD]/sim_ticks_per_sec());
					    CC1K_MAINREG_STATE[CC1K_CORE_PD] = FALSE;
					  }
					}
					else {
					  if(!CC1K_MAINREG_STATE[CC1K_CORE_PD]) {
					    time1[CC1K_CORE_PD] = sim_time();
					    CC1K_MAINREG_STATE[CC1K_CORE_PD] = TRUE;
					  }
					  else {
					    time2[CC1K_CORE_PD] = sim_time();
					    totalTime[CC1K_CORE_PD] = time2[CC1K_CORE_PD] - time1[CC1K_CORE_PD];					    					    
					    call CC1000SimEnergyEstimator.crysOscEnergy(totalTime[CC1K_CORE_PD]);					    
					    dbg("mainTime","core On for %f time\n",(double)totalTime[CC1K_CORE_PD]/sim_ticks_per_sec());
						time1[CC1K_CORE_PD] = sim_time();					    
					  }					
					  dbg("main","Core_PD not set\n");					
					}
					
					break;
	  /*  Current register specifies the following:
	   *  VCO current
	   *  LO_DRIVE
	   *  PA_DRIVE
	   */				
	  case CC1K_CURRENT :
	  				{
	  				  float VCOcurrent;
	  				  //VCO current
	  				  switch ((CC1K_REG_ACCESS(CC1K_CURRENT) >> CC1K_VCO_CURRENT) & 0xf) {
	  				    case 0 : VCOcurrent = 0.000150; break;
	  				    case 1 : VCOcurrent = 0.000250; break;
	  				    case 2 : VCOcurrent = 0.000350; break;
	  				    case 3 : VCOcurrent = 0.000450; break;
	  				    case 4 : VCOcurrent = 0.000950; break;
	  				    case 5 : VCOcurrent = 0.001050; break;
	  				    case 6 : VCOcurrent = 0.001150; break;
	  				    case 7 : VCOcurrent = 0.001250; break;
	  				    case 8 : VCOcurrent = 0.001450; break;
	  				    case 9 : VCOcurrent = 0.001550; break;
	  				    case 10 : VCOcurrent = 0.001650; break;
	  				    case 11 : VCOcurrent = 0.001750; break;
	  				    case 12 : VCOcurrent = 0.002250; break;
	  				    case 13 : VCOcurrent = 0.002350; break;
	  				    case 14 : VCOcurrent = 0.002450; break;
	  				    case 15 : VCOcurrent = 0.002550; break;
	  				    default : VCOcurrent = 0.0 ; break;
	  				  }
	  			    }
	  				//LOW_DRIVE 
	  				{
	  				  float LOcurrent;
	  				  switch ((CC1K_REG_ACCESS(CC1K_CURRENT) >> CC1K_LO_DRIVE) & 0x3) {
	  				    case 0 : LOcurrent = 0.005; break;
	  				    case 1 : LOcurrent = 0.001; break;
	  				    case 2 : LOcurrent = 0.0015; break;
	  				    case 3 : LOcurrent = 0.002; break;
	  				    default : LOcurrent = 0.0; break;
	  				  }
	  				}
	  				
	  				//PA_DRIVE current
	  				{
	  				  float PAcurrent;
	  				  switch ((CC1K_REG_ACCESS(CC1K_CURRENT) >> CC1K_PA_DRIVE) & 0x3) {
	  				    case 0 : PAcurrent = 0.001; break;
	  				    case 1 : PAcurrent = 0.002; break;
	  				    case 2 : PAcurrent = 0.003; break;
	  				    case 3 : PAcurrent = 0.004; break;
	  				  }
	  				}
	  				break;
	             
      default 	   :
      				//do nothing
    }
  
  }
}
  
