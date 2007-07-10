// $Id$

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
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
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/*
 *
 * Authors:		Sarah Bergbreiter
 * Date last modified:  10/8/2003
 *
 */

/**
 * Provides the ability to write or read a MOTOR packet to the 
 * I2C bus.  For more information, look at the MotorSendMsg and
 * MotorReceiveMsg interfaces.
 * @author Sarah Bergbreiter
 **/
configuration I2CMotorPacket
{
  provides {
    interface StdControl;
    interface MotorReceiveMsg;
    interface MotorSendMsg;
  }
}

implementation {
  components I2CC, I2CMotorPacketM, LedsC as Debug;

  StdControl = I2CMotorPacketM;
  MotorReceiveMsg = I2CMotorPacketM;
  MotorSendMsg = I2CMotorPacketM;

  I2CMotorPacketM.I2C -> I2CC;
  I2CMotorPacketM.I2CStdControl -> I2CC.StdControl;

  I2CMotorPacketM.Leds -> Debug;
}
