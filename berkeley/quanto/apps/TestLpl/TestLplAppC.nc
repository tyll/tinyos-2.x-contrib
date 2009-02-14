#include <Timer.h>
#include "QuantoLogStagedMyUART.h"
#define AM_BOUNCEPACKET 0xCA
configuration TestLplAppC
{
}
implementation
{
    components MainC, TestLplC as TestLpl;
    components UserButtonC;
    components RandomC;
    components LedsC;

    components new QuantoLogStagedMyUARTC(QLOG_ONESHOT) as CLog;

    components ActiveMessageC;
    components new AMReceiverC(AM_BOUNCEPACKET);
    
    components ResourceContextsC;

    TestLpl.Boot -> MainC;
    TestLpl.Leds -> LedsC;

    TestLpl.AMControl -> ActiveMessageC;
    TestLpl.Receive -> AMReceiverC;

    TestLpl.QuantoLog -> CLog;
    TestLpl.UserButtonNotify -> UserButtonC;

    TestLpl.CPUContext -> ResourceContextsC.CPUContext;

    components CC2420ActiveMessageC;
    TestLpl.LowPowerListening -> CC2420ActiveMessageC;
}
 
