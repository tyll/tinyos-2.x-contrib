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
 
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include "tinyos_macros.h"
#include "jpeghdr.h"
#include "jpegTOS.h"
#include "jpegUncompress.h"
#include "quanttables.h"

int getBytes(char* filename, uint8_t *dataIn)
{
  FILE *fdIn;
  if (!(fdIn = fopen(filename, "r")) ){
    printf("Can't open %s for reading\n", filename);
    return 0;
  }

  uint8_t line[1024];
  int count, dataSize=0;

	dataSize=0;
  while( (count=fread(line, 1, 1024, fdIn))>0)
  {
    memcpy(&(dataIn[dataSize]),line,count);
		dataSize+=count;
  }
  fclose(fdIn);
  return dataSize;
}

int main(int argc, char **argv)
{
  char filename[1024];
  if (argc == 2)
    sprintf(filename,argv[1]);
  else
    sprintf(filename,"coded.huf");
    
  uint8_t recovered[320*240*3];
  memset(recovered,0,sizeof(recovered));
	code_header_t header;

  //decodeJpegFile("coded.huf", recovered, &header);
      
  uint8_t in[320*240*3];
  uint32_t size=getBytes(filename,in);
  decodeJpegBytes(in, size, recovered, &header);
  printf("decoded header: W=%d H=%d qual=%d COL=%d size2=%d\n",
            header.width, header.height, header.quality, header.is_color, header.totalSize);
  
	if (header.is_color)
	{
	  FILE *fdOut = fopen("testOut.ppm", "w");
		fprintf(fdOut,"%s","P6\n\n320 240\n255\n");
	  fwrite(recovered,1,header.width*header.height*3,fdOut);
	  fclose(fdOut);printf("written .ppm file");
	}
	else
	{
	  FILE *fdOut = fopen("testOut.pgm", "w");
		fprintf(fdOut,"%s","P5\n\n320 240\n255\n");
	  fwrite(recovered,1,header.width*header.height,fdOut);
	  fclose(fdOut); printf("written .pgm file");
	}
	return 1;
}

