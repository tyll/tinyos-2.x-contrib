configuration DfrfEngineC {
  provides {
    interface DfrfControl[uint8_t appId];
    interface DfrfSendAny as DfrfSend[uint8_t appId];
    interface DfrfReceiveAny as DfrfReceive[uint8_t appId];
  }
  uses {
    interface DfrfPolicy[uint8_t appId];
  }
} implementation {

  components MainC, DfrfEngineP as Engine, TimeSyncMessageC, new TimerMilliC() as Timer, new TimerMilliC() as DfrfTimer, HilTimerMilliC, NoLedsC as LedsC, NoLedsC;

  DfrfSend = Engine.DfrfSend;
  DfrfReceive = Engine.DfrfReceive;

  Engine.DfrfControl = DfrfControl;
  Engine.DfrfPolicy = DfrfPolicy;
  Engine.Packet -> TimeSyncMessageC;
  Engine.Leds -> LedsC;
  Engine.LocalTime -> HilTimerMilliC;
  Engine.TimeSyncAMSend -> TimeSyncMessageC.TimeSyncAMSendMilli[AM_DFRF_MSG];
  Engine.Receive -> TimeSyncMessageC.Receive[AM_DFRF_MSG];
  Engine.TimeSyncPacket -> TimeSyncMessageC.TimeSyncPacketMilli;
  Engine.Timer -> DfrfTimer;

}

