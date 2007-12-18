configuration HplAT91I2CLSC {
  provides {
    interface HplAT91I2CLS;
  }
}
implementation {
  components HplAT91I2CLSP;
  
  HplAT91I2CLS = HplAT91I2CLSP.I2CLS;
}
