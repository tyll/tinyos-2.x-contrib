#include "LplTest.h"

configuration LplTestC {

} implementation {

	components 
		LplTestP as App,
		MainC,
		LedsC,
		ActiveMessageC,
		//new TimerMilliC() as Timer,
		new RandomOffsetTimerMilliC() as Timer,
		new AMSenderC(AM_LPLTEST_MSG) as Sender,
		new AMReceiverC(AM_LPLTEST_MSG) as Receiver;

	App.Boot -> MainC;
	App.Leds -> LedsC;

	App.Timer -> Timer;

	App.RadioControl -> ActiveMessageC;
	App.Send -> Sender;
	App.Receive -> Receiver;
	App.Acks -> ActiveMessageC;
	App.AMPacket -> ActiveMessageC;

	components QuickTimeC;

}
