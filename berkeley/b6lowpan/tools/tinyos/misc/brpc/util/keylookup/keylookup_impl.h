#ifndef KEYLOOKUP_IMPL_H
#define KEYLOOKUP_IMPL_H
#include "brpc.h"
#define KEYLOOKUP_NUMBER 12135
r_error_t pack_keylookup_lookup ( uint8_t ** __buf , uint16_t __buf_len , uint8_t key [] , uint16_t key_len ) ;
r_error_t dispatch_keylookup(void *arg, uint8_t *__buf, uint16_t __buf_len);
void handle_keylookup_lookup_impl ( void * arg , uint8_t key [] , uint16_t key_len ) ;
r_error_t pack_keylookup_lookupdone ( uint8_t ** __buf , uint16_t __buf_len , uint8_t value [] , uint16_t value_len ) ;
r_error_t dispatch_keylookup(void *arg, uint8_t *__buf, uint16_t __buf_len);
void handle_keylookup_lookupdone_impl ( void * arg , uint8_t value [] , uint16_t value_len ) ;
r_error_t pack_keylookup_insert ( uint8_t ** __buf , uint16_t __buf_len , uint8_t key [] , uint16_t key_len , uint8_t value [] , uint16_t value_len ) ;
r_error_t dispatch_keylookup(void *arg, uint8_t *__buf, uint16_t __buf_len);
void handle_keylookup_insert_impl ( void * arg , uint8_t key [] , uint16_t key_len , uint8_t value [] , uint16_t value_len ) ;
r_error_t pack_keylookup_insertdone ( uint8_t ** __buf , uint16_t __buf_len , uint8_t key [] , uint16_t key_len ) ;
r_error_t dispatch_keylookup(void *arg, uint8_t *__buf, uint16_t __buf_len);
void handle_keylookup_insertdone_impl ( void * arg , uint8_t key [] , uint16_t key_len ) ;
#define KEYLOOKUP_NFUNCS 4
#endif
