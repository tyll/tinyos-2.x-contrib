
/**
 * @author David Moss
 */
 
#include "TestBroadcast.h"

configuration TestBroadcastC {
}

implementation {

#if defined(PLATFORM_MICA2) || defined(PLATFORM_MICA2DOT)
  components CC1000ActiveMessageC as Lpl;
#elif defined(PLATFORM_MICAZ) || defined(PLATFORM_TELOSB)
  components CC2420ActiveMessageC as Lpl;
#else
#error "LPL testing not supported on this platform"
#endif

  components TestBroadcastP,
      MainC,
      ActiveMessageC,
      new AMSenderC(AM_TESTSYNCMSG),
      new AMReceiverC(AM_TESTSYNCMSG),
      new TimerMilliC(),
      new TimerMilliC() as HeartbeatC,
      LedsC;
      
  TestBroadcastP.Boot -> MainC;
  TestBroadcastP.SplitControl -> ActiveMessageC;
  TestBroadcastP.LowPowerListening -> Lpl;
  TestBroadcastP.AMPacket -> ActiveMessageC;
  TestBroadcastP.AMSend -> AMSenderC;
  TestBroadcastP.Receive -> AMReceiverC;
  TestBroadcastP.Packet -> ActiveMessageC;
  TestBroadcastP.Leds -> LedsC;
  TestBroadcastP.Timer -> TimerMilliC;
  TestBroadcastP.Heartbeat -> HeartbeatC;

}

