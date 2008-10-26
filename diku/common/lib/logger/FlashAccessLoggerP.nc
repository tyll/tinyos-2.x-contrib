
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

module FlashAccessLoggerP {
    provides interface FlashAccess as FlashAccessLogger;
    provides interface StdControl as FlashControlLogger;
    provides event void sleeping();
    uses interface StdControl as FlashControl;
    uses interface FlashAccess;
    uses interface GeneralIO as ReadIO;
    uses interface GeneralIO as WriteIO;
    uses interface GeneralIO as EraseIO;
    
}

implementation {

    /**************************************************************************
    **************************************************************************/
    command error_t FlashControlLogger.start()
    {
        return call FlashControl.start();
    }

    command error_t FlashControlLogger.stop()
    {
        return call FlashControl.stop();
    }

    /**************************************************************************
    **************************************************************************/
    command uint16_t FlashAccessLogger.firstUsablePage()
    {
        return call FlashAccess.firstUsablePage();
    }
    
    command uint16_t FlashAccessLogger.lastUsablePage()
    {
        return call FlashAccess.lastUsablePage();
    }

    /*****************************************************/
    command error_t FlashAccessLogger.read(uint16_t page_no, void *page)
    {
        call ReadIO.set();
        return call FlashAccess.read(page_no, page);
    }
    
    event void FlashAccess.readReady(uint16_t page_no, void *page, uint16_t length)
    {
        call ReadIO.clr();
        signal FlashAccessLogger.readReady(page_no, page, length);
    }
    
    /*****************************************************/
    command error_t FlashAccessLogger.erase(uint16_t page_no)
    {
        call EraseIO.set();
        return call FlashAccess.erase(page_no);
    }
    
    event void FlashAccess.eraseDone(uint16_t page_no)
    {
        call EraseIO.clr();
        signal FlashAccessLogger.eraseDone(page_no);
    }
    
    /*****************************************************/
    command error_t FlashAccessLogger.eraseAll()
    {
        call EraseIO.set();
        return call FlashAccess.eraseAll();
    }
    
    event void FlashAccess.eraseAllDone()
    {
        call EraseIO.clr();
        signal FlashAccessLogger.eraseAllDone();
    }

    /*****************************************************/
    command error_t FlashAccessLogger.write(uint16_t page_no, void *page)
    {
        call WriteIO.set();
        return call FlashAccess.write(page_no, page);
    }
    
    event void FlashAccess.writeDone(uint16_t page_no, void *page)
    {
        call WriteIO.clr();
        signal FlashAccessLogger.writeDone(page_no, page);
    }

    /*****************************************************/
    event void sleeping() 
    {
      /*call ReadIO.clr();
        call WriteIO.clr();
        call EraseIO.clr();*/
    }
}
