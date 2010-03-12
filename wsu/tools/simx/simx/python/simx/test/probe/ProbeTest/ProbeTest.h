#ifndef PROBE_TEST_H
#define PROBE_TEST_H

#define NREADINGS 10

typedef nx_struct nx_varied_struct {
  nx_int8_t int8;
  nx_uint8_t uint8;
  nx_int16_t int16;
  nx_uint16_t uint16;
  nx_int32_t int32;
  nx_uint32_t uint32;
} nx_varied_struct_t;

typedef nx_union nx_varied_union {
  nx_int8_t int8;
  nx_uint8_t uint8;
  nx_int16_t int16;
  nx_uint16_t uint16;
  nx_int32_t int32;
  nx_uint32_t uint32;
} nx_varied_union_t;

#endif
