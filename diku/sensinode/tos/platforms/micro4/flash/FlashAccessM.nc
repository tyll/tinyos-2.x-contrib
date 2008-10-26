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
 * @author Klaus S. Madsen <klaussm@diku.dk>
 */


module FlashAccessM
{
    provides {
        interface Init as FlashInit;
        interface StdControl as FlashControl;
        interface FlashAccess;
    }
    uses interface HALSTM25P40 as Flash;
}

implementation
{

#define FIRST_PAGE 0x0000
#define LAST_PAGE 0x07FF
#define PAGE_SIZE 0x0100

    command error_t FlashInit.init()
    {       
        return call Flash.wakeUp();
    }

    command error_t FlashControl.start()
    {
        return call Flash.wakeUp();
    }

    command error_t FlashControl.stop()
    {
        return call Flash.sleep();
    }

    command uint16_t FlashAccess.firstUsablePage() {
    
        return FIRST_PAGE;
    }
    
    command uint16_t FlashAccess.lastUsablePage() {
    
        return LAST_PAGE;
    }

    /**
    * Read a page from the flash. 
    *
    * @param page_no The page to read from.
    * @param page    A buffer to hold the page bring read.
    * @return SUCCESS, the page could be read
    */
    command error_t FlashAccess.read(uint16_t page_no, void *page) {
    
        uint32_t address;

        if ( (FIRST_PAGE <= page_no) && (page_no <= LAST_PAGE) ) {
            address = page_no;
            address = address << 8;
    
            return call Flash.read(address, (uint8_t *) page, PAGE_SIZE);

        } else {
            return FAIL;
        }
    }

    event void Flash.readReady(uint32_t address, uint8_t *buffer, uint16_t length) {
        
        signal FlashAccess.readReady(address >> 8, buffer, length);
        
        return;
    }

    event void Flash.fastReadReady(uint32_t address, uint8_t *buffer, uint16_t length) {
        return;
    }

    /**
    * Erase the sector holding the page in the flash.
    *
    * @param page_no The page inside the sector.
    * @return SUCCESS, the sector was erased.
    */
    command error_t FlashAccess.erase(uint16_t page_no) {
    
        uint32_t address;

        if ( (FIRST_PAGE <= page_no) && (page_no <= LAST_PAGE) ) {
            address = page_no;
            address = address << 8;
    
            return call Flash.sectorErase(address);

        } else {
            return FAIL;
        }
    } 
    
    event void Flash.sectorEraseDone(uint32_t address)
    {
        signal FlashAccess.eraseDone(address >> 8);
    }

    /**
    * Erase the sector holding the page in the flash.
    *
    * @param page_no The page inside the sector.
    * @return SUCCESS, the sector was erased.
    */
    command error_t FlashAccess.eraseAll() {
    
        return call Flash.bulkErase();
    } 
    
    event void Flash.bulkEraseDone()
    {
        signal FlashAccess.eraseAllDone();
    }

    /**
    * Write a page to the flash
    *
    * <p>Note this function does not clear the page before the
    * write. This must be done by calling erase</p>
    *
    * @param page_no The page to write
    * @param page    A buffer containing the contents to write
    * @result SUCCESS, the self-programming has successfully finished.
    */
    command error_t FlashAccess.write(uint16_t page_no, void *page) { 

        uint32_t address;

        if ( (FIRST_PAGE <= page_no) && (page_no <= LAST_PAGE) ) {
            address = page_no;
            address = address << 8;
    
            return call Flash.write(address, (uint8_t *) page, PAGE_SIZE);
            
        } else {
            return FAIL;
        }
    }
    
    event void Flash.writeDone(uint32_t address, uint8_t *buffer, uint16_t length)
    {
        signal FlashAccess.writeDone(address >> 8, buffer);
    }


    /**
    * Event signaled when flash has gone to sleep.
    * Flash automatically goes into sleep mode when idle
    */
 /*   event void Flash.sleeping() {
    
    }
*/
}

