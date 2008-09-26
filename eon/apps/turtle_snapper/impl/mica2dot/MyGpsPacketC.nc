

configuration MyGpsPacketC {
  provides {
    interface StdControl as GpsControl;
    interface GPSReceiveMsg as GpsReceive;
  }
}
implementation {
  components MyGpsPacket, HPLUART0M, NoLeds as Leds;
 
  GpsControl = MyGpsPacket;
  GpsReceive = MyGpsPacket;

  MyGpsPacket.UART -> HPLUART0M.UART;
  MyGpsPacket.Leds -> Leds;
  
}
