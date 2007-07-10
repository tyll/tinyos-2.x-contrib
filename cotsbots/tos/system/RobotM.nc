/*                                                                      tab:4
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
 * Authors:             Sarah Bergbreiter
 * Date last modified:  8/12/02
 *
 * The Robot component is the top-level control for a robot on the mica mote.
 *
 */

includes MotorBoard;

module RobotM {
  provides interface Robot;
  uses {
    interface MotorSendMsg as Send;
    interface MotorReceiveMsg as Receive;
    interface StdControl as CommControl;
  }
}
implementation {

  MOTOR_Msg buffer[2];
  MOTOR_MsgPtr bufferPtr[2];
  uint8_t currentBuffer;
  bool sendPending;
  bool sendCurrentBuffer;

  /* Initialize the communication */
  command result_t Robot.init() {
    bufferPtr[0] = &buffer[0];
    bufferPtr[1] = &buffer[1];
    currentBuffer = 0;
    sendPending = FALSE;
    sendCurrentBuffer = FALSE;
    call CommControl.init();
    return call CommControl.start();
  }

  /* Send message to motor board */
  void SendMsg() {
    if (!sendPending) {
      if (call Send.send(bufferPtr[currentBuffer])) {
        currentBuffer ^= 0x01;
        sendPending = TRUE;
      }
    } else {
      sendCurrentBuffer = TRUE;
    }
  }

  /* Set the robot speed */
  command result_t Robot.setSpeed(uint8_t speed) {
    bufferPtr[currentBuffer]->addr = 0;
    bufferPtr[currentBuffer]->type = SET_SPEED;
    //bufferPtr[currentBuffer]->length = 4;
    bufferPtr[currentBuffer]->data[0] = speed;
    SendMsg();

    return SUCCESS;
  }

  /* Set the robot direction */
  command result_t Robot.setDir(uint8_t dir) {
    bufferPtr[currentBuffer]->addr = 0;
    bufferPtr[currentBuffer]->type = SET_DIRECTION;
    //bufferPtr[currentBuffer]->length = 4;
    bufferPtr[currentBuffer]->data[0] = dir;
    SendMsg();

    return SUCCESS;
  }

  /* Set the robot turn */
  command result_t Robot.setTurn(uint8_t turn) {
    bufferPtr[currentBuffer]->addr = 0;
    bufferPtr[currentBuffer]->type = SET_TURN;
    //bufferPtr[currentBuffer]->length = 4;
    bufferPtr[currentBuffer]->data[0] = turn;
    SendMsg();

    return SUCCESS;
  }

  /* Set the robot speed turn and direction all at once */
  command result_t Robot.setSpeedTurnDirection(uint8_t speed, uint8_t turn, uint8_t dir) {
    bufferPtr[currentBuffer]->addr = 0;
    bufferPtr[currentBuffer]->type = SET_SPEEDTURNDIR;
    //bufferPtr[currentBuffer]->length = 5;
    bufferPtr[currentBuffer]->data[0] = speed;
    bufferPtr[currentBuffer]->data[1] = turn;
    if (dir == FORWARD)
      bufferPtr[currentBuffer]->data[1] |= 0x80;
    SendMsg();

    return SUCCESS;
  }

  /**
   * Handle the MotorSend Done event. Toggle green LED to indicate msg sent.
   * @return Always returns <code>SUCCESS</code>
   **/
  event result_t Send.sendDone(MOTOR_MsgPtr msg, result_t success) {
    sendPending = FALSE;
    if (sendCurrentBuffer) {
      sendCurrentBuffer = FALSE;
      SendMsg();
    }
    return success;
  }

  /**
   * Handle the Motor Receive event.
   * @return Always returns <code>SUCCESS</code>
   **/
  event MOTOR_MsgPtr Receive.receive(MOTOR_MsgPtr data) {
    return data;
  }
 

}
