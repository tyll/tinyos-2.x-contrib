
/**
 * @author David Moss
 */
 
#include "TinyosString.h" 
 
interface IntToHexStr {

  /**  
   * Convert the value to an ascii hexadecimal string, and append it to the
   * given string.
   * @param str The string to append the result to
   * @param value The value to convert
   * @return SUCCESS if the value got converted and appended to the string,
   *     ESIZE if it's too big.
   */
  command error_t toHexString(string_t *str, uint32_t value);
   
  /**  
   * Convert the value to an ascii decimal string, and append it to the
   * given string.
   * @param str The string to append the result to
   * @param value The value to convert
   * @return SUCCESS if the value got converted and appended to the string,
   *     ESIZE if it's too big.
   */
  command error_t toDecString(string_t *str, uint32_t value);
  
}

