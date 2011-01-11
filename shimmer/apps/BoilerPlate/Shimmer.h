/*
 * Copyright (c) 2010, Shimmer Research, Ltd.
 * All rights reserved
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:

 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of Shimmer Research, Ltd. nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author Mike Healy
 * @date   November, 2010
 */

#ifndef SHIMMER_H
#define SHIMMER_H

enum {
   SAMPLING_1000HZ   = 1,
   SAMPLING_500HZ    = 2,
   SAMPLING_250HZ    = 4,
   SAMPLING_200HZ    = 5,
   SAMPLING_166HZ    = 6,
   SAMPLING_125HZ    = 8,
   SAMPLING_100HZ    = 10,
   SAMPLING_50HZ     = 20,
   SAMPLING_10HZ     = 100,
   SAMPLING_0HZ_OFF  = 255
};

// Packet Types
enum {
   DATA_PACKET                      = 0x00,
   INQUIRY_COMMAND                  = 0x01,
   INQUIRY_RESPONSE                 = 0x02,
   GET_SAMPLING_RATE_COMMAND        = 0x03,
   SAMPLING_RATE_RESPONSE           = 0x04,
   SET_SAMPLING_RATE_COMMAND        = 0x05,
   TOGGLE_LED_COMMAND               = 0x06,
   START_STREAMING_COMMAND          = 0x07,
   SET_SENSORS_COMMAND              = 0x08,
   SET_ACCEL_SENSITIVITY_COMMAND    = 0x09,
   ACCEL_SENSITIVITY_RESPONSE       = 0x0A,
   GET_ACCEL_SENSITIVITY_COMMAND    = 0x0B,
   SET_5V_REGULATOR_COMMAND         = 0x0C,
   SET_PMUX_COMMAND                 = 0x0D,
   SET_CONFIG_SETUP_BYTE0_COMMAND   = 0x0E,
   CONFIG_SETUP_BYTE0_RESPONSE      = 0x0F,
   GET_CONFIG_SETUP_BYTE0_COMMAND   = 0x10,
   STOP_STREAMING_COMMAND           = 0x20,
   ACK_COMMAND_PROCESSED            = 0xFF
};


// Packet Sizes
enum {
   DATA_PACKET_SIZE = 25,        // biggest possibly required i.e 11 channels + 3 bytes
   RESPONSE_PACKET_SIZE = 17,    // biggest possibly required
   MAX_COMMAND_ARG_SIZE = 1      // maximum number of arguments for any command sent so shimmer    
};

// Channel contents
enum {
   X_ACCEL     = 0x00,
   Y_ACCEL     = 0x01,
   Z_ACCEL     = 0x02,
   X_GYRO      = 0x03,
   Y_GYRO      = 0x04,
   Z_GYRO      = 0x05,
   X_MAG       = 0x06,
   Y_MAG       = 0x07,
   Z_MAG       = 0x08,
   ECG_RA_LL   = 0x09,
   ECG_LA_LL   = 0x0A,
   GSR_LO      = 0x0B,
   GSR_HI      = 0x0C,
   EMG_1       = 0x0D,
   EMG_2       = 0x0E,
   ANEX_A0     = 0x0F,
   ANEX_A7     = 0x10
};

// Infomem contents;
enum {
   NV_NUM_CONFIG_BYTES = 14, 
   MAX_NUM_CHANNELS = 11 
};

enum {
   NV_SAMPLING_RATE = 0,
   NV_BUFFER_SIZE = 1,
   NV_SENSORS0 = 2,
   NV_ACCEL_SENSITIVITY = 12,
   NV_CONFIG_SETUP_BYTE0 = 13
};

//Sensor bitmap
enum {
   SENSOR_ACCEL   = 0x80,
   SENSOR_GYRO    = 0x40,
   SENSOR_MAG     = 0x20,
   SENSOR_ECG     = 0x10,
   SENSOR_EMG     = 0x08,
   SENSOR_GSR     = 0x04,
   SENSOR_ANEX_A7 = 0x02,
   SENSOR_ANEX_A0 = 0x01
};

// Config Byte0 bitmap
enum {
   CONFIG_5V_REG = 0x80,
   CONFIG_PMUX   = 0x40,
};

#endif // SHIMMER_H
