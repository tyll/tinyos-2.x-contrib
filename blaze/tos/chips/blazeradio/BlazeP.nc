

/**
 * @author Jared Hill 
 */
 
 /**
  * This module acts as arbiter between the two radios as well as the 
  * the send and receive branches. It turns the power to the radios on 
  * and off. It synchronizes the lower layers.
  */

#include "Blaze.h"
#include "IEEE802154.h"

module BlazeP {

  provides interface Init as InitModule;
  //allocates the spiBus between the receive and send branch
  provides interface Resource as SpiResource[ uint8_t id ];
  provides interface Send;
  provides interface Receive;
  provides interface RadioSelect;
  provides interface ReleaseSpi;
  //provides interface BlazeChannelMonitor;
  
  
  uses interface Resource;
  uses interface GpioInterrupt as CC1100ReceiveInterrupt;
  uses interface GpioInterrupt as CC2500ReceiveInterrupt;
  //uses interface BlazeChannelMonitor;
  uses interface Leds;
  uses interface SplitControl as CC1100Control;
  uses interface SplitControl as CC2500Control;
  uses interface State as CC1100State;
  uses interface State;
  uses interface State as CC2500State;
  uses interface AsyncSend as CC1100Send;
  uses interface AsyncSend as CC2500Send;
  uses interface AsyncReceive as CC1100Receive;
  uses interface AsyncReceive as CC2500Receive;
  uses interface BlazePacket;
  uses interface Timer<TMilli> as TimeoutTimer;
}

implementation {

  enum {
    NO_HOLDER = 0xff,
  };

  enum {
    S_IDLE,
    S_GRANTING,
    S_BUSY,
  };
  
  enum resource_state{
    
    S_CC1100_TX = 1,
    S_CC2500_TX = 2,
    S_CC1100_RX = 3,
    S_CC2500_RX = 4,
    S_CC1100_INIT = 5,
    S_CC2500_INIT = 6,
    RESOURCE_COUNT = 7,
  };
  
  bool enabled = FALSE;
  norace uint16_t m_addr;
  uint8_t m_requests = 0;
  uint8_t m_holder = NO_HOLDER;
  uint8_t m_state = S_IDLE;
  
  //arrays for keeping the states of the messages
  message_t* m_msg_send[2]; 
  uint8_t m_len_send[2];
  norace message_t receive_msg;
  uint8_t m_len_rec[2];
  error_t m_error[2];
  norace uint8_t m_radio;
  
  /********Tasks**********************/

   task void sendDoneTask();
   task void receiveTask();
   task void sendMsg();
   task void startTimer();
   task void releaseSpi();
   task void stopTimer();
   task void CC1100StartTask();
   task void CC2500StartTask();
   
  /******** Local Functions ************/
   void grant(uint8_t id);
   void next();
   void release();
  
  /******************** Init Commands *******************/
  
  command error_t InitModule.init() {
    
    call State.toIdle();
    enabled = TRUE;
    return SUCCESS;
  }
  
  /*************CC1100ReceiveInterrupt Events*************/
  async event void CC1100ReceiveInterrupt.fired(){
    if(call State.getState() == S_CC1100_RX){
      return;
    }
    call SpiResource.request[ S_CC1100_RX ](); 
    
  }
  /*************CC2500ReceiveInterrupt Events*************/
  
  async event void CC2500ReceiveInterrupt.fired(){
    if(call State.getState() == S_CC2500_RX){
      return;
    }
    
    //uncomment this when you actually have two different radios. 
    //call SpiResource.request[ S_CC2500_RX ]();
  }
  
  /**************** CC1100Control Events *******************/
  event void CC1100Control.startDone(error_t error){
    call State.toIdle();
    call CC1100ReceiveInterrupt.enableRisingEdge();
    call SpiResource.release[ S_CC1100_INIT ]();
    signal RadioSelect.grantCC1100(error);
  }
  
  event void CC1100Control.stopDone(error_t error){
    
    call State.toIdle();
    signal RadioSelect.releaseCC1100Done(error);
  }
  
  /**************** CC2500Control Events *******************/
  
  event void CC2500Control.startDone(error_t error){
    call State.toIdle();
    call CC2500ReceiveInterrupt.enableRisingEdge();
    call SpiResource.release[ S_CC2500_INIT ]();
    signal RadioSelect.grantCC2500(error);
  }
  
  event void CC2500Control.stopDone(error_t error){
    call State.toIdle();
    signal RadioSelect.releaseCC2500Done(error);
    
  }
  
  /***************** Resource Events **********************/
  event void Resource.granted() {
    uint8_t holder;
    atomic { 
        holder = m_holder;
        m_state = S_BUSY;
    }
    grant(holder);
    
  }
  
  /***************** SpiResource Commands *****************/
  async command error_t SpiResource.request[ uint8_t id ]() {
    
    if(!enabled) {
      return EOFF;
    }
    
    atomic {

      if ( m_state != S_IDLE ) {
        m_requests |= 1 << id;
        
      } else {
        m_holder = id;
        m_state = S_GRANTING;
        if(!call Resource.isOwner()){
          call Resource.request();
        }else{
          m_state = S_BUSY;
          grant(id);
        }
      }
    }
    return SUCCESS;
  }
  
  async command error_t SpiResource.immediateRequest[ uint8_t id ]() {
    error_t error;
    
    if(!enabled) {
      return EOFF;
    }
    
    atomic {
      if ( m_state != S_IDLE ) {
        return EBUSY;
      }
      
      error = call Resource.immediateRequest();
      if ( error == SUCCESS ) {
        m_holder = id;
        m_state = S_BUSY;
      }
    }
    return error;
  }

  async command error_t SpiResource.release[ uint8_t id ]() {
    atomic {
      if ( (m_holder != id) || (m_state != S_BUSY)) {
        return FAIL;
      }
      m_holder = NO_HOLDER;
      post startTimer();
      post releaseSpi();
      /*
      call Resource.release();
      if ( !m_requests ) {
        m_state = S_IDLE;
      } else {
        for ( i = m_holder + 1; ; i++ ) {
          if ( i >= RESOURCE_COUNT ) {
            i = 0;
          }
          
          if ( m_requests & ( 1 << i ) ) {
            m_holder = i;
            m_requests &= ~( 1 << i );
            call Resource.request();
            m_state = S_GRANTING;
            return SUCCESS;
          }
        }
      }
      */ 
      
    }
    return SUCCESS;
  }
  
  async command uint8_t SpiResource.isOwner[ uint8_t id ]() {
    atomic return (m_holder == id) & (m_state == S_BUSY);
  }

  /*************CC1100Send Events********************************/
  //synchronize the send chain
  async event void CC1100Send.sendDone(message_t* msg, error_t error){
    
    //nothing inside this module will execute until the sendDoneTask releases the resource
    //we can use the same m_radio value as set in the Send.send command
    atomic{
      m_msg_send[m_radio] = msg;
      m_error[m_radio] = error;
    }
    //call Leds.led0On();   
    //post startTimer();
    //signal ReleaseSpi.releaseSpi();
    post sendDoneTask();
  }
  
  /*************CC2500Send Events********************************/
  //synchronize the send chain
  async event void CC2500Send.sendDone(message_t* msg, error_t error){
    
    //nothing inside this module will execute until the sendDoneTask releases the resource
    //we can use the same m_radio value as set in the Send.send command
    atomic{
      m_msg_send[m_radio] = msg;
      m_error[m_radio] = error;
    }
    //post startTimer();
    //signal ReleaseSpi.releaseSpi();
    post sendDoneTask();
  }
  
  /*************ReleaseSpi Command********************/
  async command void ReleaseSpi.release(bool okay){
    post stopTimer();
    if(okay){
      release();  
    }
    //else we wait for something from above
  }
  
  /**************TimeoutTimer Events*******************/
  event void TimeoutTimer.fired(){
    //post sendDoneTask();
    if(call Leds.get() == 1){
        call Leds.set(12);
    }
    release();
  }
   
   
  /*********** CC1100Receive Events *************************/
  //synchronize the receive chain
  async event void CC1100Receive.receive(message_t* msg, void* payload, uint8_t len){
  
    uint8_t radio = BLAZE_CC1100;
    //nothing inside this module will execute until the receiveTask releases the resource
    //call Leds.led1Off();
    //call Leds.led0Off();
        
    if(msg == NULL){
      call State.toIdle();
      call SpiResource.release[ S_CC1100_RX ]();
      return;
    }
    atomic{
      m_len_rec[radio] = len;
      m_radio = radio;
    } 
    
    //call Leds.set(0);
    post receiveTask();
    
  }  
  
  /*********** CC2500Receive Events *************************/
  //synchronize the receive chain
  async event void CC2500Receive.receive(message_t* msg, void* payload, uint8_t len){
  
    uint8_t radio = BLAZE_CC2500;
    if(msg == NULL){
      call State.toIdle();
      call SpiResource.release[ S_CC2500_RX ]();
      return;
    }
    //nothing inside this module will execute until the receiveTask releases the resource
    atomic{
      m_len_rec[radio] = len;
      m_radio = radio;
    } 
    post receiveTask();
  }  
  
  /*************RadioSelect Commands***********************/
  command error_t RadioSelect.requestCC1100(){
    //make sure CC2500 is powered off
    if(call CC2500State.getState() != S_RADIO_OFF){
      return FAIL;
    }
    call SpiResource.request[S_CC1100_INIT](); 
    return SUCCESS; 
  }
  
  command error_t RadioSelect.releaseCC1100(){
    if(call State.getState() != S_IDLE){
      return FAIL;
    }
    return call CC1100Control.stop();
     
  }
  
  command error_t RadioSelect.requestCC2500(){
    //make sure the CC1100 is powered off
    if(call CC1100State.getState() != S_RADIO_OFF){
      return FAIL;
    }
    call SpiResource.request[S_CC2500_INIT]();
    return SUCCESS;
    
  }
  command error_t RadioSelect.releaseCC2500(){
    if(call State.getState() != S_IDLE){
      return FAIL;
    }
    return call CC2500Control.stop();
     
  }
  
  /********************* Send Commands **************************/
  command error_t Send.send(message_t* p_msg, uint8_t len){
    
    uint8_t radio = call BlazePacket.getRadio(p_msg);
    //if we are already sending on this radio, we cannot request it again
    //increment radio to match the transmit state
    if(call State.getState() == (radio + 1)){
      return FAIL;
    }
    atomic{
      m_msg_send[radio] = p_msg;
      m_len_send[radio] = len;
    }
    //increment radio to match the transmit state
    return call SpiResource.request[ (radio + 1) ]();
  }

  command error_t Send.cancel(message_t* msg){ 
    return FAIL;
  }
  
  command uint8_t Send.maxPayloadLength(){
    return TOSH_DATA_LENGTH;
  }

  command void* Send.getPayload(message_t* msg){
    return msg->data;
  }
  
  
  /********************* Receive Commands **********************/
  command void* Receive.getPayload(message_t* msg, uint8_t* len){
    if (len != NULL) {
      *len = TOSH_DATA_LENGTH;
    }
    return msg->data;  
  }

  command uint8_t Receive.payloadLength(message_t* msg){
    blaze_header_t* header = call BlazePacket.getHeader( msg );
    return header->length;
  }
  
  /*************Tasks************************/
  task void sendDoneTask(){
    message_t* msg;
    error_t error;
    uint8_t radio;
    call TimeoutTimer.stop();
    atomic{
      radio = m_radio;
      msg = m_msg_send[radio];
      error = m_error[radio];
    }
    call State.toIdle();
    //This is to increment the radio to match the tx state
    //call Leds.led0Off();
    call SpiResource.release[ radio +  1 ](); 
    signal Send.sendDone(msg, error);
  }
  
  task void receiveTask(){
    
    message_t* msg;
    blaze_header_t* cur_header;
    blaze_header_t* sent_header;
    blaze_metadata_t* meta;
    uint8_t len;
    uint8_t radio;
    atomic{
      radio = m_radio;
      len = m_len_rec[radio];
      sent_header = call BlazePacket.getHeader(m_msg_send[radio]);
    }
    msg = &receive_msg;
    call State.toIdle();
    //see if this is an ack packet
    cur_header = call BlazePacket.getHeader(msg);
    if((( cur_header->fcf >> IEEE154_FCF_FRAME_TYPE ) & 7) == IEEE154_TYPE_ACK){
      if( (sent_header->dsn == cur_header->dsn) && (sent_header->dest == cur_header->src) ){  
        meta = call BlazePacket.getMetadata(msg);
        meta->ack = TRUE;
      }
    }else{
      signal Receive.receive(msg, msg->data, len);
    }

    //increment the radio to match the recieve state
    call SpiResource.release[ (radio + 3) ]();
    
  }
  
  task void sendMsg(){
    uint8_t pktLen;
    uint8_t radio;
    message_t* p_msg;
    blaze_header_t* header; 
    blaze_metadata_t* metadata;
    call TimeoutTimer.stop();
    atomic{
      radio = m_radio;
      pktLen = m_len_send[radio];
      p_msg = m_msg_send[radio];
      m_error[radio] = FAIL; //if we fail, error is set correctly
    }
    //double check we are in the correct radio state
    //add the one to radio to match the transmit state value
    if(call State.getState() != (radio + 1)){
        post sendDoneTask(); 
        return;
    }
    header = call BlazePacket.getHeader( p_msg );
    metadata = call BlazePacket.getMetadata( p_msg );
    
    pktLen = pktLen + sizeof(blaze_header_t) + sizeof(blaze_footer_t);    
    header->length = pktLen;
    header->fcf &= 1 << IEEE154_FCF_ACK_REQ;
    header->fcf |= ( ( IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE ) |
		     ( 1 << IEEE154_FCF_INTRAPAN ) |
		     ( IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE ) |
		     ( IEEE154_ADDR_SHORT << IEEE154_FCF_SRC_ADDR_MODE ) );
    //header->src = call AMPacket.address();
    metadata->ack = FALSE;
    metadata->rssi = 0;
    metadata->lqi = 0;
    metadata->time = 0;
    
    if(radio == BLAZE_CC1100){
      if(call CC1100Send.send(p_msg, pktLen) != SUCCESS){
        atomic{
          m_error[radio] = FAIL;
        }
        post sendDoneTask();
      }
    }else{
      if(call CC2500Send.send(p_msg, pktLen) != SUCCESS){
        atomic{
          m_error[radio] = FAIL;
        }
        post sendDoneTask();
      }
    }
  }
  
  task void startTimer(){
    call TimeoutTimer.startOneShot(10);
  }
  
  task void stopTimer(){
    call TimeoutTimer.stop();
  }
  
  task void CC1100StartTask(){
    call CC1100Control.start();
  }
  
  task void CC2500StartTask(){
    call CC2500Control.start();
  }
  
  task void releaseSpi(){
    signal ReleaseSpi.releaseSpi();
  }
  
  void release(){
    atomic{
      call Resource.release();
      if ( !m_requests ) {
        m_state = S_IDLE;
        //call Leds.led2Off();
      } else {
        next();  
      }
    }
    
  }
  
  void next(){
    uint8_t i;
    atomic{
      for ( i = m_holder + 1; ; i++ ) {
        if ( i >= RESOURCE_COUNT ) {
          i = 0;
        }
      
        if ( m_requests & ( 1 << i ) ) {
          m_holder = i;
          m_requests &= ~( 1 << i );
          if(!call Resource.isOwner()){
            
            call Resource.request();
            m_state = S_GRANTING;
            return;
          }else{
            grant(i);
            m_state = S_BUSY;
            return;
          }
        }
      }
    }
  }
  
  void grant(uint8_t holder){
    call State.forceState(holder);
    switch(holder){
      case S_CC1100_TX:
        m_radio = BLAZE_CC1100;
        post sendMsg();
        break;
      
      case S_CC2500_TX:
        m_radio = BLAZE_CC2500;
        post sendMsg();
        break;
        break;

      case S_CC1100_RX:  //you know the radio is already on and in receive mode, right?
        //we know here which radio is on, so set the radio in the metadata...
        //call Leds.led2On();   
        call BlazePacket.setRadio(&receive_msg, BLAZE_CC1100);
        call CC1100Receive.startReceive(&receive_msg);
        break;
      
      case S_CC2500_RX:
        //we know here which radio is on, so set the radio in the metadata...
        call BlazePacket.setRadio(&receive_msg, BLAZE_CC2500);
        call CC2500Receive.startReceive(&receive_msg);
        break; 
        
      case S_CC1100_INIT:
        post CC1100StartTask();
        break;
      
      case S_CC2500_INIT:
        post CC2500StartTask();
        break;
     
    }
  }
  
  default async event void ReleaseSpi.releaseSpi(){ 
    call ReleaseSpi.release(TRUE);
  }
  
  default event message_t* Receive.receive(message_t* msg, void* data, uint8_t len){return msg;}
  
}
