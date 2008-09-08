#include "PowerState.h"

/* Shortcut to call setBits. To use this you must have defined
 * (preferrably through enums) name_MASK and name_OFF values.
 */
#define SET_BITS(name, value) \
   setBits(name##_MASK, name##_OFF, value)


interface PowerState {
    /** Sets the powerstate to value */
    async command void set(powerstate_t value);

    /** Sets the part of powerstate represented by mask to value.
     *  @param mask the bits of powerstate that should be changed
     *  @param offset of the least significant bit of mask
     *  @param value value to set the bits to. value will be shifted by offset, so
     *               it should start at bit 0.
     *  For example, to set bits 4 and 5 of 01[11]0101 to 2 (producing 01[10]0101)
     *   this function should be called with setBits(00110000, 4, 2)
     */
    async command void setBits(powerstate_t mask , uint8_t offset, powerstate_t value);

    /* Sets the bits of powerstate corresponding to mask to 0.
     * 01101101.unsetBits(01111100) = 00000001. This is equivalent
     * to setBits(mask, 0, 0) */
    async command void unsetBits(powerstate_t mask);

    /** Sets the bit indicated by bit (0..15) to 1 */

    async command void setBit(uint8_t bit);
    /** Unsets the bit indicated by bit (0..15) to 0 */
    async command void unsetBit(uint8_t bit);
}


