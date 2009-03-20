/*
 * "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
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
 */

configuration TestIEEE154C {
  
} implementation {
  components MainC,  TestIEEE154P;
  components LedsC;
  components new TimerMilliC();

  components CC2420MessageC;

  TestIEEE154P.Boot -> MainC;

//   TestIEEE154P.RadioControl -> CC2420ActiveMessageC;
//   TestIEEE154P.Send -> CC2420ActiveMessageC.AMSend[0x2];
//   TestIEEE154P.Receive -> CC2420ActiveMessageC.Receive[0x2];

  TestIEEE154P.RadioControl -> CC2420MessageC;
  TestIEEE154P.Send -> CC2420MessageC;
  TestIEEE154P.Receive -> CC2420MessageC.Ieee154Receive;

  TestIEEE154P.Leds -> LedsC;
  TestIEEE154P.Timer -> TimerMilliC;
}
