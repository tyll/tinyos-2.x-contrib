/*
 * used by Compression component, provided by Aggregation component
 *
 * @ author        Sundeep Pattem
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California
*/

#include "Compression.h"

interface AggregationTable {
  
  command void contactDescendant(uint8_t pos, uint8_t idx);

  event void tablePointer(agg_table_entry_t *entry, self_info *info);
  
  event void change(uint8_t type, uint8_t pos);

}