#include <inttypes.h>
#define CONST_BITS  8
#define PASS1_BITS  2
#define MAXJSAMPLE	255
#define CENTERJSAMPLE	128
#define DCTSIZE 8

#define FIX_0_382683433  ((int32_t)   98)
#define FIX_0_541196100  ((int32_t)  139)
#define FIX_0_707106781  ((int32_t)  181)
#define FIX_1_306562965  ((int32_t)  334)
#define FIX_1_082392200  ((int32_t)  277)
#define FIX_1_414213562  ((int32_t)  362)
#define FIX_1_847759065  ((int32_t)  473)
#define FIX_2_613125930  ((int32_t)  669)
#define RIGHT_SHIFT(x,shft)	((x) >> (shft))
#define DESCALE(x,n)  RIGHT_SHIFT(x, n)
#define MULTIPLY(var,const)  ((int32_t) DESCALE((var) * (const), CONST_BITS))
#define RANGE_MASK  (MAXJSAMPLE * 4 + 3)

static inline int8_t diff_quantize(int32_t _val, uint8_t qval, uint8_t quality, uint8_t isDC)
{
  int16_t quant = qval*quality;
  int32_t val=_val;


  if (val>0)
    val+=quant>>1;
  else
    val-=quant>>1;
  if (quant!=0)
    val/=quant;
  if (!isDC)
  {
    if (val>127) {val=127;}
    else if (val< -128) {val=-128;}
  }
  else if (val>127) {val=127;}

    return (int8_t)val;
}

void diff_dctQuantBlock(uint8_t blkIdx_i, uint8_t blkIdx_j, uint16_t numBlks, 
																 int8_t *img_data, uint8_t bytesPerPixel, int8_t *out, 
																 uint8_t *qtable, uint8_t quality, uint16_t pixelsPerRow)
{
  uint16_t blksPerRow = pixelsPerRow>>3;
  int8_t *dataptr = &img_data[(pixelsPerRow*(blkIdx_j<<3)+(blkIdx_i<<3))*bytesPerPixel];
    int8_t *optr 		 = &out[blksPerRow*blkIdx_j+blkIdx_i];

  int32_t tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;
  int32_t tmp10, tmp11, tmp12, tmp13;
  int32_t z1, z2, z3, z4, z5, z11, z13;
  int32_t ctr;
  int32_t tmp[64*bytesPerPixel];
  int32_t *tmpptr = tmp;

  for (ctr = DCTSIZE-1; ctr >= 0; ctr--) {
    uint8_t idx1=0*bytesPerPixel, idx2=7*bytesPerPixel;//0,7
    tmp0 = (int32_t)dataptr[idx1] + dataptr[idx2];
    tmp7 = (int32_t)dataptr[idx1] - dataptr[idx2];

    idx1+=bytesPerPixel; idx2-=bytesPerPixel;//1.6
    tmp1 = (int32_t)dataptr[idx1] + dataptr[idx2];
    tmp6 = (int32_t)dataptr[idx1] - dataptr[idx2];

    idx1+=bytesPerPixel; idx2-=bytesPerPixel;//2,5
    tmp2 = (int32_t)dataptr[idx1] + dataptr[idx2];
    tmp5 = (int32_t)dataptr[idx1] - dataptr[idx2];
    
    idx1+=bytesPerPixel; idx2-=bytesPerPixel;//3,4
    tmp3 = (int32_t)dataptr[idx1] + dataptr[idx2];
    tmp4 = (int32_t)dataptr[idx1] - dataptr[idx2];
    
    /* Even part */
    
    tmp10 = tmp0 + tmp3;	/* phase 2 */
    tmp13 = tmp0 - tmp3;
    tmp11 = tmp1 + tmp2;
    tmp12 = tmp1 - tmp2;

    tmpptr[0] = tmp10 + tmp11; /* phase 3 */
    tmpptr[4] = tmp10 - tmp11;
	
    z1 = MULTIPLY(tmp12 + tmp13, FIX_0_707106781); /* c4 */
    tmpptr[2] = tmp13 + z1;	/* phase 5 */
    tmpptr[6] = tmp13 - z1;
    
    /* Odd part */

    tmp10 = tmp4 + tmp5;	/* phase 2 */
    tmp11 = tmp5 + tmp6;
    tmp12 = tmp6 + tmp7;

    /* The rotator is modified from fig 4-8 to avoid extra negations. */
    z5 = MULTIPLY(tmp10 - tmp12, FIX_0_382683433); /* c6 */
    z2 = MULTIPLY(tmp10, FIX_0_541196100) + z5; /* c2-c6 */
    z4 = MULTIPLY(tmp12, FIX_1_306562965) + z5; /* c2+c6 */
    z3 = MULTIPLY(tmp11, FIX_0_707106781); /* c4 */

    z11 = tmp7 + z3;		/* phase 5 */
    z13 = tmp7 - z3;

    tmpptr[5] = z13 + z2;	/* phase 6 */
    tmpptr[3] = z13 - z2;
    tmpptr[1] = z11 + z4;
    tmpptr[7] = z11 - z4;

    //dataptr += pixelsPerRow<<bytesPerPixel;		/* advance pointer to next row */
    dataptr += pixelsPerRow*bytesPerPixel;		/* advance pointer to next row */
    tmpptr += 8;
  }

  /* Pass 2: process columns. */

  tmpptr = tmp;
  
  for (ctr = DCTSIZE-1; ctr >= 0; ctr--) {
    tmp0 = (int32_t)tmpptr[8*0] + tmpptr[8*7];
    tmp7 = (int32_t)tmpptr[8*0] - tmpptr[8*7];
    tmp1 = (int32_t)tmpptr[8*1] + tmpptr[8*6];
    tmp6 = (int32_t)tmpptr[8*1] - tmpptr[8*6];
    tmp2 = (int32_t)tmpptr[8*2] + tmpptr[8*5];
    tmp5 = (int32_t)tmpptr[8*2] - tmpptr[8*5];
    tmp3 = (int32_t)tmpptr[8*3] + tmpptr[8*4];
    tmp4 = (int32_t)tmpptr[8*3] - tmpptr[8*4];
    
    /* Even part */
    
    tmp10 = tmp0 + tmp3;	/* phase 2 */
    tmp13 = tmp0 - tmp3;
    tmp11 = tmp1 + tmp2;
    tmp12 = tmp1 - tmp2;
    
    optr[numBlks*0] = diff_quantize(tmp10 + tmp11,qtable[8*0],quality,
                                (ctr==DCTSIZE-1)?1:0); /* phase 3 */
    optr[numBlks*4] = diff_quantize(tmp10 - tmp11,qtable[8*4],quality,0);
    
    z1 = MULTIPLY(tmp12 + tmp13, FIX_0_707106781); /* c4 */
    optr[numBlks*2] = diff_quantize(tmp13 + z1,qtable[8*2],quality,0); /* phase 5 */
    optr[numBlks*6] = diff_quantize(tmp13 - z1,qtable[8*6],quality,0);
    
    /* Odd part */

    tmp10 = tmp4 + tmp5;	/* phase 2 */
    tmp11 = tmp5 + tmp6;
    tmp12 = tmp6 + tmp7;

    /* The rotator is modified from fig 4-8 to avoid extra negations. */
    z5 = MULTIPLY(tmp10 - tmp12, FIX_0_382683433); /* c6 */
    z2 = MULTIPLY(tmp10, FIX_0_541196100) + z5; /* c2-c6 */
    z4 = MULTIPLY(tmp12, FIX_1_306562965) + z5; /* c2+c6 */
    z3 = MULTIPLY(tmp11, FIX_0_707106781); /* c4 */

    z11 = tmp7 + z3;		/* phase 5 */
    z13 = tmp7 - z3;

    optr[numBlks*5] = diff_quantize(z13 + z2,qtable[8*5],quality,0); /* phase 6 */
    optr[numBlks*3] = diff_quantize(z13 - z2,qtable[8*3],quality,0);
    optr[numBlks*1] = diff_quantize(z11 + z4,qtable[8*1],quality,0);
    optr[numBlks*7] = diff_quantize(z11 - z4,qtable[8*7],quality,0);

    optr+=numBlks<<3;
    tmpptr++;
    qtable++;

  }

}
     
