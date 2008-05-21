interface Hcs08Interrupt
{
  async command void enable();
  async command void disable();
  async command void interruptOnRising();
  async command void interruptOnFalling();
  async command void interruptOnEdge();
  async command void interruptOnEdgeLevel();
  async event void fired();
}