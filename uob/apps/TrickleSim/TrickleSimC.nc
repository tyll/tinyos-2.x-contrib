#include "Timer.h"
#include "TrickleSim.h"

module TrickleSimC @safe() {
  uses {
    interface Leds;
    interface Boot;
    interface Receive;
    interface AMSend;
    interface SplitControl as AMControl;
    interface Packet;
    interface TrickleTimer;
  }
}
implementation {

  message_t packet;

  bool locked;
  uint16_t counter = 0;

  event void Boot.booted() {
    dbg("Boot",
	"%s\tTrickleSimC: booted\n",
	sim_time_string());
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call TrickleTimer.start();
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
    call TrickleTimer.stop();
  }

  event void TrickleTimer.fired() {
    //counter++;
    if (locked) {
      return;
    } else {
      trickle_sim_msg_t* tsm = (trickle_sim_msg_t*)
	call Packet.getPayload(&packet,
			       sizeof(trickle_sim_msg_t));
      if (tsm == NULL) {
	dbg("TrickleSimC",
	    "%s\tTrickleSimC: ERROR: tsm == NULL\n",
	    sim_time_string());
	return;
      }

      tsm->counter = counter;
      dbg("TrickleSimC",
	  "%s\tTrickleSimC: sending packet (%hu)\n",
	  sim_time_string(),
	  counter);
      if (call AMSend.send(AM_BROADCAST_ADDR, &packet,
			   sizeof(trickle_sim_msg_t)) == SUCCESS) {
	locked = TRUE;
      }
    }
  }

  event message_t* Receive.receive(message_t* bufPtr,
				   void* payload, uint8_t len) {
    dbg("TrickleSimC",
	"%s\tTrickleSimC: Received packet of length %hhu.\n",
	sim_time_string(),
	len);
    if (len != sizeof(trickle_sim_msg_t)) {
    dbg("TrickleSimC",
	"%s\tTrickleSimC: Invalid packet.\n",
	sim_time_string());
      return bufPtr;
    } else {
      trickle_sim_msg_t* tsm = (trickle_sim_msg_t*)payload;

      if (tsm->counter == counter) {
	// consistent data
	dbg("TrickleSimC",
	    "%s\tTrickleSimC: consistent data. %hu %hu\n",
	    sim_time_string(),
	    counter, tsm->counter);
	call TrickleTimer.incrementCounter();
      } else {
	// inconsistent data detected
	// only update with newer data
	if (tsm->counter > counter) {
	  counter = tsm->counter;
	  dbg("TrickleSimC",
	      "%s\tTrickleSimC: inconsistent newer data. %hu %hu\n",
	      sim_time_string(),
	      counter, tsm->counter);

	} else {
	  dbg("TrickleSimC",
	      "%s\tTrickleSimC: inconsistent older data. %hu %hu\n",
	      sim_time_string(),
	      counter, tsm->counter);
	}
	call TrickleTimer.reset();
      }
      return bufPtr;
    }
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      dbg("TrickleSimC",
	  "%s\tTrickleSimC: packet sent (%hu)\n",
	  sim_time_string(),
	  counter);
      locked = FALSE;
    }
  }
}
