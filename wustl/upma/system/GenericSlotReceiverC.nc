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
/**                                             
 *
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */

generic configuration GenericSlotReceiverC(bool pm, uint16_t idleTo) {
	provides interface SlotControl;
	provides interface GenericSlotEvents;
	provides interface SlotReceive;
 	
	uses interface RadioPowerControl;
	uses interface AsyncReceive as SubReceive;
	uses interface ChannelMonitor;
	uses interface Slotter;
	uses interface AMPacket;

} implementation {
	components new GenericSlotReceiverP(pm, idleTo);
	components MainC;
	components DummyChannelMonitorC;
	
	GenericSlotReceiverP.SlotReceive = SlotReceive;
	GenericSlotReceiverP.GenericSlotEvents = GenericSlotEvents;
	GenericSlotReceiverP.SlotControl = SlotControl;
	MainC.SoftwareInit -> GenericSlotReceiverP.Init;
	GenericSlotReceiverP.RadioPowerControl = RadioPowerControl;
	GenericSlotReceiverP.SubReceive = SubReceive;
	GenericSlotReceiverP.ChannelMonitor = ChannelMonitor;
	GenericSlotReceiverP.Slotter = Slotter;
	GenericSlotReceiverP.AMPacket = AMPacket;
}
