configuration HplMsp430Usart1P {
  provides interface AsyncStdControl;
  provides interface HplMsp430Usart as Usart;
  provides interface HplMsp430UsartInterrupts as Interrupts;

  uses interface HplMsp430GeneralIO as SIMO;
  uses interface HplMsp430GeneralIO as SOMI;
  uses interface HplMsp430GeneralIO as UCLK;
  uses interface HplMsp430GeneralIO as URXD;
  uses interface HplMsp430GeneralIO as UTXD;
}

implementation
{
    components HplMsp430Usart1ImplP, ResourceContextsC;
    HplMsp430Usart1ImplP.CPUContext -> ResourceContextsC.CPUContext;

  AsyncStdControl = HplMsp430Usart1ImplP;
  Usart = HplMsp430Usart1ImplP;
  Interrupts = HplMsp430Usart1ImplP;

  SIMO = HplMsp430Usart1ImplP.SIMO;
  SOMI = HplMsp430Usart1ImplP.SOMI;
  UCLK = HplMsp430Usart1ImplP.UCLK;
  URXD = HplMsp430Usart1ImplP.URXD;
  UTXD = HplMsp430Usart1ImplP.UTXD;

}
