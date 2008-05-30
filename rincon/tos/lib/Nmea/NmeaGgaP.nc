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
 * The method of character to decimal/integer conversion is very
 * rudimentary and needs to be redone.
 * 
 * @author Danny Park
 */

#include "NmeaGga.h"
#include "Nmea.h"

module NmeaGgaP {
  provides interface NmeaPacket<nmea_gga_msg_t>;
}
implementation {
  
  bool isGga(nmea_raw_t* rawPacket);
  bool isValidGga(nmea_raw_t* rawPacket);
  void setTimestamp(nmea_raw_t* rawPacket, nmea_timestamp_t* time);
  void setLatitude(nmea_raw_t* rawPacket, nmea_latitude_t *lat);
  void setLongitude(nmea_raw_t* rawPacket, nmea_longitude_t* lon);
  void setFixQuality(nmea_raw_t* rawPacket, uint8_t* fq);
  void setNumSatellites(nmea_raw_t* rawPacket, uint8_t* numSat);
  void setAltitude(nmea_raw_t* rawPacket, uint16_t* alt);
  //void setAltitude(nmea_raw_t* rawPacket, uint16_t* alt, nmea_gga_msg_t* out);
  void setGeoidHeight(nmea_raw_t* rawPacket, uint16_t* gh);
  uint16_t AsciiDecToInt(uint8_t asciiStr[], uint8_t start,
      uint8_t end, uint8_t decPlaces);
  
  command error_t NmeaPacket.process(nmea_raw_t* rawPacket, nmea_gga_msg_t* outPacket) {
    if(isValidGga(rawPacket)) {
      setTimestamp(rawPacket, &(outPacket->time));
      setLatitude(rawPacket, &(outPacket->latitude));
      setLongitude(rawPacket, &(outPacket->longitude));
      setFixQuality(rawPacket, &(outPacket->fixQuality));
      setNumSatellites(rawPacket, &(outPacket->numSatellites));
      //setHorizontalDilution(rawPacket, outPacket->%%%%);
      setAltitude(rawPacket, &(outPacket->altitude));
      //setAltitude(rawPacket, &(outPacket->altitude), outPacket);
      //outPacket->altitude = 0xFFFF;
      setGeoidHeight(rawPacket, &(outPacket->geoidHeight));
      //outPacket->geiodHeight = 0xFFFF;
      //setDGPSLastUpdate(...);
      //setDGPSID(...);
      //checksum
      return SUCCESS;
    }
    else {
      //raw packet error
      (outPacket->time).hour = 0xFF;
      (outPacket->time).minute = 0xFF;
      (outPacket->time).second = 0xFF;
      (outPacket->latitude).degree = 0xFF;
      (outPacket->latitude).minute = 0xFFFF;
      (outPacket->latitude).direction = 0xFF;
      (outPacket->longitude).degree = 0xFF;
      (outPacket->longitude).minute = 0xFFFF;
      (outPacket->longitude).direction = 0xFF;
      outPacket->fixQuality = FIX_INVALID;
      outPacket->numSatellites = 0x00;
      //horizontal dilution of position
      outPacket->altitude = 0xFFFF;
      outPacket->geoidHeight = 0xFFFF;
      //time in seconds since last DGPS update
      //DGPS station ID number
      //checksum
      return FAIL;
    }
  }
  
  bool isGga(nmea_raw_t* rawPacket) {
    return rawPacket->sentence[1] == ASCII_G &&
      rawPacket->sentence[2] == ASCII_P &&
      rawPacket->sentence[3] == ASCII_G &&
      rawPacket->sentence[4] == ASCII_G &&
      rawPacket->sentence[5] == ASCII_A;
  }
  
  bool isValidGga(nmea_raw_t* rawPacket) {
    //possibly add checksum/completeness tests (start with '$', end with LF)
    return isGga(rawPacket);// && rawPacket->fieldCount == GGA_FIELD_COUNT;
  }
  
  void setTimestamp(nmea_raw_t* rawPacket, nmea_timestamp_t* time) {
    uint8_t fieldStart = rawPacket->fields[GGA_TIME] + 1;
    if(rawPacket->fieldCount > GGA_TIME &&
      (rawPacket->fields[GGA_TIME + 1] - fieldStart) >= GGA_TIM_ML) {
      time->hour = strTo2Digit(rawPacket->sentence, (fieldStart));
      time->minute = strTo2Digit(rawPacket->sentence, (fieldStart+2));
      time->second = strTo2Digit(rawPacket->sentence, (fieldStart+4));
    }
    else {//error
      time->hour = 0xFF;
      time->minute = 0xFF;
      time->second = 0xFF;
    }
  }
  
  void setLatitude(nmea_raw_t* rawPacket, nmea_latitude_t *lat) {
    uint8_t fieldStart = rawPacket->fields[GGA_LATITUDE] + 1;
    if(rawPacket->fieldCount > GGA_LATITUDE &&
      (rawPacket->fields[GGA_LATITUDE + 2] - fieldStart) >= GGA_LAT_ML) {
      lat->degree = strTo2Digit(rawPacket->sentence, (fieldStart));
      lat->minute = strTo2Digit(rawPacket->sentence, (fieldStart+2)) * 1000
          + strTo3Digit(rawPacket->sentence, (fieldStart+5));//2 degree digits, 2 minute digits, 1 decimal point(.)
      lat->direction = rawPacket->sentence[rawPacket->fields[GGA_LATITUDE + 1] + 1];
    }
    else {//error
      lat->degree = 0xFF;
      lat->minute = 0xFFFF;
      lat->direction = 0xFF;
    }
  }
  
  void setLongitude(nmea_raw_t* rawPacket, nmea_longitude_t* lon) {
    uint8_t fieldStart = rawPacket->fields[GGA_LONGITUDE] + 1;
    if(rawPacket->fieldCount > GGA_LONGITUDE &&
      (rawPacket->fields[GGA_LONGITUDE + 2] - fieldStart) >= GGA_LON_ML) {
      lon->degree = strTo3Digit(rawPacket->sentence, fieldStart);
      lon->minute = strTo2Digit(rawPacket->sentence, (fieldStart+3)) * 1000
          + strTo3Digit(rawPacket->sentence, (fieldStart+6));//3 degree digits, 2 minute digits, 1 decimal point(.)
      lon->direction = rawPacket->sentence[rawPacket->fields[GGA_LONGITUDE + 1] + 1];
    }
    else {//error
      lon->degree = 0xFF;
      lon->minute = 0xFFFF;
      lon->direction = 0xFF;
    }
  }
  
  void setFixQuality(nmea_raw_t* rawPacket, uint8_t* fq) {
    uint8_t fieldStart = rawPacket->fields[GGA_FIX_QUALITY] + 1;
    if(rawPacket->fieldCount > GGA_FIX_QUALITY &&
      (rawPacket->fields[GGA_FIX_QUALITY + 1] - fieldStart) == GGA_FQ_ML) {
      *fq = char2num(rawPacket->sentence[fieldStart]);
    }
    else {//error
      *fq = FIX_INVALID;
    }
  }
  
  void setNumSatellites(nmea_raw_t* rawPacket, uint8_t* numSat) {
    uint8_t fieldStart = rawPacket->fields[GGA_NUM_SATELLITES] + 1;
    if(rawPacket->fieldCount > GGA_NUM_SATELLITES &&
      (rawPacket->fields[GGA_NUM_SATELLITES + 1] - fieldStart) == GGA_SAT_ML) {
      *numSat = strTo2Digit(rawPacket->sentence, fieldStart);
    }
    else {//error
      *numSat = 0xFF;
    }
  }
  
  void setAltitude(nmea_raw_t* rawPacket, uint16_t* alt) {
    uint8_t fieldStart = rawPacket->fields[GGA_ALTITUDE] + 1;
    uint8_t fieldEnd = rawPacket->fields[GGA_ALTITUDE + 1];
    
    if((rawPacket->fieldCount > GGA_ALTITUDE)
        && ((fieldEnd - fieldStart) >= GGA_ALT_ML)
        && (rawPacket->sentence[fieldEnd + 1] == ASCII_M)) {
      
      *alt = AsciiDecToInt(rawPacket->sentence, fieldStart, fieldEnd, 1);
      
    } else if(fieldEnd == fieldStart) {
      *alt = 0;
      
    } else {//error
      *alt = 0xFFFF;
    }
  }
  
  void setGeoidHeight(nmea_raw_t* rawPacket, uint16_t* gh) {
    uint8_t fieldStart = rawPacket->fields[GGA_GEOID_HEIGHT] + 1;
    uint8_t fieldEnd = rawPacket->fields[GGA_GEOID_HEIGHT + 1];
    
    if((rawPacket->fieldCount > GGA_GEOID_HEIGHT)
        && ((fieldEnd - fieldStart) >= GGA_GH_ML)
        && (rawPacket->sentence[fieldEnd + 1] == ASCII_M)) {
      
      *gh = AsciiDecToInt(rawPacket->sentence, fieldStart, fieldEnd, 1);
      
    } else if(fieldEnd == fieldStart) {
      *gh = 0;
      
    } else {//error
      *gh = 0xFFFF;
    }
  }
  
  uint16_t AsciiDecToInt(uint8_t asciiStr[], uint8_t start,
      uint8_t end, uint8_t decPlaces) {
    
    uint16_t number;
    uint8_t curChar, counter, curDecPlaces;
    bool pastDecimal;
    
    number = 0;
    curDecPlaces = 0;
    pastDecimal = FALSE;
    
    for(counter = start; counter < end; counter++) {
      curChar = asciiStr[counter];
      
      if(curChar >= ASCII_ZERO && curChar <= ASCII_NINE) {
        if((number < 6553)
            || ((number == 6553) && (curChar <= ASCII_FIVE))) {
          number = (number * 10) + (curChar - ASCII_ZERO);
          
        } else {
          /** error: number out of bounds, 16 bit number max of 65535==0xFFFF */
          number = 0xFFFF;
        }
        
        if(pastDecimal) {
          curDecPlaces++;
          
          if(curDecPlaces == decPlaces) {
            /** break out of the loop, the number asked for is done */
            break;
            
          } else if(curDecPlaces > decPlaces) {
            /** error: more decimal places were calculated than asked for */
            number = 0xFFFF;
            break;
          }
        }
      } else if(curChar == ASCII_PERIOD) {
        if(decPlaces > 0) {
          pastDecimal = TRUE;
          
        } else {
          /** break out of the loop, the number asked for is done */
          break;
        }
        
      } else {
        /** error: invalide character */
        number = 0xFFFF;
        break;
      }
      
      
    }
    
    /** Make sure number is not off by any factors of 10 */
    while((number < 6553) && (curDecPlaces < decPlaces)) {
      curDecPlaces++;
      number *= 10;
    }
    
    if(curDecPlaces != decPlaces) {
      number = 0xFFFF;
    }
    
    return number;
  }
}
