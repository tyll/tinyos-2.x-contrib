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

module HotmacReceiveP {
  provides {
    interface Hotmac;
    interface SplitControl;
    interface Receive;
    interface ControlTransfer as ReceiveTransfer;
    interface Init;
    interface Get<uint8_t> as ControlChannel;
    interface Statistics<struct hotmac_rx_stats>;
  }
  
  uses {
    interface Receive as SubReceive;
    interface State as HotmacState;
    interface AsyncSplitControl as RadioControl;
    interface CC2420Transmit;

    interface Alarm<T32khz, uint32_t> as ReceiveTimeout;
    interface Alarm<T32khz, uint32_t> as ProbeAlarm;

    interface ControlTransfer as TransmitTransfer;
    interface PacketAcknowledgements;
    interface Packet;
    interface CC2420PacketBody;
    interface HotmacPacket;
    interface NeighborTable;
    interface ReceiveIndicator;
    interface CC2420Config;
    interface CC2420Receive;
    interface PacketTimeStamp<T32khz, uint32_t>;
    interface Random;

    interface PowerCycleInfo;
    interface Leds;
  }
} implementation {

  // phase in the 32khz time 
  uint32_t probe_phase;
  // how many 32khz tics between probes
  uint32_t probe_interval = HOTMAC_DEFAULT_CHECK_PERIOD;

  uint8_t channel_control = CC2420_DEF_CHANNEL;
  uint8_t channel_whitelist[] = {CC2420_DEF_CHANNEL}; // 15, 21, 24};
#define CHANNEL_WHITELIST_LEN  ((sizeof(channel_whitelist)) / sizeof(uint8_t))

  uint16_t cwl;
  message_t probe;
  nx_struct hotmac_beacon *probe_beacon = NULL;
  uint8_t current_dsn;
  int missed_beacons;

  void sendProbe();
  task void stopAndPut();
  task void doSplitControlStop();
  bool stopping, switching;

  struct hotmac_rx_stats stats;

  command error_t Init.init() {
    atomic switching = FALSE;
    probe_interval = HOTMAC_DEFAULT_CHECK_PERIOD;
    probe_phase    = 0;
    return SUCCESS;
  }

  void startTimeout() {
    uint32_t timeout;
    atomic {
      timeout = HOTMAC_POSTPROBE_WAIT
        + (HOTMAC_CWIN_SIZE * cwl);
    }
    assertUART(timeout < HOTMAC_DEFAULT_CHECK_PERIOD * 10LL);

    /* change to the data channel */
    atomic switching = TRUE;
    call CC2420Config.setChannel(probe_beacon->channel);
    call CC2420Config.sync();

    call ReceiveTimeout.start(timeout);
    // printfUART("timeout: %i\n", timeout);
  }

  void giveupRadio() {
    if (call HotmacState.isState(S_RECEIVE)) {
      if (!(signal ReceiveTransfer.xfer())) {
        call RadioControl.stop();
      }
    }
  }
  async event void TransmitTransfer.beacon(message_t* msg, void* payload, uint8_t len) {}

  event bool TransmitTransfer.xfer() {
    return FALSE;
  }

  async event void ProbeAlarm.fired() {

    atomic {
      if (call HotmacState.isIdle()) {
        call HotmacState.forceState(S_RECEIVE);
        // we're not transmitting-- turn on and send a probe
        if (call RadioControl.start() != SUCCESS) {
          goto fail;
        }

        // reset the contention window used by senders
        cwl = 1;
        current_dsn = 0;
      } else if (call HotmacState.isState(S_RECEIVE)) {
        // we turned and scheduled the probe for NOW
        // missed_beacons = 0;
        call Leds.led1Toggle();
        atomic stats.probe_tx++;
        if (call CC2420Transmit.resend(TRUE) != SUCCESS) {
          goto fail;
        }
      } else {
      fail:
        post stopAndPut();
      }
    }
  }

  /***************** RadioControl events  ***************/
  async event void RadioControl.startDone(error_t err) {
    atomic {
      if (call HotmacState.isState(S_RECEIVE)) {
        if (err != SUCCESS) {
          post stopAndPut();
        } else {

          call CC2420Config.setShortAddr(TOS_NODE_ID);
          call CC2420Config.setAddressRecognition(TRUE,TRUE);
          call CC2420Config.setAutoAck(FALSE,FALSE);
          call CC2420Config.setChannel(channel_control);
          
          call CC2420Config.sync();
        }
      }
    }
  }

  event void PowerCycleInfo.stopDone(uint32_t on_time) {
    printfUART("awake for %lu\n", on_time);
  }

  event void RadioControl.stopDone(error_t err) {
    atomic {
      if (call HotmacState.isState(S_RECEIVE)) {
        call HotmacState.toIdle();
      }
    }

    if (stopping) {
      post doSplitControlStop();
    }
  }

  async event void CC2420Config.syncDone(error_t error) {
    atomic {
      if (call HotmacState.isState(S_RECEIVE)) {
        if (error != SUCCESS) {
          post stopAndPut();
        } else if (!switching){
          sendProbe();
        } else {
          switching = FALSE;
        }
      }
    }
  }

  /***************** Code to send a probe  ***************/
  void sendProbe() {
    uint8_t l_dsn;

    atomic {
      call HotmacPacket.setNetwork(&probe, HOTMAC_6LOWPAN_NETWORK);
      probe_beacon->period = probe_interval;
      probe_beacon->cwl = cwl;

      if (current_dsn == 0) {
        /* only choose a new channel if this is the first probe... */
        probe_beacon->channel = channel_whitelist[(call Random.rand16()) % 
                                                  CHANNEL_WHITELIST_LEN];
      }

      l_dsn = current_dsn;
    }

    call HotmacPacket.constructHeader(&probe, 
                                      TOS_NODE_ID | 0x8000, 
                                      sizeof(nx_struct hotmac_beacon));
    call PacketAcknowledgements.requestAck(&probe);
    call HotmacPacket.setDsn(&probe, l_dsn);

    if (call CC2420Transmit.load(&probe) != SUCCESS) {
      post stopAndPut();
    }
  }

  task void stopAndPut() {
    uint32_t now = call ProbeAlarm.getNow();
    uint32_t wake_dt;

    atomic {
      call ReceiveTimeout.stop();

      if (now > probe_phase) {
        wake_dt = probe_interval - 
          ((now - probe_phase) % probe_interval);
      } else {
        wake_dt = probe_phase - now;
      }

      if (wake_dt < HOTMAC_WAKEUP_LOAD_TIME) {
        // we schedule the wakeup a little before when we need to send
        // the beacon, so we can turn on the radio and load the beacon.
        // wake_dt += probe_interval;
        wake_dt = HOTMAC_WAKEUP_LOAD_TIME + 0x1f;
      }
      wake_dt -= HOTMAC_WAKEUP_LOAD_TIME;

      assertUART(wake_dt < HOTMAC_DEFAULT_CHECK_PERIOD * 2);
      call ProbeAlarm.startAt(now, wake_dt);
      // printfUART("wake in: %lu\n", wake_dt);

      giveupRadio();
    }
  }

  async event void CC2420Transmit.loadDone(message_t *msg, error_t error) {

    if (!call HotmacState.isState(S_RECEIVE)) return;
    if (error == SUCCESS) {
      if (current_dsn > 0) {
        signal ProbeAlarm.fired();
      } else {
        // compute exactly when to send the next beacon
        uint32_t now = call ProbeAlarm.getNow();
        uint32_t wake_dt;
    
        if (now > probe_phase) {
          wake_dt = probe_interval - 
            ((now - probe_phase) % probe_interval);
        } else {
          wake_dt = probe_phase - now;
        }

        if (wake_dt > HOTMAC_WAKEUP_TOO_LONG) {
          // we might have missed the wakeup, so don't stay awake for
          // the whole period waiting for a beacon.

          // send one right now in case receivers are waiting.
          wake_dt = 0x1f;
        }
      
        assertUART(wake_dt > 0);
        call ProbeAlarm.startAt(now, wake_dt);
      }
    } else {
      post stopAndPut();
    }
  }

  async event void CC2420Transmit.sendDone(message_t *msg, error_t error) {

    if (!call HotmacState.isState(S_RECEIVE)) return;
    if (error != SUCCESS) goto done;
    if (!call PacketAcknowledgements.wasAcked(msg)) {
      // no ack.  go back to sleep.
      goto done;
    } else {
      startTimeout();
      // got an ack.  wait to receive a packet.
      return;
    }
  done:
    post stopAndPut();
  }

  /***************** Code to send a probe  ***************/

  async event void ReceiveTimeout.fired() {
    atomic {
      if (!call HotmacState.isState(S_RECEIVE)) return;
      if (!call ReceiveIndicator.isReceiving()) {
        if (cwl == 1) {
          // using a base of 4 seems reasonable, since if we missed a
          // packet, there are probably two senders and so this gives is
          // only a 1/4 chance of colliding again.
          cwl = 4;
        } else if (cwl < 32) {
          cwl *= 2;
        } else {
          post stopAndPut();
          return;
        }

        sendProbe();
      } else {
        call ReceiveTimeout.start(HOTMAC_POSTPROBE_WAIT);
      }
    }
  }

  async event void CC2420Receive.receive(uint8_t type, message_t *msg) {
    cc2420_header_t *header = call CC2420PacketBody.getHeader(msg);
    if (type != IEEE154_TYPE_DATA) return;
    // the async version of receive doesn't do an address check
    // the hardware should make sure that this never happens, though
    // atomic printfUART("DATA RX: %x %i\n", header->dest, header->length);
    if (header->length < CC2420_SIZE) return;

    if (call HotmacPacket.getNetwork(msg) == HOTMAC_6LOWPAN_NETWORK) {
      if (header->length - CC2420_SIZE != sizeof(nx_struct hotmac_beacon)) return;
      // received a beacon frame.  pass it to the send manager.
      signal ReceiveTransfer.beacon(msg, msg->data, sizeof(nx_struct hotmac_beacon));
      atomic stats.probe_rx++;
    } else {
      atomic {
        // received a data frame.  deliver and reset the state machine.

        // stop any running timers.  We will restart them later if
        // necessary.
        if (!(call ReceiveTimeout.isRunning())) {
          // the packet was too slow comming in; we would have already
          // shut down the radio in the timeout
          return;
        } else {
          call ReceiveTimeout.stop();
        }
        call ProbeAlarm.stop();
        
        current_dsn = call HotmacPacket.getDsn(msg);
        assertUART(current_dsn != 0); 
        // try to reduce the window as senders leave the system due to
        // their packets successfully getting through.
        if (cwl > 4) cwl /= 2;
        
        if (header->dest != AM_BROADCAST_ADDR) {
          // call Leds.led2Toggle();
          sendProbe();
        } else {
          post stopAndPut();
        }
      }
    }
  }

  event message_t* SubReceive.receive(message_t* msg, void* payload, uint8_t len) {
    assertUART(msg != NULL);

    if (call HotmacPacket.getNetwork(msg) == HOTMAC_6LOWPAN_NETWORK) {
      // if it was a beacon, we handled it async
      // update our cache and exit
      cc2420_header_t* header = call CC2420PacketBody.getHeader( msg );
      nx_struct hotmac_beacon *beacon = (nx_struct hotmac_beacon *)payload;
      struct hotmac_neigh_entry *neigh = 
        call NeighborTable.lookupOrInsert(header->src);


      // don't update the phase on beacons which weren't the first one...
      if (call HotmacPacket.getDsn(msg) > 0) return msg;
      if (neigh == NULL) return msg;

      if (call PacketTimeStamp.isValid(msg)) {
        neigh->period = beacon->period;
        neigh->phase = (call PacketTimeStamp.timestamp(msg)) % 
          ((uint32_t)neigh->period);
        assertUART(neigh->period <= HOTMAC_SEND_TIMEOUT);
      }

      return msg;
    } else {
      struct hotmac_neigh_entry *neigh;
      ieee154_saddr_t nAddr = (call CC2420PacketBody.getHeader(msg))->src;
      // atomic printfUART("CHECK: N: %i\n", nAddr);
      atomic stats.data_rx++;

      neigh = call NeighborTable.lookupOrInsert(nAddr);
      if (neigh == NULL) {
        return signal Receive.receive(msg, payload, len);
      } else {
        if (neigh->lsn == call HotmacPacket.getDsn(msg)) {
          printfUART("DUP %i %i\n", neigh->lsn, call HotmacPacket.getDsn(msg));
          return msg;
        } else {
          neigh->lsn = call HotmacPacket.getDsn(msg);
          return signal Receive.receive(msg, payload, len);
        }
      }
    }
  }

  /*********** SplitControl ************/
  task void startDone() {
    signal SplitControl.startDone(SUCCESS);
  }

  task void doSplitControlStop() {
    call ProbeAlarm.stop();
    if (call HotmacState.isIdle()) {
      stopping = FALSE;
      call HotmacState.forceState(S_OFF);
      signal SplitControl.stopDone(SUCCESS);
    } else {
      stopping = TRUE;
    }
  }

  command error_t SplitControl.start() {
    atomic {
      stopping = FALSE;
      probe_phase =  (call Random.rand16()) % HOTMAC_DEFAULT_CHECK_PERIOD;
/*       probe_interval =  (call Random.rand16()) % (HOTMAC_DEFAULT_CHECK_PERIOD / 20) +  */
/*         HOTMAC_DEFAULT_CHECK_PERIOD;  */
      probe_beacon = (nx_struct hotmac_beacon *)call Packet.getPayload(&probe, 4);

      call HotmacState.forceState(S_IDLE);
      // if (TOS_NODE_ID == 1)
      call ProbeAlarm.start(probe_interval + probe_phase);
      // call Leds.led1Toggle();
      post startDone();
    }
    return SUCCESS;
  }

  command error_t SplitControl.stop() {
    post doSplitControlStop();
    return SUCCESS;
  }

  event void NeighborTable.evicted(ieee154_saddr_t neighbor) {}

  command uint8_t ControlChannel.get() {
    return channel_control;
  }

  command void Statistics.clear() {
    memset(&stats, 0, sizeof(stats));
  }

  command void Statistics.get(struct hotmac_rx_stats *s) {
    memcpy(s, &stats, sizeof(stats));
  }

  /* Hotmac interface */
  command error_t Hotmac.setPeriod(uint32_t period) {
    atomic probe_interval = period;
  }

  command uint32_t Hotmac.getPeriod() {
    atomic return probe_interval;
  }

  command void Hotmac.overhear() {}

  


  default event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    atomic printfUART(" !!!! receive len: %i from :%i \n", 
                      len, 
                      (call CC2420PacketBody.getHeader(msg))->src);
    // call NeighborTable.print();
    return msg;
  }
}
