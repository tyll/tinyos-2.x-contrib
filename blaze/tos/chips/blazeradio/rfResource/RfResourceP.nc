#include "CC1100.h"

module RfResourceP {

  provides interface AMSend[ am_id_t amId ];
  provides interface ChipSpiResource as RadioResource[ am_id_t amId ];
  
  uses interface AMSend as SubSend[ am_id_t amId ];
  uses interface SplitControl[ uint8_t radio_id ];
  uses interface State;
  uses interface Boot;
  uses interface BlazePacket;
  uses interface Timer<TMilli> as TimeoutTimer;
  uses interface Leds;
  uses interface DebugPins as Pins;
}

implementation {

  /******** Vairables ************************/
  
  enum{
    NO_RADIO = 0xFF,
    TIMEOUT_WAIT = 5,
  };
  
  enum{
    S_IDLE = 0,
    S_STOPPING = 1,
    S_SWITCHING = 2,
    S_STARTING = 3,
    S_SENDING = 4,
    S_WAIT_RELEASE = 5,
  };
  
  /* The radio that is currently powered on*/
  uint8_t cur_radio = NO_RADIO;
  /* The radio that has been requested*/
  uint8_t next_radio = NO_RADIO;
  /* True if there is a message to send*/
  bool valid_msg;
  /* Pointer to the next message to send*/
  message_t* g_msg;
  /* Address of the next message to send*/
  am_addr_t g_addr;
  /* Length of the next message to send*/
  uint8_t g_length;
  /* am_id of the next message to send*/
  am_id_t g_amId;
  /* false if need to abort release of resource*/
  bool release = TRUE;
  /* True if a component has tried to send a message but the component was 
   * waiting for the attempt release command call, this way the cc1100 is not 
   * started again*/
  bool msgWaiting = FALSE;
  
  
  /******** Prototypes ***********************/
  task void sendMsg();
  task void startTimeout();
  task void stopRadio();
  void toIdle();	

  /************** Boot Events *********************/
  event void Boot.booted(){
    //initalize the CC1100 Radio using SplitControl
    atomic{
      cur_radio = CC1100_RADIO_ID;
    }
    call State.forceState(S_STARTING);
    call SplitControl.start[ CC1100_RADIO_ID ]();
  }
  /************** AMSend Commands *******************/
  command error_t AMSend.send[ am_id_t amId ](am_addr_t addr, message_t* msg, uint8_t len)
  {
    uint8_t radio;
    //call Pins.toggle65();
    if(call State.requestState(S_SWITCHING) != SUCCESS){
      atomic msgWaiting = TRUE;
      
      return EBUSY;
    }
    atomic msgWaiting = FALSE;
    //check and see what radio wants it
    radio = call BlazePacket.getRadio(msg);
    atomic{
      g_amId = amId;
      g_addr = addr;
      g_msg = msg;
      g_length = len;
    }
    //if the current radio is not the one we need to use, stop the current radio
    //else, send the message
    if(radio != cur_radio){
      next_radio = radio;
      call SplitControl.stop[ cur_radio ]();
    }else{
      post sendMsg();
    }
    return SUCCESS;
  }
  
  command error_t AMSend.cancel[ am_id_t amId ](message_t* msg)
  {
    return call SubSend.cancel[ amId ](msg); //will this always signal out a sendDone event 
  }
  
  command uint8_t AMSend.maxPayloadLength[ am_id_t amId ]()
  {
    return call SubSend.maxPayloadLength[ amId ]();
  }
  
  command void* AMSend.getPayload[ am_id_t amId ](message_t* msg, uint8_t len)
  {
    return call SubSend.getPayload[ amId ](msg, len);
  }
  
  /************ RadioResource Commands *************************/
  async command void RadioResource.abortRelease[ uint8_t radio_id ](){
    //make sure Rf component not released, wait for RadioResource.attemptRelease command
    atomic{
      release = FALSE;
    }
  }
  
  async command error_t RadioResource.attemptRelease[ uint8_t radio_id ](){
    //release current Rf component and start the CC1100
    if(call State.getState() == S_WAIT_RELEASE){
      if(msgWaiting){
        call State.toIdle();
        post startTimeout();
      }else{
        call State.forceState(S_STARTING);
        post stopRadio();
      }
    }
    return SUCCESS;
  }
  
  /***************** SplitControl Events ***********************/
  event void SplitControl.startDone[ uint8_t radio_id ](error_t error){
    // go to the idle state if just listening
    //post send message now that correct rf component is initialized
    if(call State.getState() == S_STARTING){
      call State.toIdle();
    }else if(call State.getState() == S_SWITCHING){
      post sendMsg();
    }
  }
  
  event void SplitControl.stopDone[ uint8_t radio_id ](error_t error){
    //if stopping to shut off all components, signal out
    //else if stopping to switch, call start
    if(call State.getState() == S_STARTING){
      atomic{
        cur_radio = CC1100_RADIO_ID;
      }
      call SplitControl.start[ CC1100_RADIO_ID ](); 
    }else if(call State.getState() == S_SWITCHING){
      atomic cur_radio = next_radio;
      if(call SplitControl.start[ cur_radio ]() != SUCCESS){
        
      }
    }
  }
  
  /***************** SubSend events ***************************/
  event void SubSend.sendDone[ am_id_t amId ](message_t* msg, error_t error){
    //signal AMSend.sendDone
    signal AMSend.sendDone[ amId ](msg, error);
    call Pins.clr56();
    atomic{
      release = TRUE;
    }
    //signal RadioResource.releasing
    signal RadioResource.releasing[ amId ]();
    //test and see if got abort callback
    atomic{
      if(release) {
        //if the cc1100 radio is already on (it is in the rx state), wait for next send
        if(cur_radio == CC1100_RADIO_ID){
          call State.toIdle();
        }else{
          toIdle();
        }
      }else{
        call State.forceState(S_WAIT_RELEASE);
      }
      
    }
    
  }
  
  /***************** TimeoutTimer *************************/
  event void TimeoutTimer.fired(){
    //if the timeout timer fires waiting for a new message to send,
    // turn on the cc1100 radio
    if(cur_radio != CC1100_RADIO_ID){
      toIdle();
    }
  }
  
  /******************* Tasks *********************************/
  task void sendMsg(){
    call State.forceState(S_SENDING);
    if(call SubSend.send[ g_amId ](g_addr, g_msg, g_length) != SUCCESS){
      post sendMsg();
    }else{
      call Pins.set56();
    }
  }
  
  task void startTimeout(){
    call TimeoutTimer.startOneShot(TIMEOUT_WAIT);
  }
  
  task void stopRadio(){
    call SplitControl.stop[ cur_radio ]();
  }
  
  void toIdle(){
    call State.forceState(S_STARTING);
    call SplitControl.stop[ cur_radio ]();
  }

  /******************* Default Events *************************/
  default async event void RadioResource.releasing[ uint8_t radioId](){}
  
  default event void AMSend.sendDone[ am_id_t amId ](message_t* msg, error_t error){}
  /*
  default command error_t SubSend.send[ am_id_t amId ](am_addr_t addr, message_t* msg, uint8_t len){
    return FAIL;
  }
  default command error_t SubSend.cancel[ am_id_t amId ](message_t* msg){
    return FAIL;
  }
  default command uint8_t SubSend.maxPayloadLength[ am_id_t amId ](){
    return 0;
  }
  default command void* SubSend.getPayload[ am_id_t amId ](message_t* msg, uint8_t len){
    return NULL;
  }
  */
  default command error_t SplitControl.start[ uint8_t radioId ](){
    return FAIL;
  }
  default command error_t SplitControl.stop[ uint8_t radioId ](){
    return FAIL;
  }
}


