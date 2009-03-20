
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include "keylookup_impl.h"
#include "keylookup_server.h"
#include "keylookup_client.h"

int sock;
struct sockaddr_in6 server;
const struct in6_addr in6addr_any = IN6ADDR_ANY_INIT;


void handle_keylookup_lookup_impl ( void * arg , uint8_t key [] , uint16_t key_len ) {
}
r_error_t call_keylookup_lookup ( uint8_t key [] , uint16_t key_len ) {
  uint8_t buf [1500];
  uint8_t *b = buf;
  int rv;
  pack_keylookup_lookup(&b, 1500 , key , key_len );
  rv = sendto(sock, buf, (b - buf), 0, (struct sockaddr *)&server, sizeof(struct sockaddr_in6));
  if (rv < 0) return EFAIL;
  return SUCCESS;
}
void handle_keylookup_lookupdone_impl ( void * arg , uint8_t value [] , uint16_t value_len ) {
  handle_keylookup_lookupdone( value , value_len );
}
void handle_keylookup_insert_impl ( void * arg , uint8_t key [] , uint16_t key_len , uint8_t value [] , uint16_t value_len ) {
}
r_error_t call_keylookup_insert ( uint8_t key [] , uint16_t key_len , uint8_t value [] , uint16_t value_len ) {
  uint8_t buf [1500];
  uint8_t *b = buf;
  int rv;
  pack_keylookup_insert(&b, 1500 , key , key_len , value , value_len );
  rv = sendto(sock, buf, (b - buf), 0, (struct sockaddr *)&server, sizeof(struct sockaddr_in6));
  if (rv < 0) return EFAIL;
  return SUCCESS;
}
void handle_keylookup_insertdone_impl ( void * arg , uint8_t key [] , uint16_t key_len ) {
  handle_keylookup_insertdone( key , key_len );
}

int keylookup_client_next() {
  uint8_t buf[1500];
  socklen_t sockaddr_len;
  struct sockaddr_in6 endpoint;
  int rcvlen = recvfrom(sock, buf, 1500, 0,
                       (struct sockaddr *)&endpoint, &sockaddr_len);
  if (rcvlen == -1) return -1;
  dispatch_keylookup((void *)&endpoint, buf, rcvlen);
  return 0;
}

int keylookup_client_init(char *host, int port) {
  struct sockaddr_in6 local;
  sock = socket(PF_INET6, SOCK_DGRAM, 0);
  if (sock < 0) return -1;
  local.sin6_family = AF_INET;
  local.sin6_port = 0;
  local.sin6_addr = in6addr_any;
  if (bind(sock, (struct sockaddr *)&local, sizeof(local)) < 0)
    return -1;

  server.sin6_family = AF_INET;
  server.sin6_port = htons(port);
  if (inet_pton(AF_INET6, host, &server.sin6_addr) <= 0)
    return -1;
  return 0;
}
