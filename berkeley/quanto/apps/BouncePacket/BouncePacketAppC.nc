#include <Timer.h>
#define AM_BOUNCEPACKET 0xCA
configuration BouncePacketAppC
{
}
implementation
{
    components MainC, BouncePacketC as Bounce;
    components UserButtonC;
    components RandomC;
    components LedsC;

    components new TimerMilliC() as Timer0;
    components new TimerMilliC() as Timer1;
    components new TimerMilliC() as StopTimer;

    components ActiveMessageC;
    components new AMSenderC(AM_BOUNCEPACKET);
    components new AMReceiverC(AM_BOUNCEPACKET);
    
    components ResourceContextsC;

    //Enable continuous streaming log over the UART
    components QuantoLogMyUARTWriterC;

    Bounce.Boot -> MainC;
    Bounce.Random -> RandomC;
    Bounce.Timer0 -> Timer0;
    Bounce.Timer1 -> Timer1;
    Bounce.Leds -> LedsC;

    Bounce.StopTimer -> StopTimer;

    Bounce.AMControl -> ActiveMessageC;
    Bounce.Packet -> AMSenderC;
    Bounce.AMSend -> AMSenderC;
    Bounce.Receive -> AMReceiverC;

    Bounce.UserButtonNotify -> UserButtonC;

    Bounce.CPUContext -> ResourceContextsC.CPUContext;

    components CC2420ActiveMessageC;
    Bounce.RadioBackoff -> CC2420ActiveMessageC.RadioBackoff[AM_BOUNCEPACKET];
    Bounce.LowPowerListening -> CC2420ActiveMessageC;

    
}
 
