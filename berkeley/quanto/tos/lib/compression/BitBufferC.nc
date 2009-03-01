#include "BitBuffer.h"
/** @param BB_SIZE number of bytes in the buffer */
generic module BitBufferC(uint16_t BB_SIZE) {
    provides interface BitBuffer;
}
implementation {
    // We overlay the bitBuf pointer to this unnamed struct, which 
    // actually has the allocated space of BB_SIZE entries.
    // The bitBuf type is externally visible, so that other
    // modules can use the storage in this module by reference.
    // The size field exists so that these external users can
    // correctly use the buffer.
    struct {
        uint16_t size_in_bits;
        uint16_t pos;
        uint16_t rpos;
        uint8_t buf[BB_SIZE];
    } buffer;

    bitBuf *buf = (bitBuf*)&buffer;

    command bitBuf* BitBuffer.getBuffer() {
        return buf;
    }

    command uint8_t* BitBuffer.getBytes() {
        return (uint8_t*)&(buf->buf);
    }

    command void BitBuffer.clear() {
        memset(buf->buf, 0, BB_SIZE);
        buf->size_in_bits = BB_SIZE << 3;
        buf->pos = 0;
        buf->rpos = 0;
    }


    inline command uint16_t BitBuffer.getNBits() {
        return buf->pos;
    }
    
    inline command uint16_t BitBuffer.getSize() {
        return BB_SIZE;
    }

    inline command uint16_t BitBuffer.getNBytes() 
    {
        uint16_t B;
        uint8_t b;
        B = buf->pos >> 3;
        b = buf->pos % 8;
        if (b)
            return B+1;
        return B;
    }

    inline command uint16_t BitBuffer.getFreeBits() {
        return bitBuf_getFreeBits(buf);
    }
    /* Assumes content is previously 0 */
    inline command void BitBuffer.pad() {
        uint16_t B = buf->pos % 8;
        if (B) 
            buf->pos += 8 - B;
    }

    inline command error_t BitBuffer.putBit(bool bit) {
        return bitBuf_putBit(buf, bit);
    }
    
    command error_t BitBuffer.putByte(uint8_t byte) {
        uint16_t l = call BitBuffer.getNBytes();
        if (l == BB_SIZE)
            return FALSE;
        call BitBuffer.pad(); //pad can't increase the length
        buf->buf[l] = byte;
        buf->pos += 8; 
        return TRUE;
    }

    command uint8_t BitBuffer.getNextBit() {
        return bitBuf_getNextBit(buf);
    }

    command void BitBuffer.setReadPos(uint16_t rpos) {
        if (rpos > buf->pos) 
            rpos = buf->pos;
        buf->rpos = rpos;
    }

    command uint16_t BitBuffer.getReadPos() {
        return buf->rpos;
    }
}
