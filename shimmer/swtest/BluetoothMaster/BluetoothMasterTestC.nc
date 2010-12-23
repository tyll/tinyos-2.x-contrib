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
 * Author: Steve Ayer, Mike Healy, Adrian Burns
 *         July, 2010
 *
 * port to tos-2.x
 * @author Steve Ayer
 * @date   December, 2010
 */

 /***********************************************************************************

   This master mode is useful when the device only wants to initiate connections (not
   receive them). In this mode the device will NOT be discoverable or connectable.

   At compile time you need to provide a Bluetooth Slave Address to connect to so do 
   "make BT_SLAVE=0011f6057c35 shimmer2" for example....
   where 0011f6057c35 is your Bluetooth device address

   Default Sample Frequency: 50 hz
   
   Packet Format:
         BOF| Sensor ID | Data Type | Seq No. | TimeStamp | Len | Acc | Acc  | Acc  | Gyro  | Gyro | Gyro |  CRC | EOF
   Byte:  1 |    2      |     3     |    4    |     5-6   |  7  | 8-9 | 10-11| 12-13| 14-15 | 16-17| 18-19| 20-21| 22

   Known Issues:
   When you program a Shimmer back to a slave mode firmware after using this master 
   mode firmware that it takes a second reset before the slave becomes discoverable.again.
   
 ***********************************************************************************/

#include "crc.h"
#include "BluetoothMasterTest.h"
#include "Mma_Accel.h"
#include "RovingNetworks.h"

module BluetoothMasterTestC {
  uses {
    interface Boot;
    interface Init as FastClockInit;
    interface Init as BluetoothInit;
    interface Init as AccelInit;
    interface Init as GyroInit;
    interface FastClock;
    interface Msp430DmaChannel as DMA0;
    interface StdControl as AccelStdControl;
    interface Mma_Accel as Accel;
    interface StdControl as GyroStdControl;
    interface GyroBoard;
    interface StdControl as BTStdControl;
    interface Bluetooth;    
    interface Leds;
    interface shimmerAnalogSetup;
    interface Timer<TMilli> as ConnectTimer;
    interface Timer<TMilli> as BluetoothMasterTestTimer;
    interface Timer<TMilli> as SampleTimer;
    interface LocalTime<T32khz>;
  }
} 

implementation {
  extern int sprintf(char *str, const char *format, ...) __attribute__ ((C));

  //#define USE_8MHZ_CRYSTAL
//#define LOW_BATTERY_INDICATION
#define USE_AVCC_REF /* approx 0.5 milliamps saving when using AVCC compared to 2.5V or 1.5V internal ref */

#define CONNECT_PERIOD 30720 /* 30s off 30s on  over and over again */
#define CONN_TIMEOUT   10240 /* shut down radio if we cant connect to a slave */

#ifdef LOW_BATTERY_INDICATION
  //#define DEBUG_LOW_BATTERY_INDICATION
  /* during testing of the the (AVcc-AVss)/2 value from the ADC on various SHIMMERS, to get a reliable cut off point 
     to recharge the battery it is important to find the baseline (AVcc-AVss)/2 value coming from the ADC as it varies 
     from SHIMMER to SHIMMER, however the range of fluctuation is pretty constant and (AVcc-AVss)/2 provides an accurate 
     battery low indication that prevents getting any voltage skewed data from the accelerometer or add-on board sensors */
  #define TOTAL_BASELINE_BATT_VOLT_SAMPLES_TO_RECORD 1000
  #define BATTERY_LOW_INDICATION_OFFSET 20 /* (AVcc - AVss)/2 = Approx 3V-0V/2 = 1.5V, 12 bit ADC with 2.5V REF,
                                              4096/2500 = 1mV=1.6384 units */ 
  bool need_baseline_voltage;
  uint16_t num_baseline_voltage_samples, baseline_voltage;
  uint32_t sum_batt_volt_samples;

#ifdef DEBUG_LOW_BATTERY_INDICATION
  #error "were going for debug mode yea?, comment me out then"
  uint16_t debug_counter;
#endif /* DEBUG_LOW_BATTERY_INDICATION */

#endif /* LOW_BATTERY_INDICATION */
  
  #define FIXED_PACKET_SIZE 22
  #define FIXED_PAYLOAD_SIZE 12
  uint8_t NUM_ADC_CHANS;  
  uint8_t tx_packet[(FIXED_PACKET_SIZE*2)+1]; /* (*2)twice size because of byte stuffing */
                                              /* (+1)MSP430 CPU can only read/write 16-bit values at even addresses, 
                                              /* so use an empty byte to even up the memory locations for 16-bit values */
  const uint8_t personality[17] = {
    0,1,2,3,4,5,0xFF,0xFF,
    SAMPLING_50HZ,SAMPLING_50HZ,SAMPLING_50HZ,SAMPLING_50HZ,
    SAMPLING_50HZ,SAMPLING_50HZ,SAMPLING_0HZ_OFF,SAMPLING_0HZ_OFF,FRAMING_EOF
  };

  norace uint8_t current_buffer = 0, dma_blocks = 0;
  uint16_t sbuf0[36], sbuf1[36], timestamp0, timestamp1;

  /* default sample frequency every time the sensor boots up */
  uint16_t sample_freq = SAMPLING_50HZ;

  bool enable_sending, command_mode_complete, activity_led_on, bluetooth_connected, link_disconnecting;

  /* Internal function to calculate 16 bit CRC */
  uint16_t calc_crc(uint8_t *ptr, uint8_t count) {
    uint16_t crc;
      crc = 0;
    while (count-- > 0)
      crc = crcByte(crc, *ptr++);

    return crc;
  }

  event void Boot.booted() {
    //    call FastClockInit.init();

    //    call FastClock.setSMCLK(1);  // want smclk to run at 1mhz

    atomic {
      memset(tx_packet, 0, (FIXED_PACKET_SIZE*2));
      enable_sending = FALSE;
      bluetooth_connected = command_mode_complete = activity_led_on = FALSE;
      dma_blocks = 0;
    }

    call shimmerAnalogSetup.addAccelInputs();
    call shimmerAnalogSetup.addGyroInputs();
    call shimmerAnalogSetup.finishADCSetup(sbuf0);

    NUM_ADC_CHANS = call shimmerAnalogSetup.getNumberOfChannels();

#ifdef LOW_BATTERY_INDICATION
    /* initialise baseline voltage measurement stuff */ 
    need_baseline_voltage = TRUE;
    num_baseline_voltage_samples = baseline_voltage = sum_batt_volt_samples = 0;

#ifdef DEBUG_LOW_BATTERY_INDICATION
    debug_counter = 0;
#endif /* DEBUG_LOW_BATTERY_INDICATION */
#endif /* LOW_BATTERY_INDICATION */

    /* takes 10s so do it here */    
    //    call GyroInit.init();
    /* after a few seconds connect */
    call BluetoothMasterTestTimer.startOneShot(5120);
  }

  /* if hw setup goes ok this will end up with in Bluetooth.commandModeEnded event */
  task void powerUpSystem() {
    call BluetoothInit.init();

    call AccelInit.init();

    call Bluetooth.disableRemoteConfig(TRUE);
    /* initiating a connection can be done in Slave or Matster mode */
    call Bluetooth.setRadioMode(MASTER_MODE);
    call BTStdControl.start();
  }  
  
  task void powerDownSystem() {
    call BTStdControl.stop();
  }

  task void sendMasterDisconnect() {
    call Bluetooth.disconnect();
  }

#ifdef LOW_BATTERY_INDICATION
  
  task void sendBatteryLowIndication() {
    uint16_t crc;
    char batt_low_str[] = "BATTERY LOW!";

    /* stop all sensing - battery is below the threshold */
    call SampleTimer.stop();
    call shimmerAnalogSetup.stopConversion();
    call DMA0.stopTransfer();
    call Accel.wake(FALSE);
    call Leds.led1Off();

    /* send the battery low indication packet to BioMOBIUS */
    tx_packet[1] = FRAMING_BOF;
    tx_packet[2] = SHIMMER_REV1;
    tx_packet[3] = STRING_DATA_TYPE;
    tx_packet[4]++; /* increment sequence number */ 
    tx_packet[5] = timestamp0 & 0xff;
    tx_packet[6] = (timestamp0 >> 8) & 0xff;
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
  }

  /* all samples are got so set the baseline voltage for this SHIMMER hardware */
  void setBattVoltageBaseline() {
    baseline_voltage = (sum_batt_volt_samples / TOTAL_BASELINE_BATT_VOLT_SAMPLES_TO_RECORD);
  }

  /* check voltage level and if it is low then stop sampling, send message and disconnect */
  void checkBattVoltageLevel(uint16_t battery_voltage) {
#ifndef DEBUG_LOW_BATTERY_INDICATION
    if(battery_voltage < (baseline_voltage-BATTERY_LOW_INDICATION_OFFSET)) {
#else
    if(debug_counter++ == 2500) {
#endif /* DEBUG_LOW_BATTERY_INDICATION */
      link_disconnecting = TRUE;
    }
  }

  /* keep checking the voltage level of the battery until it drops below the offset */
  void monitorBattery() {
    uint16_t battery_voltage;
    if(current_buffer == 1) {
      battery_voltage = sbuf0[4];
    }
    else {
      battery_voltage = sbuf1[4];
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
    uint16_t *p_packet, *p_ADCsamples, crc;
    
    tx_packet[1] = FRAMING_BOF;
    tx_packet[2] = SHIMMER_REV1;
    tx_packet[3] = PROPRIETARY_DATA_TYPE;
    tx_packet[4]++; /* increment sequence number */ 

    tx_packet[7] = FIXED_PAYLOAD_SIZE;

    p_packet = (uint16_t *)&tx_packet[8];
      
    if(current_buffer == 1) {
      p_ADCsamples = &sbuf0[0];
      tx_packet[5] = timestamp0 & 0xff;
      tx_packet[6] = (timestamp0 >> 8) & 0xff;
    }
    else {
      p_ADCsamples = &sbuf1[0];
      tx_packet[5] = timestamp1 & 0xff;
      tx_packet[6] = (timestamp1 >> 8) & 0xff;
    }
    /* copy all the data samples into the outgoing packet */
    *p_packet++ = *p_ADCsamples++; //tx_packet[8]
    *p_packet++ = *p_ADCsamples++; //tx_packet[10]
    *p_packet++ = *p_ADCsamples++; //tx_packet[12]
    *p_packet++ = *p_ADCsamples++; //tx_packet[14]
    *p_packet++ = *p_ADCsamples++; //tx_packet[16]
    *p_packet = *p_ADCsamples; //tx_packet[18]

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

    atomic if(enable_sending) {
      preparePacket();

      /* send data over the air */
      call Bluetooth.write(&tx_packet[1], FIXED_PACKET_SIZE);
      atomic enable_sending = FALSE;
    }
  }

  task void startSensing() {
    call GyroInit.init();
    call GyroStdControl.start();

    call Accel.setSensitivity(RANGE_6_0G);
    call Accel.wake(TRUE);

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
    call SampleTimer.stop();
    call shimmerAnalogSetup.stopConversion();
    call DMA0.stopTransfer();
    call Accel.wake(FALSE);
    call Leds.led1Off();
    call GyroStdControl.stop();
  }

  async event void Bluetooth.connectionMade(uint8_t status) { 
    call Leds.led2On();
    call ConnectTimer.stop();
    atomic enable_sending = bluetooth_connected = TRUE;
    post startSensing();
    call BluetoothMasterTestTimer.startOneShot(CONNECT_PERIOD);    
  }

  task void connectToSlave() {
    call Bluetooth.connect(BT_SLAVE_ADDRESS); //yellow airnet dongle
  }
  
  async event void Bluetooth.commandModeEnded() { 
    atomic command_mode_complete = TRUE;
    call ConnectTimer.startOneShot(CONN_TIMEOUT);
    post connectToSlave();
  }
    
  /* we can get here by us (Master) closing the connection or the 
     slave closing the connection */
  async event void Bluetooth.connectionClosed(uint8_t reason){
    call Leds.led2Off();
    atomic enable_sending = bluetooth_connected = FALSE;
  
    post stopSensing();
    post powerDownSystem();
    
    /* test app will connect again in 30 seconds */
    call BluetoothMasterTestTimer.startOneShot(CONNECT_PERIOD);
  }

  async event void GyroBoard.buttonPressed() { }

  async event void Bluetooth.dataAvailable(uint8_t data){
    /* start capturing on ^G */
    if(7 == data) {
      atomic if(command_mode_complete) {
        post startSensing();
      }
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
    if(link_disconnecting) {
      link_disconnecting = FALSE;
      /* signal battery low to master and let the master disconnect the link */
      post sendBatteryLowIndication();
    }
#endif /* LOW_BATTERY_INDICATION */

  }

  event void BluetoothMasterTestTimer.fired() {
    if(bluetooth_connected) {
      post stopSensing();
      /* connection will be closed and BT module will be turned off 
         when the connectionClosed event appears */
      post sendMasterDisconnect();
    }
    else {
      post powerUpSystem();
    }
  }

  event void SampleTimer.fired() {
    call shimmerAnalogSetup.triggerConversion();
  }

  event void ConnectTimer.fired() {
    /* connection failed so clean up */
    post stopSensing();
    post powerDownSystem();
  }

  async event void DMA0.transferDone(error_t success) {
    dma_blocks++;
    //atomic DMA0DA += 12;
    if(dma_blocks == 1){ //this should be about 6 but for this test its 1
      dma_blocks = 0;

      if(current_buffer == 0){
	call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)sbuf1, NUM_ADC_CHANS);
        atomic timestamp1 = call LocalTime.get();
	current_buffer = 1;
      }
      else { 
	call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)sbuf0, NUM_ADC_CHANS);
        atomic timestamp0 = call LocalTime.get();
	current_buffer = 0;
      }
      post sendSensorData();      
    }
  }
}

