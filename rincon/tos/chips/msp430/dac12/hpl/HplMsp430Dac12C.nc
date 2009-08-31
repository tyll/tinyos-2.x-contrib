
/**
 * DAC12 hardware presentation layer
 * @author David Moss
 */
configuration HplMsp430Dac12C {
  provides {
    interface HplMsp430Dac12 as HplMsp430Dac12_0;
    interface HplMsp430Dac12 as HplMsp430Dac12_1;
  }
}

implementation {

  components new HplMsp430Dac12P(DAC12_0CTL_, DAC12_0DAT_) as HplMsp430Dac12_0P;
  components new HplMsp430Dac12P(DAC12_1CTL_, DAC12_1DAT_) as HplMsp430Dac12_1P;
  
  HplMsp430Dac12_0 = HplMsp430Dac12_0P;
  HplMsp430Dac12_1 = HplMsp430Dac12_1P;
  
}
