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
}

