/* Implementation of SPI communications between the ADE7753 power chip and the 
* msp430 microcontroller.
* Reading/writing registers on the chip, happens only after the SPI bus 
* resource has been successfully requested and granted
*
* This file also provides the Msp430SpiConfigure.getConfig() which
* sets the appropriate values of the UxTCTL (usart1 trasmit) register.
*
*
* @author Maria Kazandjieva, <mariakaz@cs.stanford.edu>
* @date Nov 18, 2008
*/ 

#include "ADE7753.h"

module ADE7753P {
    provides interface Init;
    provides interface ADE7753;
    provides interface Msp430SpiConfigure;

    uses interface Resource;
    uses interface SpiPacket;
    uses interface HplMsp430GeneralIO as CS;         // chip select line
    uses interface HplMsp430GeneralIO as ONOFF;       // relay
    uses interface Leds;
}

implementation {
    
    uint8_t txBuf[4];
    uint8_t rxBuf[4];
    uint8_t txLen;
    uint8_t rxLen;
    uint8_t state;
    uint8_t relay_state;
    
    
    
    /*
    * Commands
    */
    
    command bool ADE7753.getRelayState() {
        bool onstate = FALSE;
        if (relay_state == ON) {
            onstate = TRUE;
        } else {
            onstate = FALSE;
        }
        return onstate;
    }

    command bool ADE7753.toggleRelay() {
        bool onstate = FALSE;
        if (relay_state == ON) {
          atomic {
            relay_state = OFF;
            call ONOFF.clr();
          }
        } else {
            atomic {
              relay_state = ON;
              call ONOFF.set();
              onstate = TRUE;
            }
        }
        return onstate;
    }
 
    /* Initiate the CS pin */
    command error_t Init.init() {
        call CS.makeOutput();
        call CS.set();
        call ONOFF.makeOutput();
        call ONOFF.set();
    
        return SUCCESS;
    }
    
    /**
    * Command for writing to an ADE7753 register. The data written can be at most 3 bytes
    */
    command error_t ADE7753.setReg(uint8_t regAddr, uint8_t len, uint32_t value) {
      
     
        // set Tx buffer
        // set the MSB to 1, signify write to the communications register

        txBuf[0] = regAddr | (1 << 7); 
        txBuf[1] = 0;
        txBuf[2] = 0;
        txBuf[3] = 0;
    
        rxBuf[0] = 0;
        rxBuf[1] = 0;
        rxBuf[2] = 0;
	rxBuf[3] = 0;
    
        txLen = len;


	// this is necessary because the value we want to write is a 32-bit uint,
	// but registers on the ADE are at most 24-bits;
	// we are placing the correct bytes in the array to be written
	if (txLen == 2) {
		// must put value to write after the register's address
		txBuf[1] = (uint8_t) value;
	} else if (txLen == 3) {
		// we are writing 2 bytes of data after the destination register address
		txBuf[1] = (uint8_t) (value >> 8);
		txBuf[2] = (uint8_t) value;
	} else if (txLen == 4) {
		// data we are writing is 3 bytes, so 4 including the register address
		txBuf[1] = (uint8_t) (value >> 16);
		txBuf[2] = (uint8_t) (value >> 8);
		txBuf[3] = (uint8_t) value;
	}

	atomic state = SETREG;
        call Resource.request();
    
        return SUCCESS;
    
    }
   
    /*
    * Command for reading a register from the ADE chip. 
    * The data we read will be at most 3 bytes
    */ 
    command error_t ADE7753.getReg(uint8_t regAddr, uint8_t len) {
	// MSB stays 0 because this is a read
	
        txBuf[0] = regAddr;
        txBuf[1] = 0;
        txBuf[2] = 0;
        txBuf[3] = 0;
        
        rxBuf[0] = 0; 
        rxBuf[1] = 0;
        rxBuf[2] = 0;
        rxBuf[3] = 0;
 
        rxLen = len;
	
	atomic state = GETREG;
        call Resource.request();

        return SUCCESS;

    }
    
    
    /*
    * Events
    */
   
    /* The SPI bus has been granted to us, we can proceed */ 
    event void Resource.granted() {
        error_t err;
   	 
        call CS.clr();

	if (state == GETREG) { 
            err = call SpiPacket.send(txBuf, rxBuf, rxLen);
	} else if (state == SETREG) {
	    err = call SpiPacket.send(txBuf, rxBuf, txLen);
	} else {
	    err = SUCCESS;
	    call Resource.release();
	}

        if (err == FAIL) {
            call Resource.request();
        }

    }
    
    /* read or write over the SPI has completed, signal the appropriate event */
    async event void SpiPacket.sendDone(uint8_t* txB, uint8_t* rxB, uint16_t len, error_t e) {
        uint32_t value = 0;
	call CS.set ();
        call Resource.release();

	// this is necessary because the ADE7753 can return at most 24 bits;
	// we want to place those in a 32 bit uint
	if (len == 2) {
	    value = (uint32_t) rxB[1];
 	} else if (len == 3) {
	    value = (uint32_t) rxB[2] | ((uint32_t) rxB[1] << 8);
	} else if (len == 4) {
	    value = (uint32_t)rxB[3] | ((uint32_t)rxB[2] << 8) | ((uint32_t)rxB[1] << 16);
	}

	if (state == GETREG) {
		signal ADE7753.getRegDone(e, value);
		//call Leds.led1Toggle();
	} else if (state == SETREG) {
		signal ADE7753.setRegDone(e, value);
	}
    }

    
     /* Configure the TCTL register n the MSP 430 with the correct values for SPI to work */
     async command msp430_spi_union_config_t* Msp430SpiConfigure.getConfig() {
	return (msp430_spi_union_config_t*)&my_msp430_spi_default_config;
    }
    


}
