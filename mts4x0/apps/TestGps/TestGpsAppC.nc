#include <I2C.h>
#include "gps.h"

configuration TestGpsAppC
{
}

implementation
{
	components MainC, LedsC as Leds;

	components SerialActiveMessageC;
	components new SerialAMSenderC(AM_GPS);
	components new SerialAMReceiverC(AM_GPS);

	components TestGpsC as App;

	App -> MainC.Boot;
	App.Leds -> Leds;

	components GPSC;
	App.GPS -> GPSC;
	App.GPSControl -> GPSC.GPSControl;
	App.GPSInit -> GPSC.GPSInit;

	App.SerialPacket -> SerialAMSenderC;
	App.SerialAMPacket -> SerialAMSenderC;
	App.SerialAMControl -> SerialActiveMessageC;
	App.SerialAMSend -> SerialAMSenderC;


  components PrintfC;
 	components new TimerMilliC() as FlushTimer;
	App.FlushTimer -> FlushTimer;
	App.PrintfControl -> PrintfC;
  App.PrintfFlush -> PrintfC;


}
