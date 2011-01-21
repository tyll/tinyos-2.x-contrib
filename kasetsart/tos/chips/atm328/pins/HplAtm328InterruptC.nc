#include <atm328hardware.h>

/**
 * Component providing access to all pin-change interrupt pins on ATmega328.
 * External interrupts are not yet supported.
 *
 * @notes
 * This file is modified from
 * <code>tinyos-2.1.0/tos/chips/atm128/pins/HplAtm128InterruptC.nc</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

configuration HplAtm328InterruptC
{
  // provides all the ports as raw ports
  provides {
    interface HplAtm328Interrupt as PcInt0;
    interface HplAtm328Interrupt as PcInt1;
    interface HplAtm328Interrupt as PcInt2;
    interface HplAtm328Interrupt as PcInt3;
    interface HplAtm328Interrupt as PcInt4;
    interface HplAtm328Interrupt as PcInt5;
    interface HplAtm328Interrupt as PcInt6;
    interface HplAtm328Interrupt as PcInt7;

    interface HplAtm328Interrupt as PcInt8;
    interface HplAtm328Interrupt as PcInt9;
    interface HplAtm328Interrupt as PcInt10;
    interface HplAtm328Interrupt as PcInt11;
    interface HplAtm328Interrupt as PcInt12;
    interface HplAtm328Interrupt as PcInt13;
    interface HplAtm328Interrupt as PcInt14;

    interface HplAtm328Interrupt as PcInt16;
    interface HplAtm328Interrupt as PcInt17;
    interface HplAtm328Interrupt as PcInt18;
    interface HplAtm328Interrupt as PcInt19;
    interface HplAtm328Interrupt as PcInt20;
    interface HplAtm328Interrupt as PcInt21;
    interface HplAtm328Interrupt as PcInt22;
    interface HplAtm328Interrupt as PcInt23;
  }
}
implementation
{
#define PIN_PARAMS(pin_reg,pin_bit,mask_reg,mask_bit,pcicr_bit) \
  (uint8_t)&pin_reg, \
  pin_bit, \
  (uint8_t)&mask_reg, \
  mask_bit, \
  pcicr_bit

  components 
    HplAtm328InterruptSigP as IrqVector,

    new HplAtm328InterruptPinP(PIN_PARAMS(PINB,PINB0,PCMSK0,PCINT0,PCIE0)) as IntPin0,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINB,PINB1,PCMSK0,PCINT1,PCIE0)) as IntPin1,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINB,PINB2,PCMSK0,PCINT2,PCIE0)) as IntPin2,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINB,PINB3,PCMSK0,PCINT3,PCIE0)) as IntPin3,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINB,PINB4,PCMSK0,PCINT4,PCIE0)) as IntPin4,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINB,PINB5,PCMSK0,PCINT5,PCIE0)) as IntPin5,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINB,PINB6,PCMSK0,PCINT6,PCIE0)) as IntPin6,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINB,PINB7,PCMSK0,PCINT7,PCIE0)) as IntPin7,

    new HplAtm328InterruptPinP(PIN_PARAMS(PINC,PINC0,PCMSK1,PCINT8,PCIE1)) as IntPin8,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINC,PINC1,PCMSK1,PCINT9,PCIE1)) as IntPin9,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINC,PINC2,PCMSK1,PCINT10,PCIE1)) as IntPin10,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINC,PINC3,PCMSK1,PCINT11,PCIE1)) as IntPin11,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINC,PINC4,PCMSK1,PCINT12,PCIE1)) as IntPin12,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINC,PINC5,PCMSK1,PCINT13,PCIE1)) as IntPin13,
    new HplAtm328InterruptPinP(PIN_PARAMS(PINC,PINC6,PCMSK1,PCINT14,PCIE1)) as IntPin14,

    new HplAtm328InterruptPinP(PIN_PARAMS(PIND,PIND0,PCMSK2,PCINT16,PCIE2)) as IntPin16,
    new HplAtm328InterruptPinP(PIN_PARAMS(PIND,PIND1,PCMSK2,PCINT17,PCIE2)) as IntPin17,
    new HplAtm328InterruptPinP(PIN_PARAMS(PIND,PIND2,PCMSK2,PCINT18,PCIE2)) as IntPin18,
    new HplAtm328InterruptPinP(PIN_PARAMS(PIND,PIND3,PCMSK2,PCINT19,PCIE2)) as IntPin19,
    new HplAtm328InterruptPinP(PIN_PARAMS(PIND,PIND4,PCMSK2,PCINT20,PCIE2)) as IntPin20,
    new HplAtm328InterruptPinP(PIN_PARAMS(PIND,PIND5,PCMSK2,PCINT21,PCIE2)) as IntPin21,
    new HplAtm328InterruptPinP(PIN_PARAMS(PIND,PIND6,PCMSK2,PCINT22,PCIE2)) as IntPin22,
    new HplAtm328InterruptPinP(PIN_PARAMS(PIND,PIND7,PCMSK2,PCINT23,PCIE2)) as IntPin23;
  
  PcInt0  = IntPin0;
  PcInt1  = IntPin1;
  PcInt2  = IntPin2;
  PcInt3  = IntPin3;
  PcInt4  = IntPin4;
  PcInt5  = IntPin5;
  PcInt6  = IntPin6;
  PcInt7  = IntPin7;
  PcInt8  = IntPin8;
  PcInt9  = IntPin9;
  PcInt10 = IntPin10;
  PcInt11 = IntPin11;
  PcInt12 = IntPin12;
  PcInt13 = IntPin13;
  PcInt14 = IntPin14;
  PcInt16 = IntPin16;
  PcInt17 = IntPin17;
  PcInt18 = IntPin18;
  PcInt19 = IntPin19;
  PcInt20 = IntPin20;
  PcInt21 = IntPin21;
  PcInt22 = IntPin22;
  PcInt23 = IntPin23;

  IntPin0.IrqSignal -> IrqVector.SigPcInt0;
  IntPin1.IrqSignal -> IrqVector.SigPcInt0;
  IntPin2.IrqSignal -> IrqVector.SigPcInt0;
  IntPin3.IrqSignal -> IrqVector.SigPcInt0;
  IntPin4.IrqSignal -> IrqVector.SigPcInt0;
  IntPin5.IrqSignal -> IrqVector.SigPcInt0;
  IntPin6.IrqSignal -> IrqVector.SigPcInt0;
  IntPin7.IrqSignal -> IrqVector.SigPcInt0;

  IntPin8.IrqSignal -> IrqVector.SigPcInt1;
  IntPin9.IrqSignal -> IrqVector.SigPcInt1;
  IntPin10.IrqSignal -> IrqVector.SigPcInt1;
  IntPin11.IrqSignal -> IrqVector.SigPcInt1;
  IntPin12.IrqSignal -> IrqVector.SigPcInt1;
  IntPin13.IrqSignal -> IrqVector.SigPcInt1;
  IntPin14.IrqSignal -> IrqVector.SigPcInt1;

  IntPin16.IrqSignal -> IrqVector.SigPcInt2;
  IntPin17.IrqSignal -> IrqVector.SigPcInt2;
  IntPin18.IrqSignal -> IrqVector.SigPcInt2;
  IntPin19.IrqSignal -> IrqVector.SigPcInt2;
  IntPin20.IrqSignal -> IrqVector.SigPcInt2;
  IntPin21.IrqSignal -> IrqVector.SigPcInt2;
  IntPin22.IrqSignal -> IrqVector.SigPcInt2;
  IntPin23.IrqSignal -> IrqVector.SigPcInt2;
}

