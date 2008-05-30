/*
 * Copyright (c) 2008 Rincon Research Corporation
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

/**
 * TODO:Add documentation here.
 * 
 * @author Danny Park
 */

#ifndef NMEA_H
#define NMEA_H

#ifndef NMEA_MAX_LENGTH
#define NMEA_MAX_LENGTH 82
#endif

#ifndef NMEA_MAX_FIELDS
#define NMEA_MAX_FIELDS 14
#endif

enum {
  NMEA_START = 0x24,//$
  //NMEA_END1 = 0x0D,//CR
  NMEA_END = 0x0A,//LF -- NMEA 'sentence' terminator
  NMEA_DELIMETER = 0x2C,//','
  NMEA_CHECKSUM_DELIM = 0x2A,//'*'
  ASCII_PERIOD = 0x2E,//ASCII period '.'
  ASCII_ZERO = 0x30,//ASCII zero '0'
  ASCII_FIVE = 0x35,//ASCII five '5'
  ASCII_NINE = 0x39,//ASCII nine '9'
  ASCII_A = 0x41,//ASCII 'A'
  ASCII_G = 0x47,//ASCII 'G'
  ASCII_M = 0x4D,//ASCII 'M'
  ASCII_P = 0x50,//ASCII 'P'
};

typedef struct nmea_raw {
  uint8_t sentence[NMEA_MAX_LENGTH];
  uint8_t length;//length of raw string from '$' to LF inclusive
  uint8_t fields[NMEA_MAX_FIELDS];//indexes of field delimiters (',' -- commas) in string
  uint8_t fieldCount;//number of fields in current string
} nmea_raw_t;

#define char2num(c) (c - ASCII_ZERO)
#define strTo2Digit(str, start) (char2num(str[start])*10 + char2num(str[start+1]))
#define strTo3Digit(str, start) (char2num(str[start])*100 + char2num(str[start+1])*10 + char2num(str[start+2]))

#endif
