/*
 * Copyright (c) 2010, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Janos Sallai
 */ 
 
#include <Msp430DcoSpec.h>

module Msp430DcoCalibP
{
  uses {
  	interface Msp430Timer as TimerMicro;
  	interface Msp430Timer as Timer32khz;
  	interface DiagMsg;
  	interface Leds;
  }
  provides {
  	interface McuPowerOverride;
  	interface StdControl;
  }  	
}
implementation
{
  
  enum {
  	LOG2_DELTA_SUM_COUNT = 3,
  	DELTA_SUM_COUNT = 1 << LOG2_DELTA_SUM_COUNT,
  };
  
  norace uint16_t prevT32KhzReading = 0;
  norace uint32_t deltaSum = 0; // accumulator of deltas
  uint8_t idx = 0;
  norace uint8_t isOn = 0; // 0 is continuous calibration is on, 1 if off
	
  enum
  {
  	// number of ACLK ticks during 65536 ticks of the fast clock
    	TARGET_DELTA = 1ULL * ACLK_HZ * ACLK_PRESCALER * 65536L / TARGET_DCO_HZ,
    	// maximum allowed deviation from TARGET_DELTA
    	MAX_DEVIATION = 4, 
  };

  command error_t StdControl.start() {
  	if(isOn)
  	  return EALREADY;
  	prevT32KhzReading = 0;
	isOn = 1;
	return SUCCESS;
  }

  command error_t StdControl.stop() {
  	if(!isOn)
  	  return EALREADY;
	isOn = 0;
	return SUCCESS;
  }

  task void adjustDco() {
	uint16_t delta;
	
	// bail out if continuous calibration is off
	if(!isOn)
		return;
	
	// divide sum to get average
	atomic delta = deltaSum >> LOG2_DELTA_SUM_COUNT;
	
	call Leds.led2Toggle();						
	call Leds.led0Off();
	call Leds.led1Off();

	if( delta > (TARGET_DELTA+MAX_DEVIATION) )
	{
		// too many 32khz ticks means the DCO is running too slow, speed it up		
		if( DCOCTL < 0xe0 )
		{
			DCOCTL++;
			call Leds.led0On();
		}
		else if( (BCSCTL1 & 7) < 7 )
		{
			BCSCTL1++;
			DCOCTL = 96;
		}
	}
	else if( delta < (TARGET_DELTA-MAX_DEVIATION) )
	{
		// too few 32khz ticks means the DCO is running too fast, slow it down
		if( DCOCTL > 0 )
		{
			DCOCTL--;
			call Leds.led1On();
		}
		else if( (BCSCTL1 & 7) > 0 )
		{
			BCSCTL1--;
			DCOCTL = 128;
		}
	}
	
	if(call DiagMsg.record() == SUCCESS)
	{
		call DiagMsg.str("e=");
		call DiagMsg.int16(delta-TARGET_DELTA);
		call DiagMsg.str("DCOCTL=");
		call DiagMsg.uint16(DCOCTL);
		call DiagMsg.send();
	}

	// this will cause idx and deltaSum to reset
	// when the next TMicro overflow interrupt comes
	atomic 	prevT32KhzReading = 0;
	
  }

  async event void TimerMicro.overflow()
  {
    uint16_t now;
    uint16_t d;  // # of T32khz ticks since the previous IRQ

    // bail out if continuous calibration is off
    if(!isOn)
    	return;

    now = call Timer32khz.get();
    d = now - prevT32KhzReading;  // # of T32khz ticks since the previous IRQ

    // check if prevT32KhzReading is valid
    if(prevT32KhzReading == 0) {
    	// prevT32KhzReading is invalid, set it, and reset idx and sum
    	prevT32KhzReading = now;
        idx = 0;
        deltaSum = 0;        
    	return;
    }
    
    prevT32KhzReading = now;
    
    if(idx < DELTA_SUM_COUNT) {    
    	// accumulate DELTA_SUM_COUNT deltas
    	idx++;
	deltaSum+=d;
    } else if(idx == DELTA_SUM_COUNT) {
	// DELTA_SUM_COUNT deltas accumulated, adjust DCO
    	idx++;
  	post adjustDco();
    }
  }

  async event void Timer32khz.overflow()
  {
  }
  
  async command mcu_power_t McuPowerOverride.lowestState() {
  	if(isOn)
    		return MSP430_POWER_ACTIVE;
	else
		return 0xff;
  }  
}

