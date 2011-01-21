#include "Atm328Spi.h"

/**
 * HPL-level access to the Atmega328 SPI bus.  A command for
 * enabling/disabling SS pin has been added to the original interface.
 *
 * @notes
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/spi/Atm128Spi.nc</code>
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

interface Atm328Spi {

  /* Modal functions */

  /** Initialize the ATmega328 SPI bus into master mode. */
  async command void initMaster();

  /** Initialize the ATmega328 SPI bus into slave mode. */
  async command void initSlave();

  /** Disable and sleep the ATmega328 SPI bus. */
  async command void sleep();
  
  /* SPDR: SPI Data Register */

  /** 
   * Read the SPI data register 
   * @return last data byte
   */
  async command uint8_t read();

  /** 
   * Write the SPI data register 
   * @param data   next data byte
   */
  async command void write(uint8_t data);

  /**
   * Interrupt signalling SPI data cycle is complete. 
   * @param data   data byte from data register
   */
  async event   void dataReady(uint8_t data);
  
  /* SPCR: SPI Control Register */
  /* SPIE bit */
  async command void enableInterrupt(bool enabled);
  async command bool isInterruptEnabled();
  /* SPI bit */
  async command void enableSpi(bool busOn);
  async command bool isSpiEnabled();
  /* DORD bit */
  async command void setDataOrder(bool lsbFirst);
  async command bool isOrderLsbFirst();
  /* MSTR bit */
  async command void setMasterBit(bool isMaster);
  async command bool isMasterBitSet();
  /* CPOL bit */
  async command void setClockPolarity(bool highWhenIdle);
  async command bool getClockPolarity();
  /* CPHA bit */
  async command void setClockPhase(bool sampleOnTrailing);
  async command bool getClockPhase();
  /* SPR1 and SPR0 bits */
  async command void  setClock(uint8_t speed);
  async command uint8_t getClock();
  
  /* SPSR: SPI Status Register */
  
  /* SPIF bit */
  async command bool isInterruptPending();
  /* WCOL bit */
  async command bool hasWriteCollided();
  /* SPI2X bit */
  async command bool isMasterDoubleSpeed();
  async command void setMasterDoubleSpeed(bool on);

  /* @@@Art Allow app to control the SS/CS line */
  async command void enableSs(bool enabled);
}
