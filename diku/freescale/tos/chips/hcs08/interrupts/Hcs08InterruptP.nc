module Hcs08InterruptP
{
  uses interface HplHcs08Interrupt;
  
  provides interface Hcs08Interrupt;
}
implementation
{
  async command void Hcs08Interrupt.enable()
  {
    call HplHcs08Interrupt.enable();
    call HplHcs08Interrupt.enableInterrupt();
  }
  
  async command void Hcs08Interrupt.disable()
  {
    call HplHcs08Interrupt.disable();
    call HplHcs08Interrupt.disableInterrupt();
  }
  

  async command void Hcs08Interrupt.interruptOnRising() { call HplHcs08Interrupt.interruptOnRising(); }
  async command void Hcs08Interrupt.interruptOnFalling() { call HplHcs08Interrupt.interruptOnFalling(); }
  async command void Hcs08Interrupt.interruptOnEdge() { call HplHcs08Interrupt.interruptOnEdge(); }
  async command void Hcs08Interrupt.interruptOnEdgeLevel() { call HplHcs08Interrupt.interruptOnEdgeLevel(); }
  
  async event void HplHcs08Interrupt.fired() { signal Hcs08Interrupt.fired(); }
}