/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * TUnitProcessing Communication Link with the computer
 * @author David Moss
 */
 
#include "Link_TUnitProcessing.h"

module Link_TUnitProcessingP {
  uses {
    interface TUnitProcessing;
    
    interface Boot;
    interface AMSend as SerialEventSend;
    interface Receive as SerialReceive;
    interface SplitControl as SerialSplitControl;
    interface State as SerialState;
    interface State as SendState;
  }
}

implementation {

  /** Message to signal events */
  message_t eventMsg[MAX_TUNIT_QUEUE];
  
  /** Next element in our queue available for insertion */
  uint8_t writingEventMsg;
  
  /** Current element in our queue we're sending */
  uint8_t sendingEventMsg;
  
  /**
   * State of our serial port
   */
  enum {
    S_OFF,
    S_ON,
  };
  
  /**
   * State of our communications
   */
  enum {
    S_IDLE,
    S_BUSY,
  };
  
  enum {
    EMPTY = 0xFF,
  };
  
  /***************** Prototypes *****************/
  void execute(TUnitProcessingMsg *inMsg);
  task void sendEventMsg();
  task void allDone();
  
  error_t insert(uint8_t cmd, uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual, uint8_t assertionId);
  void attemptEventSend();
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    int i;
    for(i = 0; i < MAX_TUNIT_QUEUE; i++) {
      ((TUnitProcessingMsg *) call SerialEventSend.getPayload(&eventMsg[i], TOSH_DATA_LENGTH))->cmd = 0xFF;
    }
    atomic writingEventMsg = 0;
    atomic sendingEventMsg = 0;
    call SerialSplitControl.start();
  }
  
  /***************** SerialSplitControl Events ****************/
  event void SerialSplitControl.startDone(error_t error) {
    call SerialState.forceState(S_ON);
  }
  
  event void SerialSplitControl.stopDone(error_t error) {
    call SerialState.forceState(S_OFF);
  }
  
  /***************** Receive Events ****************/
  event message_t *SerialReceive.receive(message_t *msg, void *payload, uint8_t len) {
    execute(payload);
    return msg;
  }
  
  /***************** Send Events ****************/
  event void SerialEventSend.sendDone(message_t *msg, error_t error) {
    atomic {
      ((TUnitProcessingMsg *) (&eventMsg[sendingEventMsg])->data)->cmd = EMPTY;
      sendingEventMsg++;
      sendingEventMsg %= MAX_TUNIT_QUEUE;
    }
    call SendState.toIdle();
    attemptEventSend();
  }
  
  /***************** TUnitProcessing Events ****************/
  async event void TUnitProcessing.testSuccess(uint8_t testId, uint8_t assertionId) {
    insert(TUNITPROCESSING_EVENT_TESTRESULT_SUCCESS, testId, NULL, 0, 0, assertionId);
  }
  
  async event void TUnitProcessing.testEqualsFailed(uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual, uint8_t assertionId) {
    insert(TUNITPROCESSING_EVENT_TESTRESULT_EQUALS_FAILED, testId, failMsg, expected, actual, assertionId);
  }
  
  async event void TUnitProcessing.testNotEqualsFailed(uint8_t testId, char *failMsg, uint32_t actual, uint8_t assertionId) {
    insert(TUNITPROCESSING_EVENT_TESTRESULT_NOTEQUALS_FAILED, testId, failMsg, actual, actual, assertionId);
  }
  
  async event void TUnitProcessing.testResultIsBelowFailed(uint8_t testId, char *failMsg, uint32_t upperbound, uint32_t actual, uint8_t assertionId) {
    insert(TUNITPROCESSING_EVENT_TESTRESULT_BELOW_FAILED, testId, failMsg, upperbound, actual, assertionId);
  }
    
  async event void TUnitProcessing.testResultIsAboveFailed(uint8_t testId, char *failMsg, uint32_t lowerbound, uint32_t actual, uint8_t assertionId) {
    insert(TUNITPROCESSING_EVENT_TESTRESULT_ABOVE_FAILED, testId, failMsg, lowerbound, actual, assertionId);
  }
    
  async event void TUnitProcessing.testFailed(uint8_t testId, char *failMsg, uint8_t assertionId) {
    insert(TUNITPROCESSING_EVENT_TESTRESULT_FAILED, testId, failMsg, 0, 0, assertionId);
  }
  
  
  event void TUnitProcessing.allDone() {
    post allDone();
  }

  event void TUnitProcessing.pong() {
    insert(TUNITPROCESSING_EVENT_PONG, 0xFF, NULL, 0, 0, 0xFF);
  }

  
  /***************** Tasks ****************/  
  task void sendEventMsg() {
    if(call SerialEventSend.send(0, &eventMsg[sendingEventMsg], sizeof(TUnitProcessingMsg)) != SUCCESS) {
      if(call SerialState.getState() == S_OFF) {
        call SerialSplitControl.start();
      }
      post sendEventMsg();
    }
  }
  
  task void allDone() {
    if(insert(TUNITPROCESSING_EVENT_ALLDONE, 0xFF, NULL, 0, 0, 0xFF) != SUCCESS) {
      post allDone();
    }
  }
  
  /***************** Functions ****************/
  void execute(TUnitProcessingMsg *inMsg) {
    switch(inMsg->cmd) {
      case TUNITPROCESSING_CMD_RUN:
        call TUnitProcessing.run();
        break;
        
      case TUNITPROCESSING_CMD_PING:
        call TUnitProcessing.ping();
        break;

      case TUNITPROCESSING_CMD_TEARDOWNONETIME:
        call TUnitProcessing.tearDownOneTime();
        break;
        
      default:
    }
  }
  
  /**
   * Insert an event message into the internal queue to send out serially.
   * The TUnitProcessingMsg.cmd field locks the message.  If that field is 0xFF,
   * then the message is available. Otherwise, the message is in use.
   */
  error_t insert(uint8_t cmd, uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual, uint8_t assertionId) {
    TUnitProcessingMsg *tunitMsg;
    bool failed = (cmd == TUNITPROCESSING_EVENT_TESTRESULT_FAILED)
        || (cmd == TUNITPROCESSING_EVENT_TESTRESULT_EQUALS_FAILED)
        || (cmd == TUNITPROCESSING_EVENT_TESTRESULT_NOTEQUALS_FAILED)
        || (cmd == TUNITPROCESSING_EVENT_TESTRESULT_BELOW_FAILED)
        || (cmd == TUNITPROCESSING_EVENT_TESTRESULT_ABOVE_FAILED);
    
    atomic {
      while(TRUE) {
        if((tunitMsg = (TUnitProcessingMsg *) (&eventMsg[writingEventMsg])->data)->cmd == EMPTY) {

          // Found an available message
          tunitMsg->cmd = cmd;
          tunitMsg->id = testId;
          tunitMsg->failMsgLength = 0;
          tunitMsg->expected = expected;
          tunitMsg->actual = actual;
          tunitMsg->assertionId = assertionId;
          
          memset(tunitMsg->failMsg, 0x0, PROCESSING_MSG_LENGTH);
          
          if(failed && failMsg != NULL) {
            while(*failMsg && tunitMsg->failMsgLength < PROCESSING_MSG_LENGTH) {
              tunitMsg->failMsg[tunitMsg->failMsgLength] = *failMsg++;
              tunitMsg->failMsgLength++;
            }
          }
          
          writingEventMsg++;
          writingEventMsg %= MAX_TUNIT_QUEUE;
          
          if(failed && (failMsg != NULL) && *failMsg) {
            // More failMsg data to send...
            if(((TUnitProcessingMsg *) (&eventMsg[writingEventMsg])->data)->cmd != EMPTY) {
              // And no place to put it, so call this one the last message
              tunitMsg->lastMsg = TRUE;
              break;
            
            } else {
              // The next message in the queue is available, so keep going
              tunitMsg->lastMsg = FALSE;
            }
            
          } else {
            // We're done - no more failMsg to send
            tunitMsg->lastMsg = TRUE;
            break;
          }
          
        } else {
          // No available messages
          attemptEventSend();
          return FAIL;
        }
      }
    }
    
    attemptEventSend();
    return SUCCESS;
  }
  
  /**
   * Attempt to send the next event message from our queue, if the resource
   * is available and we have a message to send
   */
  void attemptEventSend() {
    atomic {
      if(call SendState.isIdle()) {
        // Our resource is available
        if(((TUnitProcessingMsg *) (&eventMsg[sendingEventMsg])->data)->cmd != EMPTY) {
          // And our current message has information to send, so send it now.
          call SendState.forceState(S_BUSY);
          post sendEventMsg();
        }
      }
    }
  }
}
