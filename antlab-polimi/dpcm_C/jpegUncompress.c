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
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include "tinyos_macros.h"
#include "jpeghdr.h"
#include "ycc2rgb.h"
#include "idctfstBlk.h"
#include "quanttables_odrb.h"
#include "huffmanUncompress.h"
#include "decodeZeros.h"

//#define RLE_ONLY


void decode(code_header_t *header, unsigned char *dataIn, int8_t* decoded)
{
  unsigned char dataTmp[header->sizeRLE];
  uint32_t max_size = header->width*header->height;
  uint32_t dc_size = max_size/64;

#ifdef RLE_ONLY
  decodeDC(dataIn, decoded, dc_size);
  decodeZeros(&dataIn[dc_size], &decoded[dc_size], header->sizeRLE, max_size-dc_size);
#else
FILE* fd;
uint32_t r=0;
uint32_t idx=header->sizeHUF;

  Huffman_Uncompress(dataIn, dataTmp, header->sizeHUF, header->sizeRLE);
  decodeDC(dataTmp, decoded, dc_size);
  idx=decodeZeros(&dataTmp[dc_size], &decoded[dc_size], header->sizeRLE, max_size-dc_size);

#endif
	return;
}

void decodeBytes(unsigned char *dataBuffer, int8_t* decoded, code_header_t *header)
//void decodeBytes(unsigned char *dataBuffer, int16_t* decoded, code_header_t *header)
{
  memcpy(header,dataBuffer,CODE_HEADER_SIZE);
    printf("DECODE hdr (%dx%d, qual=%d, col=%d, sizeRLE=%d, sizeHUF=%d, totSize=%d)\n",
  			 header->width,header->height,header->quality,
  			 header->is_color,header->sizeRLE,header->sizeHUF,header->totalSize);

  unsigned char *dataIn=&dataBuffer[CODE_HEADER_SIZE];
  decode(header, dataIn, decoded);
}

int32_t minim(int32_t x, int32_t y)
{
	if (x<y)
		return x;
	return y;
}

void decodeFile(char *filename, int8_t* decoded, code_header_t *header, uint8_t idx)
//void decodeFile(char *filename, int16_t* decoded, code_header_t *header, uint8_t idx)
{
  FILE *fdIn;
  if (!(fdIn = fopen(filename, "r")) ){
    printf("decodeFile: Can't open %s file for reading\n", filename);
    return;
  }

  unsigned char line[1024];
  int i=0,count, dataSize=0;
  unsigned char *dataIn=0;

	for (i=0; i<idx; i++)
	{
	  count=fread(line,1,CODE_HEADER_SIZE,fdIn);
	  if (count<CODE_HEADER_SIZE)
	  {
	    printf("decodeFile: file read error!\n");
			fclose(fdIn);
			return;
	  }
	  
	  memcpy(header,line,CODE_HEADER_SIZE);
	  
	  if (dataIn!=0)
	  	free(dataIn);
	  dataIn = malloc(header->sizeHUF);	
	  
		dataSize=0;
	  while( (count=fread(line, 1, minim(1024,header->sizeHUF-dataSize), fdIn))>0)
	  {
	    memcpy(&(dataIn[dataSize]),line,count);
			dataSize+=count;
	  }
	}
  fclose(fdIn);
  printf("DECODE header (%dx%d, qual=%d, col=%d, sizeRLE=%d, sizeHUF=%d)\n",
  			 header->width,header->height,header->quality, 
  			 header->is_color,header->sizeRLE,header->sizeHUF);

  decode(header, dataIn, decoded);

}

void idct(code_header_t *header, int8_t* dct_decoded, uint8_t *recovered, uint8_t bufShift, uint8_t *qtable)
{
	int32_t i,j;
  for (i=0; i<header->width>>3; i++)
    for (j=0; j<header->height>>3; j++)
				idctNew(i,j,header->width*header->height>>6,
							dct_decoded,recovered,bufShift,
							qtable,header->quality,header->width);
}

void decodeJpegFile(char *filename, uint8_t *recovered, code_header_t *header,uint16_t width, uint16_t height)
//void decodeJpegFile(char *filename, uint16_t *recovered, code_header_t *header,uint16_t width, uint16_t height)
{
  int32_t ycc_rgb_table[YCC_RGB_TABLE_SIZE]; ycc_rgb_init(ycc_rgb_table);
  int8_t dct_decoded[width*height];
//  int16_t dct_decoded[width*height];

  decodeFile(filename,dct_decoded,header,1);
	if (header->is_color)
	{
	  idct(header, dct_decoded, recovered, 3, QUANT_TABLE);
	  decodeFile(filename,dct_decoded,header,2);
	  idct(header, dct_decoded, &recovered[1], 3, QUANT_TABLE);
	  decodeFile(filename,dct_decoded,header,3);
	  idct(header, dct_decoded, &recovered[2], 3, QUANT_TABLE);
  	ycc_rgb_convert(recovered,recovered,ycc_rgb_table,header->width*3,header->height);
	}
	else
	  idct(header, dct_decoded, recovered, 1, QUANT_TABLE);

  FILE *fd_tmp=0;

  if (!(fd_tmp = fopen("decoded.huf", "w")) ){
    printf("decodeJpegFile: Can't open decoded.huf file for writing\n");
    return;
  }
  fwrite(dct_decoded,1,width*height,fd_tmp);
  fclose(fd_tmp);printf("written decoded.huf file\n");
}

void decodeJpegBytes(uint8_t *dataIn, uint32_t dataSize, uint8_t *recovered, code_header_t *header,uint16_t width,uint16_t height)
{
  int32_t ycc_rgb_table[YCC_RGB_TABLE_SIZE];
  ycc_rgb_init(ycc_rgb_table);

   int8_t dct_decoded[width*height];
//    int16_t dct_decoded[width*height]; 

  //get header
  decodeBytes(dataIn, dct_decoded, header);
  

  if (header->is_color)
  {
    //uint16_t dataSize=header->totalSize;
    idcti(header, dct_decoded, recovered, 3, QUANT_TABLE);

    uint32_t idx=header->sizeHUF+CODE_HEADER_SIZE;
    if (dataSize>idx+1200)
    {
      decodeBytes(&dataIn[idx],dct_decoded,header);
      idct(header, dct_decoded, &recovered[1], 3, QUANT_TABLE);

      idx+=header->sizeHUF+CODE_HEADER_SIZE;
      if (dataSize>idx+1200)
      {
        decodeBytes(&dataIn[idx],dct_decoded,header);
        idct(header, dct_decoded, &recovered[2], 3, QUANT_TABLE);
      }
      ycc_rgb_convert(recovered,recovered,ycc_rgb_table,header->width*3,header->height);
    }
    else //for output as bw img
    {
      int i, ibound=header->height*header->width;
      for (i=1; i<ibound; ++i)
        recovered[i]=recovered[i*3];
      header->is_color=0;
    }
    header->totalSize=dataSize;
  }
  else
    idct(header, dct_decoded, recovered, 1, QUANT_TABLE);
}

