/*
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
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
 */
/*
 * Copyright (c) 2002-2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * Null is an empty skeleton application.  It is useful to test that the
 * build environment is functional in its most minimal sense, i.e., you
 * can correctly compile an application. It is also useful to test the
 * minimum power consumption of a node when it has absolutely no 
 * interrupts or resources active.
 *
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 * @date February 4, 2006
 */

#include <msp430usart.h>

configuration GpsSleepAppC{}
implementation {
  components MainC, GpsSleepC, LedsC;
  MainC.Boot <- GpsSleepC;
  GpsSleepC.Leds -> LedsC;
  
  components Msp430I2CP;        // this is mine, ported from tos-1.x; find it in shimmer/chips/msp430
  GpsSleepC.I2CPacket -> Msp430I2CP.I2CBasicAddr;

  components HplMsp430I2C0C;
  GpsSleepC.HplI2C -> HplMsp430I2C0C;
  Msp430I2CP.HplI2C -> HplMsp430I2C0C;

  components HplMsp430Usart0C;
  Msp430I2CP.I2CInterrupts -> HplMsp430Usart0C;

}

