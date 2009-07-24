/*
 * Copyright (c) 2009, Vanderbilt University
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
 * Author: Miklos Maroti, Gabor Pap, Janos Sallai
 */

#include "GradientFieldPacket.h"

module GradientFieldP
{
	provides
	{
		interface GradientField;
	}
	uses
	{
    interface StdControl as DfrfControl;
    interface AMPacket;
		interface Timer<TMilli>;
		interface DfrfSend<gradient_field_packet_t>;
		interface DfrfReceive<gradient_field_packet_t>;
		interface Leds;
	}
}

implementation
{
  uint16_t rootAddress = 0xffff;
  uint16_t effectiveRootAddress = 0xffff;
	uint16_t hopCountSum;
	uint16_t effectiveHopCountSum;
	uint8_t  msgCount;
	uint8_t  effectiveMsgCount;
	uint8_t  lastSeq = 0xff;


	/**** hop count ****/

	command void GradientField.beacon()
	{
		rootAddress = effectiveRootAddress = call AMPacket.address();

		hopCountSum = effectiveHopCountSum = 0;
		msgCount = effectiveMsgCount = 0;

		lastSeq |= 0x0F;

    call DfrfControl.start();
		call Timer.startPeriodic(512);
    call Leds.led0Toggle();
	}

	command am_addr_t GradientField.rootAddress()
	{
	  return effectiveRootAddress;
	}

	command void GradientField.setRootAddress(am_addr_t ra) {
	  rootAddress = effectiveRootAddress = ra;
	}

	command uint16_t GradientField.hopCount()
	{
		if( effectiveMsgCount == 0 )
			return 0xffff;
    else
		  return (effectiveHopCountSum << 2) / effectiveMsgCount;
	}

	command void GradientField.setHopCount(uint16_t hc) {
    if(hc == 0xffff) {
      hopCountSum = effectiveHopCountSum = 0;
      msgCount = effectiveMsgCount = 0;
    } else {
      hopCountSum = effectiveHopCountSum = hc;
      msgCount = effectiveMsgCount = 4;
    }
	}


	/**** implementation ****/


	event bool DfrfReceive.receive(gradient_field_packet_t* data, uint32_t eventTime)
	{
    call Leds.led1Toggle();

    // detect a new beaconing round
    if(( lastSeq & 0xf0 ) != ( data->seq & 0xf0 )) {
      rootAddress = data->rootAddress;
      msgCount = 0;
    }

		lastSeq = data->seq;
		hopCountSum += ++(data->hopCount);
		++msgCount;

    // update last* values if enough messages have been received in the current beaconing round
    if(msgCount > effectiveMsgCount / 2) {
      effectiveMsgCount = msgCount;
      effectiveRootAddress = rootAddress;
      effectiveHopCountSum = hopCountSum;
    }

		return TRUE;
	}

	event void Timer.fired()
	{

		gradient_field_packet_t data;
		data.seq = ++lastSeq;
		data.rootAddress = rootAddress;
		data.hopCount = 0;

    call Leds.led2Toggle();

		call DfrfSend.send(&data, 0);

		if( (lastSeq & 0x0F) == 0x0F ) {
			call Timer.stop();
			call DfrfControl.stop();

      call Leds.set(7);

		}
	}


}
