/**
 * @author Roman Lim
 */

#ifndef HARVESTER_H
#define HARVESTER_H
#include <AM.h>

enum {
  /* Number of readings per message. If you increase this, you may have to
     increase the message_t size. */
  // NREADINGS = 1,
  /* Default sampling period. */
  SAMPLING_INTERVAL = 10240,
  AM_HARVESTER = 0x93,
  AM_TREEINFO = 0x94,
  TREEINFO_INT = 30000,
  LPL_INT = 150UL,
  NEIGHBOR_TABLE_SIZE = 1,
//  TX_POWER=3, /* 0 - 31, use lower values to generate multihop network in a smaller place */
};

typedef nx_struct harvester {
  nx_uint8_t dsn; /* serial number */
  nx_uint16_t id; /* Mote id of sending mote. */
  nx_uint16_t value; /* the value of the sample */
} harvester_t;

typedef nx_struct treeinfoNeighour {
	nx_am_addr_t nodeId; /* This is the current parent of the node. */
	nx_uint16_t etx;		/* linkquality to parent */ 
} nx_treeinfoNeighour_t;


typedef nx_struct treeinfo {
	nx_am_addr_t id; /* Mote id of sending mote. */
	nx_am_addr_t parent; /* This is the current parent of the node. */
	nx_uint8_t numNeighbours;
	nx_treeinfoNeighour_t neighbours[NEIGHBOR_TABLE_SIZE]; /* NEIGHBOR_TABLE_SIZE is defined in LE */
	nx_uint8_t sn;
} treeinfo_t;

#endif
