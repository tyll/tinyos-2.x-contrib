#include "Ieee154Test.h"

configuration Ieee154TestC {

} implementation {

	components 
		MainC,
		LedsC,
		new TimerMilliC(),
#ifdef USE_AM
		ActiveMessageC as MessageC,
		new DirectAMSenderC(13) as Sender,
		new AMReceiverC(13) as Receiver,
#else
		Ieee154MessageC as MessageC,
		new DirectIeee154SenderC() as Sender,
#endif
		CC2420RadioC,
		Ieee154TestP as App;
		
	App.Boot -> MainC.Boot;
	App.Leds -> LedsC;
	App.Timer -> TimerMilliC;

	App.RadioControl -> MessageC;

	App.Send -> Sender;
	App.Packet -> Sender;
	App.PacketLink -> CC2420RadioC;

#ifdef USE_AM
	App.Receive -> Receiver;
#else
	App.Receive -> MessageC;
#endif

}
