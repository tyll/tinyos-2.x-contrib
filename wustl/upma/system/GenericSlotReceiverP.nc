/*
 * "Copyright (c) 2007 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */
 
/**      
 * The generic slot sender implements a generic slot as follows:
 * 
 *      start
 *       |        radio on                                 radio off           
 *       |         done        idle To     			         done               
 *       |          |            |                            |                 
 *       v          V            v                            V                  
 *       |****************************************************|
 *       |---START--|-----ON-----|---ACTIVITY/IDLE------------| END 
 *                               |
 *                               |
 *                               V
 *                         signal activity/idle
 * 
 *  pm - if true, it will turn on the radio in the beginning of slot, and
 *       off at the end of the slot
 *  idleTo - the time until you check for the channel to be idle/active. 
 *           if idle => sleep.
 *         - if idle is 0, then you will remain on for the entire duration 
 *           of slot 
 *
 *
 *  you should account for the time to turn off the radio, in the beginning 
 *  of the slot
 *
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */
 
 generic module GenericSlotReceiverP(bool pm, uint16_t idleTo) {
 	provides interface AsyncReceive as Receive;
 	provides interface GenericSlotEvents;
 	provides interface Init;

	uses interface RadioPowerControl;
	uses interface AsyncReceive as SubReceive;
	uses interface ChannelMonitor;
	uses interface AMPacket;
 } implementation {
 	enum {
 		S_START = 0,
 		S_ON = 1,
 		S_ACTIVITY = 2,
 		S_IDLE = 3,
 		S_END = 4
 	};
 	
 	uint8_t state;
 	uint8_t currentSlot;
 	
 	void alarm(uint8_t at) {
	}
 	
 	command error_t Init.init() {
		currentSlot = 0xff;
		state = S_END;
		//call ChannelMonitor.setCheckLength(idleTo);
		return SUCCESS;
  	}
  	
 	async command void SlotControl.startSlot(uint8_t slot, message_t *msg, uint8_t len) {
  		uint8_t oldState;
  		
  		atomic {
  			currentSlot = slot;
  			oldState = state;
  		}
  		
  		if (oldState != S_END) {
  			alarm(0);
  			return;
  		}
  		
  		
  		if (pm == TRUE) {
  			atomic state = S_START;
  			//call RadioPowerControl.start();
  		} else {
  			atomic state = S_ON;
  			if (idleTo > 0) {
  				//call ChannelMonitor.check();
  			} else {
  				 atomic state = S_ACTIVITY;
  			}
  			
  		}
  	}
  	

	event void RadioPowerControl.startDone(error_t error) {
		uint8_t oldState;
		
		if (pm == FALSE) return;
		
		atomic oldState = state;
		if (oldState != S_START) {
			alarm(1);
			return;
		} else {
			atomic state = S_ON;
		}
		
		if (idleTo > 0) {
			//call ChannelMonitor.check();
  		} else {
  				 atomic state = S_ACTIVITY;
  		}
	}
	
  	async event void ChannelMonitor.free() {
  		uint8_t oldState;
  		if (idleTo == 0) return;
  		atomic oldState = state;
  		
  		if (oldState != S_ON) {
  			alarm(2);
  			return;
  		} else {
  			atomic state = S_IDLE;
  			signal GenericSlotEvents.free();
  		}
  	}

  
  	async event void ChannelMonitor.busy() {
  		uint8_t oldState;
  		
  		if (idleTo == 0) return;
  		atomic oldState = state;
  		if (oldState != S_ON) {
  			alarm(3);
  			return;
  		} else {
  			atomic state = S_IDLE;
  			signal GenericSlotEvents.busy();
  		}
  	}

  	async event void ChannelMonitor.error() {
  	}

	event void RadioPowerControl.stopDone(error_t error)  {
	}
    
	async event void SubReceive.receive(message_t *msg, void *payload, uint8_t len) {
		signal SlotReceive.receive(msg, payload, len);
	}
	 
 	
 	default async event void GenericSlotEvents.free() {
 	}
 	
	default async event void GenericSlotEvents.busy() {
	}
 	
 }
