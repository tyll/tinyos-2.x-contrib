/**
 * Defining the platform-independently named packet structures to be the
 * chip-specific MRF24J40 packet structures.
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */


#ifndef PLATFORM_MESSAGE_H
#define PLATFORM_MESSAGE_H

#include "mrf24.h"
#include "Serial.h"

typedef union message_header 
{
  mrf24_header_t mrf24;
  serial_header_t serial;
} message_header_t;

typedef union message_footer 
{
  mrf24_footer_t mrf24;
} message_footer_t;

typedef union message_metadata 
{
  mrf24_metadata_t mrf24;
  serial_metadata_t serial;
} message_metadata_t;

#endif
