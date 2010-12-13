/**
 * Interface to configure the chip modes
 * 
 * </br> KTH | Royal Institute of Technology
 * </br> Automatic Control
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 * @see LS7366R.h
 */

interface LS7366RConfig {

	/**
	 * Sync configuration changes with the ls7366r hardware. This only
	 * applies to set commands below.
	 *
	 * @return SUCCESS if the request was accepted, FAIL otherwise.
	 */
	command error_t sync();
	/**
	 * This event is signalled when the synch command has finished
	 */
	event void syncDone( error_t error );

	/***************************************************************************************
	 * STR configuration
	 ***************************************************************************************/
	
	/**
	 * Get the actual state
	 * 
	 * @return state
	 */
	command uint8_t getState();
	/**
	 * Set the new state to the ls7366r
	 * 
	 * @param uint8_t new state value
	 */
	command void setState( uint8_t state );

	/***************************************************************************************
	 * MDR0 configuration
	 ***************************************************************************************/
	/**
	 * Get the current quadrature mode
	 * 
	 * @return quadrature value
	 */
	command uint8_t getQuadMode();
	/**
	 * Set the new quadrature mode
	 * 
	 * @param uint8_t new quadrature mode
	 */
	command void setQuadMode( uint8_t mode );

	/**
	 * Get the current running mode
	 * 
	 * @return running value
	 */
	command uint8_t getRunningMode();
	/**
	 * Set the new running mode
	 * 
	 * @param uint8_t new running mode
	 */
	command void setRunningMode( uint8_t mode );

	/**
	 * Get the current index configuration
	 * 
	 * @return index mode
	 */
	command uint8_t getIndex();
	/**
	 * Set the new current index configuration
	 * 
	 * @param uint8_t new index configuration
	 */
	command void setIndex( uint8_t index );

	/**
	 * Get the current index configuration
	 * 
	 * @return index mode
	 */
	command uint8_t getIndexSync();
	/**
	 * Set the new current index syncconfiguration
	 * 
	 * @param uint8_t new index sync configuration
	 */
	command void setIndexSync( uint8_t index );

	/***************************************************************************************
	 * MDR1 configuration
	 ***************************************************************************************/
	/**
	 * Get size of the counter in bytes
	 * 
	 * @return uint8_t
	 */
	command uint8_t getSize();
	/**
	 * Set the new counter size in bytes
	 * 
	 * @param uint8_t counter size
	 */
	command void setSize( uint8_t size );
	
	/**
	 * Get clock divisor configured
	 * 
	 * @return divisor
	 */
	command uint8_t getClkDiv();
	/**
	 * Set the new clock divisor desired
	 * 
	 * @param uint8_t new clock divisor
	 */
	command void setClkDiv( uint8_t clk_div );

	/**
	 * Get if the counter is enabled or not
	 * 
	 * @return TRUE if is disable, FALSE is enabled
	 */
	command bool getDisabled();
	/**
	 * Set the new size for the counter mdoe
	 * 
	 * @param uint8_t counter size in bytes
	 */
	command void setDisabled(bool enabled);
	
	/***************************************************************************************
	 * DTR configuration
	 ***************************************************************************************/
	/**
	 * Get DTR value. If N-Module counting mode is enabled
	 * it shall return the count range.
	 * 
	 * @return TRUE if is disable, FALSE is enabled
	 */
	command uint32_t getModule();
	/**
	 * Set the count range
	 * 
	 * @param uint8_t count range
	 */
	command void setModule(uint32_t module2);

}
