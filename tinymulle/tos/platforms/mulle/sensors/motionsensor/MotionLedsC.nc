// $Id$

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
/**
 *
 * The basic TinyOS LEDs abstraction.
 *
 * @author Phil Buonadonna
 * @author David Gay
 * @author Philip Levis
 * @author Joe Polastre
 */


configuration MotionLedsC {
  provides interface Leds;
}
implementation {
  components MotionLedsP as App, PlatformC; 
  components HplM16c62pGeneralIOC as IO;

  Leds = App;

  App.Init <- PlatformC.SubInit;
  App.Led0 -> IO.PortP80;  // Pin P8_0 = Red LED
  App.Led1 -> IO.PortP13;  // Pin P1_3 = Green LED
  App.Led2 -> IO.PortP27; //  Pin P2_7 = Blue LED
  
  
  
}

