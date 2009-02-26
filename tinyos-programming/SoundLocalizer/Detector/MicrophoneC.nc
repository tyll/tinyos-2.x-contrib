module MicrophoneC
{
  provides interface SplitControl;
  uses {
    interface Timer<TMilli>;
    interface GeneralIO as MicPower;  // Power control pin
    interface GeneralIO as MicMuxSel; // Microphone / tone detector selection pin
    interface I2CPacket<TI2CBasicAddr>;
    interface Resource as I2CResource;
  }
}
implementation
{
  enum {
    MIC_POT_ADDR = 0x5A,
    MIC_POT_SUBADDR = 0,
    MIC_GAIN = 64
  };

  uint8_t gainPacket[2];

  task void gainOk(), gainFail(), stopDone();

  command error_t SplitControl.start() {
    // Powerup the microphone
    call MicPower.makeOutput();
    call MicPower.set();
    // Select raw microphone output
    call MicMuxSel.makeOutput();    
    call MicMuxSel.set(); 

    // Request the I2C bus to adjust gain
    call I2CResource.request();

    return SUCCESS;
  }

  event void I2CResource.granted() {
    error_t ok;

    // Send gain-control packet over I2C bus
    gainPacket[0] = MIC_POT_SUBADDR;
    gainPacket[1] = MIC_GAIN;
    ok = call I2CPacket.write(I2C_START | I2C_STOP, MIC_POT_ADDR,
			      sizeof gainPacket, gainPacket);
    if (ok != SUCCESS)
      signal SplitControl.startDone(FAIL);
  }

  async event void I2CPacket.writeDone(error_t error, uint16_t addr,
				       uint8_t length, uint8_t* data) {
    // Release I2C bus and wait for microphone to warmup (report failure
    // in case of error)
    call I2CResource.release();
    if (error == SUCCESS)
      post gainOk();
    else
      post gainFail();
  }

  task void gainOk() {
    call Timer.startOneShot(MICROPHONE_WARMUP); 
  }

  task void gainFail() {
    signal SplitControl.startDone(FAIL);
  }

  event void Timer.fired() {
    // Microphone warmed up. Signal completion of startup.
    signal SplitControl.startDone(SUCCESS);
  }

  command error_t SplitControl.stop() {
    // Power off microphone
    call MicPower.clr();
    call MicPower.makeInput();

    // And let our caller know we're done - post a task as one should not
    // signal events directly from commands
    post stopDone();
    return SUCCESS;
  }

  task void stopDone() {
    signal SplitControl.stopDone(SUCCESS);
  }

  async event void I2CPacket.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data) {
  }
}
