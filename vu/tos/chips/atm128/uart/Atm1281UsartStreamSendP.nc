module Atm1281UsartStreamSendP {
  uses {
    interface UsartByteSend as ByteSend;
  }

  provides {
    interface UsartStreamSend as StreamSend;
  }
}
implementation {

  norace uint8_t* txBufStart = 0;
  norace uint8_t* txBuf = 0;
  norace uint8_t* txBufEnd = 0;
    
  async command error_t StreamSend.send( uint8_t* buf, uint16_t len ) {

    error_t ecode;

    // check for zero length
    if(len == 0)
      return EINVAL;
      
    // check for ongoing transmission
    if(txBuf < txBufEnd) 
      return EBUSY;

    // set up tx buffer	
    txBufStart = buf;
    txBuf = buf;
    txBufEnd = buf + len;
	
    // enable interrupt on empty tx buffer
    ecode  = call ByteSend.enableReadyToSend();	
     
    // return error code
    return ecode;
  }

  void signalSendDone(error_t ecode) {
    uint8_t* newBuf = txBuf;
    uint16_t newLen = 0;
    	
    signal StreamSend.sendDone( txBufStart, txBuf-txBufStart, ecode, &newBuf, &newLen);
    txBufStart = newBuf;
    txBuf = newBuf;
    txBufEnd = newBuf + newLen;  	
    
    // disable tx buffer empty interrupt if no bytes to send
    if(txBuf == txBufEnd)
      call ByteSend.disableReadyToSend();	
  }
  
  async event void ByteSend.readyToSend() {
    error_t ecode;
  	
    if(txBuf < txBufEnd) {
      ecode = call ByteSend.send(*txBuf);

      if(ecode == SUCCESS) {
        // successful send
        txBuf++;
        
        if(txBuf == txBufEnd) {
          // it was the last byte of the buffer
	  signalSendDone(ecode);      
        }
      } else {
        // error (USART off? or busy?)
	signalSendDone(ecode);
      }    
    }
  }
  
  async command void StreamSend.requestSendDone() {
    signalSendDone(ECANCEL);
  }  
  
}
