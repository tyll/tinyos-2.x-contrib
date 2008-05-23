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

#ifndef NMEA_COORDINATES_H
#define NMEA_COORDINATES_H

typedef uint8_t nmea_cardinal_t;//North, South, East, West -- ONLY
enum {
  SOUTH = 0x53,//hex ASCII for 'S'
  NORTH = 0x4E,//hex ASCII for 'N'
  EAST = 0x45,//hex ASCII for 'E'
  WEST = 0x57,//hex ASCII for 'W'
};

typedef struct nmea_latitude {
  uint8_t degree; // 0-90
  uint8_t minute; // 0-60
  uint8_t remainder; // 2 decimal places as an integer (i.e. divide by 100 to get the actual remainder)
  nmea_cardinal_t direction; // NORTH or SOUTH ONLY
} nmea_latitude_t;

typedef struct nmea_longitude {
  uint8_t degree; // 0-180
  uint8_t minute; // 0-60
  uint8_t remainder; // 2 decimal places as an integer (i.e. divide by 100 to get the actual remainder)
  nmea_cardinal_t direction; // EAST or WEST ONLY
} nmea_longitude_t;

#endif
