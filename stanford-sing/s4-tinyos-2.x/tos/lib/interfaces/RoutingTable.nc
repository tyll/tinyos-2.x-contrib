// ex: set tabstop=4 shiftwidth=4 expandtab syn=c:
// $Id$

// Authors: Yun Mao maoy@cis.upenn.edu $Date$

#include "S4.h"

interface RoutingTable {
    command uint16_t get_routing_table_size();
    command ClusterMember* get_routing_table();
}
