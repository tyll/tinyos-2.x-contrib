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

module TestCommM {
  provides interface StdControl;
  uses {
    interface StdControl as TimerControl;
    interface Timer;
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
    bufferPtr = &buffer;
    bufferPtr->addr = 0x00;
    bufferPtr->type = LED_TOGGLE;
    sendPending = FALSE;
    return rcombine(call TimerControl.init(), call CommControl.init());
  }

  /**
   * Start the component. If the clock is used, it will be initialized here.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.start() {
    call Timer.start(TIMER_REPEAT, 1000);
    return call CommControl.start();
  }

  /**
   * Stop component.  Not really implemented.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.stop() {
    call Timer.stop();
    return call CommControl.stop();
  }

  event result_t Timer.fired() {
    /* Send Message to Motor Board */
    if (!sendPending) {
      if (call Send.send(bufferPtr)) {
	call Leds.yellowToggle();
	sendPending = TRUE;
	return SUCCESS;
      }
    }

    return FAIL;
  }

  /**
   * Handle the MotorSend Done event. Toggle green LED to indicate msg sent.
   * @return Always returns <code>SUCCESS</code>
   **/
  event result_t Send.sendDone(MOTOR_MsgPtr msg, result_t success) {
    if (success)
      call Leds.greenToggle();
    else
      call Leds.redToggle();
    sendPending = FALSE;
    return SUCCESS;
  }

  /**
   * Toggle a red LED to indicate that a motor message has been received.
   * Package the received message into a TOS packet and forward.
   * @return Always returns <code>SUCCESS</code>
   **/
  event MOTOR_MsgPtr Receive.receive(MOTOR_MsgPtr data) {
    //call Leds.redToggle();
    return data;
  }

}  
