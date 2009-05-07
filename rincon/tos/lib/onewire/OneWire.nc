/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */
 
////////////////////////////////////////////////////////////////////////
// OneWire.nc
//

#include "onewire.h"

interface OneWire {

  // Initialize the pin used for the bus.
  command void initialize();

  // Send the reset sequence. Returns TRUE if any
  // 1-wire devices are present, otherwise FALSE.
  command bool sendReset();

  // Write a bit to the bus.
  command void writeBit(bool);

  // Read a bit from the bus.
  command bool readBit();

  // Write a byte to the bus.
  command void writeByte(uint8_t);

  // Read a byte from the bus.
  command uint8_t readByte();

  // Update a DOW CRC with the given bit.
  command uint8_t crcBit(uint8_t oldCrc, uint8_t byte);

  // Update a DOW CRC with the given byte.
  command uint8_t crcByte(uint8_t oldCrc, uint8_t byte);

  // Read a byte from the bus, updating a CRC.
  command uint8_t readByteCrc(uint8_t *crcp);

  // Search for devices on the bus. Each of these returns
  // TRUE if a device was found (in which case the device's
  // ROM code will be in ctx->ROM_NO), otherwise FALSE will
  // be returned.
  //
  // Obviously, you call first() to begin the search and
  // next() to continue the search.
  command bool first(ow_search_state_t *ctx);
  command bool  next(ow_search_state_t *ctx);
  // Note: AN187 supports more functionality than is
  //       implemented in these two functions. For now,
  //       all we need is the function below:

  // Enumerate all devices on bus. data[] must point
  // to space for ndata 64-bit ROM ID entries. Returns
  // the actual number of devices found on the bus (only
  // the first ndata ROM IDs will be stored, however).
  command uint8_t enumerate(uint8_t *data, uint8_t ndata);
}

// EOF OneWire.nc

