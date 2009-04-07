#include "CounterPacket.h"
configuration TestBroadcastPolicyAppC {
} implementation {
  components TestBroadcastPolicyC as App, MainC, BroadcastPolicyC as Policy, new TimerMilliC() as Timer, LedsC, ActiveMessageC as AM;
//  components new DfrfClientC(APPID_COUNTER, counter_packet_t, offsetof(counter_packet_t, unique_delimiter), 512) as DfrfService;
  components new DfrfClientC(APPID_COUNTER, counter_packet_t, sizeof(counter_packet_t), 15*sizeof(counter_packet_t)) as DfrfService;

  // initialization and startup
  App -> MainC.Boot;
  App.AMControl -> AM.SplitControl;

  // routing control/send/receive/policy
  App.DfrfControl -> DfrfService.StdControl;
  App.DfrfSend -> DfrfService;
  App.DfrfReceive -> DfrfService;
  DfrfService.Policy -> Policy;

  // app wirings
  App.Timer -> Timer;
  App.Leds -> LedsC;
  App.AMPacket -> AM;

  // RemoteControll components
  components LedRcC;
}
