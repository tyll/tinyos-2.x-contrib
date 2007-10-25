/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
*
*  $Id$
* 
*/

#include "msp430baudrates.h"
#include "DSNBoot.h"

module DSNBootP
{
	uses interface Leds;
	uses interface Init;
	uses interface Init as InitLeds;
	uses interface HplMsp430Usart as UsartControl;
	uses interface HplMsp430UsartInterrupts as Interrupt;
	uses interface Resource;
	uses interface HplMsp430GeneralIO as BootPin;
	uses interface HplMsp430GeneralIO as TxPin;
}
implementation
{
	uint8_t rxBuffer[265];
	// 2 device family type 12 internal use, 2 version
	uint8_t buffer[22]={0x80,0xff,0x10,0x10,0xf1,0x6c,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x5a,0x9f,0x26};
	uint16_t dummy;
	uint16_t rxLen;
	uint16_t frameLength;
	uint16_t writeAddr=0;
	bool receiving=FALSE;
	bool bslConnected=FALSE;
	uint16_t crc;
	
	void initUart()	{
		call UsartControl.setClockSource(SSEL_SMCLK); 						// ACLK
		call UsartControl.setClockRate(UBR_SMCLK_9600, UMCTL_SMCLK_9600);
		call UsartControl.setModeUART();
		call UsartControl.enableUART();
	}
	
	void initUart38400()	{
		call UsartControl.disableUART();
		call UsartControl.setClockSource(SSEL_SMCLK); 						// SMCLK
		call UsartControl.setClockRate(UBR_SMCLK_38400, UMCTL_SMCLK_38400);
		call UsartControl.setModeUART();
		call UsartControl.enableUART();
	}
	
	uint16_t getCRC(uint8_t * b, uint16_t len)	{
		uint8_t i;
		uint8_t lo;
		uint8_t hi;
		if (len % 2!=0)
			return 0;
		lo=0; hi=0;
		for (i=0;i<(len-2)/2;i++) {
			lo=lo^b[i*2];
			hi=hi^b[i*2+1];
		}
		return (lo | (hi << 8))^0xffff;
	}
	
	void unlockFlash() {
	// unlock flash and set programing frequency
		FCTL2 = FWKEY + FSSEL1 + FN1;	// SMCLK / 5 -> 1285 kHz < SMCLK < 2380 kHz, SMCLK ~ 1Mhz
		FCTL3 = FWKEY;					// clear lock
    	FCTL1 = FWKEY + WRT;			// enable write
	}
		
	void lockFlash() {
		FCTL1 = FWKEY;					// disable write
      	FCTL3 = FWKEY + LOCK;			// lock flash
	}
	
	error_t write(uint16_t addr, uint8_t* buf) {
		// len must be always 2
		volatile uint16_t *flashAddr = (uint16_t*)(uint16_t)addr;
	    uint16_t *wordBuf = (uint16_t*)buf;
	    if ((addr > DSN_BOOT_LAST_SEGMENT) | (addr < DSN_BOOT_START)) {
	    	if ((uint16_t)flashAddr != RESET_ADDR)
				*flashAddr = wordBuf[0];
			else
				*flashAddr = DSN_BOOT_START;
			return SUCCESS;
	    }
	    else
	    	return FAIL;
	} 

/*	
	error_t write(uint16_t addr, uint8_t* buf, uint16_t len) {
	    volatile uint16_t *flashAddr = (uint16_t*)(uint16_t)addr;
	    uint16_t *wordBuf = (uint16_t*)buf;
    	uint16_t i = 0;

		* len and addr is even by definition of the bsl protocol 
		* (see slaa089c.pdf "Features of the MSP430 Bootstrap Loader")
    	*
	    * len is 16 bits so it can't be larger than 0xffff
    	* make sure we can't wrap around
    	* make sure we can't override the bootloader
    	*
    	* Writing a word lasts about 35/300kHz = 117 us
    	* Writing 250 bytes lasts about 13ms

	    if ((addr < (0xffff - (len >> 1))) & ((addr > DSN_BOOT_LAST_SEGMENT) | (addr < DSN_BOOT_START))) {
    		FCTL2 = FWKEY + FSSEL1 + FN1;
			FCTL3 = FWKEY;
    	  	FCTL1 = FWKEY + WRT;
	      	for (i = 0; i < (len >> 1); i++, flashAddr++) {
				if ((uint16_t)flashAddr != RESET_ADDR)
			  		*flashAddr = wordBuf[i];
				else
			  		*flashAddr = DSN_BOOT_START;
      		}
      		FCTL1 = FWKEY;
      		FCTL3 = FWKEY + LOCK;
      		return SUCCESS;
    	}
    	else
    		return FAIL;
    }
*/
    
    error_t erase(uint16_t addr) {
   		volatile uint16_t *flashAddr = (uint16_t*)(uint16_t)addr;
    	if ((addr > DSN_BOOT_LAST_SEGMENT) | (addr < DSN_BOOT_START)) {		// do not allow to erase the bootloader
    		FCTL2 = FWKEY + FSSEL1 + FN1;		// SMCLK / 5 -> 1285 kHz < SMCLK < 2380 kHz, SMCLK ~ 1Mhz
			FCTL3 = FWKEY;						// clear lock
    	  	FCTL1 = FWKEY + ERASE;				// enable segment erase
	      	*flashAddr = 0; 					// dummy write in this segment. starts erase. next instruction is executed after erase done
    		FCTL3 = FWKEY + LOCK;				// set lock
      		if (addr > DSN_BOOT_LAST_SEGMENT) {	// if reset vector is erased, set it again to the startaddress of the bootloader
      			dummy=DSN_BOOT_START;
      			unlockFlash();
      			write(RESET_ADDR, (uint8_t *)&dummy);
      			lockFlash();
      		}
      		return SUCCESS;
    	}
    	else
    		return FAIL;
    }
	
	void reboot() { 
		// illegal value at WDTCTL resets the msp
		WDTCTL = 0;
	}
	
	void txByte(uint8_t b) {
		call UsartControl.tx(b);
	}
	
	void bsl_ack() {
		txByte(0x90);
	}
	
	void bsl_nack()	{
		txByte(0xa0);
	}
	
	void txByteWait(uint8_t b)	{
		while (!call UsartControl.isTxEmpty());
		txByte(b);
	}
	
	void txBuffer(uint8_t * mybuffer, uint8_t len) {
		uint8_t i;
		for (i=0;i<len;i++)	{
			txByteWait(mybuffer[i]);
		}
	}
	
	void run() {
		// call the main program at default startaddress
    	typedef void __attribute__((noreturn)) (*tosboot_exec)();
	    ((tosboot_exec)DSN_BOOT_PROGRAM_SEGMENT)(); 
	}
    
    void massErase ()
    {
	    uint16_t i;
	    // erase every segment of code memory
	    // erase() won't remove the bootloader
    	for (i=0; i<96; i++)
    	{
    		erase( 0x4000 + i*0x200);
    	}    
    	// erase information memory
   		erase( 0x1000);
		erase( 0x1080);    	
    }
    
    void addCRC(uint8_t * mybuffer, uint16_t len){
		uint16_t mycrc;
		mycrc = getCRC(mybuffer, len);
		mybuffer[len]=(uint8_t)mycrc;
		mybuffer[len+1]=mycrc >> 8;
    }
    
    void txData(uint16_t addr, uint16_t len) {
	    volatile uint16_t *flashAddr = (uint16_t*)(uint16_t)addr;
		uint16_t i;
		uint8_t crc_lo, crc_hi;
		
		txByteWait(0x80); // hdr
		txByteWait(0xff); // dummy
		txByteWait((uint8_t)len); // len
		txByteWait((uint8_t)len); // len

		crc_lo=0xff^0x80^((uint8_t)len);
		crc_hi=(uint8_t)len;
		
		for (i=0;i<(len >> 1);i++,flashAddr++) {
			if ((uint16_t)flashAddr==RESET_ADDR) {
				txByteWait((uint8_t)DSN_BOOT_PROGRAM_SEGMENT);
				txByteWait((uint8_t)(DSN_BOOT_PROGRAM_SEGMENT >> 8));
				crc_lo^=(uint8_t)DSN_BOOT_PROGRAM_SEGMENT;
				crc_hi^=(uint8_t)(DSN_BOOT_PROGRAM_SEGMENT >> 8);
			}
			else {
				txByteWait((uint8_t)(*flashAddr));
				txByteWait((uint8_t)((*flashAddr) >> 8));
				crc_lo^=(uint8_t)(*flashAddr);
				crc_hi^=(uint8_t)((*flashAddr) >> 8);		
			}
		}
		txByteWait(crc_lo); // crc
		txByteWait(crc_hi);
	}

    error_t eraseCheck(uint16_t addr, uint16_t len) {
    	volatile uint16_t *flashAddr = (uint16_t*)(uint16_t)addr;
		uint16_t i;

		for (i=0;i<(len >> 1);i++,flashAddr++) {
			if (*flashAddr!=0xffff)
				return FAIL;
		}
		return SUCCESS;
    }
    
    error_t verify(uint16_t addr, uint8_t* buf, uint16_t len) {
    	volatile uint16_t *flashAddr = (uint16_t*)(uint16_t)addr;
    	uint16_t *wordBuf = (uint16_t*)buf;
		uint16_t i;

		for (i=0;i<(len >> 1);i++,flashAddr++) {
			if ((uint16_t)flashAddr==RESET_ADDR) {
				if (*flashAddr!=DSN_BOOT_START)
					return FAIL;
			}
			else {
				if (*flashAddr!=wordBuf[i])
					return FAIL;
			}
		}
		return SUCCESS;
    }
    
    void checkId()
	{
		 volatile uint16_t *flashAddr;
		 flashAddr=(uint16_t*)ID_ADDR;
		 if (*flashAddr==0xffff) {
		 	unlockFlash();
		 	write(ID_ADDR, (uint8_t *)&TOS_NODE_ID);
		 	lockFlash();
		 }
	}
	
	/**
	*
	* Main routine.
	* At every startup, the uart is polled a few times. if no input is given, normal startup is
	* performed.
	*/
	
	int main() __attribute__ ((C, spontaneous)) {
	    
	    call BootPin.makeInput();
	  
		if (! call BootPin.get())
		{
			checkId();
			run();
		}
		
		// bootloader in bsl mode
	    __nesc_disable_interrupt();
	    call Init.init();
		call InitLeds.init();
	    call Leds.led0On();

		initUart();
	    call Leds.led0Off();
			
		while (TRUE)
		{
			// poll uart rx
		   	if (IFG1 & URXIFG0){
				IFG1 &= ~URXIFG0;
				if (receiving)
				{
					rxBuffer[rxLen++]=U0RXBUF;
					if (rxLen==4)
					{
						frameLength=rxBuffer[rxLen-1]+6;
					}
					if (rxLen==10 && rxBuffer[1]==BSL_RX_DATA)
					{	// start online writing
						writeAddr=rxBuffer[4] | (rxBuffer[5] << 8);
						unlockFlash();
					}
					if ((writeAddr>0) & ((rxLen % 2) == 0) & (rxLen <= frameLength-2)) {
						write(writeAddr, &(rxBuffer[rxLen-2]));
						writeAddr+=2;
					}
					if (rxLen==frameLength)
					{	// whole frame arrived
						receiving=FALSE;
						// crc check and valid len
						crc=getCRC(rxBuffer, rxLen);
						if ((rxBuffer[rxLen-2]==((uint8_t)crc)) &
							(rxBuffer[rxLen-1]==(crc>>8)) &
							(rxBuffer[2]==rxBuffer[3]))
						{
							// take action
							switch( rxBuffer[1] ) {
							case BSL_RX_DATA:
							    call Leds.led2Off();
   							    call Leds.led0On();
   							    lockFlash();
   							    writeAddr=0;
   							    if (verify(rxBuffer[4] | (rxBuffer[5] << 8), &rxBuffer[8], rxBuffer[6])==SUCCESS)
									bsl_ack();
								else
									bsl_nack();
								break;
							case BSL_ERASE_SEGMENT:
								if (erase(rxBuffer[4] | (rxBuffer[5] << 8))==SUCCESS)
									bsl_ack();
								else
									bsl_nack();
								break;
							case BSL_MASS_ERASE:	// pseudo mass erase: everything but the bootloader is erased
   							    call Leds.led2On();
							    massErase();
   							    bsl_ack();
								break;
							case BSL_LOAD_PC:		// for tests. just starts the loaded programm at default address...
								bsl_ack();
								checkId();
								run();
								break;
							case BSL_RX_PWD:
								bsl_ack();
								break;
							case BSL_TX_BSLVERSION:
								txBuffer(buffer, 22);
								break;
							case BSL_TX_DATA:
							    call Leds.led0Off();
   							    call Leds.led1On();
								txData(rxBuffer[4] | (rxBuffer[5] << 8), (uint16_t)rxBuffer[6]);
								break;
							case BSL_ERASE_CHECK:
								if (eraseCheck(rxBuffer[4] | (rxBuffer[5] << 8), rxBuffer[6] | (rxBuffer[7] << 8))==SUCCESS)
									bsl_ack();
								else
									bsl_nack();
							case BSL_CHANGE_BAUDRATE:
								/*
								BCSCTL1 = RSEL0 | RSEL1 | RSEL2 | XT2OFF;
								DCOCTL = DCO0 | DCO1 | DCO2;
								D1: F1xx: Basic clock module control register DCOCTL (DCO.2  DCO.0)
								D2: F1xx: basic clock module control register BCSCTL1 (XT2Off, Rsel.2  Rsel.0)
								D3: 0: 9600 Baud,1: 19200 Baud,2: 38400 Baud
								*/
								if (rxBuffer[6]==2) {
									bsl_ack();
									while (!call UsartControl.isTxEmpty());
									initUart38400();
								}
								else
									bsl_nack();
							default:
								// command not available
								bsl_nack(); 
							}						
						}
						else
						{
							// signal erroneous frame
							bsl_nack(); 
						}
						bslConnected=FALSE;
					}
				}
				else if (U0RXBUF==0x80) {
					if (bslConnected)	{
						rxBuffer[0]=0x80;
						rxLen=1;
						frameLength=0;
						receiving=TRUE;
					}
					else {
						bslConnected=TRUE;
						bsl_ack();
					}
				}
			}
		}
	}
	
	// this functions are needed because of interface definitions
	// they're never called because no hardware interrupts are activated
	async event void Interrupt.txDone()
  	{}

	async event void Interrupt.rxDone(uint8_t data)
	{}

	event void Resource.granted()
	{}
}
