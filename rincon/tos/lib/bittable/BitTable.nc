
#include "BitTable.h"

interface BitTable {

  /**
   * Set a bit
   * @param table the table to set a bit from
   * @param element the bit element to set
   */
  command void set(bit_table_t *table, uint8_t element);
  
  /**
   * Clear a bit
   * @param table the table to clear from
   * @param element the bit element to clear
   */
  command void clr(bit_table_t *table, uint8_t element);
  
  /**
   * @return TRUE if the bit element is set in the given table
   */
  command bool isBitSet(bit_table_t *table, uint8_t element);
  
  /** 
   * Clear all bits
   * @param table the table to clear
   */
  command void clearAll(bit_table_t *table);
  
  /**
   * @return the total number of bits that are set
   */
  command uint8_t getTotal(bit_table_t *table);
  
  /**
   * @param table the table to search through to find the next bit that's high.
   * @param currentElement the element to start search from. The search includes
   *     that element.  -1 will start from the beginning.
   * @return the element number of the next bit that is set high.
   *     returns  -1 (0xFF) if no more elements are set high.
   */
  command uint8_t getNext(bit_table_t *table, uint8_t currentElement);
  
}

