/**
 * Interface that provides functions to read and write values
 * of the LS7366R
 * 
 * </br> KTH | Royal Institute of Technology
 * </br> Automatic Control
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 * 
 */

#include "LS7366R.h"

interface LS7366RRegister {

	/**
	 * Read an undefined number of bytes
	 * 
	 * @param
	 * 		*data	vector of bytes to return 
	 * 		length	number of bytes to read
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t read( uint8_t* data, uint8_t length);

	/**
	 * Read a word, 2 bytes
	 * 
	 * @param
	 * 		*data	variable to store the result
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t read16b(uint16_t* data);
	
	/**
	 * Read a byte
	 * 
	 * @param
	 * 		*data	variable to store the result
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t readByte(uint8_t* data);


	/**
	 * Write 4 bytes, 32 bits
	 * 
	 * @param
	 * 		data	data to write in a register
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t write32b(uint32_t data);
	
	/**
	 * Write a word, 2 bytes
	 * 
	 * @param
	 * 		data	data to write in a register
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t write16b(uint16_t data);

	/**
	 * Write a byte
	 * 
	 * @param
	 * 		data	data to write in a register
	 * 
	 * @return SUCCESS if the read was done, FAIL otherwise.
	 */
	async command error_t writeByte(uint8_t data);
	
	

}
