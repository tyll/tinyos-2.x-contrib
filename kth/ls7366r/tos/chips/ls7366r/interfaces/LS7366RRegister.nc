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
 * Interface that provides functions to read and write values
 * of the LS7366R
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 */

#include "LS7366R.h"

interface LS7366RRegister {

	/**
	 * Read an undefined number of bytes
	 * 
	 * @param
	 * 		*data	vector of bytes to return 
	 * 		length	number of bytes to read
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t read( uint8_t* data, uint8_t length);

	/**
	 * Read a word, 2 bytes
	 * 
	 * @param
	 * 		*data	variable to store the result
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t read16b(uint16_t* data);
	
	/**
	 * Read a byte
	 * 
	 * @param
	 * 		*data	variable to store the result
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t readByte(uint8_t* data);


	/**
	 * Write 4 bytes, 32 bits
	 * 
	 * @param
	 * 		data	data to write in a register
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t write32b(uint32_t data);
	
	/**
	 * Write a word, 2 bytes
	 * 
	 * @param
	 * 		data	data to write in a register
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t write16b(uint16_t data);

	/**
	 * Write a byte
	 * 
	 * @param
	 * 		data	data to write in a register
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t writeByte(uint8_t data);
	
	

}
