/*
 * Author: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */
interface Dpcm{
	command void init();
#ifdef PSNR_ENV
	command uint16_t dpcm_encode(uint8_t* input,uint8_t* output,uint16_t width,uint16_t height,uint8_t qual,uint8_t frame,uint32_t bandwidthLimit,uint8_t* dpcm_buffer,uint32_t* mse);
#else
	command uint16_t dpcm_encode(uint8_t* input,uint8_t* output,uint16_t width,uint16_t height,uint8_t qual,uint8_t
 frame,uint32_t bandwidthLimit,uint8_t* dpcm_buffer);
#endif

	
	
	
}
