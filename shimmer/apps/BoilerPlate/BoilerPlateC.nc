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
          Packet Type | ADC Sampling rate | Accel Sensitivity | Config Byte 0 |Num Chans | Buf size | Chan1 | Chan2 | ... | ChanX
   Byte:       0      |         1         |          2        |       3       |    4     |     5    |   6   |   7   | ... |   x

***********************************************************************************/
#include "Timer.h"
#include "Mma_Accel.h"
#include "RovingNetworks.h"
#include "Shimmer.h"

module BoilerPlateC {
   uses {
      interface Boot;
      interface Init as BluetoothInit;
      interface Init as AccelInit;
      interface Init as GyroInit;
      interface Init as MagInit;
      interface GyroBoard;
      interface Magnetometer;
      interface StdControl as GyroStdControl;
      interface Leds;
      interface shimmerAnalogSetup;
      interface Timer<TMilli> as SetupTimer;
      interface Timer<TMilli> as ActivityTimer;
      interface Timer<TMilli> as SampleTimer;
      interface LocalTime<T32khz>;
      interface Mma_Accel as Accel;
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

   int8_t tx_packet[((DATA_PACKET_SIZE%2)?(DATA_PACKET_SIZE+1):DATA_PACKET_SIZE)]; 
   // (+1) because MSP430 CPU can only read/write 16-bit values at even addresses,
   // so use an empty first  byte to even up the memory locations for 16-bit values
   uint8_t start_val = ((DATA_PACKET_SIZE%2)?1:0);

   uint8_t res_packet[RESPONSE_PACKET_SIZE];

   uint8_t nbr_adc_chans, nbr_digi_chans, readBuf[7];
   norace uint8_t current_buffer = 0;
   int16_t sbuf0[11], sbuf1[11];    // maximum of 11 channels, (3 x Accel) + (3 x Gyro) + (3 x Mag) + (2 x AnEx) 
   uint16_t timestamp0, timestamp1;
   bool enable_sending, enable_receiving, command_mode_complete, activity_led_on;

   bool sensing, commandPending, wasSensing;
   bool sendAck, inquiryResponse, samplingRateResponse, accelSensitivityResponse, configSetupByte0Response;

   uint8_t g_action, g_arg_size, g_arg[MAX_COMMAND_ARG_SIZE];

   // Configuration
   uint8_t stored_config[NV_NUM_CONFIG_BYTES];
   uint8_t channel_contents[MAX_NUM_CHANNELS];



   task void startSensing() {
      if((stored_config[NV_SENSORS0] & SENSOR_GYRO) || (stored_config[NV_SENSORS0] & SENSOR_MAG)) {
         call GyroInit.init();
         call GyroStdControl.start();
	 call Magnetometer.enableBus();
      }

      if(stored_config[NV_SENSORS0] & SENSOR_MAG)
      {
         call Magnetometer.runContinuousConversion();
      }
      
      if(stored_config[NV_SENSORS0] & SENSOR_ACCEL) {
         call Accel.setSensitivity(stored_config[NV_ACCEL_SENSITIVITY]);
         call Accel.wake(TRUE);
      }
      call ActivityTimer.startPeriodic(1000);

      if(stored_config[NV_SAMPLING_RATE] != SAMPLING_0HZ_OFF)
         call SampleTimer.startPeriodic(stored_config[NV_SAMPLING_RATE]); 
      atomic sensing = TRUE;
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
      call Leds.led1Off();
      atomic sensing = FALSE;
   }


   task void sendSensorData() {
      atomic if(enable_sending) {
         prepareDataPacket();

         // send data over the air
         call Bluetooth.write(tx_packet+start_val, (3 + ((nbr_adc_chans+nbr_digi_chans)*2)));
         enable_sending = FALSE;
      }
   }


   task void sendResponse() {
      uint16_t packet_length = 0;
      bool temp;
      
      atomic { 
         temp = enable_sending;
         enable_sending = FALSE;
         commandPending = FALSE;
      }
      if(temp) {
         if(sendAck) {
            // if sending other response prepend acknowledgement to start
            // else just send acknowledgement by itself 
            *(res_packet + packet_length++) = ACK_COMMAND_PROCESSED;
            sendAck = FALSE;
         }
         if(inquiryResponse) {
            *(res_packet + packet_length++) = INQUIRY_RESPONSE;                        //packet type
            *(res_packet + packet_length++) = stored_config[NV_SAMPLING_RATE];         //ADC sampling rate
            *(res_packet + packet_length++) = stored_config[NV_ACCEL_SENSITIVITY];     //Accel Sensitivity
            *(res_packet + packet_length++) = stored_config[NV_CONFIG_SETUP_BYTE0];    //Config Setup Byte 0
            *(res_packet + packet_length++) = nbr_adc_chans + nbr_digi_chans;          //number of data channels
            *(res_packet + packet_length++) = stored_config[NV_BUFFER_SIZE];           //buffer size 
            memcpy((res_packet + packet_length), channel_contents, (nbr_adc_chans + nbr_digi_chans));
            packet_length += nbr_adc_chans + nbr_digi_chans;
            inquiryResponse = FALSE;
         }
         else if(samplingRateResponse) {
            *(res_packet + packet_length++) = SAMPLING_RATE_RESPONSE;                  // packet type
            *(res_packet + packet_length++) = stored_config[NV_SAMPLING_RATE];         // ADC sampling rate
            samplingRateResponse = FALSE;
         }
         else if(accelSensitivityResponse) {
            *(res_packet + packet_length++) = ACCEL_SENSITIVITY_RESPONSE;              // packet type
            *(res_packet + packet_length++) = stored_config[NV_ACCEL_SENSITIVITY];     // Accel Sensitivity
            accelSensitivityResponse = FALSE;
         }
         else if(configSetupByte0Response) {
            *(res_packet + packet_length++) = CONFIG_SETUP_BYTE0_RESPONSE;             // packet type
            *(res_packet + packet_length++) = stored_config[NV_CONFIG_SETUP_BYTE0];    // Config setup byte 0
            configSetupByte0Response = FALSE;
         }
         else {}

         // send data over the air
         call Bluetooth.write(res_packet, packet_length);
      }
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
            atomic if(sensing) {
               post stopSensing();
               post startSensing();
            }
            break;
         case TOGGLE_LED_COMMAND:
            call Leds.led0Toggle();
            break;
         case START_STREAMING_COMMAND:
            // start capturing on ^G
            atomic if(command_mode_complete)
               post startSensing();
            else
               // give config a chance, wait 5 secs
               post startConfigTimer();
            break;
         case SET_SENSORS_COMMAND:
            stored_config[NV_SENSORS0] = g_arg[0];
            call InternalFlash.write((void*)NV_SENSORS0, (void*)&stored_config[NV_SENSORS0], 1);
            atomic if(sensing) {
               post stopSensing();
               post ConfigureChannelsTask();
               //post startSensing();
               wasSensing = TRUE;
            }
            else
               post ConfigureChannelsTask();
            break;
         case SET_ACCEL_SENSITIVITY_COMMAND:
            if((g_arg[0] == RANGE_1_5G) || (g_arg[0] == RANGE_2_0G) || (g_arg[0] == RANGE_4_0G) || (g_arg[0] == RANGE_6_0G)) {
               stored_config[NV_ACCEL_SENSITIVITY] = g_arg[0];
               call InternalFlash.write((void*)NV_ACCEL_SENSITIVITY, (void*)&stored_config[NV_ACCEL_SENSITIVITY], 1);
               atomic if(sensing) {
                  post stopSensing();
                  post startSensing();
               }
            }
            break;
         case GET_ACCEL_SENSITIVITY_COMMAND:
            accelSensitivityResponse = TRUE;
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
               TOSH_SET_SER0_RTS_PIN;
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
         case STOP_STREAMING_COMMAND:
            post stopSensing();
            break;
         default:
      }
      sendAck = TRUE;
      post sendResponse();
   }


   task void clockin_result() {
      call Magnetometer.readData();
   }

   
   task void collect_results() {
      int16_t realVals[3];
      register uint8_t i;

      call Magnetometer.convertRegistersToData(readBuf, realVals);

      if(current_buffer == 0) {
         for(i = 0; i < 3; i++)
            *(sbuf0 + i + nbr_adc_chans) = *(realVals + i);
      }
      else {
         for(i = 0; i < 3; i++)
            *(sbuf1 + i + nbr_adc_chans) = *(realVals + i);
      }

      post sendSensorData();
   }


   void init() {
#ifdef USE_8MHZ_CRYSTAL
      call FastClockInit.init();
      call FastClock.setSMCLK(1);  // set smclk to 1MHz
#endif // USE_8MHZ_CRYSTAL
   
      atomic {
         enable_sending = FALSE;
         enable_receiving = FALSE;
         command_mode_complete = FALSE;
         activity_led_on = FALSE;
         sensing = FALSE;
         sendAck = FALSE;
         inquiryResponse = FALSE;
         samplingRateResponse = FALSE;
         accelSensitivityResponse = FALSE;
         configSetupByte0Response = FALSE;
         commandPending = FALSE;
         wasSensing = FALSE;
         nbr_adc_chans = 0;
         nbr_digi_chans = 0;
      }
      call BluetoothInit.init();

      call InternalFlash.read((void*)0, (void*)stored_config, NV_NUM_CONFIG_BYTES);
      if(stored_config[NV_SENSORS0] == 0xFF) {
         // if config was never written to Infomem write default
         // Accel only, 50Hz, buffer size of 1, 5V reg and PMUX off
         stored_config[NV_SAMPLING_RATE] = SAMPLING_50HZ;
         stored_config[NV_BUFFER_SIZE] = 1;
         stored_config[NV_SENSORS0] = SENSOR_ACCEL;
         stored_config[NV_ACCEL_SENSITIVITY] = RANGE_1_5G;
         stored_config[NV_CONFIG_SETUP_BYTE0] = 0;
         call InternalFlash.write((void*)0, (void*)stored_config, NV_NUM_CONFIG_BYTES);
      }

      configure_channels();

      call Bluetooth.disableRemoteConfig(TRUE);
   
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

   }


   void configure_channels() {
      uint8_t *channel_contents_ptr = channel_contents;

      nbr_adc_chans = 0;
      nbr_digi_chans = 0;

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
         *channel_contents_ptr++ = EMG_1;
         *channel_contents_ptr++ = EMG_2;
      }
      //GSR
      else if(stored_config[NV_SENSORS0] & SENSOR_GSR){
         call shimmerAnalogSetup.addGSRInput();
         *channel_contents_ptr++ = GSR_LO;
         *channel_contents_ptr++ = GSR_HI;
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
      // Mag
      // needs to be last to allow DMA for ADC channels
      if(stored_config[NV_SENSORS0] & SENSOR_MAG) {
         *channel_contents_ptr++ = X_MAG;
         *channel_contents_ptr++ = Y_MAG;
         *channel_contents_ptr++ = Z_MAG;
         nbr_digi_chans += 3;
      }

      call shimmerAnalogSetup.finishADCSetup(sbuf0);
      nbr_adc_chans = call shimmerAnalogSetup.getNumberOfChannels();


      atomic if(wasSensing) {
         post startSensing();
         wasSensing = FALSE;
      }
   }


   // The MSP430 CPU is byte addressed and little endian/
   // packets are sent little endian so the word 0xABCD will be sent as bytes 0xCD 0xAB
   void prepareDataPacket() {
      uint16_t *p_packet, *p_ADCsamples;
      uint8_t *p8_packet, i;

      p8_packet = &tx_packet[start_val];
    
      *p8_packet++ = DATA_PACKET;
      if(current_buffer == 0) {
         p_ADCsamples = sbuf0;
         *p8_packet++ = timestamp0 & 0xff;
         *p8_packet++ = (timestamp0 >> 8) & 0xff;
         current_buffer = 1;
      }
      else {
         p_ADCsamples = sbuf1;
         *p8_packet++ = timestamp1 & 0xff;
         *p8_packet++ = (timestamp1 >> 8) & 0xff;
         current_buffer = 0;
      }

      p_packet = (uint16_t *)p8_packet;
      for(i=0; i<(nbr_adc_chans+nbr_digi_chans); i++, p_packet++, p_ADCsamples++){
         *p_packet = *p_ADCsamples; 
      }
   }


   event void Boot.booted() {
      init();
      call BTStdControl.start(); 
   }


   async event void Bluetooth.connectionMade(uint8_t status) { 
      atomic {
         enable_sending = TRUE;
         enable_receiving = TRUE;
      }
      call Leds.led2On();
   }

   
   async event void Bluetooth.commandModeEnded() { 
      atomic command_mode_complete = TRUE;
   }
    

   async event void Bluetooth.connectionClosed(uint8_t reason){
      atomic { 
         enable_sending = FALSE;
         enable_receiving = FALSE;
         sensing = FALSE;
      }
      call Leds.led2Off();
      post stopSensing();
   }


   async event void Bluetooth.dataAvailable(uint8_t data){
      atomic if(enable_receiving)
         call BPCommandParser.handleByte(data);
   }


   event void Bluetooth.writeDone(){
      atomic enable_sending = TRUE;
   }


   event void SetupTimer.fired() {
      atomic if(command_mode_complete){
         post startSensing();
      }
   }


   event void ActivityTimer.fired() {
      atomic {
         // toggle activity led every second
         if(activity_led_on) {
            call Leds.led1On();
            activity_led_on = FALSE;
         }
         else {
            call Leds.led1Off();
            activity_led_on = TRUE;
         }
      }
   }


   event void SampleTimer.fired() {
      if(nbr_adc_chans > 0)
         call shimmerAnalogSetup.triggerConversion();
      else if(nbr_digi_chans > 0)
         post clockin_result();
   }


   async event void DMA0.transferDone(error_t success) {
      if(current_buffer == 0){
         call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)sbuf1, nbr_adc_chans);
         atomic timestamp1 = call LocalTime.get();
         //current_buffer = 1;
      }
      else { 
         call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)sbuf0, nbr_adc_chans);
         atomic timestamp0 = call LocalTime.get();
         //current_buffer = 0;
      }
      if(nbr_digi_chans > 0)
         post clockin_result();
      else
         post sendSensorData();      
   }


   async event void BPCommandParser.activate(uint8_t action, uint8_t arg_size, uint8_t *arg){
      atomic if(!commandPending) {
         g_action = action;
         g_arg_size = arg_size;
         memcpy(g_arg, arg, arg_size);
         commandPending = TRUE;
         post ProcessCommand();
      }
   }


   async event void GyroBoard.buttonPressed() {
   }


   event void Magnetometer.readDone(uint8_t * data, error_t success) {
      memcpy(readBuf, data, 7);
      post collect_results();
   }


   event void Magnetometer.writeDone(error_t success){
   }
}
