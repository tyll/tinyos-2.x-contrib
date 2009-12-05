
#ifndef PLATFORM_MESSAGE_H
#define PLATFORM_MESSAGE_H

#include "Blaze.h"
#include "Serial.h"

typedef union message_header {
  blaze_header_t blazeHeader;
  serial_header_t serial;
} message_header_t;

typedef union TOSRadioFooter {
  blaze_footer_t blazeFooter;
} message_footer_t;

typedef union TOSRadioMetadata {
  blaze_metadata_t blazeMetadata;
} message_metadata_t;

#endif
