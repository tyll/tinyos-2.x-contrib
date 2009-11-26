/*
* Copyright (c) 2009 Centre for Electronics Design and Technology (CEDT),
*  Indian Institute of Science (IISc) and Laboratory for Cryptologic
*  Algorithms (LACAL), Ecole Polytechnique Federale de Lausanne (EPFL).
*
* Author: Sylvain Pelissier <sylvain.pelissier@gmail.com>
*
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
* - Neither the name of INSERT_AFFILIATION_NAME_HERE nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "trivium.h"

/**
 * 	Interface for the Trivium Stream cipher in TinyOS.
 *  @author Sylvain Pelissier <sylvain.pelissier@gmail.com>
 */

interface trivium{
	/**
	* 	Initialisation of the states from the key and the IV. It needs to be performed once when the node boots.
	*   <br>
	*	@param s1 The state of the algorithm. Represent s[1] to s[93] of the original specification. If EIGHT_BIT_MICROCONTROLLER
	*   is defined, s1 must be an array of 12 elements. If SIXTEEN_BIT_MICROCONTROLLER
	*   is defined, s1 must be an array of 6 elements.
	*   <br><br>
	*	@param s2 The state of the algorithm. Represent s[94] to s[177] of the original specification. If EIGHT_BIT_MICROCONTROLLER
	*   is defined, s2 must be an array of 11 elements. If SIXTEEN_BIT_MICROCONTROLLER
	*   is defined, s2 must be an array of 6 elements.
	*   <br><br>
	*   @param s3 The state of the algorithm. Represent s[178] to s[288] of the original specification. If EIGHT_BIT_MICROCONTROLLER
	*   is defined, s3 must be an array of 14 elements. If SIXTEEN_BIT_MICROCONTROLLER
	*   is defined, s3 must be an array of 7 elements.
    *   <br><br>
	*	@param IV the initialization vector, 10 bytes.
	*	@param K  the secret key, 10 bytes.
	*/
	command void key_init(uint_t *s1,uint_t *s2, uint_t *s3, uint8_t *K, uint8_t *IV);


	/**
	*	Generation of  bytes of random data which can be XORed with the plaintext or ciphertext.<br>
	*   @param z 8 bytes of keystream.
	*/
	command void gen_keystream(uint_t *s1,uint_t *s2, uint_t *s3, uint_t *z);

    /**
    *   Encryption or decryption of a message.
    *   @param input message to be encrypted or decrypted.
    *   @param output the output of the algorithms.
    *   @param length the length of the message.
    */
    command void process_bytes(uint_t *s1,uint_t *s2, uint_t *s3,uint8_t *input, uint8_t *output, int32_t length);
}
