#include <stdio.h>
#include <stdlib.h>
#include "diff_idctfstBlk.h"
#include "diff_dctfstBlk.h"
#include "codeZeros.h"
#include "huffmanCompress.h"
#include "jpeghdr.h"


int dpcm_encode 
	(uint8_t* input,uint16_t width,uint16_t height,uint8_t qual,
				char * filename,uint8_t frame_num,uint32_t bandwidthLimit) {

FILE* fdB=NULL;
FILE* fdImg=NULL;
char* file_buffer = "buffer_sender";
uint8_t buffer[400000];
/************************ RESCALED
uint16_t W = width;
uint16_t H = height;
uint16_t width = width/2;
uint16_t height = height/2;
int k,r,temp;
*********************************/
uint8_t diff[width*height];
int8_t dct_output[width*height];
uint8_t tmpOut[width*height];
int8_t recovered[width*height];
uint8_t dataOut[width*height];
char  frame_num_str[10];
int i,j;
code_header_t *header = (code_header_t *)dataOut;
uint8_t *dct_code_data = &dataOut[CODE_HEADER_SIZE];
uint32_t dataSize=width*height;
uint32_t idx=0;
uint16_t dcSize = dataSize/64;
uint count;
uint8_t line[1024];

printf("Start encoding.\n");

//creating name of the coded file

strcat(filename,"_coded_");
sprintf(frame_num_str,"%d",frame_num);
strcat(filename,frame_num_str);
strcat(filename,".dpcm");

 // read the buffer
  if( frame_num > 0 && (fdB = fopen(file_buffer, "r"))!=NULL ){

	while( (count=fread(line, 1, 1024, fdB))>0)
  	{
		memcpy(&(buffer[dataSize]),line,count);
		dataSize+=count;
	}
	
        fclose(fdB);

   }
   else if( frame_num > 0 && (fdB = fopen(file_buffer, "r"))==NULL ){
	printf("Error reading buffer\n");
	return -1;
  }


// find number of blocks
uint8_t w_blocks= width >> 3; 
uint8_t h_blocks= height >> 3;
uint16_t total_blocks= w_blocks*h_blocks;


// bytes per pixel settings
int bufShift=1;  // B&W


/**************************************** RESCALED
//compute the difference
temp=0;
k=0;
r=0;
j=0;
i=0;
if(frame_num==0){

	while(i<H*W){
		temp=0;
		for(k=0;k<2;k++){
			temp=temp+0.25*input[i+k]+0.25*input[i+320+k];
		}
		diff[j]=temp;//-128;
		j++;
		i=i+2;
		if(i%320==0){
			r++;
			i=i+320;
		}
		
	}
}
else if(frame_num>0){

	while(i<W*H){
		temp=0;
		for(k=0;k<4;k++){
			temp=temp+0.25*input[i+k];
		}
		diff[j]=(temp-buffer[j])/2;
		j++;
		i=i+4;
	}
}


if ((fdImg = fopen("print_rescaled.pgm", "w")))
  {
	fprintf(fdImg, "P5\n\n%d %d\n255\n", half_width, half_height);
  	fwrite(diff,1,half_width*half_height,fdImg);	
	fclose(fdImg);
	printf("Rescaled image written.\n");
  }
else {
	pritnf("Error opening (w) fdImg\n");
	return -1;
}

return 0;
*********************************************************************************/
// compute the difference
i=0;
if(frame_num==0){

        while(i<height*width){
                
		diff[i]=input[i]-128;  //bound the diff[i] in a int8_t variable
                i++;
        }
}
else if(frame_num>0){

        while(i<height*width){
                
                diff[i]=(input[i]-buffer[i])/2; // helved to bound the diff[i] in a int8_t var
                i++;
               
        }
}


// compress the difference	

  if (bandwidthLimit<(CODE_HEADER_SIZE+dataSize/64))
    return 0;

for (i=0; i<w_blocks; i++)
    for (j=0; j<h_blocks; j++)
	{
			diff_dctQuantBlock(i, j, total_blocks,
										(int8_t *)diff, bufShift, dct_output, 
										QUANT_TABLE,qual, width);
			diff_idctNew(i,j,total_blocks,
							dct_output,recovered,bufShift,
							QUANT_TABLE,qual,width);

	}

//build header

	header->width=width;
  	header->height=height;
  	header->quality=qual;
  	header->is_color = 0;


// entropy compression

idx=codeDC((uint8_t *)dct_output, tmpOut, dcSize);
idx+=codeZeros(((uint8_t*)&dct_output[dcSize]), &tmpOut[dcSize], dataSize-dcSize, bandwidthLimit-dcSize);

header->sizeRLE = (uint16_t)idx;

idx=Huffman_Compress(tmpOut,dct_code_data,idx);

header->sizeHUF = (uint16_t)idx;
header->totalSize = idx;

//write difference
if (  (fdImg = fopen(filename, "w")) )
  {
	printf("Writing coded difference.\n");
	fwrite(dataOut,1,idx+CODE_HEADER_SIZE,fdImg);
	 fclose(fdImg);
  }
else {
	printf("Error opening (w) fdImg.");
	return -1;
}

	
//update buffer
if(frame_num == 0) {

	for(i=0;i<width*height;i++){
	
		buffer[i]=recovered[i]+128;
	}
}
else {

	for(i=0;i<width*height;i++){

		if(buffer[i]+recovered[i]*2<0){	             
				buffer[i]=0;	
		}
		else if(buffer[i]+recovered[i]*2>255) {
			buffer[i]=255;
		}
		else buffer[i]=buffer[i]+recovered[i]*2;
	}	
}


// write the new buffer
	if ((fdB = fopen(file_buffer, "w"))) {
	fwrite(buffer,1,width*height,fdB);
	fclose(fdB);
	}
	else{
		printf("Error writing buffer.\n");
		return -1;
	}


  printf("Buffer updated.\n");
  return 0;
}
