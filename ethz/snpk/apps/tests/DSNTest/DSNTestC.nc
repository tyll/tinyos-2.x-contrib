#include "DSNTest.h"

configuration DSNTestC
{
}
implementation
{
	components MainC, DSNTestP as App, LedsC;
	components DSNC;
	components new TimerMilliC() as Timer;
	components new TimerMilliC() as BlinkTimer;
	components ActiveMessageC;
	
	App.Boot -> MainC.Boot;
	App.DSN -> DSNC.DsnSend;
	App.DsnReceive -> DSNC;
 	App.Leds -> LedsC;
	App.Timer -> Timer;
	App.BlinkTimer -> BlinkTimer;
	App.AMPacket -> ActiveMessageC;
	App.Packet -> ActiveMessageC;
	App.RadioControl -> ActiveMessageC;

}
