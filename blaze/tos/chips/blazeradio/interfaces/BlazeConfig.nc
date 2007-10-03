/**
 * @author Jared Hill
 * @author David Moss
 */
 
interface BlazeConfig {

  /**
   * If changes have been made to the chip's configuration, those changes are
   * currently stored in the microcontroller.  This command will commit those 
   * changes to hardware.  It must be called before any changes made by calling
   * "set" functions within the BlazeConfig interface will take effect.
   * @return SUCCESS if the changes will be committed.
   */
  command error_t commit();
  
  /**
   * The hardware has been loaded with the currently defined configuration
   */
  event void commitDone();
  
  
  /**
   * @param on TRUE to turn address recognition on, FALSE to turn it off
   */
  command void setAddressRecognition(bool on);
  
  /**
   * @return TRUE if address recognition is enabled
   */
  async command bool isAddressRecognitionEnabled();
  
  /** 
   * @param on TRUE if we should only accept packets from other nodes in our PAN
   */
  command void setPanRecognition(bool on);
  
  /**
   * @return TRUE if PAN address recognition is enabled
   */
  async command bool isPanRecognitionEnabled();
  
  /**
   * Sync must be called for acknowledgement changes to take effect
   * @param enableAutoAck TRUE to enable auto acknowledgements
   * @param hwAutoAck TRUE to default to hardware auto acks, FALSE to
   *     default to software auto acknowledgements
   */
  command void setAutoAck(bool enableAutoAck);
  
  /**
   * @return TRUE if auto acks are enabled
   */
  async command bool isAutoAckEnabled();
  
  
  /** 
   * This command is used to set the (approximate) frequency the radio.
   * It uses the assumed base frequency, the assumed channel width and the changes the 
   * value in the channel register.  
   * @param freqKhz - the desired frequency in Khz to set the radio to
   * @reutrn - FAIL if desired frequency is not in range, else SUCCESS
   */
  command error_t setFrequencyKhz( uint32_t freqKhz );
  
  /** 
   * This command is used to get the current (approximate) frequency the radio is set to in KHz.
   * It uses the assumed base frequency, the assumed channel width and the current value in the 
   * channel register to calculate this.  
   * @return approx. frequency in KHz
   */
  command uint32_t getFrequencyKhz();
  
  /** 
   * This command sets the value of the channel register on the radio
   * @param chan - the value of the channel
   */
  command void setChannel( uint8_t chan );
  
  /** 
   * This command returns the value of the channel register on the radio
   * @return the value of the channel register
   */
  command uint8_t getChannel();
  
}
