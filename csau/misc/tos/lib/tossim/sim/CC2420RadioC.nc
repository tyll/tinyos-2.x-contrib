/*
 * Copyright (c) 2010 Aarhus University
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
 * - Neither the name of Aarhus University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL AARHUS
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
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   February 08 2010
 */

configuration CC2420RadioC {

	provides {
		interface TossimPacketModel as Model;		
		interface SplitControl as Control;

		interface LowPowerListening;
		interface PacketAcknowledgements;
		interface PacketLink;
		interface CC2420Packet;
	}

	uses {
		interface TossimPacketModel as SubModel;		
		interface SplitControl as SubControl;
		interface Packet;
	}

} implementation {

  components TossimPacketModelC as Network;
	components TossimAdapterC as Adapter;

#ifdef PACKET_LINK
  components PacketLinkC as LinkC;
#else
  components PacketLinkDummyC as LinkC;
#endif
	
	components UniqueSendC;
  components UniqueReceiveC;

#ifdef LOW_POWER_LISTENING
  components DefaultLplC as LplC;
#else
  components DummyLplC as LplC;
#endif

	components CC2420CsmaC;
	components CC2420TransmitC;
	components CC2420ReceiveC;
	components CC2420PacketC;

	// Control Layers
	Control = LplC;
	LplC.SubControl -> CC2420CsmaC;
	CC2420CsmaC.SubControl = SubControl;

	// Send layers
	Adapter.SubSend -> UniqueSendC;
	UniqueSendC.SubSend -> LinkC;
	LinkC.SubSend -> LplC;
	LplC.SubSend -> CC2420TransmitC;
	CC2420TransmitC.SubSend -> Adapter;
	
	// Receive Layers
	Adapter.SubReceive -> LplC;
	LplC.SubReceive -> UniqueReceiveC.Receive;
	UniqueReceiveC.SubReceive -> CC2420ReceiveC;
	CC2420ReceiveC.SubReceive ->	Adapter;	

	Model = Adapter.Model;
	Adapter.SubModel = SubModel;

	Adapter.Packet = Packet;
	CC2420TransmitC.ChannelAccess -> Network;;
	CC2420TransmitC.CC2420PacketBody -> CC2420PacketC;

	LowPowerListening = LplC;
  PacketAcknowledgements = CC2420PacketC;
	PacketLink = LinkC;
	CC2420Packet = CC2420PacketC;

}
