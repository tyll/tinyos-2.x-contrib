/* "Copyright (c) 2000-2003 The Regents of the University of California. All rights reserved.
* BSD license full text at: 
* http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * MSP430Timer32khzMapC presents as paramaterized interfaces all of
 * the 32khz hardware timers on the MSP430 that are available for
 * compile time allocation by "new Alarm32khz16C()", "new
 * AlarmMilli32C()", and so on.  
 *
 * Platforms based on the MSP430 are * encouraged to copy in and
 * override this file, presenting only the * hardware timers that are
 * available for allocation on that platform.
 *
 * @author Cory Sharp <cssharp@eecs.berkeley.edu>
 * @version $Revision$ $Date$
 */

configuration Msp430Timer32khzMapC
{
  provides interface Msp430Timer[ uint8_t id ];
  provides interface Msp430TimerControl[ uint8_t id ];
  provides interface Msp430Compare[ uint8_t id ];
}
implementation
{
  components Msp430TimerC;

  Msp430Timer[0] = Msp430TimerC.TimerB;
  Msp430TimerControl[0] = Msp430TimerC.ControlB0;
  Msp430Compare[0] = Msp430TimerC.CompareB0;

  // Timer pin B1 is used by the CC2420 radio's SFD pin
  // this is the only difference between the default 32khz map
  // and the map on telos

  Msp430Timer[1] = Msp430TimerC.TimerB;
  Msp430TimerControl[1] = Msp430TimerC.ControlB2;
  Msp430Compare[1] = Msp430TimerC.CompareB2;

  Msp430Timer[2] = Msp430TimerC.TimerB;
  Msp430TimerControl[2] = Msp430TimerC.ControlB3;
  Msp430Compare[2] = Msp430TimerC.CompareB3;

  Msp430Timer[3] = Msp430TimerC.TimerB;
  Msp430TimerControl[3] = Msp430TimerC.ControlB4;
  Msp430Compare[3] = Msp430TimerC.CompareB4;

  Msp430Timer[4] = Msp430TimerC.TimerB;
  Msp430TimerControl[4] = Msp430TimerC.ControlB5;
  Msp430Compare[4] = Msp430TimerC.CompareB5;

  Msp430Timer[5] = Msp430TimerC.TimerB;
  Msp430TimerControl[5] = Msp430TimerC.ControlB6;
  Msp430Compare[5] = Msp430TimerC.CompareB6;
}

