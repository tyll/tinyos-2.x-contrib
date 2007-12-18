/*
 * Copyright (c) 2007 Copenhagen Business School
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
 * - Neither the name of CBS nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Test of I2C.
 *
 * @author Rasmus Ulslev Pedersen
 */

#include "I2C.h"
#include "LCD.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define   DEVICE_ADR                    0x01
#define   COPYRIGHTSTRING               "Let's samba nxt arm in arm, (c)LEGO System A/S"
#define   COPYRIGHTSTRINGLENGTH         46    /* Number of bytes checked in COPYRIGHTSTRING */

//Motor test
//#define   BYTES_TO_TX                   8
#define   NO_TO_TX   			BYTES_TO_TX + 1
#define   NO_TO_RX				BYTES_TO_RX + 1

//Sizes (in bytes) of each scalar type
#define SIZE_UBYTE 1
#define SIZE_SBYTE 1
#define SIZE_UWORD 2
#define SIZE_SWORD 2
#define SIZE_ULONG 4
#define SIZE_SLONG 4

module TestI2CM
{
  provides interface Init;
  
  uses {
    interface I2CPacket<TI2CBasicAddr>;
    //uses interface HplAT91I2C;

    interface Boot;
    
    interface HplAT91Pit as PitTimer;
    
    interface HalLCD;
    
    interface Init as SubInit;
  }
}

implementation
{
  uint8_t I2cInBuffer[NO_TO_RX];

  uint8_t I2cOutBuffer[NO_TO_TX];
  uint8_t CopyrightStr[] =        {"\xCC"COPYRIGHTSTRING};
  uint8_t booted = 0;
  uint8_t tmp = 0;
  uint32_t cnt = 0;
  
  UBYTE State;

  event void Boot.booted(){
    uint8_t tmptemp = 1;  
  }

  command error_t Init.init() {
    State = 0;
    call SubInit.init(); //I2CMasterP
    booted = 1;

    return SUCCESS;
  }
  
  async event void PitTimer.fired(){
    //post cPitTask();
	}
  
  //async event void HplAT91I2C.interruptI2C(){}

  async event void I2CPacket.readDone(error_t error, uint16_t addr, 
					     uint8_t length, uint8_t* data) {
  IOFROMAVR *pIoFromAvr;
		if((cnt % 100) == 0){
			pIoFromAvr = (IOFROMAVR*) data;
			sprintf((char *)lcdstr,"s:%u",pIoFromAvr->AdValue[0]);
			call HalLCD.displayString(lcdstr, 1);
			sprintf((char *)lcdstr,"s:%u",pIoFromAvr->AdValue[1]);
			call HalLCD.displayString(lcdstr, 2);			
			sprintf((char *)lcdstr,"s:%u",pIoFromAvr->AdValue[2]);
			call HalLCD.displayString(lcdstr, 3);			
			sprintf((char *)lcdstr,"s:%u",pIoFromAvr->AdValue[3]);
			call HalLCD.displayString(lcdstr, 4);			
			//togglepin(0);
		}

    return;
  }

  async event void I2CPacket.writeDone(error_t error, uint16_t addr, 
						     uint8_t length, uint8_t* data) { 
    return;
  }
  
  //task void cPitTask() {
  event void PitTimer.firedTask(uint32_t taskMiss){
    if(booted == 1)
    {
  		error_t error;
			uint16_t devAddr;
			uint8_t* mI2CBuffer;
			uint8_t len;
cnt++;
			switch(State)
			{
				case 0: //unlock
				{
					mI2CBuffer = CopyrightStr;
					devAddr = DEVICE_ADR;
					len = COPYRIGHTSTRINGLENGTH + 1;
					error = call I2CPacket.write(I2C_START | I2C_STOP, devAddr, len, mI2CBuffer);
					State++;
				}
				break;
				case 1: //wait
				{
					State++;
				}
				break;
				case 2: // tx
				{
					UBYTE I2cTmp, Sum, *pIrq, NoToTx;
					
					IoToAvr.Power 	= 0;
					IoToAvr.PwmFreq 	= 0;
					IoToAvr.PwmValue[0] = 0;
					IoToAvr.PwmValue[1] = 0;
					IoToAvr.PwmValue[2] = 0;
					IoToAvr.PwmValue[3] = 0;
					IoToAvr.OutputMode  = 0;
					IoToAvr.InputPower  = 0;

					pIrq = (uint8_t*)&IoToAvr;
					
					for(I2cTmp = 0, Sum = 0; I2cTmp < BYTES_TO_TX; I2cTmp++, pIrq++)
					{
						I2cOutBuffer[I2cTmp] = *pIrq;
						Sum += *pIrq;
					}

					I2cOutBuffer[I2cTmp] = ~Sum;
					pIrq                = I2cOutBuffer;
					NoToTx              = NO_TO_TX;
					devAddr = DEVICE_ADR;

					error = call I2CPacket.write(I2C_START | I2C_STOP, devAddr, NoToTx, pIrq);
tmp = 1;
					State++;
					State++;
				}
				break;
				case 3: //wait
				{
					State++;
				}
				break;				
				case 4: //rx
				{
					UBYTE NoToRx;
					mI2CBuffer = I2cInBuffer;
					devAddr = DEVICE_ADR;
					NoToRx = NO_TO_RX;

					error = call I2CPacket.read(I2C_START | I2C_STOP, devAddr, NoToRx, mI2CBuffer);
				
          State = 2;
				}
				break;				
				default:
				break;
			}
    }
  }
  
}
