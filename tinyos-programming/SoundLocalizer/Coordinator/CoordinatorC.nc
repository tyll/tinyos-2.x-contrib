module CoordinatorC
{
  uses {
    interface Boot;
    interface SplitControl as RadioControl;
    interface Timer<TMilli>;
    interface AMSend;
    interface Leds;
  }
}
implementation {
  uint16_t count;
  message_t msg;
  bool busy;

  void problem() {
    call Leds.led0Toggle();
  }

  event void Boot.booted() {
    call RadioControl.start();
  }

  event void RadioControl.startDone(error_t error) {
    if (error == SUCCESS)
      call Timer.startPeriodic(BEACON_INTERVAL);
    else
      problem();
  }

  event void RadioControl.stopDone(error_t error) { }

  event void Timer.fired() {
    if (!busy)
      {
	coordination_msg_t *payload = call AMSend.getPayload(&msg, sizeof *payload);

	if (payload)
	  {
	    payload->count = count;
	    payload->sample_at = SAMPLE_TIME;
	    payload->interval = BEACON_INTERVAL;
	    if (call AMSend.send(AM_BROADCAST_ADDR, &msg, sizeof *payload) == SUCCESS)
	      busy = TRUE;
	    else
	      problem();
	  }
      }
    if (++count == SAMPLE_TIME)
      call Timer.stop();
  }

  event void AMSend.sendDone(message_t *m, error_t error) {
    if (m == &msg)
      busy = FALSE;
    if (error == SUCCESS)
      call Leds.led1Toggle();
    else
      problem();
  }
}
