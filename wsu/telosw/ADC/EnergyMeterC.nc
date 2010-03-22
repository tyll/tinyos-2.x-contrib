/*
 * "Copyright (c) 2000-2007 The Regents of the University of
 * California.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * Top-level component for the energy meter.
 *
 * @author Prabal Dutta
 * @date   Sep 8, 2007
 */
configuration EnergyMeterC {
  provides {
    interface EnergyMeter;
  }
}
implementation {
  components MainC;
  components Msp430TimerC;
  components HplMsp430GeneralIOC;
  components EnergyMeterP;

  EnergyMeter = EnergyMeterP;

  //EnergyMeterP.Boot -> MainC;
  EnergyMeterP.Msp430TimerA -> Msp430TimerC.TimerA;
  EnergyMeterP.Port21 -> HplMsp430GeneralIOC.Port21;
  EnergyMeterP.Port62 -> HplMsp430GeneralIOC.Port62;
}
