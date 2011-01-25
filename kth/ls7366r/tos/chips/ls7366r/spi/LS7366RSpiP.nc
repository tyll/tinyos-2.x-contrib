/*
 * Copyright (c) 2010, KTH Royal Institute of Technology
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions 
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright 
 *   notice, this list of conditions and the following disclaimer in the 
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the KTH Royal Institute of Technology nor the names 
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY 
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */
/**
 * Component that manage the SPI resource and provides
 * the read/write function and the strobe commands
 * 
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 */

module LS7366RSpiP @safe() {

  provides {
    interface ChipSpiResource;
    interface Resource[ uint8_t id ];
    interface LS7366RRegister as Reg[ uint8_t id ];
    interface LS7366RStrobe as Strobe[ uint8_t id ];
  }
  
  uses {
    interface Resource as SpiResource;
    interface SpiByte;
    
    interface State as WorkingState;
    interface Leds;
  }
}

implementation {

  enum {
    RESOURCE_COUNT = uniqueCount( "LS7366RSpi.Resource" ),
    NO_HOLDER = 0xFF,
  };

  /** WorkingStates */
  enum {
    S_IDLE,
    S_BUSY,
  };

  /** Address to read/write on the LS7366R, also maintains caller's client id */
  norace uint16_t m_addr;
  
  /** Each bit represents a client ID that is requesting SPI bus access */
  uint8_t m_requests = 0;
  
  /** The current client that owns the SPI bus */
  uint8_t m_holder = NO_HOLDER;
  
  /** TRUE if it is safe to release the SPI bus after all users say ok */
  bool release;
  
  /***************** Prototypes ****************/
  error_t attemptRelease();
  task void grant();
  
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
      if ( call WorkingState.requestState(S_BUSY) == SUCCESS ) {
        m_holder = id;
        if(call SpiResource.isOwner()) {
          post grant();
          
        } else {
          call SpiResource.request();
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
      if ( call WorkingState.requestState(S_BUSY) != SUCCESS ) {
        return EBUSY;
      }
      
      
      if(call SpiResource.isOwner()) {
        m_holder = id;
        error = SUCCESS;
      
      } else if ((error = call SpiResource.immediateRequest()) == SUCCESS ) {
        m_holder = id;
        
      } else {
        call WorkingState.toIdle();
      }
    }
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
        call WorkingState.toIdle();
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
  /***************** Strobe Commands ****************/
  async command error_t Strobe.strobe[ uint8_t addr ]() {
      atomic {
        if(call WorkingState.isIdle()) {
          return EBUSY;
        }
      }
      // write the command in the SIMO bus
      call SpiByte.write( addr );
      
      return SUCCESS;
    }

  /***************** Register Commands ****************/
  async command error_t Reg.read[ uint8_t addr ]( uint8_t* data , uint8_t length) {
    	
	 uint8_t i = 0;
    atomic {
      if(call WorkingState.isIdle()) {
        return EBUSY;
      }
    }
    // write the instruction and the addres of the register in the SOMI bus
    call SpiByte.write( addr | LS7366R_OP_RD);
    //for each byte we want to read in the SOMI we write a dummy byte in the SIMO 
    for ( i = 0 ; i < length ; i++) *(data + i) = call SpiByte.write( 0 );

    return SUCCESS;

  }

  async command error_t Reg.readByte[ uint8_t addr ]( uint8_t* data) {

      atomic {
        if(call WorkingState.isIdle()) {
          return EBUSY;
        }
      }
      // write the instruction and the addres of the register in the SOMI bus
      call SpiByte.write(addr | LS7366R_OP_RD );
      // write a dummy byte in the SOMI and read the value of the SIMO
      *data = call SpiByte.write( 0 );

      
      return SUCCESS;
    }
    async command error_t Reg.read16b[ uint8_t addr ]( uint16_t* data) {

       atomic {
         if(call WorkingState.isIdle()) {
           return EBUSY;
         }
       }
       // write the instruction and the addres of the register in the SOMI bus
       call SpiByte.write(addr | LS7366R_OP_RD );
       // write a dummy byte in the SOMI and read the value of the SIMO
       *data = call SpiByte.write( 0 );
       *(data+1) = call SpiByte.write( 0 );

       
       return SUCCESS;
     }
  async command error_t Reg.writeByte[ uint8_t addr ]( uint8_t data) {

    atomic {
      if(call WorkingState.isIdle()) {
        return EBUSY;
      }
    }
    // write the instruction and the addres of the register in the SOMI bus
    call SpiByte.write(addr | LS7366R_OP_WR );
    // write the data we want to transmit
    call SpiByte.write( data );

    
    return SUCCESS;
  }
  async command error_t Reg.write16b[ uint8_t addr ]( uint16_t data) {

     atomic {
       if(call WorkingState.isIdle()) {
         return EBUSY;
       }
     }
     // write the instruction and the addres of the register in the SOMI bus
     call SpiByte.write(addr | LS7366R_OP_WR );
     // write the data we want to transmit
     call SpiByte.write( data >> 8 );
     call SpiByte.write( data & 0xFF );

     
     return SUCCESS;
   }
  async command error_t Reg.write32b[ uint8_t addr ]( uint32_t data) {

     atomic {
       if(call WorkingState.isIdle()) {
         return EBUSY;
       }
     }
     // write the instruction and the addres of the register in the SOMI bus
     call SpiByte.write(addr | LS7366R_OP_WR );
     // write the data we want to transmit
     call SpiByte.write( (data >> 24 ) & 0xFF);
     call SpiByte.write( (data >> 16 ) & 0xFF);
     call SpiByte.write( (data >> 8 ) & 0xFF);
     call SpiByte.write( data & 0xFF );
     
     return SUCCESS;
   }
  
  /***************** Functions ****************/
  error_t attemptRelease() {
    if(m_requests > 0 
        || m_holder != NO_HOLDER 
        || !call WorkingState.isIdle()) {
      return FAIL;
    }
    
    atomic release = TRUE;
    signal ChipSpiResource.releasing();
    atomic {
      if(release) {
        call SpiResource.release();
        return SUCCESS;
      }
    }
    
    return EBUSY;
  }
  
  task void grant() {
    uint8_t holder;
    atomic { 
      holder = m_holder;
    }
    signal Resource.granted[ holder ]();
  }

  /***************** Defaults ****************/
  default event void Resource.granted[ uint8_t id ]() {}

  default async event void ChipSpiResource.releasing() {}
  
}
