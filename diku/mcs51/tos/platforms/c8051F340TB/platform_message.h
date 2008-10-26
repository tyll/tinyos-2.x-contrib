
#ifndef PLATFORM_MESSAGE_H
#define PLATFORM_MESSAGE_H

typedef union message_header {
  uint8_t serial;
  //  serial_header_t serial;
} message_header_t;

typedef union TOSRadioFooter {
  uint8_t serial;
} message_footer_t;

typedef union TOSRadioMetadata {
  uint8_t serial;
} message_metadata_t;

#endif
