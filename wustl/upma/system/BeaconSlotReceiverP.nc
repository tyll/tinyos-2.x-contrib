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
 *
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */

module BeaconSlotReceiverP {
	provides interface SlotControl;

	uses interface SlotControl as TDMASlot;
	uses interface AsyncReceive as SubReceive;
	uses interface Slotter;
	uses interface AMPacket;
} implementation {
	enum { 
		SIMPLE_TDMA_SYNC = 123,
	};
  	
  	void alarm() {
	}
	
  	async command void SlotControl.startSlot(uint8_t slot, message_t *msg, uint8_t len) {		
    }
    
    async command void SlotControl.endSlot(uint8_t slot) {		
    }
    
	async event void SubReceive.receive(message_t *msg, void *payload, uint8_t len) {
		if (call AMPacket.type(msg) == SIMPLE_TDMA_SYNC) {
			call Slotter.synchronize(1);
		}
	}
	
	async event void TDMASlot.sendDone(message_t *msg,  uint8_t len) {
		signal SlotControl.sendDone(msg, len);
	}
	
	async event void TDMASlot.receive(message_t *msg, void *payload, uint8_t len) {
	}
	
	async event void Slotter.slot(uint8_t num) {}
}
