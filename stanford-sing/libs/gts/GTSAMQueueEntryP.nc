/*
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * Internal AM component that fills in needed packet fields for the 
 * AMSend -> Send transformation.
 *
 * @author Philip Levis
 * @date   Jan 16 2006
 */ 

/**
 * Separate clone of the AM layer component for GTS.
 *
 * @author Jung Il Choi
 * @date 2008/06/17 
 */
 
#include "AM.h"

generic module GTSAMQueueEntryP(am_id_t amId) {
  provides interface GTSAMSend;
  uses{
    interface GTSSend;
    interface AMPacket;
    interface Boot;
    interface ReportProtocol;
  }
}

implementation {
	
  event void Boot.booted() {
  	call ReportProtocol.report(amId);
  }
	
  command error_t GTSAMSend.send(am_addr_t dest,
			      message_t* msg,
			      uint8_t len,
			      uint8_t quiet) {
    call AMPacket.setDestination(msg, dest);
    call AMPacket.setType(msg, amId);
    return call GTSSend.send(msg, len, quiet);
  }
  command error_t GTSAMSend.cancel(message_t* msg) {
    return call GTSSend.cancel(msg);
  }

  event void GTSSend.sendDone(message_t* m, error_t err) {
    signal GTSAMSend.sendDone(m, err);
  }
  
  command uint8_t GTSAMSend.maxPayloadLength() {
    return call GTSSend.maxPayloadLength();
  }

  command void* GTSAMSend.getPayload(message_t* m, uint8_t len) {
    return call GTSSend.getPayload(m, len);
  }
  
}
