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


configuration ACMeterAppC {}

implementation {
	components MainC, ACMeterApp, ACMeterC, LedsC;
	components new AMSenderC(AM_ENERGYMSG) as AMSenderC;
	components new AMReceiverC(AM_SWITCHMSG) as AMReceiverC;
	components ActiveMessageC as ActiveMessageC;
        components LocalIeeeEui64C;

	ACMeterApp.Boot -> MainC.Boot;
	ACMeterApp.AMSend -> AMSenderC;
	ACMeterApp.Packet -> AMSenderC;
	ACMeterApp.AMReceive -> AMReceiverC;
	ACMeterApp.Leds -> LedsC;
	ACMeterApp.MeterControl -> ACMeterC.SplitControl;
	ACMeterApp.AMControl -> ActiveMessageC;
	ACMeterApp.ACMeter -> ACMeterC.ACMeter;
        ACMeterApp.LocalIeeeEui64 -> LocalIeeeEui64C;
}
