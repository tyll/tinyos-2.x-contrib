/**
 * @author Jared Hill
 * @author David Moss
 */
 
interface BlazeConfig {

  /**
   * @param freqMHz the frequency to set the radio to in MHz.
   */
  command void setFreq( uint16_t freqMHz );

  /**
   * @return the frequency of the radio in MHz
   */
  command uint8_t getFreq();
  
}
