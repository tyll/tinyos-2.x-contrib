/*
 * Copyright (c) 2005-2006 Arch Rock Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * @author Jonathan Hui <jhui@archrock.com>
 * @version $Revision$ $Date$
 */

module HplCC2430RadioP {

  provides interface Resource[ uint8_t id ];
  provides interface CC2420Fifo as Fifo[ uint8_t id ];
  provides interface CC2420Ram as Ram[ uint16_t id ];
  provides interface CC2420Register as Reg[ uint16_t id ]; // Used to be uint8_t
  provides interface CC2420Strobe as Strobe[ uint8_t id ];

  /*
  provides interface CC2420Register as FSCTRL;
  provides interface CC2420Register as IOCFG0;  
  provides interface CC2420Register as IOCFG1;
  provides interface CC2420Register as MDMCTRL0;
  provides interface CC2420Register as MDMCTRL1;
  provides interface CC2420Register as RXCTRL1;
  provides interface CC2420Register as TXCTRL;
  */

  uses interface Leds;

}

implementation {

  enum {
    RESOURCE_COUNT = uniqueCount( "CC2420Spi.Resource" ),
    NO_HOLDER = 0xff,
  };

  norace uint16_t m_addr;
  bool m_resource_busy = FALSE;
  uint8_t m_requests = 0;
  uint8_t m_holder = NO_HOLDER;

 default event void Resource.granted[ uint8_t id ]() {
 }
 
  async command error_t Resource.request[ uint8_t id ]() {
    atomic {
      if ( m_resource_busy )
        m_requests |= 1 << id;
      else {
        m_holder = id;
        m_resource_busy = TRUE;
        //call SpiResource.request();
      }
    }
    return SUCCESS;
  }
  
  async command error_t Resource.immediateRequest[ uint8_t id ]() {
    error_t error;
    atomic {
      if ( m_resource_busy )
        return EBUSY; 
      //error = call SpiResource.immediateRequest();
      error = SUCCESS;
      if ( error == SUCCESS ) {
        m_holder = id;
        m_resource_busy = TRUE;
      }
    }
    return error;
  }

  async command error_t Resource.release[ uint8_t id ]() {
    uint8_t i;
    atomic {
      if ( m_holder != id )
        return FAIL;
      m_holder = NO_HOLDER;
      //call SpiResource.release();
      if ( !m_requests ) {
        m_resource_busy = FALSE;
      }
      else {
        for ( i = m_holder + 1; ; i++ ) {
          if ( i >= RESOURCE_COUNT )
            i = 0;
          if ( m_requests & ( 1 << i ) ) {
            m_holder = i;
            m_requests &= ~( 1 << i );
            //call SpiResource.request();
            return SUCCESS;
          }
        }
      }
      return SUCCESS;
    }
  }
  
  async command uint8_t Resource.isOwner[ uint8_t id ]() {
    atomic return m_holder == id;
  }

/*   event void SpiResource.granted() { */
/*     uint8_t holder; */
/*     atomic holder = m_holder; */
/*     signal Resource.granted[ holder ](); */
/*   } */


  async command cc2420_status_t Fifo.beginRead[ uint8_t addr ]( uint8_t* data, 
								uint8_t len ) {
    
    //cc2420_status_t status;
    //status = call SpiByte.write( m_addr );
    
    m_addr = addr | 0x40;
    RFD = m_addr;
    call Fifo.continueRead[ addr ]( data, len );

    return SUCCESS;
    
  }

  async command error_t Fifo.continueRead[ uint8_t addr ]( uint8_t* data,
							   uint8_t len ) {
    
    uint8_t i;

    for (i=0 ; i<len ; i++) {
      data[i] = RFD;
    }
    //call SpiPacket.send( NULL, data, len );
    signal Fifo.readDone[ m_addr & ~0x40 ]( data, len, SUCCESS );    

    return SUCCESS;
  }

  async command cc2420_status_t Fifo.write[ uint8_t addr ]( uint8_t* data, 
							    uint8_t len ) {

    uint8_t i;
    //m_addr = addr;
    //status = call SpiByte.write( m_addr );
    //call SpiPacket.send( data, NULL, len );
    for (i=0 ; i<len ; i++) {
      RFD=data[i];
    }
    signal Fifo.writeDone[ addr ]( data, len, SUCCESS );
    return SUCCESS;
  }

  /*
   * RAM interface is unused in the cc2420 stack (there is a "modify",
   * but noone uses that =]).
   *
   * I have no idea what offset means - so lets hope this is it =]
   *
   * Endianess should be right since these values are stored as big endian
   * and so is a uint16_t (as opposed to sfr16).
   */
  async command cc2420_status_t Ram.read[ uint16_t addr ]( uint8_t offset,
							   uint8_t* data, 
							   uint8_t len ) { 
    uint8_t i;
    for (i=0 ; i<len ; i++) {
      data[i] = *((uint8_t*) (addr + offset + i) );
    }
    return SUCCESS;
  }

  async command cc2420_status_t Ram.write[ uint16_t addr ]( uint8_t offset,
							    uint8_t* data, 
							    uint8_t len ) {
    uint8_t i;
    for (i=0 ; i<len ; i++) {
      *((uint8_t*) (addr + offset + i) ) = data[i];
    }
    return SUCCESS;
  }

  // The generic-module system does not allow pointers, so we cast a bit
  async command cc2420_status_t Reg.read[ uint16_t addr ]( uint16_t* data ) {
    *data = *((uint16_t_xdata*) addr);
    return SUCCESS;
  }

  async command cc2420_status_t Reg.write[ uint16_t addr ]( uint16_t data ) {
    *((uint16_t_xdata*) addr) = data;
    return SUCCESS;
  }

  async command cc2420_status_t Strobe.strobe[ uint8_t opcode ]() {
    RFST = opcode;
    return SUCCESS;
  }

  default async event void Fifo.readDone[ uint8_t addr ]( uint8_t* rx_buf, uint8_t rx_len, error_t error ) {}
  default async event void Fifo.writeDone[ uint8_t addr ]( uint8_t* tx_buf, uint8_t tx_len, error_t error ) {}

}
