/* Copyright (c)  2005-2006 Arch Rock Corporation All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * HPL implementation of interrupts and captures for the ChipCon
 * CC2420 radio connected to a TI MSP430 processor.
 *
 * @author Jonathan Hui <jhui@archrock.com>    2006/12/12 18:23:44   $Revision: 1.4
 * revised John Griessen 13 Dec 2007
 */

configuration HplCC2420InterruptsC {

  provides interface GpioCapture as CaptureSFD;
  provides interface GpioInterrupt as InterruptCCA;
  provides interface GpioInterrupt as InterruptFIFOP;

}

implementation {

  components HplMsp430GeneralIOC as GeneralIOC;
  components Msp430TimerC;
  components new GpioCaptureC() as CaptureSFDC;
  CaptureSFDC.Msp430TimerControl -> Msp430TimerC.ControlB1;
  CaptureSFDC.Msp430Capture -> Msp430TimerC.CaptureB1;
  CaptureSFDC.GeneralIO -> GeneralIOC.Port41;

  components HplMsp430InterruptC;
  components new Msp430InterruptC() as InterruptCCAC;
  components new Msp430InterruptC() as InterruptFIFOPC;
  InterruptCCAC.HplInterrupt -> HplMsp430InterruptC.Port14;
  InterruptFIFOPC.HplInterrupt -> HplMsp430InterruptC.Port10;

  CaptureSFD = CaptureSFDC.Capture;
  InterruptCCA = InterruptCCAC.Interrupt;
  InterruptFIFOP = InterruptFIFOPC.Interrupt;

}
