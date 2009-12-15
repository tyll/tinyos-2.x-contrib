#include "TrickleSim.h"

configuration TrickleSimAppC {}
implementation {
  components MainC, TrickleSimC as App, LedsC;
  components new AMSenderC(AM_TRICKLE_SIM_MSG);
  components new AMReceiverC(AM_TRICKLE_SIM_MSG);
  components ActiveMessageC;

#ifndef PUSH
  components UobTrickleMilliC as TimerC;
#else
  components UobPushMilliC as TimerC;
#endif
  App.Boot -> MainC.Boot;

  App.Receive -> AMReceiverC;
  App.AMSend -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.Leds -> LedsC;
  App.Packet -> AMSenderC;

  App.UobTrickleTimer -> TimerC.TrickleTimer;
}
