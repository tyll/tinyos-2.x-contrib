
#include "TestCase.h"
#include "CC1100.h"
#include "CC2500.h"

module DualRadioTestP {
  provides {
    interface SplitControl as SplitControlCapture[radio_id_t radio];
    interface Send as SendCapture[radio_id_t radio];
  }

  uses {
    interface SplitControl;
    interface SplitControl as BlazeSplitControl[radio_id_t radio];
    interface State;
    interface AMSend;
    
    interface TestControl as SetUp;
    
    interface TestCase as TurnOnDefaultRadio;
    interface TestCase as TurnOnSecondaryRadio;
    interface TestCase as SendDefaultMsg;
  }
}

implementation {

  enum {
    S_IDLE,
    S_TURNONDEFAULTRADIO,
    S_TURNONSECONDARYRADIO,
    S_SENDDEFAULTMSG,
  };
  
  message_t myMsg;
  
  /***************** Test Control ****************/
  event void SetUp.run() {
    call State.toIdle();
    call BlazeSplitControl.stop[CC1100_RADIO_ID]();
    call BlazeSplitControl.stop[CC2500_RADIO_ID]();
    // Continues at BlazeSplitControl.stopDone[CC2500_RADIO_ID]();
  }
  
  /***************** Tests ****************/
  event void TurnOnDefaultRadio.run() {
    assertEquals("CC1100 is not default", 0, CC1100_RADIO_ID);
    call State.forceState(S_TURNONDEFAULTRADIO);
    call SplitControl.start();
  }
  
  event void TurnOnSecondaryRadio.run() {
    call State.forceState(S_TURNONSECONDARYRADIO);
    call BlazeSplitControl.start[CC2500_RADIO_ID]();
  }
  
  event void SendDefaultMsg.run() {
    call State.forceState(S_SENDDEFAULTMSG);
    call SplitControl.start();
    // Continues at SplitControl.startDone()...
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    if(call State.isState(S_SENDDEFAULTMSG)) {
      call SendDefaultMsg.done();
    }
  }
  
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    if(call State.isState(S_SENDDEFAULTMSG)) {
      call AMSend.send(0, &myMsg, 0);
      // Continues at SendCapture.send...
    }
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  event void BlazeSplitControl.startDone[radio_id_t id](error_t error) {
  }
  
  event void BlazeSplitControl.stopDone[radio_id_t id](error_t error) {
    if(id == CC2500_RADIO_ID) {
      call SetUp.done();
    }
  }
  
  
  /***************** SplitControlCapture Commands ****************/
  command error_t SplitControlCapture.start[radio_id_t radio]() {
    if(call State.isState(S_TURNONDEFAULTRADIO)) {
      assertEquals("Wrong radio", CC1100_RADIO_ID, radio);
      call TurnOnDefaultRadio.done();
    
    } else if(call State.isState(S_TURNONSECONDARYRADIO)) {
      assertEquals("Wrong radio", CC2500_RADIO_ID, radio);
      call TurnOnSecondaryRadio.done();
    }
    
    signal SplitControlCapture.startDone[radio](SUCCESS);
    return SUCCESS;
  }
  
  command error_t SplitControlCapture.stop[radio_id_t radio]() {
    signal SplitControlCapture.stopDone[radio](SUCCESS);
    return SUCCESS;
  }
  
  /***************** SendCapture Commands ****************/
  command error_t SendCapture.send[radio_id_t radio](message_t* msg, uint8_t len) {
    if(call State.isState(S_SENDDEFAULTMSG)) {
      assertEquals("Wrong send radio", CC1100_RADIO_ID, radio);
      // Continues at AMSend.sendDone...
    }
    
    
    signal SendCapture.sendDone[radio](msg, SUCCESS);
    return SUCCESS;    
  }

  command error_t SendCapture.cancel[radio_id_t radio](message_t* msg) {
    return SUCCESS;   
  }

  command uint8_t SendCapture.maxPayloadLength[radio_id_t radio]() {
    return TOSH_DATA_LENGTH;
  }

  command void *SendCapture.getPayload[radio_id_t radio](message_t* msg, uint8_t len) {
    return msg->data;
  }
}
