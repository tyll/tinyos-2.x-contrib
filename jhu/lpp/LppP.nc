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
 * This is the LPP implementation for CC2420. To prevent false
 * wake-ups the acks are turned off during the probing. After a
 * wake-up is detected the hardware acks are turn on.
 *
 * @author Razvan Musaloiu-E. <razvanm@cs.jhu.edu>
 */

module LppP
{
  provides {
    interface SplitControl;
    interface LowPowerProbing as Lpp;
    interface AMSend[uint8_t id];
  }

  uses {
    interface Boot;
    interface CC2420Config;
    interface SplitControl as SubSplitControl;
    interface AMSend as BeaconAMSend;
    interface PacketAcknowledgements as Acks;
    interface Timer<TMilli>;
    interface Random;
    interface Leds;
    interface CC2420Packet;
    interface AMSend as SubAMSend[uint8_t id];
  }
}

implementation
{
  enum {
    S_OFF,
    S_ON
  };

  uint8_t radioState = S_OFF;
  uint8_t dutyCycleState = S_OFF;
  uint8_t syncState = S_OFF;
  uint16_t sleepInterval = 0;
  bool stopDonePending = FALSE;

  message_t beacon_msg;

  task void stopRadio();
  task void startRadio();
  task void sendBeacon();

  void startTimer()
  {
    call Timer.startOneShot(sleepInterval + call Random.rand16() % 1024);
  }
  
  event void Boot.booted() { }

  command void Lpp.setLocalSleepInterval(uint16_t sleepIntervalMs)
  {
    dbg("LppP", "LppP: sleepIntervalMs: %i\n", sleepIntervalMs);
    if (sleepIntervalMs == 0) {
      dbg("LppP", "LppP: dutyCycleState: S_OFF\n");
      dutyCycleState = S_OFF;
    } else {
      dbg("LppP", "LppP: dutyCycleState: S_ON\n");
      dutyCycleState = S_ON;
      sleepInterval = sleepIntervalMs;
      if (radioState == S_ON) {
	call CC2420Config.setAutoAck(FALSE, TRUE);
	post stopRadio();
      } else {
	startTimer();
      }
    }
  }

  command uint16_t Lpp.getLocalSleepInterval()
  {
    return sleepInterval;
  }

  command error_t SplitControl.start()
  {
    return call SubSplitControl.start();
  }

  command error_t SplitControl.stop()
  {
    stopDonePending = TRUE;
    if (dutyCycleState == S_ON) {
      call Lpp.setLocalSleepInterval(sleepInterval);    
      return SUCCESS;
    } else {
      return call SubSplitControl.stop();
    }
  }

  event void Timer.fired()
  {
    if (radioState == S_OFF) {
      if (dutyCycleState == S_ON) {
	post startRadio();
      }
    }
  }

  event void SubSplitControl.startDone(error_t error)
  {
    call Leds.led0On();
    radioState = S_ON;
    dbg("LppP", "LppP: radioState = S_ON, channel = %d.\n", call CC2420Config.getChannel());
    if (dutyCycleState == S_ON) {
      post sendBeacon();
    } else {
      signal SplitControl.startDone(error);
    }
  }

  event void SubSplitControl.stopDone(error_t error)
  {
    call Leds.led0Off();
    radioState = S_OFF;
    dbg("LppP", "LppP: radioState = S_OFF, channel = %d.\n", call CC2420Config.getChannel());
    if (stopDonePending) {
      stopDonePending = FALSE;
      signal SplitControl.stopDone(error);
    }
    if (dutyCycleState == S_ON) {
      startTimer();
    }
  }
  
  // Implementation of the tasks
  task void sendBeacon()
  {
    dbg("LppP", "LppP: sendBeacon: try to send.\n");
    call Acks.requestAck(&beacon_msg);
    if (call BeaconAMSend.send(AM_BROADCAST_ADDR, &beacon_msg, 0) != SUCCESS) {
      post sendBeacon();
    } 
  }

  task void stopRadio()
  {
    if (dutyCycleState == S_ON) {
      if (call SubSplitControl.stop() != SUCCESS) {
        post stopRadio();
      }
    }
  }

  task void startRadio()
  {
    if (dutyCycleState == S_ON) {
      if (call SubSplitControl.start() != SUCCESS) {
        post startRadio();
      }
    }
  }

  event void BeaconAMSend.sendDone(message_t* msg, error_t error)
  {
    if (call Acks.wasAcked(msg)) {
      dbg("LppP", "LppP: Acks.wasAcked.\n");
      call CC2420Config.setAutoAck(TRUE, TRUE);
      syncState = S_ON;
      call CC2420Config.sync();
    } else {
      dbg("LppP", "LppP: sendDone: no ack, going to bed.\n");
      if (call SubSplitControl.stop() != SUCCESS) {
	post stopRadio();
      }
    }
  }

  event void CC2420Config.syncDone(error_t error)
  {
    if (syncState == S_ON) {
      dbg("LppP", "LppP: CC2420Config.syncDone.\n");
      signal SplitControl.startDone(SUCCESS);
    } else {
      dbg("LppP", "LppP: CC2420Config.syncDone: ignored.\n");
    }
  }

  // AMSend proxying...
  command error_t AMSend.send[am_id_t id](am_addr_t addr, message_t* msg, uint8_t len)
  {
    if (radioState == S_ON || id == SLOW_LPL_AM) {
      dbg("LppP", "LppP: AMSend.send: addr=%i msg=%p len=%i\n", addr, msg, len);
      return call SubAMSend.send[id](addr, msg, len);
    } else {
      return EOFF;
    }
  }

  command error_t AMSend.cancel[am_id_t id](message_t* msg)
  {
    return call SubAMSend.cancel[id](msg);
  }

  command uint8_t AMSend.maxPayloadLength[am_id_t id]()
  {
    return call SubAMSend.maxPayloadLength[id]();
  }

  command void* AMSend.getPayload[am_id_t id](message_t* msg, uint8_t len)
  {
    return call SubAMSend.getPayload[id](msg, len);
  }

  event void SubAMSend.sendDone[am_id_t id](message_t* msg, error_t error)
  {
    dbg("LppP", "LppP: SubAMSend.sendDone: msg=%x error=%i\n", msg, error);
    signal AMSend.sendDone[id](msg, error);
  }
}
