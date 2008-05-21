configuration Hcs08InterruptC
{
  provides interface Hcs08Interrupt;
}
implementation
{
  components HplHcs08InterruptC, Hcs08InterruptP;
  
  HplHcs08InterruptC.HplHcs08Interrupt <- Hcs08InterruptP;
  
  Hcs08Interrupt = Hcs08InterruptP;
}