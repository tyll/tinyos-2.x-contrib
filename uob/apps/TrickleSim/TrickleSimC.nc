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
    //interface TrickleTimer;
    interface UobTrickleTimer;
  }
}
implementation {

  message_t packet;

  bool locked;
  uint16_t counter = 0;
  uint32_t windowSize;

  event void Boot.booted() {
    dbg("Boot",
	"%s\tTrickleSimC: booted\n",
	sim_time_string());

#ifdef PUSH
    dbg("Boot",
	"%s\tTrickleSimC: ***** PUSH ***** (TAU: %u)\n",
	sim_time_string(), UOB_PUSH);
#else
    dbg("Boot",
	"%s\tTrickleSimC: ***** TRICKLE ***** (TAU_L: %u, TAU_H: %u, K: %u)\n",
	sim_time_string(), UOB_TAU_LOW, UOB_TAU_HIGH, UOB_K);
#endif
    windowSize = UOB_TAU_HIGH;
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call UobTrickleTimer.start();
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
    call UobTrickleTimer.stop();
  }

  event void UobTrickleTimer.fired() {
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
      tsm->sender = TOS_NODE_ID;

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
    if (len != sizeof(trickle_sim_msg_t)) {
    dbg("TrickleSimC",
	"%s\tTrickleSimC: Invalid packet.\n",
	sim_time_string());
      return bufPtr;
    } else {
      trickle_sim_msg_t* tsm = (trickle_sim_msg_t*)payload;

      dbg("TrickleSimC",
	  "%s\tTrickleSimC: Received packet of length %hhu from node %u.\n",
	  sim_time_string(),
	  len,
	  tsm->sender);

      if (tsm->counter == counter) {
	// consistent data
	dbg("TrickleSimC",
	    "%s\tTrickleSimC: consistent data. %hu %hu\n",
	    sim_time_string(),
	    counter, tsm->counter);
	call UobTrickleTimer.incrementCounter();
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
	call UobTrickleTimer.reset();
      }
      return bufPtr;
    }
  }

  /*
  event uint32_t UobTrickleTimer.requestWindowSize() {

    windowSize = windowSize << 1;
    if(windowSize > UOB_TAU_HIGH) {
      windowSize = UOB_TAU_HIGH;
    }

    dbg("TrickleSimC", "Window size requested, give %u\n", windowSize);
    return windowSize;
  }
  */

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
