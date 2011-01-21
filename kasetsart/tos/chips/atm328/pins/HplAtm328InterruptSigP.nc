/**
 * Interrupt interface access for interrupt capable GPIO pins.
 * Exposes just the interrupt vector routine for 
 * easy linking to generic components.
 *
 * @notes
 * This file is modified from
 * <code>tinyos-2.1.0/tos/chips/atm128/pins/HplAtm128InterruptSigP.nc</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
module HplAtm328InterruptSigP @safe()
{
  provides interface HplAtm328InterruptSig as SigPcInt0; // PCINT0..7
  provides interface HplAtm328InterruptSig as SigPcInt1; // PCINT8..14
  provides interface HplAtm328InterruptSig as SigPcInt2; // PCINT16..23
}
implementation
{
  default async event void SigPcInt0.fired() { }
  AVR_ATOMIC_HANDLER( PCINT0_vect ) {
    signal SigPcInt0.fired();
  }

  default async event void SigPcInt1.fired() { }
  AVR_ATOMIC_HANDLER( PCINT1_vect ) {
    signal SigPcInt1.fired();
  }

  default async event void SigPcInt2.fired() { }
  AVR_ATOMIC_HANDLER( PCINT2_vect ) {
    signal SigPcInt2.fired();
  }
}
