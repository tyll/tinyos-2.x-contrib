/* "Copyright (c) 2008 The Regents of the University  of California.
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

/**
 * ACme Energy Monitor
 * @author Fred Jiang <fxjiang@eecs.berkeley.edu>
 * @version $Revision$
 */

#include <6lowpan.h>

configuration ACMeterAppC {

} implementation {
  components MainC, LedsC;
  components IPDispatchC, ACMeterAppP;
  components LocalIeeeEui64C;

  ACMeterAppP.Boot -> MainC;
  ACMeterAppP.Leds -> LedsC;

  ACMeterAppP.LocalIeeeEui64 -> LocalIeeeEui64C;

  ACMeterAppP.RadioControl -> IPDispatchC;
  ACMeterAppP.RouteStats -> IPDispatchC.RouteStats;
  components UDPShellC;
  components new UdpSocketC() as Report;
  ACMeterAppP.ReportSend -> Report;

  components new ShellCommandC("set") as Set;
  components new ShellCommandC("read") as Read;
  components new ShellCommandC("period") as Period;
  components new ShellCommandC("reset") as Reset;
  
  // components new ShellCommandC("calibrate") as Calibrate;
  
  ACMeterAppP.SetCmd -> Set;
  ACMeterAppP.ReadCmd -> Read;
  ACMeterAppP.PeriodCmd -> Period;
  ACMeterAppP.ResetCmd -> Reset;
  // ACMeterAppP.CalibrateCmd -> Calibrate;

  components ACMeterC;

  ACMeterAppP.MeterControl -> ACMeterC;
  ACMeterAppP.ACMeter -> ACMeterC;

  components new TimerMilliC() as TimerC;
  ACMeterAppP.Timer -> TimerC;

  components RandomC;
  ACMeterAppP.Random -> RandomC;
  
  }
