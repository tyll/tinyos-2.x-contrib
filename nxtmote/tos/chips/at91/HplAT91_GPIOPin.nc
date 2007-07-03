/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
interface HplAT91_GPIOPin 
{
  
  async command void setPIOPER();
  async command void setPIOOER();
  async command void setPIOCODR();
  async command void setPIOSODR();
  async command bool getPIOPDSR();
  
  async command void setPIOASR();
  async command void setPIOPDR();
  async command void setPIOMDER();
  async command void setPIOPPUDR();
  
  async event void interruptGPIOPin();
}

