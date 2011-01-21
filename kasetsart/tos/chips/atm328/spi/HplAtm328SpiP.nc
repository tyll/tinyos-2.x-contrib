#include "Atm328Spi.h"

/**
 * Implementation of the SPI bus abstraction for ATmega328 microcontroller.
 *
 * @notes 
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/spi/HplAtm128SpiP.nc</code>
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

module HplAtm328SpiP @safe() {
  provides interface Atm328Spi as SPI;
  provides interface AsyncStdControl;
  
  uses {
    interface GeneralIO as SS;   // Slave set line
    interface GeneralIO as SCK;  // SPI clock line
    interface GeneralIO as MOSI; // Master out, slave in
    interface GeneralIO as MISO; // Master in, slave out
    interface McuPowerState as Mcu;
  }
}
implementation {

  async command error_t AsyncStdControl.start() {
    call SPI.enableSpi(TRUE);
  }

  async command error_t AsyncStdControl.stop() {
    call SPI.enableInterrupt(FALSE);
    call SPI.enableSpi(FALSE);
  }
  
  async command void SPI.initMaster() {
    call MOSI.makeOutput();
    call MISO.makeInput();
    call SCK.makeOutput();
    call SS.makeOutput();  // @@@Art definitely required
    call SPI.setMasterBit(TRUE);
  }

  async command void SPI.initSlave() {
    call MISO.makeOutput();
    call MOSI.makeInput();
    call SCK.makeInput();
    call SS.makeInput();
    call SPI.setMasterBit(FALSE);
  }
  
  async command void SPI.sleep() {
//    call SS.set();	// why was this needed?
  }
  
  async command uint8_t SPI.read()        { return SPDR; }
  async command void SPI.write(uint8_t d) { SPDR = d; }
    
  default async event void SPI.dataReady(uint8_t d) {}
  AVR_ATOMIC_HANDLER(SPI_STC_vect) {
      signal SPI.dataReady(call SPI.read());
  }

  //=== SPI Bus utility routines. ====================================
  async command bool SPI.isInterruptPending() {
    return READ_BIT(SPSR, SPIF);
  }

  async command bool SPI.isInterruptEnabled () {                
    return READ_BIT(SPCR, SPIE);
  }

  async command void SPI.enableInterrupt(bool enabled) {
    if (enabled) {
      SET_BIT(SPCR, SPIE);
      call Mcu.update();
    }
    else {
      CLR_BIT(SPCR, SPIE);
      call Mcu.update();
    }
  }

  async command bool SPI.isSpiEnabled() {
    return READ_BIT(SPCR, SPE);
  }
  
  async command void SPI.enableSpi(bool enabled) {
    if (enabled) {
      SET_BIT(SPCR, SPE);
      call Mcu.update();
    }
    else {
      CLR_BIT(SPCR, SPE);
      call Mcu.update();
    }
  }

  /* DORD bit */
  async command void SPI.setDataOrder(bool lsbFirst) {
    if (lsbFirst) {
      SET_BIT(SPCR, DORD);
    }
    else {
      CLR_BIT(SPCR, DORD);
    }
  }
  
  async command bool SPI.isOrderLsbFirst() {
    return READ_BIT(SPCR, DORD);
  }
  
  /* MSTR bit */
  async command void SPI.setMasterBit(bool isMaster) {
    if (isMaster) {
      SET_BIT(SPCR, MSTR);
    }
    else {
      CLR_BIT(SPCR, MSTR);
    }
  }
  async command bool SPI.isMasterBitSet() {
    return READ_BIT(SPCR, MSTR);
  }
  
  /* CPOL bit */
  async command void SPI.setClockPolarity(bool highWhenIdle) {
    if (highWhenIdle) {
      SET_BIT(SPCR, CPOL);
    }
    else {
      CLR_BIT(SPCR, CPOL);
    }
  }
  
  async command bool SPI.getClockPolarity() {
    return READ_BIT(SPCR, CPOL);
  }
  
  /* CPHA bit */
  async command void SPI.setClockPhase(bool sampleOnTrailing) {
    if (sampleOnTrailing) {
      SET_BIT(SPCR, CPHA);
    }
    else {
      CLR_BIT(SPCR, CPHA);
    }
  }
  async command bool SPI.getClockPhase() {
    return READ_BIT(SPCR, CPHA);
  }

  
  async command uint8_t SPI.getClock () {                
    return READ_FLAG(SPCR, ((1 << SPR1) | (1 <<SPR0)));
  }
  
  async command void SPI.setClock (uint8_t v) {
    v &= (SPR1) | (SPR0);
    SPCR = (SPCR & ~(SPR1 | SPR0)) | v;
  }

  async command bool SPI.hasWriteCollided() {
    return READ_BIT(SPSR, WCOL);
  }

  async command bool SPI.isMasterDoubleSpeed() {
    return READ_BIT(SPSR, SPI2X);
  }

  async command void SPI.setMasterDoubleSpeed(bool on) {
   if (on) {
      SET_BIT(SPSR, SPI2X);
    }
    else {
      CLR_BIT(SPSR, SPI2X);
    }
  }

  // @@@Art
  async command void SPI.enableSs(bool enabled)
  {
    if (enabled)
      call SS.clr(); // pull SS/CS low
    else
      call SS.set(); // pull SS/CS high
  }
}
