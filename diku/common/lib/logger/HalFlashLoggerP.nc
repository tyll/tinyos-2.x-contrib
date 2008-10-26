
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
 * Log recording layer
 *
 * @author Marcus Chang <marcus@diku.dk>
 * @author Martin Leopold <leopold@diku.dk>
 */

module HalFlashLoggerP {
    provides interface HalFlash as HalFlashLogger;
    uses interface HalFlash;
    uses interface GeneralIO as ReadIO;
    uses interface GeneralIO as WriteIO;
    uses interface GeneralIO as EraseIO;
}

implementation {

    command error_t HalFlashLogger.read(uint8_t * destination, uint8_t * source, uint16_t length) 
    {
        call ReadIO.set();       
        call HalFlash.read(destination, source, length);
        call ReadIO.clr();       
        
        return SUCCESS;
    }

    command error_t HalFlashLogger.write(uint8_t * source, uint8_t * destination, uint16_t length) 
    {
        call WriteIO.set();       
        call HalFlash.write(source, destination, length);
        call WriteIO.clr();       
        
        return SUCCESS;
    }
    
    command error_t HalFlashLogger.erase(uint8_t * address) 
    {
        call EraseIO.set();
        call HalFlash.erase(address);
        call EraseIO.clr();

        return SUCCESS;
    }

}
