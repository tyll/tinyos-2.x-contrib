uint32_t decodeZeros(uint8_t *dataIn, unsigned char *dataOut,
	 		    uint32_t size, uint32_t maxSize)
{
  uint32_t i,r,j, idx=0;

  r=0;
  for (i=0; i<size; i++)
  {

    if (dataIn[r] == 0 && (r+1)<size)
    {
	// doppio zero: zeri fino a fine file
	if(dataIn[(r+1)]==0){
	    while (idx<maxSize)
	          dataOut[idx++]=0;
    		return idx;
	}
  
      for (j=0; j<dataIn[(r+1)]; j++)
        dataOut[idx++]=0;
	r=r+2;
    }
    else if(dataIn[r]!=0 && (r+1)<=size)
  	{
	     int8_t value=dataIn[r];
	     dataOut[idx++]=value;
	     r=r+1;
	}
     else{
		 printf("\nZero length decoding error..\n");
		return 0;
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

