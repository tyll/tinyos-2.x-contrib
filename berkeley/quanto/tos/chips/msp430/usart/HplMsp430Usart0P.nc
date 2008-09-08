configuration HplMsp430Usart0P {
  provides interface HplMsp430Usart as Usart;
  provides interface HplMsp430UsartInterrupts as Interrupts;
  provides interface HplMsp430I2CInterrupts as I2CInterrupts;
  
  uses interface HplMsp430I2C as HplI2C;
  uses interface HplMsp430GeneralIO as SIMO;
  uses interface HplMsp430GeneralIO as SOMI;
  uses interface HplMsp430GeneralIO as UCLK;
  uses interface HplMsp430GeneralIO as URXD;
  uses interface HplMsp430GeneralIO as UTXD;
}

implementation
{
  components HplMsp430Usart0ImplP, ResourceContextsC;
  HplMsp430Usart0ImplP.CPUContext -> ResourceContextsC.CPUContext;

  Usart = HplMsp430Usart0ImplP;
  Interrupts = HplMsp430Usart0ImplP;
  I2CInterrupts = HplMsp430Usart0ImplP;
  
  HplI2C = HplMsp430Usart0ImplP;
  SIMO = HplMsp430Usart0ImplP.SIMO;
  SOMI = HplMsp430Usart0ImplP.SOMI;
  UCLK = HplMsp430Usart0ImplP.UCLK;
  URXD = HplMsp430Usart0ImplP.URXD;
  UTXD = HplMsp430Usart0ImplP.UTXD;

}
