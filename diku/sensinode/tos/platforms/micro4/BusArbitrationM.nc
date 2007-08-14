/*									tab:4
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
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
 */
/*
 *
 * Authors:		Joe Polastre
 *
 * $Id$
 */

module BusArbitrationM {
  provides {
    interface BusArbitration[uint8_t id];
    interface Init;
  }
}
implementation {

  uint8_t state;
  uint8_t busid;
  bool isBusReleasedPending;
  enum { BUS_OFF, BUS_IDLE, BUS_BUSY };

  task void busReleased() {
    uint8_t i;
    uint8_t currentstate;
    // tell everyone the bus has been released
    atomic isBusReleasedPending = FALSE;
    for (i = 0; i < uniqueCount("BusArbitration"); i++) {
      atomic currentstate = state;
      if (currentstate == BUS_IDLE) 
        signal BusArbitration.busFree[i]();
    }
  }
 
  command error_t Init.init() {
    uint8_t _state;

    /* StdControl.init() */
    atomic {
      state = BUS_OFF;
      isBusReleasedPending = FALSE;
    }

    /* StdControl.start() */
    atomic {
      if (state == BUS_OFF) {
	state = BUS_IDLE;
	isBusReleasedPending = FALSE;
      }
      _state = state;
    }

    if (_state == BUS_IDLE)
      return SUCCESS;

    return FAIL;
  }

    /* StdControl.stop() */
/*  command error_t StdControl.stop() {
    uint8_t _state;
    atomic {
      if (state == BUS_IDLE) {
	state = BUS_OFF;
	isBusReleasedPending = FALSE;
      }
      _state = state;
    }

    if (_state == BUS_OFF) {
      return SUCCESS;
    }
    return FAIL;
  }
*/
  async command error_t BusArbitration.getBus[uint8_t id]() {
    bool gotbus = FALSE;
    atomic {
      if (state == BUS_IDLE) {
        state = BUS_BUSY;
        gotbus = TRUE;
        busid = id;
      }
    }
    if (gotbus)
      return SUCCESS;
    return FAIL;
  }
 
  async command error_t BusArbitration.releaseBus[uint8_t id]() {
    atomic {
      if ((state == BUS_BUSY) && (busid == id)) {
        state = BUS_IDLE;

	// Post busReleased inside the if-statement so it's only posted if the
	// bus has actually been released.  And, only post if the task isn't
	// already pending.  And, it's inside the atomic because
	// isBusReleasedPending is a state variable that must be guarded.
	if( (isBusReleasedPending == FALSE) && (post busReleased() == TRUE) )
	  isBusReleasedPending = TRUE;

      }
    }
    return SUCCESS;
  }

  default event error_t BusArbitration.busFree[uint8_t id]() {
    return SUCCESS;
  }

}

