configuration HalAT91I2CLSC {
  provides {
    interface HalAT91I2CLS;
  }
  
  uses {
    interface Boot;
  }
}
implementation {

  components HalAT91I2CLSP, HplAT91I2CLSC;
  
  HalAT91I2CLS = HalAT91I2CLSP;
  
  Boot = HalAT91I2CLSP;

  HalAT91I2CLSP.HplAT91I2CLS -> HplAT91I2CLSC;
}
