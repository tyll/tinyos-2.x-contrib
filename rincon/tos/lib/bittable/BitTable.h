
#ifndef BITTABLE_H
#define BITTABLE_H

#ifndef SIZE_OF_BIT_TABLE_IN_BYTES
#define SIZE_OF_BIT_TABLE_IN_BYTES 4  // 32 bits
#endif

#ifndef TOTAL_BIT_TABLE_ELEMENTS
#define TOTAL_BIT_TABLE_ELEMENTS SIZE_OF_BIT_TABLE_IN_BYTES * 8
#endif

typedef struct bit_table_t {
  uint8_t data[SIZE_OF_BIT_TABLE_IN_BYTES];
} bit_table_t;

#endif
