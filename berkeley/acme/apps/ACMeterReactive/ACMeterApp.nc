/* "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
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

/**
 * ACme Energy Monitor
 * @author Fred Jiang <fxjiang@eecs.berkeley.edu>
 * @version $Revision$
 */


#include "EnergyMsg.h"
#define INTERVAL 1024

module ACMeterApp {
	uses interface Boot;
	uses interface AMSend;
	uses interface Receive as AMReceive;
	uses interface Packet;
	uses interface Leds;
	uses interface SplitControl as MeterControl;
	uses interface SplitControl as AMControl;
	uses interface ACMeter;
        uses interface LocalIeeeEui64;
}

implementation {
	message_t pkt;
	EnergyMsg_t* energymsg;

	uint32_t energy, laenergy, lvaenergy, lvarenergy;

	task void SendVal() {
          ieee_eui64_t eui;
          eui = call LocalIeeeEui64.getId();
          energymsg = (EnergyMsg_t*) call Packet.getPayload(&pkt, sizeof(energymsg));
          memcpy(energymsg->eui64, eui.data, IEEE_EUI64_LENGTH);
          energymsg->src = TOS_NODE_ID;
          energymsg->energy = energy;
          energymsg->laenergy = laenergy;
          energymsg->lvaenergy = lvaenergy;
          energymsg->lvarenergy = lvarenergy;
          
          if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(EnergyMsg_t)) == SUCCESS) {
            //				call Leds.led1Toggle();
          }		
          return;
	}
		
	event void Boot.booted() {
          atomic energy = 0;
                
          call AMControl.start();
	}

	event void MeterControl.startDone(error_t err) {
		// start reading energy at 1Hz
		call ACMeter.start(INTERVAL);
	}

	event void MeterControl.stopDone(error_t err) {}
	
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			call MeterControl.start();
		}
		else {
			call AMControl.start();
		}	
	}

	event message_t* AMReceive.receive(message_t* msg, void* payload, uint8_t len) {
		call ACMeter.toggle();
		return msg;
	}
	
	event void AMSend.sendDone(message_t* msg, error_t error) {}
	
	event void AMControl.stopDone(error_t err) {}

	event void ACMeter.sampleDone(uint32_t val, uint32_t laval, uint32_t lvaval, uint32_t lvarval) {
		atomic energy = val;
		atomic laenergy = laval;
		atomic lvaenergy = lvaval;
		atomic lvarenergy = lvarval;
		post SendVal();
	}
	
}
	
