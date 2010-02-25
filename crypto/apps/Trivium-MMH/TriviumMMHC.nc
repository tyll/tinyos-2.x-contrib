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

/*
 *	Implementation of Trivium-MMH.
*/

module TriviumMMHC{
	uses interface Boot;
	uses interface MMH;
	uses interface trivium;
}

implementation{

	uint32_t h,tag;
	uint8_t s1[12],s2[11],s3[14];
	uint8_t z[8];
	
	/*
		Message. With MMH, the message need to have a fixed length.
	*/
    uint8_t m[16]  = 		{'h','e','l','l','o',' ','w','o','r','l','d',' ','!',0,0,0};

	/*
		Authentication key.
	*/
	uint32_t auth_key[4] = 	{268431451 ,730224437 ,577865670 ,763641067};

	/*
		Trivium key.
	*/
	uint8_t K[10] =  		{0x0f,0x62,0xB5,0x08,0x5B,0xAE,0x01,0x54,0xA7,0xFA};

	/*
		Trivium initialisation vector.
	*/
	uint8_t IV[10] = 		{0x28,0x8F,0xF6,0x5D,0xC4,0x2B,0x92,0xF9,0x60,0xC7};
	
	uint32_t *p1 = (uint32_t *)m;
	uint32_t *p2 = (uint32_t *)z;
    
	event void Boot.booted()
	{
		/*
			Trivium initialisation.
		*/
		call trivium.key_init(s1,s2,s3, K, IV);

		/*
			Message hashing.
		*/
        h = call MMH.hash(p1, auth_key,4);
		dbg("Boot", "Message hash: %x\n", h);
		call trivium.gen_keystream(s1,s2,s3,z);
		dbg("Boot", "Trivium key stream: %x\n", p2[0]);

		/*
			Authentication tag creation
		*/
		tag = p2[0] ^ h;
		dbg("Boot", "Authenticator: %x\n", tag);
		
	}
}
