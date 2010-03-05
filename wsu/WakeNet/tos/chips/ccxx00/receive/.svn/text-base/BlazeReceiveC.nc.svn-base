/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */


/**
 * Lowest level implementation on the receive branch.
 *
 * SplitControl.stop() must put this component in a state where it is 
 * safe to turn off the radio before signalling stopDone()
 *
 * @author Jared Hill
 * @author David Moss
 */


configuration BlazeReceiveC {
  provides {
    interface Receive[ radio_id_t id ];
    interface AckReceive;
    interface RxNotify[ radio_id_t id ];
    interface SplitControl[ radio_id_t id ];
    interface State as ReceiveState;
    interface Backoff as AckBackoff[am_id_t amId];
    interface PacketCount as ReceivedPacketCount;
    interface PacketCount as OverheardPacketCount;
  }
}

implementation {

  components BlazeReceiveP;  
  Receive = BlazeReceiveP.Receive;
  AckReceive = BlazeReceiveP;
  SplitControl = BlazeReceiveP.SplitControl;
  RxNotify = BlazeReceiveP.RxNotify;
  AckBackoff = BlazeReceiveP.AckBackoff;
  ReceivedPacketCount = BlazeReceiveP.ReceivedPacketCount;
  OverheardPacketCount = BlazeReceiveP.OverheardPacketCount;
  
  components new StateC();
  BlazeReceiveP.State -> StateC;
  ReceiveState = StateC;
  
  components BlazeCentralWiringC;
  BlazeReceiveP.Csn -> BlazeCentralWiringC.Csn;
  BlazeReceiveP.RxIo -> BlazeCentralWiringC.Gdo0_io;
  BlazeReceiveP.BlazeConfig -> BlazeCentralWiringC.BlazeConfig;
  BlazeReceiveP.RxInterrupt -> BlazeCentralWiringC.Gdo0_int;
  BlazeReceiveP.ChipRdy -> BlazeCentralWiringC.Gdo2_io;
  BlazeReceiveP.BlazeRegSettings -> BlazeCentralWiringC.BlazeRegSettings;
  
  components MainC;
  MainC.SoftwareInit -> BlazeReceiveP;
  
  components BlazePacketC,
      BlazeSpiC as Spi,
      new BlazeSpiResourceC(),
      FifoThrottleC;
      
  BlazeReceiveP.Resource -> BlazeSpiResourceC;
  BlazeReceiveP.RXFIFO -> Spi.RXFIFO;
  BlazeReceiveP.SFRX -> Spi.SFRX;
  
  BlazeReceiveP.RadioStatus -> Spi.RadioStatus;

  BlazeReceiveP.BlazePacket -> BlazePacketC;
  BlazeReceiveP.BlazePacketBody -> BlazePacketC;
  
  components new ReceiveModeC();
  BlazeReceiveP.ReceiveMode -> ReceiveModeC;
  
  components BlazeTransmitC;
  BlazeReceiveP.AckSend -> BlazeTransmitC.AckSend;
  
  components ActiveMessageAddressC;
  BlazeReceiveP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  components new AlarmMultiplexC();
  BlazeReceiveP.AckGap -> AlarmMultiplexC;
  
  components RandomC;
  BlazeReceiveP.Random -> RandomC;
  
  components LedsC;
  BlazeReceiveP.Leds -> LedsC;
  
	//added by Gang
	BlazeReceiveP.MCSM2 -> Spi.MCSM2;
#if BLAZE_ENABLE_CRC_32
  components PacketCrcC;
  BlazeReceiveP.PacketCrc -> PacketCrcC;
#endif
}
