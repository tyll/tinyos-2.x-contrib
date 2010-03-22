/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */


#include "Blaze.h"
#include "BlazeSpiResource.h"

/**
 * @author Jared Hill
 * @author David Moss
 */ 
module BlazeSpiP {

  provides {
    interface Resource[ uint8_t id ];
    interface BlazeFifo as Fifo[ uint8_t id ];
    interface BlazeRegister as Reg[ uint8_t id ];
    interface BlazeStrobe as Strobe[ uint8_t id ];
    interface ChipSpiResource;
    interface RadioInit;
    interface RadioStatus;
  }
  
  uses {
    interface Resource as SpiResource;
    interface SpiByte;
    interface SpiPacket;
    interface Leds;
    interface State;
    interface State as SpiResourceState;
  }
}

implementation {

  enum {
    RESOURCE_COUNT = uniqueCount( UQ_BLAZE_SPI_RESOURCE ),
    NO_HOLDER = 0xFF,
  };

  enum {
    S_IDLE,
    S_BUSY,
    
    S_READ_FIFO,
    S_INIT,
    S_WRITE_FIFO,
  };

  /** Address to read / write */
  uint16_t m_addr;
  
  /** Each bit represents a client ID that is requesting SPI bus access */
  uint32_t m_requests = 0;
  
  /** The current client that owns the SPI bus */
  uint8_t m_holder = NO_HOLDER;
  
  /** TRUE if it is safe to release the SPI bus after all users say ok */
  bool release;
  
  /***************** Prototypes ****************/
  uint8_t getRadioStatus();
  error_t attemptRelease();
  task void grant();
  task void radioInitDone();
  
  /***************** RadioInit Commands ****************/
  command error_t RadioInit.init(uint8_t startAddr, uint8_t* regs, 
      uint8_t len) {
      
    if(!call SpiResource.isOwner()) {
      return ERESERVE;
    }
    
    if(call State.requestState(S_INIT) != SUCCESS) {
      return FAIL;
    }
    
    call SpiByte.write(startAddr | BLAZE_BURST | BLAZE_WRITE);
    call SpiPacket.send(regs, NULL, len);
    
    return SUCCESS;  
  }
  
  
  /***************** ChipSpiResource Commands ****************/
  /**
   * Abort the release of the SPI bus.  This must be called only with the
   * releasing() event
   */
  async command void ChipSpiResource.abortRelease() {
    atomic release = FALSE;
  }
  
  /**
   * Release the SPI bus if there are no objections
   */
  async command error_t ChipSpiResource.attemptRelease() {
    return attemptRelease();
  }
  
  /***************** Resource Commands *****************/
  async command error_t Resource.request[ uint8_t id ]() {
    
    atomic {
      if ( call SpiResourceState.requestState(S_BUSY) == SUCCESS ) {
        m_holder = id;
        if(call SpiResource.isOwner()) {
          post grant();
          
        } else {
          return call SpiResource.request();
        }
        
      } else {
        m_requests |= 1 << id;
      }
    }
    return SUCCESS;
  }
  
  async command error_t Resource.immediateRequest[ uint8_t id ]() {
    error_t error;
    
    atomic {
      if ( call SpiResourceState.requestState(S_BUSY) != SUCCESS ) {
        return EBUSY;
      }
      
      if(call SpiResource.isOwner()) {
        m_holder = id;
        error = SUCCESS;
      
      } else if ((error = call SpiResource.immediateRequest()) == SUCCESS ) {
        m_holder = id;
        
      } else {
        call SpiResourceState.toIdle();
      }
    }

#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
    if(!error) {
      call Leds.led2On();
    }
#endif

    return error;
  }

  async command error_t Resource.release[ uint8_t id ]() {
    uint8_t i;
    
    atomic {
      if ( m_holder != id ) {
        return FAIL;
      }

      m_holder = NO_HOLDER;
      if ( !m_requests ) {
        call SpiResourceState.toIdle();
        attemptRelease();
        
      } else {
        for ( i = m_holder + 1; ; i++ ) {
          i %= RESOURCE_COUNT;
          
          if ( m_requests & ( 1 << i ) ) {
            m_holder = i;
            m_requests &= ~( 1 << i );
            post grant();
            return SUCCESS;
          }
        }
      }
    }
    
    return SUCCESS;
  }
  
  async command uint8_t Resource.isOwner[ uint8_t id ]() {
    atomic return (m_holder == id);
  }

  /***************** SpiResource Events ****************/
  event void SpiResource.granted() {
    post grant();
  }
  
  /***************** Fifo Commands ****************/
  async command blaze_status_t Fifo.beginRead[ uint8_t addr ]( uint8_t* data, 
      uint8_t len ) {
      
    blaze_status_t status;
    call State.forceState(S_READ_FIFO);
    status = call SpiByte.write( addr | BLAZE_BURST | BLAZE_READ );
    call Fifo.continueRead[ addr ]( data, len );
    
    return status;
  }

  async command error_t Fifo.continueRead[ uint8_t addr ]( uint8_t* data,
      uint8_t len ) {
      
    atomic m_addr = addr;
    call SpiPacket.send( NULL, data, len );
    return SUCCESS;
  }

  async command blaze_status_t Fifo.write[ uint8_t addr ]( uint8_t* data, 
      uint8_t len ) {
      
    uint8_t status;
    
    call State.forceState(S_WRITE_FIFO);    
    atomic m_addr = addr;
    status = call SpiByte.write( addr | BLAZE_BURST | BLAZE_WRITE );
    call SpiPacket.send( data, NULL, len );

    return status;
  }
  
  /***************** SpiPacket Events ****************/
  async event void SpiPacket.sendDone( uint8_t* tx_buf, uint8_t* rx_buf, 
      uint16_t len, error_t error ) {
      
    uint8_t status = call State.getState();
    call State.toIdle();
    
    if(status == S_INIT) {
      // Because we're in async context...
      post radioInitDone();
      
    } else if ( status == S_READ_FIFO ) {
      signal Fifo.readDone[ m_addr ]( rx_buf, len, error );
      
    } else if( status == S_WRITE_FIFO) {
      signal Fifo.writeDone[ m_addr ]( tx_buf, len, error );
    }
  }

  /***************** Reg Commands ****************/
  async command blaze_status_t Reg.read[ uint8_t addr ](uint8_t* data ) {
	blaze_status_t status;
	status = call SpiByte.write(addr | BLAZE_READ | BLAZE_SINGLE); 
	*data = call SpiByte.write(BLAZE_SNOP);
    return status;
  }

  async command blaze_status_t Reg.write[ uint8_t addr ]( uint8_t data ) {
    call SpiByte.write(addr | BLAZE_WRITE | BLAZE_SINGLE);
    return call SpiByte.write(data);
  }

  /***************** Strobe Commands ****************/
  async command blaze_status_t Strobe.strobe[ uint8_t addr ]() {
    return call SpiByte.write( addr );
  }

  /***************** RadioStatus Commands ****************/
  async command uint8_t RadioStatus.getRadioStatus() { 
    uint8_t ret;
    uint8_t chk;
    ret = getRadioStatus();
    /*** wait 'til we read the same value twice, a feature of these radios */
    while ((chk = getRadioStatus()) != ret) {
      ret = chk;
    }
    
    return ret;
  }


  /***************** Tasks ***************/
  task void radioInitDone() {
    signal RadioInit.initDone(); 
  }
  
  task void grant() {
    uint8_t holder;
    atomic { 
      holder = m_holder;
    }

#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
    call Leds.led2On();
#endif

    signal Resource.granted[ holder ]();
  }


  /***************** Functions ****************/
  uint8_t getRadioStatus(){
    //return BLAZE_S_RX;
    return ((call SpiByte.write(BLAZE_SNOP) >> 4) & 0x07);
  }

  error_t attemptRelease() {
    uint8_t atomicRequests;
    uint8_t atomicHolder;
    
    atomic {
      atomicRequests = m_requests;
      atomicHolder = m_holder;
    }
    
    if(atomicRequests > 0 
        || atomicHolder != NO_HOLDER 
        || !call SpiResourceState.isIdle()) {
      return FAIL;
    }
    
    atomic release = TRUE;
    // Users call back with ChipSpiResource.abortRelease() if needed:
    signal ChipSpiResource.releasing();
    atomic {
      if(release) {

#if BLAZE_ENABLE_SPI_WOR_RX_LEDS
        call Leds.led2Off();
#endif

        call SpiResource.release();
        return SUCCESS;
      }
    }
    
    return EBUSY;
  }
  
  /***************** Defaults ****************/
  default event void Resource.granted[ uint8_t id ]() { 
    call SpiResource.release();
  }
  
  default async event void Fifo.readDone[ uint8_t addr ]( uint8_t* rx_buf, uint8_t rx_len, error_t error ) {}
  default async event void Fifo.writeDone[ uint8_t addr ]( uint8_t* tx_buf, uint8_t tx_len, error_t error ) {}
  
  default event void RadioInit.initDone() {}
  
  
  default async event void ChipSpiResource.releasing() {
  }
  
  
}
