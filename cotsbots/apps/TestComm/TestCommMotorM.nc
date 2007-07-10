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
 * Date last modified:  10/9/2003
 *
 */

/**
 * TestComm provides a test platform for sending and receiving motor packets.
 * This program runs on the mica(2) mote and sends messages to the motor
 * board periodically telling it to turn on its LED.  The mica's green
 * led toggles whenever it sends a packet.  The red led toggles when it
 * receives a packet.
 *
 * @author Sarah Bergbreiter
 **/

includes MotorBoard;

module TestCommMotorM {
  provides interface StdControl;
  uses {
    interface Clock;
    interface MotorSendMsg as Send;
    interface MotorReceiveMsg as Receive;
    interface StdControl as CommControl;
    interface Leds;
  }
}
implementation
{
  MOTOR_Msg buffer;
  MOTOR_MsgPtr bufferPtr;
  bool sendPending;

  /**
   * Initialize the component.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.init() {
    atomic {
      sendPending = FALSE;
      bufferPtr = &buffer;
    }
    bufferPtr->addr = 0x01;
    bufferPtr->type = MICA_LED_TOGGLE;
    return call CommControl.init();
  }

  /**
   * Start the component. If the clock is used, it will be initialized here.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.start() {
    call Clock.setRate(30,4); // About 1/sec
    return call CommControl.start();
  }

  /**
   * Stop component.  Not really implemented.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.stop() {
    call Clock.setRate(0,0);
    return call CommControl.stop();
  }

  task void sendMsg() {
    bool sp, ret;
    atomic {
      sp = sendPending;
    }
    if (!sp) {
      atomic {
	ret = call Send.send(bufferPtr);
      }
      if (ret) {
	atomic {
	  sendPending = TRUE;
	  call Leds.redToggle();
	}
      }
    }	
  }

  async event result_t Clock.fire() {
    /* Send Message to Motor Board */
    post sendMsg();

    return SUCCESS;
  }

  /**
   * Handle the MotorSend Done event. Toggle green LED to indicate msg sent.
   * @return Always returns <code>SUCCESS</code>
   **/
  event result_t Send.sendDone(MOTOR_MsgPtr msg, result_t success) {
    atomic {
      sendPending = FALSE;
    }
    //if (success)
    //call Leds.redToggle();

    return SUCCESS;
  }

  /**
   * Toggle a red LED to indicate that a motor message has been received.
   * Package the received message into a TOS packet and forward.
   * @return Always returns <code>SUCCESS</code>
   **/
  event MOTOR_MsgPtr Receive.receive(MOTOR_MsgPtr data) {
    call Leds.redToggle();
    return data;
  }

}  
