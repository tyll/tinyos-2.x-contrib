/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * Defining the platform-independently named packet structures to be the
 * chip-specific CC2420 packet structures.
 *
 * @author Philip Levis    2006/12/12 
 * revised John Griessen 
 * @version $Revision$ $Date$
 */


#ifndef PLATFORM_MESSAGE_H
#define PLATFORM_MESSAGE_H

#include <CC2420.h>
#include <Serial.h>

typedef union message_header {
  cc2420_header_t cc2420;
  serial_header_t serial;
} message_header_t;

typedef union TOSRadioFooter {
  cc2420_footer_t cc2420;
} message_footer_t;

typedef union TOSRadioMetadata {
  cc2420_metadata_t cc2420;
} message_metadata_t;

#endif
