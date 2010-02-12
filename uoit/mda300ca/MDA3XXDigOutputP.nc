/**
* Core component that allows the use of the digital outputs
* on the MDA 300 and 320 sensorboards.
* 
* This component does the following steps to set the digital
* output pins:
*   1. Request resource
*   2. Resource granted -> Write data through I2C bus
*   3. Write done -> Release resource and Signal done
* 
* @author Christopher Leung
* @modified June 5, 2008
*/

module MDA3XXDigOutputP {
	provides {
		interface DigOutput;
	}
	uses {
		//interface Leds as DebugLeds;
		interface I2CPacket<TI2CBasicAddr>;
		interface Resource;
	}
}
implementation {
	uint8_t I2C_data = 0xFF;	// Pin values
	uint8_t I2C_send;			// Buffer
	uint8_t I2C_read[2];
	bool idle = TRUE;
	bool read = FALSE;
	
	task void writeToI2C() {
		I2C_send = I2C_data;
		if ((call I2CPacket.write(I2C_START|I2C_STOP, 63, 1, (uint8_t*) &I2C_send)) != SUCCESS)
			post writeToI2C();
	}
	
	task void readToI2C() {		
		if ((call I2CPacket.read(I2C_START|I2C_STOP, 63, 2, (uint8_t*) &I2C_read)) != SUCCESS)
			post readToI2C();
	}
	
	task void signalReadyToSet() {
		signal DigOutput.readyToSet();
		idle = TRUE;
	}
	
	task void signalReadyToRead() {
		signal DigOutput.readyToRead();
		idle = TRUE;
	}
	/**
	 * Sets all the pins.
	 *
	 * @param value Value to be set on the pins.
	 * 
	 * @return SUCCESS if the component is free.
	 */
	command error_t DigOutput.setAll(uint8_t value) {
		if (idle) {
			idle = FALSE;
			read = FALSE;
			I2C_data = value;
			call Resource.request();
			return SUCCESS;
		}
		return FAIL;
	}
	
	/**
	 * Reads all the pins.
	 *
	 * @param none
	 * 
	 * @return SUCCESS if the component is free.
	 */
	command error_t DigOutput.requestRead() {
		if (idle) {
			idle = FALSE;
			read = TRUE;
			//I2C_data = value;
			call Resource.request();
			return SUCCESS;
		}
		return FAIL;
	}
	
	/**
	 * Sets select pins.
	 *
	 * @param pins Pins to be set.
	 * @param value Values to be set on selected pins.
	 *
	 * @return SUCCESS if the component is free.
	 */
	command error_t DigOutput.set(uint8_t pins, uint8_t value) {
		uint8_t temp_I2C_data;
		if (idle) {
			temp_I2C_data = I2C_data;
			value &= pins;
			temp_I2C_data &= ~pins;
			temp_I2C_data |= value;
			
			idle = FALSE;
			read = FALSE;
			I2C_data = temp_I2C_data;
			call Resource.request();
			return SUCCESS;
		}
		return FAIL;
	}
	
	/**
	 * Gets the pin values.
	 *
	 * @note If get() is called during a write operation,
	 * the value that is being written will be returned.
	 *
	 * @return Pin values
	 */
	command uint8_t DigOutput.get() {
		uint8_t temp_I2C_data;
		temp_I2C_data = I2C_data;
		return I2C_data;
	}
	
	/**
	 * Gets the pin values.
	 *
	 * @return Pin data value
	 */
	command uint8_t DigOutput.read() {
		uint8_t temp_I2C_read;
		temp_I2C_read = I2C_read[1];
		return temp_I2C_read;
	}
	
	event void Resource.granted() {
		if (read){
			post readToI2C();
		}else{
			post writeToI2C();
		}
	}
	
	async event void I2CPacket.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data) {
		call Resource.release();
		post signalReadyToRead();
	}
	
	async event void I2CPacket.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data) {
		call Resource.release();
		post signalReadyToSet();
	}
}
