
/**
 * @author David Moss
 */
 
#include "TinyosString.h"

module IntToHexStrP {
  provides {
    interface IntToHexStr;
  }
  
  uses {
    interface StringWriter;
    interface Leds;
  }
}

implementation {
  
  const char digits[] = {
      '0','1','2','3',
      '4','5','6','7',
      '8','9','A','B',
      'C','D','E','F'};
  
  /** Buffer to hold the result in */
  char result[8];
  
  /**
   * Helper for converting unsigned numbers to String.
   *
   * @param num the number
   * 
   * @param exp log2(digit) (ie. 1, 3, or 4 for binary, oct, hex)
   */
  void toUnsignedString(uint32_t num, uint8_t expMask, string_t *str) {
    uint8_t mask = (1 << expMask) - 1;
    char *buffer = ((char *) &result) + sizeof(result);
    memset(&result, '0', sizeof(result));
    
    do {
        buffer--;
        *buffer = digits[num & mask];
        num >>= expMask;
    } while (num != 0 && (buffer >= (char *) &result));
    
    // Now our buffer says something like:
    //     00000123
    // So copy out the 123 into the string.
    for( ; buffer < ((char *) (&result)) + sizeof(result); ) {
      *(str->data + str->length) = *buffer;
      str->length++;
      buffer++;
    }
  }
  
  /**
   * Convert the given value to a hex string and append it to the given string.
   * @return SUCCESS if there was enough room to append the value
   */
  command error_t IntToHexStr.toHexString(string_t *str, uint32_t value) {
    // 8 characters is the maximum this conversion may produce
    if(str->length + 8 > DEFAULT_STRING_LENGTH) {
      return ESIZE;
    }
    
    toUnsignedString(value, 4, str);
    return SUCCESS;
  }
  
  command error_t IntToHexStr.toDecString(string_t *str, uint32_t value) {
    string_t theString;
    call StringWriter.clear(&theString);
    
    while(value > 0) {
      if(call StringWriter.insertByte(&theString, (char) ((value % 10) + '0')) != SUCCESS) {
        return ESIZE;
      }
      value /= 10;
    }
    
    call StringWriter.appendBuffer(str, &theString.data, theString.length);
    return SUCCESS;
  }	
  
}

