
module GenericCommReallyPromiscuousM {
  provides {
    interface Init;
    interface StdControl;
    interface AMSend[ uint8_t am];
    interface Receive[uint8_t am];
  }
  uses {
    interface Packet;
    interface StdControl as BottomStdControl;
    interface AMSend as BottomSendMsg[ uint8_t am ];
    interface Receive as BottomReceiveMsg[ uint8_t am ];
    
    interface PacketAcknowledgements as Acks;
    
#if defined(PLATFORM_MICA2) || defined (PLATFORM_MICA2DOT)
    interface MacControl;
#endif
  }
}
implementation {

  bool initialized = FALSE;

  command error_t Init.init()  {        
    initialized = TRUE;
    
    return SUCCESS;
  }

  command error_t StdControl.start()  {
    error_t ok;
    
    if (!initialized) {
      call Init.init();
    }
    
    //ok = call BottomStdControl.start();
#if defined(PLATFORM_MICA2) || defined (PLATFORM_MICA2DOT)
    call MacControl.enableAck();
#endif
    return ok;
  }

  command error_t StdControl.stop()  {
    //return call BottomStdControl.stop();
    
    return SUCCESS;
  }

  command error_t AMSend.send[ uint8_t am ]( uint16_t addr, message_t* msg, uint8_t length )  {
    error_t err;
    
    err = call BottomSendMsg.send[ am ]( addr,  msg, length );
    
    dbg("S4-debug", "Called GenericCommReallyPromiscuousM.AMSend.send with args(am=%d): %d, msg=%x, %d, ret val=%d, time=%s \n",
        am, addr, msg, length, err, sim_time_string());
    
    return err;
  }
  
  default command error_t BottomSendMsg.send[ uint8_t am ]( uint16_t addr, message_t* msg, uint8_t length )  {
      return SUCCESS;
  }

  event void BottomSendMsg.sendDone[ uint8_t am ]( message_t* msg, error_t success )  {
    dbg("S4-debug", "Called GenericCommReallyPromiscuousM.AMSend.sendDone with args(am=%d): msg, %d\n",
          am, success);	
       
    
    signal AMSend.sendDone[ am ]( msg, success );
  }

  event message_t* BottomReceiveMsg.receive[ uint8_t am ]( message_t* msg, void* payload, uint8_t len )  {
    if (am == AM_S4_APP_MSG) 
      dbg("BVR", "Called GenericCommReallyPromiscuousM.Receive.receive with args(am=%d):  time=%s\n",
            am, sim_time_string());
    
    return signal Receive.receive[ am ]( msg, payload, len );
  }

  default event void AMSend.sendDone[ uint8_t am ]( message_t* msg, error_t success )  {
    return ;
  }

  default event message_t* Receive.receive[ uint8_t am ]( message_t* msg, void* payload, uint8_t len)  {    
    return msg;
  }

  command error_t AMSend.cancel[uint8_t id]( message_t* msg){
    return call BottomSendMsg.cancel[id](msg);
  }
    
  command void* AMSend.getPayload[uint8_t id]( message_t* msg, uint8_t len){
    return call BottomSendMsg.getPayload[id](msg, len);
  }
    
  command uint8_t AMSend.maxPayloadLength[uint8_t id]( ){
    return call BottomSendMsg.maxPayloadLength[id]();
  }

} //end of implementation  
