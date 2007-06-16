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
 
/**
 * Low-level cc1000 radio simulation support for TOSSIM.
 *
 * @author Venkatesh S
 * @author Prabhakar T V
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
  
  //start the radio ticks, RADIO_DATA_RATE 19200 bps and the RADIO_OSC_FREQ = 14Mhz
  uint64_t radio_ticks = 14000000/19200;
  
  //event handlers for SPI 
  sim_event_t *allocate_spi_event();  
  
  bool radioState;
  
  enum {
    rx = 0,
    tx = 1,
  };
  
  command error_t PlatformInit.init() {
    call SpiSck.makeInput();
    call OC1C.makeInput();
    call HplCC1000Spi.rxMode();
    spi_event = NULL;
    spi_flag = FALSE;
    return SUCCESS;
  }

  AVR_ATOMIC_HANDLER(SIG_SPI) {
    /*the lower level FIFO is such it hold the compliment result of the
     *received bits. So just compliment the SPDR register contents in 
     *the simulation
     */
    register uint8_t temp = ~SPDR;
    SPDR = outgoingByte;
    signal HplCC1000Spi.dataReady(temp);
  }
  default async event void HplCC1000Spi.dataReady(uint8_t data) { }
  

  async command void HplCC1000Spi.writeByte(uint8_t data) {
    atomic outgoingByte = data;
    dbg("HplCC1000Spi","Writing %hhx\n",data);
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
    /**********start the spi event loop************/
    if(spi_event != NULL) {
      spi_event->cancelled = 1;
    }
    else {
      dbg("HplCC1000SpiP","Allocating SPI event\n");
      spi_event = allocate_spi_event();
      sim_queue_insert(spi_event);

    }
  }
	
  async command void HplCC1000Spi.txMode() {
    call SpiMiso.makeOutput();
    call SpiMosi.makeOutput();
    radioState = tx;
    dbg("HplCC1000SpiP","Radio state is %s\n",(RADIO_STATE)?"tx":"rx");  
  }

  async command void HplCC1000Spi.rxMode() {
    gain_entry_t* neighborEntry = sim_gain_first(sim_node());
    call SpiMiso.makeInput();
    call SpiMosi.makeInput();    
    if(radioState == tx) {
      //release the spi lock of the receiver nodes
      while (neighborEntry != NULL) {
	    int dest = neighborEntry->mote;
	    int src = sim_node();	
	    sim_set_node(dest);       
	    if(sim_gain_connected(src,dest)){
          spi_flag = FALSE;
	    }
		sim_set_node(src);	     
		neighborEntry = sim_gain_next(neighborEntry);
      }
    }
    radioState = rx;
    dbg("HplCC1000SpiP","Radio state is %s\n",(RADIO_STATE)?"tx":"rx");    
  }
 
  /*********** SPI events ***********/

  
  void spi_byte_event_handle(sim_event_t* evt) {
    //radio state = 0 -> Rx
    //radio state = 1 -> Tx
    if(RADIO_STATE == 1) {
      gain_entry_t* neighborEntry = sim_gain_first(sim_node());
      while (neighborEntry != NULL) {
	    int dest = neighborEntry->mote;
	    int src = sim_node();
	    int temp = SPDR;
	    sim_set_node(dest);
        if(sim_gain_connected(src,dest)) { 		
	      /* signal the event only if the radio is in receive state
	       * and if the radio is ON
  		   */
		  if(RADIO_STATE == rx && RADIO_CORE_ON && RADIO_BIAS_ON) {
	        SPDR = temp;
	        spi_flag = TRUE;
	        SIG_SPI();
	      }
	    }
		sim_set_node(src);
		neighborEntry = sim_gain_next(neighborEntry);
      }      
    }
    else if(RADIO_STATE == 0) {
      
    }
    else {
      //some nasty bug
    }
    if(!spi_flag) {
      SPDR = 0;
      SIG_SPI();
    }else {
    
    }
    dbg("HplCC1000SpiP","Event handled for SPI at %s\n",sim_time_string());
    evt->time += sim_ticks_per_sec()/radio_ticks;
    sim_queue_insert(evt);
  
  }
  
  sim_event_t *allocate_spi_event() {
    sim_event_t* newEvent = sim_queue_allocate_event();
    newEvent->time = radio_ticks;
    newEvent->handle = spi_byte_event_handle;
    newEvent->cleanup = sim_queue_cleanup_none;
    return newEvent;
  }
  
    
}
