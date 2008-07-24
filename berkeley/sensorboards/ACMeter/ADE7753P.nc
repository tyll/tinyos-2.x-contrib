#include "ADE7753.h"

module ADE7753P
{
	provides interface Init;
	provides interface SplitControl;
	provides interface ADE7753;

	uses interface Resource;

	uses interface SpiPacket;
//  uses interface GpioInterrupt as InterruptAlert;
	uses interface HplMsp430GeneralIO as SPIFRM;
	uses interface Leds;
}

implementation {

  enum {
    STATE_IDLE,
    STATE_STARTING,
    STATE_STOPPING,
    STATE_STOPPED,
    STATE_GETREG,
    STATE_SETREG,
    STATE_ERROR
  };

  uint8_t mSPIRxBuf[4],mSPITxBuf[4];
  uint8_t mSPITxLen;
  uint8_t mSPIRxLen;
  
  uint8_t mState;
  bool misInited = FALSE;
  norace error_t mSSError;


  /*
  task void StartDone() {
    atomic mState = STATE_IDLE;
    signal SplitControl.startDone(SUCCESS);
    return;
  }

  task void StopDone() {
    signal SplitControl.stopDone(mSSError);
    return;
  }
  */
  
  command error_t Init.init() {
    atomic {
      if (!misInited) {
	misInited = TRUE;
	mState = STATE_STOPPED;
      }
      // Control CS pin manually
      call SPIFRM.makeOutput();
      call SPIFRM.set();
    }
    return SUCCESS;
  }

  command error_t SplitControl.start() {
    error_t error = SUCCESS;
    atomic {
      if (mState == STATE_STOPPED) { 
		  // mState = STATE_STARTING;
		  mState = STATE_IDLE;
      }
      else {
	error = EBUSY;
      }
    }
    if (error) 
      return error;

	/* set initialization register values here
    mSPITxBuf[0] = LIS3L02DQ_CTRL_REG1;
    mSPITxBuf[1] = 0;
    mSPITxBuf[1] = (LIS3L01DQ_CTRL_REG1_PD(1) | LIS3L01DQ_CTRL_REG1_XEN | LIS3L01DQ_CTRL_REG1_YEN | LIS3L01DQ_CTRL_REG1_ZEN);
    call SPIFRM.clr(); // CS LOW
    error = call SpiPacket.send(mSPITxBuf,mSPIRxBuf,2);
	*/
    atomic mState = STATE_IDLE;
	call SPIFRM.set();

	signal SplitControl.startDone(SUCCESS);
    return error;
  }

  command error_t SplitControl.stop() {
    error_t error = SUCCESS;

    atomic {
      if (mState == STATE_IDLE) {
		  // mState = STATE_STOPPING;
		  mState = STATE_STOPPED;
      }
      else { 
		  error = EBUSY;
      }
    }
    if (error)
		return error;

	/* stopping conditions
    mSPITxBuf[0] = LIS3L02DQ_CTRL_REG1;
    mSPITxBuf[1] = 0;
    mSPITxBuf[1] = (LIS3L01DQ_CTRL_REG1_PD(0));
    call SPIFRM.clr(); // CS LOW
    error = call SpiPacket.send(mSPITxBuf,mSPIRxBuf,2);
	*/
	mState = STATE_STOPPED;	
	call SPIFRM.set();
	
	signal SplitControl.stopDone(mSSError);	
    return error;
  }


  event void Resource.granted() {
	  switch(mState) {
	  case STATE_GETREG:
		  // call Leds.led0Toggle();
		  call SPIFRM.clr(); // CS LOW
		  if (call SpiPacket.send(mSPITxBuf,mSPIRxBuf,mSPIRxLen) == FAIL)
			  call Resource.request();
		  break;
	  case STATE_SETREG:
//		  call Leds.led0On();
		  call SPIFRM.clr(); // CS LOW
		  if (call SpiPacket.send(mSPITxBuf,mSPIRxBuf,mSPITxLen) == FAIL)
			  call Resource.request();
		  break;
	  default:
		  call Resource.release();
	  }
  }
  
  // Here I'm forcing 24 bit receive data
  command error_t ADE7753.getReg(uint8_t regAddr, uint8_t len) {
    error_t error = SUCCESS;
	
    //if((regAddr < 0x16) || (regAddr > 0x2F)) {
	if(regAddr > 0x3F) {
      error = EINVAL;
      return error;
    }

    mSPITxBuf[0] = regAddr;
    mSPITxBuf[1] = 0;
    mSPITxBuf[2] = 0;
    mSPITxBuf[3] = 0;
	
	mSPIRxBuf[0] = 0;
    mSPIRxBuf[1] = 0;
	mSPIRxBuf[2] = 0;
	mSPIRxBuf[3] = 0;

	mSPIRxLen = len;
	
	atomic mState = STATE_GETREG;

	call Resource.request();

	/*
    call SPIFRM.clr(); // CS LOW

	error = call SpiPacket.send(mSPITxBuf,mSPIRxBuf,4);
	// call Leds.led0On();

	*/
	
    return error;
  }


  // here I'm forcing 24bit of val during a write
  command error_t ADE7753.setReg(uint8_t regAddr, uint8_t len, uint32_t val) {
  // here I'm forcing 8bit of val during a write
  // command error_t ADE7753.setReg(uint8_t regAddr, uint8_t val) {
    error_t error = SUCCESS;

    // if((regAddr < 0x16) || (regAddr > 0x2F)) {
	if(regAddr > 0x3F) {
		 error = EINVAL;
      return error;
    }

	// call Leds.led0On();
	
    mSPITxBuf[0] = regAddr | (1 << 7); // set the WRITE bit

	switch (len) {
	case 2:
		mSPITxBuf[1] = (uint8_t) val;
		break;
	case 3:
		mSPITxBuf[1] = (uint8_t) (val>>8);
		mSPITxBuf[2] = (uint8_t) val;
		break;
	case 4:
		mSPITxBuf[1] = (uint8_t) (val>>16);
		mSPITxBuf[2] = (uint8_t) (val>>8);
		mSPITxBuf[3] = (uint8_t) val;
		break;
	}

	mSPITxLen = len;

//	call Leds.led0On();

	mState = STATE_SETREG;
	
	call Resource.request();
	/*
	call SPIFRM.clr(); // CS LOW
	error = call SpiPacket.send(mSPITxBuf,mSPIRxBuf,2);	
	*/
    return error;
  }

  async event void SpiPacket.sendDone(uint8_t* txBuf, uint8_t* rxBuf, uint16_t len, error_t spi_error ) {

	  uint32_t val;
	  error_t error = spi_error;

//	  if (spi_error == FAIL)
//		  call Leds.led0Toggle();
//	  call Leds.led1On();
	  
	call SPIFRM.set(); // CS HIGH
	
    switch (mState) {
    case STATE_GETREG:
		mState = STATE_IDLE;
		//call Leds.led0Toggle();
		// repack

//		if (mSPIRxLen != len)
//			call Leds.led0Toggle();
		
		switch (len) {
		case 2:
			val = rxBuf[1];
			break;
		case 3:
			val = ((uint32_t)rxBuf[1])<<8 | rxBuf[2];
			break;
		case 4:
			val = ((uint32_t)rxBuf[1])<<16 | ((uint32_t)rxBuf[2])<<8 | rxBuf[3];
			break;
		default:
			val = 0xF0F0F0F0;
			break;
		}
		signal ADE7753.getRegDone(error, (txBuf[0] & 0x7F), val, len);
		// signal ADE7753.getRegDone(error, (txBuf[0] & 0x7F) , *(uint32_t*)rxBuf & 0xFFFFFF);
		break;
    case STATE_SETREG:

//		call Leds.led1Toggle();
		
		mState = STATE_IDLE;

//		if (mSPITxLen != len)
//			call Leds.led1Toggle();


// repack
		switch (len) {
		case 2:
			val = txBuf[1];
			break;
		case 3:
			val = ((uint32_t)txBuf[1])<<8 | txBuf[2];
			break;
		case 4:
			val = ((uint32_t)txBuf[1])<<16 | ((uint32_t)txBuf[2])<<8 | txBuf[3];
			break;
		default:
			val = 0xF0F0F0F0;
			break;
		}		
		signal ADE7753.setRegDone(error, (txBuf[0] & 0x7F), val, len);
		break;
		/*
    case STATE_STARTING:
      mState = STATE_IDLE;
      call SPIFRM.set();
      post StartDone();
      break;
    case STATE_STOPPING:
      mState = STATE_STOPPED;
      post StopDone();
	  */
    default:
      mState = STATE_IDLE;
      break;
    }

	call Resource.release();

	return;
  }

  /*
  async event void InterruptAlert.fired() {
    // This alert is decoupled from whatever state the MAX136x is in. 
    // Upper layers must handle dealing with this alert appropriately.
    signal ADE7753.alertThreshold();
    return;
  }
  */
  
  default event void SplitControl.startDone( error_t error ) { return; }
  default event void SplitControl.stopDone( error_t error ) { return; }

  
  // default async event void ADE7753.alertThreshold(){ return; }

}
