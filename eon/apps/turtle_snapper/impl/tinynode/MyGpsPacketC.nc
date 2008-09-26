

configuration MyGpsPacketC {
  provides {
    interface StdControl as GpsControl;
    interface GPSReceiveMsg as GpsReceive;
  }
}
implementation {
  components MyGpsPacket, HPLUARTC;
 
  GpsControl = MyGpsPacket;
  GpsReceive = MyGpsPacket;

  MyGpsPacket.UART -> HPLUARTC.UART;
  
}
