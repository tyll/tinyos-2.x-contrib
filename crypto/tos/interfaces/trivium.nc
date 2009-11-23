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

/*
 * 	Interface for the Trivium Stream cipher in TinyOS.
 */


#include "trivium.h"

interface trivium{
	/*
	* 	Key and IV initialisation, need to be perform once when the node boots.
	*	s1,s2,s3	:	the state of the algorithm.
    *                   if a 8-bit microcontroller is used, the sizes of each array are:
    *                   s1[12], s2[11] and s3[14].
    *                   if a 16-bit microcontroller is used:
    *                   s1[6], s2[6] and s3[7].
    *
	*	IV		    :	the initialization vector, 80 bits.
	*	K		    : 	the secret key, 80 bits.
	*/
	command void key_init(uint_t *s1,uint_t *s2, uint_t *s3, uint_t *K, uint_t *IV);


	/*
	*	Generation of 64 bits of random data which can be XORed with the plaintext or ciphertext.
	*/
	command void gen_keystream(uint_t *s1,uint_t *s2, uint_t *s3, uint_t *z);

    /*
    *   Encryption or decryption of a message contains in the variable "input" with length stored in
    *   the variable "length". the result is store in the "output" variable. s1, s2 and s3 represents
    *   the current state of the algorithm.
    */
    command void process_bytes(uint_t *s1,uint_t *s2, uint_t *s3,uint8_t *input, uint8_t *output, int32_t length);
}
