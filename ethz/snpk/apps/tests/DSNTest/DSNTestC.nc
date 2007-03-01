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

	MainC.SoftwareInit -> DSNC.Init;
	
	App.Boot -> MainC.Boot;
	App.DSN -> DSNC;
 	App.Leds -> LedsC;
	App.Timer -> Timer;
	App.BlinkTimer -> BlinkTimer;
	App.AMPacket -> ActiveMessageC;
	App.Packet -> ActiveMessageC;
	App.RadioControl -> ActiveMessageC;

}
