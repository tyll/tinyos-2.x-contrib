/**
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
/* 
 * Copyright (c) 2006, Ecole Polytechnique Federale de Lausanne (EPFL),
 * Switzerland.
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
 * - Neither the name of the Ecole Polytechnique Federale de Lausanne (EPFL) 
 *   nor the names of its contributors may be used to 
 *   endorse or promote products derived from this software without 
 *   specific prior written permission.
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
 * ========================================================================
 */

/**
 * @author Jonathan Hui <jhui@archrock.com>
 * @author Henri Dubois-Ferriere
 * @version $Revision$ $Date$
 */

module SX1211SpiImplP {

    provides interface SX1211Fifo as Fifo @atmostonce();
    provides interface SX1211Register as Reg;//[uint8_t id];

    provides interface Init @atleastonce();

    provides interface Resource[ uint8_t id ];

    uses interface Resource as SpiResource;
    uses interface GeneralIO as NssDataPin;
    uses interface GeneralIO as NssConfigPin;
    uses interface SpiByte;
}

implementation {

#include "sx1211debug.h"

    enum {
	RESOURCE_COUNT = uniqueCount( "SX1211Spi.Resource" ),
	NO_HOLDER = 0xff,
    };


    bool m_resource_busy = FALSE;
    uint8_t m_requests = 0;
    uint8_t m_holder = NO_HOLDER;

    command error_t Init.init() {
	// useless..  done in set pin directions
    	atomic {
	call NssDataPin.makeOutput();
	call NssConfigPin.makeOutput();
	call NssDataPin.set();
	call NssConfigPin.set();
    	}
	return SUCCESS;
    }

    async command error_t Resource.request[ uint8_t id ]() {
	atomic {
	    if ( m_resource_busy )
		m_requests |= 1 << id;
	    else {
		m_holder = id;
		m_resource_busy = TRUE;
		
		call SpiResource.request();
	    }
	}
	return SUCCESS;
    }
  
    async command error_t Resource.immediateRequest[ uint8_t id ]() {
	error_t error;
	atomic {
	    if ( m_resource_busy )
		return EBUSY;
	    error = call SpiResource.immediateRequest();
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
	    if ( m_holder != id ) {
		sx1211check(11, 1);
		return FAIL;
	    }

	    m_holder = NO_HOLDER;
	    call SpiResource.release();
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
			call SpiResource.request();
			return SUCCESS;
		    }
		}
	    }
	    return SUCCESS;
	}
    }
  
    async command uint8_t Resource.isOwner[ uint8_t id ]() {
	atomic return (m_holder == id);
    }

    event void SpiResource.granted() {
	uint8_t holder;
	atomic holder = m_holder;
	signal Resource.granted[ holder ]();
    }


 default event void Resource.granted[ uint8_t id ]() {
 }

 async command error_t Fifo.write(uint8_t* data, uint8_t length) __attribute__ ((noinline)){
	 uint8_t i;
	 uint8_t *pos=data;
	 
#if 1
     if (call NssDataPin.get() == 0 || call NssConfigPin.get() == 0)
	 sx1211check(8, 1);
#endif

     // as NSS_DATA needs to be (de-)asserted after every byte, there is no advantage using SpiPacket..
     atomic { // clr, write, set are all atomic, (maybe) save some nesc_atomics..
     for (i=0;i<length;i++) {
    	 call NssDataPin.clr();
    	 call SpiByte.write(*pos);
    	 call NssDataPin.set();    
    	 pos++;
     }
     }
     return SUCCESS;
 }

 async command error_t Fifo.read(uint8_t* data, uint8_t length) {
     uint8_t i;
     uint8_t *pos=data;
#if 1
     if (call NssDataPin.get() != TRUE || call NssConfigPin.get() != TRUE)
	 sx1211check(5, 1);
#endif

     // as NSS_DATA needs to be (de-)asserted after every byte, there is no advantage using SpiPacket..
     atomic {
     for (i=0;i<length;i++) {
    	 call NssDataPin.clr();
    	 *pos = call SpiByte.write(0);
    	 call NssDataPin.set();    
    	 pos++;
     }
     }
     return SUCCESS;
 }

 async command void Reg.read(uint8_t addr, uint8_t* data) 
 {
#if 1
     if (call NssDataPin.get() != TRUE || call NssConfigPin.get() != TRUE)
	 sx1211check(6, 1);
#endif
     atomic {
     call NssConfigPin.clr();
     call SpiByte.write(SX1211_READ(addr));
     *data = call SpiByte.write(0);
     call NssConfigPin.set();
     }
 }

 async command void Reg.write(uint8_t addr, uint8_t data) 
 {
#if 1
     if (call NssDataPin.get() != TRUE || call NssConfigPin.get() != TRUE)
	 sx1211check(7, 1);
#endif
     atomic {
     call NssConfigPin.clr();
     call SpiByte.write(SX1211_WRITE(addr));
     call SpiByte.write(data);
     call NssConfigPin.set();
     }
 }

}
