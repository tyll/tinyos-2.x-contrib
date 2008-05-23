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
 * NmeaRawReceiveP is to receive bytes over the UART and group those bytes
 * into a raw NMEA packet.  A raw NMEA packet is just an ASCII string with
 * fields delimited by a comma (,).  The string starts with $ and is supposed
 * to end with a carriage return (CR), line feed (LF) sequence but I have
 * found that the Leadtek GPS-9546 chip on the MTS420CA sensorboard for the
 * micaZ mote only seems to send a LF.
 * 
 * See Nmea.h for a description of the raw NMEA packet (nmea_raw_t).
 * 
 * @author Danny Park
 */

#include "Nmea.h"

module NmeaRawReceiveP {
  uses {
    interface SyncUartStream;
  }
  provides {
    interface NmeaRawReceive;
  }
}
implementation {
  /*
    STATE_IDLE: nothing is happening in buffer
    STATE_RX: buffer is being filled with incoming bytes
    STATE_RX_DONE: buffer full or there has been a successful
      packet reception and buffer is waiting to be sent to
      using application.
  */
  enum state_enums {
    STATE_IDLE = 0,
    STATE_RX = 1,
    STATE_RX_DONE = 2,
  };
  uint8_t state = STATE_IDLE;
  
  nmea_raw_t buffer;
  
  
  
  command uint8_t NmeaRawReceive.maxLength() { return NMEA_MAX_LENGTH; }
  
  /**
   * SyncUartStream.receivedByte() is signalled with every byte received
   * over the UART.  This event groups the received bytes into raw NMEA
   * packets based on a start byte and end byte.  The raw packet also
   * keeps track of field delimeters (commas) to prevent the need to
   * loop through the whole packet just to find delimeters later.
   * 
   * Possible errors:
   * - If an end byte is not received before the max length is reached.
   * - If more field delimeters are received than the raw nmea packet
   *   has room to store then the fieldCount will be set to 0xFF which
   *   should never happen normally.
   * 
   * Other Implementation Comments:
   * - if(state == STATE_RX) is a separate 'if' statement (instead of
   *   an 'else if' because it needs to execute even if the packet was
   *   just started so a checksum can be calculated on the raw packet
   *   if needed.
   */
  event void SyncUartStream.receivedByte( uint8_t byte ) {
    
    if((state == STATE_IDLE) && (byte == NMEA_START)) {
      state = STATE_RX;
      buffer.length = 0;
      buffer.fieldCount = 0;
    }
    
    if(state == STATE_RX) {
      if(byte == NMEA_DELIMETER) {
        if(buffer.fieldCount <= NMEA_MAX_FIELDS) {
          buffer.fields[buffer.fieldCount++] = buffer.length;
          
        } else {
          buffer.fieldCount = 0xFF;
        }
      }
      
      buffer.sentence[buffer.length++] = byte;
      
      if(byte == NMEA_END || buffer.length >= NMEA_MAX_LENGTH) {
        signal NmeaRawReceive.received(&buffer,
            buffer.sentence[buffer.length - 1] == NMEA_END);
        
        state = STATE_IDLE;
      }
    }
  }
  
  event void SyncUartStream.droppedByte() {
  }
}
