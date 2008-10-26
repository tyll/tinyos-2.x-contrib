/*
 * Copyright (c) 2007 University of Copenhagen
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
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *
 * @author Marcus Chang <marcus@diku.dk>
 */

module HalFlashP {
    provides interface HalFlash;
    uses interface HplFlash;
}

implementation {

    command error_t HalFlash.read(uint8_t * destination, uint8_t * source, uint16_t length) { 
    
        memcpy(destination, source, length);

        return SUCCESS;    
    }

    command error_t HalFlash.write(uint8_t * source, uint8_t * destination, uint16_t length) {
        uint8_t * src, * dst;
        uint8_t tmp;
        uint16_t rest;
    
        rest = length;
        src = source;
        dst = destination;
         

        while (rest > 0) {        

            /* maximum writable space left in this segment */        
            tmp = 0x40 - ((uint16_t) dst - (((uint16_t) dst) & ~0x3F));

            if (rest > tmp) {
                /* write tmp bytes */
                call HplFlash.write(src, dst, tmp);            

                /* update source and destination pointers */
                src = (uint8_t *) ((uint16_t) src + tmp);
                dst = (uint8_t *) ((uint16_t) dst + tmp);

                /* update number of remaining bytes */
                rest -= tmp;

            } else {
                /* write rest bytes */
                call HplFlash.write(src, dst, rest);            

                /* set remaining bytes to zero */
                rest = 0;
            }
        }
        
        return SUCCESS;
    }
    
    command error_t HalFlash.erase(uint8_t * address) {       

        call HplFlash.erase(address);

        return SUCCESS;
    }

}
