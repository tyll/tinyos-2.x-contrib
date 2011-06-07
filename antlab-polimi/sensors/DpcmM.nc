/*
 * Author: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */
#include <stdio.h>
#include "sdram.h"
#include "diff_idctfstBlk.h"
#include "diff_dctfstBlk.h"
#include "codeZeros.h"
#include "huffmanCompress.h"
#include "jpeghdr.h"

module DpcmM
{
	uses interface Leds;
	provides interface Dpcm;

}
implementation
{
  int8_t *dct_out=(int8_t*)BUF1_FRAME_ADDRESS;//76800b
  uint8_t *tmpOut=(uint8_t*)BUF2_FRAME_ADDRESS;//76800b
  char* file_buffer="buffer_sender";
//  uint8_t buffer[76800];
  FILE* fdB=NULL;
  FILE* fdImg=NULL;

  command void Dpcm.init()
  {
	// test
	call Leds.led1Toggle();     
	}
 	
 command uint16_t Dpcm.dpcm_encode(uint8_t* input,uint8_t* dataOut,uint16_t input_width,uint16_t input_height,uint8_t qual,uint8_t frame_num,uint32_t bandwidthLimit,uint8_t* dpcm_buffer)
  {
      
//320x240
//uint16_t width=input_width;
//uint16_t height=input_height;  
      
//160x120      
uint16_t width=input_width/2;
uint16_t height=input_height/2;

//80x60
//uint16_t width=input_width/4;
//uint16_t height=input_height/4;

int16_t temp=0;
int8_t diff[(width*height)];
int8_t recovered[(width*height)];
int i,j;
uint32_t idx=0, dataSize=width*height;
uint16_t dcSize = dataSize/64;
uint8_t w_blocks=width>>3;
uint8_t h_blocks=height>>3;
uint16_t total_blocks= w_blocks*h_blocks;
code_header_t *header = (code_header_t *)dataOut;
uint8_t *dct_code_data = &dataOut[CODE_HEADER_SIZE];
// color settings
uint8_t bufFix=1;  // 1bpp

    if (bandwidthLimit<(CODE_HEADER_SIZE+dataSize/64)){
   
	return 0;
      }

//compute the difference 320x240
/*
if(frame_num==0){
	i=1;
	j=0;
	while(i<input_width*input_height*2){
		diff[j]=input[i]-128;
		i=i+2;
		j++;
	}

}
else {
	
	i=1;
	j=0;
	while(i<input_width*input_height*2){
		diff[j]=(input[i]-dpcm_buffer[j])/2;
		i=i+2;
		j++;
	}
 
}
*/

//compute scaled difference (subsampled) 160x120

if(frame_num==0){
	i=1;
	j=0;
	while(i<input_width*input_height*2){
		temp=0;
		temp=input[i]+input[i+2]+input[i+640]+input[i+642];
		diff[j]=temp/4-128;
		j++;
		i=i+4;
		if((i-1)%640==0) i=i+640;
	}

}
else {
	i=1;
	j=0;
	while(i<input_width*input_height*2){
		temp=0;
		temp=input[i]+input[i+2]+input[i+640]+input[i+642];
		diff[j]=(temp/4-dpcm_buffer[j])/2;
		j++;
		i=i+4;
		if((i-1)%640==0) i=i+640;
	
	}

 
}

//compute scaled difference (subsampled) 80x60
/*
if(frame_num==0){
    i=1;
    j=0;
    while(i<input_width*input_height*2){
        temp=0;
        temp=input[i]+input[i+2]+input[i+4]+input[i+6]+
            input[i+640]+input[i+642]+input[i+644]+input[i+646]+
            input[i+1280]+input[i+1282]+input[i+1284]+input[i+1286]+
            input[i+1920]+input[i+1922]+input[i+1924]+input[i+1926];
        diff[j]=temp/16-128;
        j++;
        i=i+8;
        if((i-1)%640==0) i=i+1920;
    }

}
else {
    i=1;
    j=0;
    while(i<input_width*input_height*2){
        temp=0;
        temp=input[i]+input[i+2]+input[i+4]+input[i+6]+
            input[i+640]+input[i+642]+input[i+644]+input[i+646]+
            input[i+1280]+input[i+1282]+input[i+1284]+input[i+1286]+
            input[i+1920]+input[i+1922]+input[i+1924]+input[i+1926];
        diff[j]=(temp/16-dpcm_buffer[j])/2;
        j++;
        i=i+8;
        if((i-1)%640==0) i=i+1920;
    
    }

 
}
*/

// compress the difference	


for (i=0; i<w_blocks; i++)
    for (j=0; j<h_blocks; j++)
	{
			diff_dctQuantBlock(i, j, total_blocks,
										diff, bufFix, dct_out, 
										QUANT_TABLE,qual, width);
			diff_idctNew(i,j,total_blocks,
							dct_out,recovered,1,
							QUANT_TABLE,qual,width);

	}


//build header

	header->width=((width&0xFF00)>>8)|((width&0xFF)<<8);
  	header->height=((height&0xFF00)>>8)|((height&0xFF)<<8);
  	header->quality=qual;
  	header->is_color = 0;


// entropy compression

idx=codeDC(dct_out, tmpOut, dcSize);
idx+=codeZeros(&dct_out[dcSize], &tmpOut[dcSize], dataSize-dcSize, bandwidthLimit-dcSize);

header->sizeRLE = ((idx&0xFF00)>>8)|((idx&0xFF)<<8);

idx=Huffman_Compress(tmpOut,dct_code_data,idx);

header->sizeHUF = ((idx&0xFF00)>>8)|((idx&0xFF)<<8);
header->totalSize = ((idx&0xFF00)>>8)|((idx&0xFF)<<8);


//update buffer
if(frame_num==0){
	for(i=0;i<width*height;i++){  
		dpcm_buffer[i]=recovered[i]+128;
	}
}//frame=0
else {
	for(i=0;i<width*height;i++){

	if(dpcm_buffer[i]+recovered[i]*2<0){
			dpcm_buffer[i]=0;	
	}
	else if(dpcm_buffer[i]+recovered[i]*2>255) {
			dpcm_buffer[i]=255;
	}
	else dpcm_buffer[i]=dpcm_buffer[i]+recovered[i]*2;

	}	
}//frame>0

	return idx+CODE_HEADER_SIZE;

	}



}

