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

module GenericSlotterP {
	provides {
		interface Init;
		interface AsyncStdControl;
		interface Slotter;
		interface SlotterControl;
		interface FrameConfiguration;
	}	
	uses {
		interface Alarm<T32khz, uint32_t>;
		interface Leds;
//		interface HplMsp430GeneralIO as Pin;
		interface Boot;
	}
}
implementation {
	norace uint8_t slot;
	norace uint32_t slotLength;
	norace uint8_t frameLength;
	bool sync;
	uint32_t nextFire;

	command error_t Init.init() {
		atomic {
			slotLength = 320;
			frameLength = 17;
			sync = FALSE;
		}
		return SUCCESS;
	}
	
	event void Boot.booted()
	{
		//call Pin.makeOutput();
	}

 	async command error_t AsyncStdControl.start() {
 		atomic nextFire = call Alarm.getNow() + slotLength;
 		return SUCCESS;
 	}
 	async command error_t AsyncStdControl.stop() {
 		call Alarm.stop();
 		return SUCCESS;
 	}
 	
 	async command error_t SlotterControl.synchronize(uint8_t toSlot) {
 	 	atomic slot = toSlot - 1;
 		
 	 	call Alarm.stop();
		signal Alarm.fired();
 		return SUCCESS;
 	}
 	
 	command void FrameConfiguration.setSlotLength(uint32_t slotTimeBms) {
 		atomic slotLength = slotTimeBms;
 	}
 	
 	command void FrameConfiguration.setFrameLength(uint8_t numSlots) {
 		atomic frameLength = numSlots;
 	}
 	
 	command uint32_t FrameConfiguration.getSlotLength() {
 		return slotLength;
 	}
 	
 	command uint8_t FrameConfiguration.getFrameLength() {
 		return frameLength;
 	}
 	
 	async command uint32_t SlotterControl.getAlarm() {
 		return call Alarm.getAlarm();
 	}
 	
	async command uint32_t SlotterControl.getNow() {
		return call Alarm.getNow();
	}
	
	async command void SlotterControl.stop() {
		call Alarm.stop();
	}
	
	
 	async event void Alarm.fired() {
 		atomic nextFire = call Alarm.getNow() + slotLength;
 		atomic slot = (slot +1) % frameLength;
 	 	signal Slotter.slot(slot);
 	 	//call Pin.toggle();
 		call Alarm.start(slotLength);
 	}
 	
 	async command uint8_t SlotterControl.getSlot() {
 		return slot;
 	}
 	async command uint32_t SlotterControl.getRemaining() {
 		uint32_t now, diff;
 		now = call Alarm.getNow();
 		atomic {
 		if (nextFire > now) diff = nextFire - now;
 		else diff = 0;
 		}
 		
 		return diff;
 	}
 	
 	async command bool SlotterControl.isSynchornized() {
 		return sync;
 	}
}
