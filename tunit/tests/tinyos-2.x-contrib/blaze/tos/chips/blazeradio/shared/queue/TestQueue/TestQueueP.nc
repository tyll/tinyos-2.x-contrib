
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
    
    interface TestCase as TestSingleMessage;
    //interface TestCase as TestMultipleMessages;
    //interface TestCase as TestTooManyMessages;
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
    
  };
  
  /***************** Local Test Variables ****************/ 
  norace message_t myMsg[QUEUE_SIZE + 1];
  norace uint8_t values[] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 
  	0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
  norace uint8_t index;
  norace uint8_t g_amid;
  norace message_t* g_msg;
  norace uint8_t g_idIndex;
  
  void clrMsg(message_t* msg);
  task void signalDone();
  task void successDone();
  
  /***************** SetUp Events ****************/
  event void SetUp.run() {
    call SetUp.done();
  }




  /***************** TestCases ****************/
  /**
   * Test and make sure the defaults work on the parameterized AmRegistry interface
   */
  event void TestSingleMessage.run() {
  
    call State.forceState(S_TESTSINGLE);
    g_idIndex = 0x55;
    index = 0;
    clrMsg(&(myMsg[index]));
    call AMSend.send[g_idIndex](0, &myMsg[index], 15);
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
    if((amId > 0x54) && (amId < 0x59)){ 
      //assertEquals("val 1: ", 0x01, vals[0]); 
      //assertEquals("val 2: ", 0x02, vals[1]); 
      //assertEquals("val 3: ", 0x03, vals[2]); 
      //assertEquals("val 4: ", 0x04, vals[3]); 
      //assertEquals("val 5: ", 0x05, vals[4]); 
      //assertEquals("val 6: ", 0x06, vals[5]); 
      //assertEquals("val 7: ", 0x07, vals[6]); 
      //assertEquals("val 8: ", 0x08, vals[7]); 
      //assertEquals("val 9: ", 0x09, vals[8]); 
      //assertEquals("val 10: ", 0x0a, vals[9]); 
      //assertEquals("val 11: ", 0x0b, vals[10]); 
      //assertEquals("val 12: ", 0x0c, vals[11]); 
      //assertEquals("val 13: ", 0x0d, vals[12]); 
      //assertEquals("val 14: ", 0x0e, vals[13]); 
      //assertEquals("val 15: ", 0x0f, vals[14]);
    }else{
      //assertEquals("val 1: ", 0, vals[0]); 
      //assertEquals("val 2: ", 0, vals[1]); 
      //assertEquals("val 3: ", 0, vals[2]); 
      //assertEquals("val 4: ", 0, vals[3]); 
      //assertEquals("val 5: ", 0, vals[4]); 
      //assertEquals("val 6: ", 0, vals[5]); 
      //assertEquals("val 7: ", 0, vals[6]); 
      //assertEquals("val 8: ", 0, vals[7]); 
      //assertEquals("val 9: ", 0, vals[8]); 
      //assertEquals("val 10: ", 0, vals[9]); 
      //assertEquals("val 11: ", 0, vals[10]); 
      //assertEquals("val 12: ", 0, vals[11]); 
      //assertEquals("val 13: ", 0, vals[12]); 
      //assertEquals("val 14: ", 0, vals[13]); 
      //assertEquals("val 15: ", 0, vals[14]);
    }
    if(call State.getState() == S_TESTSINGLE){
      if(g_idIndex < (0x58 + 1)){
        g_idIndex++;
        index++;
        clrMsg(&myMsg[index]);
        call AMSend.send[g_idIndex](0, &myMsg[index], 15);   
      }else{
        call State.toIdle();
        assertEquals("Times run: ", 4, index);
        call TestSingleMessage.done();
      }
    }else if(call State.getState() == S_TESTMULTIPLE){
      
    }else if(call State.getState() == S_TESTTOOMANY){
    
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

    g_amid = id;
    g_msg = msg;
    post signalDone();
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
}


