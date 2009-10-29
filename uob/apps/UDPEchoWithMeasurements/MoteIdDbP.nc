/* -*- mode:c++; indent-tabs-mode: nil -*- */
/**
 * 48 bit ID chips to USB ID and wanted TOS_NODE_ID
 */
/**
 * @author: Markus Becker (mab@comnets.uni-bremen.de)
 */

#include "MoteIdDb.h"

module MoteIdDbP {
    provides {
        interface MoteIdDb;
    }
}
implementation {

  command error_t MoteIdDb.getShortAddr(uint8_t *id, ieee154_saddr_t *addr) {
    int i;
    error_t e = EINVAL;

    for (i = 0; i < MOTE_NO; i++) {
      if (memcmp(id, id_db[i].id, ID_SIZE) == 0) {
        memcpy(addr, &(id_db[i].addr), sizeof(ieee154_saddr_t));
        return SUCCESS;
      }
    }

    return e;
  }

  command error_t MoteIdDb.getUsbId(uint8_t *id, char* usbid) {
    int i;
    error_t e = EINVAL;

    for (i = 0; i < MOTE_NO; i++) {
      if (memcmp(id, id_db[i].id, ID_SIZE) == 0) {
        memcpy(usbid, &(id_db[i].usbid), USB_ID_SIZE);
        return SUCCESS;
      }
    }

    return e;
  }
}
