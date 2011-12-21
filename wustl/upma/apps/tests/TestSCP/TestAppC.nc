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
 * @author Greg Hackmann
 * @version $Revision$
 * @date $Date$
 */

#include "TestMsg.h"

configuration TestAppC
{
}
implementation
{
	components MainC;
	components new TestC(FALSE) as App;
//	components new TestC(TRUE) as App;
	components new TimerMilliC() as Timer;
	components LedsC;
	components ActiveMessageC as AM;
	components MacControlC;
	
	components SerialActiveMessageC;
	
	App.Boot -> MainC;
	App.Timer -> Timer;
	App.Leds -> LedsC;
	App.SyncInterval -> MacControlC.SyncInterval;
	App.Scp -> MacControlC.Scp;
	App.RadioControl -> AM.SplitControl;
	App.AMSend -> AM.AMSend[AM_TESTMSG];
	App.Receive -> AM.Receive[AM_TESTMSG];

	App.AMSerial -> SerialActiveMessageC.AMSend[150];
}
