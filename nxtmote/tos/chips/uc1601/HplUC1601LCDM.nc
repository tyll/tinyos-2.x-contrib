/*
 * Copyright (c) 2007 nxtmote project
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *  
 *   Neither the name of nxtmote project nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE ARCHED
 * ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
/**
 * Display module.
 * @author Rasmus Ulslev Pedersen
 */

#include "LCD.h"

module HplUC1601LCDM {
  provides {
    interface HplUC1601LCD as HplLCD;
    interface Init;
  }
  
  uses {
    interface HalAT91SPICntl as SpiControl;
    interface SpiPacket;
    interface HplAT91Pit as PitTimer;
  }
}

implementation {
  
  bool gfInitialized = FALSE;

  uint8_t tmpbuff[DISP_LINES][100];
  uint8_t llen[DISP_LINES];
  uint8_t dirty[DISP_LINES];
  
  error_t writespi(uint8_t* data, uint8_t len, uint8_t type) {
    while(!(*AT91C_SPI_SR & AT91C_SPI_TXEMPTY));
	 
	  if(type)
	    *AT91C_PIOA_SODR = AT91C_PIO_PA12; // type = 1 means DAT
	  else
	    *AT91C_PIOA_CODR = AT91C_PIO_PA12; // type = 0 means CMD
	    
		call SpiPacket.send((uint8_t*)data, rxbuf, len);
		
		// Give it time 
	  //{waitspin(10000);} //10000 ok
    
    return SUCCESS;
  }
  
  command error_t Init.init()
  {
    uint8_t i;
    
    bool initflag;
    atomic {
      initflag = gfInitialized;
      gfInitialized = TRUE;
    }

    if(!initflag) {
      memset(txbuf1, 0x00, sizeof(txbuf1));
      
      call SpiControl.setSPIParams();  
      
      for(i = 0; i < DISP_LINES; i++){
			  dirty[i] = 0;
			  llen[i] = 0;
			}
			
      // Give it time 
		  //{waitspin(100000);} //10000 ok
    }
    
    return SUCCESS;
  }
    
  
  command void HplLCD.initLCD() {
    uint32_t i;
    
    // Send init string
    writespi(initStr, sizeof(initStr), CMD);
    
    // Clear the 8 lines 
    for(i=0;i<DISP_LINES;i++) {
      call HplLCD.write(txbuf1,sizeof(txbuf1),i);
    }
  }

  command error_t HplLCD.writefast(uint8_t* data, uint8_t len, uint8_t line){
    error_t err;

  	if(line < DISP_LINES){
      writespi((uint8_t*)DisplayLineString[line],sizeof(DisplayLineString[line]),CMD);
      {waitspin(10000);}
      // Write the line data
      writespi(data, len, DAT);
      {waitspin(10000);}
      err = SUCCESS;
    }
    else {
      err = FAIL;
    }
    
    return err;
  }
  
  command error_t HplLCD.write(uint8_t* data, uint8_t len, uint8_t line){
    error_t err;
    
  	if(line < DISP_LINES){
      memcpy(tmpbuff[line], data, len);
      dirty[line] = 1;
      llen[line] = len;
      err = SUCCESS;
    }
    else {
      err = FAIL;
    }

		return err;
  }
  
  async event void SpiPacket.sendDone( uint8_t* txBuf, uint8_t* rxBuf, uint16_t len,
                             error_t error ) {
  }
  
  //task void cPitTask(){
  event void PitTimer.firedTask(uint32_t misses){
    uint8_t i;
    
    for(i = 0; i < DISP_LINES; i++){
      if(dirty[i] == 1) {
     	  // Tell display which line 
        writespi((uint8_t*)DisplayLineString[i],sizeof(DisplayLineString[i]),CMD);
        // Write the line data
        writespi(tmpbuff[i], llen[i], DAT);
        llen[i] = 0;
        dirty[i] = 0;
        break;
      }
    }
  }
  
  async event void PitTimer.fired(){
	    //post cPitTask();
	}
}
