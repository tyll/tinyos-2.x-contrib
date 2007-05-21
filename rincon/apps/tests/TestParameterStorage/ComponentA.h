
/**
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
#ifndef COMPONENTA_H
#define COMPONENTA_H

#define UQ_COMPONENTA_EXTENSION "componentA.ExtendMetadata"

typedef nx_struct cc5000_metadata_t {
  nx_uint8_t tx_power;
  nx_uint8_t rssi;
  nx_uint8_t lqi;
  nx_bool crc;
  nx_bool ack;
  nx_uint16_t time;

  nx_uint8_t extendedParameters[uniqueCount(UQ_COMPONENTA_EXTENSION)];
} cc5000_metadata_t;

#endif

