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

#include <math.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tinyos_macros.h"
#include "jpeghdr.h"
#include "jpegTOS.h"
#include "jpegUncompress.h"

  int ROW=40*8;//40*8;
  int COL=30*8;//30*8;
  int QUALITY=9;
  int BANDWIDTH=225000;
  int IS_COLOR=1;

int main(int argc, char **argv)
{
  printf("usage: dctApp.exe [.pgm|.ppm file] [max filesize]\n");
  char filename[1024];
  if (argc >= 2)
    sprintf(filename,argv[1]);
  else
    sprintf(filename,"data//test.pgm");

  char* ext=filename, *tmp;
  while ( (tmp=strstr(ext,".")) != NULL )
  {
    ext=&tmp[1];
  }
  printf("input file:%s ext:%s\n",filename,ext);

  int max_filesize=INT_MAX;
  if (argc == 3)
    max_filesize = atoi(argv[2]);

  int bufShift;
  if (strcmp(ext,"pgm")==0)
  {
    IS_COLOR=0;
    bufShift=1;
  }
  else
  {
    IS_COLOR=1;
    bufShift=3;
  }
  char filenameIn[1024];
  sprintf(filenameIn, "data//testIn.%s",ext);
  char filenameOut[1024];
  sprintf(filenameOut, "data//testOut.%s",ext);
  /*
  char *filename = "data//test.pgm";
  char *filenameIn = "data//testIn.pgm";
  char *filenameOut = "data//testOut.pgm";
  int bufShift=1; IS_COLOR=0;//*/
  /*
  char *filename = "data//_test.ppm";
  char *filenameIn = "data//_testIn.ppm";
  char *filenameOut = "data//_testOut.ppm";
  int bufShift=3; IS_COLOR=1;//*/
  FILE *fd;
  FILE *fdIn;
  FILE *fdOut;
  if (!(fd = fopen(filename, "r")) ){
    printf("Can't open data: %s\n", filename);
    return 1;
  }
  
  if (    !(fdIn = fopen(filenameIn, "w")) 
	   || !(fdOut = fopen(filenameOut, "w")))
  {
    printf("Can't open data for writing\n");
    fclose(fd);
    return 1;
  }

  unsigned char line[320];
  unsigned char input[320*240*bufShift+10];
  uint8_t dct_code[BANDWIDTH];
  
  int i,count;
  
  for (i=0; i<4; i++)
  {
    fgets(line, 320, fd);
  	fprintf(fdIn,"%s",line);
  	fprintf(fdOut,"%s",line);
  }
  i=0;
  while( (count=fread(line, 1, 320, fd))>0)
  {
    memcpy(&(input[i]),line,count);
	  i+=count; 
  }
  unsigned char input_save[320*240*bufShift+10];
  memcpy(input_save, input, sizeof(input));

  uint32_t idx;
  if (IS_COLOR)
    idx = encodeColJpeg(input,dct_code,BANDWIDTH,ROW,COL,QUALITY,bufShift);
	else
    idx = encodeJpeg(input,dct_code,BANDWIDTH,ROW,COL,QUALITY,bufShift,0);

  FILE *fd_tmp1=0;
  if (!(fd_tmp1 = fopen("data//coded.huf", "w")) ){
    printf("Can't open %s file for writing\n",filename);
    return 1;
  }
  
  if (idx > max_filesize)
    idx = max_filesize;
  fwrite(dct_code,1,idx,fd_tmp1);
  fclose(fd_tmp1);
  printf("CODE length: %d b (%d msgs)\n", (int)idx,(int)idx/64+1);
  printf("written coded.huf file\n");

  uint8_t recovered[320*240*bufShift+10];
  memset(recovered,0,sizeof(recovered));
	code_header_t header;
	decodeJpegFile("data//coded.huf", recovered, &header);

  double rmse=0.0;	  
  for (i=0; i<ROW*COL; i++)
	  rmse+= (recovered[i]-input_save[i])*(recovered[i]-input_save[i]);
  rmse = sqrt(rmse/ROW/COL);
  
  printf("PSNR: %f\n",20*log(255/rmse));
  printf("RMSE: %f\n",rmse);
  {
    fwrite(input_save,1,ROW*COL*bufShift,fdIn);
    fwrite(recovered,1,ROW*COL*bufShift,fdOut);
  }

  fclose(fd);
  fclose(fdIn); printf("written %s\n",filenameIn);
  fclose(fdOut); printf("written %s\n",filenameOut);
	return 1;    
}


