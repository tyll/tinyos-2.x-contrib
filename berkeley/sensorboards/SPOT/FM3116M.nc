#include <I2C.h>

//includes msp430baudrates;

module FM3116M
{
	uses interface Boot;
	provides interface FM3116[ uint8_t i2cAddr];
	uses interface Leds;
	uses interface Resource as I2CResource;
//	uses interface MSP430I2CPacket as I2CPacket;
	uses interface I2CPacket<TI2CBasicAddr> as I2CPacket;
//moteiv:	uses interface StdControl as I2CControl;
//moteiv:	uses interface HPLUSARTControl as UartControl;
}
implementation
{
	enum {
//		ADDR = 0x68, // select companion [A1,A0] = [0,0]
//		ADDR,
		IDLE = 0,
		INIT,
		WRITE_RC,
		WRITE_RC_ONLY,
		READ_CNT_ONLY_LATCH,
		READ_CNT_ONLY,
		READ_CNT_LATCH,
		READ_CNT,
		CAL,
		WRITE_REG,
		READ_REG_LATCH,
		READ_REG,
	};

	uint8_t ADDR;
	
	uint16_t init_code, rc_code;
	uint8_t latch_code;
	
	uint8_t state;
	uint16_t calreg;
	uint16_t reg;

	// fxjiang
	// uint32_t count;
	uint8_t count[5];

	uint8_t readAddr;
	uint8_t readVal;

	uint16_t return_addr;

	// fxjiang debug
	// uint8_t* return_data;
	uint32_t return_data;
	
	event void Boot.booted() {
		ADDR = 0;
		count[0] = 0;
		count[1] = 0;
		count[2] = 0;
		count[3] = 0;
		count[4] = 0;
		readAddr = 0;
		readVal = 0;
		state = IDLE;
		init_code = 0x050C;
		rc_code = 0x0D0C;
		latch_code = 0x0D;
		calreg = 0x0500;
		reg = 0;

		return_addr = 0;
		return_data = 0;
		
		// something is obviously obsolete here
//		call I2CControl.init();
//moteiv:		call I2CControl.start();
	}
	
	command error_t FM3116.init[ uint8_t i2cAddr ]() {
		// call Leds.led0On();
		if (state == IDLE) {
			state = INIT;
			ADDR = i2cAddr;
			call I2CResource.request();
			return SUCCESS;
		}
		else 
			return FAIL;
	}


	command error_t FM3116.CAL[ uint8_t i2cAddr ]() {
		if (state == IDLE) {
			state = CAL;
			ADDR = i2cAddr;
			call I2CResource.request();
			return SUCCESS;
		}
		else
			return FAIL;		
	}

	command error_t FM3116.readReg[ uint8_t i2cAddr ](uint8_t addr) {
		if (state == IDLE) {
			state = READ_REG_LATCH;
			readAddr = addr;
			ADDR = i2cAddr;
			call I2CResource.request();
			return SUCCESS;
		}
		else
			return FAIL;	

	}
	
	command error_t FM3116.writeReg[ uint8_t i2cAddr ](uint8_t addr, uint8_t val) {
		if (state == IDLE) {
			state = WRITE_REG;
			reg = ((uint16_t)val)<<8 | (uint16_t)addr;
			ADDR = i2cAddr;
			call I2CResource.request();
			return SUCCESS;
		}
		else
			return FAIL;		
	}
	
	command error_t FM3116.takeSnapshot[ uint8_t i2cAddr ]() {
		if (state == IDLE) {
			state = WRITE_RC_ONLY;
			ADDR = i2cAddr;
			call I2CResource.request();
			return SUCCESS;
		}
		else
			return FAIL;
	}

	command error_t FM3116.readCounter_Only[ uint8_t i2cAddr ]() {
		if (state == IDLE) {
			state = READ_CNT_ONLY_LATCH;
			ADDR = i2cAddr;
			call I2CResource.request();
			return SUCCESS;
		}
		else
			return FAIL;
	}
	
	command error_t FM3116.readCounter[ uint8_t i2cAddr ]() {
		if (state == IDLE) {
			state = WRITE_RC;
			ADDR = i2cAddr;
			call I2CResource.request();
			return SUCCESS;
		}
		else
			return FAIL;
	}

	task void writeDone() {		
//		call Leds.led0Toggle();
		
		switch (state) {
		case INIT:
			state = IDLE;
			signal FM3116.initDone[return_addr]();
			break;
		case WRITE_RC_ONLY:
			state = IDLE;
			signal FM3116.snapshotDone[return_addr]();
			break;
		case WRITE_RC:
			state = READ_CNT_LATCH;
			call I2CResource.request();
			break;
		case READ_CNT_ONLY_LATCH:
			state = READ_CNT_ONLY;
			call I2CResource.request();			
			break;
		case READ_CNT_LATCH:
			state = READ_CNT;
			call I2CResource.request();			
			break;
		case CAL:
			state = IDLE;
			signal FM3116.calDone[return_addr]();
			break;
		case WRITE_REG:
			state = IDLE;
			signal FM3116.writeReg_Done[return_addr]();
			break;
	  	case READ_REG_LATCH:
			state = READ_REG;
			call I2CResource.request();			
			break;
		}
	}
	
	async event void I2CPacket.writeDone(error_t success, uint16_t addr, uint8_t length, uint8_t* data) {
//		call Leds.led1On();
		call I2CResource.release();
		if (success == FAIL) {
//			call Leds.led1On();
			call Leds.led2On();	
		} else {
			atomic {
				return_addr = addr;
				// fxjiang debug
				// return_data = data;
				return_data =  *( (uint32_t*) data);
				post writeDone();
			}
		}
	}

	task void readDone() {
		
//		call Leds.led0Toggle();			

		switch (state) {
		case READ_CNT_ONLY:
			state = IDLE;
			// fxjiang debug
			// signal FM3116.readOnly_Done[return_addr](*((uint32_t*)return_data));
				signal FM3116.readOnly_Done[return_addr](*(uint32_t*)(return_data+1));
			break;
		case READ_CNT:
			state = IDLE;
			// fxjiang debug
			// signal FM3116.readDone[return_addr](*((uint32_t*)return_data));
			signal FM3116.readDone[return_addr](return_data);
			break;
		case READ_REG:
			/*
			if (*return_data != readVal)
				call Leds.led2On();
			if (*return_data != 0)
				call Leds.led2On();
			*/
			state = IDLE;
			// fxjiang
			// signal FM3116.readReg_Done[return_addr](*return_data);
			signal FM3116.readReg_Done[return_addr](return_data);
			break;
		}
	}

	async event void I2CPacket.readDone(error_t success, uint16_t addr, uint8_t length, uint8_t* data) {
		call I2CResource.release();
		if (success == FAIL)
			call Leds.led2On();
		else {
			atomic{
				return_addr = addr;
				// fxjiang
				// return_data = data;
//				return_data = *((uint32_t*)data);

				// fxjiang change back!
				return_data = data;

//				if ( (return_data & 0x000000FF) == 0xD1)
//					call Leds.led0Toggle();
				post readDone();
			}
		}
	}

	event void I2CResource.granted() {

		// Make any necessary UART changes

		//moteiv:
		/*
		call UartControl.setClockSource(SSEL_2);
		call UartControl.setClockRate(UBR_SMCLK_9600, UMCTL_SMCLK_9600);
		call UartControl.setModeI2C();
		call UartControl.enableI2C();
		*/

		// call Leds.led1Toggle();
		
		switch (state) {
		case INIT:
			// call Leds.led1On();
			// chain counters, rising edge
			if (call I2CPacket.write(I2C_START | I2C_STOP, ADDR, 2, (uint8_t*)(&init_code)) == FAIL) 
				call I2CResource.request(  );
			break;
		case WRITE_RC_ONLY:
			// Take counter snapshot ONLY
			if (call I2CPacket.write(I2C_START | I2C_STOP, ADDR, 2, (uint8_t*)(&rc_code)) == FAIL)
				call I2CResource.request(  );
			break;
		case WRITE_RC:
			// Take counter snapshot
			if (call I2CPacket.write(I2C_START | I2C_STOP, ADDR, 2, (uint8_t*)(&rc_code)) == FAIL)
				call I2CResource.request(  );
			break;
		case READ_CNT_ONLY_LATCH:
			// Set current register address
			if (call I2CPacket.write(I2C_START | I2C_STOP, ADDR, 1, &latch_code) == FAIL)
				call I2CResource.request(  );
			break;
		case READ_CNT_LATCH:
			// Set current register address
			if (call I2CPacket.write(I2C_START | I2C_STOP, ADDR, 1, &latch_code) == FAIL)
				call I2CResource.request(  );
			break;
		case READ_CNT_ONLY:
			// Read it now!
//			call Leds.led0Toggle();
			// if (call I2CPacket.read(I2C_START | I2C_STOP, ADDR, 4, (uint8_t*)(&count)) == FAIL)
			if (call I2CPacket.read(I2C_START | I2C_STOP, ADDR, 5, count) == FAIL)
				call I2CResource.request(  );
			break;
		case READ_CNT:
			// Read it now!
			// if (call I2CPacket.read(I2C_START | I2C_STOP, ADDR, 4, (uint8_t*)(&count)) == FAIL)
			if (call I2CPacket.read(I2C_START | I2C_STOP, ADDR, 5, count) == FAIL)
				call I2CResource.request(  );
			break;
		case CAL:
			if (call I2CPacket.write(I2C_START | I2C_STOP, ADDR, 2, (uint8_t*)(&calreg)) == FAIL)
				call I2CResource.request(  );
			break;
		case WRITE_REG:
			if (call I2CPacket.write(I2C_START | I2C_STOP, ADDR, 2, (uint8_t*)(&reg)) == FAIL)
				call I2CResource.request(  );
			break;
		case READ_REG_LATCH:
			// Set current register address
			if (call I2CPacket.write(I2C_START | I2C_STOP, ADDR, 1, &readAddr) == FAIL)
				call I2CResource.request(  );
			break;
		case READ_REG:
			// Read it now!
			if (call I2CPacket.read(I2C_START | I2C_STOP, ADDR, 1, &readVal) == FAIL)
				call I2CResource.request(  );
			break;
		default:
			call I2CResource.release();
		}	   
	}
	
default event void FM3116.initDone[uint8_t i2cAddr]() {}
default event void FM3116.readDone[uint8_t i2cAddr](uint32_t cnt) {} 
default event void FM3116.calDone[uint8_t i2cAddr]() {}
default event void FM3116.writeReg_Done[uint8_t i2cAddr]() {}
default event void FM3116.readReg_Done[uint8_t i2cAddr](uint8_t val) {}
default event void FM3116.snapshotDone[uint8_t i2cAddr]() {}
default event void FM3116.readOnly_Done[uint8_t i2cAddr](uint32_t cnt) {}

}
