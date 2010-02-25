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
*	Implementation of the Poly32 interface.
*/

module Poly32C{

	provides interface polyp32;

}

implementation{

    uint32_t p = 0xfffffffb;
    uint32_t marker = 0xfffffffa;

	command uint32_t Poly32.hash(uint32_t *m, uint32_t key, uint16_t l)
	{
	    uint16_t i;
        uint64_t z;
        uint32_t a,b,y;

        /*
         *   Pad with one.
         */
        y=1;

        for(i=0;i<l;i++)
        {
            if(m[i] >= p-1)
            {
                z = (uint64_t)key*y;
                b = (uint32_t)z;
                a = (uint32_t)(z>>32);
                y = 5*a;
                y += b;

                if(y < b)
                {
                    y += 5;
                }

                y += marker;
                if(y < marker)
                {
                    y += 5;
                }

                z = (uint64_t)key*y;
                b = (uint32_t)z;
                a = (uint32_t)(z>>32);
                y = 5*a;
                y += b;

                if(y < b)
                {
                    y += 5;
                }

                y += (m[i]-5);
                if(y < (m[i]-5))
                {
                    y += 5;
                }

            }
            else
            {
                z = (uint64_t)key*y;
                b = (uint32_t)z;
                a = (uint32_t)(z>>32);
                y = 5*a;
                y += b;

                if(y < b)
                {
                    y += 5;
                }

                y += m[i];
                if(y < m[i])
                {
                    y += 5;
                }
            }

        }
		return y;
	}

}
