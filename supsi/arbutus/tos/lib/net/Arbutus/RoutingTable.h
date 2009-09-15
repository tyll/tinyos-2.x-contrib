#define NEIGHBOR_TABLE_SIZE 30

enum {INVALID_RVAL=0xFF,};



typedef struct neighbor_table_entry {
  nx_uint16_t node;  
  nx_uint8_t local_hopcount;  
  nx_uint8_t local_adjustedHopcount;    
  nx_uint16_t ll_addr;
  nx_uint16_t isParent;
  nx_uint16_t beaconerParent;
  nx_uint8_t beaconer_hopcount;
  nx_uint8_t lastseq;
  nx_uint8_t rcvcnt;
  nx_uint8_t failcnt;
  nx_uint8_t flags;
  nx_uint8_t rss;
  nx_uint8_t lqi;
  nx_uint8_t rssBottleneck;
  nx_uint8_t lqiBottleneck;
  nx_uint16_t rnp;
  nx_uint8_t freaky;
  nx_uint16_t metric;
  nx_uint16_t formerParent;
  nx_uint8_t controlState;

} neighbor_table_entry_t;






