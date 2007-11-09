
#include "TestCase.h"
#include "IEEE802154.h"
#include "priority.h"


/**
 * @author David Moss
 */

module TestQueueP {
  provides {
    interface AMSend as SubSend[ am_id_t amId ];
  }
  
  uses {
    interface AMSend[radio_id_t radioId];
    
    interface State;
    
    interface TestControl as SetUp;
    
    interface TestCase as TestMultipleMessages;
    interface Leds;
    interface AmRegistry as AM55;
    interface AmRegistry as AM56;
    interface AmRegistry as AM57;
    interface AmRegistry as AM58;
    
  }
    
}

implementation {

  /**
   * Test States
   */
  enum {
    S_IDLE,
    S_TESTSINGLE,
    S_TESTMULTIPLE,
    S_TESTTOOMANY,
  };

  enum {
    PRIORITY55 = P_1,
    PRIORITY56 = P_2,
    PRIORITY57 = P_3,
    PRIORITY58 = P_HIGHEST,
    NUM_MSG = 5,
  };
  
  /***************** Local Test Variables ****************/ 
  norace message_t myMsg[NUM_MSG];
  norace uint8_t values[] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 
  	0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
  norace uint8_t index;
  norace uint8_t g_amid;
  norace message_t* g_msg;
  norace uint8_t g_idIndex;
  norace uint8_t order[] = {0x55, 0x58, 0x57, 0x56, 0x59};
  bool done;
  
  void clrMsg(message_t* msg);
  task void signalDone();
  task void successDone();
  task void doneTask();
  task void checkDone();
  
  /***************** SetUp Events ****************/
  event void SetUp.run() {
    call SetUp.done();
  }




  /***************** TestCases ****************/
  /**
   * Test and make sure the defaults work on the parameterized AmRegistry interface
   */
  event void TestMultipleMessages.run() {
  
    call State.forceState(S_TESTMULTIPLE);
    g_idIndex = 0x55;
    index = 0;
    done = FALSE;
    for(index = 0; index < NUM_MSG; index++){
      clrMsg(&(myMsg[index]));
      call AMSend.send[0x55 + index](0, &myMsg[index], 15);
    }   
    index = 0;
    done = TRUE;
  }
  
  /**
   * Test and make sure the message_t metadata gets filled in correctly
   */
   /*
  event void TestMultipleMessages.run() {
    
    //call State.forceState(S_TESTMULTIPLE);
    assertEquals("nothing: ", 0, 0);
    call TestMultipleMessages.done();
  }
  
  event void TestTooManyMessages.run(){
  
    //call State.forceState(S_TESTTOOMANY);
    assertEquals("nothing: ", 0, 0);
    call TestTooManyMessages.done();
  }
  */
  /*************** AMSend events *************************/
  event void AMSend.sendDone[ am_id_t amId ](message_t* msg, error_t error){
  
    uint8_t *vals;
    vals = (uint8_t*)msg;
    order[index] = amId;
    index++;
    
    if(call State.getState() == S_TESTMULTIPLE){
      if(amId == 0x59){
        post doneTask();
      }
    } 
  }

  /***************** AmRegistry events ******************/
  event void AM55.configure(message_t* msg){
    
    memcpy(msg, &values, 15);
    
    call AM55.configureDone(msg, PRIORITY55);
  
  }
  
  event void AM56.configure(message_t* msg){
    
    memcpy(msg, &values, 15);
    
    call AM56.configureDone(msg, PRIORITY56);
  
  }
  
  event void AM57.configure(message_t* msg){
    
    memcpy(msg, &values, 15);
    
    call AM57.configureDone(msg, PRIORITY57);
  
  }
  
  event void AM58.configure(message_t* msg){
    
    memcpy(msg, &values, 15);
    
    call AM58.configureDone(msg, PRIORITY58);
  
  }
  
  /***************** SubSend Interface Implementation ****************/
  
  command error_t SubSend.send[am_id_t id](am_addr_t addr, message_t* msg, uint8_t len) {
    
    if(!done){
      g_amid = id;
      g_msg = msg;
      post checkDone();
    }else{
      signal SubSend.sendDone[ id ](msg, SUCCESS);
    }
    return SUCCESS;
  }

  command error_t SubSend.cancel[am_id_t id](message_t* msg) {
    return FAIL;
  }

  command uint8_t SubSend.maxPayloadLength[am_id_t id]() {
    return 0;
  }

  command void* SubSend.getPayload[am_id_t id](message_t* msg, uint8_t len) {
    return NULL;
  }
  
  /************** Tasks *****************************/
  task void successDone(){
    //call TestSuccess.done();
  }
  
  task void signalDone(){
    signal SubSend.sendDone[ g_amid ](g_msg, SUCCESS);
  }
  
  void clrMsg(message_t* msg){
  
    uint8_t i;
    uint8_t* val;
    val = (uint8_t*)msg;
    for(i = 0; i < 15; i++){
      val[i] = 0;
    }
  }
  
  task void checkDone(){
    if(!done){
      post checkDone();
    }
    signal SubSend.sendDone[g_amid](g_msg, SUCCESS);
  }
  
  task void doneTask(){
    assertEquals("first: ", 0x55, order[0]);
    assertEquals("second: ", 0x58, order[1]);
    assertEquals("third: ", 0x57, order[2]);
    assertEquals("fourth: ", 0x56, order[3]);
    assertEquals("fifth: ", 0x59, order[4]);
    call TestMultipleMessages.done();
    
  }
}


