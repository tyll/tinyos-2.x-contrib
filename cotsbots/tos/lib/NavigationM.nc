/*									tab:4
 *
 *
 * "Copyright (c) 2000-2002 The Regents of the University  of California.  
 * All rights reserved.
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
 */
/*
 *
 * Authors:		Sarah Bergbreiter
 * Date last modified:  1/22/03
 *
 */

/* Navigation Component
 
 Functionality: Given a particular starting point and heading, navigate
   the robot to a second point.  (x1,y1,theta) -> (x2,y2)

 Notes: 
   1. This navigation component only assumes the robot may move in the forward
   direction.  It may be approved by adding in the ability to go backwards.
   2. It also uses the standard trig functions provided by the math.h
   library.  If space or time is a priority, you may consider using the Taylor
   expansions for these functions.

 USAGE:

  StdControl.init() must be called to set up the debug communication components
    and the robot initialization.

  Navigation.navigate(x1,y1,theta,x2,y2)
    - navigates from point 1 to point 2 where my current heading is theta
    - the positions are provided in cm with respect to some global coordinate
      system and theta is a double value provided in radians (-pi,pi)
 */

includes NavigationMsg; 

module NavigationM {
  uses {
    interface StdControl as CommControl;
    interface SendMsg as Send;
    interface Leds;
    interface Timer as TurnTimer;
    interface Timer as StraightTimer;
    interface Robot;
  }
  provides interface Navigation;
  provides interface StdControl;
}
implementation
{
  bool pending;
  struct TOS_Msg data;
  uint16_t turnTime, straightTime;
  int16_t x1,y1,x2,y2;
  double theta;
  bool debug;

  enum {
    OFF = 0,
    SPEED1 = 25,
    FORWARD = 1,
    REVERSE = 0,
    STRAIGHT = 30,
    LEFT = 0,
    RIGHT = 60
  };

  task void navigate() {
    NavigationDbgMsg *message = (NavigationDbgMsg *)data.data;
    double thetaCar, thetaLine, thetaDiff, Pi2;
    double thetaCircle,cx,cy,thetaLine2,dLine2,alpha;
    double thetaTurn,x3,y3,x4,y4,xTurn,yTurn,arcAngle;
    uint16_t turn, straight;
    uint8_t R = 20;
    int8_t right = 0;

    // Stop timers and robot to recompute new trajectory
    call Robot.setSpeedTurnDirection(OFF,STRAIGHT,FORWARD);
    call StraightTimer.stop();
    call TurnTimer.stop();

    thetaCar = theta;
    thetaLine = atan2((int)(x2-x1),(int)(y2-y1));
    thetaDiff = (theta-thetaLine)/2;
    Pi2 = M_PI/2;

    if (tan(thetaDiff) > 0) {
      right = 1;
      thetaCircle = theta - Pi2;
    } else {
      thetaCircle = theta + Pi2;
    }

    cx = x1+R*cos(thetaCircle);
    cy = y1+R*sin(thetaCircle);
    x3 = x2-cx;
    y3 = y2-cy;
    thetaLine2 = atan2(x3,y3);
    dLine2 = sqrt(x3*x3+y3*y3);
    /* If point is inside the circle return FAIL */
    if (dLine2 < R)
      return;

    alpha = acos(R/dLine2);

    if (right == 1) {
      theta = theta + Pi2;
      thetaTurn = thetaLine2+alpha;
      if (theta < thetaTurn)
        theta = theta + 2*M_PI;
      arcAngle = theta - thetaTurn;
    } else {
      theta = theta - Pi2;
      thetaTurn = thetaLine2 - alpha;
      if (thetaTurn < theta)
        thetaTurn = thetaTurn + 2*M_PI;
      arcAngle = thetaTurn - theta;
    }

    xTurn = cx+R*cos(thetaTurn);
    yTurn = cy+R*sin(thetaTurn);

    x4 = xTurn - x2;
    y4 = yTurn - y2;
    turn = (uint16_t)(arcAngle*R);
    straight = (uint16_t)(sqrt(x4*x4+y4*y4));

    /* Assuming speed = 40 cm/sec get time result in milliseconds) */
    /* Add an extra 200ms start time for turning */
    /* Subtract an extra 500ms for stopping */
    turnTime = 25*turn + 200;
    straightTime = 25*straight;
    if (straightTime < 550)
      straightTime = 50;
    else
      straightTime = straightTime - 500;

    call Leds.greenToggle();
    call TurnTimer.start(TIMER_ONE_SHOT, turnTime);
    if (right == 1)
      call Robot.setSpeedTurnDirection(SPEED1,RIGHT,FORWARD);
    else
      call Robot.setSpeedTurnDirection(SPEED1,LEFT,FORWARD);

    if (debug) {
      message->data[0] = turn;
      message->data[1] = straight;
      message->data[2] = turnTime;
      message->data[3] = straightTime;
      message->data[4] = (int16_t)(thetaDiff*100);
      message->data[5] = (int16_t)(thetaCar*100);
      message->data[6] = cx;
      message->data[7] = cy;
      message->data[8] = (int16_t)(x2-x1);
      message->data[9] = (int16_t)(y2-y1);

      if (!pending) {
        pending = TRUE;

        if (call Send.send(TOS_BCAST_ADDR, sizeof(NavigationDbgMsg), &data)) {
          return;
        }
        pending = FALSE;
      }
    }

  }

/** 
 *  navigate command. Set up variables and post the navigate task.
 *  @return Always return <code>SUCCESS</code>
 **/
  command result_t Navigation.navigate(int16_t _x1, int16_t _y1, double _theta, uint16_t _x2, uint16_t _y2) {
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
    theta = _theta;
    post navigate();
    return SUCCESS;
  }

/** 
 *  module Initialization. Set up variables.
 *  @return Always return <code>SUCCESS</code>
 **/
  command result_t StdControl.init(){
    call CommControl.init();
    call Robot.init();
    pending = FALSE;
    debug = FALSE;
    return SUCCESS;
  }
 /**
  * Calculate functions and send message.
  * @return Alway return <code>SUCCESS</code>
  **/ 
  command result_t StdControl.start() {
    return SUCCESS;
  }

/** 
 *  @return Always return <code>SUCCESS</code>
 **/
  command result_t StdControl.stop() {
    return SUCCESS;
  }


/** 
 * SendDone Event Handler 
 * @return Alway return <code>SUCCESS</code>
 **/
  event result_t Send.sendDone(TOS_MsgPtr msg, result_t success) {
    pending = FALSE;

    return SUCCESS;
  }

/** 
  * TurnTimer event handler : moves the robot into the
  * straight position and starts the StraightTimer.
  * @return Always return <code>SUCCESS</code>
  **/
  event result_t TurnTimer.fired() {
    call StraightTimer.start(TIMER_ONE_SHOT, straightTime);
    call Leds.yellowToggle();
    call Robot.setTurn(STRAIGHT);

    return SUCCESS;
}

/** 
  * StraightTimer event handler : turns the robot off.
  * @return Always return <code>SUCCESS</code>
  **/
  event result_t StraightTimer.fired() {
    call Robot.setSpeed(OFF);
    call Leds.redToggle();

    return SUCCESS;
}



}


