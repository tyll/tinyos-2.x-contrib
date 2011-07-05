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

#include "Shimmer.h"

module BPCommandParserP{
   provides interface BPCommandParser;
}

implementation {
   uint8_t waiting_for_args = 0, args[MAX_COMMAND_ARG_SIZE], arg_size = 0, pending_command;

   async command void BPCommandParser.handleByte(uint8_t data) {
      if(waiting_for_args) {
         args[arg_size++] = data;
         if(!--waiting_for_args){
            signal BPCommandParser.activate(pending_command, arg_size, args);
            waiting_for_args = arg_size = 0;
         }
      }
      else {
         switch (data) {
            case INQUIRY_COMMAND:
            case GET_SAMPLING_RATE_COMMAND:
            case START_STREAMING_COMMAND:
            case STOP_STREAMING_COMMAND:
            case TOGGLE_LED_COMMAND:
            case GET_ACCEL_RANGE_COMMAND:
            case GET_CONFIG_SETUP_BYTE0_COMMAND:
            case GET_ACCEL_CALIBRATION_COMMAND:
            case GET_GYRO_CALIBRATION_COMMAND:
            case GET_MAG_CALIBRATION_COMMAND:
            case GET_GSR_RANGE_COMMAND:
            case GET_SHIMMER_VERSION_COMMAND:
               signal BPCommandParser.activate(data, 0, NULL);
               break;
            case SET_SAMPLING_RATE_COMMAND:
            case SET_ACCEL_RANGE_COMMAND:
            case SET_5V_REGULATOR_COMMAND:
            case SET_PMUX_COMMAND:
            case SET_CONFIG_SETUP_BYTE0_COMMAND:
            case SET_GSR_RANGE_COMMAND:
               waiting_for_args = 1;
               pending_command = data;
               break;
            case SET_SENSORS_COMMAND:
               waiting_for_args = 2;
               pending_command = data;
               break;
            case SET_ACCEL_CALIBRATION_COMMAND:
            case SET_GYRO_CALIBRATION_COMMAND:
            case SET_MAG_CALIBRATION_COMMAND:
               waiting_for_args = 21;
               pending_command = data;
            default:
         }
      }
   }
}
