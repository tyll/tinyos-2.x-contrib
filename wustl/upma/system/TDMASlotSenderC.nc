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
 * This component transmits packets in pure tdma slot
 * It should solve the clock drift issues
 * 
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */

configuration TDMASlotSenderC {
	provides interface AsyncSend as Send; 
	
	uses interface AsyncSend as SubSend;
	uses interface AMPacket;
	uses interface CcaControl as SubCcaControl;	
} implementation {
	components new GenericSlotSenderC(0, 0, FALSE) as TDMASlotSender;
	components MainC;
	
	TDMASlotSender.SubSend = SubSend;
	TDMASlotSender.AMPacket = AMPacket;
	TDMASlotSender.SubCcaControl = SubCcaControl;
	TDMASlotSender.Send = Send;
}
