
#include <usb.h>

#ifndef _H_usb_cdc_H
#define _H_usb_cdc_H

// CDC ACM class specifc requests
#define SEND_ENCAPSULATED_COMMAND	0x00
#define GET_ENCAPSULATED_RESPONSE	0x01
#define SET_LINE_CODING			0x20
#define GET_LINE_CODING			0x21
#define SET_CONTROL_LINE_STATE		0x22
#define SEND_BREAK			0x23

typedef struct {
  uint32_t rate;   // Data terminal rate (baudrate), in bits per second
  uint8_t  stopbit;  // Stop bits: 0 - 1 Stop bit, 1 - 1.5 Stop bits, 2 - 2 Stop bits
  uint8_t  parity;   // Parity: 0 - None, 1 - Odd, 2 - Even, 3 - Mark, 4 - Space
  uint8_t  databit;  // Data bits: 5, 6, 7, 8, 16
} line_coding_t;

const line_coding_t cdc_230400_8n1 __attribute__((code)) = {
  hostToUsb32(230400),  // baudrate
  0,       // stop bit:    1
  0,       // parity:              none
  8        // data bits:   8
};

const line_coding_t cdc_9600_8n1 __attribute__((code)) = {
  hostToUsb32(9600),  // baudrate
  0,       // stop bit:    1
  0,       // parity:              none
  8        // data bits:   8
};

#endif //_H_usb_cdc_H
