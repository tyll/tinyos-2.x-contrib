

configuration GpsC 
{

  provides
    {
      interface StdControl;
      interface GpsFix;
    }
}

implementation
{
  components GpsM, MyGpsPacketC, 
#ifdef	_GPS_DEBUG_	
	RadioComm,
#endif

#ifdef TEST_GPSC
  LedsC as Leds;
#else
	//NoLeds as Leds;
	LedsC as Leds;
#endif


  StdControl = GpsM;
  GpsFix = GpsM;
  GpsM.SubControl -> MyGpsPacketC.GpsControl;
  //GpsM.SubControl -> Comm.Control;
  GpsM.GpsReceive -> MyGpsPacketC.GpsReceive;
  GpsM.Leds -> Leds;
  //GpsM.SendMsg -> Comm.Send[1];
}
