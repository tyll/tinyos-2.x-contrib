#include "brpc.h"
interface Keylookup {
  command r_error_t connect(struct sockaddr_in6 *server);
  command r_error_t lookup ( uint8_t key [] , uint16_t key_len ) ;
  event r_error_t lookupDone ( uint8_t value [] , uint16_t value_len ) ;
  command r_error_t insert ( uint8_t key [] , uint16_t key_len , uint8_t value [] , uint16_t value_len ) ;
  event r_error_t insertDone ( uint8_t key [] , uint16_t key_len ) ;
}
