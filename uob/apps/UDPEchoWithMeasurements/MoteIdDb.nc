/* -*- mode:c++; indent-tabs-mode: nil -*- */
/**
 * 48 bit ID chips to USB ID and wanted TOS_NODE_ID
 */
/**
 * @author: Markus Becker (mab@comnets.uni-bremen.de)
 */

#include <6lowpan.h>

interface MoteIdDb  {
  command error_t getShortAddr(uint8_t *id, ieee154_saddr_t *addr);
  command error_t getUsbId(uint8_t *id, char* usbid);
}
