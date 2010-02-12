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
* author Charles Elliott
* @modified June 5, 2008
*/

module MDA3XXADCP {
	provides {
		interface MDA300ADC;
	}
	uses {
		interface Leds; // as DebugLeds;
		interface I2CPacket<TI2CBasicAddr>;
		interface Resource;
	}
}
implementation {
	uint8_t I2C_data = 0xFF;	// Pin values
	uint8_t I2C_send;			// Buffer
	uint8_t I2C_read[3];
	bool idle = TRUE;
	bool read = FALSE;
	
	task void writeToI2C() {
		I2C_send = I2C_data;
		if ((call I2CPacket.write(I2C_START|I2C_STOP, 74, 1, (uint8_t*) &I2C_send)) != SUCCESS){		//0x94
			post writeToI2C();
		}
	}
	
	task void readToI2C() {		
		if ((call I2CPacket.read(I2C_START|I2C_STOP, 74, 3, (uint8_t*) &I2C_read)) != SUCCESS){
			post readToI2C();
		}
	}
	
	task void signalReadyToSet() {
		signal MDA300ADC.readyToSet();
		idle = TRUE;
	}
	
	task void signalReadyToRead() {
		signal MDA300ADC.readyToRead();
		idle = TRUE;
	}
	
	task void getResource (){
		if (call Resource.request() != SUCCESS)
			post getResource();
	}
	
	/**
	 * Selects the ADC to read.
	 *  
	 *   CHANNEL SELECTION CONTROL
	 *	SD C2 C1 C0 CH0 CH1 CH2 CH3 CH4 CH5 CH6 CH7 COM
	 *	0  0  0  0  +IN –IN  —  —   —   —   —   —   —
	 *	0  0  0  1  —   —   +IN –IN —   —   —   —   —
	 *	0  0  1  0  —   —   —   —   +IN –IN —   —   —
	 *	0  0  1  1  —   —   —   —   —   —   +IN –IN —
	 *	0  1  0  0  –IN +IN —   —   —   —   —   —   —
	 *	0  1  0  1  —   —   –IN +IN —   —   —   —   —
	 *	0  1  1  0  —   —   —   —   –IN +IN —   —   —
	 *	0  1  1  1  —   —   —   —   —   —   –IN +IN —
	 *	1  0  0  0  +IN —   —   —   —   —   —   —   –IN
	 *	1  0  0  1  —   —   +IN —   —   —   —   —   –IN
	 *	1  0  1  0  —   —   —   —   +IN —   —   —   –IN
	 *	1  0  1  1  —   —   —   —   —   —   +IN —   –IN
	 *	1  1  0  0  —   +IN —   —   —   —   —   —   –IN
	 *	1  1  0  1  —   —   —   +IN —   —   —   —   –IN
	 *	1  1  1  0  —   —   —   —   —   +IN —   —   –IN
	 *	1  1  1  1  —   —   —   —   —   —   —   +IN –IN
	 *
	 * @param value channel selected.
	 * 
	 * @return SUCCESS if the component is free.
	 */
	command error_t MDA300ADC.selectPin (uint8_t pin){
		if (idle){
			idle = FALSE;
			read = FALSE;
			//pin = pin & 0xF0;
			I2C_data = pin;
			call Resource.request();//post getResource(); //call Resource.request();
			return SUCCESS;
		}
		return FAIL;
	}
	
	/**
	 * Reads the previously selected channel
	 *
	 * @param none
	 * 
	 * @return SUCCESS if the component is free.
	 */
	command error_t MDA300ADC.requestRead() {
		if (idle) {
			idle = FALSE;
			read = TRUE;
			call Resource.request();//post getResource(); //call Resource.request();
			return SUCCESS;
		}
		return FAIL;
	}
	
	/**
	 * Gets the selected channel.
	 *
	 * @note If get() is called during a write operation,
	 * the value that is being written will be returned.
	 *
	 * @return Pin values
	 */
	command uint8_t MDA300ADC.get() {
		uint8_t temp_I2C_data;
		temp_I2C_data = I2C_data;
		return temp_I2C_data;
	}
	
	/**
	 * Gets the pin values.
	 *
	 * @return Pin data value
	 */
	command uint16_t MDA300ADC.read() {	
		uint16_t temp_I2C_read = (I2C_read[2] & 0xff) | ((I2C_read[1] & 0xff) << 8); //I2C_read[2] + (I2C_read[1]*256);
		
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
