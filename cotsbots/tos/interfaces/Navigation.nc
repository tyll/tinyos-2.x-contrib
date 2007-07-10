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
 * Authors:		Sarah Bergbreiter
 * Date last modified:  1/14/03
 *
 */

/**
 * This interface provides a navigation component that can set actuators
 * to deal with current positions.
 */

interface Navigation {

  /**
   * Navigate. 
   * @param x1 The current x-coordinate of the robot.  This should be
   * given in cm.
   * @param y1 The current y-coordinate of the robot.  This should be
   * given in cm.
   * @param theta The current heading of the robot.  This should be
   * given in radians.
   * @param x2 The x-coordinate the robot should move to.  This should be
   * given in cm.
   * @param y2 The y-coordinate the robot should move to.  This should be
   * given in cm.
   *  @return Returns SUCCESS if the robot can move to the given point.
   *   Returns FAIL if the new point lies inside the turning radius of
   *   the robot (i.e. there's no way the robot could get to that point).
   */
  command result_t navigate(int16_t x1, int16_t y1, double theta, uint16_t x2, uint16_t y2);

}

