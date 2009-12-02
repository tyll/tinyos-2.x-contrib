#include "TrickleSim.h"

configuration TrickleSimAppC {}
implementation {
  components MainC, TrickleSimC as App, LedsC;
  components new AMSenderC(AM_TRICKLE_SIM_MSG);
  components new AMReceiverC(AM_TRICKLE_SIM_MSG);
  components ActiveMessageC;

  components new TrickleTimerMilliC(TAU_LOW, TAU_HIGH, K, 1);

  App.Boot -> MainC.Boot;

  App.Receive -> AMReceiverC;
  App.AMSend -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.Leds -> LedsC;
  App.Packet -> AMSenderC;
  App.TrickleTimer -> TrickleTimerMilliC.TrickleTimer[0];
}
