#ifndef _CONFIG_H
#define _CONFIG_H

#include "ip.h"

#define DEV_LEN 16
struct config {
  ip6_addr_t router_addr;
  char proxy_dev[DEV_LEN];
  int channel;
};


int config_parse(const char *file, struct config *c);

#endif
