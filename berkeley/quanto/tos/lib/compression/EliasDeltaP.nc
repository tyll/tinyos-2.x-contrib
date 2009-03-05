#include "BitBuffer.h" 

module EliasDeltaP {
    provides interface EliasDelta;
    uses interface EliasGamma;
}
implementation {
    /* encode */
    command uint8_t EliasDelta.encode32(bitBuf* buf, uint32_t b) {
        uint32_t bb = b;
        uint32_t m;
        uint8_t l = 0;
        uint8_t ll;
        uint8_t lll = 0;
        
        uint8_t len = 0;
        while ((bb >>= 1))                  //floor(log2(b))
                l++;

        ll = l+1;                           //compute the length of ll encoded
        while ((ll >>= 1))                  // as EliasGamma
            lll++;
        len = (lll<<1) + 1 + l;               //len(EG(l+1)) + l
        if (len > bitBuf_getFreeBits(buf))
            return 0;
    
         //encode l+1 in elias_gamma
        if (! call EliasGamma.encode8(buf, l+1) )
            return 0;
    
        for (m = ((uint32_t)1 << l) >> 1; m ; m >>= 1) {   //copy b to buffer, skipping the msb
            bitBuf_putBit(buf,(b & m)?1:0);
        }
        return  len;
    }
    
    command uint8_t EliasDelta.encode16(bitBuf* buf, uint16_t b) {
        uint16_t bb = b;
        uint16_t m;
        uint8_t l = 0;
        uint8_t ll;
        uint8_t lll = 0;
        
        uint8_t len = 0;
        while ((bb >>= 1))                  //floor(log2(b))
                l++;

        ll = l+1;                           //just to compute length
        while ((ll >>= 1))
            lll++;
        len = (lll<<1) + 1 + l;               //len(EG(l+1)) + l
        if (len > bitBuf_getFreeBits(buf))
            return 0;
    
         //encode l+1 in elias_gamma
        if (! call EliasGamma.encode8(buf, l+1) )
            return 0;
    
        for (m = ((uint16_t)1 << l) >> 1; m ; m >>= 1) {   //copy b to buffer, skipping the msb
            bitBuf_putBit(buf,(b & m)?1:0);
        }
        return  len;
    }
   
    command uint8_t EliasDelta.encode8(bitBuf* buf, uint8_t b) {
        uint8_t bb = b;
        uint8_t m;
        uint8_t l = 0;
        uint8_t ll;
        uint8_t lll = 0;
        
        uint8_t len = 0;
        while ((bb >>= 1))                  //floor(log2(b))
                l++;

        ll = l+1;                           //just to compute length
        while ((ll >>= 1))
            lll++;
        len = (lll<<1) + 1 + l;               //len(EG(l+1)) + l
        if (len > bitBuf_getFreeBits(buf))
            return 0;
    
         //encode l+1 in elias_gamma
        if (! call EliasGamma.encode8(buf, l+1) )
            return 0;
    
        for (m = (1 << l) >> 1; m ; m >>= 1) {   //copy b to buffer, skipping the msb
            bitBuf_putBit(buf,(b & m)?1:0);
        }
        return  len;
    }
    
    /* Decode the next elias_gamma integer from the buffer. 
     * Assumes that an elias_gamma encoded integer begins in
     * buf->rpos */
    command uint32_t EliasDelta.decode32(bitBuf *buf) {
        uint8_t l = 0;
        uint32_t n = 0;
        uint8_t i;
        uint8_t b;

        l = call EliasGamma.decode8(buf);
        if (!l) 
            return 0;
        l--;
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
    
    command uint16_t EliasDelta.decode16(bitBuf *buf) {
        uint8_t l = 0;
        uint16_t n = 0;
        uint8_t i;
        uint8_t b;

        l = call EliasGamma.decode8(buf);
        if (!l) 
            return 0;
        l--;
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
   
    command uint8_t EliasDelta.decode8(bitBuf *buf) {
        uint8_t l = 0;
        uint8_t n = 0;
        uint8_t i;
        uint8_t b;

        l = call EliasGamma.decode8(buf);
        if (!l) 
            return 0;
        l--;
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
    

