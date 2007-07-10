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
 * Date last modified:  7/15/02
 *
 * MotorBoardTopTest is intended to be the application layer for the MotorBoard
 * software.  It is essentially a large case statement that calls the
 * appropriate functions based on the incoming packet command.
 *
 */

includes MotorBoard;

module MotorBoardTopTestCommM {
  provides interface StdControl;
  uses {
    interface StdControl as CommControl;
    interface MotorSendMsg as Send;
    interface MotorReceiveMsg as Receive;

    interface Clock;
    interface HPLMotor as HPLMotor1;
    interface HPLMotor as HPLMotor2;
    interface Leds;

  }
}
implementation
{
  MOTOR_Msg buffer;
  MOTOR_MsgPtr bufferPtr;
  bool receivePending;
  bool sendPending;

  uint8_t ticks;

  command result_t StdControl.init() {
    // Initialize all interfaces here
    bufferPtr = &buffer;
    sendPending = FALSE;
    receivePending = FALSE;
    call CommControl.init();
    call HPLMotor1.init();
    call HPLMotor2.init();
    call Leds.init();
    ticks = 0;
    return SUCCESS;
  }

  command result_t StdControl.start() {
    // Debug statements to send out message at beginning
    bufferPtr->addr = 2;
    bufferPtr->type = MICA_LED_TOGGLE;
    //bufferPtr->length = 3;
    call Clock.setRate(4,5);  // fire ~ 2 times/sec for a 2MHz clock
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    call Clock.setRate(0,0);
    return SUCCESS;
  }

  event result_t Clock.fire() {
    ticks ^= 0x01;
    if (!sendPending) {
      call Send.send(bufferPtr);
      sendPending = TRUE;
    }
    call HPLMotor1.setSpeed(150);
    call HPLMotor2.setSpeed(150);
    if (ticks == 1) {
      call HPLMotor1.setDir(1);
      call HPLMotor2.setDir(1);
      call Leds.redOn();
    } else {
      call HPLMotor1.setDir(0);
      call HPLMotor2.setDir(0);
      call Leds.redOff();
    }

    return SUCCESS;
  }

  event MOTOR_MsgPtr Receive.receive(MOTOR_MsgPtr data) {
    // Receive the packet, store it in our buffer and return the oldest message
    MOTOR_MsgPtr tmpMsg = data;

    if (data->type == LED_TOGGLE)
      call Leds.redToggle();

    /* Echo Message for Debugging
    if (!sendPending) {
      call Send.send(bufferPtr);
      sendPending = TRUE;
    }
    */

    return tmpMsg;
  }

  event result_t Send.sendDone(MOTOR_MsgPtr msg, result_t success) {
    sendPending = FALSE;
    return success;
  }

  event result_t Servo.debug(uint16_t data) {
    return SUCCESS;
  }
  
}  
