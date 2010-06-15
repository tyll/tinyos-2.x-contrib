#include "TestPacketTimeSync.h"

configuration TestPacketTimeSyncAppC {}
implementation {
  components MainC, TestPacketTimeSyncC as App, LedsC;
  components ActiveMessageC;
  components TimeSyncMessageC;
  components new TimerMilliC();
  components LocalTimeHybridMicroC as LocalTimeMicroC;
  components NoSleepC;

  App.Boot -> MainC.Boot;

  App.PingReceive -> TimeSyncMessageC.Receive[AM_PING_MSG];
  App.PingAMSend -> TimeSyncMessageC.TimeSyncAMSendRadio[AM_PING_MSG];
  App.PongAMSend -> ActiveMessageC.AMSend[AM_PONG_MSG];
  App.AMControl -> ActiveMessageC;
  App.Leds -> LedsC;
  App.MilliTimer -> TimerMilliC;
  App.Packet -> ActiveMessageC;
  App.AMPacket -> ActiveMessageC;
  App.PacketTimeStamp -> ActiveMessageC;
  App.TimeSyncPacket -> TimeSyncMessageC;
  App.LocalTime -> LocalTimeMicroC;
  
}


