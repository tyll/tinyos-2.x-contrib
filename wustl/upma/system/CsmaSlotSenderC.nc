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

#include "SenderDispatcher.h"

generic configuration CsmaSlotSenderC(uint16_t offset, uint16_t backoff, uint16_t checkLength) {
	provides interface AsyncSend as Send;

	uses interface ChannelMonitor;
	uses interface AsyncSend as SubSend;
	uses interface AMPacket;
	uses interface CcaControl as SubCcaControl;
} implementation {
	components MainC;
	components LedsC;
	components new CsmaSlotSenderP(offset, backoff, checkLength);
	components new Alarm32khz32C();

	MainC.SoftwareInit -> CsmaSlotSenderP.Init;
	CsmaSlotSenderP.SubSend = SubSend;
	CsmaSlotSenderP.AMPacket = AMPacket;
	CsmaSlotSenderP.SubCcaControl = SubCcaControl;
	CsmaSlotSenderP.Leds -> LedsC;
	CsmaSlotSenderP.ChannelMonitor = ChannelMonitor;
	Send = CsmaSlotSenderP;
	CsmaSlotSenderP.Alarm -> Alarm32khz32C;
	
	 components RandomC;
  	CsmaSlotSenderP.Random -> RandomC;
	
	
}
