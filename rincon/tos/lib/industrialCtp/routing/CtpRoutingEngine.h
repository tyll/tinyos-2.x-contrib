
#ifndef CTPROUTINGENGINE_H
#define CTPROUTINGENGINE_H

/**
 * TRUE if we are to use congestion in the routing engine
 */
#ifndef ECN_ON
#define ECN_ON FALSE
#endif

#ifndef CTP_MIN_BEACON_INTERVAL
#define CTP_MIN_BEACON_INTERVAL 5120U  // 5 seconds
#endif

#ifndef CTP_MAX_BEACON_INTERVAL
#define CTP_MAX_BEACON_INTERVAL 44236800U  // 12 hours
#endif

enum {
    AM_TREE_ROUTING_CONTROL = 0xCE,
    BEACON_INTERVAL = 30720,    // Increased the minimum beacon interval
    INVALID_ADDR  = TOS_BCAST_ADDR,
    ETX_THRESHOLD = 50,         // link quality=20% -> ETX=5 -> Metric=50 
    PARENT_SWITCH_THRESHOLD = 15,
    MAX_METRIC = 0xFFFF,
}; 
 

typedef struct {
  am_addr_t parent;
  uint16_t etx;
  bool haveHeard;
  bool congested;
} route_info_t;

typedef struct {
  am_addr_t neighbor;
  route_info_t info;
} routing_table_entry;



#endif
