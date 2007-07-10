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
 * Date last modified:  8/2/02
 *
 * TestMotorBoard is intended to provide a test platform for sending commands
 * to the motor board.  It uses a radio interface to receive commands from a
 * base station, parses them into motor packets and sends these to the motor
 * board over the UART, I2C, etc. 
 *
 */

includes RobotCmdMsg;

configuration TestMotorBoard {
}
implementation {
  components Main, TestMotorBoardM, UARTMotorPacket as Packet, LedsC,
	GenericComm as Comm, Figure8C;

  Main.StdControl -> TestMotorBoardM;

  TestMotorBoardM.CommControl -> Packet;
  TestMotorBoardM.Receive -> Packet;
  TestMotorBoardM.Send -> Packet;

  TestMotorBoardM.Leds -> LedsC;

  TestMotorBoardM.RadioControl -> Comm.Control;
  TestMotorBoardM.ReceiveMsg -> Comm.ReceiveMsg[AM_ROBOTCMDMSG];
  TestMotorBoardM.SendMsg -> Comm.SendMsg[AM_ROBOTCMDMSG];

  TestMotorBoardM.Figure8Control -> Figure8C;
  TestMotorBoardM.Figure8Calibration -> Figure8C;

}
