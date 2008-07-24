// AC Mote and Energy Meter using ADE7753
// @ Fred Jiang <fxjiang@eecs.berkeley.edu>

configuration ACMeterAppC {}

implementation {
	components MainC, ACMeterApp, ACMeterC, LedsC;
	components new AMSenderC(AM_ENERGYMSG) as AMSenderC;
	components new AMReceiverC(AM_SWITCHMSG) as AMReceiverC;
	components ActiveMessageC as ActiveMessageC;

	ACMeterApp.Boot -> MainC.Boot;
	ACMeterApp.AMSend -> AMSenderC;
	ACMeterApp.Packet -> AMSenderC;
	ACMeterApp.AMReceive -> AMReceiverC;
	ACMeterApp.Leds -> LedsC;
	ACMeterApp.MeterControl -> ACMeterC.SplitControl;
	ACMeterApp.AMControl -> ActiveMessageC;
	ACMeterApp.ACMeter -> ACMeterC.ACMeter;
}
