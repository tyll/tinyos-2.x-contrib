/**
 * THIS DEFINITION IS FOR THE ORIGINAL FLINT2 GMA
 */

configuration PlatformModemPinsC {
  provides {
    interface GeneralIO as NetAvail;
    interface GeneralIO as GPSTick;
    interface GeneralIO as DCDC;
    interface GeneralIO as Relay;
    interface GeneralIO as Ring;
    interface GeneralIO as Wake;
    interface GpioInterrupt as RingIRQ;
  }
}

implementation {
  components HplMsp430InterruptC as IRQs, HplMsp430GeneralIOC as Pins;

  components new Msp430InterruptC() as PRingIRQ;
  RingIRQ = PRingIRQ.Interrupt;
  PRingIRQ.HplInterrupt -> IRQs.Port23;

  components new Msp430GpioC() as PNetAvail;
  NetAvail = PNetAvail.GeneralIO;
  PNetAvail.HplGeneralIO -> Pins.Port15;

  components new Msp430GpioC() as PGPSTick;
  GPSTick = PGPSTick.GeneralIO;
  PGPSTick.HplGeneralIO -> Pins.Port16;

  components new Msp430GpioC() as PDCDC;
  DCDC = PDCDC.GeneralIO;
  PDCDC.HplGeneralIO -> Pins.Port20;

  components new Msp430GpioC() as PRelay;
  Relay = PRelay.GeneralIO;
  PRelay.HplGeneralIO -> Pins.Port21;

  components new Msp430GpioC() as PRing;
  Ring = PRing.GeneralIO;
  PRing.HplGeneralIO -> Pins.Port23;

  components new Msp430GpioC() as PWake;
  Wake = PWake.GeneralIO;
  PWake.HplGeneralIO -> Pins.Port24;
}

