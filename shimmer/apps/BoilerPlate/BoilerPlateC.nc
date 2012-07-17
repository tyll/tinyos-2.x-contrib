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


/***********************************************************************************

   Data Packet Format:
          Packet Type | TimeStamp | chan1 | chan2 | ... | chanX 
   Byte:       0      |    1-2    |  3-4  |  5-6  | ... | chanX

   Inquiry Response Packet Format:
          Packet Type | ADC Sampling rate | Accel Range | Config Byte 0 |Num Chans | Buf size | Chan1 | Chan2 | ... | ChanX
   Byte:       0      |         1         |       2     |       3       |    4     |     5    |   6   |   7   | ... |   x

***********************************************************************************/
#include "Timer.h"
#include "Mma_Accel.h"
#include "RovingNetworks.h"
#include "Gsr.h"
#include "Shimmer.h"

module BoilerPlateC {
   uses {
      interface Boot;
      interface Init as BluetoothInit;
      interface Init as AccelInit;
      interface Init as GyroInit;
      interface Init as MagInit;
      interface Init as StrainInit;
      interface Init as DigitalHeartInit;
      interface Init as GsrInit;
      interface Init as SampleTimerInit;
      interface GyroBoard;
      interface Magnetometer;
      interface StrainGauge;
      interface DigitalHeartRate;
      interface StdControl as GyroStdControl;
      interface Mma_Accel as Accel;
      interface Gsr;
      interface Leds;
      interface shimmerAnalogSetup;
      interface Timer<TMilli> as SetupTimer;
      interface Timer<TMilli> as ActivityTimer;
      interface Alarm<TMilli, uint16_t> as SampleTimer;
      interface LocalTime<T32khz>;
      interface StdControl as BTStdControl;
      interface Bluetooth;
      interface Msp430DmaChannel as DMA0;
      interface BPCommandParser;
      interface InternalFlash;

#ifdef USE_8MHZ_CRYSTAL
      interface Init as FastClockInit;
      interface FastClock;
#endif
   }
} 

implementation {
   extern int sprintf(char *str, const char *format, ...) __attribute__ ((C));
   void init();
   void configure_channels();
   void prepareDataPacket();

   uint8_t res_packet[RESPONSE_PACKET_SIZE], readBuf[7];
   int8_t tx_packet[DATA_PACKET_SIZE+1]; 
   // (+1) because MSP430 CPU can only read/write 16-bit values at even addresses,
   // so use an empty first  byte to even up the memory locations for 16-bit values
   // due to the 3 bytes before the first 16 bit data channel
   uint8_t start_val = 1;

   norace uint8_t nbr_adc_chans, nbr_1byte_digi_chans, nbr_2byte_digi_chans, current_buffer;
   int8_t sbuf0[(MAX_NUM_2_BYTE_CHANNELS*2) + MAX_NUM_1_BYTE_CHANNELS], sbuf1[(MAX_NUM_2_BYTE_CHANNELS*2) + MAX_NUM_1_BYTE_CHANNELS]; 
   norace uint16_t timestamp0, timestamp1;

   norace bool sensing, enable_sending, enable_receiving, commandPending, command_mode_complete;
   bool wasSensing, sendAck, inquiryResponse, samplingRateResponse, accelRangeResponse, configSetupByte0Response, gsrRangeResponse, shimmerVersionResponse;

   uint8_t g_arg_size, g_arg[MAX_COMMAND_ARG_SIZE], gsr_active_resistor;
   norace uint8_t g_action;

   // Configuration
   norace uint8_t stored_config[NV_NUM_CONFIG_BYTES];
   uint8_t channel_contents[MAX_NUM_CHANNELS];

   bool accelCalibrationResponse, gyroCalibrationResponse, magCalibrationResponse;


   task void startSensing() {
      if(stored_config[NV_SENSORS0] & SENSOR_GYRO){
         call GyroInit.init();
         call GyroStdControl.start();
      }

      if(stored_config[NV_SENSORS0] & SENSOR_MAG)
      {
         call MagInit.init();
         call Magnetometer.runContinuousConversion();
      }
      
      if(stored_config[NV_SENSORS0] & SENSOR_ACCEL) {
         call Accel.setSensitivity(stored_config[NV_ACCEL_RANGE]);
         call Accel.wake(TRUE);
      }

      if(stored_config[NV_SENSORS0] & SENSOR_GSR) {
         call GsrInit.init();
         if(stored_config[NV_GSR_RANGE] <= HW_RES_3M3) {
            call Gsr.setRange(stored_config[NV_GSR_RANGE]);
            gsr_active_resistor = stored_config[NV_GSR_RANGE];
         }
         else {
            call Gsr.setRange(HW_RES_40K);
            gsr_active_resistor = HW_RES_40K;
         }

      }

      if(stored_config[NV_SENSORS1] & SENSOR_STRAIN) {
         call StrainInit.init();
         call StrainGauge.powerOn();
         // Sets 5V reg
         stored_config[NV_CONFIG_SETUP_BYTE0] |= CONFIG_5V_REG;
         call InternalFlash.write((void*)NV_CONFIG_SETUP_BYTE0, (void*)&stored_config[NV_CONFIG_SETUP_BYTE0], 1);
      }

      if(stored_config[NV_SENSORS1] & SENSOR_HEART) {
         call DigitalHeartRate.enableRate(15);
      }

      call ActivityTimer.startPeriodic(1000);

      if(stored_config[NV_SAMPLING_RATE] != SAMPLING_0HZ_OFF)
         call SampleTimer.start(stored_config[NV_SAMPLING_RATE]); 
      sensing = TRUE;
   }


   task void stopSensing() {
      call SetupTimer.stop();
      call SampleTimer.stop();
      call ActivityTimer.stop();
      call shimmerAnalogSetup.stopConversion();
      call DMA0.stopTransfer();
      if(stored_config[NV_SENSORS0] & SENSOR_ACCEL)
         call Accel.wake(FALSE);
      if((stored_config[NV_SENSORS0] & SENSOR_GYRO) || (stored_config[NV_SENSORS0] & SENSOR_MAG)){
         call GyroStdControl.stop();
	 call Magnetometer.disableBus();
      }
      if(stored_config[NV_SENSORS1] & SENSOR_STRAIN) {
         call StrainGauge.powerOff();
         // clears 5V reg
         stored_config[NV_CONFIG_SETUP_BYTE0] &= ~CONFIG_5V_REG;
         call InternalFlash.write((void*)NV_CONFIG_SETUP_BYTE0, (void*)&stored_config[NV_CONFIG_SETUP_BYTE0], 1);
      }
      if(stored_config[NV_SENSORS1] & SENSOR_HEART) {
         call DigitalHeartRate.disableRate();
      }
      call Leds.led1Off();
      sensing = FALSE;
   }


   task void sendSensorData() {
      if(enable_sending) {
         prepareDataPacket();

         // send data over the air
         call Bluetooth.write(tx_packet+start_val, (3 + ((nbr_adc_chans+nbr_2byte_digi_chans)*2)+ nbr_1byte_digi_chans));
         enable_sending = FALSE;
      }
   }


   task void sendResponse() {
      uint16_t packet_length = 0;
      uint8_t i;
      
      commandPending = FALSE;
      
      if(enable_sending) {
         if(sendAck) {
            // if sending other response prepend acknowledgement to start
            // else just send acknowledgement by itself 
            *(res_packet + packet_length++) = ACK_COMMAND_PROCESSED;
            sendAck = FALSE;
         }
         if(inquiryResponse) {
            *(res_packet + packet_length++) = INQUIRY_RESPONSE;                                             //packet type
            *(res_packet + packet_length++) = stored_config[NV_SAMPLING_RATE];                              //ADC sampling rate
            *(res_packet + packet_length++) = stored_config[NV_ACCEL_RANGE];                                //Accel range
            *(res_packet + packet_length++) = stored_config[NV_CONFIG_SETUP_BYTE0];                         //Config Setup Byte 0
            *(res_packet + packet_length++) = nbr_adc_chans + nbr_1byte_digi_chans + nbr_2byte_digi_chans;  //number of data channels
            *(res_packet + packet_length++) = stored_config[NV_BUFFER_SIZE];                                //buffer size 
            memcpy((res_packet + packet_length), channel_contents, (nbr_adc_chans + nbr_1byte_digi_chans + nbr_2byte_digi_chans));
            packet_length += nbr_adc_chans + nbr_1byte_digi_chans + nbr_2byte_digi_chans;
            inquiryResponse = FALSE;
         }
         else if(samplingRateResponse) {
            *(res_packet + packet_length++) = SAMPLING_RATE_RESPONSE;                     // packet type
            *(res_packet + packet_length++) = stored_config[NV_SAMPLING_RATE];            // ADC sampling rate
            samplingRateResponse = FALSE;
         }
         else if(accelRangeResponse) {
            *(res_packet + packet_length++) = ACCEL_RANGE_RESPONSE;                       // packet type
            *(res_packet + packet_length++) = stored_config[NV_ACCEL_RANGE];              // Accel range
            accelRangeResponse = FALSE;
         }
         else if(configSetupByte0Response) {
            *(res_packet + packet_length++) = CONFIG_SETUP_BYTE0_RESPONSE;                // packet type
            *(res_packet + packet_length++) = stored_config[NV_CONFIG_SETUP_BYTE0];       // Config setup byte 0
            configSetupByte0Response = FALSE;
         }
         else if(accelCalibrationResponse){
            *(res_packet + packet_length++) = ACCEL_CALIBRATION_RESPONSE;                 // packet type
            for(i=0; i<21; i++)
               *(res_packet + packet_length++) = stored_config[NV_ACCEL_CALIBRATION + i]; // Calibration values
            accelCalibrationResponse = FALSE;
         }
         else if(gyroCalibrationResponse){
            *(res_packet + packet_length++) = GYRO_CALIBRATION_RESPONSE;                  // packet type
            for(i=0; i<21; i++)
               *(res_packet + packet_length++) = stored_config[NV_GYRO_CALIBRATION + i];  // Calibration values
            gyroCalibrationResponse = FALSE;
         }
         else if(magCalibrationResponse){
            *(res_packet + packet_length++) = MAG_CALIBRATION_RESPONSE;                   // packet type
            for(i=0; i<21; i++)
               *(res_packet + packet_length++) = stored_config[NV_MAG_CALIBRATION + i];   // Calibration values
            magCalibrationResponse = FALSE;
         }
         else if(gsrRangeResponse) {
            *(res_packet + packet_length++) = GSR_RANGE_RESPONSE;                          // packet type
            *(res_packet + packet_length++) = stored_config[NV_GSR_RANGE];                 // GSR range 
            gsrRangeResponse = FALSE;
         }
         else if(shimmerVersionResponse) {
            *(res_packet + packet_length++) = SHIMMER_VERSION_RESPONSE;                   // packet type
            *(res_packet + packet_length++) = SHIMMER_VER;                                // Shimmer Version
            shimmerVersionResponse = FALSE;
         }
         else {}

         // send data over the air
         call Bluetooth.write(res_packet, packet_length);
         enable_sending = FALSE;
      }
      else
         post sendResponse();
   }


   task void startConfigTimer() {
      call SetupTimer.startPeriodic(5000);
   }


   task void ConfigureChannelsTask()
   {
      configure_channels();
   }

   task void ProcessCommand() {
      switch(g_action){
         case INQUIRY_COMMAND:
            inquiryResponse = TRUE;
            break;
         case GET_SAMPLING_RATE_COMMAND:
            samplingRateResponse = TRUE;
            break;
         case SET_SAMPLING_RATE_COMMAND:
            stored_config[NV_SAMPLING_RATE] = g_arg[0];
            call InternalFlash.write((void*)NV_SAMPLING_RATE, (void*)&stored_config[NV_SAMPLING_RATE], 1);
            if(sensing) {
               post stopSensing();
               post startSensing();
            }
            break;
         case TOGGLE_LED_COMMAND:
            call Leds.led0Toggle();
            break;
         case START_STREAMING_COMMAND:
            // start capturing on ^G
            if(command_mode_complete)
               post startSensing();
            else
               // give config a chance, wait 5 secs
               post startConfigTimer();
            break;
         case SET_SENSORS_COMMAND:
            stored_config[NV_SENSORS0] = g_arg[0];
            stored_config[NV_SENSORS1] = g_arg[1];
            call InternalFlash.write((void*)NV_SENSORS0, (void*)&stored_config[NV_SENSORS0], 2);

            if(sensing) {
               post stopSensing();
               post ConfigureChannelsTask();
               wasSensing = TRUE;
            }
            else
               post ConfigureChannelsTask();
            break;
         case SET_ACCEL_RANGE_COMMAND:
            if((g_arg[0] == RANGE_1_5G) || (g_arg[0] == RANGE_2_0G) || (g_arg[0] == RANGE_4_0G) || (g_arg[0] == RANGE_6_0G)) {
               stored_config[NV_ACCEL_RANGE] = g_arg[0];
               call InternalFlash.write((void*)NV_ACCEL_RANGE, (void*)&stored_config[NV_ACCEL_RANGE], 1);
               if(sensing) {
                  post stopSensing();
                  post startSensing();
               }
            }
            break;
         case GET_ACCEL_RANGE_COMMAND:
            accelRangeResponse = TRUE;
            break;
         case SET_5V_REGULATOR_COMMAND:
            if(g_arg[0]) {
               TOSH_SET_SER0_RTS_PIN();
               stored_config[NV_CONFIG_SETUP_BYTE0] |= CONFIG_5V_REG;
            }
            else {
               TOSH_CLR_SER0_RTS_PIN();
               stored_config[NV_CONFIG_SETUP_BYTE0] &= ~CONFIG_5V_REG;
            }
            call InternalFlash.write((void*)NV_CONFIG_SETUP_BYTE0, (void*)&stored_config[NV_CONFIG_SETUP_BYTE0], 1);
            break;
         case SET_PMUX_COMMAND:
#ifdef PWRMUX_UTIL
            if(g_arg[0]) {
               TOSH_SET_PWRMUX_SEL_PIN();
               stored_config[NV_CONFIG_SETUP_BYTE0] |= CONFIG_PMUX;
            }
            else {
               TOSH_CLR_PWRMUX_SEL_PIN();
               stored_config[NV_CONFIG_SETUP_BYTE0] &= ~CONFIG_PMUX;
            }
            call InternalFlash.write((void*)NV_CONFIG_SETUP_BYTE0, (void*)&stored_config[NV_CONFIG_SETUP_BYTE0], 1);
#endif
            break;
         case SET_CONFIG_SETUP_BYTE0_COMMAND:
            stored_config[NV_CONFIG_SETUP_BYTE0] = g_arg[0];
            if(stored_config[NV_CONFIG_SETUP_BYTE0] & CONFIG_5V_REG)
               TOSH_SET_SER0_RTS_PIN();
            else
               TOSH_CLR_SER0_RTS_PIN();
#ifdef PWRMUX_UTIL
            if(stored_config[NV_CONFIG_SETUP_BYTE0] & CONFIG_PMUX)
               TOSH_SET_PWRMUX_SEL_PIN();
            else
               TOSH_CLR_PWRMUX_SEL_PIN();
#else
            // make sure PMUX bit is not set
            stored_config[NV_CONFIG_SETUP_BYTE0] &= ~CONFIG_PMUX;

#endif
            call InternalFlash.write((void*)NV_CONFIG_SETUP_BYTE0, (void*)&stored_config[NV_CONFIG_SETUP_BYTE0], 1);
            break;
         case GET_CONFIG_SETUP_BYTE0_COMMAND:
            configSetupByte0Response = TRUE;
            break;
         case SET_ACCEL_CALIBRATION_COMMAND:
            memcpy(&stored_config[NV_ACCEL_CALIBRATION], g_arg, 21);
            call InternalFlash.write((void*)NV_ACCEL_CALIBRATION, (void*)&stored_config[NV_ACCEL_CALIBRATION], 21);
            break;
         case GET_ACCEL_CALIBRATION_COMMAND:
            accelCalibrationResponse = TRUE;
            break; 
         case SET_GYRO_CALIBRATION_COMMAND:
            memcpy(&stored_config[NV_GYRO_CALIBRATION], g_arg, 21);
            call InternalFlash.write((void*)NV_GYRO_CALIBRATION, (void*)&stored_config[NV_GYRO_CALIBRATION], 21);
            break;
         case GET_GYRO_CALIBRATION_COMMAND:
            gyroCalibrationResponse = TRUE;
            break; 
         case SET_MAG_CALIBRATION_COMMAND:
            memcpy(&stored_config[NV_MAG_CALIBRATION], g_arg, 21);
            call InternalFlash.write((void*)NV_MAG_CALIBRATION, (void*)&stored_config[NV_MAG_CALIBRATION], 21);
            break;
         case GET_MAG_CALIBRATION_COMMAND:
            magCalibrationResponse = TRUE;
            break; 
         case STOP_STREAMING_COMMAND:
            post stopSensing();
            break;
         case SET_GSR_RANGE_COMMAND:
            if((g_arg[0] == HW_RES_40K) || (g_arg[0] == HW_RES_287K) || 
               (g_arg[0] == HW_RES_1M) || (g_arg[0] == HW_RES_3M3) ||
               (g_arg[0] == GSR_AUTORANGE) || (g_arg[0] == GSR_X4)) {
               stored_config[NV_GSR_RANGE] = g_arg[0];
               call InternalFlash.write((void*)NV_GSR_RANGE, (void*)&stored_config[NV_GSR_RANGE], 1);
               if(sensing) {
                  post stopSensing();
                  post startSensing();
               }
            }
            break;
         case GET_GSR_RANGE_COMMAND:
            gsrRangeResponse = TRUE;
            break;
         case GET_SHIMMER_VERSION_COMMAND:
            shimmerVersionResponse = TRUE;
            break;
         default:
      }
      sendAck = TRUE;
      post sendResponse();
   }

   
   task void collect_results() {
      uint8_t rate = 0;
      int16_t realVals[3];
      register uint8_t i, j;
      
      if(stored_config[NV_SENSORS0] & SENSOR_MAG) {
         j = 0;
         call Magnetometer.convertRegistersToData(readBuf, realVals);

         if(current_buffer == 0) {
            for(i = 0; i < 3; i++)
               *((uint16_t *)sbuf0 + j++ + nbr_adc_chans) = *(realVals + i);
         }
         else {
            for(i = 0; i < 3; i++)
               *((uint16_t *)sbuf1 + j++ + nbr_adc_chans) = *(realVals + i);
         }
      }

      // 8 bit channels must come after 16 bit channels
      // due allignment for 16 bit read/writes
      if(stored_config[NV_SENSORS1] & SENSOR_HEART) {
         j = 0;
         call DigitalHeartRate.getRate(&rate);
         if(current_buffer == 0) 
            *(sbuf0 + j++ + ((nbr_adc_chans + nbr_2byte_digi_chans)*2)) = rate;
         else
            *(sbuf1 + j++ + ((nbr_adc_chans + nbr_2byte_digi_chans)*2)) = rate;
      }

      post sendSensorData();
   }


   task void clockin_result() {
      if(stored_config[NV_SENSORS0] & SENSOR_MAG)
         call Magnetometer.readData();
      else
         post collect_results();
   }


   task void autorange_gsr() {
      uint8_t current_active_resistor = gsr_active_resistor;

      // GSR channel will always be last ADC channel
      if(current_buffer == 0) {
         gsr_active_resistor = call Gsr.controlRange(*((uint16_t *)sbuf0 + (nbr_adc_chans - 1)), gsr_active_resistor);
         *((uint16_t *)sbuf0 + (nbr_adc_chans - 1)) |= (current_active_resistor << 14);
      }
      else {
         gsr_active_resistor = call Gsr.controlRange(*((uint16_t *)sbuf1 + (nbr_adc_chans - 1)), gsr_active_resistor);
         *((uint16_t *)sbuf1 + (nbr_adc_chans - 1)) |= (current_active_resistor << 14);
      }
   }


   void init() {
#ifdef USE_8MHZ_CRYSTAL
      call FastClockInit.init();
      call FastClock.setSMCLK(1);  // set smclk to 1MHz
#endif // USE_8MHZ_CRYSTAL
   
      enable_sending = FALSE;
      enable_receiving = FALSE;
      command_mode_complete = FALSE;
      sensing = FALSE;
      wasSensing = FALSE;
      sendAck = FALSE;
      commandPending = FALSE;
      current_buffer = 0;
      nbr_1byte_digi_chans = 0;
      nbr_2byte_digi_chans = 0;
      nbr_adc_chans = 0;
      samplingRateResponse = FALSE;
      accelRangeResponse = FALSE;
      configSetupByte0Response = FALSE;
      gsrRangeResponse = FALSE;
      shimmerVersionResponse = FALSE;
      inquiryResponse = FALSE;
      accelCalibrationResponse = FALSE;
      gyroCalibrationResponse = FALSE;
      magCalibrationResponse = FALSE;

      call BluetoothInit.init();
      call Bluetooth.disableRemoteConfig(TRUE);

      call SampleTimerInit.init();

      call InternalFlash.read((void*)0, (void*)stored_config, NV_NUM_CONFIG_BYTES);
      if(stored_config[NV_SENSORS0] == 0xFF) {
         // if config was never written to Infomem write default
         // Accel only, 50Hz, buffer size of 1, GSR range as HW_RES_40K, 5V reg and PMUX off
         stored_config[NV_SAMPLING_RATE] = SAMPLING_50HZ;
         stored_config[NV_BUFFER_SIZE] = 1;
         stored_config[NV_SENSORS0] = SENSOR_ACCEL;
         stored_config[NV_SENSORS1] = 0;
         stored_config[NV_ACCEL_RANGE] = RANGE_1_5G;
         stored_config[NV_GSR_RANGE] = HW_RES_40K;
         stored_config[NV_CONFIG_SETUP_BYTE0] = 0;
         call InternalFlash.write((void*)0, (void*)stored_config, NV_NUM_CONFIG_BYTES);
      }

      // Set SER0_RTS pin to be I/O in order to control 5V regulator on AnEx board
      TOSH_MAKE_SER0_RTS_OUTPUT();
      TOSH_SEL_SER0_RTS_IOFUNC();
      if(stored_config[NV_CONFIG_SETUP_BYTE0] & CONFIG_5V_REG)
	      TOSH_SET_SER0_RTS_PIN();
      else
         TOSH_CLR_SER0_RTS_PIN();
#ifdef PWRMUX_UTIL
      // Set PMUX
      if(stored_config[NV_CONFIG_SETUP_BYTE0] & CONFIG_PMUX)
         TOSH_SET_PWRMUX_SEL_PIN();
      else
         TOSH_CLR_PWRMUX_SEL_PIN();
#endif

      configure_channels();
   }


   void configure_channels() {
      uint8_t *channel_contents_ptr = channel_contents;

      nbr_adc_chans = 0;
      nbr_1byte_digi_chans = 0;
      nbr_2byte_digi_chans = 0;

      call shimmerAnalogSetup.reset();
      // Accel
      if(stored_config[NV_SENSORS0] & SENSOR_ACCEL) {
         call AccelInit.init();
         call shimmerAnalogSetup.addAccelInputs();
         *channel_contents_ptr++ = X_ACCEL;
         *channel_contents_ptr++ = Y_ACCEL;
         *channel_contents_ptr++ = Z_ACCEL;
      }
      // Gyro
      if(stored_config[NV_SENSORS0] & SENSOR_GYRO){
         call shimmerAnalogSetup.addGyroInputs();
         *channel_contents_ptr++ = X_GYRO;
         *channel_contents_ptr++ = Y_GYRO;
         *channel_contents_ptr++ = Z_GYRO;
      }
      // ECG
      else if(stored_config[NV_SENSORS0] & SENSOR_ECG){
         call shimmerAnalogSetup.addECGInputs();
         *channel_contents_ptr++ = ECG_RA_LL;
         *channel_contents_ptr++ = ECG_LA_LL;
      }
      // EMG
      else if(stored_config[NV_SENSORS0] & SENSOR_EMG){
         call shimmerAnalogSetup.addEMGInput();
         *channel_contents_ptr++ = EMG;
      }
      // AnEx A7
      if(stored_config[NV_SENSORS0] & SENSOR_ANEX_A7) {
         call shimmerAnalogSetup.addAnExInput(7);
         *channel_contents_ptr++ = ANEX_A7;
      }
      // AnEx A0
      if(stored_config[NV_SENSORS0] & SENSOR_ANEX_A0) {
         call shimmerAnalogSetup.addAnExInput(0);
         *channel_contents_ptr++ = ANEX_A0;
      }
      // Strain Gauge
      if(stored_config[NV_SENSORS1] & SENSOR_STRAIN) {
         call shimmerAnalogSetup.addStrainGaugeInputs();
         *channel_contents_ptr++ = STRAIN_HIGH;
         *channel_contents_ptr++ = STRAIN_LOW;
      }
      // GSR
      // needs to be the last analog channel
      else if(stored_config[NV_SENSORS0] & SENSOR_GSR){
         call shimmerAnalogSetup.addGSRInput();
         *channel_contents_ptr++ = GSR_RAW;
      }
      // Digital channels need to be after ADC channels to allow for DMA
      // Mag
      if(stored_config[NV_SENSORS0] & SENSOR_MAG) {
         *channel_contents_ptr++ = X_MAG;
         *channel_contents_ptr++ = Y_MAG;
         *channel_contents_ptr++ = Z_MAG;
         nbr_2byte_digi_chans += 3;
      }
      // 1 byte digital channels must come after 2 byte digital channels
      // Heart Rate
      if(stored_config[NV_SENSORS1] & SENSOR_HEART) {
         call DigitalHeartInit.init();
         *channel_contents_ptr++ = HEART_RATE;
         nbr_1byte_digi_chans += 1;
      }

      call shimmerAnalogSetup.finishADCSetup((uint16_t *)sbuf0);
      nbr_adc_chans = call shimmerAnalogSetup.getNumberOfChannels();


      if(wasSensing) {
         post startSensing();
         wasSensing = FALSE;
      }
   }


   // The MSP430 CPU is byte addressed and little endian/
   // packets are sent little endian so the word 0xABCD will be sent as bytes 0xCD 0xAB
   void prepareDataPacket() {
      uint16_t *p_packet, *p_samples;
      uint8_t *p8_packet, *p8_samples, i;

      p8_packet = &tx_packet[start_val];
    
      *p8_packet++ = DATA_PACKET;
      if(current_buffer == 0) {
         p_samples = (uint16_t *)sbuf0;
         *p8_packet++ = timestamp0 & 0xff;
         *p8_packet++ = (timestamp0 >> 8) & 0xff;
         current_buffer = 1;
      }
      else {
         p_samples = (uint16_t *)sbuf1;
         *p8_packet++ = timestamp1 & 0xff;
         *p8_packet++ = (timestamp1 >> 8) & 0xff;
         current_buffer = 0;
      }

      p_packet = (uint16_t *)p8_packet;
      // ADC channels and 2 byte digi channels
      for(i=0; i<(nbr_adc_chans + nbr_2byte_digi_chans); i++, p_packet++, p_samples++){
         *p_packet = *p_samples; 
      }
      
      p8_packet = (uint8_t *)p_packet;
      p8_samples = (uint8_t *)p_samples;
      // 1 byte digi channels
      for(i=0; i<nbr_1byte_digi_chans; i++, p8_packet++, p_samples++){
         *p8_packet = *p_samples; 
      }
   }


   event void Boot.booted() {
      init();
      call BTStdControl.start(); 
   }


   async event void Bluetooth.connectionMade(uint8_t status) { 
      enable_sending = TRUE;
      enable_receiving = TRUE;
      call Leds.led2On();
   }

   
   async event void Bluetooth.commandModeEnded() { 
      command_mode_complete = TRUE;
   }
    

   async event void Bluetooth.connectionClosed(uint8_t reason){
      enable_sending = FALSE;
      enable_receiving = FALSE;
      sensing = FALSE;
      call Leds.led2Off();
      post stopSensing();
   }


   async event void Bluetooth.dataAvailable(uint8_t data){
      if(enable_receiving)
         call BPCommandParser.handleByte(data);
   }


   event void Bluetooth.writeDone(){
      enable_sending = TRUE;
   }


   event void SetupTimer.fired() {
      atomic if(command_mode_complete){
         post startSensing();
      }
   }


   event void ActivityTimer.fired() {
      // toggle activity led every second
      call Leds.led1Toggle();
   }


   //event void SampleTimer.fired() {
   async event void SampleTimer.fired() {
      call SampleTimer.start(stored_config[NV_SAMPLING_RATE]); 
      if(current_buffer == 0){
         timestamp0 = call LocalTime.get();
      }
      else { 
         timestamp1 = call LocalTime.get();
      }
      if(nbr_adc_chans > 0)
         call shimmerAnalogSetup.triggerConversion();
      else if((nbr_1byte_digi_chans > 0) || (nbr_2byte_digi_chans > 0))
         post clockin_result();
   }


   async event void DMA0.transferDone(error_t success) {
      if(current_buffer == 0){
         call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)sbuf1, nbr_adc_chans);
      }
      else { 
         call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)sbuf0, nbr_adc_chans);
      }
      if(stored_config[NV_SENSORS0] & SENSOR_GSR) {
         if(stored_config[NV_GSR_RANGE] == GSR_AUTORANGE)
            post autorange_gsr();
      }
      if((nbr_1byte_digi_chans > 0) || (nbr_2byte_digi_chans > 0))
         post clockin_result();
      else
         post sendSensorData();      
   }


   async event void BPCommandParser.activate(uint8_t action, uint8_t arg_size, uint8_t *arg){
      bool temp;

      atomic temp = commandPending; // to keep atomic section as short as possible
      if(!temp) {
         g_arg_size = arg_size;
         memcpy(g_arg, arg, arg_size);
         g_action = action;
         commandPending = TRUE;
         post ProcessCommand();
      }
   }


   async event void GyroBoard.buttonPressed() {
   }


   async event void Magnetometer.readDone(uint8_t * data, error_t success) {
      memcpy(readBuf, data, 7);
      post collect_results();
   }


   async event void Magnetometer.writeDone(error_t success){
   }

   async event void DigitalHeartRate.beat(uint32_t time) {
   }

   event void DigitalHeartRate.newConnectionState(bool up){
      if(up){
         if((stored_config[NV_SENSORS1] & SENSOR_HEART) && (sensing)) {
            call DigitalHeartRate.enableRate(15);
         }
      }
      else{
         if((stored_config[NV_SENSORS1] & SENSOR_HEART) && (sensing)) {
            call DigitalHeartRate.disableRate();   // this flushes any old data 
         }
      }
   }
}
