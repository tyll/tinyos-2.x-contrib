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
#include "tinyos_macros.h"
#include "jpeghdr.h"
#include "dctfstBlk.h"
//#include "rleCompress.h"
#include "codeZeros.h"
#include "huffmanCompress.h"
#include "rgb2ycc.h"
#include "quanttables.h"

//#define RLE_ONLY

//int8_t dct_output[320*240];
//uint8_t tmpOut[320*240];
int8_t *dct_output;
uint8_t *tmpOut;

int32_t rgb_ycc_table[RGB_YCC_TABLE_SIZE]; 

void set_resolution(int width, int height) {
	dct_output = malloc(sizeof(int8_t) * width * height);
	tmpOut = malloc(sizeof(uint16_t) * width * height);
}

void free_memory() {
	free(dct_output);
	free(tmpOut);
}

void init()
{
	rgb_ycc_init(rgb_ycc_table);
}

void writeOrigFile(int8_t *dct_output, uint32_t dataSize)

{
	FILE *fd_tmp1=0;
  if ((fd_tmp1 = fopen("orig.huf", "w")) ){
    fwrite(dct_output,1,dataSize,fd_tmp1);
    fclose(fd_tmp1);
  }
  else
    printf("Can't open orig.huf file for writing\n");
}

uint32_t encodeJpeg(uint8_t *dataIn, uint8_t *dataOut, uint32_t bandwidthLimit,
										uint16_t width, uint16_t height, uint8_t
 qual, uint8_t bufFix, uint8_t color)

{

	
  uint16_t i,j;
  uint32_t idx=0, dataSize=width*height;
  uint16_t dcSize = dataSize/64;
  code_header_t *header = (code_header_t *)dataOut; //salvo indirizzo inizio file
  uint8_t *dct_code_data = &dataOut[CODE_HEADER_SIZE]; //salvo indirizzo inizio dati, successivo all'header
  uint8_t tmp0=width>>3, tmp1=height>>3; //divido per otto per calcolare il numero di blocchi
  uint16_t tmp2=tmp0*tmp1;

  if (bandwidthLimit<(CODE_HEADER_SIZE+dataSize/64))
    return 0;

  for (i=0; i<tmp0; i++)
    for (j=0; j<tmp1; j++)
			dctQuantBlock(i, j, tmp2, 
										dataIn, bufFix, dct_output, 
										QUANT_TABLE, qual, width);

	writeOrigFile(dct_output, dataSize);
  header->width=width;
  header->height=height;
  header->quality=qual;
  header->is_color = color;


#ifdef RLE_ONLY
  idx=codeDC(dct_output, dct_code_data, dcSize);
  idx+=codeZeros(&dct_output[dcSize], &dct_code_data[dcSize], dataSize-dcSize, bandwidthLimit-dcSize);
	//idx=RLE_Compress(dct_output, dct_code_data, dataSize);
#else
  idx=codeDC(dct_output, tmpOut, dcSize);
  idx+=codeZeros(&dct_output[dcSize], &tmpOut[dcSize], dataSize-dcSize, bandwidthLimit-dcSize);

#endif
	header->sizeRLE = (uint16_t)idx;


#ifndef RLE_ONLY

 idx=Huffman_Compress(tmpOut, dct_code_data,idx);

#endif

	header->sizeHUF = (uint16_t)idx;

	header->totalSize = idx;

	return idx+CODE_HEADER_SIZE;
}

uint32_t encodeColJpeg(uint8_t *dataIn, uint8_t *dataOut, uint32_t bandwidthLimit, 
										uint16_t width, uint16_t height, uint8_t qual, uint8_t bufFix)
{
	init();
	rgb_ycc_convert(dataIn,dataIn,rgb_ycc_table,width*3,height);
	uint32_t idx=encodeJpeg(dataIn, dataOut, bandwidthLimit, width, height, qual, bufFix,1);
	idx+=encodeJpeg(&dataIn[1], &dataOut[idx], bandwidthLimit, width, height, qual, bufFix,1);
	idx+=encodeJpeg(&dataIn[2], &dataOut[idx], bandwidthLimit, width, height, qual, bufFix,1);
	((code_header_t *)dataOut)->totalSize = idx;
	return idx;
}

