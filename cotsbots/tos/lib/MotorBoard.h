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
 */

/* Message types/commands */
enum {
  MOTOR_TEST_START = 1,
  MOTOR_TEST_STOP = 2,
  LED_ON = 3,
  LED_OFF = 4,
  LED_TOGGLE = 5,
  SET_SPEED = 6,
  SET_DIRECTION = 7,
  SET_TURN = 8,
  ADC_READING = 9,
  GET_ADC_READING = 10,
  SERVO_DEBUG = 13,
  SET_KP = 14,
  SET_KI = 15,
  SET_STRAIGHT = 16,
  START_FIGURE8 = 17,
  STOP_FIGURE8 = 18,
  SET_SPEEDTURNDIR = 19,
  GET_SERVODATA = 20,
  STOP_SERVODATA = 21,
  SET_TURN12 = 22,
  SET_TURN34 = 23,
  ACCEL_READING = 24,
  START_ACCEL = 25,
  STOP_ACCEL = 26,
  SET_FIGURE8_SPEED = 27,
  NAVIGATE = 28,
  GET_KP = 29,
  GET_KI = 30,
  GET_STRAIGHT = 31,
  MICA_LED_ON = 125,
  MICA_LED_OFF = 126,
  MICA_LED_TOGGLE = 127
};

enum {
  OFF = 0,
  FORWARD = 1,
  REVERSE = 0,
  STRAIGHT = 30,
};

enum {
  KP_ADDR = 10,
  KI_ADDR = 11,
  STRAIGHT_ADDR = 12
};


enum {
  MOTORMsgLength = 4,
  MOTORDataLength = 2
};

/*
 * MOTOR_Msg type
 * addr: refers to address of motor board (the motor boards are
 *   designed so that they may be stacked to get more motor channels
 *   if necessary.
 * type: type of message or command being sent -- defined above.
 * data: self-explanatory
 */
typedef struct MOTOR_Msg
{
  uint8_t addr;
  uint8_t type;
  uint8_t data[MOTORMsgLength-2];
} MOTOR_Msg;

typedef MOTOR_Msg * MOTOR_MsgPtr;

enum {
  TOSM_SERVO_PORT = 0,
  TOSM_ACCELX_PORT = 6,
  TOSM_ACCELY_PORT = 7,
};



