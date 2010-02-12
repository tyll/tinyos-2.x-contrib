/**
* Interface for using the SHT75 temperature and humidity sensor
* 
* @author Charles Elliott
* @modified June 24, 2008
*/

interface SHT75Interface {
	/**
	 * writes a byte on the Sensibus and checks the acknowledge.
	 *
	 * @param value Value to be written.
	 * 
	 * @return error=1 in case of no acknowledge.
	 */
	command s_write_byte(unsigned char value);
	
	/**
	 * reads a byte form the Sensibus and gives an acknowledge in case of "ack=1"
	 *
	 * @param ack
	 *
	 * @return the read byte
	 */
	command s_read_byte(unsigned char ack);
	
	/**
	 * generates a transmission start 
	 *
	 * @param none
	 * 
	 * @return none
	 */
	command s_transstart();
	
	/**
	 * communication reset: DATA-line=1 and at least 9 SCK cycles followed by transstart
	 *
	 * @param none
	 *
	 * @return none
	 */
	command s_connectionreset();
	
	/**
	 * resets the sensor by a softreset 
	 *
	 * @param none
	 *
	 * @return error=1 in case of no response form the sensor
	 */
	command s_softreset();
	
	/**
	 * reads the status register with checksum (8-bit)
	 *
	 * @param *p_value pointer to the value being read
	 *
	 * @param *p_checksum pointer to the value of the checksum
	 *
	 * @return error=1 in case of no response form the sensor
	 */
	command s_read_statusreg(unsigned char *p_value, unsigned char *p_checksum);
	
	/**
	 * writes the status register with checksum (8-bit)
	 *
	 * @param *p_value pointer to the value of the checksum
	 *
	 * @return error>=1 in case of no response form the sensor
	 *
	 */
	command s_write_statusreg(unsigned char *p_value);
	
	/**
	 * reads the status register with checksum (8-bit)
	 *
	 * @param *p_value pointer to the value being read
	 *
	 * @param *p_checksum pointer to the value of the checksum
	 *
	 * @param mode TEMP or HUMI
	 *
	 * @return error=1 in case of no response form the sensor
	 */	
	command s_measure(unsigned char *p_value, unsigned char *p_checksum, unsigned char mode)
	
	
}
