#ifndef __HARDWARE_H__
#define __HARDWARE_H__
/* Include our CPU definitions */
#include <hcs08hardware.h>
// The baudrate to be used by the serial ports
enum {
  PLATFORM_BAUDRATE = 38400,
  PLATFORM_BYTETIME = 208
};

#endif // _H_hardware_h

