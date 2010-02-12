/**
* Interface for using the digital output pins on the MDA
* 300 and 320 sensorboards.
* 
* @author Christopher Leung
* @modified May 21, 2008
*/

interface DigOutput {
	/**
	 * Sets all the pins.
	 *
	 * @param value Value to be set on the pins.
	 * 
	 * @return SUCCESS if the component is free.
	 */
	command error_t setAll (uint8_t value);
	
	/**
	 * Sets select pins.
	 *
	 * @param pins Pins to be set.
	 * @param value Values to be set on selected pins.
	 *
	 * @return SUCCESS if the component is free.
	 */
	command error_t set (uint8_t pins, uint8_t value);
	
	/**
	 * Reads all the pins.
	 *
	 * @param none
	 * 
	 * @return SUCCESS if the component is free.
	 */
	command error_t requestRead();
	
	/**
	 * Gets the pin values.
	 *
	 * @note If get() is called during a write operation,
	 * the value that is being written will be returned.
	 *
	 * @return Pin values
	 */
	command uint8_t get ();
	
	/**
	 * Gets the pin values.
	 *
	 * @return Pin data value
	 */
	command uint8_t read();
	
	/**
	 * Notification that the pins have been set.
	 */
	event void readyToSet ();
	
	/**
	 * Notification that the pins are ready to be read.
	 */
	event void readyToRead();
}
