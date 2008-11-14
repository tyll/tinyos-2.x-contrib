#ifndef _KEYLOOKUP_SERVER_H
#define _KEYLOOKUP_SERVER_H
#include <sys/socket.h>
#include "brpc.h"
void handle_keylookup_lookup ( struct sockaddr * source , uint8_t key [] , uint16_t key_len ) ;
r_error_t signal_keylookup_lookupdone ( struct sockaddr * dest , uint8_t value [] , uint16_t value_len ) ;
void handle_keylookup_insert ( struct sockaddr * source , uint8_t key [] , uint16_t key_len , uint8_t value [] , uint16_t value_len ) ;
r_error_t signal_keylookup_insertdone ( struct sockaddr * dest , uint8_t key [] , uint16_t key_len ) ;
int keylookup_server_init(int port);
int keylookup_server_next();
#endif
