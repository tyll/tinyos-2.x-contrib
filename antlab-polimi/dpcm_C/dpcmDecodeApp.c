
/**
 * @author Stefano Paniga stefano.paniga@gmail.com
 */ 
 
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tinyos_macros.h"
#include "dpcm_decoder.h"


int main(int argc, char **argv)
{
  char filename[1024];
  uint frame_num=0;

  if (argc > 2) {

    sprintf(filename,argv[1]);
    frame_num = (uint8_t) atoi(argv[2]);

  } else {

	printf("USAGE: ./dpcmDecodeApp input_file (uint8_t) frame_num\n");
	return -1;
  }

  char* tmp_name = NULL;
  char* tmp_name2 =NULL;
  int name_size=0;
  char output_name[1024];
  // extract file name without path
  
  tmp_name = strrchr(filename,'/'); 
  //skip the / char
  if(tmp_name == NULL)
  	tmp_name = filename;
  else tmp_name = tmp_name +1;

  printf("TMP: %s\n",tmp_name);
  tmp_name2 = strrchr(tmp_name,'.');
//  strcat(tmp_name,"\0");
  name_size = tmp_name2-tmp_name;
  strncpy(output_name,tmp_name,name_size);
  printf("File name: %s\n",output_name);

  //printf("Decode.\n");
  dpcm_decode(filename,frame_num,output_name);
  
  
	return 0;
}


