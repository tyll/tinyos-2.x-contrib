
#include "BitTable.h"

module BitTableP {
  provides {
    interface BitTable;
  }
}

implementation {

  /*
  void dump(bit_table_t *table) {
    int i;
    ////printf("table %p: ", table);
    for(i = 0; i < sizeof(bit_table_t) * 8; i++) {
      if(call BitTable.isBitSet(table, i)) {
        ////printf("1");
      } else {
        ////printf("0");
      }
    }
    
    ////printf("\n\r");
  }
  */
  
  /***************** BitTable Commands ****************/
  /**
   * Set a bit
   * @param table the table to set a bit from
   * @param element the bit element to set
   */
  command void BitTable.set(bit_table_t *table, uint8_t element) {
    if(element < sizeof(bit_table_t) * 8) {
      (table->data[element / 8]) |= (1 << (element % 8));
    }
    ////printf("set %d\n\r", element);
    //dump(table);
  }
  
  /**
   * Clear a bit
   * @param table the table to clear from
   * @param element the bit element to clear
   */
  command void BitTable.clr(bit_table_t *table, uint8_t element) {
    if(element < sizeof(bit_table_t) * 8) {
      (table->data[element / 8]) &= ~(1 << (element % 8));
    }
    ////printf("clr %d\n\r", element);
    //dump(table);
  }
  
  /**
   * @return TRUE if the bit element is set in the given table
   */
  command bool BitTable.isBitSet(bit_table_t *table, uint8_t element) {
    return ((table->data[element / 8]) >> (element % 8)) & 0x1;
  }
  
  /** 
   * Clear all bits
   * @param table the table to clear
   */
  command void BitTable.clearAll(bit_table_t *table) {
    memset(table, 0x0, sizeof(bit_table_t));
    ////printf("clearAll\n\r");
    //dump(table);
  }
  
  /**
   * @return the total number of bits that are set
   */
  command uint8_t BitTable.getTotal(bit_table_t *table) {
    uint8_t total = 0;
    int i;
    for(i = 0; i < sizeof(bit_table_t) * 8; i++) {
      total += call BitTable.isBitSet(table, i);
    }
    return total;
  }
  
  /**
   * @param table the table to search through to find the next bit that's high.
   * @param currentElement the element to start search from. The search includes
   *     that element.  -1 will start from the beginning.
   * @return the element number of the next bit that is set high.
   *     returns  -1 (0xFF) if no more elements are set high.
   */
  command uint8_t BitTable.getNext(bit_table_t *table, uint8_t currentElement) {
    uint8_t i;
    for(i = currentElement + 1; i < sizeof(bit_table_t) * 8; i++) {
      if(call BitTable.isBitSet(table, i)) {
        return i;
      }
    }
    
    return -1;
  }
  

}

