/*
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * Implementation of TEP 112 (Microcontroller Power Management) for
 * the MSP430. Code for low power calculation copied from older
 * msp430hardware.h by Vlado Handziski, Joe Polastre, and Cory Sharp.
 *
 *
 * @author Philip Levis
 * @author Vlado Handziski
 * @author Joe Polastre
 * @author Cory Sharp
 * @date   October 26, 2005
 * @see  Please refer to TEP 112 for more information about this component and its
 *          intended use.
 *
 */

configuration McuSleepC {
  provides {
    interface McuSleep;
    interface McuPowerState;
  }
  uses {
    interface McuPowerOverride;
  }
}

implementation {

  components McuSleepP;
  McuSleep = McuSleepP;
  McuPowerState = McuSleepP;
  McuPowerOverride = McuSleepP;
  
  components LedsC;
  McuSleepP.Leds -> LedsC;
  
}
