// $Id$

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
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
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Low-level functions to access the CC1000 bus. Built using the mica2
 * hardware SPI.
 *
 * @author Jaein Jeong
 * @author Philip buonadonna
 */

#include <CC1000Const.h>

module HplCC1000SpiP {
  provides interface Init as PlatformInit;
  provides interface HplCC1000Spi;
  //uses interface PowerManagement;
  uses {
    interface GeneralIO as SpiSck;
    interface GeneralIO as SpiMiso;
    interface GeneralIO as SpiMosi;
    interface GeneralIO as OC1C;
  }
}
implementation
{
  uint8_t outgoingByte;
  
  sim_event_t *SPIrw = NULL;
  
  enum {
    RX= 0,
    TX =1
  };
  
  //event handlers for SPI reads
  void spi_read_data_handle(sim_event_t* evt);
  sim_event_t* allocate_spi_read();
  void schedule_spi_read();
  void readDone();
  
  //event handlers for SPI writes
  void spi_write_data_handle(sim_event_t* evt);
  sim_event_t *allocate_spi_write();
  void schedule_spi_write();
  void writeDone();  

  command error_t PlatformInit.init() {
    call SpiSck.makeInput();
    call OC1C.makeInput();
    call HplCC1000Spi.rxMode();
    return SUCCESS;
  }

  AVR_ATOMIC_HANDLER(SIG_SPI) {
    register uint8_t temp = SPDR;
    SPDR = outgoingByte;
    signal HplCC1000Spi.dataReady(temp);
  }
  default async event void HplCC1000Spi.dataReady(uint8_t data) { }
  

  async command void HplCC1000Spi.writeByte(uint8_t data) {
    atomic outgoingByte = data;
    if(READ_BIT(ATM128_DDRB,2) && READ_BIT(ATM128_DDRB,3)) {
      schedule_spi_write();
    }    
  }

  async command bool HplCC1000Spi.isBufBusy() {
    return READ_BIT(SPSR, SPIF);
  }

  async command uint8_t HplCC1000Spi.readByte() {
    return SPDR;
  }

  async command void HplCC1000Spi.enableIntr() {
    //sbi(SPCR,SPIE);
    SPCR = 0xc0;
    CLR_BIT(DDRB, 0);
    //call PowerManagement.adjustPower();
  }

  async command void HplCC1000Spi.disableIntr() {
    CLR_BIT(SPCR, SPIE);
    SET_BIT(DDRB, 0);
    CLR_BIT(PORTB, 0);
    //call PowerManagement.adjustPower();
  }

  async command void HplCC1000Spi.initSlave() {
    atomic {
      CLR_BIT(SPCR, CPOL);		// Set proper polarity...
      CLR_BIT(SPCR, CPHA);		// ...and phase
      SET_BIT(SPCR, SPIE);	// enable spi port
      SET_BIT(SPCR, SPE);
    } 
  }
	
  async command void HplCC1000Spi.txMode() {
    call SpiMiso.makeOutput();
    call SpiMosi.makeOutput();
    schedule_spi_write();
    dbg("HplCC1KSpi","Radio put to Tx state, GPIO set to %d, %d,\n",READ_BIT(ATM128_DDRB,3),READ_BIT(ATM128_DDRB,2));    
  }

  async command void HplCC1000Spi.rxMode() {
    call SpiMiso.makeInput();
    call SpiMosi.makeInput();
    dbg("HplCC1KSpi","Radio put to Rx state, GPIO set to %d, %d,\n",READ_BIT(ATM128_DDRB,3),READ_BIT(ATM128_DDRB,2));
    if(SPIrw != NULL) {
      SPIrw->cancelled = 1;
      readDone();
    }
    //Initially signal back an SPI event
    SIG_SPI();    
  }
  
  /****** SPI Read Events generator ************/

  void spi_read_data_handle(sim_event_t* evt) {
    if (evt->cancelled) {
      dbg("HplCC1KSpiRead","SPI event cancelled\n");
      return;
    }
    else {
      SPDR = outgoingByte;
      dbg("HplCC1KSpiRead","Receiving a byte to read %hhx\n",outgoingByte);
      SIG_SPI();
    }
  }

  sim_event_t* allocate_spi_read() {
    sim_event_t* newEvent = sim_queue_allocate_event();
    newEvent->time = sim_time();
    newEvent->handle = spi_read_data_handle;
    newEvent->cleanup = sim_queue_cleanup_none;
    return newEvent;
  }

  void schedule_spi_read() {
    sim_event_t* newEvent = allocate_spi_read();
    SPIrw = newEvent;
    sim_queue_insert(newEvent);
  }

  void readDone() {
    SPIrw->cleanup = sim_queue_cleanup_total;
    WRITE_BIT(SPSR,SPIF,0);
  }
  
  /******** SPI Write Events generator ********/
  
  void spi_write_data_handle(sim_event_t* evt) {
    gain_entry_t* neighborEntry = sim_gain_first(sim_node());
    if (evt->cancelled) {
      return;
    }
    else {
      SPDR = outgoingByte;
      dbg("HplCC1KSpiWrite","Transmitting %hhx\n",SPDR);
      //signal other nodes with the receive events
      while (neighborEntry != NULL) {
	    int other = neighborEntry->mote;
		int currentNode = sim_node();
		int Byte = outgoingByte;
		sim_set_node(other);
		outgoingByte = Byte;
		//signal the event only if the radio is in receive state
		//the 3rd bit represents the radio status, 0->Rx, 1->Tx
		//see CC1000 data sheet pg(40)
		if((CC1K_REG_ACCESS(CC1K_MAIN) & (1<<CC1K_RXTX)) == RX)
	  	  schedule_spi_read();
		sim_set_node(currentNode);
		neighborEntry = sim_gain_next(neighborEntry);
      }
      SIG_SPI();
    }
  }

  sim_event_t* allocate_spi_write() {
    sim_event_t* newEvent = sim_queue_allocate_event();
    newEvent->time = sim_time()+10002;
    newEvent->handle = spi_write_data_handle;
    newEvent->cleanup = sim_queue_cleanup_none;
    return newEvent;
  }

  void schedule_spi_write() {
    sim_event_t* newEvent = allocate_spi_write();
    SPIrw = newEvent;
    sim_queue_insert(newEvent);
  }

  void writeDone() {
    SPIrw->cleanup = sim_queue_cleanup_total;
    WRITE_BIT(SPSR,SPIF,0);
  }
    
}
