#include "BitBuffer.h"

/** Inteface for a BitBuffer. The BitBuffer has a capacity of
 *  an integer number of bytes, but can be acessed as a sequential
 *  list of bits.
 *  The buffer has a write position, where the next bit is added,
 *  and a read position, where the next bit is read.
 *  The read position is smaller than or equal to the the write
 *  position.
 */
interface BitBuffer {
    /** Resets the BitBuffer to all 0's, and the read and write
     * positions to 0.*/
    command void clear();

    /** Sets the next position in the BitBuffer to
     * the value of bit. 
     * @param bit the bit to set
     * @returns FAIL if the buffer is full
     */
    command error_t putBit(bool bit);
    
    /** Pads the buffer with 0's to complete an integral number of
     *  bytes. pad() will never increase the number of bytes in the
     *  buffer as returned by getNBytes.
     */
    command void pad();

    /* Adds a memory aligned byte to the buffer (padding the current
     * byte if necessary).
     * @param byte the byte to add to the buffer
     * @return FAIL if the buffer is full 
     */
    command error_t putByte(uint8_t byte);

    /* Returns the bit in the current read position in the buffer,
     * or INVALID_BIT if there is no more bits to read.
     * Advances the read position */
    command uint8_t getNextBit();

    /** Returns the length of the used portion of the
     * buffer, in bytes. This is ceil(nbits/8) */
    command uint16_t getNBytes(); 

    /** Returns the number of bits used in the BitBuffer.
     */
    command uint16_t getNBits();
    
    /* Returns the total size of the buffer in bytes */
    command uint16_t getSize();

    /* Returns the number of free bits in the buffer */
    command uint16_t getFreeBits();

    /* Sets the read position. If rpos is >= the number
     * of bits in the buffer, the read position is set
     * to the last position and the next read will cause
     * an INVALID_BIT to be read.
     */


    command void setReadPos(uint16_t rpos);

    /* Gets the read position */
    command uint16_t getReadPos();

    /** Returns a pointer to the actual byte buffer.
     *  getNBytes() bytes will be used.
     */
    command uint8_t* getBytes();

    /** Returns a pointer to the internal bitBuf representation.
     *  ONLY USE IF YOU KNOW WHAT YOU ARE DOING!!!
     */
    command bitBuf* getBuffer();
        
}
