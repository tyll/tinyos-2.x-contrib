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
 * Date last modified:  10/9/2003
 *
 * TestComm provides a test platform for sending and receiving motor packets.
 * This program runs on the mica(2) mote and sends messages to the motor
 * board periodically telling it to turn on its LED.  The mica's green
 * led toggles whenever it sends a packet.  The red led toggles when it
 * receives a packet.
 *
 */

configuration TestComm {
}
implementation {
  components Main, TestCommM, I2CMotorPacket as Packet, LedsC as Display, TimerC;

  Main.StdControl -> TestCommM;

  TestCommM.CommControl -> Packet;
  TestCommM.Receive -> Packet;
  TestCommM.Send -> Packet;

  TestCommM.Timer -> TimerC.Timer[unique("Timer")];
  TestCommM.TimerControl -> TimerC;
  TestCommM.Leds -> Display;
}
