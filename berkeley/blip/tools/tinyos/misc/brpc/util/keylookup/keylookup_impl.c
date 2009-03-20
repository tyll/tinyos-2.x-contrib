#include "keylookup_client.h"
#include "keylookup_server.h"
#include "keylookup_impl.h"
r_error_t pack_keylookup_lookup ( uint8_t ** __buf , uint16_t __buf_len , uint8_t key [] , uint16_t key_len ) {
  /* [(0, 'key', 'uint8_t')] */
  uint16_t i;
  if (__buf_len < 6 + (key_len * 1) + 2) return ESHORT;
  *((uint32_t *)*__buf) = htonl(12135);
  *__buf += 4;
  *((uint16_t *)*__buf) = htons(0);
  *__buf += 2;
  *((uint16_t *)*__buf) = htons(key_len);
  *__buf += 2;
  for (i = 0; i < key_len; i++) {
  *((uint8_t *)*__buf) = key[i];
  *__buf += 1;
  }
return SUCCESS;
}
r_error_t dispatch_keylookup_lookup (void *arg, uint8_t *__buf, uint16_t __buf_len) {
  /* [(0, 'key', 'uint8_t')]*/
  uint16_t i;
  uint8_t * key ;
  uint16_t key_len;
  key_len = ntohs(*((uint16_t *)__buf));
  __buf += 2;
  key = (uint8_t*)__buf;
  __buf += (key_len * 1);
  handle_keylookup_lookup_impl(arg , key , key_len );
return SUCCESS;
}
r_error_t pack_keylookup_lookupdone ( uint8_t ** __buf , uint16_t __buf_len , uint8_t value [] , uint16_t value_len ) {
  /* [(0, 'value', 'uint8_t')] */
  uint16_t i;
  if (__buf_len < 6 + (value_len * 1) + 2) return ESHORT;
  *((uint32_t *)*__buf) = htonl(12135);
  *__buf += 4;
  *((uint16_t *)*__buf) = htons(1);
  *__buf += 2;
  *((uint16_t *)*__buf) = htons(value_len);
  *__buf += 2;
  for (i = 0; i < value_len; i++) {
  *((uint8_t *)*__buf) = value[i];
  *__buf += 1;
  }
return SUCCESS;
}
r_error_t dispatch_keylookup_lookupdone (void *arg, uint8_t *__buf, uint16_t __buf_len) {
  /* [(0, 'value', 'uint8_t')]*/
  uint16_t i;
  uint8_t * value ;
  uint16_t value_len;
  value_len = ntohs(*((uint16_t *)__buf));
  __buf += 2;
  value = (uint8_t*)__buf;
  __buf += (value_len * 1);
  handle_keylookup_lookupdone_impl(arg , value , value_len );
return SUCCESS;
}
r_error_t pack_keylookup_insert ( uint8_t ** __buf , uint16_t __buf_len , uint8_t key [] , uint16_t key_len , uint8_t value [] , uint16_t value_len ) {
  /* [(0, 'key', 'uint8_t'), (0, 'value', 'uint8_t')] */
  uint16_t i;
  if (__buf_len < 6 + (key_len * 1) + 2 + (value_len * 1) + 2) return ESHORT;
  *((uint32_t *)*__buf) = htonl(12135);
  *__buf += 4;
  *((uint16_t *)*__buf) = htons(2);
  *__buf += 2;
  *((uint16_t *)*__buf) = htons(key_len);
  *__buf += 2;
  for (i = 0; i < key_len; i++) {
  *((uint8_t *)*__buf) = key[i];
  *__buf += 1;
  }
  *((uint16_t *)*__buf) = htons(value_len);
  *__buf += 2;
  for (i = 0; i < value_len; i++) {
  *((uint8_t *)*__buf) = value[i];
  *__buf += 1;
  }
return SUCCESS;
}
r_error_t dispatch_keylookup_insert (void *arg, uint8_t *__buf, uint16_t __buf_len) {
  /* [(0, 'key', 'uint8_t'), (0, 'value', 'uint8_t')]*/
  uint16_t i;
  uint8_t * key ;
  uint16_t key_len;
  uint8_t * value ;
  uint16_t value_len;
  key_len = ntohs(*((uint16_t *)__buf));
  __buf += 2;
  key = (uint8_t*)__buf;
  __buf += (key_len * 1);
  value_len = ntohs(*((uint16_t *)__buf));
  __buf += 2;
  value = (uint8_t*)__buf;
  __buf += (value_len * 1);
  handle_keylookup_insert_impl(arg , key , key_len , value , value_len );
return SUCCESS;
}
r_error_t pack_keylookup_insertdone ( uint8_t ** __buf , uint16_t __buf_len , uint8_t key [] , uint16_t key_len ) {
  /* [(0, 'key', 'uint8_t')] */
  uint16_t i;
  if (__buf_len < 6 + (key_len * 1) + 2) return ESHORT;
  *((uint32_t *)*__buf) = htonl(12135);
  *__buf += 4;
  *((uint16_t *)*__buf) = htons(3);
  *__buf += 2;
  *((uint16_t *)*__buf) = htons(key_len);
  *__buf += 2;
  for (i = 0; i < key_len; i++) {
  *((uint8_t *)*__buf) = key[i];
  *__buf += 1;
  }
return SUCCESS;
}
r_error_t dispatch_keylookup_insertdone (void *arg, uint8_t *__buf, uint16_t __buf_len) {
  /* [(0, 'key', 'uint8_t')]*/
  uint16_t i;
  uint8_t * key ;
  uint16_t key_len;
  key_len = ntohs(*((uint16_t *)__buf));
  __buf += 2;
  key = (uint8_t*)__buf;
  __buf += (key_len * 1);
  handle_keylookup_insertdone_impl(arg , key , key_len );
return SUCCESS;
}
r_error_t dispatch_keylookup(void *arg, uint8_t *__buf, uint16_t __buf_len) {
  uint16_t f_no;
  uint32_t i_no;
  i_no = ntohl(*((uint32_t *)__buf));
  __buf += 4;
  f_no = ntohs(*((uint16_t *)__buf));
  __buf += 2;
  if (i_no != 12135) return EWRONGIFACE;
  switch (f_no) {
  case 0:  return dispatch_keylookup_lookup(arg, __buf, __buf_len - 6);
  case 1:  return dispatch_keylookup_lookupdone(arg, __buf, __buf_len - 6);
  case 2:  return dispatch_keylookup_insert(arg, __buf, __buf_len - 6);
  case 3:  return dispatch_keylookup_insertdone(arg, __buf, __buf_len - 6);
  default: return EWRONGFUNC;
  }
}
