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
 
	//- run-length code all zeros assuming that all data are encoded using 7 bits,
	//  thus data|0x80 encodes data, num&0x7F encodes number of consecutive zeros,
	//  and 0 is a special symbol meaning that the rest of the data is all zeros
	//- dataIn contains input data
	//- dataOut is a placeholder for the run-length code
	//- dataSize is the size of the input data
	//- bandwidth specifies limit on the size of the encoded sequence, all entries
	//  beyond bandwidth will be set to zero
	//- command returns the length of the encoded sequence

static inline uint32_t codeZeros(uint8_t *dataIn, uint8_t *dataOut, uint32_t dataSize,
				   uint32_t bandwidth)
{

  uint32_t i;
  uint32_t idx=0;
	uint16_t zeroSeqLength=0, numZeroFreqs=0;

  for (i=0; (i<dataSize && idx<(bandwidth-3)); i++)
  {
    int8_t value = dataIn[i];
    if (value==0)
    {
      if (zeroSeqLength++==0x7F)
      {
        ++numZeroFreqs;
        zeroSeqLength=1;
      }
    }
    else
    {
      if (zeroSeqLength>0)
      {
        while (numZeroFreqs>0)
        {
          numZeroFreqs--;
          dataOut[idx++] = 0x7F;
        }
        dataOut[idx++] = zeroSeqLength&0x7F;
        zeroSeqLength = 0;
      }
      
      //hardcoded 7bits per value
      if (value<=-64)
        {value=-64;}
      else if (value>=63)
        {value = 63;}
      dataOut[idx++] = value|0x80;
    }
  }
  // zero(0) is a special symbol meaning that there are zeros until the end of file
//    if ( zeroSeqLength>0 ||
//        (idx<dataSize && idx>=bandwidth))
    dataOut[idx++]=0;

  return idx;//*/
}

static inline uint32_t codeDC(uint8_t *dataIn, uint8_t *dataOut, uint16_t dataSize)
{
  uint16_t i;
  dataOut[0]=dataIn[0];
  for (i=1; i<dataSize; i++)
    dataOut[i]=dataIn[i-1]-dataIn[i];
  return dataSize;
}
