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
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

 
/*
 * Flash Information 
 * Internal AVR EEPROM
 * 4096 bytes total
 * Because this is an EEPROM, we do not need to erase before write.
 * However, because we're abstracting it to act the same as other
 * memories, DirectFlash will allow you to explicitly erase segments of the 
 * EEPROM.  This will write 0xFF's to all the bytes in the segment.
 * This is important because some apps expect to read 0xFF's to know
 * if that area of memory is available to safely write.
 * 
 * The erase unit size (segment length) below was simply chosen as
 * a multiple of 4096.
 * 
 * @author David Moss
 */ 

#ifndef FLASHSETTINGS_H
#define FLASHSETTINGS_H

enum {
  AVR_WRITE_UNIT_LENGTH = 1,
  AVR_ERASE_UNIT_LENGTH = 0x80,
  AVR_WRITE_UNITS = 4096,
  AVR_ERASE_UNITS = 32,
  AVR_FILL_BYTE = 0xFF,
  
  AVR_WRITE_UNIT_LENGTH_LOG2 = 0,
  AVR_ERASE_UNIT_LENGTH_LOG2 = 7,
}; 

#endif

