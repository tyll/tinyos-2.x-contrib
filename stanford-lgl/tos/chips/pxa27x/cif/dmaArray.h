#ifndef _DMA_ARRAY_H
#define _DMA_ARRAY_H

typedef struct {
    uint32_t DDADR;
    uint32_t DSADR;
    uint32_t DTADR;
    uint32_t DCMD;
} DMADescriptor_t;


#define MAX_DESC_TRANSFER  8184		// max is 8K-1, CIF requires a multiple of 8	//8192

// ----------------------------------------------
#define DescArray_NBR_DESC         20//8
#define DescArray_BYTE_ALLIGNMENT  16
#define DescArray_BUFFER_SIZE      (DescArray_NBR_DESC*sizeof(DMADescriptor_t) + DescArray_BYTE_ALLIGNMENT)

typedef struct DescArray
{
    uint8_t data[DescArray_BUFFER_SIZE];   // The data is alligned from data[baseIndex]
} DescArray;

#endif //_DMA_ARRAY_H
