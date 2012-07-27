/*
 * Copyright (c) 2012, Shimmer Research, Ltd.
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
 * @author  Steve Ayer
 * @date    July, 2012
 */

#include "Mma_Accel.h"
#include "msp430usart.h"
//#include "Magnetometer.h"  don't need this unless we adjust outputrate

module ParamLoggingP {
  uses {
    interface Boot;

    interface FatFs;

    interface HplMsp430Usart as Usart;

    interface shimmerAnalogSetup;

    interface Msp430DmaChannel as DMA0;

    interface IDChip;

    interface Init as AccelInit;
    interface Mma_Accel as Accel;

    interface Init as GyroInit;
    interface StdControl as GyroStdControl;
    interface GyroBoard;

    interface Init as MagInit;
    interface Magnetometer;

    interface Init as GsrInit;
    interface Gsr;

    interface Init as StrainGaugeInit;
    interface StrainGauge;

    interface Time;
    interface Leds;

    interface Init as sampleTimerInit;
    interface Alarm<TMilli, uint16_t> as sampleTimer;
    interface Timer<TMilli> as warningTimer;
  }
}

implementation {
  extern int sprintf(char *str, const char *format, ...) __attribute__ ((C));
  extern int snprintf(char *str, size_t len, const char *format, ...) __attribute__ ((C));

  void do_stores();
  task void getSamplingConfig();
  char * fgets(char * buff, int len, FIL* fp);
  void busControlToMag();
  void busControlToSD();
  task void collect_results();

  uint8_t endo = 0;
  uint8_t stop_storage = 0, longAddress[8], directory_set, bad_opendir, bad_mkdir, NUM_ADC_CHANS = 0, justbooted;
  norace uint8_t current_buffer = 0, dma_blocks = 0;
  uint16_t sequence_number = 0, sample_period, dir_counter, fs_block_size, block_samples;
  int16_t sbuf0[512], sbuf1[512], * mag_slot;
  uint8_t dirname[128], filename[128], dir_hour = 0, idname[13], warning_count, doin_the_mag = 0, got_analog = 0, readBuf[8];
  uint8_t bytes_per_block, file_error;

  /*
   * flags to indicate which sensors are enabled:  accel, gyro, mag, ecg, emg, gsr, strain-gauge
   * file should be a list of name-value pairs, thus:
   * accel=1
   * gyro=1
   * mag=0
   * ecg=0
   * emg=0
   * gsr=0
   * str=0
   * sample_rate=50
   */
  uint8_t sensor_array[8];

  FATFS gfs;
  FIL gfp;
  DIR gdp;

  /*
   * to avoid overwriting old data files, each time the app starts (device reset)
   * this will establish a base directory consisting of four-character mac address (last four hex digits)
   * from the cc2420 radio, and a three digit counter, beginning with the last-seen value
   * on the card plus one.
   * e.g. IDe777-0000/
   * files will be written to this directory until reset in numerical order
   */
  error_t set_basedir() { 
    FILINFO gfi;
    error_t res;
    uint16_t tmp_counter = 0;
    char lfn[_MAX_LFN + 1], * fname, * scout, dirnum[8];

    // first we'll make the shimmer mac address into a string
    sprintf(idname, "ID%02x%02x", longAddress[4], longAddress[5]);

    gfi.lfname = lfn;
    gfi.lfsize = sizeof(lfn);

    if((res = call FatFs.opendir(&gdp, "/data"))){
      if(res == FR_NO_PATH)      // we'll have to make /data first
	res = call FatFs.mkdir("/data");
	
      if(res)         // in every case, we're toast
	return FAIL;

      // try one more time
      if((res = call FatFs.opendir(&gdp, "/data")))
	return FAIL;
    }

    dir_counter = 0;   // this might be the first log for this shimmer

    /*
     * file name format
     * ID             just a nmemonic
     * e777           last four of shimmer 12 hex-digit cc2420 mac address
     * -              separator
     * 000
     *
     * we want to create a new directory with a sequential run number each power-up/reset for each shimmer
     */
    while(call FatFs.readdir(&gdp, &gfi) == FR_OK){
      if(*gfi.fname == 0)
	break;
      else if(gfi.fattrib & AM_DIR){      
	fname = (*gfi.lfname) ? gfi.lfname : gfi.fname;

	if(!strncmp(fname, idname, 6)){      // their id prefix has just six chars
	  if((scout = strchr(fname, '-'))){   // if not, something is seriously wrong!
	    scout++;

	    strcpy(dirnum, scout);
	    tmp_counter = atoi(dirnum);
	    if(tmp_counter >= dir_counter){
	      dir_counter = tmp_counter;
	      dir_counter++;                   // start with next in numerical sequence
	    }
	  }
	  else
	    return FAIL;
	}
      }
    }

    // at this point, we have the id string and the counter, so we can make a directory name
    return SUCCESS;
  }

  error_t make_basedir() { 
    sprintf(dirname, "/data/%s-%03d", idname, dir_counter);

    if(call FatFs.mkdir(dirname))
      return FAIL;
    
    return SUCCESS;
  }

  task void store_contents() {
    uint bytesWritten;

    TOSH_MAKE_DOCK_N_OUTPUT();
    TOSH_SET_DOCK_N_PIN();

    if(doin_the_mag)
      busControlToSD();

    if(gfp.fptr > 1080000){                     // @ 50hz * three channels, one hour
      call Leds.led1Toggle();
      call FatFs.fclose(&gfp);                             // close this file
      do_stores();

      TOSH_MAKE_DOCK_N_OUTPUT();                // we need these because do_stores has its own output/input transition
      TOSH_SET_DOCK_N_PIN();
    }

    call Leds.led2On();

    if(current_buffer == 1){
      call FatFs.fwrite(&gfp, (uint8_t *)sbuf0, fs_block_size, &bytesWritten);
    }
    else{
      call FatFs.fwrite(&gfp, (uint8_t *)sbuf1, fs_block_size, &bytesWritten);    
    }
    call Leds.led2Off();

    call FatFs.fsync(&gfp);

    if(stop_storage){
      call FatFs.fclose(&gfp);                             // close this file
      stop_storage = 0;
    }
    
    /*
     * ugly way to poll dock, since we disabled driver's ability to get 
     * a hw interrupt.  better than blowing out the filesystem with a broken write
     * to disk.
     */
    TOSH_MAKE_DOCK_N_INPUT();
    atomic if(!TOSH_READ_DOCK_N_PIN()){
      call sampleTimer.stop();

      call Leds.led1On();
      /*
       * the next thing the apps sees should be 
       * an fatfs.available event.  unmount
       * will call diskiostdcontrol.init, which will
       * powercycle the card, put it in sd mode for the dock,
       * and re-initialize the interrupt
       */
      call FatFs.unmount();      
    }
    
    if(doin_the_mag)
      busControlToMag();
  }

  task void initialize_directories() {
    atomic directory_set = 1;

    bad_opendir = bad_mkdir = 0;

    TOSH_MAKE_DOCK_N_OUTPUT();
    TOSH_SET_DOCK_N_PIN();

    if(set_basedir() != SUCCESS)
      bad_opendir = 1;

    if(make_basedir() != SUCCESS)
      bad_mkdir = 1;

    TOSH_MAKE_DOCK_N_INPUT();
  }
  
  event void Boot.booted() {
    justbooted = 1;

    call sampleTimerInit.init();
    sample_period = 20;   // 50 hz

    // just a flag so we only do this once
    directory_set = 0;

    dma_blocks = 0;

    // we'll use this to id which shimmer wrote the files
    call IDChip.read(longAddress);

    call FatFs.mount(&gfs);
  }

  void busControlToSD(){
    call Usart.setModeSpi(&msp430_spi_default_config);

    call Usart.enableRxIntr();

    while(call Usart.isTxEmpty() == FALSE);

    TOSH_CLR_SD_CS_N_PIN();  
  }

  void busControlToMag(){
    TOSH_SET_SD_CS_N_PIN();  
    
    call Magnetometer.enableBus();
  }

  /*
   * simple function to erase mutually-exclusive selection errors
   * i.e., you can only have one daughter card at a time, so we
   * should eliminate selecting more than one input combo
   * note that accel can operate with any of these...
   */
  void errorCheckArray() {
    if(*(sensor_array + 1) || *(sensor_array + 2))    // gyro and/or mag board
      *(sensor_array + 3) = *(sensor_array + 4) = *(sensor_array + 5) = *(sensor_array + 6) = 0;
    else if(*(sensor_array + 3))  // ecg
      *(sensor_array + 4) = *(sensor_array + 5) = *(sensor_array + 6) = 0;
    else if(*(sensor_array + 4))  // emg
      *(sensor_array + 5) = *(sensor_array + 6) = 0;
    else if(*(sensor_array + 5))  // gsr
      *(sensor_array + 6) = 0;
  }

  void setSamplingConfig() { 
    register uint8_t i;
    
    errorCheckArray();
    for(i = 0; i < 7; i++){
      switch(i){
      case 0:
	if(*sensor_array){
	  call AccelInit.init();
	  call Accel.setSensitivity(RANGE_1_5G);
	  call shimmerAnalogSetup.addAccelInputs();
	  got_analog = 1;
	}
	break;
      case 1:
	if(*(sensor_array + 1)){
	  call GyroInit.init();
	  call GyroStdControl.start();
	  call shimmerAnalogSetup.addGyroInputs();
	  got_analog = 1;
	}
	break;
      case 2:
	if(*(sensor_array + 2)){
	  TOSH_SET_SD_CS_N_PIN();  
	  call MagInit.init();
	  call Magnetometer.runContinuousConversion();
	  __delay_cycles(1500);
	  busControlToSD();
	  doin_the_mag = 1;
	}
	break;
      case 3:
	if(*(sensor_array + 3)){
	  call shimmerAnalogSetup.addECGInputs();
	  got_analog = 1;
	}
	break;
      case 4:
	if(*(sensor_array + 4)){
	  call shimmerAnalogSetup.addEMGInput();
	  got_analog = 1;
	}
	break;
      case 5:
	if(*(sensor_array + 5)){
	  call GsrInit.init();
	  call shimmerAnalogSetup.addGSRInput();
	  got_analog = 1;
	}
	break;
      case 6:
	if(*(sensor_array + 6)){
	  call StrainGaugeInit.init();
	  call StrainGauge.powerOn();
	  call shimmerAnalogSetup.addStrainGaugeInputs();
	  got_analog = 1;
	}
	break;
      default:
	break;
      }
    }
    if(got_analog){
      call shimmerAnalogSetup.finishADCSetup(sbuf0);
      NUM_ADC_CHANS = call shimmerAnalogSetup.getNumberOfChannels();
    }
    
    if(doin_the_mag){
      bytes_per_block = NUM_ADC_CHANS * 2 + 6;
      mag_slot = sbuf0 + NUM_ADC_CHANS; 
    }
    else
      bytes_per_block = NUM_ADC_CHANS * 2;
    block_samples = 1024 / bytes_per_block;
    fs_block_size = block_samples * bytes_per_block;
  }
  
  char * fgets(char * buff, int len, FIL * fp) {
    uint16_t i = 0;
    char * p = buff;
    uint bytesRead;
    
    file_error = 0;
    while (i < len - 1) {			/* Read bytes until buffer gets filled */
      if(call FatFs.fread(fp, p, 1, &bytesRead)){
	file_error = 1;
	return NULL;
      }
      if(bytesRead != 1) 
	break;			/* Break when no data to read */

      if(*p == '\r') 
	continue;	/* Strip '\r' */

      i++;
      if (*p++ == '\n') 
	break;	/* Break when reached end of line */
    }
    *p = 0;
    return i ? buff : NULL;
  }

  event void warningTimer.fired() {
    warning_count++;

    switch(warning_count) {
    case 1:
    case 3:
      call Leds.set(0);
      call warningTimer.startOneShot(250);
      break;
    case 2:
    case 4:
      call Leds.set(7);
      call warningTimer.startOneShot(250);
      break;
    default:
      call Leds.set(0);
      break;
    }
  }

  
  task void configFailureWarning(){
    warning_count = 0;

    call Leds.set(7);
    //    call warningTimer.startOneShot(1000);
  }

  void setDefaultConfig() {
    *sensor_array = 1;   // accel only
    sample_period = 20;

    call shimmerAnalogSetup.addAccelInputs();
 
    call shimmerAnalogSetup.finishADCSetup(sbuf0);
    NUM_ADC_CHANS = call shimmerAnalogSetup.getNumberOfChannels();
    
    bytes_per_block = NUM_ADC_CHANS * 2;
    block_samples = 1024 / bytes_per_block;
    fs_block_size = block_samples * bytes_per_block;
  }

  uint8_t parseConfig() {
    char buffer[66], * equals;

    while(fgets(buffer, 64, &gfp)){
      if(file_error){
	call FatFs.fclose(&gfp);
	return 0;
      }
      if(!(equals = strchr(buffer, '=')))
	continue;
      equals++;     // this is the value
      if(strstr(buffer, "accel"))
	*sensor_array = atoi(equals);
      else if(strstr(buffer, "gyro"))
	*(sensor_array + 1) = atoi(equals);
      else if(strstr(buffer, "mag"))
	*(sensor_array + 2) = atoi(equals);
      else if(strstr(buffer, "ecg"))
	*(sensor_array + 3) = atoi(equals);
      else if(strstr(buffer, "emg"))
	*(sensor_array + 4) = atoi(equals);
      else if(strstr(buffer, "gsr"))
	*(sensor_array + 5) = atoi(equals);
      else if(strstr(buffer, "str"))
	*(sensor_array + 6) = atoi(equals);
      else if(strstr(buffer, "sample_rate"))
	sample_period = 1000 / atoi(equals);
    }
    call FatFs.fclose(&gfp);
    
    return 1;
  }

  task void getSamplingConfig() {
    uint16_t i;
    char configfile[32];

    sprintf(configfile, "/sample.cfg");

    call FatFs.disableDock();

    for(i = 0; i < 500; i++)
      TOSH_uwait(1000);

    if(call FatFs.fopen(&gfp, configfile, (FA_OPEN_EXISTING | FA_READ))){
      setDefaultConfig();
      post configFailureWarning();
    }
    else if(!parseConfig()){  // if this returns 0 the file has a glitch
      setDefaultConfig();
      post configFailureWarning();
    }
    else
      setSamplingConfig();

    call FatFs.enableDock();
  }
    
  task void stopEverything() {
    // this will kill writes after the current one finishes
    atomic stop_storage = 1;

    call sampleTimer.stop();

    call shimmerAnalogSetup.stopConversion();  //DMA0.ADCdisable();
    
    call Leds.set(0);

    call FatFs.fclose(&gfp);         // last chance to close the file if it's open
    call FatFs.disable();
  }

  event void Time.tick() {}

  void do_stores(){
    uint8_t r;

    sprintf(filename, "%s/%03d", dirname, sequence_number++);

    TOSH_MAKE_DOCK_N_OUTPUT();
    TOSH_SET_DOCK_N_PIN();

    r = call FatFs.fopen(&gfp, filename, (FA_OPEN_ALWAYS | FA_WRITE | FA_READ));

    TOSH_MAKE_DOCK_N_INPUT();

    if(r)
      call Leds.set(7);
    else
      call Leds.set(0);
  }
  
  task void clockin_result() {
    call Magnetometer.readData();
  }

  async event void sampleTimer.fired() {
    if(NUM_ADC_CHANS)
      call shimmerAnalogSetup.triggerConversion();
    else
      post clockin_result();

    call sampleTimer.start(sample_period);
  }

  task void collect_results() {
    *mag_slot = *(readBuf);
    *mag_slot <<= 8;
    *mag_slot += *(readBuf + 1);

    *(mag_slot + 1) = *(readBuf + 2);
    *(mag_slot + 1) <<= 8;
    *(mag_slot + 1) += *(readBuf + 3);

    *(mag_slot + 2) = *(readBuf + 4);
    *(mag_slot + 2) <<= 8;
    *(mag_slot + 2) += *(readBuf + 5);

    if(!NUM_ADC_CHANS){
      dma_blocks++;
      mag_slot += (bytes_per_block >> 1);
      if(dma_blocks == block_samples){
	dma_blocks = 0;

	if(current_buffer == 0){
	  mag_slot = sbuf1; 
	  current_buffer = 1;
	}
	else { 
	  mag_slot = sbuf0; 
	  current_buffer = 0;
	}
	post store_contents();
      }
    }
    else{
      if(endo){
	if(current_buffer == 0)
	  mag_slot = sbuf0 + NUM_ADC_CHANS; 
	else
	  mag_slot = sbuf1 + NUM_ADC_CHANS; 
	endo = 0;
	post store_contents();
      }
      else
	mag_slot += (bytes_per_block >> 1);
    }
  }

  async event void Magnetometer.readDone(uint8_t * data, error_t success){
    memcpy(readBuf, data, 6);
    post collect_results();
  }

  async event void DMA0.transferDone(error_t success) {
    dma_blocks++;
    atomic DMA0DA += bytes_per_block;

    if(doin_the_mag)
      post clockin_result();

    if(dma_blocks == block_samples){
      dma_blocks = 0;
      endo = 1;
      if(current_buffer == 0){
	call DMA0.repeatTransfer((void *)ADC12MEM0_, (void *)sbuf1, NUM_ADC_CHANS);
	current_buffer = 1;
      }
      else { 
	call DMA0.repeatTransfer((void *)ADC12MEM0_, (void *)sbuf0, NUM_ADC_CHANS);
	current_buffer = 0;
      }
      if(!doin_the_mag)
	post store_contents();
    }
  }

  task void rollTheBall() {
    uint16_t i;

    for(i = 0; i < 500; i++)
      TOSH_uwait(1000);

    do_stores();
    
    if(doin_the_mag)
      busControlToMag();
    call sampleTimer.start(sample_period);
  }

  task void dock_check() {
    call sampleTimer.stop();
  }

  async event void FatFs.mediaAvailable() {
    if(justbooted){
      justbooted = 0;
      post getSamplingConfig();
    }
    if(!stop_storage && !directory_set){
      post initialize_directories();
      if(bad_opendir || bad_mkdir){
	call Leds.set(7);
	return;
      }
    }
    call Leds.led1Off();
    post rollTheBall();
  }
  
  async event void FatFs.mediaUnavailable() {
    post dock_check();

    call Leds.led1On();
  }

  async event void Magnetometer.writeDone(error_t success){
  }

  async event void GyroBoard.buttonPressed() {
  }

}
