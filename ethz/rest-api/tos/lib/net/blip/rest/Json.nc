/* Copyright (c) 2009, Distributed Computing Group (DCG), ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  @author Lars Schor <lschor@ee.ethz.ch>
* 
*/

interface Json{
	
	/************ Collection *****************/
	
	/**
	 * Create a collection
	 * 
	 * <p>
	 * A collection includes all elements the resource provides
	 * </p>
	 * @param col Pointer to the collection
	 * @param name Type of the message (i.e. res or col)
	 */ 
	command void createCollection(char *col, char *name);  
	 
	/**
	 * Add a element to the collection
	 * 
	 * <p>
	 * Add a special element to this collection
	 * </p>
	 * @param first 1 if it is the first element one adds
	 */
	command void addToCollection(char *col, char *elem, uint8_t first);
	
	/**
	 * Finish the collection
	 * 
	 * <p>
	 * Complets the collection to form a correct JSON packet
	 * </p>
	 */
	command uint16_t finishCollection(char *col);  
	
	/************ Member / Element *****************/
	
	/**
	 * Create an element
	 * 
	 * <p>
	 * Create an element to send as JSON packet
	 * </p>
	 * @param buf Pointer to the element
	 * @param name name of the element
	 */
	command void createElement(char * buf, char *name); 
	
	/**
	 * Adds the supported methods to the element
	 * 
	 * <p>
	 * Supported Methods: Defined in the header file "Rest.h"
	 * </p>
	 * @param method[] Array with the methods supported
	 * @param len number of methods that are supported
	 */	
	command void addMethod(char * jsonElement, uint8_t method[], uint8_t len); 
	
	/**
	 * Add an integer Value 
	 * 
	 * <p>
	 * Add an integer Value to the paramter list
	 * </p>
	 * @param update 1 if it is updatable
	 * @param first 1 if it is the first paramter one adds
	 * @param type datatype (i.e. b (binary) or i (integer)); 
	 */
	command void addParamInt(char *jsonElement, char *name, uint16_t value, char *type, uint8_t update, uint8_t first); 
	
	/**
	 * Add an float Value 
	 * 
	 * <p>
	 * Add an float Value to the paramter list
	 * </p>
	 * @param update 1 if it is updatable
	 * @param first 1 if it is the first paramter one adds
	 */
	command void addParamFloat(char * jsonElement, char *name, float value, uint8_t update, uint8_t first); 
	
	/**
	 * Add a string Value
	 * 
	 * <p>
	 * Add a string Value to the parameter list
	 * </p>
	 */
	command void addParamString(char * jsonElement, char *name,  char *value, uint8_t update, uint8_t first);
	
	/**
	 * Finish the element / member
	 * 
	 * <p>
	 * Completes the element / member to form a correct JSON packet
	 * </p>
	 */
	command uint16_t finishElement(char * buf); 
}