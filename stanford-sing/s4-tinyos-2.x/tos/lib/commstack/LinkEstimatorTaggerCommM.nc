
includes AM;
includes LinkEstimator;

module LinkEstimatorTaggerCommM {
  provides {
    interface Init;
    interface StdControl;
    interface AMSend[ uint8_t am];
    interface Receive[uint8_t am];
  }
  uses {    
    interface Packet;   ///////////  diff
    interface AMPacket; //////// diff
    
    interface Init as BottomStdControlInit;
    interface StdControl as BottomStdControl;
    interface AMSend as BottomSendMsg[ uint8_t am ];
    interface Receive as BottomReceiveMsg[ uint8_t am ];
 
#ifdef SERIAL_LOGGING   
    interface AMPacket as SerialActiveMessagePkt; /// diff
    interface AMSend as SerialAMSend;  // diff
#endif
    
    //interface Logger;
  }
}
implementation {
  
  uint16_t my_seqno;
  
  bool initialized = FALSE;

  command error_t Init.init()  {
    error_t err;
    my_seqno = 1;
    err = call BottomStdControlInit.init();
    
    initialized = TRUE;
    
    return err;
  }

  command error_t StdControl.start()  {
    if (!initialized) {
      call Init.init();
    }
    
    return call BottomStdControl.start();
  }

  command error_t StdControl.stop()  {
    return call BottomStdControl.stop();
  }

  //This is the only thing this module does, tag the outgoing packets with an ever increasing
  //sequence number and with the local address.
  //This is not subject to freezing, because we assume that it is the recipient who
  //should freeze the link quality of this node.
  command error_t AMSend.send[ uint8_t am ]( uint16_t addr,  message_t* msg, uint8_t length)  {
    LEHeader* link_header_ptr = (LEHeader*)&msg->data[0];
    //if (addr != call SerialActiveMessagePkt.address()) {
      dbg("BVR-debug","LinkEstimatorCommM$send. Will tag packet with sequence number (%d)\n",my_seqno);
      link_header_ptr->last_hop = call AMPacket.address();
      link_header_ptr->seqno = my_seqno++; 
    //}
    

    return call BottomSendMsg.send[ am ]( addr,  msg, length );
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

  event void BottomSendMsg.sendDone[ uint8_t am ]( message_t* msg, error_t success )  {
    dbg("BVR-debug","LinkEstimatorCommM$sendDone: result:%d\n",success);
    signal AMSend.sendDone[ am ]( msg, success );
  }

  event message_t* BottomReceiveMsg.receive[ uint8_t am ]( message_t* msg, void* payload, uint8_t len )  {
    return signal Receive.receive[ am ]( msg, payload, len );
  }

  default event void AMSend.sendDone[ uint8_t am ]( message_t* msg, error_t success )  {
    return;
  }

  default event message_t* Receive.receive[ uint8_t am ]( message_t* msg, void* payload, uint8_t len )  {
    return msg;
  }
  
#ifdef SERIAL_LOGGING  
  event void SerialAMSend.sendDone( message_t* msg, error_t success )  {
      return;
  }
#endif


} //end of implementation  
