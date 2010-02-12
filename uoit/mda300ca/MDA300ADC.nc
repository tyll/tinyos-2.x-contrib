/**
* Interface for using the digital output pins on the MDA
* 300 and 320 sensorboards.
* 
* @author Christopher Leung
* author Charles Elliott
* @modified May 21, 2008
*/

interface MDA300ADC {
	/**
	 * Selects the ADC to read.
	 * ADDRESS + -
	 * 0x00 -> 0 1
	 * 0x10 -> 2 3
	 * 0x20 -> 4 5
	 * 0x30 -> 6 7
	 * 0x40 -> 1 0
	 * 0x50 -> 3 2
	 * 0x60 -> 5 4
	 * 0x70 -> 7 6
	 * 0x80 -> 0 COM
	 * 0x90 -> 1 COM
	 * 0xA0 -> 2 COM
	 * 0xB0 -> 3 COM
	 * 0xC0 -> 4 COM
	 * 0xD0 -> 5 COM
	 * 0xE0 -> 6 COM
	 * 0xF0 -> 7 COM
	 * bits 2 and 3 are power down selection 
	 * bits 0 and 1 are unused               
	 *
	 * @param value channel selected.
	 * 
	 * @return SUCCESS if the component is free.	 
	 */	 
	command error_t selectPin(uint8_t pin);
	
	/**
	 * Gets the channel selected.
	 *
	 * @note If get() is called during a write operation,
	 * the value that is being written will be returned.
	 *
	 * @return selected channel
	 */
	command uint8_t get ();
	
	command error_t requestRead();
	
	/**
	 * Gets the channel value.
	 *
	 * @return data value
	 */
	command uint16_t read();
	
	/**
	 * Notification that the channel is ready to be read.
	 */
	event void readyToRead();
	
	event void readyToSet();
}
