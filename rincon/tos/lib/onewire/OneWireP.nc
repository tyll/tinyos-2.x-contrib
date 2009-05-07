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
// OneWireP.nc
//
// Note on Interrupt control
//
//   Experience confirms what the datasheet says: 1wire
//   bus timing is very strict. If interrupts are enabled
//   during 1wire bus transactions, you'll get an overall
//   error rate of 2-10% (which is awful). By disabling
//   interrupts in critical sections, reliability is greatly
//   enhanced: measured BER < 4e-8, PER < 6e-6.
//
//   Interrupts are never disabled longer than (approximately)
//   max(T_MSP__1WIRE [67], T_SLOT__1WIRE [75]) microseconds.
//
// Note on Timing
//
//   There's not really a good way to do microsecond-level
//   timing in TinyOS. So each platform has to define an
//   *inline* assembler timing loop in this file.
//
//   Note that the specifics of this loop also depend on the
//   clock speed at runtime; i.e., if you change the mote's
//   clock speed to something other than what the timing loop
//   is written for, 1-wire will almost certainly break!
//
//   Since the loop is inlined, you probably don't want to
//   write clock-speed sensitive loops (which will probably
//   throw the timing off, anyway). If you add the __noinline__
//   attribute, be *very* sure you account for all the call
//   and return overhead, plus any additional processing you
//   add -- you've only got a few microseconds (tens of clocks)
//   leeway. 1-wire is pretty darn crusty in this regard.
//
//   One solution is to use something like the DS2480B 1-wire
//   bus controller (which handles all the timing stuff). Of
//   course, to use the '2480, you have to burn a UART to talk
//   to it. This sorta defeats the purpose of 1-wire :-)
//

generic module OneWireP() {
  provides {
    interface Init;
    interface OneWire;
  }

  uses interface GeneralIO as Pin;
}

implementation {

#if defined(PLATFORM_MICA2) || defined(PLATFORM_MICAZ)
#define CLOCK_MHZ 7.3728
#elif defined(__MSP430__)
#include "Msp430DcoSpec.h"
#define CLOCK_MHZ ((TARGET_DCO_KHZ) * 1024e-6)
#endif

#include "usleep.h"

#ifdef __AVR__
#define FULL_SEQUENCE__1WIRE
#endif

#ifdef FULL_SEQUENCE__1WIRE
//#warning "1-wire using full GPIO sequence"
/*** XXX this is CPU- and clock-speed dependent!!! */
// Compensate for TOS
#define ofs__1wire 5
#define usleep__1wire(n) usleep(((n)<=ofs__1wire)?1:((n)-ofs__1wire))
#else
//#warning "1-wire using tricky GPIO sequence"
#define usleep__1wire(n) usleep(n)
#endif

  command void OneWire.initialize() {
    call Pin.makeOutput();
#ifdef FULL_SEQUENCE__1WIRE
    call Pin.set();
#else
    call Pin.clr();
#endif
    call Pin.makeInput();
#ifdef __AVR__
    // Disable pullup
    call Pin.clr();
#endif
    // NOTE: All APIs should leave the pin high (input
    //       state) when finished so devices will go
    //       to sleep and so no current will be drawn
    //       by the pullup!
  }

  command error_t Init.init() {
    call OneWire.initialize();
    return SUCCESS;
  }

  // Set pin state
#ifdef FULL_SEQUENCE__1WIRE
  void setLow()   { call Pin.makeOutput(); call Pin.clr(); }
  void setHigh()  { call Pin.set(); call Pin.makeInput(); }
#else
  void setLow()   { call Pin.makeOutput(); }
  void setHigh()  { call Pin.makeInput(); }
#endif

#define T_RSTL__1WIRE 560 // 480-640us
#define T_RSTH__1WIRE 560 // >=480us
#define T_MSP__1WIRE   67 // 60-75us

  // Issue the reset sequence on the bus. Returns
  // TRUE if any devices are present, otherwise returns
  // FALSE.
  command bool OneWire.sendReset() {
    bool ret;

    // go low for t_RSTL (interrupts enabled)
    setLow();
    usleep__1wire(T_RSTL__1WIRE);

    atomic {
      // let pullup take over
      setHigh();
      // sample after t_MSP
      usleep__1wire(T_MSP__1WIRE);
      ret = call Pin.get();
    }

    // fill out the frame
    //  -- per page 8 (480us min)
    //  -- includes t_REC
    usleep__1wire(T_RSTH__1WIRE - T_MSP__1WIRE);

    return ! ret;
  }

//#define T_W1L__1WIRE  10 // 5-15us
#define T_W1L__1WIRE  8 // 5-15us
#define T_SLOT__1WIRE 75 // 60-120us

  // Write a 1 onto the bus
  void writeOne() {
    atomic {
      // go low for t_W1L
      setLow();
      usleep__1wire(T_W1L__1WIRE);
      //call Pin.set();
      setHigh();
    }
    // burn the rest of the 65us t_SLOT
    usleep__1wire(T_SLOT__1WIRE - T_W1L__1WIRE);
  }

#define T_W0L__1WIRE 60 // 60-120us

  // Write a 0 onto the bus
  void writeZero() {
    atomic {
      // go low for t_W0L
      setLow();
      usleep__1wire(T_W0L__1WIRE);
      setHigh();
    }
    // burn the rest of the slot -- MUST
    // be 5us minimum!!
    usleep__1wire(T_SLOT__1WIRE - T_W0L__1WIRE);
  }

#define T_RL__1WIRE   7 // 5-15us
#define T_MSR__1WIRE 11 // T_RL__1WIRE..15us

  // Write a bit onto the bus
  command void OneWire.writeBit(bool bit) {
    if (bit)
      writeOne();
    else
      writeZero();
  }

  // Read a bit from the bus
  command bool OneWire.readBit() {
    bool ret;

    atomic {
      // go low for t_RL
      setLow();
      usleep__1wire(T_RL__1WIRE);
      // go high and wait for sampling window
      setHigh();
      usleep__1wire(T_MSR__1WIRE - T_RL__1WIRE);
      // sample
      ret = call Pin.get();
    }
    // burn the rest of the slot -- MUST
    // be 5us minimum!!
    usleep__1wire(T_SLOT__1WIRE - T_MSR__1WIRE);

    return ret;
  }

  // Write a byte onto the bus
  bool first = TRUE;
  command void OneWire.writeByte(uint8_t data) {
    int i;
    // 1-wire is LSB-first
    for (i = 0; i < 8; i++) {
      call OneWire.writeBit(data & 1);
      data >>= 1;
    }
  }

  // Read a byte from the bus
  command uint8_t OneWire.readByte() {
    uint8_t ret = 0;
    int i;
    
    // 1-wire is LSB-first
    for (i = 0; i < 8; i++) {
      ret >>= 1;
      if (call OneWire.readBit())
	ret |= 0x80;
    }
    return ret;
  }

  // Update DOW CRC from bit
  command uint8_t OneWire.crcBit(uint8_t crc, bool bit) {
    uint8_t fb;

    if ((fb = ((crc & 0x80) ? 1 : 0) ^ bit))
      crc ^= 0x18;
    crc <<= 1;
    crc  |= fb;
    return crc;
  }

  // Update DOW CRC from byte
  command uint8_t OneWire.crcByte(uint8_t crc, uint8_t byte) {
    uint8_t fb;
    int     i;

    for (i = 0; i < 8; i++) {
      fb   = ((crc & 0x80) ? 1 : 0) ^ (byte & 1);
      crc ^= fb ? 0x18 : 0x00;
      crc  = (crc << 1) | fb;
      byte = byte >> 1;
    }
    return crc;
  }

  // Read a byte from the bus, updating a DOW CRC in the process
  command uint8_t OneWire.readByteCrc(uint8_t *crcp) {
    uint8_t ret = 0, crc = *crcp, fb;
    int i;
    
    // 1-wire is LSB-first
    for (i = 0; i < 8; i++) {
      ret >>= 1;
      fb    = (crc & 0x80) ? 1 : 0;
      if (call OneWire.readBit()) {
	ret |= 0x80;
	fb  ^= 1;
      }
      if (fb)
	crc ^= 0x18;
      crc = (crc << 1) | fb;
    }
    *crcp = crc;
    return ret;
  }

  ////////////////////////////////////////////////////////////////////////
  // Start of AN187 code

  // Internal search helper
  bool ow_search(ow_search_state_t *ctx) {
    int id_bit_number;
    int last_zero, rom_byte_number, search_result;
    int id_bit, cmp_id_bit;
    unsigned char rom_byte_mask, search_direction;

    // initialize for search
    id_bit_number   = 1;
    last_zero       = 0;
    rom_byte_number = 0;
    rom_byte_mask   = 1;
    search_result   = FALSE;
    ctx->crc8       = 0;

    // if the last call was not the last one
    if (!ctx->LastDeviceFlag) {
      // 1-Wire reset
      if (! call OneWire.sendReset()) {
	// reset the search
	ctx->LastDiscrepancy       = 0;
	ctx->LastDeviceFlag        = FALSE;
	ctx->LastFamilyDiscrepancy = 0;
	return FALSE;
      }

      // issue the search command
      call OneWire.writeByte(0xf0);

      // loop to do the search
      do {
	// read a bit and its complement
	id_bit     = call OneWire.readBit();
	cmp_id_bit = call OneWire.readBit();

	// check for no devices on 1-wire
	if ((id_bit == 1) && (cmp_id_bit == 1))
	  break;
	// all devices coupled have 0 or 1
	if (id_bit != cmp_id_bit) {
	  search_direction = id_bit; // bit write value for search
	} else {
	  // if this discrepancy if before the Last Discrepancy
	  // on a previous next then pick the same as last time
	  if (id_bit_number < ctx->LastDiscrepancy)
	    search_direction = ((ctx->ROM_NO[rom_byte_number] & 
				 rom_byte_mask) > 0);
	  else
	    // if equal to last pick 1, if not then pick 0
	    search_direction = (id_bit_number == ctx->LastDiscrepancy);
	  // if 0 was picked then record its position in LastZero
	  if (search_direction == 0) {
	    last_zero = id_bit_number;
	    // check for Last discrepancy in family
	    if (last_zero < 9)
	      ctx->LastFamilyDiscrepancy = last_zero;
	  }
	}

	// set or clear the bit in the ROM byte rom_byte_number
	// with mask rom_byte_mask
	if (search_direction == 1)
	  ctx->ROM_NO[rom_byte_number] |= rom_byte_mask;
	else
	  ctx->ROM_NO[rom_byte_number] &= ~rom_byte_mask;

	// serial number search direction write bit
	call OneWire.writeBit(search_direction);

	// increment the byte counter id_bit_number
	// and shift the mask rom_byte_mask
	id_bit_number++;
	rom_byte_mask <<= 1;
	// if the mask is 0 then go to new SerialNum
	// byte rom_byte_number and reset mask
	if (rom_byte_mask == 0) {
	  ctx->crc8 = call OneWire.crcByte(ctx->crc8,
					   ctx->ROM_NO[rom_byte_number]);
	  rom_byte_number++;
	  rom_byte_mask = 1;
	}
      } while(rom_byte_number < 8); // loop until through all ROM bytes 0-7

      // if the search was successful then
      if (!((id_bit_number < 65) || (ctx->crc8 != 0))) {
	// search successful so set LastDiscrepancy,
	// LastDeviceFlag,search_result
	ctx->LastDiscrepancy = last_zero;
	// check for last device
	if (ctx->LastDiscrepancy == 0)
	  ctx->LastDeviceFlag = TRUE;
	search_result = TRUE;
      }
    }
    // if no device found then reset counters
    // so next 'search' will be like a first
    if (!search_result || !ctx->ROM_NO[0]) {
      ctx->LastDiscrepancy       = 0;
      ctx->LastDeviceFlag        = FALSE;
      ctx->LastFamilyDiscrepancy = 0;
      search_result              = FALSE;
    }
    return search_result;
  }

  //--------------------------------------------------------------------------
  // Find the 'first' devices on the 1-Wire bus
  // Return TRUE : device found, ROM number in ROM_NO buffer
  // FALSE : no device present
  //
  command bool OneWire.first(ow_search_state_t *ctx) {
    // reset the search state
    ctx->LastDiscrepancy       = 0;
    ctx->LastDeviceFlag        = FALSE;
    ctx->LastFamilyDiscrepancy = 0;
    return ow_search(ctx);
  }

  //--------------------------------------------------------------------------
  // Find the 'next' devices on the 1-Wire bus
  // Return TRUE : device found, ROM number in ROM_NO buffer
  // FALSE : device not found, end of search
  //
  command bool OneWire.next(ow_search_state_t *ctx) {
    return ow_search(ctx);
  }

  ////////////////////////////////////////////////////////////////////////
  // End of AN187 code
  ////////////////////////////////////////////////////////////////////////

  // Enumerate all devices on bus. data[] must point to space
  // for ndata 64-bit entries. Returns actual number of devices
  // found on bus.
  command uint8_t OneWire.enumerate(uint8_t *data, uint8_t ndata) {
    ow_search_state_t _ctx, *ctx = &_ctx;
    uint8_t           ret = 0;

    if (! call OneWire.first(ctx))
      return ret;
    do {
      if (++ret <= ndata) {
	memcpy(data, ctx->ROM_NO, 8);
	data += 8;
      }
    } while (call OneWire.next(ctx));
    return ret;
  }
}

// EOF OneWireP.nc

