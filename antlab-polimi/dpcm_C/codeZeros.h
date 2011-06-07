static inline uint32_t codeZeros(uint8_t *dataIn, uint8_t *dataOut, uint32_t dataSize,
				   uint32_t bandwidth)
{

  uint32_t i;
  uint32_t idx=0;
  uint16_t zeroSeqLength=0, numZeroFreqs=0;

  for (i=0; (i<dataSize && idx<(bandwidth-3)); i++)
  {

    if (dataIn[i]==0)
    {

     if (zeroSeqLength++==0xFF)
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
	  dataOut[idx++] = 0;	
          dataOut[idx++] = 0xFF;
        }
        dataOut[idx++] = 0;	
	dataOut[idx++] = zeroSeqLength;
        zeroSeqLength = 0;
      }
	
	dataOut[idx++] = dataIn[i];

    }// else
	
  }
// doppio zero, indica zeri fino alla fine del file
   dataOut[idx++]=0;
   dataOut[idx++]=0;

  return idx;//*/
}

static inline uint32_t codeDC(uint8_t *dataIn, uint8_t *dataOut, uint16_t dataSize)
{
  uint16_t i;

  dataOut[0]=dataIn[0];

  for (i=1; i<dataSize; i++)
   {
	
	dataOut[i]=dataIn[i-1]-dataIn[i];

     }
	
  return dataSize;
}
