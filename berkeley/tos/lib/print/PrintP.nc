/*
 * "Copyright (c) 2007 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * Implements the <code>Print</code> glue between the C and nesC
 * namespaces and sends the formatted string to the raw UART.
 * 
 * @author Prabal Dutta <prabal@cs.berkeley.edu>
 */
#include "print.h"

enum {
  S_FREE = 0,
  S_RSVD = 1,
  S_BUSY = 2
};

module PrintP {
  uses interface Boot;
  uses interface UartStream;
  uses interface StdControl as UartControl;
}
implementation {

  uint8_t m_state;
  uint8_t m_buf[PRINT_BUF_SIZE];

  error_t print_rsvp() __attribute__((C)) {
    error_t rval = FAIL;
    atomic {
      if (m_state == S_FREE) {
	m_state = S_RSVD;
	rval = SUCCESS;
      }
      else {
	rval = EBUSY;
      }
    }
    return rval;
  }

  error_t print_spool(uint8_t* buf, uint16_t len) __attribute__((C)) {
    error_t rval = FAIL;
    atomic {
      if (m_state == S_RSVD) {
	m_state = S_BUSY;
        memcpy(m_buf, buf, len);
	rval = call UartStream.send(m_buf, len);
	if (rval != SUCCESS) {
          m_state = S_FREE;
	}
      }
    }
    return rval;
  }

  event void Boot.booted() {
    atomic m_state = S_FREE;
    call UartControl.start();
  }

  async event void UartStream.sendDone(uint8_t* buf, uint16_t len, error_t e) {
    if (buf == m_buf) {
      atomic m_state = S_FREE;
    }
  }

  async event void UartStream.receivedByte(uint8_t byte) {
  }

  async event void UartStream.receiveDone(uint8_t* buf, uint16_t len, error_t e) {
  }
}
