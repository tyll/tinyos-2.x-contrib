/***********************************************************************
 * zag.c -- Blink app for the UM232R
 *
 * Binary counting using bit-banging on 3 FT232R lines:
 *   D0 is bit 0
 *   D4 is bit 1 (it's right next to D0)
 *   D2 is bit 2 (it's right next to D4)
 *
 * Building:
 *  - Uninstall ALL existing FTDI drivers
 *  - Plug in the UM232R
 *  - Install the FTDI CDM (D2XX+VCP combined) driver per the instructions
 *  - Copy ftd2xx.h from the unpacked driver folder
 *  - Copy ftd2xx.lib from i386/ under the unpacked driver folder
 *  - Open a cygwin window
 *  - Compile with gcc -mno-cygwin -I/usr/include/w32api -Wall -O -o zag.exe zag.c ftd2xx.lib
 *  - Run ./zag with a DVM strapped to the UM232R
 */

#include <windows.h>
#include <stdio.h>

#include "ftd2xx.h"

int main(int argc, char *argv[]) {
  FT_HANDLE f;
  int       rc = 1, i;

  // open the device
  if (!FT_SUCCESS(FT_Open(0, &f))) {
    printf("FT_Open: fail\n");
    return 1;
  }
  // reset it
  if (!FT_SUCCESS(FT_ResetDevice(f))) {
    printf("FT_ResetDevice: fail\n");
    goto out;
  }
  // disable flow control
  if (!FT_SUCCESS(FT_SetFlowControl(f, FT_FLOW_NONE, 0, 0))) {
    printf("FT_SetFlowControl: fail\n");
    goto out;
  }
  // set to 9600 bps
  if (!FT_SUCCESS(FT_SetBaudRate(f, FT_BAUD_9600))) {
    printf("FT_SetBaudRate: fail\n");
    goto out;
  }
  // set to 8N1
  if (!FT_SUCCESS(FT_SetDataCharacteristics(f,
					    FT_BITS_8,
					    FT_STOP_BITS_1,
					    FT_PARITY_NONE))) {
    printf("FT_SetDataCharacteristics: fail\n");
    goto out;
  }
  // enable bit-banging mode
  if (!FT_SUCCESS(FT_SetBitMode(f, (UCHAR) 0x15, (UCHAR) 0x01))) {
    printf("FT_SetBitMode: fail\n");
    goto out;
  }
  // write some data
  for (i = 0; i < 32; i++) {
    UCHAR        v;
    DWORD        nw;
    volatile int j;

    // alternate pins D0, D4, D2 on and off
    v =  (i & 1) |         // bit 0 -> D0
         ((i & 2) << 3) |  // bit 1 -> D4
         (i & 4);          // bit 2 -> D2
    // set the pins
    if (!FT_SUCCESS(FT_Write(f, &v, 1, &nw))) {
      printf("FT_Write: fail\n");
      goto out;
    } else {
      printf("%d: %d\n", i, v); fflush(stdout);
    }
    // waste some time
    for (j = 0; j < 100000000; j++)
      ;
  }
  // success (so far)
  rc = 0;
out:
  // get out of bit-banging mode
  if (!FT_SUCCESS(FT_SetBitMode(f, (UCHAR) 0x00, (UCHAR) 0x00))) {
    printf("FT_SetBitMode: fail (exit)\n");
    rc = 1;
  }
  printf("done -- rc = %d\n", rc);
  // release the device
  FT_Close(f);
  return rc;
}

/*** EOF zag.c */

