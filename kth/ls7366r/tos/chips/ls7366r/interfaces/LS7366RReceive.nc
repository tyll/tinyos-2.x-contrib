/**
 * Interface to receive values from the chip
 * 
 * </br> KTH | Royal Institute of Technology
 * </br> Automatic Control
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 * 
 */

interface LS7366RReceive {

	/**
	 * Function to receive data from the counter. 
	 * <br />
	 * To receive we have to send to instruction of which 
	 * register we want to read, and then send empty or
	 * dummy bytes. During the dummy bytes we have the
	 * data in the other bus (SOMI)
	 * 
	 * @param uint8_t* pointer to the vector to store the data
	 * 
	 * @return SUCCESS if the request was accepted, FAIL otherwise.
	 */
	command error_t receive(uint8_t* data);

	/**
	 * This event is signalled when the recive command has finished
	 */
	event void receiveDone(uint8_t* data);
}

