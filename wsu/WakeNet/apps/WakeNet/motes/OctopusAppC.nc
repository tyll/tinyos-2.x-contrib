#include <Octopus.h>
//#include <NetProg.h>
//#include <NetProg_platform.h>
//#include <DelugeMsgs.h>
//#include <DelugeMetadata.h>
//#include <TOSBoot.h>
//#include <TOSBoot_platform.h>
//#include <InternalFlash.h>

configuration OctopusAppC { }
implementation {
	components MainC, OctopusC, LedsC, RandomC;
	components new OctopusSensorC() as Sensor;
	OctopusC.Boot -> MainC;

	components new TimerMilliC() as accTimer;
	OctopusC.AccelerometerTimer -> accTimer;
	components new TimerMilliC() as lightTimer;
	OctopusC.LightTimer -> lightTimer;
	components new TimerMilliC() as adcTimer;
	OctopusC.AdcTimer -> adcTimer;
	components new TimerMilliC() as iCountTimer; 
	OctopusC.iCountTimer-> iCountTimer;
	components new TimerMilliC() as energyReportTimer;
	OctopusC.EnergyReportTimer -> energyReportTimer;

	OctopusC.WakeupADC->Sensor.WakeupADC;
	OctopusC.WakeupLight->Sensor.WakeupLight;
	OctopusC.WakeupADCRead -> Sensor.WakeupADCRead;
	OctopusC.NormalADC->Sensor.NormalADC;
	OctopusC.NormalADCRead -> Sensor.NormalADCRead;
	OctopusC.LightRead-> Sensor.LightRead;
	OctopusC.BatteryRead -> Sensor.BatteryRead;

	OctopusC.HumidityRead-> Sensor.HumidityRead;
	OctopusC.TemperatureRead-> Sensor.TemperatureRead;

	OctopusC.AccelerometerRead -> Sensor.AccelerometerRead;
	OctopusC.Accelerometer->Sensor.Accelerometer;

	OctopusC.EnergyMeter->Sensor.EnergyMeter;

	OctopusC.Leds -> LedsC;
	OctopusC.Random -> RandomC;

	components McuSleepC;
	OctopusC.McuSleep -> McuSleepC;
	components UserButtonC;
	OctopusC.Notify -> UserButtonC;

	// Serial communication
	components SerialActiveMessageC;
	components new SerialAMReceiverC(AM_OCTOPUS_SENT_MSG) as SerialRequestReceiver;
	components new SerialAMSenderC(AM_OCTOPUS_COLLECTED_MSG) as SerialCollectSender;
	OctopusC.SerialControl -> SerialActiveMessageC;
	OctopusC.SerialSend -> SerialCollectSender.AMSend;
	OctopusC.SerialReceive -> SerialRequestReceiver;

	//to get RSSI and LQI
	components BlazePacketC;
	OctopusC.BlazePacket -> BlazePacketC;
	// General Radio Communication
	components ActiveMessageC;
	OctopusC.RadioControl -> ActiveMessageC;
#if defined(PLATFORM_MICA2)
	components CC1000CsmaRadioC as Radio;
#elif defined(PLATFORM_MICAZ) || defined(PLATFORM_AQUISGRAIN)|| defined(PLATFORM_TELOSA) || defined(PLATFORM_TELOSB) || defined (PLATFORM_TELOSW)
	//components CC2420ActiveMessageC as Radio;

	//components ActiveMessageC as Radio;
#else
#error "The OctopusGUI application is only supported for mica2, micaz, telos and aquisgrain nodes"
#endif
	//OctopusC.LowPowerListening -> Radio;
	// Collected Radio Communication
#if defined(COLLECTION_PROTOCOL)
	components CtpP as CollectP;
	components CollectionC as Collector;  				// Collection layer
	components new CollectionSenderC(AM_OCTOPUS_COLLECTED_MSG); 	// Sends multihop RF
	OctopusC.CollectSend -> CollectionSenderC;			// used by a node which wants to send data to the root
	OctopusC.Snoop -> Collector.Snoop[AM_OCTOPUS_COLLECTED_MSG];
	OctopusC.CollectReceive -> Collector.Receive[AM_OCTOPUS_COLLECTED_MSG];
	OctopusC.RootControl -> Collector;
	//	OctopusC.RoutingControl -> Collector;
	OctopusC.CollectControl -> Collector;
#elif defined(DUMMY_COLLECT_PROTOCOL)
	components DummyP as CollectP; // to complete
	components CollectionC as Collector;  				// Collection layer
	components new CollectionSenderC(AM_OCTOPUS_COLLECTED_MSG); 	// Sends multihop RF
	OctopusC.CollectSend -> CollectionSenderC;			// used by a node which wants to send data to the root
	OctopusC.Snoop -> Collector.Snoop[AM_OCTOPUS_COLLECTED_MSG];
	OctopusC.CollectReceive -> Collector.Receive[AM_OCTOPUS_COLLECTED_MSG];
	OctopusC.RootControl -> Collector;
	OctopusC.CollectControl -> Collector;
#else
#error "A protocol needs to be selected to collect data"
#endif
	OctopusC.CollectInfo -> CollectP;

	components new QueueC(octopus_collected_msg_t, MAX_QUEUE) as outgoingQueue;
	OctopusC.OutgoingQueue -> outgoingQueue;
	components new QueueC(octopus_collected_msg_t, MAX_QUEUE) as upstreamQueue;
	OctopusC.UpstreamQueue -> upstreamQueue;

	components new TimerMilliC() as sendTimer;
	components new TimerMilliC() as upTimer; 
	OctopusC.SendTimer -> sendTimer;
	OctopusC.UpTimer -> upTimer;
	//	OctopusC.LinkEstimator -> Ctp; // useless ??

	components BlazeSpiC;
	OctopusC.RadioStatus -> BlazeSpiC.RadioStatus;
	OctopusC.SPWD -> BlazeSpiC.SPWD;
	OctopusC.SIDLE-> BlazeSpiC.SIDLE;
	OctopusC.SXOFF-> BlazeSpiC.SXOFF;
	OctopusC.MDMCFG4 -> BlazeSpiC.MDMCFG4;
	OctopusC.MDMCFG3 -> BlazeSpiC.MDMCFG3;

	components HplRadioSpiC;
	OctopusC.SpiByte -> HplRadioSpiC.SpiByte;

	/*
	components BlazeCentralWiringC;
	OctopusC.RxInterrupt -> BlazeCentralWiringC.Gdo0_int;
	*/



}
