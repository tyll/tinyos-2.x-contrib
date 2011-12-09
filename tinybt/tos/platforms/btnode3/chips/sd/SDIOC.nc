// $Id$
/*
 * Copyright (c) 2005-2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Low-level access functions for the AT45DB flash on the mica2 and micaz.
 *
 * @author David Gay
 */

configuration SDIOC {
  provides {
    interface Resource;
    interface SpiByte;
    interface SDByte;
  }
}
implementation {
  // Wire up byte I/O to At45db
  components SDIOP, HplAtm128GeneralIOC as Pins, HplAtm128InterruptC, PlatformC;
  components BusyWaitMicroC;
  components new NoArbiterC();

  Resource = NoArbiterC;
  SpiByte = SDIOP;
  SDByte = SDIOP;

  PlatformC.SubInit -> SDIOP;
  SDIOP.Select -> Pins.PortF0;
  SDIOP.Clk -> Pins.PortF1;
  SDIOP.In -> Pins.PortE6;
  SDIOP.Out -> Pins.PortE3;
  SDIOP.InInterrupt -> HplAtm128InterruptC.Int4;
  SDIOP.BusyWait -> BusyWaitMicroC;
}