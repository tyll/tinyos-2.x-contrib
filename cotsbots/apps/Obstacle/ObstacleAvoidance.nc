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
 * Authors:		Sarah Bergbreiter
 * Date last modified:  2/25/03
 *
 * This is an obstacle-avoidance program that utilizes the accelerometer on
 * the mica sensorboard to determine the presence of an obstacle.  When
 * an obstacle is detected, the robot will back up, turn, and go in a
 * new direction.
 *
 */

configuration ObstacleAvoidance { }
implementation
{
  components Main, ObstacleAvoidanceM, TimerC, LedsC, ObstacleC, RobotC;

  Main.StdControl -> ObstacleAvoidanceM;

  ObstacleAvoidanceM.ReverseTimer -> TimerC.Timer[unique("Timer")];
  ObstacleAvoidanceM.TimerControl -> TimerC;

  ObstacleAvoidanceM.Leds -> LedsC;
  ObstacleAvoidanceM.Robot -> RobotC;
  ObstacleAvoidanceM.ObstacleControl -> ObstacleC;
  ObstacleAvoidanceM.Obstacle -> ObstacleC;
}
