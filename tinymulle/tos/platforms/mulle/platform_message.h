/**
 * @author Henrik Makitaavola
 */
#ifndef PLATFORM_MESSAGE_H
#define PLATFORM_MESSAGE_H

#include "Serial.h"

typedef union message_header {
  serial_header_t serial;
} message_header_t;

typedef union message_footer {
} message_footer_t;

typedef union message_metadata {
//  serial_metadata_t serial;
} message_metadata_t;

#endif  // PLATFORM_MESSAGE_H
