/**************** YCbCr -> RGB conversion: most common case **************/

/*
 * YCbCr is defined per CCIR 601-1, except that Cb and Cr are
 * normalized to the range 0..MAXJSAMPLE rather than -0.5 .. 0.5.
 * The conversion equations to be implemented are therefore
 *	R = Y                + 1.40200 * Cr
 *	G = Y - 0.34414 * Cb - 0.71414 * Cr
 *	B = Y + 1.77200 * Cb
 * where Cb and Cr represent the incoming values less CENTERJSAMPLE.
 * (These numbers are derived from TIFF 6.0 section 21, dated 3-June-92.)
 *
 */

#define MAXJSAMPLE	255
#define CENTERJSAMPLE	128
#define SCALEBITS	16	/* speediest right-shift on some machines */
#define ONE_HALF	((int32_t) 1 << (SCALEBITS-1))
#define FIX(x)		((int32_t) ((x) * (1L<<SCALEBITS) + 0.5))
#define RIGHT_SHIFT(x,shft)	((x) >> (shft)) 

#define CR_R_OFF		0			/* offset to R => Y section */
#define CB_B_OFF		(1*(MAXJSAMPLE+1))	/* offset to G => Y section */
#define CR_G_OFF		(2*(MAXJSAMPLE+1))	/* etc. */
#define CB_G_OFF	  (3*(MAXJSAMPLE+1))
#define YCC_RGB_TABLE_SIZE	(4*(MAXJSAMPLE+1))

/*
 * Initialize tables for YCC->RGB colorspace conversion.
 */

void ycc_rgb_init (int32_t *ycc_rgb_tab)
{
	int32_t i,x;
  for (i = 0, x = -CENTERJSAMPLE; i <= MAXJSAMPLE; i++, x++) {
    ycc_rgb_tab[i+CR_R_OFF] = RIGHT_SHIFT(FIX(1.40200) * x + ONE_HALF, SCALEBITS);
    ycc_rgb_tab[i+CB_B_OFF] = RIGHT_SHIFT(FIX(1.77200) * x + ONE_HALF, SCALEBITS);
    ycc_rgb_tab[i+CR_G_OFF] = (- FIX(0.71414)) * x;
    ycc_rgb_tab[i+CB_G_OFF] = (- FIX(0.34414)) * x + ONE_HALF;
  }
}


/*
 * Convert some rows of samples to the output colorspace.
 *
 */

static inline uint8_t range_limit(int32_t val)
{
	if (val>255)
		return 255;
	if (val<0)
		return 0;
	return val;	
}

void ycc_rgb_convert (uint8_t *input_buf, uint8_t *output_buf, int32_t *ctab,
		 uint16_t width, uint16_t height)
{
  int32_t y, cb, cr, i, j;

  for (i=0; i<width; i+=3) 
		for (j=0; j<height; j++)
		{
      y = input_buf[i+j*width+0];
      cb = input_buf[i+j*width+1];
      cr = input_buf[i+j*width+2];
	    output_buf[i+j*width+0] = range_limit(y+ctab[cr+CR_R_OFF]);
	    output_buf[i+j*width+1] = 
					range_limit(y+((int) RIGHT_SHIFT(ctab[cb+CB_G_OFF] + ctab[cr+CR_G_OFF],SCALEBITS)));
	    output_buf[i+j*width+2] = range_limit(y+ctab[cb+CB_B_OFF]);
	  }
}



