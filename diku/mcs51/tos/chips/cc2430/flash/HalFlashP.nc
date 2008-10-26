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
 * @author Marcus Chang <marcus@diku.dk>
 */

module HalFlashP {
    provides interface Init;
    provides interface HalFlash;
}

implementation {

    /**************************************************************************
    ** 8051 assembler code. 
    **
    ** Flash write and erase instructions must be run from RAM. To update 
    ** assembler code, edit flashErasePage.a51 and flashWritePage.a51 in
    ** ../tos/chips/cc2430/flash, compile assembler file and insert instructions
    ** in the two arrays below. Only the instruction between the labels 
    ** eraseFlashProcStart/eraseFlashProcEnd and eraseFlashProcStart/
    ** eraseFlashProcEnd need to be inserted
    **************************************************************************/
    uint8_t_xdata eraseFunctionBuffer[] = 
            { 0x75, 0xAE, 0x01, 0x00, 0xE5, 0xAE, 0x54, 0x80, 0x70, 0xFA, 0x22 };
    uint8_t_xdata writeFunctionBuffer[] = 
                    { 0x7B, 0x01, 0x10, 0xAF, 0x02, 0x7B, 0x00, 0xC0, 0x83, 0xC0,
                      0x82, 0xC0, 0x85, 0xC0, 0x84, 0xC0, 0x92, 0xEA, 0xF5, 0x83,
                      0xE9, 0xF5, 0x82, 0x75, 0x92, 0x00, 0xE5, 0xAE, 0x54, 0x80,
                      0x70, 0xFA, 0x75, 0xAE, 0x02, 0xEC, 0x60, 0x17, 0x7A, 0x40,
                      0x79, 0x04, 0xE0, 0xA3, 0xF5, 0xAF, 0xD9, 0xFA, 0x75, 0xAF,
                      0x00, 0xE5, 0xAE, 0x54, 0x40, 0x70, 0xFA, 0xDA, 0xED, 0xDC,
                      0xE9, 0xED, 0x60, 0x19, 0xED, 0x54, 0xFC, 0x03, 0x03, 0xFD, 
                      0x79, 0x04, 0xE0, 0xA3, 0xF5, 0xAF, 0xD9, 0xFA, 0x75, 0xAF,
                      0x00, 0xE5, 0xAE, 0x54, 0x40, 0x70, 0xFA, 0xDD, 0xED, 0xD0, 
                      0x92, 0xD0, 0x84, 0xD0, 0x85, 0xD0, 0x82, 0xD0, 0x83, 0xEB,
                      0x60, 0x02, 0xD2, 0xAF, 0x22 };
    
    void (*eraseFunction)();    
    void (*writeFunction)(uint8_t * data, uint16_t length);    

    command error_t Init.init() {
        
        eraseFunction = (void(*)()) eraseFunctionBuffer;
        writeFunction = (void(*)(uint8_t *, uint16_t)) writeFunctionBuffer;
            
        return SUCCESS;
    }


    command error_t HalFlash.read(uint8_t * destination, uint8_t * source, uint16_t length) { 
    
      memcpy((uint8_t_xdata*)destination, (uint8_t_xdata*)source, length);

        return SUCCESS;    
    }

    command error_t HalFlash.write(uint8_t * source, uint8_t * destination, uint16_t length) {
        uint8_t page, row, location;
        uint8_t old;

        page = (uint32_t) destination / 0x0800;
        row = ((uint32_t) destination % 0x0800) >> 8;
        location = (((uint32_t) destination % 0x0800) & 0xFF) >> 2;
        
        
        FADDRH = (page << 1) | (row >> 2);
        FADDRL = (row << 6) | location;
                
        FWT = 0x24;

        old = MEMCTR;
        MEMCTR |= 0x40;
        writeFunction(source, length);
        MEMCTR = old;                

        return SUCCESS;
    }
    
    command error_t HalFlash.erase(uint8_t * address) {
        uint8_t page;
        uint8_t old;

        page = ((uint32_t) address) / 0x0800;
        
        FADDRH = (page << 1);

        old = MEMCTR;
        MEMCTR |= 0x40;

        eraseFunction();

        MEMCTR = old;        

        return SUCCESS;
    }

}
