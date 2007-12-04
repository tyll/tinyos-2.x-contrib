module HplSCCBReliableM
{
  provides {
    interface HplSCCB[uint8_t id];
  }

  uses interface HplSCCB as actualHplSCCB;
  uses interface Leds;
}
implementation
{
  // Number of times to retry an sccb communication
#define SCCB_MAX_RETRIES 5

  //----------------------------------------------------------------------------
  // StdControl - Simply pass through to Sccb StdControl
  //----------------------------------------------------------------------------
  command error_t HplSCCB.init[uint8_t id]() {
    return call actualHplSCCB.init();
  }


  //----------------------------------------------------------------------------
  // Sccb Interface Implementation
  //----------------------------------------------------------------------------
  command error_t HplSCCB.three_write[uint8_t id](uint8_t data, uint8_t address) {
    uint8_t sccb_data = 0x00;
    error_t sccb_result;
    uint8_t i;

    sccb_result = FAIL;
    for (i = 0; i < SCCB_MAX_RETRIES; i++) {
      // Write data and read it back
      call actualHplSCCB.three_write(data, address);
      call actualHplSCCB.two_write(address);
      call actualHplSCCB.read(&sccb_data);

      // Check data for integrity
      if (sccb_data == data) {
        sccb_result = SUCCESS;
        break;
      }
    }
    if (sccb_result == FAIL)
      call Leds.led0On();
    else if (data != 0)
      call Leds.led1On();
    // Inform the calling layer if we fail
    return sccb_result;
  }

  command error_t HplSCCB.two_write[uint8_t id](uint8_t address) {
    return call actualHplSCCB.two_write(address);
  }

  command error_t HplSCCB.read[uint8_t id](uint8_t* data) {
    return call actualHplSCCB.read(data);
  }
}

