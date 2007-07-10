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
 * The robot should perform a figure8.  This is open-loop only - there
 * are no guarantees that the figure8 will actually look like one.  In
 * fact, this will depend very heavily on battery voltage and timing.
 *
 */

includes MotorBoard;

module Figure8M {
  uses {
    interface Robot;
    interface Timer<TMilli> as Timer;
    interface Leds;
    interface Boot;
    interface Triggerable;
  }
}
implementation {

  uint8_t ticks;
  uint8_t TurnRight;
  uint8_t TurnStraight1;
  uint8_t TurnLeft;
  uint8_t TurnStraight2;
  uint8_t Speed;

  enum {
    OFF = 0,
    SPEED1 = 160,
    FORWARD = 1,
    REVERSE = 0,
    STRAIGHT = 30,
    LEFT = 0,
    RIGHT = 60
  };

  /* Set default constants -- could store on EEPROM for Mica*/
  event void Boot.booted() {
    atomic {
      Speed = 70;
      TurnRight = 3;
      TurnStraight1 = 103;
      TurnLeft = 109;
//      TurnLeft = 16;
//      TurnStraight2 = 28;
      TurnStraight2 = 209;//return to straight after 32
      ticks = 0;
    }

    call Robot.init();
    call Timer.startPeriodic( 125 );
    call Robot.setSpeedTurnDirection(Speed, STRAIGHT, FORWARD);

  }

  task void moveOnTick() {
    uint8_t t;
    atomic {
      t = ticks;
    }
    if (t == 1)
      call Robot.setSpeedTurnDirection(Speed, STRAIGHT, FORWARD);
    else if (t == TurnRight)
      call Robot.setSpeedTurnDirection(Speed, RIGHT, FORWARD);
    else if (t == TurnStraight1)
      call Robot.setSpeedTurnDirection(Speed, STRAIGHT, FORWARD);
    else if (t == TurnLeft)
      call Robot.setSpeedTurnDirection(Speed, LEFT, FORWARD);
    else if (t == TurnStraight2)
      call Robot.setSpeedTurnDirection(Speed, STRAIGHT, FORWARD);
    else if (t >= 212) {
     atomic{
      ticks = 0;
     } //Close ATOMIC
    } //Close IF/ELSE
  }




  event void Timer.fired() {
    atomic {
      ticks++;
    }
    post moveOnTick();
    dbg("Figure8_DBG", "moveOnTick() posted\n");
  }

// Whisker Testing // 

  event void Triggerable.trig(int ID){
   while(ID){
    ID = ID - 1;
    dbg("Whisker","Whisker1 Triggered.\n");
   }
  }

   void sim_trig_signal(int itemID) __attribute__ ((C, spontaneous)){
   signal Triggerable.trig(itemID);
  }
 

}
