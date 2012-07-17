/*
 * Copyright (c) 2007, Intel Corporation
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, 
 * this list of conditions and the following disclaimer. 
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution. 
 *
 * Neither the name of the Intel Corporation nor the names of its contributors
 * may be used to endorse or promote products derived from this software 
 * without specific prior written permission. 
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Author: Adrian Burns
 *         November, 2007
 */

/***********************************************************************************
this is the third-generation of adrian burns' biomobius accelgyro app, 
going into tinyos-2.x and now altering the input i/o to handle a non-analog
signal from a magnetometer.  

   This app uses Bluetooth to stream 3 Accelerometer channels and 3 Gyro channels 
   of data to a BioMOBIUS PC application. 
   Tested on SHIMMER Base Board Rev 1.3, SHIMMER GyroDB 1.0 board.

   LOW_BATTERY_INDICATION if defined stops the app streaming data just after the 
   battery voltage drops below the regulator value of 3V.

   Default Sample Frequency: 50 hz

   NOTE:  magnetometer delivers data at 10hz, so these data are only updated every *fifth* packet
          at the default sample rate of 50hz.

   Packet Format:
         BOF| Sensor ID | Data Type | Seq No. | TimeStamp | Len | Mag | Mag  | Mag  | Gyro  | Gyro | Gyro |  CRC | EOF
   Byte:  1 |    2      |     3     |    4    |     5-6   |  7  | 8-9 | 10-11| 12-13| 14-15 | 16-17| 18-19| 20-21| 22

***********************************************************************************/
/*
 * @author Adrian Burns
 * @date November, 2007
 *
 * @author Mike Healy
 * @date May 7, 2009 - ported to TinyOS 2.x 
 *
 * @author Steve Ayer
 * @date   March, 2010
 * mods to use shimmerAnalogSetup interface and new GyroBoard module
 *
 * @author Steve Ayer
 * @date   July, 2010
 * revisions to use gyro/mag board, sending data in that order gyro no longer second)
 */

#include "Timer.h"
#include "GyroMag.h"
#include "crc.h"
#include "RovingNetworks.h"

module GyroMagC {
  uses {
    interface Boot;

    interface FastClock;
    interface Init as FastClockInit;

    interface Init as BluetoothInit;
    interface Init as GyroInit;
    interface Init as MagInit;

    interface GyroBoard;
    interface StdControl as GyroStdControl;
    interface Magnetometer;

    interface Leds;

    interface shimmerAnalogSetup;

    interface Timer<TMilli> as SetupTimer;
    interface Timer<TMilli> as ActivityTimer;
    interface Timer<TMilli> as SampleTimer;

    interface LocalTime<T32khz>;

    interface StdControl as BTStdControl;
    interface Bluetooth;

    interface Msp430DmaChannel as DMA0;
  }
} 

implementation {
  extern int sprintf(char *str, const char *format, ...) __attribute__ ((C));

#ifdef LOW_BATTERY_INDICATION
  //#define DEBUG_LOW_BATTERY_INDICATION
  /* during testing of the the (AVcc-AVss)/2 value from the ADC on various SHIMMERS, to get a reliable cut off point 
     to recharge the battery it is important to find the baseline (AVcc-AVss)/2 value coming from the ADC as it varies 
     from SHIMMER to SHIMMER, however the range of fluctuation is pretty constant and (AVcc-AVss)/2 provides an accurate 
     battery low indication that prevents getting any voltage skewed data from the accelerometer or add-on board sensors */
#define TOTAL_BASELINE_BATT_VOLT_SAMPLES_TO_RECORD 1000
#define BATTERY_LOW_INDICATION_OFFSET 20 /* (AVcc - AVss)/2 = Approx 3V-0V/2 = 1.5V, 12 bit ADC with 2.5V REF, 4096/2500 = 1mV=1.6384 units */ 
  bool need_baseline_voltage, linkDisconnecting;
  uint16_t num_baseline_voltage_samples, baseline_voltage;
  uint32_t sum_batt_volt_samples;

#ifdef DEBUG_LOW_BATTERY_INDICATION
  uint16_t debug_counter;
#endif /* DEBUG_LOW_BATTERY_INDICATION */

#endif /* LOW_BATTERY_INDICATION */

#define FIXED_PACKET_SIZE 22
#define FIXED_PAYLOAD_SIZE 12
  //  uint8_t tx_packet[(FIXED_PACKET_SIZE*2)+1]; /* (*2)twice size because of NON-EXISTENT byte stuffing */
  int8_t tx_packet[(FIXED_PACKET_SIZE*2)+1]; /* (*2)twice size because of NON-EXISTENT byte stuffing */
  /* (+1)MSP430 CPU can only read/write 16-bit values at even addresses, */
  /* so use an empty byte to even up the memory locations for 16-bit values */
  const uint8_t personality[17] = {
    0,1,2,3,4,5,0xFF,0xFF,
    SAMPLING_50HZ,SAMPLING_50HZ,SAMPLING_50HZ,SAMPLING_50HZ,
    SAMPLING_50HZ,SAMPLING_50HZ,SAMPLING_0HZ_OFF,SAMPLING_0HZ_OFF,FRAMING_EOF
  };
  
  int16_t sbuf0[42], sbuf1[42], * current_dest, sample_period = 500;

  uint8_t NBR_ADC_CHANS, readBuf[13], buffered;
  norace uint8_t current_buffer = 0;
  uint16_t timestamp0, timestamp1;  // sbuf0[7], sbuf1[7], 
  bool enable_sending, command_mode_complete, activity_led_on;

  /* default sample frequency every time the sensor boots up */
  uint16_t sample_freq = 200;//SAMPLING_10HZ;

  /* Internal function to calculate 16 bit CRC */
  uint16_t calc_crc(uint8_t *ptr, uint8_t count) {
    uint16_t crc;
    crc = 0;
    while (count-- > 0)
      crc = crcByte(crc, *ptr++);
    return crc;
  }

  void init() {
    call FastClockInit.init();
    call FastClock.setSMCLK(1);

    call BluetoothInit.init();

    // mag pointer init
    //    current_dest = sbuf0 + 3;

    atomic {
      memset(tx_packet, 0, (FIXED_PACKET_SIZE*2));
      enable_sending = FALSE;
      command_mode_complete = FALSE;
      activity_led_on = FALSE;
    }
    
    call shimmerAnalogSetup.addGyroInputs();
    call shimmerAnalogSetup.finishADCSetup(sbuf0);

    NBR_ADC_CHANS = call shimmerAnalogSetup.getNumberOfChannels();

    call Bluetooth.disableRemoteConfig(TRUE);
  }

  event void Boot.booted() {
    init();
    call BTStdControl.start();
    /* so that the clinicians know the sensor is on */
#ifdef LOW_BATTERY_INDICATION
    /* initialise baseline voltage measurement stuff */ 
    need_baseline_voltage = TRUE;
    num_baseline_voltage_samples = baseline_voltage = sum_batt_volt_samples = 0;
    call Leds.led0On();
#ifdef DEBUG_LOW_BATTERY_INDICATION
    debug_counter = 0;
#endif /* DEBUG_LOW_BATTERY_INDICATION */
#endif /* LOW_BATTERY_INDICATION */
  }

#ifdef LOW_BATTERY_INDICATION  
  task void sendBatteryLowIndication() {
    uint16_t crc;
    char batt_low_str[] = "BATTERY LOW!";

    /* stop all sensing - battery is below the threshold */
    call SetupTimer.stop();
    call ActivityTimer.stop();
    call shimmerAnalogSetup.stopConversion();
    call DMA0.stopTransfer();
    call GyroStdControl.stop();
    call Magnetometer.disableBus();
    call Leds.led1Off();


    /* send the battery low indication packet to BioMOBIUS */
    tx_packet[1] = FRAMING_BOF;
    tx_packet[2] = SHIMMER_REV1;
    tx_packet[3] = STRING_DATA_TYPE;
    tx_packet[4]++; /* increment sequence number */ 
    atomic tx_packet[5] = timestamp0 & 0xff;
    atomic tx_packet[6] = (timestamp0 >> 8) & 0xff;
    tx_packet[7] = FIXED_PAYLOAD_SIZE;
    memcpy(&tx_packet[8], &batt_low_str[0], 12);

#ifdef DEBUG_LOW_BATTERY_INDICATION
    tx_packet[8] = (baseline_voltage) & 0xff;
    tx_packet[9] = ((baseline_voltage) >> 8) & 0xff;
#endif /* DEBUG_LOW_BATTERY_INDICATION */
    
    crc = calc_crc(&tx_packet[2], (FIXED_PACKET_SIZE-FRAMING_SIZE));
    tx_packet[FIXED_PACKET_SIZE - 2] = crc & 0xff;
    tx_packet[FIXED_PACKET_SIZE - 1] = (crc >> 8) & 0xff;
    tx_packet[FIXED_PACKET_SIZE] = FRAMING_EOF;

    call Bluetooth.write(&tx_packet[1], FIXED_PACKET_SIZE);
    atomic enable_sending = FALSE;

    /* initialise baseline voltage measurement stuff */
    need_baseline_voltage = TRUE;
    num_baseline_voltage_samples = baseline_voltage = sum_batt_volt_samples = 0;
    call Leds.led0On();
  }

  /* all samples are got so set the baseline voltage for this SHIMMER hardware */
  void setBattVoltageBaseline() {
    baseline_voltage = (sum_batt_volt_samples / TOTAL_BASELINE_BATT_VOLT_SAMPLES_TO_RECORD);
  }

  /* check voltage level and if it is low then stop sampling, send message and disconnect */
  void checkBattVoltageLevel(uint16_t battery_voltage) {
#ifndef DEBUG_LOW_BATTERY_INDICATION
    //    if(battery_voltage < (baseline_voltage-BATTERY_LOW_INDICATION_OFFSET)) {
#else
    //if(debug_counter++ == 500) {
    if(0) {
#endif /* DEBUG_LOW_BATTERY_INDICATION */
      linkDisconnecting = TRUE;
    }
  }

  /* check voltage level and if it is low then stop sampling, send message and disconnect */
  void checkBattVoltageLevel(uint16_t battery_voltage) {
#ifndef DEBUG_LOW_BATTERY_INDICATION
    if(battery_voltage < (baseline_voltage-BATTERY_LOW_INDICATION_OFFSET)) {
#else
      //if(debug_counter++ == 500) {
      if(0) {
#endif /* DEBUG_LOW_BATTERY_INDICATION */
	linkDisconnecting = TRUE;
      }
    }
  }
  /* keep checking the voltage level of the battery until it drops below the offset */
  void monitorBattery() {
    uint16_t battery_voltage;
    if(current_buffer == 1) {
      battery_voltage = sbuf0[6];
    }
    else {
      battery_voltage = sbuf1[6];
    }
    if(need_baseline_voltage) {
      num_baseline_voltage_samples++;      
      if(num_baseline_voltage_samples <= TOTAL_BASELINE_BATT_VOLT_SAMPLES_TO_RECORD) {
	/* add this sample to the total so that an average baseline can be obtained */
	sum_batt_volt_samples += battery_voltage;
      }
      else {
	setBattVoltageBaseline();
	need_baseline_voltage = FALSE;
	call Leds.led0Off();
      }
    }
    else {
      checkBattVoltageLevel(battery_voltage);
    }
  }
#endif /* LOW_BATTERY_INDICATION */

  /* The MSP430 CPU is byte addressed and little endian */
  /* packets are sent little endian so the word 0xABCD will be sent as bytes 0xCD 0xAB */
  void preparePacket() {
    uint16_t crc;
    int16_t *p_packet, *p_ADCsamples;
    register uint8_t i;

    tx_packet[1] = FRAMING_BOF;
    tx_packet[2] = SHIMMER_REV1;
    tx_packet[3] = PROPRIETARY_DATA_TYPE;
    tx_packet[4]++; /* increment sequence number */

    tx_packet[7] = FIXED_PAYLOAD_SIZE;

    if(current_buffer == 1) {
      tx_packet[5] = timestamp0 & 0xff;
      tx_packet[6] = (timestamp0 >> 8) & 0xff;
    }
    else {
      tx_packet[5] = timestamp1 & 0xff;
      tx_packet[6] = (timestamp1 >> 8) & 0xff;
    }

    if(current_buffer == 0) {
      for(i = 0; i < 6; i++){
	*(tx_packet + 8 + i*2) = *(sbuf0 + i);      
	*(tx_packet + 9 + i*2) = *(sbuf0 + i) >> 8; 
      }
      current_buffer = 1;
    }
    else{
      for(i = 0; i < 6; i++){
	*(tx_packet + 8 + i*2) = *(sbuf1 + i); 
	*(tx_packet + 9 + i*2) = *(sbuf1 + i) >> 8;
      }
      current_buffer = 0;
    }

    /* debug stuff - capture battery voltage to monitor discharge */
#ifdef DEBUG_LOW_BATTERY_INDICATION
    if(current_buffer == 1) {
      tx_packet[18] = (sbuf0[6]) & 0xff;
      tx_packet[19] = ((sbuf0[6]) >> 8) & 0xff;
    }
    else {
      tx_packet[18] = (sbuf1[6]) & 0xff;
      tx_packet[19] = ((sbuf1[6]) >> 8) & 0xff;
    }
#endif /* LOW_BATTERY_INDICATION */

    crc = calc_crc(&tx_packet[2], (FIXED_PACKET_SIZE-FRAMING_SIZE));
    tx_packet[FIXED_PACKET_SIZE - 2] = crc & 0xff;
    tx_packet[FIXED_PACKET_SIZE - 1] = (crc >> 8) & 0xff;
    tx_packet[FIXED_PACKET_SIZE] = FRAMING_EOF;
  }

  task void sendSensorData() {
#ifdef LOW_BATTERY_INDICATION
    monitorBattery();
#endif /* LOW_BATTERY_INDICATION */

    //    atomic if(enable_sending) {
    preparePacket();

      /* send data over the air */ 
    call Bluetooth.write(tx_packet + 1, FIXED_PACKET_SIZE);

      //      atomic enable_sending = FALSE;
      //}
  }

  task void startSensing() {
    call GyroInit.init();
    call GyroStdControl.start();
    call Magnetometer.enableBus();
    // six second pause here waiting for gyros to start up...

    call ActivityTimer.startPeriodic(1000);

    call Magnetometer.runContinuousConversion();

    call SampleTimer.startPeriodic(sample_freq);
  }

  task void sendPersonality() {
    atomic if(enable_sending) {
      /* send data over the air */
      call Bluetooth.write(&personality[0], 17);
      atomic enable_sending = FALSE;
    }
  }

  task void stopSensing() {
    call SetupTimer.stop();
    call SampleTimer.stop();
    call ActivityTimer.stop();
    call shimmerAnalogSetup.stopConversion();
    call DMA0.stopTransfer();
    // MAG STOP
    call Leds.led1Off();
    call GyroStdControl.stop();
    call Magnetometer.disableBus();
  }

  task void reallysendSensorData() {
    if(current_buffer == 1){
      call Bluetooth.write((uint8_t *)sbuf0, 22);
    }
    else{
      call Bluetooth.write((uint8_t *)sbuf1, 22);
    }
  }

  task void collect_results() {
    int16_t realVals[3];
    uint16_t heading;
    register uint8_t i;

    call Magnetometer.convertRegistersToData(readBuf, realVals);

    if(current_buffer == 0){
      for(i = 0; i < 3; i++)
	*(sbuf0 + i + 3) =  *(realVals + i);  
    }
    else{
      for(i = 0; i < 3; i++)
	*(sbuf1 + i + 3) =  *(realVals + i);  
    }
    
    post sendSensorData();
  }

  task void clockin_result(){
    call Magnetometer.readData();
  }

  async event void Magnetometer.readDone(uint8_t * data, error_t success){
    //    call GyroMagBoard.ledToggle();
    memcpy(readBuf, data, 7);
    post collect_results();
  }
  
  async event void Magnetometer.writeDone(error_t success){
  }

  async event void Bluetooth.connectionMade(uint8_t status) { 
    //post startSensing();
    atomic enable_sending = TRUE;

    call Leds.led2On();
  }

  async event void Bluetooth.commandModeEnded() { 
    atomic command_mode_complete = TRUE;
  }
    
  async event void Bluetooth.connectionClosed(uint8_t reason){
    atomic enable_sending = FALSE;    
    call Leds.led2Off();
    post stopSensing();
  }

  task void startConfigTimer() {
    call SetupTimer.startPeriodic(5000);
  }

  async event void Bluetooth.dataAvailable(uint8_t data){
    /* start capturing on ^G */
    if(7 == data) {
      atomic if(command_mode_complete) {
	post startSensing();
      }
      else {
	/* give config a chance, wait 5 secs */
	post startConfigTimer();
      }
    }
    else if (data == 1) {
      post sendPersonality();
    }
    /* stop capturing on spacebar */
    else if (data == 32) {
      post stopSensing();
    }
    else { /* were done */ }
  }

  event void Bluetooth.writeDone(){
    atomic enable_sending = TRUE;

#ifdef LOW_BATTERY_INDICATION
    if(linkDisconnecting) {
      linkDisconnecting = FALSE;
      /* signal battery low to master and let the master disconnect the link */
      post sendBatteryLowIndication();
    }
#endif /* LOW_BATTERY_INDICATION */
  }

  event void SetupTimer.fired() {
    atomic if(command_mode_complete){
      call ActivityTimer.stop();
      post startSensing();
    }
  }

  event void ActivityTimer.fired() {
    atomic {
      /* toggle activity led every second */
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
    call shimmerAnalogSetup.triggerConversion();
    //post clockin_result();
  }

  async event void DMA0.transferDone(error_t success) {
    if(current_buffer == 0){
      call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)sbuf1, NBR_ADC_CHANS);
      atomic timestamp1 = call LocalTime.get();
      //      current_buffer = 1;
    }
    else { 
      call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)sbuf0, NBR_ADC_CHANS);
      atomic timestamp0 = call LocalTime.get();
      //current_buffer = 0;
    }
    post clockin_result();
  }

  async event void GyroBoard.buttonPressed() {
  }
}

