/*
 * "Copyright (c) 2010 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */
/*
 * @author Stephen Dawson-Haggerty <stevedh@eecs.berkeley.edu>
 */

#include <PrintfUART.h>
#include "hotmac.h"

module HotmacTransmitP {
  provides {
    interface AMSend;
    interface Init;

    interface HotmacPacket;
    interface PacketLink;
    interface ControlTransfer as TransmitTransfer;

    interface Statistics<struct hotmac_tx_stats>;
  }

  uses {
    interface RadioBackoff as SubBackoff;
    interface CC2420PacketBody;
    interface CC2420Config;
    interface CC2420Transmit;
    interface PacketAcknowledgements;

    interface Random;
    interface AsyncSplitControl as RadioControl;
    interface State as HotmacState;
    interface Alarm<T32khz, uint32_t> as SendAlarm;
    interface ControlTransfer as ReceiveTransfer;
    interface NeighborTable;
    interface Get<uint8_t> as ControlChannel;

    interface Leds;
  }
} implementation {

  // delivery parameters
  uint16_t cwl;
  uint16_t maxcwl, delivery_attempts;
  uint8_t current_dsn;
#define INCR_DSN() do {                         \
    current_dsn++; \
    if (current_dsn == 0) current_dsn = 1; \
  } while (0)

  // state machine variables
  bool send_from_load, send_from_sync;
  ieee154_saddr_t dest_addr;
  error_t    pending_error;
  message_t *pending_msg, *pending_deliver_msg;

  // accounting state
  uint16_t nBeacons;
  uint32_t start_time;

  void restartSend();
  void sendDone(error_t error, uint32_t shutdown_delay);
  void giveupRadio();
  void scheduleWakeup();

  struct hotmac_tx_stats stats;

  command error_t Init.init() {
    atomic {
      pending_deliver_msg = pending_msg = NULL;
      current_dsn = call Random.rand16() & 0xff;
      INCR_DSN();
      cwl = maxcwl = 1;
      send_from_load = FALSE;
    }
    return SUCCESS;
  }

  void giveupRadio() {
/*     if (!(signal TransmitTransfer.xfer())) { */
    if ((call RadioControl.stop()) != SUCCESS) {
      call HotmacState.toIdle();
    }
/*     } */
  }

  void scheduleWakeup() {
    struct hotmac_neigh_entry *entry;

    entry = call NeighborTable.lookup(dest_addr);
    if (entry == NULL || 
        entry->period == 0 ||
        dest_addr == IEEE154_BROADCAST_ADDR) {
      // if there's no entry or we don't have phase information
      call SendAlarm.start(0x1f);
    } else {
      uint32_t now = call SendAlarm.getNow();
      uint32_t wakeTime;
      if (now > entry->phase) {
        wakeTime = entry->period - 
          ((now - entry->phase) % entry->period);
      } else {
        wakeTime = entry->phase - now;
      }

      if (wakeTime < HOTMAC_WAKEUP_LOAD_TIME + HOTMAC_GUARD_TIME)
        wakeTime += entry->period; 
      wakeTime = wakeTime - HOTMAC_WAKEUP_LOAD_TIME - HOTMAC_GUARD_TIME;
         
      assertUART(wakeTime < HOTMAC_DEFAULT_CHECK_PERIOD * 2);
      call SendAlarm.startAt(now, wakeTime);
    }
  }

  /***************  AMSend **************/
  command error_t AMSend.send(ieee154_saddr_t addr, message_t* msg, uint8_t len) {
    ieee154_saddr_t old_dest = dest_addr;
    atomic {
      if (call HotmacState.isState(S_OFF)) {
        return EOFF;
      }

      if (pending_msg != NULL) {
        return EBUSY;
      }

      if (len > TOSH_DATA_LENGTH) {
        return ESIZE;
      }
      
      call HotmacPacket.constructHeader(msg, addr, len);
      call HotmacPacket.setDsn(msg, current_dsn);

      dest_addr = addr;
      pending_msg = msg;
      delivery_attempts = 0;
      maxcwl = 0;
      send_from_load = FALSE;

      if ((call SendAlarm.isRunning()) && 
          // pending_msg == NULL && // already checked for
          old_dest == dest_addr && 
          (call HotmacState.isState(S_TRANSMIT))) {
        // we just finished a send, but the receiver is still
        // awake.  If the next message is for him, send it right away
        // rather then waiting for another probe
        send_from_load = TRUE;
        call SendAlarm.stop();

        if (call CC2420Transmit.load(pending_msg) == SUCCESS) {
          return SUCCESS;
        } // else fall through
      }
      scheduleWakeup();
    }
      
    return SUCCESS;
  }

  command error_t AMSend.cancel(message_t* msg) {

  }

  command uint8_t AMSend.maxPayloadLength() {
    return TOSH_DATA_LENGTH;
  }

  command void* AMSend.getPayload(message_t* msg, uint8_t len) {
    return msg->data;
  }

  async event void ReceiveTransfer.beacon(message_t *p_msg, void *payload, uint8_t len) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader( p_msg );
    nx_struct hotmac_beacon *beacon = (nx_struct hotmac_beacon *)payload;
    /* this happens when sending a broadcast: auto-ack is on, address
       recognition is off, so we receive everything.  */
    if ((dest_addr != IEEE154_BROADCAST_ADDR) &&
        ((header->dest & ~0x8000) != dest_addr)) return;
    atomic {
      if (!(call HotmacState.isState(S_TRANSMIT)) || pending_msg == NULL) {
        return;
      }

      assertUART(p_msg != NULL);
      assertUART(call SendAlarm.isRunning());
      assertUART(pending_msg != NULL);

      nBeacons++;
      maxcwl = beacon->cwl > cwl ? beacon->cwl : cwl;
      cwl = beacon->cwl;
      
      if (header->dsn != current_dsn || 
          header->dest == IEEE154_BROADCAST_ADDR) {
        call Leds.led0Toggle();

        if (beacon->channel != (call CC2420Config.getChannel())) {
          send_from_sync = TRUE;
          call CC2420Config.setChannel(beacon->channel);
          call CC2420Config.sync();
          atomic printfUART("chan: %i\n", beacon->channel);
        } else if (call CC2420Transmit.resend(TRUE) != SUCCESS) {
          // SDH : I guess this could happen if we're loading the
          // message and a probe comes in.
          // sendDone(FAIL, 0);
          send_from_load = TRUE;
        } else {
          (call CC2420PacketBody.getMetadata( pending_msg ))->retries++;
        }
      } else {
        (call CC2420PacketBody.getMetadata( pending_msg ))->ack = TRUE;
        sendDone(SUCCESS, HOTMAC_POSTPROBE_WAIT);
      }
    }
    return;
  }

  task void sendDone_task() {
    message_t *deliver_msg;
    error_t deliver_error;

    atomic {
      deliver_msg = pending_deliver_msg;
      deliver_error = pending_error;
      pending_deliver_msg = NULL;
      if (pending_error != SUCCESS)
        (call CC2420PacketBody.getMetadata( deliver_msg ))->ack = FALSE;
    }
    assertUART(deliver_msg != NULL);
    signal AMSend.sendDone(deliver_msg, deliver_error);
  }

  void sendDone(error_t error, uint32_t when) {
    pending_error = error;
    pending_deliver_msg = pending_msg;
    pending_msg = NULL;
    INCR_DSN();

    call SendAlarm.stop();
    post sendDone_task();

    if (when) {
      assertUART(when < HOTMAC_DEFAULT_CHECK_PERIOD * 2);
      call SendAlarm.start(when);
    } else {
      giveupRadio();
    }
  }

  /************* CC2420Transmit  *************/
  async event void CC2420Transmit.loadDone(message_t *msg, error_t error) {
    atomic {
      if (call HotmacState.isState(S_TRANSMIT)) {
        if (error != SUCCESS) {
          sendDone(error, 0);
          return;
        } if (send_from_load) {
          // if we're part of a streaming send, we would have already
          // received a beacon.  therefore, transmit immediately
          if (call CC2420Transmit.resend(TRUE) != SUCCESS) {
            sendDone(error, 0);
            return;
          }
          send_from_load = FALSE;
        }
        call SendAlarm.start(HOTMAC_SEND_TIMEOUT);
      }
    }
  }

  async event void CC2420Transmit.sendDone(message_t *msg, error_t error) {
    if (call HotmacState.isState(S_TRANSMIT)) {
      atomic stats.data_tx++;
    }
    if (dest_addr == IEEE154_BROADCAST_ADDR) {
      // SDH : TODO : switch back to control channel
    }
  }

  event bool ReceiveTransfer.xfer() {
    atomic {
      if (pending_msg != NULL && !call SendAlarm.isRunning()) {
        call HotmacState.forceState(S_TRANSMIT);
        restartSend();
        return TRUE;
      }
    }
    return FALSE;
  }

  /************* SplitControl *************/
  async event void RadioControl.startDone(error_t error) {
    atomic {
      if (call HotmacState.isState(S_TRANSMIT)) {

        if (error != SUCCESS) {
          sendDone(error, 0);
          return;
        }

        nBeacons = 0;
        restartSend();
      }
    }
  }

  event void RadioControl.stopDone(error_t error) {
    atomic {
      if (call HotmacState.isState(S_TRANSMIT)) {
        printfUART("stopDone: %i\n", nBeacons);

        call HotmacState.toIdle();
      } else if (pending_msg != NULL && !call SendAlarm.isRunning()) {
        call SendAlarm.start(0x1F);
      }
    }
  }

  async event void CC2420Config.syncDone(error_t error) {
    atomic {
      if (call HotmacState.isState(S_TRANSMIT)) {
        if (error != SUCCESS) {
          sendDone(FAIL, 0);
          return;
        }
        if (pending_msg != NULL) {
          if (send_from_sync) {
            send_from_sync = FALSE;
            if (call CC2420Transmit.resend(TRUE) != SUCCESS) {
              sendDone(FAIL, 0);
            }
          } else {
            if (call CC2420Transmit.load(pending_msg) != SUCCESS) {
              sendDone(FAIL, 0);
            } 
          }
        }
      }
    }
  }

  void restartSend() {
    assertUART(pending_msg != NULL);

    if ((call CC2420PacketBody.getHeader(pending_msg))->dest == 
        IEEE154_BROADCAST_ADDR) {
      call CC2420Config.setAddressRecognition(FALSE,FALSE);
    } else {
      call CC2420Config.setAddressRecognition(TRUE,TRUE);
    }
    
    call CC2420Config.setShortAddr(dest_addr | 0x8000);
    call CC2420Config.setAutoAck(TRUE,TRUE);
    call CC2420Config.setChannel(call ControlChannel.get());
    call CC2420Config.sync();
  }

  async event void SendAlarm.fired() {
    atomic {
      if (call HotmacState.isState(S_TRANSMIT)) {
        if (pending_msg == NULL) {
          // called to shut down the radio
          giveupRadio();
        } else {
          // we just finished an attempt, but didn't deliver a message since we're here
          assertUART(pending_msg != NULL);

          if ((call CC2420PacketBody.getHeader(pending_msg))->dest == IEEE154_BROADCAST_ADDR
              || delivery_attempts >= call PacketLink.getRetries(pending_msg)) {
            (call CC2420PacketBody.getMetadata( pending_msg ))->ack = FALSE;
            sendDone(SUCCESS, 0);
          } else {
            uint32_t backoff_time = (((call Random.rand16() % 4)) * HOTMAC_SEND_TIMEOUT) + 
              ((call Random.rand16()) % HOTMAC_SEND_TIMEOUT) + 0x1f;
            
            assertUART(backoff_time < 10L * HOTMAC_DEFAULT_CHECK_PERIOD);
            call SendAlarm.start(backoff_time);
            delivery_attempts++;
            //atomic printfUART("starting attempt: %i\n", delivery_attempts);
            giveupRadio();
            (call CC2420PacketBody.getMetadata( pending_msg ))->retries++;
          }
        }
      } else if (call HotmacState.isIdle()) {
        // a deferred send is taking place-- either we're waiting again
        // or we're trying to optimize by waking up right before the
        // receiver.
        assertUART(pending_msg != NULL);

        call HotmacState.forceState(S_TRANSMIT);
        if (call RadioControl.start() != SUCCESS) {
          sendDone(FAIL, 0);
        }
      } else {
        // might be receiving
        assertUART(pending_msg != NULL);
      }
    }
  }

  /*************** RadioBackoff ********************/

  async event void SubBackoff.requestInitialBackoff(message_t * ONE msg) {
    uint8_t l_cwl;
    atomic l_cwl = cwl;

    if (msg == pending_msg) {
      // for data
      call SubBackoff.setInitialBackoff( (call Random.rand16() % l_cwl)
                                         * HOTMAC_CWIN_SIZE
                                         + CC2420_MIN_BACKOFF ); 
    } else {
      // for probes
      call SubBackoff.setInitialBackoff( CC2420_MIN_BACKOFF );
    }
  }

  async event void SubBackoff.requestCongestionBackoff(message_t * ONE msg) {
    atomic {
      if (msg == pending_msg) {
        // if there's contention on the channel, our strategy is to wait
        // for another beacon, so give up on this transmission...
        call CC2420Transmit.cancel();

        (call CC2420PacketBody.getMetadata( pending_msg ))->retries--;

      } else {
        // for probes -- doesn't really matter
        call SubBackoff.setCongestionBackoff( call Random.rand16()
                                              % (0x7 * CC2420_BACKOFF_PERIOD) + CC2420_MIN_BACKOFF);
      }
    }
  }



  /************* HotmacPacket *************/
  async command void HotmacPacket.constructHeader(message_t *p_msg, ieee154_saddr_t addr, uint8_t len) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader( p_msg );
    cc2420_metadata_t* metadata = call CC2420PacketBody.getMetadata( p_msg );

    assertUART(p_msg != NULL);

    header->length = len + CC2420_SIZE;
    header->fcf = ( ( IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE ) |
                    ( 1 << IEEE154_FCF_INTRAPAN ) |
                    ( IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE ) |
                    ( IEEE154_ADDR_SHORT << IEEE154_FCF_SRC_ADDR_MODE ) );
    header->dsn = 0;
    header->destpan = call CC2420Config.getPanAddr();
    header->dest = addr;
    // don't use CC2420Config -- might be | 0x8000
    header->src = TOS_NODE_ID;

    metadata->tx_power = 0;
    metadata->ack = FALSE;
    metadata->rssi = 0;
    metadata->lqi = 0;
    metadata->retries = 0;
    metadata->timestamp = CC2420_INVALID_TIMESTAMP;
  }

  async command uint8_t HotmacPacket.getDsn(message_t *p_msg) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader( p_msg );
    return header->dsn;
  }

  async command void HotmacPacket.setDsn(message_t *p_msg, uint8_t dsn) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader( p_msg );
    header->dsn = dsn;
  }

  async command uint8_t HotmacPacket.getNetwork(message_t *p_msg) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader( p_msg );
#ifdef CC2420_IFRAME_TYPE
    return header->network;
#else
    return header->type;
#endif
  }

  async command void HotmacPacket.setNetwork(message_t *p_msg, uint8_t nwid) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader( p_msg );
#ifdef CC2420_IFRAME_TYPE
    header->network = nwid;
#else
    header->type = nwid;
#endif
  }

  command void PacketLink.setRetries(message_t *msg, uint16_t maxRetries) {
    atomic (call CC2420PacketBody.getMetadata(msg))->retries = maxRetries;
  }

  command void PacketLink.setRetryDelay(message_t *msg, uint16_t retryDelay) {
  }

  command uint16_t PacketLink.getRetries(message_t *msg) {
    atomic return (call CC2420PacketBody.getMetadata(msg))->retries;
  }

  command uint16_t PacketLink.getRetryDelay(message_t *msg) {
    return 0;
  }


  command void Statistics.clear() {
    memset(&stats, 0, sizeof(stats));
  }

  command void Statistics.get(struct hotmac_tx_stats *s) {
    memcpy(s, &stats, sizeof(stats));
  }

  command bool PacketLink.wasDelivered(message_t *msg) {
    return call PacketAcknowledgements.wasAcked(msg);
  }

  async event void SubBackoff.requestCca(message_t *msg) {}

  event void NeighborTable.evicted(ieee154_saddr_t neighbor) {}


}

