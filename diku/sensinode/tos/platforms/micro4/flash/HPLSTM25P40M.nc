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


/*These macros control flash select signal and assume correct bus state*/
#define FLASH_SELECT(x) P3OUT &= ~0x01
#define FLASH_UNSELECT(x) P3OUT |= 0x01

/*Flash control commands*/
#define M25P_WREN 0x06
#define M25P_WRDI 0x04
#define M25P_RDID 0x9F
#define M25P_RDSR 0x05
#define M25P_WRSR 0x01
#define M25P_READ 0x03
#define M25P_FAST_READ 0x0B
#define M25P_PP   0x02
#define M25P_SE   0xD8
#define M25P_BE   0xC7
#define M25P_DP   0xB9
#define M25P_RES  0xAB

/** Flash status register bits */
#define FLASH_SR_SRWD 0x80 /*!< Status register write protect */
#define FLASH_SR_BP2  0x10 /*!< Block protect bit 2*/
#define FLASH_SR_BP1  0x08 /*!< Block protect bit 1*/
#define FLASH_SR_BP0  0x04 /*!< Block protect bit 0*/
#define FLASH_SR_WEL  0x02 /*!< Write enable latch*/
#define FLASH_SR_WIP  0x01 /*!< Write in progress (busy)*/


module HPLSTM25P40M {
	provides {
		interface HPLSTM25P40 as HPLFlash;
	}

	uses {
		interface StdOut;
		interface Spi;
	}
}

implementation {

	bool flashBusy();
	void flashWait();


	/**********************************************************************
	 * Flash read
	 *********************************************************************/
	/**
	 * Read flash block.
	 *
	 *
	 * \param address block address on flash
	 * \param buffer  pointer to buffer
	 * \param length  length of read buffer
	 *
	 * \return SUCCESS
	 * \return FAIL	bus not free or init failed
	 */
	command error_t HPLFlash.read(uint32_t address, uint8_t *buffer, uint16_t length)
	{
		uint16_t i;
		uint8_t * p = buffer;

		/***********************************************
		** Read flash into buffer
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_READ);
		call Spi.write(address >> 16);
		call Spi.write(address >> 8);
		call Spi.write(address);

		for (i = 0; i < length; i++)
		{
			*p++ = call Spi.write(0);
		}
		FLASH_UNSELECT();
		
		return SUCCESS;
	}
	

	/**
	 * Fast Read flash block.
	 *
	 *
	 * \param address block address on flash
	 * \param buffer  pointer to buffer
	 * \param length  length of read buffer
	 *
	 * \return SUCCESS
	 * \return FAIL	bus not free or init failed
	 */
	command error_t HPLFlash.fastRead(uint32_t address, uint8_t *buffer, uint16_t length)
	{
		uint16_t i;
		uint8_t *p = buffer;

		/***********************************************
		** Fast read flash into buffer
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_FAST_READ);
		call Spi.write(address >> 16);
		call Spi.write(address >> 8);
		call Spi.write(address);
		call Spi.write(0);

		for (i = 0; i< length ; i++)
		{
			*p++ = call Spi.write(0);
		}

		FLASH_UNSELECT();

		return SUCCESS;
	}
	

	/**********************************************************************
	 * Flash write
	 *********************************************************************/
	/**
	 * Write flash page. Page size is 256 bytes.
	 * Write address must point at start of page.
	 *
	 * \param address block address on flash
	 * \param buffer  pointer to buffer
	 * \param length  length of read buffer
	 *
	 * \return SUCCESS
	 * \return FAIL		bus not free or buffer too long
	 */
	command error_t HPLFlash.write(uint32_t address, uint8_t *buffer, uint16_t length)
	{
		uint16_t i;
		uint8_t *p = buffer;

		/***********************************************
		** Enable write mode
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_WREN);
		FLASH_UNSELECT();

		TOSH_uwait(10);

		/***********************************************
		** Write buffer to page, starting at address
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_PP);
		call Spi.write(address >> 16);
		call Spi.write(address >> 8);
		call Spi.write(address);

		for (i = 0; i< length ; i++)
		{
			call Spi.write(*p++);
		}
		FLASH_UNSELECT();

		TOSH_uwait(10);

		/***********************************************
		** Disable write mode
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_WRDI);
		FLASH_UNSELECT();

		return SUCCESS;
	}



	/**********************************************************************
	 * Flash erase
	 *********************************************************************/
	/**
	 * Flash sector erase. Sector size is 64 kilobytes.
	 * Address must point at start of sector.
	 *
	 * \param address block address on flash
	 *
	 * \return SUCCESS
	 * \return FAIL		bus not free 
	 */
	command error_t HPLFlash.sectorErase(uint32_t address)
	{

		/***********************************************
		** Enable write mode
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_WREN);
		FLASH_UNSELECT();

		TOSH_uwait(10);

		/***********************************************
		** Erase sector holding address
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_SE);
		call Spi.write(address >> 16);
		call Spi.write(address >> 8);
		call Spi.write(address);
		FLASH_UNSELECT();

		TOSH_uwait(10);

		/***********************************************
		** Disable write mode
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_WRDI);
		FLASH_UNSELECT();


		return SUCCESS;
	}

	/**
	 * Flash bulk erase. 
	 * Erases entire flash
	 *
	 * \return SUCCESS
	 * \return FAIL	bus not free 
	 */
	command error_t HPLFlash.bulkErase()
	{

		/***********************************************
		** Enable write mode
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_WREN);
		FLASH_UNSELECT();

		TOSH_uwait(10);

		/***********************************************
		** Bulk erase
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_BE);
		FLASH_UNSELECT();

		TOSH_uwait(10);

		/***********************************************
		** Disable write mode
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_WRDI);
		FLASH_UNSELECT();

		return SUCCESS;
	}


	/**********************************************************************
	 * Flash power management
	 *********************************************************************/
	/**
	 * Deep Power-down. 
	 *
	 * \return SUCCESS
	 * \return FAIL		bus not free
	 */
	command error_t HPLFlash.sleep()
	{

		/***********************************************
		** Send command to enter deep power-down
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_DP);
		FLASH_UNSELECT();

        TOSH_uwait(10);

		return SUCCESS;
	}

	/**
	 * Flash signature read. Wakes the device up from power down mode.
	 * Signature value should be 0x12 if the flash is present and working.
	 *
	 * \return signature value
	 * \return -1	bus not free
	 */
	command int16_t HPLFlash.wakeUp()
	{
		int16_t retval;

		/***********************************************
		** Read signature
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_RES);
		call Spi.write(0);
		call Spi.write(0);
		call Spi.write(0);
		retval = call Spi.write(0);
		FLASH_UNSELECT();
		
		TOSH_uwait(10);

		return retval;
	}


	/**********************************************************************
	 * Flash services
	 *********************************************************************/
	/**
	 * Flash identification read. 
	 * Only available in chips with Process Technology code X
	 *
	 * \return id value
	 * \return -1	bus not free
	 */
	command int32_t HPLFlash.readIdentification()
	{
		int32_t retval;

		/***********************************************
		** Read identification
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_RDID);
		retval = call Spi.write(0);
		retval = (retval << 8) + call Spi.write(0);
		retval = (retval << 8) + call Spi.write(0);
		FLASH_UNSELECT();

		return retval;
	}

	/**
	 * Flash status register read. 
	 *
	 * \return status register value
	 * \return -1		bus not free
	 */
	command int16_t HPLFlash.readStatus()
	{
		int16_t retval;

		/***********************************************
		** Read status register
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_RDSR);
		retval = call Spi.write(M25P_RDSR);
		FLASH_UNSELECT();

		return retval;
	}

	/**
	 * Flash status register write. 
	 *
	 * \return SUCCESS
	 * \return FAIL		bus not free
	 */
	command error_t HPLFlash.writeStatus(uint8_t value)
	{

		/***********************************************
		** Enable write mode
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_WREN);
		FLASH_UNSELECT();

		TOSH_uwait(10);

		/***********************************************
		** Write status register
		***********************************************/
		FLASH_SELECT();
		call Spi.write(M25P_WRSR);
		call Spi.write(value);
		FLASH_UNSELECT();

		return SUCCESS;
	}



	/**********************************************************************
	 * Checks if flash is writing
	 *********************************************************************/
	command error_t HPLFlash.isFree() {
		uint8_t status;

		FLASH_SELECT();
		call Spi.write(M25P_RDSR);
		status = call Spi.write(0);
		FLASH_UNSELECT();

		TOSH_uwait(10);
	
		if (status & FLASH_SR_WIP) {
			return FAIL;
		} else {
			return SUCCESS;
		}
	}

	async event void StdOut.get(uint8_t data) {

	}

}
