module Atm1281UsartStreamReceiveP {
  uses {
    interface UsartByteReceive as ByteReceive;
    interface HplAtm1281UsartUtil as Util;
  }
  provides {
    interface UsartStreamReceive as StreamReceive;
  }
}
implementation {

  norace uint8_t* rxBufStart = 0;
  norace uint8_t* rxBuf = 0;
  norace uint8_t* rxBufEnd = 0;
    
  async command error_t StreamReceive.receive( uint8_t* buf, uint16_t len ) {
    error_t ecode;
  	
    // check for zero length
    if(len == 0)
    	return EINVAL;

    // check for ongoing receive operation
    if(rxBuf < rxBufEnd)
      return EBUSY;

    // set up receive buffer
    rxBufStart = buf;
    rxBuf = buf;
    rxBufEnd = buf + len;
    
    // make sure byte receive is on
    ecode = call ByteReceive.enableReceive();

    // flush receive buffer if receive is already on
    if(ecode == EALREADY) {
    	call ByteReceive.flush();
    	return SUCCESS;
    }
    
    return ecode;
  }
  
  void signalReceiveDone(error_t ecode) {
    uint8_t* newBuf = rxBuf;
    uint16_t newLen = 0;
    	
    signal StreamReceive.receiveDone( rxBufStart, rxBuf-rxBufStart, ecode, &newBuf, &newLen);
    rxBufStart = newBuf;
    rxBuf = newBuf;
    rxBufEnd = newBuf + newLen;  	

    // if we had a rx error, we need to flush the rx buffer
    if(ecode == FAIL) {
    	call ByteReceive.flush();
    }
  }
  
  async event void ByteReceive.receive(uint8_t byte) {
//    if(rxBuf < rxBufEnd) {
      *rxBuf = byte;
      rxBuf++;
      if(rxBuf == rxBufEnd) {
        signalReceiveDone(SUCCESS);
      }
//    }
  }

  async event void ByteReceive.receiveError() {
    signalReceiveDone(FAIL);
  }
  
  async command void StreamReceive.requestReceiveDone() {
    signalReceiveDone(ECANCEL);
  }  
}
