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

configuration BeaconSlotC {
	provides interface AsyncSend as Send;
	provides interface AsyncReceive as Receive; 
	
	uses interface SlotterControl;
	uses interface AsyncSend as SubSend;
	uses interface AsyncReceive as SubReceive;
	uses interface AMPacket;
	uses interface CcaControl as SubCcaControl;	
	uses interface Alarm<T32khz, uint32_t> as SyncAlarm;

} implementation {
	components BeaconSlotP;
	components MainC;
	
	MainC.SoftwareInit -> BeaconSlotP.Init;
	BeaconSlotP.SubCcaControl = SubCcaControl;
	BeaconSlotP.SlotterControl = SlotterControl;
	BeaconSlotP.AMPacket = AMPacket;
	BeaconSlotP.SubSend = SubSend;
	BeaconSlotP.SyncAlarm = SyncAlarm;
	BeaconSlotP.SubReceive = SubReceive;
	BeaconSlotP.Receive = Receive;
	BeaconSlotP.Send = Send;
}
