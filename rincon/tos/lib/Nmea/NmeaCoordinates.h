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

typedef struct nmea_coordinate {

  /** Stored as an integer value */
  uint8_t degree;
  
  /**
   * Measured from 0-60* minutes with 3 decimal places of accuracy
   * stored as an integer (divide by 1000 to get actual value)
   * *Actual values will range from 0 to 59999.
   */
  uint16_t minute;
  
  /** NORTH, SOUTH, EAST, or WEST (from the above enums) */
  nmea_cardinal_t direction;

} nmea_coordinate_t;

/** degree should be from 0-90, direction should only be NORTH or SOUTH */
typedef nmea_coordinate_t nmea_latitude_t;

/** degree should be from 0-180, direction should only be EAST or WEST */
typedef nmea_coordinate_t nmea_longitude_t;

#endif
