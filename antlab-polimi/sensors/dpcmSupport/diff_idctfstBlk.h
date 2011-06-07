#ifndef _DIFF_IDCTFSTBLK_H
#define _DIFF_IDCTFSTBLK_H

#include <stdio.h>
#include <inttypes.h>
#define CONST_BITS  8
#define PASS1_BITS  2
#define MAXJSAMPLE	255
#define CENTERJSAMPLE	128
#define DCTSIZE 8

#define FIX_1_082392200  ((int32_t)  277)		/* FIX(1.082392200) */
#define FIX_1_414213562  ((int32_t)  362)		/* FIX(1.414213562) */
#define FIX_1_847759065  ((int32_t)  473)		/* FIX(1.847759065) */
#define FIX_2_613125930  ((int32_t)  669)		/* FIX(2.613125930) */

#define RIGHT_SHIFT(x,shft)	((x) >> (shft))
#define DESCALE(x,n)  RIGHT_SHIFT(x, n)
#define MULTIPLY(var,const)  ((int32_t) DESCALE((var) * (const), CONST_BITS))
#define IDESCALE(x,n)  ((int32_t) RIGHT_SHIFT((x) + (1 << ((n)-1)), n))


static inline int16_t diff_dequantize(int8_t _val, uint8_t qval, uint8_t quality, uint8_t isDC)
{
  int16_t quant = qval*quality;
//  int32_t val=(isDC)?(uint8_t)_val:_val;
  int32_t val=_val;
//  val<<=QUALITY_SHIFT_NEW;
/*  if (val>0)
    val+=quant>>1;
  else
    val-=quant>>1;*/
  if (quant!=0)
    val*=quant;
  return val;
}

void diff_idctNew(uint8_t blkIdx_i, uint8_t blkIdx_j, uint16_t numBlks,
						int8_t* dct_data, int8_t* out, uint8_t bytesPerPixel,
						uint8_t *qtable, uint8_t quality, uint16_t pixelsPerRow)
{

  uint16_t blksPerRow = pixelsPerRow>>3;
  int8_t *inptr 	= &dct_data[blksPerRow*blkIdx_j+blkIdx_i];
  int8_t *outptr = &out[(pixelsPerRow*(blkIdx_j<<3)+(blkIdx_i<<3))*bytesPerPixel];
    int k;
int16_t val;
  int32_t tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;
  int32_t tmp10, tmp11, tmp12, tmp13;
  int32_t z5, z10, z11, z12, z13;
  uint8_t *quantptr;
  int32_t *wsptr;
  uint8_t ctr;
  int32_t workspace[64];	/* buffers data between passes */
    int32_t tmpout[8];
  /* Pass 1: process columns from input, store into work array. */

  quantptr = qtable;
  wsptr = workspace;
  for (ctr = DCTSIZE; ctr > 0; ctr--) {

    tmp0 = diff_dequantize(inptr[numBlks*0], quantptr[DCTSIZE*0], quality,
                      (ctr==DCTSIZE)?1:0);
    tmp1 = diff_dequantize(inptr[numBlks*2], quantptr[DCTSIZE*2], quality,0);
    tmp2 = diff_dequantize(inptr[numBlks*4], quantptr[DCTSIZE*4], quality,0);
    tmp3 = diff_dequantize(inptr[numBlks*6], quantptr[DCTSIZE*6], quality,0);

    tmp10 = tmp0 + tmp2;	/* phase 3 */
    tmp11 = tmp0 - tmp2;

    tmp13 = tmp1 + tmp3;	/* phases 5-3 */
    tmp12 = MULTIPLY(tmp1 - tmp3, FIX_1_414213562) - tmp13; /* 2*c4 */

    tmp0 = tmp10 + tmp13;	/* phase 2 */
    tmp3 = tmp10 - tmp13;
    tmp1 = tmp11 + tmp12;
    tmp2 = tmp11 - tmp12;
    
    /* Odd part */

    tmp4 = diff_dequantize(inptr[numBlks*1], quantptr[DCTSIZE*1], quality,0);
    tmp5 = diff_dequantize(inptr[numBlks*3], quantptr[DCTSIZE*3], quality,0);
    tmp6 = diff_dequantize(inptr[numBlks*5], quantptr[DCTSIZE*5], quality,0);
    tmp7 = diff_dequantize(inptr[numBlks*7], quantptr[DCTSIZE*7], quality,0);

    z13 = tmp6 + tmp5;		/* phase 6 */
    z10 = tmp6 - tmp5;
    z11 = tmp4 + tmp7;
    z12 = tmp4 - tmp7;

    tmp7 = z11 + z13;		/* phase 5 */
    tmp11 = MULTIPLY(z11 - z13, FIX_1_414213562); /* 2*c4 */

    z5 = MULTIPLY(z10 + z12, FIX_1_847759065); /* 2*c2 */
    tmp10 = MULTIPLY(z12, FIX_1_082392200) - z5; /* 2*(c2-c6) */
    tmp12 = MULTIPLY(z10, - FIX_2_613125930) + z5; /* -2*(c2+c6) */

    tmp6 = tmp12 - tmp7;	/* phase 2 */
    tmp5 = tmp11 - tmp6;
    tmp4 = tmp10 + tmp5;

    wsptr[DCTSIZE*0] = (int) (tmp0 + tmp7);
    wsptr[DCTSIZE*7] = (int) (tmp0 - tmp7);
    wsptr[DCTSIZE*1] = (int) (tmp1 + tmp6);
    wsptr[DCTSIZE*6] = (int) (tmp1 - tmp6);
    wsptr[DCTSIZE*2] = (int) (tmp2 + tmp5);
    wsptr[DCTSIZE*5] = (int) (tmp2 - tmp5);
    wsptr[DCTSIZE*4] = (int) (tmp3 + tmp4);
    wsptr[DCTSIZE*3] = (int) (tmp3 - tmp4);

    /* advance pointers to next column */
		//inptr++;			
    inptr+=numBlks<<3;
    quantptr++;
    wsptr++;
  }
  
  /* Pass 2: process rows from work array, store into output array. */
  /* Note that we must descale the results by a factor of 8 == 2**3, */
  /* and also undo the PASS1_BITS scaling. */

  wsptr = workspace;
  for (ctr = 0; ctr < DCTSIZE; ctr++) {
    /* Even part */

    tmp10 = ((int32_t) wsptr[0] + (int32_t) wsptr[4]);
    tmp11 = ((int32_t) wsptr[0] - (int32_t) wsptr[4]);

    tmp13 = ((int32_t) wsptr[2] + (int32_t) wsptr[6]);
    tmp12 = MULTIPLY((int32_t) wsptr[2] - (int32_t) wsptr[6], FIX_1_414213562)
	    - tmp13;

    tmp0 = tmp10 + tmp13;
    tmp3 = tmp10 - tmp13;
    tmp1 = tmp11 + tmp12;
    tmp2 = tmp11 - tmp12;

    /* Odd part */

    z13 = (int32_t) wsptr[5] + (int32_t) wsptr[3];
    z10 = (int32_t) wsptr[5] - (int32_t) wsptr[3];
    z11 = (int32_t) wsptr[1] + (int32_t) wsptr[7];
    z12 = (int32_t) wsptr[1] - (int32_t) wsptr[7];

    tmp7 = z11 + z13;		/* phase 5 */
    tmp11 = MULTIPLY(z11 - z13, FIX_1_414213562); /* 2*c4 */

    z5 = MULTIPLY(z10 + z12, FIX_1_847759065); /* 2*c2 */
    tmp10 = MULTIPLY(z12, FIX_1_082392200) - z5; /* 2*(c2-c6) */
    tmp12 = MULTIPLY(z10, - FIX_2_613125930) + z5; /* -2*(c2+c6) */

    tmp6 = tmp12 - tmp7;	/* phase 2 */
    tmp5 = tmp11 - tmp6;
    tmp4 = tmp10 + tmp5;

    /* Final output stage: scale down by a factor of 8 and range-limit */



    tmpout[0] = IDESCALE(tmp0 + tmp7, PASS1_BITS+4);
    tmpout[7] = IDESCALE(tmp0 - tmp7, PASS1_BITS+4);
    tmpout[1] = IDESCALE(tmp1 + tmp6, PASS1_BITS+4);
    tmpout[6] = IDESCALE(tmp1 - tmp6, PASS1_BITS+4);
    tmpout[2] = IDESCALE(tmp2 + tmp5, PASS1_BITS+4);
    tmpout[5] = IDESCALE(tmp2 - tmp5, PASS1_BITS+4);
    tmpout[4] = IDESCALE(tmp3 + tmp4, PASS1_BITS+4);
    tmpout[3] = IDESCALE(tmp3 - tmp4, PASS1_BITS+4);


    for (k=0; k<8; k++)
    {
      val = tmpout[k];
      val = (val>127)?127:val;
      val = (val<(-128))?(-128):val;
      //outptr[k]=val;
      outptr[k*bytesPerPixel]=val;
    }

    wsptr += DCTSIZE;		/* advance pointer to next row */
    //outptr += pixelsPerRow;
    outptr += pixelsPerRow*bytesPerPixel;
  }
}

#endif

