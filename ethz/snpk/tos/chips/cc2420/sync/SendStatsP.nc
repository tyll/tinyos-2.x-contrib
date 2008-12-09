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

#include "CC2420.h"

module SendStatsP {
  provides {
    interface Send;
    interface PacketStats;
  }
  uses {
    interface Send as SubSend;

    interface CC2420PacketBody;
    interface PacketAcknowledgements;
    interface AMPacket;
//#ifdef CC2420SYNC_DEBUG
    interface DsnSend as DSN;
    interface DsnCommand<uint8_t> as GetStatsCommand;
//#endif    
  }
}

implementation {

  uint32_t n_broadcast=0;
  uint32_t n_unicast_long=0;
  uint32_t n_unicast_long_acked=0;
  uint32_t n_unicast_short=0;
  uint32_t n_unicast_short_acked=0;
  
  uint32_t n_send=0;
  uint32_t n_senddone=0;

  /***************** Prototypes *********/
  
  /***************** Send Commands ***************/
  command error_t Send.send(message_t *msg, uint8_t len) {
	  error_t error;
	  if ((error=call SubSend.send(msg, len))==SUCCESS)
		  n_send++;
    return error;
  }

  command error_t Send.cancel(message_t *msg) {
    return call SubSend.cancel(msg);
  }
  
  command uint8_t Send.maxPayloadLength() {
    return call SubSend.maxPayloadLength();
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }
  

  /***************** SubSend Events ***************/
  event void SubSend.sendDone(message_t* msg, error_t error) {
    cc2420_metadata_t * meta;
    n_senddone++;
    meta = call CC2420PacketBody.getMetadata(msg);
    if (call AMPacket.destination(msg)==AM_BROADCAST_ADDR) {
      n_broadcast++;
    }
    else {
      if (meta->synced || meta->rxInterval==0) {
        n_unicast_short++;
        n_unicast_short_acked+= call PacketAcknowledgements.wasAcked(msg);
      }
      else {
        n_unicast_long++;
        n_unicast_long_acked+= call PacketAcknowledgements.wasAcked(msg);
      }
    }

    // print packet metadata
#ifdef CC2420SYNC_DEBUG
    call DSN.logInt(call AMPacket.destination(msg));
    call DSN.logInt( meta->rxInterval);
    call DSN.logInt( meta->lplTransmissions);
    call DSN.logInt( meta->backoffSamples);
    call DSN.logInt( meta->retries);
    call DSN.logInt( meta->snoopedAcks);    
    call DSN.logInt( meta->ack);
    call DSN.logInt( error);
    call DSN.logInt( n_send);
    call DSN.logInt( n_senddone);
    call DSN.logWarning("dst: %i, meta: %ims, lpl# %i, samples %i, retries %i, snooped %i, ack %i, error %i, %i %i");
#endif
    signal Send.sendDone(msg, error);
  }
  
  command uint16_t PacketStats.getBroadcast() {  return n_broadcast; }
  command uint16_t PacketStats.getUnicast() {  return n_unicast_long; }
  command uint16_t PacketStats.getUnicastAck() {  return n_unicast_long_acked; }
  command uint16_t PacketStats.getSyncUnicast() {  return n_unicast_short; }
  command uint16_t PacketStats.getSyncUnicastAck() {  return n_unicast_short_acked; }
  
  
  /***************** DSN events ************************/
//#ifdef CC2420SYNC_DEBUG  
  event void GetStatsCommand.detected(uint8_t * values, uint8_t n) {
    call DSN.logInt(n_broadcast);
    call DSN.logInt(n_unicast_long);
    call DSN.logInt(n_unicast_long_acked);
    call DSN.logInt(n_unicast_short);
    call DSN.logInt(n_unicast_short_acked);
    call DSN.log("Stats: %i | %i %i | %i %i");
  }
//#endif
  /***************** Functions ***********************/


  /***************** Tasks ********************************/

}
