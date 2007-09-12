/**
 * @author Jared Hill
 * @author David Moss
 */
 
interface BlazeConfig {

  /**
   * If changes have been made to the chip's configuration, those changes are
   * currently stored in the microcontroller.  This command will commit those 
   * changes to hardware.  It must be called for the changes to take effect.
   * @return SUCCESS if the changes will be committed.
   */
  command error_t commit();
  
  /**
   * The hardware has been loaded with the currently defined configuration
   */
  event void commitDone();
  
  
  /**
   * @param channel The channel ID to set the radio to
   */
  command void setChannel( uint16_t channel );

  /**
   * @return the radio's channel
   */
  command uint16_t getChannel();
  

  /**
   * Get the PAN (network) address for this node
   */
  async command uint16_t getPanAddr();
  
  /**
   * @param address the PAN (network) address for this node
   */
  command void setPanAddr( uint16_t address );

  
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
  
}
