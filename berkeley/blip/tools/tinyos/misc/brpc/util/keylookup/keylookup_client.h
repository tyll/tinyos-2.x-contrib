#ifndef _KEYLOOKUP_CLIENT_H
#define _KEYLOOKUP_CLIENT_H
#include <sys/socket.h>
#include "brpc.h"
r_error_t call_keylookup_lookup ( uint8_t key [] , uint16_t key_len ) ;
void handle_keylookup_lookupdone ( uint8_t value [] , uint16_t value_len ) ;
r_error_t call_keylookup_insert ( uint8_t key [] , uint16_t key_len , uint8_t value [] , uint16_t value_len ) ;
void handle_keylookup_insertdone ( uint8_t key [] , uint16_t key_len ) ;
int keylookup_client_init(char *svr, int port);
int keylookup_client_next();
#endif
