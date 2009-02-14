/** @author Rodrigo Fonseca */

/** Interface to an 8-bit Move-to-front encoder/decoder.
 *  MTF is used to reduce the entropy of a list of integers
 *  that exhibit locality of reference. 
 *  It is a reversible transform of the list, and is used in 
 *  compression. For example, it is used associated with the
 *  Burrows-Wheeler transform in bzip2.
 *
 *  For each number n in the list, the output is the number of
 *  unique distinct numbers in the list since the last occurrence
 *  of n. In other words, an MTF encoder converts a list into its
 *  stack distance representation, where each reference to n moves
 *  n to the top of a stack.
 *  The initial state is a stack in which number k is at position k.
 *
 *  To decode the list the decoder must have the same initial state.
 *  It then keeps the same stack as the encoder does, based on the
 *  stack distances. 
 *  For each integer k in the encoded list it finds the k-th
 *  integer in the stack, outputs k, and moves k to the top of the 
 *  stack.
 *  
 */
interface MoveToFront {
    /* Resets the MTF state to the cannonical one */
    command void init();
    
    /** Returns the MTF encoding of byte. This depends
     * on the history of previous encodings */
    command uint8_t encode(uint8_t byte);

    /** Returns the integer corresponding to the encoding
     *  of pos. This depends on the history of previous
     *  decodings. */
    command uint8_t decode(uint8_t pos);
}
