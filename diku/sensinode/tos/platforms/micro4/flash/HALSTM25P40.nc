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


interface HALSTM25P40 {

    /**
     * Read flash block.
     *
     *
     * \param address block address on flash
     * \param buffer  pointer to buffer
     * \param length  length of read buffer
     *
     * \return SUCCESS
     * \return FAIL bus not free or init failed
     */
    command error_t read(uint32_t address, uint8_t *buffer, uint16_t length);
    event void readReady(uint32_t address, uint8_t *buffer, uint16_t length);

    /**
     * Fast Read flash block.
     *
     *
     * \param address block address on flash
     * \param buffer  pointer to buffer
     * \param length  length of read buffer
     *
     * \return SUCCESS
     * \return FAIL bus not free or init failed
     */
    command error_t fastRead(uint32_t address, uint8_t *buffer, uint16_t length);
    event void fastReadReady(uint32_t address, uint8_t *buffer, uint16_t length);

    /**
     * Write flash page. Page size is 256 bytes.
     * Write address must point at start of page.
     *
     * \param address block address on flash
     * \param buffer  pointer to buffer
     * \param length  length of read buffer
     *
     * \return SUCCESS
     * \return FAIL     bus not free or buffer too long
     */
    command error_t write(uint32_t address, uint8_t *buffer, uint16_t length);
    event void writeDone(uint32_t address, uint8_t *buffer, uint16_t length);

    /**
     * Flash sector erase. Sector size is 64 kilobytes.
     * Address must point at start of or within sector.
     *
     * \param address block address on flash
     *
     * \return SUCCESS
     * \return FAIL     bus not free 
     */
    command error_t sectorErase(uint32_t address);
    event void sectorEraseDone(uint32_t address);

    /**
     * Flash bulk erase. 
     * Erases entire flash
     *
     * \return SUCCESS
     * \return FAIL bus not free 
     */
    command error_t bulkErase();
    event void bulkEraseDone();

    /**
     * Deep Power-down. 
     *
     * \return SUCCESS
     * \return FAIL     bus not free
     */
    command error_t sleep();
//    event void sleeping();

    /**
     * Flash signature read. Wakes the device up from power down mode.
     * Signature value should be 0x12 if the flash is present and working.
     *
     * \return signature value
     * \return -1   bus not free
     */
    command error_t wakeUp();

}
