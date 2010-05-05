
#include "hotmac.h"

interface NeighborTable {
  command struct hotmac_neigh_entry *lookup(ieee154_saddr_t nAddr);
  command struct hotmac_neigh_entry *insert(ieee154_saddr_t nAddr);
  command struct hotmac_neigh_entry *lookupOrInsert(ieee154_saddr_t nAddr);

  command error_t pinNeighbor(ieee154_saddr_t nAddr);

  event void evicted(ieee154_saddr_t nAddr);

#ifdef PRINTFUART_ENABLED
  command void print();
#endif

}
