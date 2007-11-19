module KeepAliveP
{
  provides interface KeepAlive;
  uses {
    interface SplitControl as RadioSplitControl;
    interface StdControl as DisseminationStdControl;
    interface DisseminationUpdate<nx_struct Beacon> as BeaconUpdate;
    interface DisseminationValue<nx_struct Beacon> as BeaconValue;
    interface Timer<TMilli> as TimeoutTimer;
    interface Timer<TMilli> as BeaconTimer;
    interface Monitor as Monitor;
    interface Leds;
}
}

implementation
{
  enum {
    S_OFF,
    S_ON,
  };

  message_t msg;
  nx_struct Beacon beacon;

  uint8_t listenState;

  command void KeepAlive.startBroadcast(uint32_t interval)
  {
    listenState = S_OFF;
    beacon.interval = 3*interval;
    call DisseminationStdControl.start();
    call BeaconTimer.startPeriodic(interval);
  }

  command void KeepAlive.startListen(uint32_t interval)
  {
    listenState = S_ON;
    call TimeoutTimer.startOneShot(interval);
    call DisseminationStdControl.start();
  }

  command void KeepAlive.stop()
  {
    listenState = S_OFF;
    call TimeoutTimer.stop();
    call BeaconTimer.stop();
    call DisseminationStdControl.stop();
  }

  event void BeaconValue.changed()
  {
    const nx_struct Beacon *recvBeacon = call BeaconValue.get();
    if (listenState == S_ON) {
      beacon.interval = recvBeacon->interval;
      beacon.counter = recvBeacon->counter;
      dbg("KeepAlive", "KeepAlive: reset TimeoutTimer, counter is %d.\n", beacon.counter);
      call TimeoutTimer.startOneShot(beacon.interval);
    }
  }

  event void BeaconTimer.fired()
  {
    beacon.counter = beacon.counter + 1;
    dbg("KeepAlive", "KeepAlive: increment counter to %d.\n", beacon.counter);
    call BeaconUpdate.change(&beacon);
  }

  event void TimeoutTimer.fired()
  {
    dbg("KeepAlive", "KeepAlive: TimeoutTimer.fired, turn the radio off.\n");
    call RadioSplitControl.stop();
    signal KeepAlive.timeout();
  }
  
  event void Monitor.receive(message_t* aMsg, void* payload, uint8_t len)
  {
    dbg("KeepAlive", "KeepAlive: Monitor.receive: reset TimeoutTimer, counter is %d.\n", beacon.counter);
    if (listenState == S_ON) {
      call TimeoutTimer.startOneShot(beacon.interval);
    }
  }

  event void Monitor.sendDone(message_t* aMsg, error_t error)
  {
    dbg("KeepAlive", "KeepAlive: Monitor.sendDone: reset TimeoutTimer, counter is %d.\n", beacon.counter);
    if (listenState == S_ON) {
      call TimeoutTimer.startOneShot(beacon.interval);
    }
  }

  event void RadioSplitControl.startDone(error_t error) { }
  event void RadioSplitControl.stopDone(error_t error) { }

}
