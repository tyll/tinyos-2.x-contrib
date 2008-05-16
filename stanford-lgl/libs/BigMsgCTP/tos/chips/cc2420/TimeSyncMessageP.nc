/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Miklos Maroti
 */

module TimeSyncMessageP
{
  provides
  {
    interface Packet;

    interface TimeSyncSend<T32khz> as TimeSyncSend32khz[uint8_t id];
    interface TimeSyncEvent<T32khz> as TimeSyncEvent32khz;
  }

  uses
  {
    interface AMSend as SubSend[uint8_t id];
    interface Packet as SubPacket;
    interface PacketTimeStamp<T32khz,uint32_t>;
    interface PacketLastTouch;
    interface CC2420Ram;
    interface GeneralIO as CSN;
    interface LocalTime<T32khz> as LocalTime32khz;
    interface Leds;
  }
}

implementation
{
/*----------------- Packet -----------------*/

  typedef nx_struct timesync_footer_t
  {
    nx_uint32_t time_offset;  // in micorsec
  } timesync_footer_t;

  typedef struct timesync_local_t
  {
    uint32_t event_time;    // in microsec
  } timesync_local_t;

  inline timesync_footer_t* getFooter(message_t* msg)
  {
    return (timesync_footer_t*)(msg->data + call SubPacket.payloadLength(msg) - sizeof(timesync_footer_t));
  }

  inline timesync_local_t* getLocal(message_t* msg)
  {
    return (timesync_local_t*)(msg->data + call SubPacket.maxPayloadLength() - sizeof(timesync_local_t));
  }

  command void Packet.clear(message_t* msg)
  {
    call SubPacket.clear(msg);
    call PacketLastTouch.cancel(msg); // TODO: check if we need to do this
  }

  command void Packet.setPayloadLength(message_t* msg, uint8_t len)
  {
    call SubPacket.setPayloadLength(msg, len + sizeof(timesync_footer_t));
  }

  command uint8_t Packet.payloadLength(message_t* msg)
  {
    return call SubPacket.payloadLength(msg) - sizeof(timesync_footer_t);
  }

  command uint8_t Packet.maxPayloadLength()
  {
    return call SubPacket.maxPayloadLength() - sizeof(timesync_footer_t) - sizeof(timesync_local_t);
  }

  command void* Packet.getPayload(message_t* msg, uint8_t len)
  {
    return call SubPacket.getPayload(msg, len + sizeof(timesync_footer_t) + sizeof(timesync_local_t));
  }

/*----------------- TimeSyncSend32khz -----------------*/

  command error_t TimeSyncSend32khz.send[am_id_t id](uint32_t event_time, am_addr_t addr, message_t* msg, uint8_t len)
  {
    error_t err;
    timesync_local_t* local = getLocal(msg);

    local->event_time = event_time;

    err = call SubSend.send[id](addr, msg, len+sizeof(timesync_footer_t));
    call PacketLastTouch.request(msg);

    return err;
  }

  command error_t TimeSyncSend32khz.cancel[am_id_t id](message_t* msg)
  {
    call PacketLastTouch.cancel(msg);
    return call SubSend.cancel[id](msg);
  }

  default event void TimeSyncSend32khz.sendDone[am_id_t id](message_t* msg, error_t error)
  {
  }

  command uint8_t TimeSyncSend32khz.maxPayloadLength[am_id_t id]()
  {
    return call SubSend.maxPayloadLength[id]() - sizeof(timesync_footer_t);
  }

  command void* TimeSyncSend32khz.getPayload[am_id_t id](message_t* msg, uint8_t len)
  {
    return call SubSend.getPayload[id](msg, len + sizeof(timesync_footer_t));
  }

  /*----------------- SubSend.sendDone -------------------*/

  event void SubSend.sendDone[am_id_t id](message_t* msg, error_t error)
  {
    signal TimeSyncSend32khz.sendDone[id](msg, error);
  }

  /*----------------- PacketLastTouch.touch -------------------*/

  enum
  {
    TIMESYNC_INVALID_STAMP = 0x80000000L,
  };

  async event void PacketLastTouch.touch(message_t* msg)
  {
    timesync_footer_t* footer = getFooter(msg);
    timesync_local_t* local;

    if( call PacketTimeStamp.isSet(msg) )
    {
      local = getLocal(msg);

      footer->time_offset = local->event_time - call PacketTimeStamp.get(msg);
      call CSN.clr();
      call CC2420Ram.write( sizeof(cc2420_header_t)+call SubPacket.payloadLength(msg) - sizeof(timesync_footer_t),
                              (void*)&footer->time_offset,  4);
      call CSN.set();
    }
    else
      footer->time_offset = TIMESYNC_INVALID_STAMP;
  }

  /*----------------- TimeSyncEvent32khz -----------------*/

  command bool TimeSyncEvent32khz.hasValidTime(message_t* msg)
  {
    timesync_footer_t* footer = getFooter(msg);

    return call PacketTimeStamp.isSet(msg) && footer->time_offset != TIMESYNC_INVALID_STAMP;
  }

  command uint32_t TimeSyncEvent32khz.getTime(message_t* msg)
  {
    timesync_footer_t* footer = getFooter(msg);

    return (uint32_t)(footer->time_offset) + call PacketTimeStamp.get(msg);
  }
}
