#include "BitBuffer.h" 

module EliasGammaC {
    provides interface EliasGamma;
}
implementation {
    /* encode */
    command uint8_t EliasGamma.encode32(bitBuf* buf, uint32_t b) {
        uint32_t bb = b;
        uint32_t m;
        uint8_t i;
        uint8_t l = 0;
        uint8_t len = 0;
        while ((bb >>= 1))                  //floor(log2(b))
                l++;
    
        len = 2*l + 1;
        if (len > bitBuf_getFreeBits(buf))
            return 0;
    
        for (i = 0; i < l; i++)            //put l 0's
            bitBuf_putBit(buf, 0);
    
        for (m = (uint32_t)1 << l ; m ; m >>= 1) {   //copy b to buffer from the msb
            bitBuf_putBit(buf,(b & m)?1:0);
        }
        return  len;
    }
    
    command uint8_t EliasGamma.encode16(bitBuf* buf, uint16_t b) {
        uint16_t bb = b;
        uint16_t m;
        uint8_t i;
        uint8_t l = 0;
        uint8_t len = 0;
        while ((bb >>= 1))                  //floor(log2(b))
                l++;
    
        len = 2*l + 1;
        if (len > bitBuf_getFreeBits(buf))
            return 0;
    
        for (i = 0; i < l; i++)            //put l 0's
            bitBuf_putBit(buf, 0);
    
        for (m = (uint16_t)1 << l ; m ; m >>= 1) {   //copy b to buffer from the msb
            bitBuf_putBit(buf,(b & m)?1:0);
        }
        return  len;
    }
    
    command uint8_t EliasGamma.encode8(bitBuf* buf, uint8_t b) {
        uint8_t bb = b;
        uint8_t m;
        uint8_t i;
        uint8_t l = 0;
        uint8_t len = 0;
        while ((bb >>= 1))                  //floor(log2(b))
                l++;
    
        len = 2*l + 1;
        if (len > bitBuf_getFreeBits(buf))
            return 0;
    
        for (i = 0; i < l; i++)            //put l 0's
            bitBuf_putBit(buf, 0);
    
        for (m = 1 << l ; m ; m >>= 1) {   //copy b to buffer from the msb
            bitBuf_putBit(buf,(b & m)?1:0);
        }
        return  len;
    }
    
    /* Decode the next elias_gamma integer from the buffer. 
     * Assumes that an elias_gamma encoded integer begins in
     * buf->rpos */
    command uint32_t EliasGamma.decode32(bitBuf *buf) {
        uint8_t l = 0;
        uint32_t n = 0;
        uint8_t i;
        uint8_t b;
        while (! (b = bitBuf_getNextBit(buf)))
            l++;
        if (b == INVALID_BIT)
            return 0;
        n |= 1 << l;
        for (i = l; i > 0; i--) {
           if ((b = bitBuf_getNextBit(buf)) == 1 ) {
               n |= 1 << (i-1); 
           } else if (b == INVALID_BIT) {
               return 0;
           }
        }
        return n;
    }
    
    command uint16_t EliasGamma.decode16(bitBuf *buf) {
        uint8_t l = 0;
        uint16_t n = 0;
        uint8_t i;
        uint8_t b;
        while (! (b = bitBuf_getNextBit(buf)))
            l++;
        if (b == INVALID_BIT)
            return 0;
        n |= 1 << l;
        for (i = l; i > 0; i--) {
           if ((b = bitBuf_getNextBit(buf)) == 1 ) {
               n |= 1 << (i-1); 
           } else if (b == INVALID_BIT) {
               return 0;
           }
        }
        return n;
    }
    
    command uint8_t EliasGamma.decode8(bitBuf *buf) {
        uint8_t l = 0;
        uint8_t n = 0;
        uint8_t i;
        uint8_t b;
        while (! (b = bitBuf_getNextBit(buf)))
            l++;
        if (b == INVALID_BIT)
            return 0;
        n |= 1 << l;
        for (i = l; i > 0; i--) {
           if ((b = bitBuf_getNextBit(buf)) == 1 ) {
               n |= 1 << (i-1); 
           } else if (b == INVALID_BIT) {
               return 0;
           }
        }
        return n;
    }
}
    

