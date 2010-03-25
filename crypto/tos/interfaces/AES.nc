/*
* Copyright (c) 2010 Centre for Electronics Design and Technology (CEDT),
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

/**
 * 	Interface for the AES cipher in TinyOS.
 *  Implementation based on the Public domain implementation of Karl Malbrain (malbrain@yahoo.com)
 *  available at http://code.google.com/p/byte-oriented-aes/downloads/list.
 *  @author Sylvain Pelissier <sylvain.pelissier@gmail.com>
 */

interface AES{

    /**
     *  Compute the expanded key with the key schedule algorithm. It is independent of the plaintext so it as to be done
	 *	only once per key.
     *  @param expkey an array that contains the expanded key. It must be (NB_ROUND+1) * 16 bytes long.
     *  @param key the secret key.
     */
	command void keyExpansion(uint8_t *expkey, uint8_t *key);

    /**
     *  Encrypt one block of plaintext.
     *  @param in_block the input block of plaintext.
     *  @param expkey an array that contains the expanded key.
     *  @param out_block the resulting block of ciphertext.
     */
    command void encrypt(uint8_t *in_block, uint8_t *expkey, uint8_t *out_block);

    /**
     *  Decrypt one block of plaintext.
     *  @param in_block the input block of ciphertext.
     *  @param expkey an array that contains the expanded key.
     *  @param out_block the resulting block of plaintext.
     */
    command void decrypt(uint8_t *in_block, uint8_t *expkey, uint8_t *out_block);
}
