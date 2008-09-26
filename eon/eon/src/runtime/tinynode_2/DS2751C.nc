configuration DS2751C
{
  provides
  {
    interface DS2751;
  }

}

implementation
{
  components DS2751M;
  components BusyWaitMicroC as BusyWait0;
  
  components HplMsp430GeneralIOC as GeneralIOC; 
  components new Msp430GpioC() as OneWireBusC;
  
  DS2751M.OneWireBus -> OneWireBusC;
  OneWireBusC -> GeneralIOC.Port65; //(ADC5)
  

 DS2751 = DS2751M.DS2751;
 DS2751M.BusyWait0 -> BusyWait0;
 
 
}
