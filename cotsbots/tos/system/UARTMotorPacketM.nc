/*									tab:4
 *
 *
 * "Copyright (c) 2002 and The Regents of the University 
 * of California.  All rights reserved.
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
 * Authors:		Sarah Bergbreiter
 * Date last modified:  7/12/02
 *
 * This component handles the packet abstraction on the motor board UART
 * Comm stack.
 *
 */

includes MotorBoard;

module UARTMotorPacketM {
  provides {
    interface StdControl as Control;
    interface MotorSendMsg as Send;
    interface MotorReceiveMsg as Receive;

    command result_t txBytes(uint8_t *bytes, uint8_t numBytes);
    /* Effects: start sending 'numBytes' bytes from 'bytes'
    */
  }
  uses {
    interface ByteComm;
    interface StdControl as ByteControl;
    interface Leds;
  }
}
implementation
{
  uint8_t rxCount, rxLength, txCount, txLength;
  MOTOR_Msg buffers[2];
  MOTOR_Msg* bufferPtrs[2];
  uint8_t bufferIndex;
  uint8_t *recPtr;
  uint8_t *sendPtr;

  enum {
    IDLE,
    PACKET,
    BYTES
  };
  uint8_t state;

  /*
    state == IDLE (0), nothing is being sent
    state == PACKET (1), this level is sending a packet
    state == BYTES (2), this level is just transferring bytes

    The purpose of adding the new state, to simply transfer bytes, is because
    certain applications may want to just send a sequence of bytes without the
    packet abstraction.  One such example is the UART.

   */
  
  /* Initialization of this component */
  command result_t Control.init() {
    atomic {
      recPtr = (uint8_t *)&buffers[0];
      bufferIndex = 0;
      bufferPtrs[0] = &buffers[0];
      bufferPtrs[1] = &buffers[1];

      state = IDLE;
      txCount = rxCount = 0;
      // We will have to change this if moving to variable length
      rxLength = MOTORMsgLength;
      dbg(DBG_BOOT, "Packet handler initialized.\n");
    }
    return call ByteControl.init();
  }

  /* Command to control the power of the network stack */
  command result_t Control.start() {
    // apply your power management algorithm
    return call ByteControl.start();
  }

  /* Command to control the power of the network stack */
  command result_t Control.stop() {
    // apply your power management algorithm
    return call ByteControl.stop();
  }


  /* Command to transmit raw bytes */
  command result_t txBytes(uint8_t *bytes, uint8_t numBytes) {
    uint8_t byteToSend = 0;
    bool sending = FALSE;
    atomic {
      if (txCount == 0)
	{
	  txCount = 1;
	  txLength = numBytes;
	  sendPtr = bytes;
	  byteToSend = sendPtr[0];
	  sending = TRUE;
	}
    }
    if (sending) {
      /* send the first byte */
      if (call ByteComm.txByte(byteToSend)) {
	return SUCCESS;
      } else {
	atomic {
	  txCount = 0;
	}
      }
    }
    return FAIL;
  }

  /* Command to transmit a packet */
  command result_t Send.send(MOTOR_MsgPtr msg) {
    uint8_t oldState;
    uint8_t sendNum;
    uint8_t* packet;
    result_t rval = FAIL;
    atomic {
      oldState = state;
      if (state == IDLE) {
	state = PACKET;
      }
      packet = (uint8_t*)msg;
      sendNum = MOTORMsgLength;
    }
    if (oldState == IDLE) {
      atomic {
	rval = call txBytes(packet, MOTORMsgLength);
      }
    }
    return rval;
  }

  task void sendDoneSuccessTask() {
    MOTOR_MsgPtr msg;
    atomic {
      txCount = 0;
      state = IDLE;
      msg = (MOTOR_MsgPtr)sendPtr;
    }
    signal Send.sendDone(msg,SUCCESS);
  }

  task void sendDoneFailTask() {
    MOTOR_MsgPtr msg;
    atomic {
      txCount = 0;
      state = IDLE;
      msg = (MOTOR_MsgPtr)sendPtr;
    }
    signal Send.sendDone(msg,FAIL);
  }

  void sendComplete(result_t success) {
    uint8_t stateCopy;
    atomic {
      stateCopy = state;
    }
    if (stateCopy == PACKET) {
      if (success) {
	post sendDoneSuccessTask();
      } else {
	post sendDoneFailTask();
      }
    } else {
      atomic {
	state = IDLE;
	txCount = 0;
      }
    }
  }

  /* Byte level component signals it is ready to accept the next byte.
     Send the next byte if there are data pending to be sent */
  async event result_t ByteComm.txByteReady(bool success) {
    uint8_t txC;
    uint8_t txL;
    atomic {
      txC = txCount;
      txL = txLength;
    }
    if (txC > 0) {
	if (!success) {
	    dbg(DBG_ERROR, "TX_packet failed, TX_byte_failed");
	    sendComplete(FAIL);
	} else if (txC < txL) {
	  uint8_t byteToSend;
	  atomic {
	    byteToSend = sendPtr[txC];
	    txCount++;
	  }
	  dbg(DBG_PACKET, "PACKET: byte sent: %x, COUNT: %d\n",
	      sendPtr[txCount], txCount);

	  if (!call ByteComm.txByte(byteToSend))
	    sendComplete(FAIL);
	}
    }
    return SUCCESS;
  }

  async event result_t ByteComm.txDone() {
    bool complete;
    atomic {
      complete = (txCount == txLength);
    }
    if (complete)
      sendComplete(SUCCESS);
    return SUCCESS;
  }

  task void receiveTask() {
    MOTOR_MsgPtr tmp;
    atomic {
      tmp = bufferPtrs[bufferIndex ^ 1];
    }
    tmp = signal Receive.receive(tmp);
    if (tmp) {
      atomic {
	bufferPtrs[bufferIndex ^ 1] = tmp;
      }
    }
  }

  /* The handles the latest decoded byte propagated by the Byte Level
     component*/
  async event result_t ByteComm.rxByteReady(uint8_t data, bool error,
				      uint16_t strength) {
    bool rxDone;

    dbg(DBG_PACKET, "PACKET: byte arrived: %x, COUNT: %d\n", data, rxCount);
    if (error) {
	atomic {
	  rxCount = 0;
	}
	return FAIL;
    }
    atomic {      
      recPtr[rxCount++] = data;
      rxDone = (rxCount == rxLength);
    }

    if (rxDone) {
      atomic {
	bufferIndex = bufferIndex ^ 1;
	recPtr = (uint8_t*)bufferPtrs[bufferIndex];
	dbg(DBG_PACKET, "got packet\n");
	rxCount = 0;
      }
      post receiveTask();
      return FAIL;
    }
    return SUCCESS;
  }

}





