
#include "hotmac.h"

module NeighborTableC {
  provides interface Init;
  provides interface NeighborTable;
} implementation {

  struct hotmac_neigh_entry table[HOTMAC_NEIGHBORTABLE_SZ];
  
  command error_t Init.init() {
    memset(&table, 0, sizeof(table));
    return SUCCESS;
  }

#ifdef PRINTFUART_ENABLED
  command void NeighborTable.print() {
    int i;

    printfUART("slot\t|VP\t|addr\t|lru\t|lsn\t|phase\t|period\n");
    for (i = 0; i < HOTMAC_NEIGHBORTABLE_SZ; i++) {
      printfUART("%i\t|", i);
      if (table[i].valid) {
        printfUART("V");
      } else {
        printfUART(" ");
      }
      if (table[i].pinned) {
        printfUART("P");
      } else { 
        printfUART(" ");
      }
      printfUART("\t|%i\t|%i\t|%i\t|%i\t|%i\n", table[i].neigh,
                 table[i].lru, table[i].lsn, table[i].phase,
                 table[i].period);
    }
  }
#endif

  command struct hotmac_neigh_entry *NeighborTable.lookup(ieee154_saddr_t nAddr) {
    int i;
    for (i = 0; i < HOTMAC_NEIGHBORTABLE_SZ; i++) {
      if (table[i].valid && table[i].neigh == nAddr) {
        if (table[i].lru < 0xf) {
          table[i].lru++;
        }
        return &table[i];
      }
    }
    return NULL;
  }

  command struct hotmac_neigh_entry *NeighborTable.insert(ieee154_saddr_t nAddr) {
    int i;
    int minLru[2] = {0xff,0};

    for (i = 0; i < HOTMAC_NEIGHBORTABLE_SZ; i++) {
      if (!table[i].valid) {
        goto filin;
      }
      if (!table[i].pinned && table[i].lru < minLru[0]) {
        minLru[0] = table[i].lru;
        minLru[1] = i;
      }
    }
    if (minLru[0] == 0xff) return NULL;
    signal NeighborTable.evicted(table[minLru[1]].neigh);
    i = minLru[1];

  filin:
    memset(&table[i], 0, sizeof(struct hotmac_neigh_entry));
    table[i].valid = 1;
    table[i].neigh = nAddr;
    return &table[i];
  }

  command struct hotmac_neigh_entry *NeighborTable.lookupOrInsert(ieee154_saddr_t nAddr) {
    struct hotmac_neigh_entry *neigh = NULL;

    neigh = call NeighborTable.lookup(nAddr);
    if (neigh == NULL) {
      neigh = call NeighborTable.insert(nAddr);
    }
    return neigh;
  }

  command error_t NeighborTable.pinNeighbor(uint16_t nAddr) {
    struct hotmac_neigh_entry *entry = call NeighborTable.lookup(nAddr);
    if (entry == NULL) return FAIL;
    entry->pinned = 1;
    return SUCCESS;
  }
}
