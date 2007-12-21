/*
 * Copyright (c) 2007 nxtmote project
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *  
 *   Neither the name of the nxtmote project nor the names of its
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
 * This Hal module implements the TinyOS 2.0 I2CPacket interface over
 * the AT91 I2C Hpl
 *
 * @author Rasmus Ulslev Pedersen
 * note: Derived from imote files and LEGO files
 */

#include <I2C.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define   I2CClk                        400000L
#define   TIME400KHz                    (((OSC/16L)/(I2CClk * 2)) + 1)
#define   CLDIV                         (((OSC/I2CClk)/2)-3)
#define   DISABLEI2cIrqs 								0x000001C7

module HalAT91I2CMasterP
{
  provides interface Init;
  provides interface I2CPacket<TI2CBasicAddr>;

  uses interface HplAT91I2C as I2C;

  uses interface HplAT91_GPIOPin as I2CSCL;
  uses interface HplAT91_GPIOPin as I2CSDA;
  
  uses interface HalLCD;
  
}

implementation
{

  // These states don't necessarily reflect the state of the I2C bus, rather the state of this
  // module WRT an operation.  I.E. the module might be in STATE_IDLE, but the I2C bus still
  // held by the master for a continued read.
  enum {
    I2C_STATE_IDLE,
    I2C_STATE_READSTART,
    I2C_STATE_READ,
    I2C_STATE_READEND,
    I2C_STATE_WRITE,
    I2C_STATE_WRITEEND,
    I2C_STATE_ERROR
  };

  uint8_t mI2CState;
  uint16_t mCurTargetAddr;
  uint8_t *mCurBuf, mCurBufLen, mCurBufIndex;
  i2c_flags_t mCurFlags;
  //uint32_t mBaseICRFlags;
  uint32_t mAllIrqFlags;
  
  static void waitclk(){
    uint32_t PitTmr;

    PitTmr = (*AT91C_PITC_PIIR & AT91C_PITC_CPIV) + TIME400KHz;
    if (PitTmr >= (*AT91C_PITC_PIMR & AT91C_PITC_CPIV))
    {
      PitTmr -= (*AT91C_PITC_PIMR & AT91C_PITC_CPIV);
    }

    while ((*AT91C_PITC_PIIR & AT91C_PITC_CPIV) < PitTmr);
    
  
  }

  static void readNextByte() {
//if(mCurBufIndex == 12){
//sprintf((char *)lcdstr,"r:%u:%u", (unsigned int)mCurBufIndex, (unsigned int)mCurBufLen);
//call HalLCD.displayString(lcdstr, 2);
//togglepin(0);
//}
    if (mCurBufIndex >= (mCurBufLen - 1)) {
      atomic { mI2CState = I2C_STATE_READEND; }
      if (mCurFlags & I2C_STOP) {
	      //call I2C.setTWICR(AT91C_TWI_STOP);
//sprintf((char *)lcdstr,"stop");
//call HalLCD.displayString(lcdstr, 2);
//togglepin(0);		      
	      *AT91C_TWI_CR = AT91C_TWI_STOP;
      }
      //TODO: What if STOP is not set
    }
    else {
      atomic { mI2CState = I2C_STATE_READ; }
    }
    mCurBuf[mCurBufIndex-1] = *AT91C_TWI_RHR;
    return;
  }

  static void writeNextByte() {
    if (mCurBufIndex >= mCurBufLen) {
      atomic { mI2CState = I2C_STATE_WRITEEND; }
 
      if (mCurFlags & I2C_STOP) {
      	*AT91C_TWI_CR = AT91C_TWI_STOP; //because it is not in the interrupthandler
      }
      
    }
    else {
      atomic { mI2CState = I2C_STATE_WRITE; }
    }
    return;
  }
  
  static error_t startI2CTransact(uint8_t nextState, uint16_t addr, uint8_t length, uint8_t *data, 
			   i2c_flags_t flags, bool bRnW) {
    error_t error = SUCCESS;
    //uint8_t tmpRnW;
    //uint8_t Tmp;
    //uint32_t PitTmr;
    
    if ((data == NULL) || (length == 0) || ((addr & 0xFF80) != 0)) { /* check that addr is not bigger than 7 bits */
      return EINVAL;
    }

    atomic {
      if (mI2CState == I2C_STATE_IDLE) {
				mI2CState = nextState;
				mCurTargetAddr = addr;
				mCurBuf = data;
				mCurBufLen = length;
				mCurBufIndex = 0;
				mCurFlags = flags;
      }
      else {
      	error = EBUSY;
      }
    }
    if (error) {
      return error;
    }

    if (flags & I2C_START) {
			if (bRnW){ //read
				ULONG Tmp;

				//call I2C.setTWIIDR(DISABLEI2cIrqs);
				
				*AT91C_TWI_IDR = 0x000001C7;
				
				/* Reset error flags */
				Tmp               = *AT91C_TWI_SR;
				Tmp               = *AT91C_TWI_RHR;
				Tmp               = Tmp;        /* Suppress warning */
				*AT91C_TWI_MMR    = (AT91C_TWI_MREAD | AT91C_TWI_IADRSZ_NO | (DEVICE_ADR << 16));
				*AT91C_TWI_CR     = AT91C_TWI_START | AT91C_TWI_MSEN;
				//Tmp               = *AT91C_TWI_SR;
				*AT91C_TWI_IER    = 0x000001C2;			
				
				
				//*AT91C_AIC_ICCR   = (1L<<AT91C_ID_TWI);            /* Clear AIC irq      */\
				//*AT91C_TWI_MMR      = (AT91C_TWI_MREAD | AT91C_TWI_IADRSZ_NO | (addr << 16)); /* no internal adr, write dir */
				//*AT91C_TWI_CR       = (AT91C_TWI_MSEN | AT91C_TWI_START);
				//*AT91C_TWI_IER      = 0x000001C2;  /* Enable RX related irq */    
				
				if(0)		
				{
					*AT91C_AIC_IDCR   = (1L<<AT91C_ID_TWI);
					//*AT91C_TWI_IDR = 0x000001C7;

					Tmp = *AT91C_TWI_SR;
					Tmp = *AT91C_TWI_RHR;
					Tmp = Tmp;
					//reset();                                  


					//AT91C_AIC_SVR[AT91C_ID_TWI] = (unsigned int)irqhandler;
					AT91C_AIC_SMR[AT91C_ID_TWI] = ((AT91C_AIC_PRIOR_HIGHEST) | (AT91C_AIC_SRCTYPE_INT_EDGE_TRIGGERED));
					*AT91C_AIC_IECR   = (1L<<AT91C_ID_TWI);               /* Enables AIC irq */\
					*AT91C_PIOA_ASR   = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* Sel. per. A     */\
					*AT91C_PIOA_PDR   = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* Sel. per on pins*/\
					*AT91C_PIOA_MDER  = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* Open drain      */\
					*AT91C_PIOA_PPUDR = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* no pull up      */\
					*AT91C_TWI_CWGR   = (CLDIV | (CLDIV << 8));    	  
					*AT91C_AIC_ICCR   = (1L<<AT91C_ID_TWI);
					*AT91C_TWI_CR     = (AT91C_TWI_MSEN | AT91C_TWI_START);
					Tmp               = *AT91C_TWI_SR;
				}
			}
			else
			{ //write
				ULONG Tmp;

				//call I2C.setTWIIDR(DISABLEI2cIrqs);
				*AT91C_TWI_IDR = 0x000001C7;

				*AT91C_AIC_ICCR   = (1L<<AT91C_ID_TWI);            /* Clear AIC irq      */\
				*AT91C_TWI_MMR      = (AT91C_TWI_IADRSZ_NO | (addr << 16)); /* no internal adr, write dir */
				*AT91C_TWI_CR       = AT91C_TWI_MSEN;// | AT91C_TWI_START;
        *AT91C_TWI_IER      = 0x000001C4;  /* Enable TX related irq */\

				if(0){
					*AT91C_AIC_IDCR   = (1L<<AT91C_ID_TWI);

					//*AT91C_TWI_IDR = 0x000001C7;
					call I2C.setTWIIDR(DISABLEI2cIrqs);
					Tmp = *AT91C_TWI_SR;
					Tmp = *AT91C_TWI_THR;
					Tmp = Tmp;
					//reset();                                  
					*AT91C_AIC_ICCR   = (1L<<AT91C_ID_TWI);            /* Clear AIC irq      */\

					//AT91C_AIC_SVR[AT91C_ID_TWI] = (unsigned int)irqhandler;
					AT91C_AIC_SMR[AT91C_ID_TWI] = ((AT91C_AIC_PRIOR_HIGHEST) | (AT91C_AIC_SRCTYPE_INT_EDGE_TRIGGERED));
					*AT91C_AIC_IECR   = (1L<<AT91C_ID_TWI);               /* Enables AIC irq */\
					*AT91C_PIOA_ASR   = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* Sel. per. A     */\
					*AT91C_PIOA_PDR   = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* Sel. per on pins*/\
					*AT91C_PIOA_MDER  = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* Open drain      */\
					*AT91C_PIOA_PPUDR = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* no pull up      */\
					*AT91C_TWI_CWGR   = (CLDIV | (CLDIV << 8));    	  
					*AT91C_AIC_ICCR     = (1L<<AT91C_ID_TWI);
					*AT91C_TWI_CR       = AT91C_TWI_MSEN;// | AT91C_TWI_START;
					*AT91C_TWI_MMR      = (AT91C_TWI_IADRSZ_NO | (addr << 16)); /* no internal adr, write dir */

					*AT91C_TWI_IER      = 0x000001C4;  /* Enable TX related irq */
				}

			}
    }
    else if (bRnW) {
      atomic {
      	readNextByte();
      }
    }
    else {
      atomic {
      	writeNextByte();
      }
    }
    return error;
  }

  task void handleReadError() {
    call I2C.setTWICR(AT91C_TWI_STOP);
    call I2C.setTWICR(AT91C_TWI_SWRST);
    atomic {
      mI2CState = I2C_STATE_IDLE;
      signal I2CPacket.readDone(FAIL,mCurTargetAddr,mCurBufLen,mCurBuf);
    }
    return;
  }
    
  task void handleWriteError() {
    call I2C.setTWICR(AT91C_TWI_STOP);
    call I2C.setTWICR(AT91C_TWI_SWRST);
    atomic {
      mI2CState = I2C_STATE_IDLE;
      signal I2CPacket.writeDone(FAIL,mCurTargetAddr,mCurBufLen,mCurBuf);
    }
    return;
  }
  
  command error_t Init.init() {

    mAllIrqFlags = (AT91C_TWI_TXCOMP | AT91C_TWI_RXRDY | AT91C_TWI_TXRDY | AT91C_TWI_OVRE | AT91C_TWI_UNRE | AT91C_TWI_NACK);
    //atomic {
    if(1) {
      // Note: The AIC is addressed from the Hpl module
      *AT91C_AIC_IDCR   = (1L<<AT91C_ID_TWI);  
      call I2C.setTWIIDR(DISABLEI2cIrqs);
      *AT91C_AIC_ICCR   = (1L<<AT91C_ID_TWI);
      AT91C_AIC_SMR[AT91C_ID_TWI] = ((AT91C_AIC_PRIOR_HIGHEST) | (AT91C_AIC_SRCTYPE_INT_EDGE_TRIGGERED));      
      *AT91C_PMC_PCER  = (1L<<AT91C_ID_TWI);/* Enable TWI Clock        */
      *AT91C_AIC_IECR   = (1L<<AT91C_ID_TWI); 
      //call I2C.setTWIIDR(mAllIrqFlags);

			*AT91C_PIOA_ASR   = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* Sel. per. A     */\
			*AT91C_PIOA_PDR   = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* Sel. per on pins*/\
			*AT91C_PIOA_MDER  = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* Open drain      */\
			*AT91C_PIOA_PPUDR = (AT91C_PA4_TWCK | AT91C_PA3_TWD); /* no pull up      */\

/*    
      // TODO
      // Parameterized on AT91C_PA4_TWCK
      call I2CSCL.setPIOASR();
      call I2CSCL.setPIOPDR();
      call I2CSCL.setPIOMDER();
      call I2CSCL.setPIOPPUDR();
      
      // Parameterized on AT91C_PA3_TWD
      call I2CSDA.setPIOASR();
      call I2CSDA.setPIOPDR();
      call I2CSDA.setPIOMDER();
      call I2CSDA.setPIOPPUDR();
*/
      mI2CState = I2C_STATE_IDLE;
      
      call I2C.setTWICWGR(CLDIV | (CLDIV << 8));
      
      //call I2C.setTWIIER(mAllIrqFlags);
    }    

    return SUCCESS;
  }

  async command error_t I2CPacket.read(i2c_flags_t flags, uint16_t addr, uint8_t length, uint8_t* data) {
    error_t error = SUCCESS;

    if ((flags & I2C_ACK_END) && (flags & I2C_STOP)) {
      error = EINVAL;
      return error;
    }

    // AT91 does not allow for direct control of ACK or NACK bit
    if (flags & I2C_ACK_END) {
      error = EINVAL;
      return error;
    }

    if (flags & I2C_START) {
      error = startI2CTransact(I2C_STATE_READSTART,addr,length,data,flags,TRUE);
    }
    else {
      error = startI2CTransact(I2C_STATE_READ,addr,length,data,flags,TRUE);
    }
    
    return error;
  }

  async command error_t I2CPacket.write(i2c_flags_t flags, uint16_t addr, uint8_t length, uint8_t* data) {
    error_t error = SUCCESS;

    error = startI2CTransact(I2C_STATE_WRITE,addr,length,data,flags,FALSE);

    return error;
  }

  async event void I2C.interruptI2C() {
  
    uint32_t valTWISR;
    uint32_t tmpTWIErr;

    valTWISR = call I2C.getTWISR();
    tmpTWIErr = AT91C_TWI_OVRE | AT91C_TWI_UNRE | AT91C_TWI_NACK;
	
    atomic {
			switch (mI2CState) {
			case I2C_STATE_IDLE:
				// Should never get here. Reset all pending interrupts.
				break;

			case I2C_STATE_READSTART:
				if (valTWISR & tmpTWIErr) {
					mI2CState = I2C_STATE_ERROR;
					post handleReadError();
					break;
				}
				//mCurBuf[mCurBufIndex] = *AT91C_TWI_RHR;
				//mCurBuf[mCurBufIndex] = call I2C.getTWIRHR();
				mCurBufIndex++;				
				readNextByte();
				break;

			case I2C_STATE_READ:
if(0) {
				sprintf((char *)lcdstr,"six9");
				call HalLCD.displayString(lcdstr, 6);
				togglepin(0);			

}

				if (valTWISR & tmpTWIErr) {
				
				sprintf((char *)lcdstr,"error");
				call HalLCD.displayString(lcdstr, 5);
				togglepin(0);			
					mI2CState = I2C_STATE_ERROR;
					post handleReadError();
					break;
				}
				
//				mCurBuf[mCurBufIndex] = *AT91C_TWI_RHR;
				//mCurBuf[mCurBufIndex] = call I2C.getTWIRHR();
				mCurBufIndex++;
				readNextByte();
				break;

			case I2C_STATE_READEND:
//sprintf((char *)lcdstr,"end+");
//call HalLCD.displayString(lcdstr, 5);
//togglepin(0);			
				if (valTWISR & tmpTWIErr) {
					mI2CState = I2C_STATE_ERROR;
					post handleReadError();
					break;
				}
				//mCurBuf[mCurBufIndex] = call I2C.getTWIRHR();
				mCurBuf[mCurBufIndex] = *AT91C_TWI_RHR;
				mI2CState = I2C_STATE_IDLE;
				signal I2CPacket.readDone(SUCCESS,mCurTargetAddr,mCurBufLen,mCurBuf);
				break;

			case I2C_STATE_WRITE:
				if (valTWISR & tmpTWIErr) {
					mI2CState = I2C_STATE_ERROR;
					post handleWriteError();
					break;
				}
				*AT91C_TWI_THR = mCurBuf[mCurBufIndex];
				mCurBufIndex++;

				writeNextByte();
				break;

			case I2C_STATE_WRITEEND:
				if (valTWISR & tmpTWIErr) {
					mI2CState = I2C_STATE_ERROR;
					post handleWriteError();
					break;
				}
				mI2CState= I2C_STATE_IDLE;
				//call I2C.setICR(mBaseICRFlags);
				signal I2CPacket.writeDone(SUCCESS,mCurTargetAddr,mCurBufLen,mCurBuf);
				break;

			default:
				break;
			}
	  }

      
    return;
  }

  default async event void I2CPacket.readDone(error_t error, uint16_t addr, 
					     uint8_t length, uint8_t* data) {
    return;
  }

  default async event void I2CPacket.writeDone(error_t error, uint16_t addr, 
						     uint8_t length, uint8_t* data) { 
    return;
  }

  async event void I2CSDA.interruptGPIOPin() {}
  async event void I2CSCL.interruptGPIOPin() {}
}
