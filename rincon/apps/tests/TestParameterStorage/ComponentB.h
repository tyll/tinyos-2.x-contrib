
/**
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
#ifndef COMPONENTB_H
#define COMPONENTB_H

#define UQ_COMPONENTB_EXTENSION "componentB.ExtendMetadata"

typedef struct growing_struct_t {
  uint8_t extendedParameters[uniqueCount(UQ_COMPONENTB_EXTENSION)];
} growing_struct_t;

#endif

