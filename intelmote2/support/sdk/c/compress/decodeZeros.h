/*
* Copyright (c) 2006 Stanford University.
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
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission
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
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 
 
uint32_t decodeZeros(uint8_t *dataIn, unsigned char *dataOut,
	 		    uint32_t size, uint32_t maxSize)
{
  uint32_t i,j, idx=0;
  
  for (i=0; i<size; i++)
  {
    if ((dataIn[i]&0x80) == 0)
    {
  	  if (dataIn[i]==0)
  	  {//zeroes until the end of the file
  	    while (idx<maxSize)
          dataOut[idx++]=0;
    		return idx;
  	  }
	  
      for (j=0; j<dataIn[i]; j++)
        dataOut[idx++]=0;
    }
    else
  	{
      int8_t value = dataIn[i];
      value = (value>-65)?(value&0x7F)-128:value&0x7F;
      dataOut[idx++]=value;
	  }
  }
  return idx;
}

static inline void decodeDC(uint8_t *dataIn, uint8_t *dataOut, uint16_t dataSize)
{
  uint16_t i;
  dataOut[0]=dataIn[0];
  for (i=1; i<dataSize; i++)
    dataOut[i]=dataOut[i-1]-dataIn[i];
}

