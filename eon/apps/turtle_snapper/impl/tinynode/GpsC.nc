

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
  components GpsM, MyGpsPacketC; 
  components NoLeds as Leds;

  StdControl = GpsM;
  GpsFix = GpsM;
  GpsM.SubControl -> MyGpsPacketC.GpsControl;
  GpsM.GpsReceive -> MyGpsPacketC.GpsReceive;
  GpsM.Leds -> Leds;
}
