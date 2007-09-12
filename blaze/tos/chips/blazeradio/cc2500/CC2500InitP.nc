 
/**
 * Manage the CC2500 SPI connection
 * @author Jared Hill
 * @author David Moss
 */
 
#include "Blaze.h"
#include "CC2500.h"
#include "AM.h"

module CC2500InitP {

  provides {
    interface Init as SoftwareInit;
    interface BlazeRegSettings;
    interface BlazeConfig;
  }

  uses {
    interface GeneralIO as Csn;
    interface GeneralIO as Power;
    interface GeneralIO as Gdo0_io;
    interface GeneralIO as Gdo2_io;
    interface ActiveMessageAddress;
    interface BlazeCommit;
    interface Leds;
  }
}

implementation {

  /** The personal area network address for this radio */
  uint16_t panAddress;
  
  /** TRUE if address recognition is enabled */
  bool addressRecognition;
  
  /** TRUE if PAN recognition is enabled */
  bool panRecognition;
  
  /** TRUE if we should auto-acknowledge packets if an ack is requested */
  bool autoAck;
  
  /** Default register values. Change the configuration by editing CC2500.h */
  uint8_t regValues[] = {
      CC2500_CONFIG_IOCFG2, 
      CC2500_CONFIG_IOCFG1, 
      CC2500_CONFIG_IOCFG0,
      CC2500_CONFIG_FIFOTHR, 
      CC2500_CONFIG_SYNC1, 
      CC2500_CONFIG_SYNC0, 
      CC2500_CONFIG_PKTLEN,
      CC2500_CONFIG_PKTCTRL1, 
      CC2500_CONFIG_PKTCTRL0, 
      CC2500_CONFIG_ADDR, 
      CC2500_CONFIG_CHANNR,
      CC2500_CONFIG_FSCTRL1, 
      CC2500_CONFIG_FSCTRL0, 
      CC2500_CONFIG_FREQ2, 
      CC2500_CONFIG_FREQ1,
      CC2500_CONFIG_FREQ0, 
      CC2500_CONFIG_MDMCFG4, 
      CC2500_CONFIG_MDMCFG3, 
      CC2500_CONFIG_MDMCFG2,
      CC2500_CONFIG_MDMCFG1, 
      CC2500_CONFIG_MDMCFG0, 
      CC2500_CONFIG_DEVIATN, 
      CC2500_CONFIG_MCSM2,
      CC2500_CONFIG_MCSM1, 
      CC2500_CONFIG_MCSM0, 
      CC2500_CONFIG_FOCCFG, 
      CC2500_CONFIG_BSCFG,
      CC2500_CONFIG_AGCTRL2, 
      CC2500_CONFIG_AGCTRL1, 
      CC2500_CONFIG_AGCTRL0, 
      CC2500_CONFIG_WOREVT1,
      CC2500_CONFIG_WOREVT0, 
      CC2500_CONFIG_WORCTRL, 
      CC2500_CONFIG_FREND1, 
      CC2500_CONFIG_FREND0,
      CC2500_CONFIG_FSCAL3, 
      CC2500_CONFIG_FSCAL2, 
      CC2500_CONFIG_FSCAL1, 
      CC2500_CONFIG_FSCAL0,
  };
  
  /***************** SoftwareInit Commands ****************/
  command error_t SoftwareInit.init() {
    // TODO the struct is an nxle. Do we put the MSB's in the ADDR reg?
    regValues[BLAZE_ADDR] = (call ActiveMessageAddress.amAddress()) >> 8;
    panAddress = TOS_AM_GROUP;
    
#if defined(NO_ACKNOWLEDGEMENTS)
    autoAck = FALSE;
#else
    autoAck = TRUE;
#endif

#if defined(NO_ADDRESS_RECOGNITION)
    addressRecognition = FALSE;
#else
    addressRecognition = TRUE;
#endif

#if defined(NO_PAN_RECOGNITION)
    panRecognition = FALSE;
#else
    panRecognition = TRUE;
#endif


    call Csn.makeOutput();
    call Power.makeOutput();
    
    // TODO Keep GDO's output low to avoid floaters when the chip is off
    // But when I made these outputs they locked up my code
    call Gdo0_io.makeInput();  // TODO platform init this to output
    call Gdo2_io.makeInput();  // TODO should be output perhaps
    call Gdo0_io.clr();
    call Gdo2_io.clr();
    
    return SUCCESS;
  }
  
  /***************** BlazeInit Commands ****************/
  command uint8_t *BlazeRegSettings.getDefaultRegisters() {
    return regValues;
  }

  /***************** BlazeConfig Commands ****************/
  
  /**
   * If changes have been made to the chip's configuration, those changes are
   * currently stored in the microcontroller.  This command will commit those 
   * changes to hardware.  It must be called for the changes to take effect.
   * @return SUCCESS if the changes will be committed.
   */
  command error_t BlazeConfig.commit() {
    call BlazeCommit.commit();
    return SUCCESS;
  }
  
  /**
   * @param channel The channel ID to set the radio to
   */
  command void BlazeConfig.setChannel( uint16_t channel ) {
    // TODO
  }

  /**
   * @return the radio's channel
   */
  command uint16_t BlazeConfig.getChannel() {
    // TODO
    return regValues[BLAZE_CHANNR];
  }
  
  /**
   * Get the PAN (network) address for this node
   */
  async command uint16_t BlazeConfig.getPanAddr() {
    uint16_t atomicPan;
    atomic atomicPan = panAddress;
    return atomicPan;
  }
  
  /**
   * @param address the PAN (network) address for this node
   */
  command void BlazeConfig.setPanAddr( uint16_t address ) {
    atomic panAddress = address;
  }
  
  /**
   * @param on TRUE to turn address recognition on, FALSE to turn it off
   */
  command void BlazeConfig.setAddressRecognition(bool on) {
    atomic addressRecognition = on;
    // TODO set the address recognition in hardware
  }
  
  /**
   * @return TRUE if address recognition is enabled
   */
  async command bool BlazeConfig.isAddressRecognitionEnabled() {
    return addressRecognition;
  }
  
  /** 
   * @param on TRUE if we should only accept packets from other nodes in our PAN
   */
  command void BlazeConfig.setPanRecognition(bool on) {
    atomic panRecognition = on;
  }
  
  /**
   * @return TRUE if PAN address recognition is enabled
   */
  async command bool BlazeConfig.isPanRecognitionEnabled() {
    bool atomicPanEnabled;
    atomic atomicPanEnabled = panRecognition;
    return atomicPanEnabled;
  }
  
  /**
   * Sync must be called for acknowledgement changes to take effect
   * @param enableAutoAck TRUE to enable auto acknowledgements
   * @param hwAutoAck TRUE to default to hardware auto acks, FALSE to
   *     default to software auto acknowledgements
   */
  command void BlazeConfig.setAutoAck(bool enableAutoAck) {
    atomic autoAck = enableAutoAck;  
  }
  
  /**
   * @return TRUE if auto acks are enabled
   */
  async command bool BlazeConfig.isAutoAckEnabled() {
    bool atomicAckEnabled;
    atomic atomicAckEnabled = autoAck;
    return atomicAckEnabled;
  }
  
  /***************** ActiveMessageAddress Events ****************/
  async event void ActiveMessageAddress.changed() {   
    regValues[BLAZE_ADDR] = (call ActiveMessageAddress.amAddress()) >> 8;
  }
  
  /***************** BlazeCommit Events ****************/
  event void BlazeCommit.commitDone() {
    signal BlazeConfig.commitDone();
  }
  
  /***************** Defaults ****************/
  default event void BlazeConfig.commitDone() {}
}
