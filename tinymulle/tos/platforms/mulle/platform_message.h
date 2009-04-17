/**
 * @author Henrik Makitaavola
 */
#ifndef PLATFORM_MESSAGE_H
#define PLATFORM_MESSAGE_H

#include "Serial.h"
#ifdef MULLE_RF230
#include <RF230Packet.h>

typedef union message_header {
  rf230packet_header_t rf230;
  serial_header_t serial;
} message_header_t;

typedef union message_footer {
  rf230packet_footer_t rf230;
} message_footer_t;

typedef union message_metadata {
  rf230packet_metadata_t rf230;
//  serial_metadata_t serial;
} message_metadata_t;

#else

typedef union message_header {
  serial_header_t serial;
} message_header_t;

typedef union message_footer {
} message_footer_t;

typedef union message_metadata {
//  serial_metadata_t serial;
} message_metadata_t;
#endif

#endif  // PLATFORM_MESSAGE_H
