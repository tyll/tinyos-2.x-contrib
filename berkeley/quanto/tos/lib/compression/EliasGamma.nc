/** @author Rodrigo Fonseca */

interface EliasGamma {
    /* Encode a [32, 16, 8]-bit unsigned *positive* integer to the buffer.
     * @param buffer A bitBuf with enough space for the encoded
     *               integer
     * @param n The integer to be encoded. n > 0.
     * @returns The number of bits used by the encoded integer,
     *          or 0 if (i) the input was 0, or 
     *                  (ii) there was no space in the buffer.
     *          If the return was 0, the buffer is guaranteed to
     *          not be altered.
     */
    command uint8_t encode32(bitBuf* buffer, uint32_t n);
    command uint8_t encode16(bitBuf* buffer, uint16_t n);
    command uint8_t  encode8(bitBuf* buffer,  uint8_t n);

    /* Decodes an up to 32-bit integer from the buffer.
     * Returns 0 in case of an error. The bitBuf is not
     * altered in case of an error. */
    command uint32_t decode32(bitBuf* buffer);
    command uint16_t decode16(bitBuf* buffer);
    command uint8_t   decode8(bitBuf* buffer);
}


