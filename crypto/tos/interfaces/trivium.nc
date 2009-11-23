#include "trivium.h"
/*
 * 	Interface for the Trivium Stream cipher in TinyOS.
 */

interface trivium{
	/*
	* 	Key and IV initialisation, need to be perform once when the node boots.
	*	s1,s2,s3	:	the state of the algorithm.
    *                   if a 8-bit microcontroller is used, the sizes of each array are:
    *                   s1[12], s2[11] and s3[14].
    *                   if a 16-bit microcontroller is used:
    *                   s1[6], s2[6] and s3[7].
    *
	*	IV		    :	the initialization vector, 80 bits.
	*	K		    : 	the secret key, 80 bits.
	*/
	command void key_init(uint_t *s1,uint_t *s2, uint_t *s3, uint_t *K, uint_t *IV);


	/*
	*	Generation of 64 bits of random data which can be XORed with the plaintext or ciphertext.
	*/
	command void gen_keystream(uint_t *s1,uint_t *s2, uint_t *s3, uint_t *z);

    /*
    *   Encryption or decryption of a message contains in the variable "input" with length stored in
    *   the variable "length". the result is store in the "output" variable. s1, s2 and s3 represents
    *   the current state of the algorithm.
    */
    command void process_bytes(uint_t *s1,uint_t *s2, uint_t *s3,uint8_t *input, uint8_t *output, int32_t length);
}
