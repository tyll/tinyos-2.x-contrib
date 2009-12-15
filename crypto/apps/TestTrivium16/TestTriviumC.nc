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
 *	Implementation of TestTrivium16.
*/

#define MSG_LEN 12

module TestTriviumC{
	uses interface Boot;
	uses interface trivium;
}

implementation{

	/*
	 * 	Transmitter internal state.
	 */
	uint16_t s1[6],s2[6],s3[7];

	/*
	 * Receiver internal state.
	 */
	uint16_t s12[6],s22[6],s32[7];

	/*
	 * Secret key
	 */
	uint8_t K[10] =  {0x0f,0x62,0xB5,0x08,0x5B,0xAE,0x01,0x54,0xA7,0xFA};

	/*
	 * Initialization vector
	 */
	uint8_t IV[10] = {0x28,0x8F,0xF6,0x5D,0xC4,0x2B,0x92,0xF9,0x60,0xC7};

	uint8_t out[MSG_LEN];
	uint8_t msg1[MSG_LEN];
	uint8_t i;

	event void Boot.booted()
	{
		/*
		 * Message
		 */
		msg1[0] = 'H';msg1[1] = 'e';msg1[2] = 'l';msg1[3] = 'l';msg1[4] = 'o';msg1[5] = ' ';
		msg1[6] = 'w';msg1[7] = 'o';msg1[8] = 'r';msg1[9] = 'l';msg1[10] = 'd';msg1[11] = '\0';

		/*
		 * 	Key initialisation for the transmitter.
		 */
		call trivium.key_init(s1,s2,s3, K, IV);
		dbg("Boot", "Key init done @ Time: %s\n", sim_time_string());

		dbg("Boot", "Message: %s\n", msg1);

		/*
		 * Encryption of the message.
		 */
		call trivium.process_bytes(s1,s2,s3,msg1,out,MSG_LEN);

		dbg("Boot", "Encryption (hexadecimal): ");
		for(i=0;i<MSG_LEN;i++){
			dbg_clear("Boot", "%02x", out[i]);
		}
		dbg_clear("Boot", "\n");

		/*
		 * 	Key initialisation for the receiver.
		 */
		call trivium.key_init(s12,s22,s32, K, IV);
		dbg("Boot", "Key init done @ Time: %s\n", sim_time_string());
		/*
		 * Decryption of the message.
		 */

		call trivium.process_bytes(s12,s22,s32,out,msg1,MSG_LEN);
		dbg("Boot", "Message decryted : %s\n", msg1);
	}
}
