module TestGpsParserC
{
	uses
	{
		interface Boot;
		interface Leds;

		// GPS Parser
		interface GpsParser as GPSParser;
		interface Init as GPSParserInit;
		interface SplitControl as GPSParserControl;

		// Serial
		interface Packet as SerialPacket;
		interface AMPacket as SerialAMPacket;
		interface AMSend as SerialAMSend;
		interface SplitControl as SerialAMControl;
#ifdef PRINTFDEBUG
    interface Timer<TMilli> as FlushTimer;
		interface SplitControl as PrintfControl;
    interface PrintfFlush;
#endif
	}
}

implementation
{
	message_t serialPkt;
	bool serialBusy = FALSE;

	event void Boot.booted()
	{
		call Leds.led0On();
		call SerialAMControl.start();
#ifdef PRINTFDEBUG
    call FlushTimer.startPeriodic(500);
#endif
	}


#ifdef PRINTFDEBUG
	event void FlushTimer.fired(){
    call PrintfFlush.flush();
	}

  event void PrintfControl.startDone(error_t error){}
  event void PrintfControl.stopDone(error_t error){}
  event void PrintfFlush.flushDone(error_t error){}

#endif


	event GpsGGAMsg* GPSParser.GGAReceived(GpsGGAMsg *msg)
	{
		if(!serialBusy)
		{
			GpsGGAMsg *pkt = (GpsGGAMsg*)(call SerialPacket.getPayload(&serialPkt, sizeof(GpsGGAMsg)));

			call Leds.led2Toggle();

			pkt->time.h = msg->time.h;
			pkt->time.m = msg->time.m;
			pkt->time.s = msg->time.s;

			pkt->latitude.deg = msg->latitude.deg;
			pkt->latitude.min = msg->latitude.min;
			pkt->latitude.mmin = msg->latitude.mmin;

			pkt->longitude.deg = msg->longitude.deg;
			pkt->longitude.min = msg->longitude.min;
			pkt->longitude.mmin = msg->longitude.mmin;

			pkt->mode = msg->mode;
			pkt->nb_sat = msg->nb_sat;
			pkt->altitude = msg->altitude;

			if(call SerialAMSend.send(AM_BROADCAST_ADDR, &serialPkt, sizeof(GpsGGAMsg)) == SUCCESS)
			{
				serialBusy = TRUE;
			}
		}
		return msg;
	}

	event GpsVTGMsg* GPSParser.VTGReceived(GpsVTGMsg *msg)
	{
		return msg;
	}

	event void SerialAMControl.startDone(error_t err)
	{
		if (err == SUCCESS)
		{
			call GPSParserInit.init();
			call GPSParserControl.start();
		}
		else
		{
			call SerialAMControl.start();
		}
	}

	event void SerialAMSend.sendDone(message_t* msg, error_t err)
	{
		if (&serialPkt == msg)
		{
			serialBusy = FALSE;
		}
	}

	event void GPSParserControl.startDone(error_t error)
	{
		call Leds.led1On();
	}

	// Unused events
	event void GPSParserControl.stopDone(error_t error) {}
	event void SerialAMControl.stopDone(error_t error) {}
}
