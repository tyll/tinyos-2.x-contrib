#ifndef QLOG_COMP_MY_UART
#define QLOG_COMP_MY_UART
    enum {
        CBLOCKSIZE = 20,   //  # msgs compressed at once
        BUFFERSIZE = 100,  //  # msgs in event buffer. Must be
                           //    a multiple of CBLOCKSIZE.
        BITBUFSIZE = 234,  //  # size in bytes of the bit buffer.
        MTFSYNC   = 10,   //  # reset mtf every MTFRESET blocks
    };

    /* The BitBuffer size has to be larger than the entry size X
     * CBLOCKSIZE, because in the worst case an integer of b bits
     * will take 2*b-1 bits to encode in Elias Gamma. In most cases,
     * however, the size will be much smaller than b.
     * Each entry has 12 bytes, but b/c of the way they are encoded
     * (8,8,32,32,8,8) they will take at most 186 bits.
     * 186x10 = 1860 = 232.5, hence 234 bytes. */
   
#endif
