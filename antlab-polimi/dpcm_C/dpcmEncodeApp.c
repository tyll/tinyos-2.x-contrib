
/**
 * @author Stefano Paniga (stefano.paniga@gmail.com)
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
#include "quanttables.h"
#include "dpcm_encoder.h"
#include "dpcm_decoder.h"

#define  QUALITY 9
#define BANDWIDTH 225000
#define MAX_INPUT_SIZE 2 << 20

int main(int argc, char **argv)
{
  
  char filename[1024];
  uint8_t frame = 0;
  int bufShift = 0;
  FILE *fd;
  uint width, height, depth,i;
  unsigned char magic_number[2];
  unsigned char input_save[MAX_INPUT_SIZE];
  uint is_color=1;
  uint name_size=0;
  uint current_number;
  char short_name[1024];
  char *tmp_name = NULL;

  if (argc > 2) {
	sprintf(filename,argv[1]);
	frame = (uint8_t) atoi(argv[2]);
  }
  else {
    printf("USAGE: dpcmEncodeApp.exe (.pgm|.ppm) input_file (uint8_t) frame_number\n");
    printf("Max input: %d\n",MAX_INPUT_SIZE);
    return -1;
  }

  char* ext=filename, *tmp;
  while ( (tmp=strstr(ext,".")) != NULL )
  {
    ext=&tmp[1];
  }
  printf("input file:%s ext:%s\n",filename,ext);

  if (strcmp(ext,"pgm")==0)
  {
    is_color=0;
    bufShift=1;
  }
  else
  {
    is_color=1;
    bufShift=3;
  }

  if (!(fd = fopen(filename, "r")) ){
    printf("Can't open data: %s\n", filename);
    return -1;
  }

 // reads magic number  

 fgets((char *)magic_number,3,fd);

 if (strcmp((const char *)magic_number, "P5") == 0 || strcmp((const char *)magic_number, "P6") == 0) {
	printf("File already in binary format (Magic number = %s)\n", magic_number);
	return -1;
  }
  if (strcmp((const char *)magic_number, "P2") != 0 && strcmp((const char *)magic_number, "P3") != 0) {
	printf("Format not valid:  magic_number = %s\n", magic_number);
	return -1;
  }

 // reads height width and depth
  fscanf(fd,"%d",&width);
  fscanf(fd,"%d",&height);
  fscanf(fd,"%d",&depth);
  
  unsigned char input[width*height*bufShift]; 

 // read values
  i=0;
  while( fscanf(fd,"%d",&current_number)!=EOF)
  {
	input[i]=(char)current_number;
	i++;
  }
 fclose(fd);
 
 memcpy(input_save, input, sizeof(input));

 // extract file name without path
 tmp_name = strrchr(filename,'/'); //skip the / char
 if (tmp_name == NULL) 
	 tmp_name = filename;
 else 
	 tmp_name = tmp_name +1;

 strcat(tmp_name,"\0");
 name_size = strlen(tmp_name)-4;
 strncpy(short_name,tmp_name,name_size);

 printf("Name found: %s, name size: %d\n",short_name, name_size);

 dpcm_encode(input,width,height,QUALITY,short_name,frame,BANDWIDTH);

 return 0;    

}


