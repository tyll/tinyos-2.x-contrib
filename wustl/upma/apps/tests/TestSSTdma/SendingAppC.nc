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

generic configuration SendingAppC(uint16_t interval, bool sends)
{
}
implementation
{
	components MainC;
	components PrintfC;
	components ActiveMessageC;
	components HplMsp430GeneralIOC;
	
	components new SendingC(interval, sends) as App;
	components new AMSenderC(240) as AMSender;
	components LedsC;
	components new TimerMilliC();
	components new TimerMilliC() as FlushTimerC;
	components new TimerMilliC() as BenchmarkTimerC;
	components new TimerMilliC() as StartTimerC;
	components new AMReceiverC(240) as AMReceiver;
	components Counter32khz32C;
	components StatsC;
	
  	App.BenchmarkTimer -> BenchmarkTimerC;
  	App.StartTimer -> StartTimerC;
	App.Pin -> HplMsp430GeneralIOC.Port27;
	App.RcvPin -> HplMsp430GeneralIOC.Port26;
	App.Boot -> MainC;
	
	App.FlushTimer -> FlushTimerC;
	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.AMSender -> AMSender;
	App.AMReceiver -> AMReceiver;
	App.Packet -> ActiveMessageC;
	App.SendTimer -> TimerMilliC;
	App.SplitControl -> ActiveMessageC;
	App.Counter -> Counter32khz32C;
	
	App.Stats -> StatsC;
}

