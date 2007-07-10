// $Id$

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */


/*
 *
 * Authors:		Sarah Bergbreiter
 * Date last modified:  10/8/2003
 ********** Still need to complete slave functionality for receive
 *
 */

/**
 * Provides functionality for writing and reading motor packets on the I2C bus
 * Doesn't deal with Master Receive or Slave Transmit modes...
 * Yellow LED: Toggles every time I start send a message successfully
 * Green LED: Toggles every time I've sent a send done
 * Red LED: Toggles when I start reading data as a slave
 * 
 * @author Sarah Bergbreiter
 */
includes MotorBoard;

module I2CMotorPacketM
{
  provides {
    interface StdControl;
    interface MotorSendMsg as Send;
    interface MotorReceiveMsg as Receive;
  }
  uses {
    interface I2C;
    interface StdControl as I2CStdControl;
    interface Leds;
  }
}

implementation {

  /* state of the i2c request  */
  enum {IDLE=99,
        I2C_START_COMMAND=1,
        I2C_STOP_COMMAND=2,
        I2C_STOP_COMMAND_SENT=3,
        I2C_WRITE_ADDRESS=10,
        I2C_WRITE_DATA=11,
        I2C_READ_ADDRESS=20,
        I2C_READ_DATA=21,
	I2C_READ_DONE=22,
        I2C_GOT_W_REQ=30,
        I2C_GOT_W_DATA=31,
        I2C_GOT_R_REQ=40,
        I2C_GOT_R_DATA=41};

  /**
   *  packet to write to/ read from the i2c bus 
   */
  MOTOR_Msg buffer[2];
  MOTOR_MsgPtr bufferPtr[2];
  uint8_t bufferIndex;
  uint8_t* sendPtr;
  uint8_t* recPtr;

  /**
   * current index of read/write byte 
   */
  uint8_t sendIndex;    
  uint8_t receiveIndex;

  /** 
   * current state of the i2c request 
   */
  char state;    

  /**
   * initialize the I2C bus and set initial state
   */
  command result_t StdControl.init() {
    call I2CStdControl.init();
    atomic {
      state = IDLE;
      sendIndex = 0;
      receiveIndex = 0;
      bufferIndex = 0;
      bufferPtr[0] = &buffer[0];
      bufferPtr[1] = &buffer[1];
      recPtr = (uint8_t*)bufferPtr[0];
    }
    return SUCCESS;
  }

  /**
   * start the component 
   **/
  command result_t StdControl.start() {
    return call I2CStdControl.start();
  }

  /**
   * stop the component
   **/
  command result_t StdControl.stop() {
    return call I2CStdControl.stop();
  }

  /**
   * Writes a Motor packet out to the I2C bus 
   *
   * @param msg pointer to Motor_Msg to be sent
   *
   * @return returns SUCCESS if the bus is free and the request is accepted.
   */
  command result_t Send.send(MOTOR_MsgPtr msg) {
    char s;
    atomic {
      s = state;
    }
    if (s == IDLE) {
      atomic {
	/*  reset variables  */
	sendPtr = (uint8_t*) msg;
	sendIndex = 0;
      }
    } else {
      return FAIL;
    }
    
    atomic {
      state = I2C_WRITE_ADDRESS;
    }
    if (call I2C.sendStart()) {
      return SUCCESS;
    } else {
      atomic {
	state = IDLE;
      }
      return FAIL;
    }
  }
  
  /**
   * notification that the start symbol was sent 
   **/
  async event result_t I2C.sendStartDone() {
  //event result_t I2C.sendStartDone() {
    char s;
    atomic {
      s = state;
    }
    if(s == I2C_WRITE_ADDRESS){
      atomic {
	state = I2C_WRITE_DATA;
      }
      // Write SLA+W packet
      if (call I2C.write((sendPtr[0] << 1) + 0)) {
	return SUCCESS;
      }
    }
    return SUCCESS;
  }

  task void sendSuccessComplete() {
    uint8_t *msg;
    atomic {
      msg = sendPtr;
    }
    signal Send.sendDone((MOTOR_MsgPtr)msg, SUCCESS);
  }

  task void sendFailComplete() {
    uint8_t *msg;
    atomic {
      msg = sendPtr;
    }
    signal Send.sendDone((MOTOR_MsgPtr)msg, FAIL);
  }

  /**
   * notification that the stop symbol was sent 
   **/
  async event result_t I2C.sendEndDone() {
    uint8_t s;
    atomic {
      s = state;
    }
    if (s == I2C_STOP_COMMAND_SENT) {
      /* success! */
      atomic {
	state = IDLE;
      }
      post sendSuccessComplete();
    }
    return SUCCESS;
  }

  /**
   * notification of a byte sucessfully written to the bus 
   **/
  async event result_t I2C.writeDone(bool result) {
    char s;
    uint8_t si;
    bool done = FALSE;
    result_t ret = FALSE;
    atomic {
      s = state;
      si = sendIndex;
    }
    if(result == FALSE) {
      atomic {
	state = IDLE;
      }
      call I2C.sendEnd();
      post sendFailComplete();
      return FAIL;
    }

    if ((s == I2C_WRITE_DATA) && (si < (MOTORMsgLength-1))) {
      atomic {
        sendIndex++;
	done = (sendIndex == (MOTORMsgLength-1));
      }
      if (done) {
	atomic {
	  state = I2C_STOP_COMMAND;
	}
      }
      atomic {
	ret = call I2C.write(sendPtr[sendIndex]);
      }
      return ret;

    } else if (s == I2C_STOP_COMMAND) {
      atomic {
        state = I2C_STOP_COMMAND_SENT;
	ret = call I2C.sendEnd();
      }
      return ret;
    }

    return SUCCESS;
  }


  async event result_t I2C.readDone(bool success, char data) {
    return SUCCESS;
  }

  /**
   * I have been addressed -- reset reading stuff and go into READING state
   **/
  async event result_t I2C.gotWriteRequest(bool success) {
    if (success == FALSE) return FAIL;
    atomic {
      state = I2C_GOT_W_REQ;
      receiveIndex = 1;
    }
    // make sure I'm returning ACKs
    return call I2C.read(TRUE);
  }

  /**
   * read a byte off the bus and add it to the packet 
   **/
  async event result_t I2C.gotWriteData(bool success, uint8_t value) {
    if (success == FALSE) {
      atomic {
	state = IDLE;
      }
      return FAIL;
    }

    atomic {
      state = I2C_GOT_W_DATA;
      if (receiveIndex < MOTORMsgLength) {
	recPtr[receiveIndex++] = value;
      }
    }

    return call I2C.read(TRUE);
  }

  task void readDone() {
    MOTOR_MsgPtr tmp;
    atomic {
      tmp = bufferPtr[bufferIndex ^ 0x01];
    }
    tmp = signal Receive.receive(tmp);
    if (tmp) {
      atomic {
	bufferPtr[bufferIndex ^ 0x01] = tmp;
      }
    }
  }

  /**
   * stop signal received -- state is now idle
   **/
  async event result_t I2C.gotStop() {
    atomic {
      bufferPtr[bufferIndex]->addr = TOS_LOCAL_ADDRESS;
      bufferIndex ^= 0x01;
      recPtr = (uint8_t *)bufferPtr[bufferIndex];
      receiveIndex = 1;
      state = IDLE;
    }
    post readDone();
    return SUCCESS;
  }

  async event result_t I2C.gotReadRequest(bool success) {
    if (success == FALSE) return FAIL;
    atomic {
      state = I2C_GOT_R_REQ;
    }
    return SUCCESS;
  }

  async event result_t I2C.sentReadData(bool success) {
    if (success == FALSE) return FAIL;
    atomic {
      state = I2C_GOT_R_DATA;
    }
    return SUCCESS;
  }

  async event result_t I2C.sentReadDone(bool success) {
    return success;
  }

  // Error.  Reset it all.
  async event result_t I2C.gotError() {
    state = IDLE;
    return FAIL;
  }

  default event MOTOR_MsgPtr Receive.receive(MOTOR_MsgPtr m) {
    return m;
  }

  default event result_t Send.sendDone(MOTOR_MsgPtr m, bool result) {
    return SUCCESS;
  }

}

