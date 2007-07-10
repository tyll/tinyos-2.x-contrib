/*                                                                      tab:4
 *
 *
 * "Copyright (c) 2002 and The Regents of the University
 * of California.  All rights reserved.
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
 * Authors:             Sarah Bergbreiter
 * Date last modified:  10/21/2003
 *
 * This component sends a series of beeps using the sounder and timing
 * information provided by the component calling AcousticBeacon.
 *
 */

includes BeepDiffusionMsg;

module AcousticBeaconM {
  provides interface StdControl;
  provides interface AcousticBeacon;
  uses {
    interface StdControl as SounderControl;
    interface StdControl as TimerControl;
    interface Timer;
    interface StdControl as RadioControl;
    interface SendMsg;
  }
}
implementation {

  bool beeping, sending;
  uint8_t numValues, timeIndex;
  uint16_t* timePattern;

  TOS_Msg buffer;
  TOS_MsgPtr bufferPtr;
  bool sendPending;

  enum {
    MIC_STARTUP_TIME = 500,
  };

  command result_t StdControl.init() {
    beeping = FALSE;
    sending = FALSE;
    numValues = 0;
    timeIndex = 0;
    sendPending = FALSE;
    bufferPtr = &buffer;
    return rcombine3(call SounderControl.init(), call TimerControl.init(), call RadioControl.init());
  }

  command result_t StdControl.start() {
    return call RadioControl.start();
  }

  command result_t StdControl.stop() {
    return call RadioControl.stop();
  }

  command result_t AcousticBeacon.send(uint8_t num, uint16_t* time) {
    BeepDiffusionMsg* message = (BeepDiffusionMsg *)bufferPtr->data;
    if (!sending) {
      atomic {
	sending = TRUE;
	beeping = FALSE;
	numValues = num;
	timePattern = time;
	timeIndex = 0;
      }
      if (num > 0) {
	if (!sendPending) {
	  message->beeperID = TOS_LOCAL_ADDRESS;
	  if (call SendMsg.send(TOS_BCAST_ADDR, sizeof(BeepDiffusionMsg), bufferPtr)) {
	    sendPending = TRUE;
	    call Timer.start(TIMER_ONE_SHOT, MIC_STARTUP_TIME);
	    return SUCCESS;
	  }
	}
	return SUCCESS;
      }
    }
    return FAIL;
  }

  event result_t SendMsg.sendDone(TOS_MsgPtr m, bool success) {
    sendPending = FALSE;
    return success;
  }

  default event result_t AcousticBeacon.sendDone(uint16_t* time) { return SUCCESS; }

  event result_t Timer.fired() {
    timeIndex++;
    if (timeIndex == numValues) {
      call SounderControl.stop();
      sending = FALSE;
      beeping = FALSE;
      signal AcousticBeacon.sendDone(timePattern);
      return SUCCESS;
    }
    call Timer.start(TIMER_ONE_SHOT, timePattern[timeIndex-1]);

    if (beeping) {
      call SounderControl.stop();
      beeping = FALSE;
    } else {
      call SounderControl.start();
      beeping = TRUE;
    }
    return SUCCESS;
  }

}
