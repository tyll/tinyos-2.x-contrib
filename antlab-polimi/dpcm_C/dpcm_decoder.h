#include <stdio.h>
#include "diff_idctfstBlk.h"
#include "diff_dctfstBlk.h"
#include "decodeZeros.h"
#include "huffmanUncompress.h"
#include "jpeghdr.h"
#include "quanttables.h"

int getBytes(char* filename, uint8_t *dataIn)
{
  FILE *fdIn;

  if (!(fdIn = fopen(filename, "r")) ){
    printf("Can't open %s for reading\n", filename);
    return -1;
  }

  int8_t line[1024];
  int count, dataSize=0;

  while( (count=fread(line, 1, 1024, fdIn))>0)
  {

    memcpy(&(dataIn[dataSize]),line,count);
		dataSize+=count;
  }

  fclose(fdIn);
  return dataSize;
}

int read_dimensions_from_compressed_file(code_header_t* header, char* filename) {
	unsigned char dataBuffer[1024];

	FILE *fdIn;

	if (!(fdIn = fopen(filename, "r")) ){
		printf("Can't open %s for reading its header\n", filename);
		return -11;
	}

	uint8_t line[1024];
	int count;
	count=fread(line, 1, 1024, fdIn);
	memcpy(dataBuffer,line,count);
	fclose(fdIn);
	

	memcpy(header,dataBuffer,CODE_HEADER_SIZE);	
	return count;
}



int dpcm_decode(char * filename,uint8_t frame_num, char* output_name){

FILE* fdB;
FILE* fdImg;
char* file_buffer="buffer_receiver";
char* save_path="src/pictures/";
code_header_t header[CODE_HEADER_SIZE];
char out_img[1024];
int i,j;


//creating name of the output image
out_img[0]='\0';
strcat(out_img,save_path);
for(i=0; i<=strlen(filename); i++) {
	out_img[strlen(save_path)+i]=output_name[i];
}
sprintf(&out_img[i++],"%d",frame_num);
out_img[i]='\0';

strcat(out_img,"_rec.pgm");

// color settings
int bufShift=1;  // B&W

// read the received image
read_dimensions_from_compressed_file(header, filename);

// build structures

printf("Width: %d; Height: %d\n",header->width,header->height);
uint8_t buffer[header->width*header->height];
uint8_t received_img[header->width*header->height];
int8_t recovered_diff[header->width*header->height];
uint8_t recovered_img[header->width*header->height]; 


// read the buffer
 if (  frame_num>0 &&  (fdB = fopen(file_buffer, "r"))!=NULL )
  {
	 uint8_t line[1024];
	 int count, dataSize=0;

	 while( (count=fread(line, 1, 1024, fdB))>0) {
		memcpy(&(buffer[dataSize]),line,count);
		dataSize+=count;
	 } 

	 fclose(fdB);	
	
  }
  else if( frame_num > 0 ) {

	printf("Error reading buffer\n");
	return -1;
  }

// read image received
getBytes(filename,received_img);

// decode received image	

    printf("DECODE hdr (%dx%d, qual=%d, col=%d, sizeRLE=%d, sizeHUF=%d, totSize=%d)\n",
  			 header->width,header->height,header->quality,
  			 header->is_color,header->sizeRLE,header->sizeHUF,header->totalSize);


  unsigned char *dataIn=&received_img[CODE_HEADER_SIZE];
  unsigned char dataTmp[header->sizeRLE];
  uint32_t max_size = header->width*header->height;
  uint32_t dc_size = max_size/64;
  int8_t dct_decoded[header->width*header->height];

  Huffman_Uncompress(dataIn, dataTmp, header->sizeHUF, header->sizeRLE);

  decodeDC(dataTmp,(uint8_t *) dct_decoded, dc_size);

  decodeZeros(&dataTmp[dc_size],(uint8_t *) &dct_decoded[dc_size], header->sizeRLE, max_size-dc_size);
	


//find num of blocks
uint16_t width=header->width;
uint16_t height=header->height;
uint8_t w_blocks=width>>3;
uint8_t h_blocks=height>>3;
uint16_t total_blocks= w_blocks*h_blocks;

for (i=0; i<w_blocks; i++)
    for (j=0; j<h_blocks; j++)
	{
			
			diff_idctNew(i,j,total_blocks,
							dct_decoded,recovered_diff,bufShift,
							QUANT_TABLE,header->quality,width);
	}

//sum the buffer
if(frame_num==0){
	for(i=0;i<width*height;i++){
		buffer[i]=recovered_diff[i]+128;	
		recovered_img[i]=buffer[i];
	
	}
}
else{
	for(i=0;i<width*height;i++){

		if(buffer[i]+recovered_diff[i]*2<0){
			buffer[i]=0;	
		}
		else if(buffer[i]+recovered_diff[i]*2>255) {
			buffer[i]=255;
		}
		else buffer[i]=buffer[i]+recovered_diff[i]*2;
		recovered_img[i]=buffer[i];
	
	}
}

//printf("Pre image\n");
FILE *fdBD;
if ((fdBD = fopen("buffer_debug", "w"))) 
  {

  for(i=0;i<width*height;i++) 
	  fprintf(fdBD,"%d\n",buffer[i]);
  fclose(fdBD);

}
else {

  printf("Error writing buffer.\n");
  return -1;

}


// write new buffer
if ((fdB = fopen(file_buffer, "w"))) {

	fwrite(buffer,1,width*height,fdB);
 	fclose(fdB);
}
else {
  printf("Error updating buffer.\n");
  return -1;
}

// write reconstructed image on file
printf("Writing file %s\n",out_img);
if ((fdImg = fopen(out_img, "w")))
  {
//	fprintf(fdImg, "P5\n\n%d %d\n255\n", width, height);
  	fwrite(recovered_img,1,width*height,fdImg);	
	fclose(fdImg);
	printf("Image correctly reconstructed.\n");
  }
 else {
 	printf ("Error opening out_img");
 }

 return 0;

}
