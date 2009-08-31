
/**
 * @author David Moss
 */
 
#ifndef TINYOS_STRING_H
#define TINYOS_STRING_H

#ifndef DEFAULT_STRING_LENGTH
#define DEFAULT_STRING_LENGTH 100  // max should be 135 + 2 byte length + 2 byte crc on rx
#endif

typedef struct string_t {
  uint8_t length;
  uint8_t data[DEFAULT_STRING_LENGTH];
} string_t;

#endif
