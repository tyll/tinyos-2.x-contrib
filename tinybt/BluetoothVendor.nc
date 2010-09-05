/**
 *
 * $Rev:: 56          $:  Revision of last commit
 * $Author$:  Author of last commit
 * $Date$:  Date of last commit
 *
 **/
#include "btpackets.h"

interface BluetoothVendor
{
  /**
   * Rewrite the packet according to vendor Specifications. Currently vendor packet sets it to UART rate.
   * 
   * @param pkt packet for rewrite
   * @param opcode the opcode for rewrite
   * @return returns the vendor opcode
   */
  command error_t setPacket(gen_pkt *pkt, uint16_t opcode);
}
