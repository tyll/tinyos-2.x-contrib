// ex: set tabstop=2 shiftwidth=2 expandtab syn=c:
// $Id$

/*                                                                      
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
 * Authors:  Rodrigo Fonseca
 * Date Last Modified: 2005/05/26
 */

includes AM;
includes BVR;

includes Timer;

configuration TestS4Simple {
}

implementation {
  components MainC
           , TestS4SimpleM as TestS4SimpleM
           , S4RouterC
           , LBlinkC
           , LedsC as Leds
#if PLATFORM_MICA2 || PLATFORM_MICA2DOT
           , CC1000RadioC
#endif           
           , new TimerMilliC() as Timer3
           , RandomLfsrC as Random
           , CoordinateTableM
           , ActiveMessageC
           , RandomC
           ;
     
  TestS4SimpleM -> MainC.Boot;
  
  TestS4SimpleM.RouterControl -> S4RouterC.StdControl;
  TestS4SimpleM.Send -> S4RouterC.S4Send;
  TestS4SimpleM.Receive -> S4RouterC.S4Receive;
 
  TestS4SimpleM.LBlink -> LBlinkC;
  TestS4SimpleM.LBlinkControl -> LBlinkC; 
  TestS4SimpleM.Leds -> Leds;
  TestS4SimpleM.Boot -> MainC.Boot;
  
  TestS4SimpleM.Timer1 -> Timer3;
  
  //S4RouterC.RouteToInterface -> TestS4SimpleM;
  
  TestS4SimpleM.CoordinateTable -> CoordinateTableM;
  TestS4SimpleM.AMControl -> ActiveMessageC;
  
  TestS4SimpleM.Random -> RandomC;
  TestS4SimpleM.AMPacket -> ActiveMessageC;
}


