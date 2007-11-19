/* Copyright (c) 2007 Johns Hopkins University.
*  All rights reserved.
*
*  Permission to use, copy, modify, and distribute this software and its
*  documentation for any purpose, without fee, and without written
*  agreement is hereby granted, provided that the above copyright
*  notice, the (updated) modification history and the author appear in
*  all copies of this source code.
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
*/

/**
 * @author Razvan Musaloiu-E. <razvanm@cs.jhu.edu>
 */


module MonitorC
{
  provides {
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface AMSend[uint8_t id];
    interface Monitor;
  }

  uses {
    interface AMPacket;
    interface Receive as SubReceive[am_id_t id];
    interface Receive as SubSnoop[am_id_t id];
    interface AMSend as SubAMSend[am_id_t id];
    interface PacketAcknowledgements as Acks;
  }
}

implementation
{
  command error_t AMSend.send[am_id_t id](am_addr_t addr, message_t* msg, uint8_t len) {
    if (addr != AM_BROADCAST_ADDR) {
      call Acks.requestAck(msg);
    }

    return call SubAMSend.send[id](addr, msg, len);
  }

  command uint8_t AMSend.maxPayloadLength[am_id_t id]() { return call SubAMSend.maxPayloadLength[id](); }

  event message_t* SubReceive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len)
  {
    signal Monitor.receive(msg, payload, len);
    return signal Receive.receive[id](msg, payload, len);
  }
  
  event message_t* SubSnoop.receive[am_id_t id](message_t* msg, void* payload, uint8_t len)
  {
    signal Monitor.receive(msg, payload, len);
    return signal Snoop.receive[id](msg, payload, len);
  }

  event void SubAMSend.sendDone[am_id_t id](message_t* msg, error_t error)
  {
    signal Monitor.sendDone(msg, error);
    return signal AMSend.sendDone[id](msg, error);
  }

  command error_t AMSend.cancel[am_id_t id](message_t* msg) { return call SubAMSend.cancel[id](msg); }
  command void* AMSend.getPayload[am_id_t id](message_t* msg, uint8_t len) { return call SubAMSend.getPayload[id](msg, len); }

  default event message_t* Receive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) { return msg; }
  default event message_t* Snoop.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) { return msg; }

  default event void Monitor.receive(message_t* msg, void* payload, uint8_t len) { }
  default event void Monitor.sendDone(message_t* msg, error_t error) { }
}
