
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include "keylookup_impl.h"
#include "keylookup_server.h"
int sock;
const struct in6_addr in6addr_any = IN6ADDR_ANY_INIT;


/*
 * define the dispatchers for commands and call points for events.
 */
void handle_keylookup_lookup_impl ( void * arg , uint8_t key [] , uint16_t key_len ) {
  handle_keylookup_lookup((struct sockaddr *)arg , key , key_len );
  return;
}
void handle_keylookup_lookupdone_impl ( void * arg , uint8_t value [] , uint16_t value_len ) {
  return;
}
r_error_t signal_keylookup_lookupdone ( struct sockaddr * dest , uint8_t value [] , uint16_t value_len ) {
  uint8_t buf [1500];
  uint8_t *b = buf;
  int rv;
  pack_keylookup_lookupdone(&b, 1500 , value , value_len );
  rv = sendto(sock, buf, (b - buf), 0, dest, sizeof(struct sockaddr_in6));
  if (rv < 0) return EFAIL;
  return SUCCESS;
}
void handle_keylookup_insert_impl ( void * arg , uint8_t key [] , uint16_t key_len , uint8_t value [] , uint16_t value_len ) {
  handle_keylookup_insert((struct sockaddr *)arg , key , key_len , value , value_len );
  return;
}
void handle_keylookup_insertdone_impl ( void * arg , uint8_t key [] , uint16_t key_len ) {
  return;
}
r_error_t signal_keylookup_insertdone ( struct sockaddr * dest , uint8_t key [] , uint16_t key_len ) {
  uint8_t buf [1500];
  uint8_t *b = buf;
  int rv;
  pack_keylookup_insertdone(&b, 1500 , key , key_len );
  rv = sendto(sock, buf, (b - buf), 0, dest, sizeof(struct sockaddr_in6));
  if (rv < 0) return EFAIL;
  return SUCCESS;
}


int keylookup_server_init(int port) { 
  struct sockaddr_in6 local;
  sock = socket(PF_INET6, SOCK_DGRAM, 0);
  if (sock < 0) return -1;
  local.sin6_family = AF_INET;;
  local.sin6_port = htons(port);
  local.sin6_addr = in6addr_any;
  if (bind(sock, (struct sockaddr *)&local, sizeof(local)) < 0)
    return -1;
  return 0;
}

int keylookup_server_next() {
  uint8_t buf[1500];
  socklen_t sockaddr_len;
  struct sockaddr_in6 endpoint;
  int rcvlen = recvfrom(sock, buf, 1500, 0,
                       (struct sockaddr *)&endpoint, &sockaddr_len);
  return dispatch_keylookup((void *)&endpoint, buf, rcvlen);
}


