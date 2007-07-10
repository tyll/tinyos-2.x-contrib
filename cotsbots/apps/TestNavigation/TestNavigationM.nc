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
 * Date last modified:  1/14/03
 */

includes NavigationMsg;

/** 
 * Implementation for TestNavigation module. 
 **/ 

module TestNavigationM {
  uses {
    interface StdControl as CommControl;
    interface ReceiveMsg as Receive;
    interface Navigation;
    interface StdControl as NavigationControl;
    interface Leds;
  }

  provides interface StdControl;
}

implementation {

int16_t x1, y1, x2, y2;
double theta;

/** 
 *  module Initialization. Set up variables.
 *  @return Always return <code>SUCCESS</code>
 **/
  command result_t StdControl.init(){
    call CommControl.init();
    call NavigationControl.init();
    return SUCCESS;
  }

 /**
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

  task void Navigate() {
    call Navigation.navigate(x1,y1,theta,x2,y2);
  }

/**
 * Receive a radio packet, save the values and post the navigation task.
 * @return Always returns <code>SUCCESS</code>
 **/
  event TOS_MsgPtr Receive.receive(TOS_MsgPtr msg) {
    NavigationMsg *message = (NavigationMsg *)msg->data;

    x1 = message->x1;
    y1 = message->y1;
    x2 = message->x2;
    y2 = message->y2;
    theta = ((double)(message->PiNumerator)*M_PI)/((double)(message->PiDenominator));

    post Navigate();
    
    return msg;    
  }


}
