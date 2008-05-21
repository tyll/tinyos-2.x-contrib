/* $Id$
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
 * Copyright (c) 2002-2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 *
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE. 
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS 
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR 
 * MODIFICATIONS.
 */

#include "Hcs08Adc.h"

/**
 * Internal component of the Hcs08 A/D HAL.
 * originally from atm128 adapted for Hcs08 by Tor Petterson
 *
 * @author Jason Hill
 * @author David Gay
 * @author Philip Levis
 * @author Phil Buonadonna
 * @author Hu Siquan <husq@xbow.com>
 * @author Tor Petterson <motor@diku.dk>
 */

module Hcs08AdcP 
{
  provides {
    interface Init;
    interface StdControl;
    interface Hcs08AdcSingle;
    interface Hcs08AdcMultiple;
  }
  uses {
    interface HplHcs08Adc;
    interface McuPowerState;
  }
}
implementation
{  
  /* State for the current and next (multiple-sampling only) conversion */
  struct {
    bool multiple : 1;		/* single and multiple-sampling mode */
//    bool precise : 1;		/* is this result going to be precise? */
    uint8_t channel : 5;	/* what channel did this sample come from? */
  } f, nextF;
  
  command error_t Init.init() 
  {
    atomic
      {
      	ATDC_t atdc = call HplHcs08Adc.getATDC();
      	ATDSC_t atdsc = call HplHcs08Adc.getATDSC();
      	
      	atdc.ATDPU = 0;     // Adc off
      	atdc.DJM = 1;       // Right justified
		atdc.RES8 = 0;      // 10 bit 
		atdc.SGN = 0;       // Unsigned results
		atdc.PRS = 8;       // Prescaler is 8
		atdsc.ATDIE = 0;    // Interrupt disabled
		atdsc.ATDCO = 0;    // Single conversion
		atdsc.ATDCH = Hcs08_ADC_VREFL; // Channel set to VREFL
		call HplHcs08Adc.setATDC(atdc);
		call HplHcs08Adc.setATDSC(atdsc);
      }
    return SUCCESS;
  }

  /* We enable the A/D when start is called, and disable it when stop is
     called. This drops A/D conversion latency by a factor of two (but
     increases idle mode power consumption a little). 
  */
  command error_t StdControl.start() {
    atomic call HplHcs08Adc.enableAdc();
    call McuPowerState.update();
    return SUCCESS;
  }

  command error_t StdControl.stop() {
    atomic call HplHcs08Adc.disableAdc();
	call McuPowerState.update();
    return SUCCESS;
  }

  /* Return TRUE if switching to 'channel' with reference voltage 'refVoltage'
     will give a precise result (the first sample after changing reference
     voltage or switching to/between a differential channel is imprecise)
  */
/*  inline bool isPrecise(Atm128Admux_t admux, uint8_t channel, uint8_t refVoltage) {
    return refVoltage == admux.refs &&
      (channel <= ATM128_ADC_SNGL_ADC7 || channel >= ATM128_ADC_SNGL_1_23 || channel == admux.mux);
  }*/

  async event void HplHcs08Adc.dataReady(uint16_t data) {
    bool precise, multiple;
    uint8_t channel;

    atomic 
      {
	channel = f.channel;
//	precise = f.precise;
	multiple = f.multiple;
      }

    if (!multiple)
      {
	/* A single sample. Disable the ADC interrupt to avoid starting
	   a new sample at the next "sleep" instruction. */
	call HplHcs08Adc.disableInterrupt();
	if(channel <= 7)
      call HplHcs08Adc.pinDisable(channel);
	signal Hcs08AdcSingle.dataReady(data); //, precise);
      }
    else
      {
	/* Multiple sampling. The user can:
	   - tell us to stop sampling
	   - or, to continue sampling on a new channel, possibly with a
	     new reference voltage; however this change applies not to
	     the next sample (the hardware has already started working on
	     that), but on the one after.
	*/
	bool cont;
	uint8_t nextChannel, nextVoltage;
	ATDSC_t atdsc;

	atomic 
	  {
	    atdsc = call HplHcs08Adc.getATDSC();
	    nextChannel = atdsc.ATDCH;
	  }

	cont = signal Hcs08AdcMultiple.dataReady(data, channel, &nextChannel);
	atomic
	  if (cont)
	    {
	      /* Switch channels and update our internal channel+precision
		 tracking state (f and nextF). Note that this tracking will
		 be incorrect if we take too long to get to this point. */
	      atdsc.ATDCH = nextChannel;
	      call HplHcs08Adc.setATDSC(atdsc);

	      f = nextF;
	      nextF.channel = nextChannel;
	      //nextF.precise = isPrecise(admux, nextChannel, nextVoltage);
	    }
	  else
	    call HplHcs08Adc.cancel();
	    if(channel <= 7)
          call HplHcs08Adc.pinDisable(channel);
      }
  }

  /* Start sampling based on request parameters */
  void getData(uint8_t channel, bool leftJustify, bool is8bit, bool issigned, uint8_t prescaler) {
    ATDC_t atdc;
    ATDSC_t atdsc;

    f.channel = channel;

    atdc = call HplHcs08Adc.getATDC();
    atdc.DJM = !leftJustify;
    atdc.RES8 = is8bit;
    atdc.SGN = issigned;
    atdc.PRS = prescaler;
    call HplHcs08Adc.setATDC(atdc);
    
    atdsc.ATDIE = 1;
    atdsc.ATDCO = f.multiple;
    atdsc.ATDCH = channel;
    if(channel <= 7)
      call HplHcs08Adc.pinEnable(channel);
    call HplHcs08Adc.setATDSC(atdsc);
  }

  async command void Hcs08AdcSingle.getData(uint8_t channel, bool leftJustify, 
					     bool is8bit, bool issigned,  uint8_t prescaler) {
    atomic
      {
	f.multiple = FALSE;
	getData(channel, leftJustify, is8bit, issigned, prescaler);
      }
  }

  async command bool Hcs08AdcSingle.cancel() {
    /* There is no Atm128AdcMultiple.cancel, for reasons discussed in that
       interface */
    return call HplHcs08Adc.cancel();
  }

  async command void Hcs08AdcMultiple.getData(uint8_t channel, bool leftJustify,
					       bool is8bit, bool issigned, uint8_t prescaler) {
    atomic
      {
	f.multiple = TRUE;
	getData(channel, leftJustify, is8bit, issigned, prescaler);
	nextF = f;

      }
  }

  default async event void Hcs08AdcSingle.dataReady(uint16_t data) {
  }

  default async event bool Hcs08AdcMultiple.dataReady(uint16_t data, uint8_t channel,
						       uint8_t *newChannel) {
    return FALSE; // stop conversion if we somehow end up here.
  }
}
