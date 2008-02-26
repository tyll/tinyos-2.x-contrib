
module DummyRadioStatusP {
  provides {
    interface RadioStatus;
  }
}

implementation {

  async command blaze_status_t RadioStatus.getRadioStatus() {
    return BLAZE_S_RX;
  }
  
}

