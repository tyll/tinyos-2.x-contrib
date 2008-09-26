configuration DS2770C
{
  provides
  {
    interface DS2770;
  }

}

implementation
{
  components DS2770M;
  components new TimerMilliC() as Timer0;
  components BusyWaitMicroC as BusyWait0;
  
  components HplMsp430GeneralIOC as GeneralIOC; 
  components new Msp430GpioC() as OneWireBusC;
  
  DS2770M.OneWireBus -> OneWireBusC;
  OneWireBusC -> GeneralIOC.Port64; //(ADC4)
    
 DS2770 = DS2770M.DS2770;
 DS2770M.Timer0 -> Timer0;
 DS2770M.BusyWait0 -> BusyWait0;
 
 
}
