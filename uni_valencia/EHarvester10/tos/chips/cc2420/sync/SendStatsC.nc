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

configuration SendStatsC {
  provides {
    interface Send;
    interface PacketStats;
  }
  uses {
    interface Send as SubSend;
  }
}

implementation {
  components MainC,
      SendStatsP,
      CC2420PacketC,
      CC2420ActiveMessageC,
      NeighbourSyncC;

  Send = SendStatsP.Send;
  SubSend = SendStatsP.SubSend;
  PacketStats = SendStatsP;
  
  SendStatsP.CC2420PacketBody -> CC2420PacketC;
  SendStatsP.AMPacket -> CC2420ActiveMessageC;
  SendStatsP.PacketAcknowledgements -> CC2420PacketC;
  
//#ifdef CC2420SYNC_DEBUG
  /*components  DSNC as DSNC, new DsnCommandC("get stats", uint8_t , 0) as GetStatsCommand;
  SendStatsP.DSN -> DSNC;
  SendStatsP.GetStatsCommand -> GetStatsCommand;*/
//#endif  

}
