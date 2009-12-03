module Atm1281UsartByteP {
  uses {
    interface HplAtm1281Usart as Hpl;
    interface HplAtm1281UsartSetup as Setup;
    interface HplAtm1281UsartUtil as Util;
  }

  provides {
    interface SplitControl;
    interface UsartByteReceive;
    interface UsartByteSend;
  }
}
implementation {
  norace Atm128UartBaudRate_t ubrr;

  enum { STATE_OFF = 0,
         STATE_ON = 1,
  };

  norace uint8_t state = 0;

  
#define BAUD 921600L
//#define BAUD 460800L
//#define BAUD 230400L
//#define BAUD 115200L
//#define BAUD 57600L

  /************************************************
   * UART Start and Stop
   ************************************************/

  task void startTask() {
    Atm1281UartControlB_t ucsrb;

      if( call Util.isRxOrTxInProgress() ) {
        // repost task if rx or tx in progress
        post startTask();
        return;
      }
      
      // get out of sleep mode
      call Hpl.enable();
    atomic {

      // read UCSRB
      ucsrb = call Hpl.getUCSRB();
      call Setup.setMode(ATM128_UART_MODE_DOUBLE_SPEED_ASYNC, ATM128_UART_DATA_SIZE_8_BITS, ATM128_UART_PARITY_NONE, ATM128_UART_STOP_BITS_ONE);

      ucsrb.bits.rxen = 1;  // enable receive
      ucsrb.bits.txen = 1;  // enable transmit
      ucsrb.bits.rxcie = 0; // disable rx complete interrupt
      ucsrb.bits.txcie = 0; // disable tx complete interrupt
      ucsrb.bits.udrie = 0; // enable tx buffer empty interrupt
      call Hpl.setUCSRB(ucsrb);

      call Hpl.setUBRR(ubrr);
      
      // TODO: clear udr empty flag
    }

    signal SplitControl.startDone(SUCCESS);
  }

  command error_t SplitControl.start() {
    if(state & STATE_ON)
      return EALREADY;

    state |= STATE_ON;

    // compute baud rate register value
    ubrr = call Setup.computeUBRR(ATM128_UART_MODE_DOUBLE_SPEED_ASYNC, 7372800UL, BAUD);

    // post start task
    post startTask();

    return SUCCESS;
  }

  task void stopTask() {
    // repost task if rx or tx in progress
    if( call Util.isRxOrTxInProgress() ) {
      post stopTask();
      return;
    }

    // go to sleep mode
    call Hpl.disable();

    state = STATE_OFF;
    signal SplitControl.stopDone(SUCCESS);
  }

  command error_t SplitControl.stop() {
    Atm1281UartControlB_t ucsrb;

    if(state == STATE_OFF)
      return EOFF;

      atomic {
        ucsrb = call Hpl.getUCSRB();
        ucsrb.bits.rxen = 0;
        ucsrb.bits.txen = 0;
        call Hpl.setUCSRB(ucsrb);
      }

      post stopTask();
    return SUCCESS;
  }

  default event void SplitControl.startDone(error_t e) {}
  default event void SplitControl.stopDone(error_t e) {}

  /************************************************
   * TX
   ************************************************/

  async command error_t UsartByteSend.enableReadyToSend() {
    if(state == STATE_OFF)
      return EOFF;

    call Util.enableTxBufferEmptyInterrupt();
    return SUCCESS;
  }

  async command error_t UsartByteSend.disableReadyToSend() {
    call Util.disableTxBufferEmptyInterrupt();
    return SUCCESS;
  }

  async event void Hpl.dataRegisterEmpty() {
    signal UsartByteSend.readyToSend();
  }

  async event void Hpl.txComplete() {}

  async command error_t UsartByteSend.send( uint8_t byte ) {
    if(state == STATE_OFF)
      return EOFF;

    if(call Util.isTxInProgress()) 
      return EBUSY;
    
    call Util.tx(byte);

    return SUCCESS;
  }

  async command bool UsartByteSend.isReadyToSend() {
    return call Util.isTxInProgress();
  }

  /************************************************
   * RX
   ************************************************/

  async command error_t UsartByteReceive.enableReceive() {
    if(state == STATE_OFF)
      return EOFF;

    if(call Util.isRxCompleteInterruptEnabled())
    	return EALREADY;

    call Util.flushRxBuffer();

    atomic call Util.enableRxCompleteInterrupt();
        
    return SUCCESS;
  }

  async command error_t UsartByteReceive.disableReceive() {
    if(state == STATE_OFF)
      return EOFF;

    if(!(call Util.isRxCompleteInterruptEnabled()) )
    	return EALREADY;
    
    atomic call Util.disableRxCompleteInterrupt();

    return SUCCESS;
  }

  async event void Hpl.rxComplete() {
    do {
	    register uint8_t rxError = call Util.getRxErrorFlags();
	    register uint8_t rxByte  = call Hpl.readBuf();
	    if(rxError == 0) {
	    	signal UsartByteReceive.receive(rxByte);
	    } else {
	    	// TODO: signal proper error value
	    	signal UsartByteReceive.receiveError(/*rxError*/);
	    }
    } while(call Util.isRxComplete());
  }
  
  async command void UsartByteReceive.flush() {
    call Util.flushRxBuffer();  	
  }  
}
