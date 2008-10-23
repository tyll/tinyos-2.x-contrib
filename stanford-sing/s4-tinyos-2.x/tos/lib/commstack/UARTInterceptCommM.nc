
includes AM;

module UARTInterceptCommM {
  provides {
    interface StdControl;
    interface SendMsg[ uint8_t am];
    interface ReceiveMsg[uint8_t am];
  }
  uses {
    interface StdControl as UARTControl;
    interface BareSendMsg as UARTSend;

    interface StdControl as BottomStdControl;
    interface SendMsg as BottomSendMsg[ uint8_t am ];
    interface ReceiveMsg as BottomReceiveMsg[ uint8_t am ];

  }
}
implementation {
  bool initialized = FALSE;   ///////////////// diff

  command result_t StdControl.init()  {
    call UARTControl.init();
    call BottomStdControl.init();
    
    initialized = TRUE;
    return SUCCESS;
  }

  command result_t StdControl.start()  {
    if (!initialized ) {
      call Init.init();      
    }
    
    call UARTControl.start();
    return call BottomStdControl.start();
  }

  command result_t StdControl.stop()  {
    call UARTControl.stop();
    return call BottomStdControl.stop();
  }
  
  command result_t SendMsg.send[ uint8_t am ]( uint16_t addr, uint8_t length, message_t* msg )  {
    result_t ok;
    dbg("S4-debug","UARTInterceptCommM$Send: (%p) am:%d addr:%d msg.addr:%d length:%d\n",
        msg, am, addr, msg->addr, length);
    if (addr == TOS_UART_ADDR) {
      msg->type = am;
      msg->length = length;
      msg->group = TOS_AM_GROUP;
      //Address is not set here. UARTLoggerComm should set in case of a UART packet.
      //Otherwise, we want to preserve the original destination in the UART packet,
      //instead of having it be TOS_UART_ADDRESS. This is the main point of all of this.
      ok = call UARTSend.send(msg);
      dbg("S4-debug","UARTInterceptCommM$Send to UART: result:%d\n",ok);
    } else {
      ok = call BottomSendMsg.send[ am ]( addr, length, msg );
      dbg("BVR-debug","UARTInterceptCommM$Send to BottomSend: result:%d\n",ok);
    }
    return ok;
  }

  event result_t BottomSendMsg.sendDone[ uint8_t am ]( message_t* msg, result_t success )  {
    dbg("S4-debug","UARTInterceptCommM$sendDone: (%p) am:%d result:%d\n",msg,am,success);
    return signal SendMsg.sendDone[ am ]( msg, success );
  }

  //This does not do anything. 
  event result_t UARTSend.sendDone(message_t* msg, result_t success) {
    return SUCCESS;
  }

  //Doesn't do anything special
  event message_t* BottomReceiveMsg.receive[ uint8_t am ]( message_t* msg )  {
    return signal ReceiveMsg.receive[ am ]( msg );
  }


  default event result_t SendMsg.sendDone[ uint8_t am ]( message_t* msg, result_t success )  {
    return SUCCESS;
  }

  default event message_t* ReceiveMsg.receive[ uint8_t am ]( message_t* msg )  {
    return msg;
  }


} //end of implementation  
