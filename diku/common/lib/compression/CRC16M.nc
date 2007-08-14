module CRC16M
{
  provides interface CRC16;
}

implementation
{

#include "crc.h"

  command uint16_t CRC16.calc(uint8_t *data, uint16_t len)
  {
    // In order to be fully compliant with CRC16-CCITT, the CRC must
    // have an initial value of 0xFFFF. 
    uint16_t crc = 0xFFFFU;
    uint16_t i;

    for (i = 0; i < len; i++)
      crc = crcByte(crc, data[i]);

    return crc;
  }

}
