module TestLppNodeP
{
  uses {
    interface Boot;
    interface Leds;
    interface SplitControl as RadioSplitControl;
    interface SplitControl as SerialSplitControl;
    interface LowPowerProbing as Lpp;
    interface KeepAlive;
    interface AMSend;
  }
}

implementation
{
  message_t msg;
  bool busy = 1;

  nx_struct status {
    nx_am_addr_t addr;
    nx_uint8_t on;
  } *status;

  event void Boot.booted()
  {
    call Lpp.setLocalSleepInterval(10*1024);
    status = call AMSend.getPayload(&msg, sizeof(*status));
    status->addr = TOS_NODE_ID;
    call SerialSplitControl.start();
  }

  event void RadioSplitControl.startDone(error_t error)
  {
    call Leds.led0On();
    call KeepAlive.startListen(1024);
    if (!busy) {
      busy = 1;
      status->on = 1;
      call AMSend.send(AM_BROADCAST_ADDR , &msg, sizeof(*status));
    }
  }

  event void KeepAlive.timeout()
  {
    call Leds.led0Off();
    if (!busy) {
      busy = 1;
      status->on = 0;
      call AMSend.send(AM_BROADCAST_ADDR , &msg, sizeof(*status));
    }
  }

  event void AMSend.sendDone(message_t* lmsg, error_t error)
  {
    busy = 0;
  }

  event void SerialSplitControl.startDone(error_t error)
  {
    busy = 0;
  }

  event void RadioSplitControl.stopDone(error_t error) { }
  event void SerialSplitControl.stopDone(error_t error) { }
}
