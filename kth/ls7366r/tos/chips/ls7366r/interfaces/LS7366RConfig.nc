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
 * Interface to configure the chip modes
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 * @see LS7366R.h
 */

interface LS7366RConfig {

	/**
	 * Sync configuration changes with the ls7366r hardware. This only
	 * applies to set commands below.
	 *
	 * @return SUCCESS if the request was accepted, FAIL otherwise.
	 */
	command error_t sync();
	/**
	 * This event is signalled when the synch command has finished
	 */
	event void syncDone( error_t error );

	/***************************************************************************************
	 * STR configuration
	 ***************************************************************************************/
	
	/**
	 * Get the actual state
	 * 
	 * @return state
	 */
	command uint8_t getState();
	/**
	 * Set the new state to the ls7366r
	 * 
	 * @param uint8_t new state value
	 */
	command void setState( uint8_t state );

	/***************************************************************************************
	 * MDR0 configuration
	 ***************************************************************************************/
	/**
	 * Get the current quadrature mode
	 * 
	 * @return quadrature value
	 */
	command uint8_t getQuadMode();
	/**
	 * Set the new quadrature mode
	 * 
	 * @param uint8_t new quadrature mode
	 */
	command void setQuadMode( uint8_t mode );

	/**
	 * Get the current running mode
	 * 
	 * @return running value
	 */
	command uint8_t getRunningMode();
	/**
	 * Set the new running mode
	 * 
	 * @param uint8_t new running mode
	 */
	command void setRunningMode( uint8_t mode );

	/**
	 * Get the current index configuration
	 * 
	 * @return index mode
	 */
	command uint8_t getIndex();
	/**
	 * Set the new current index configuration
	 * 
	 * @param uint8_t new index configuration
	 */
	command void setIndex( uint8_t index );

	/**
	 * Get the current index configuration
	 * 
	 * @return index mode
	 */
	command uint8_t getIndexSync();
	/**
	 * Set the new current index syncconfiguration
	 * 
	 * @param uint8_t new index sync configuration
	 */
	command void setIndexSync( uint8_t index );

	/***************************************************************************************
	 * MDR1 configuration
	 ***************************************************************************************/
	/**
	 * Get size of the counter in bytes
	 * 
	 * @return uint8_t
	 */
	command uint8_t getSize();
	/**
	 * Set the new counter size in bytes
	 * 
	 * @param uint8_t counter size
	 */
	command void setSize( uint8_t size );
	
	/**
	 * Get clock divisor configured
	 * 
	 * @return divisor
	 */
	command uint8_t getClkDiv();
	/**
	 * Set the new clock divisor desired
	 * 
	 * @param uint8_t new clock divisor
	 */
	command void setClkDiv( uint8_t clk_div );

	/**
	 * Get if the counter is enabled or not
	 * 
	 * @return TRUE if is disable, FALSE is enabled
	 */
	command bool getDisabled();
	/**
	 * Set the new size for the counter mdoe
	 * 
	 * @param uint8_t counter size in bytes
	 */
	command void setDisabled(bool enabled);
	
	/***************************************************************************************
	 * DTR configuration
	 ***************************************************************************************/
	/**
	 * Get DTR value. If N-Module counting mode is enabled
	 * it shall return the count range.
	 * 
	 * @return TRUE if is disable, FALSE is enabled
	 */
	command uint32_t getModule();
	/**
	 * Set the count range
	 * 
	 * @param uint8_t count range
	 */
	command void setModule(uint32_t module2);

}
