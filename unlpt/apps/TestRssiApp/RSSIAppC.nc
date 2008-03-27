/*
* Copyright (c) 2008 New University of Lisbon - Faculty of Sciences and
* Technology.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of New University of Lisbon - Faculty of Sciences and
*   Technology nor the names of its contributors may be used to endorse or 
*   promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * @author Miguel Silva (migueltsilva@gmail.com)
 * @version $Revision$
 * @date $Date$
 */

#include "RSSI.h"

configuration RSSIAppC {}
implementation {
	components RSSIC;

	components MainC;
	RSSIC.Boot -> MainC;

	components LedsC;
	RSSIC.Leds -> LedsC;

	components new TimerMilliC() as Timer;
	RSSIC.Timer -> Timer;

	components PrintfC;
	RSSIC.PrintfControl -> PrintfC;
	RSSIC.PrintfFlush -> PrintfC;

	components ActiveMessageC;
	RSSIC.AMControl -> ActiveMessageC;

	components new AMReceiverC(AM_RSSIMSG);
	RSSIC.RadioReceive -> AMReceiverC;

	components new AMSenderC(AM_RSSIMSG);
	RSSIC.RadioSend -> AMSenderC;
	RSSIC.PacketAck -> AMSenderC;
	RSSIC.RadioPacket -> AMSenderC;
	RSSIC.RadioAMPacket -> AMSenderC;

	components CC2420PacketC;
	RSSIC.CC2420Packet -> CC2420PacketC;

	components UserButtonC;
	RSSIC.Get -> UserButtonC;
	RSSIC.Notify -> UserButtonC;
}
