#ifndef _BIT_BUFFER_H
#define _BIT_BUFFER_H

#define INVALID_BIT 255

typedef struct {
    uint16_t size_in_bits;
    uint16_t pos; //position in bits where to write next bit
    uint16_t rpos; //position in bits where to read next bit
    uint8_t buf[];
} bitBuf;

/* Functions to manipulate the bitBuf.
   You should really be using the BitBuffer interface to play
   with your bitBuffer. These functions are here because
   EliasGamma needs them, and it gets the pointer to the
   buffer. */

inline uint16_t bitBuf_getFreeBits(bitBuf* buf) {
    return buf->size_in_bits - buf->pos;
}

inline error_t bitBuf_putBit(bitBuf* buf, uint8_t bit) {
    uint16_t B;
    uint8_t b, mask;
    if (buf->pos == (buf->size_in_bits))
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

inline uint8_t bitBuf_getNextBit(bitBuf *buf)
{
    uint16_t B;
    uint8_t b, mask;
    if (buf->rpos == buf->pos)
        return INVALID_BIT;
    B = buf->rpos >> 3;
    b = buf->rpos - (B << 3); 
    mask = 1 << b;
    buf->rpos++;
    return (buf->buf[B] & mask)?1:0;
}

#endif
