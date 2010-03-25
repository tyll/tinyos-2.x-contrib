#include "TestPacketTimestamp.h"

configuration TestPacketTimestampAppC {}
implementation {
  components MainC, TestPacketTimestampC as App, LedsC;
  components ActiveMessageC;
  components new TimerMilliC();

  App.Boot -> MainC.Boot;

  App.PingReceive -> ActiveMessageC.Receive[AM_PING_MSG];
  App.PingAMSend -> ActiveMessageC.AMSend[AM_PING_MSG];
  App.PongAMSend -> ActiveMessageC.AMSend[AM_PONG_MSG];
  App.AMControl -> ActiveMessageC;
  App.Leds -> LedsC;
  App.MilliTimer -> TimerMilliC;
  App.Packet -> ActiveMessageC;
  App.AMPacket -> ActiveMessageC;
  App.PacketTimeStamp -> ActiveMessageC;
}


