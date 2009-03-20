
#include <stdlib.h>
#include <stdio.h>
#include <sys/socket.h>
#include "brpc.h"
#include "keylookup_client.h"

void handle_keylookup_lookupdone ( uint8_t value [] , uint16_t value_len ) {
  printf("lookupDone: v: %s\n", value);
}
void handle_keylookup_insertdone ( uint8_t key [] , uint16_t key_len ) {
  printf("insertDone: k: %s\n", key);
}

int main(int argc, char **argv) {
  char *k1 = "foo";
  char *v1 = "bar";
  if (argc != 3) return 1;

  keylookup_client_init(argv[1], atoi(argv[2]));

  call_keylookup_lookup(k1, strlen(k1)+1);
  call_keylookup_insert(k1, strlen(k1)+1, v1, strlen(v1)+1);

  keylookup_client_next();
  keylookup_client_next();
  return 0;
    
}
