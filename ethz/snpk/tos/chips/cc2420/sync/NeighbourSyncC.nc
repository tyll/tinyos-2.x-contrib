/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
* 
*  @author: Roman Lim <lim@tik.ee.ethz.ch>
*
*/

configuration NeighbourSyncC {
  provides {
    interface Send;
    interface Receive;
    interface NeighbourSyncRequest;
    interface NeighbourSyncPacket;
    interface NeighbourSyncFlowPacket;
    interface PacketLogger;
  }
  uses {
    interface Send as SubSend;
    interface Receive as SubReceive;
  }
}

implementation {
  components MainC,
      NeighbourSyncP,
      new Alarm32khz32C(),
      CC2420PacketC,
      PowerCycleC,
      CC2420TransmitC,
      new StateC() as RadioPowerStateC,
      new StateC() as SyncSendStateC,
      CC2420CsmaC,
      new TimerMilliC() as UpdateTimer,
      new AMSenderC(RESYNC_AM_TYPE) as ResyncSender,
      CC2420ActiveMessageC;
  
#if defined(LOW_POWER_LISTENING) || defined(ACK_LOW_POWER_LISTENING)
  components DefaultLplC as LplC;
#else
  components DummyLplC as LplC;
#endif

  Send = NeighbourSyncP.Send;
  Receive = NeighbourSyncP.Receive;

  SubSend = NeighbourSyncP.SubSend;
  SubReceive = NeighbourSyncP.SubReceive;
  
  NeighbourSyncRequest = NeighbourSyncP.NeighbourSyncRequest;
  NeighbourSyncPacket = NeighbourSyncP;
  NeighbourSyncFlowPacket = NeighbourSyncP;
  PacketLogger = NeighbourSyncP;
  
  MainC.SoftwareInit -> Alarm32khz32C;

  NeighbourSyncP.Alarm -> Alarm32khz32C;
  NeighbourSyncP.PowerCycle -> PowerCycleC;
  NeighbourSyncP.RadioTimeStamping -> CC2420TransmitC;
  NeighbourSyncP.CC2420Transmit -> CC2420TransmitC;
  NeighbourSyncP.TimedPacket -> CC2420TransmitC;
  NeighbourSyncP.CC2420PacketBody -> CC2420PacketC;
  NeighbourSyncP.PacketAcknowledgements -> CC2420PacketC;
  NeighbourSyncP.RadioPowerState -> RadioPowerStateC;
  NeighbourSyncP.SyncSendState -> SyncSendStateC;
  NeighbourSyncP.SubControl -> CC2420CsmaC;
  NeighbourSyncP.SubBackoff -> CC2420CsmaC;
  NeighbourSyncP.SendState -> LplC;
  NeighbourSyncP.UpdateTimer -> UpdateTimer;
  
  NeighbourSyncP.AMSend->ResyncSender;
  NeighbourSyncP.LowPowerListening -> CC2420ActiveMessageC;
  
#ifdef CC2420SYNC_DEBUG
  components DSNC as DSNC;
  components new DsnCommandC("get syncstats", uint8_t , 0) as SyncstatCommand;
  NeighbourSyncP.SyncstatCommand->SyncstatCommand;
  NeighbourSyncP.DSN -> DSNC;
#endif
}
