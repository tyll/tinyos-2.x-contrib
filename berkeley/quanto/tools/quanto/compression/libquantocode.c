/*
 *  Copyright (c) 2009 Rodrigo Fonseca <rodrigo.fonseca@gmail.com>
 * 
 *  Permission is hereby granted, free of charge, to any person obtaining a 
 *  copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 * 
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 * 
 *  Author: Rodrigo Fonseca <rodrigo.fonseca@gmail.com>
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "libquantocode.h"

inline void bitBuf_clear(bitBuf* buf) {
    memset(buf->buf, 0, buf->size);
    buf->pos = 0;
    buf->rpos = 0;
}

bitBuf* bitBuf_new(uint16_t size) {
    bitBuf* p;
    p = (bitBuf*) malloc (sizeof(bitBuf) + (size-1)*sizeof(uint8_t));
    p->size = size;
    bitBuf_clear(p);
    return p;
}

void bitBuf_delete(bitBuf* buf) {
    free(buf);
}

/* sets the bit */
inline bool bitBuf_putBit(bitBuf* buf, bool bit) {
    uint16_t B;
    uint8_t b, mask;
    if (buf->pos == (buf->size << 3))
        return FALSE;
    if (bit) {
        B = buf->pos >> 3;
        b = buf->pos - (B << 3); 
        mask = 1 << b;
        buf->buf[B] |= mask; 
    }
    buf->pos++;
    return TRUE;
}

inline bool bitBuf_pad(bitBuf* buf) {
    uint16_t B; 
    if (buf->pos == (buf->size << 3))
        return FALSE;
    B = buf->pos % 8;
    if (B) {
        buf->pos += 8 - B;
    }
    return TRUE;
}

uint16_t bitBuf_length(bitBuf* buf) {
    uint16_t B;
    uint8_t b;
    B = buf->pos >> 3;
    b = buf->pos % 8;
    if (b)
        return B+1;
    return B;
}

inline bool bitBuf_putByte(bitBuf* buf, uint8_t byte) {
    uint16_t l = bitBuf_length(buf);
    if (l == buf->size)
        return FALSE;
    bitBuf_pad(buf); //pad can't increase the length
    buf->buf[l] = byte;
    buf->pos += 8; 
    return TRUE;
}

inline int bitBuf_getNextBit(bitBuf* buf) {
    uint16_t B;
    uint8_t b,mask;
    if (buf->rpos == buf->pos)
        return -1;
    B = buf->rpos >> 3;
    b = buf->rpos - (B << 3); 
    mask = 1 << b;
    buf->rpos++;
    return (buf->buf[B] & mask)?1:0;
}

inline void bitBuf_setReadPos(bitBuf* buf,uint16_t pos) {
    if (pos > buf->pos) 
        buf->rpos = buf->pos;
    buf->rpos = pos;
}

inline void bitBuf_resetReadPos(bitBuf* buf) {
    bitBuf_setReadPos(buf, 0);
}

inline uint16_t bitBuf_getReadPos(bitBuf* buf) {
    return buf->rpos;
}

void bitBuf_print(bitBuf* buf) {
    uint16_t B, i;
    uint8_t b,j,l;
    B = buf->pos >> 3;
    b = buf->pos - (B << 3);
    printf("bitBuf {size:%d pos:%d B:%d b:%d}\n", buf->size, buf->pos, B, b);
    for (i = 0; i <= B; i++) {
        l = 8;
        if (i == B)
            l = b;
        for (j = 0; j < l; j++) {
            printf("%d", (buf->buf[i] & (1 << j))?1:0);
        }
        printf (" ");
    }
}

/************* 32-bit Elias Gamma Codec ***************/

void elias_gamma_encode(uint32_t b, bitBuf* buf) {
    uint32_t bb = b;
    uint32_t m;
    uint8_t l = 0;
    //put as many 0's as l = floor(log2(b))
#ifdef EG_DEBUG
    fprintf(stderr,"eg: encoding %d : ", b);
#endif
    while (bb >>= 1) {
        l++;
#ifdef EG_DEBUG
        fprintf(stderr, "0");
#endif
        bitBuf_putBit(buf, 0);
    }
    //copy b to the buffer starting from the msb
    for (m = 1 << l; m ; m >>= 1) {
#ifdef EG_DEBUG
        fprintf(stderr, "%d", (b&m)?1:0);
#endif
        bitBuf_putBit(buf,(b & m)?1:0);
    }
#ifdef EG_DEBUG
    fprintf(stderr, "\n");
#endif
}

/* Decode the next elias_gamma integer from the buffer. 
 * Assumes that an elias_gamma encoded integer begins in
 * buf->rpos */
uint32_t elias_gamma_decode(bitBuf *buf) {
    uint8_t l = 0;
    uint32_t n = 0;
    uint8_t i;
    int b;
    while (!(b = bitBuf_getNextBit(buf))) {
#ifdef EG_DEBUG
        fprintf(stderr, "0");
#endif
        l++;
    }
    if (b == -1)
      return 0;
    n |= 1 << l;
    for (i = l; i > 0; i--) {
       if ((b = bitBuf_getNextBit(buf)) == 1) {
           n |= 1 << (i-1); 
       } else if (b == -1) {
           return 0;
       }
    }
#ifdef EG_DEBUG
    fprintf(stderr, " eg: %u \n", n);
#endif
    return n;
}

/************ 32-bit Elias Delta Codec ***************/
/* Elias Delta encodes the length portion of the elias
 * gamma code using elias gamma */

void elias_delta_encode(uint32_t b, bitBuf* buf) {
    uint32_t bb = b;
    uint32_t m;
    uint8_t l = 0;

#ifdef EG_DEBUG
    fprintf(stderr,"ed: encoding %d : ", b);
#endif
    //determine l = floor(log2(b))
    while (bb >>= 1) {
        l++;
    }
    //encode l+1 in elias_gamma
    elias_gamma_encode(l+1, buf);
    //copy b to the buffer, skipping the msb
    for (m = (1 << l) >> 1; m ; m >>= 1) {
        bitBuf_putBit(buf,(b & m)?1:0);
#ifdef EG_DEBUG
        fprintf(stderr, "%d", (b&m)?1:0);
#endif
    }
#ifdef EG_DEBUG
    fprintf(stderr, "\n");
#endif
}

uint32_t elias_delta_decode(bitBuf *buf) {
   uint32_t l;
   uint32_t n = 0;
   uint8_t i;
    int b;
   l = elias_gamma_decode(buf);
   if (!l) return 0;
   l--;
   n |= 1 << l;
     for (i = l; i > 0; i--) {
       if ((b = bitBuf_getNextBit(buf)) == 1) {
           n |= 1 << (i-1); 
       } else if (b == -1) {
           return 0;
       }
    }
#ifdef EG_DEBUG
    fprintf(stderr, " ed: %u \n", n);
#endif
    return n;
}

/************ 8-bit Move To Front Codec **************/

void mtf_init(mtf_encoder* mtf) {
    int i;
    for (i = 0; i < 255; i++)
        mtf->order[i] = i+1;
    mtf->h = 0;
} 

/* moves b to the front and returns the
 * distance */
uint8_t mtf_encode(mtf_encoder* mtf, uint8_t b) {
    uint8_t p, i;
    p = mtf->h;
    if (p == b)
        return 0;
    //with another of reverse pointers we can make the search o(1)
    //we are trading 256 bytes of memory for up to 256 accesses to
    //memory. If there is locality, these would be much less.
    for (i = 1, p = mtf->h; mtf->order[p] != b; i++, p = mtf->order[p])
        ;
    //i is the position in the list
    //now we move to front
    if (mtf->order[b] == b)                 //is b the last?
        mtf->order[p] = p;                  //now p is the last
    else
        mtf->order[p] = mtf->order[b];      //next(p) = next(b)
    mtf->order[b] = mtf->h;                 //b comes before head
    mtf->h = b;                             //head points to b

    return i;
}

uint8_t mtf_decode(mtf_encoder* mtf, uint8_t b) {
    uint8_t v, p;
    uint8_t i;

    if (b == 0)
        return mtf->h;
    //if not head, we have to find the b-th element in the 
    //list, move it to the front, and return it.    
    for (i = 1, p = mtf->h; i < b ; i++, p = mtf->order[p])
        ;
    //p = predecessor of the v
    v = mtf->order[p];   
    //move to front
    if (mtf->order[v] == v)
        mtf->order[p] = p;
    else
        mtf->order[p] = mtf->order[v];
    mtf->order[v] = mtf->h;
    mtf->h = v;
    
    return  v;
}


