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

#ifndef NMEA_GGA_H
#define NMEA_GGA_H

#include "NmeaTimestamp.h"
#include "NmeaCoordinates.h"

enum nmea_fix_types_enum {
  FIX_INVALID = 0,
  FIX_GPS = 1,
  FIX_DGPS = 2,
  FIX_PPS = 3,
  FIX_RTK = 4,//Real Time Kinematic
  FIX_FLOAT_RTK = 5,//Float RTK
  FIX_ESTIMATED = 6,//estimated (dead reckoning) (2.3 feature)
  FIX_MANUAL = 7,//Manual input mode
  FIX_SIMULATION = 8//Simulation mode
};

enum nmea_gga_fields_enum {
  GGA_TIME = 0,
  GGA_LATITUDE = 1,
  GGA_LONGITUDE = 3,
  GGA_FIX_QUALITY = 5,
  GGA_NUM_SATELLITES = 6,
  GGA_HORZ_DIL = 7,//Horizontal dilution of position
  GGA_ALTITUDE = 8,
  GGA_GEOID_HEIGHT = 10,
  GGA_DGPS_LAST_UPDATE = 12,//time in seconds since last DGPS udpate
  GGA_DGPS_ID = 13,//DGPS station ID number
  GGA_FIELD_COUNT = 14
};

enum nmea_gga_min_field_len_enum {//minumum length required for current processing of data
  GGA_TIM_ML = 6,//Time:HHMMSS (H=hour, M=minute, S=second)
  GGA_LAT_ML = 9,//Latitude:DDMM.FF,C (D=degree, M=minute, F=fraction of minute, C=Cardinal direction)
  GGA_LON_ML = 10,//Longitude:DDDMM.FF (D=degree, M=minute, F=fraction of minute, C=Cardinal direction)
  GGA_FQ_ML = 1,//Fix Quality
  GGA_SAT_ML = 2,//Number of sattelites
  GGA_HD_ML = 7,//Horizontal dilution of position
  GGA_ALT_ML = 1,//Altitude
  GGA_GH_ML = 10,//Geiod Height
  GGA_DGPSLU_ML = 12,//time in seconds since last DGPS udpate
  GGA_DGPSID_ML = 13,//DGPS station ID number 
};

typedef struct nmea_gga_msg {
  nmea_timestamp_t time;
  nmea_latitude_t latitude;
  nmea_longitude_t longitude;
  uint8_t fixQuality;//one of the FIX_* enums
  uint8_t numSatellites;//0-12 for the current gps chip
  //horizontal dilution of position
  uint16_t altitude;//in meters to one decimal place (divide by 10 to get actual value)
  uint16_t geoidHeight;//Height of geoid (mean sea level) above WGS84 ellipsoid
  //time in seconds since last DGPS update
  //DGPS station ID number
  //checksum
} nmea_gga_msg_t;

#endif
