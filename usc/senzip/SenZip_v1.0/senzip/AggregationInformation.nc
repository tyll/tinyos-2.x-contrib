/*
 * used by Aggregation component, provided by Routing component
 *
 * @ author        Sundeep Pattem
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California

*/

#include "Compression.h"

interface AggregationInformation { 

  command error_t initSettings(uint8_t metric); 

  event void parentChange(uint16_t newParent, uint8_t depth);

}
