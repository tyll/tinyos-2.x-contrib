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
 * Date last modified:  8/6/02
 *
 */

/**
 * Implementation for the TestMotorBoard application. TestMotorBoard is 
 * intended to provide a test platform for sending commands to the motor 
 * board.  It has a radio interface where instructions can be sent in 
 * standard TOS packets and then sent to the motor board in MOTOR packets.
 *
 * @author Sarah Bergbreiter
 **/

includes MotorBoard;
includes RobotCmdMsg;
includes NavigationMsg;

module TestMotorBoardM {
  provides interface StdControl;
  uses {
    interface StdControl as CommControl;
    interface MotorSendMsg as Send;
    interface MotorReceiveMsg as Receive;
    interface Leds;
    interface ReceiveMsg;
    interface SendMsg;
    interface StdControl as RadioControl;
    interface StdControl as Figure8Control;
    interface Figure8Calibration;
  }
}
implementation
{
  MOTOR_Msg buffer;
  MOTOR_MsgPtr bufferPtr;
  TOS_Msg radioBuffer;
  TOS_MsgPtr radioBufferPtr;
  bool sendPending;
  bool radioSendPending;
  uint8_t accelBuffer[2][28];
  uint8_t accelPtr;
  uint8_t currentAccelBuffer;

  /**
   * Initialize the component.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.init() {
    bufferPtr = &buffer;
    radioBufferPtr = &radioBuffer;
    sendPending = FALSE;
    radioSendPending = FALSE;
    accelPtr = 0;
    currentAccelBuffer = 0;
    return rcombine3(call RadioControl.init(), call Figure8Control.init(), call CommControl.init());
  }

  /**
   * Start the component. If the clock is used, it will be initialized here.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.start() {
    return rcombine(call RadioControl.start(), call CommControl.start());
  }

  /**
   * Stop component.  Not really implemented.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.stop() {
    return rcombine3(call RadioControl.stop(), call Figure8Control.stop(), call CommControl.stop());
  }

  /**
   * Receive a radio packet, convert it to a motor packet and send.
   * @return Always returns <code>SUCCESS</code>
   **/
  event TOS_MsgPtr ReceiveMsg.receive(TOS_MsgPtr msg) {
    RobotCmdMsg *message = (RobotCmdMsg *)msg->data;

    uint8_t i;

    switch (message->type) {
    case MICA_LED_TOGGLE:
        call Leds.yellowToggle();
        return msg;
    case START_FIGURE8:
        call Figure8Control.start();
        return msg;
    case STOP_FIGURE8:
        call Figure8Control.stop();
        return msg;
    case SET_TURN12:
        call Figure8Calibration.setRightTurn(message->data[0]);
        call Figure8Calibration.setStraight1Turn(message->data[1]);
        return msg;
    case SET_TURN34:
        call Figure8Calibration.setLeftTurn(message->data[0]);
        call Figure8Calibration.setStraight2Turn(message->data[1]);
        return msg;
    case SET_FIGURE8_SPEED:
        call Figure8Calibration.setSpeed(message->data[0]);
        return msg;
    case STOP_ACCEL:
	accelPtr = 0;
	currentAccelBuffer = 0;
	break;
    }

    bufferPtr->addr = 0;
    bufferPtr->type = message->type;
    for (i = 0; i < MOTORDataLength; i++)
      bufferPtr->data[i] = message->data[i];

    /* Send Message to Motor Board */
    if (!sendPending) {
      if (call Send.send(bufferPtr)) {
        sendPending = TRUE;
      }
    }

    return msg;    
  }

  /**
   * Handle the MotorSend Done event. Toggle green LED to indicate msg sent.
   * @return Always returns <code>SUCCESS</code>
   **/
  event result_t Send.sendDone(MOTOR_MsgPtr msg, result_t success) {
    sendPending = FALSE;
    if (success)
      call Leds.greenToggle();
    return SUCCESS;
  }

  /**
   * Toggle a red LED to indicate that a motor message has been received.
   * Package the received message into a TOS packet and forward.
   * @return Always returns <code>SUCCESS</code>
   **/
  event MOTOR_MsgPtr Receive.receive(MOTOR_MsgPtr data) {
    RobotCmdMsg *message = (RobotCmdMsg *)radioBufferPtr->data;
    uint8_t i;

    call Leds.redToggle();

    if (data->type == MICA_LED_TOGGLE) {
      call Leds.yellowToggle();
      return data;
    } else if (data->type == MICA_LED_ON) {
      call Leds.yellowOn();
      return data;
    } else if (data->type == MICA_LED_OFF) {
      call Leds.yellowOff();
      return data;
    } else if (data->type == ACCEL_READING) {
      // packetize and send
      accelBuffer[currentAccelBuffer][2*accelPtr] = data->data[0];
      accelBuffer[currentAccelBuffer][2*accelPtr+1] = data->data[1];
      if (accelPtr == 13) {
        RobotAccelMsg *msg = (RobotAccelMsg *)radioBufferPtr->data;
        msg->type = data->type;
        for (i = 0; i < 28; i++)
          msg->data[i] = accelBuffer[currentAccelBuffer][i];        
        currentAccelBuffer ^= 0x01;
        if (!radioSendPending) {
          if (call SendMsg.send(TOS_BCAST_ADDR, 29, radioBufferPtr)) {
            call Leds.yellowToggle();
            radioSendPending = TRUE;
          }
        }
      }
      accelPtr++;
      if (accelPtr == 14) accelPtr = 0;
      return data;
    }

    /* Send Message to the base station */
    message->type = data->type;
    for (i = 0; i < MOTORDataLength; i++)
      message->data[i] = data->data[i];
    if (!radioSendPending) {
      if (call SendMsg.send(TOS_BCAST_ADDR, 1+MOTORDataLength, radioBufferPtr)) {
        radioSendPending = TRUE;
      }
    }

    return data;
  }

  /**
   * Handle the TOS SendDone event.
   * @return Always returns <code>SUCCESS</code>
   **/
  event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success) {
    radioSendPending = FALSE;
    return SUCCESS;
  }

}  
