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
 * Date last modified:  7/10/02
 *
 * MotorTest component runs through a set sequence of speeds for both 
 * motor1 and motor2.
 *
 */

includes MotorBoard;

module MotorTestM {
  provides interface StdControl;
  uses {
    interface Clock;
    interface HPLMotor as HPLMotor1;
    interface HPLMotor as HPLMotor2;
  }
}
implementation {

  enum {
    SPEED1 = 100,
    SPEED2 = 120,
    SPEED3 = 140
  };

  uint8_t ticks;

  command result_t StdControl.init() {
    atomic {
      ticks = 0;
    }
    call HPLMotor1.init();
    call HPLMotor2.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    // Initialize Clock to start counting
    call Clock.setRate(15,4);  // Fire ~ 2 times/sec at 2MHz
    return SUCCESS; 
  }

  command result_t StdControl.stop() {
    // Stop clock and reset ticks
    atomic {
      ticks = 0;
    }
    call Clock.setRate(0,0);
    call HPLMotor1.setSpeed(0);
    call HPLMotor2.setSpeed(0);
    call HPLMotor1.setDir(FORWARD);
    call HPLMotor2.setDir(FORWARD);
    return SUCCESS;
  }

  task void parseTicks() {
    uint8_t t;
    atomic {
      t = ticks;
    }

    switch (t) {
      case 1:
        call HPLMotor1.setSpeed(OFF);
        call HPLMotor2.setSpeed(OFF);
        call HPLMotor1.setDir(FORWARD);
        call HPLMotor2.setDir(FORWARD);
        break;
      case 2:
        call HPLMotor1.setSpeed(SPEED1);
        call HPLMotor2.setSpeed(SPEED1);
        break;
      case 3:
        call HPLMotor1.setSpeed(SPEED2);
        call HPLMotor2.setSpeed(SPEED2);
        break;
      case 4:
        call HPLMotor1.setSpeed(SPEED3);
        call HPLMotor2.setSpeed(SPEED3);
        break;
      case 5:
        call HPLMotor1.setDir(REVERSE);
        call HPLMotor2.setDir(REVERSE);
        break;
      case 6:
        call HPLMotor1.setSpeed(SPEED2);
        call HPLMotor2.setSpeed(SPEED2);
        break;
      case 7:
        call HPLMotor1.setSpeed(SPEED1);
        call HPLMotor2.setSpeed(SPEED1);
        break;
      case 8:
        call HPLMotor1.setSpeed(OFF);
        call HPLMotor2.setSpeed(OFF);
	atomic {
	  ticks = 0;
	}
        break;
    }
  }



  async event result_t Clock.fire() {
    // Go through command sequence
    atomic {
      ticks++;
    }
    post parseTicks();
    return SUCCESS;
  }

}

