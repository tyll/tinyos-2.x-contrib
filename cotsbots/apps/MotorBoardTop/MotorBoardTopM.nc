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
 */

/**
 * MotorBoardTop is intended to be the application layer for the MotorBoard
 * software.  It is essentially a large case statement that calls the
 * appropriate functions based on the incoming packet command.
 **/

includes MotorBoard;

module MotorBoardTopM {
  provides interface StdControl;
  uses {
    interface StdControl as CommControl;
    interface MotorSendMsg as Send;
    interface MotorReceiveMsg as Receive;

    interface StdControl as MotorTest;
    interface HPLMotor as Motor1;
    interface HPLMotor as Motor2;
    interface Servo;
    interface ServoCalibration;
    interface Leds;
    interface MotorAccel;
  }
}
implementation
{
  MOTOR_Msg buffer;
  MOTOR_MsgPtr bufferPtr;
  MOTOR_Msg dataBuffer;
  MOTOR_MsgPtr dataBufferPtr;
  bool receivePending;
  bool sendPending;
  uint16_t accelCnt;
  uint16_t prevAccel;
  uint8_t turnCnt;

  /**
   * Initialize the component.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.init() {
    bufferPtr = &buffer;
    dataBufferPtr = &dataBuffer;
    sendPending = FALSE;
    receivePending = FALSE;
    accelCnt = 0;
    call CommControl.init();
    call MotorAccel.init();
    call MotorTest.init();
    call Motor1.init();
    call Motor2.init();
    call Servo.init();
    call Leds.init();
    return SUCCESS;
  }

  /**
   * Currently does nothing.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.start() {
    return call CommControl.start();
  }

  /**
   * Currently does nothing.
   * @return Always returns <code>SUCCESS</code>
   **/
  command result_t StdControl.stop() {
    // Debug statements to send out message at beginning
    return call CommControl.stop();
  }

  /**
   * Evaluate given command.  Constants are listed in 
   * tos/lib/Robot/Motorboard.h.
   * @return Always returns <code>SUCCESS</code>
   **/
  task void evalCommand() {
    bool toSend = FALSE;

    switch(bufferPtr->type) {
    case MOTOR_TEST_START:
      call MotorTest.start();
      break;
    case MOTOR_TEST_STOP:
      call MotorTest.stop();
      break;
    case LED_ON:
      call Leds.redOn();
      break;
    case LED_OFF:
      call Leds.redOff();
      break;
    case LED_TOGGLE:
      call Leds.redToggle();
      break;
    case SET_SPEED:
      call Motor1.setSpeed(bufferPtr->data[0]);
      break;
    case SET_DIRECTION:
      call Motor1.setDir(bufferPtr->data[0]);
      break;
    case SET_TURN:
      call Servo.setTurn(bufferPtr->data[0]);
      break;
    case SET_KP:
      call ServoCalibration.setKp(bufferPtr->data[0]);
      break;
    case SET_KI:
      call ServoCalibration.setKi(bufferPtr->data[0]);
      break;
    case SET_STRAIGHT:
      call ServoCalibration.setStraight(bufferPtr->data[0]);
      break;
    case GET_KP:
      toSend = TRUE;
      dataBufferPtr->type = GET_KP;
      dataBufferPtr->data[0] = call ServoCalibration.getKp();
      break;
    case GET_KI:
      toSend = TRUE;
      dataBufferPtr->type = GET_KI;
      dataBufferPtr->data[0] = call ServoCalibration.getKi();
      break;
    case GET_STRAIGHT:
      toSend = TRUE;
      dataBufferPtr->type = GET_STRAIGHT;
      dataBufferPtr->data[0] = call ServoCalibration.getStraight();
      break;
    case SET_SPEEDTURNDIR:
      call Motor1.setSpeed(bufferPtr->data[0]);
      if (bufferPtr->data[1] & 0x80)
        call Motor1.setDir(FORWARD);
      else
        call Motor1.setDir(REVERSE);
      call Servo.setTurn(0x7f & bufferPtr->data[1]);
      break;
    case GET_SERVODATA:
      call ServoCalibration.setDebug(1);
      break;
    case STOP_SERVODATA:
      call ServoCalibration.setDebug(0);
      break;
    case START_ACCEL:
      call MotorAccel.startSensing();
      break;
    case STOP_ACCEL:
      call MotorAccel.stopSensing();
      break;
    }

    if (toSend) {
      dataBufferPtr->addr = 0;
      if (!sendPending) {
        call Send.send(dataBufferPtr);
        sendPending = TRUE;
      }
    }

    receivePending = FALSE;
  }

  /**
   * Receive debug information from the servo component.  Relay
   * this data on to the mica.
   * @return Always returns <code>SUCCESS</code>
   **/
  event result_t Servo.debug(uint16_t data) {
    dataBufferPtr->addr = 0;
    dataBufferPtr->type = SERVO_DEBUG;
    dataBufferPtr->data[0] = (data >> 8) & 0x03;
    dataBufferPtr->data[1] = data & 0xff;

    if (!sendPending) {
      call Send.send(dataBufferPtr);
      sendPending = TRUE;
    }

    return SUCCESS;
  }


  /**
   * Receive a packet.  Stores new packet in a buffer and returns the oldest
   * message.
   * @return Always returns <code>SUCCESS</code>
   **/
  event MOTOR_MsgPtr Receive.receive(MOTOR_MsgPtr data) {
    MOTOR_MsgPtr tmpMsg = data;

    //call Leds.redToggle();

    /* Call task -- will ignore incoming message if one still processing */
    if (!receivePending) {
      receivePending = TRUE;
      tmpMsg = bufferPtr;
      bufferPtr = data;
      post evalCommand();
    }

    /* Echo Message for Debugging
    if (!sendPending) {
      call Send.send(bufferPtr);
      sendPending = TRUE;
    }
    */

    return tmpMsg;
  }

  /**
   * Handle the Send Done event.  Reset sendPending.
   * @return Always returns <code>SUCCESS</code>
   **/
  event result_t Send.sendDone(MOTOR_MsgPtr msg, result_t success) {
    sendPending = FALSE;
    return success;
  }
  
  event result_t MotorAccel.fire(int16_t x, int16_t y) {
    if (call Motor1.getDir() == FORWARD) {
      if ((x < 218) && (x > 210) && (turnCnt == 0)) { 
        call Leds.redOn(); 
        turnCnt = 50;
        call Motor1.setDir(REVERSE);
        call Servo.setTurn(50);

        dataBufferPtr->addr = 0;
        dataBufferPtr->type = ACCEL_READING;
        //dataBufferPtr->length = 5;
        dataBufferPtr->data[0] = 0xff & (x >> 8);     
        dataBufferPtr->data[1] = 0xff & x;

        if (!sendPending) {
          call Send.send(dataBufferPtr);
          sendPending = TRUE;
        }

      }
    }

    if (turnCnt > 0) {
      turnCnt--;
      if (turnCnt == 0) {
        call Leds.redOff();
        call Servo.setTurn(30);
        call Motor1.setDir(FORWARD);
      }
    }

    prevAccel = x;
    return SUCCESS;
  }

  event result_t MotorAccel.debug(uint16_t x, uint16_t y) {

    dataBufferPtr->addr = 0;
    dataBufferPtr->type = ACCEL_READING;
    dataBufferPtr->data[0] = 0xff & (x >> 8);     
    dataBufferPtr->data[1] = 0xff & x;

    if (!sendPending) {
      call Send.send(dataBufferPtr);
      sendPending = TRUE;
    }

    return SUCCESS;
  }

}  
