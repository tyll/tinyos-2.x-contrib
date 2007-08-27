/**
 * Interface to the DSN Component for TinyOS.
 *
 * This component gives the facility to easily log messages to the Deployment Support Network
 * and receive commands.
 *
 * @author Roman Lim <rlim@ee.ethz.ch>
 *
 **/
interface DsnEmergency {
/**
*	enables the emergency logging after a timeout.
*	if no logging activities have happend within this timeout, the registered variables are dumped
*	@param timeout time in milliseconds
*/  
  command void enable(uint32_t timeout);
  
/**
*	disables the emergency logging mechanism.
*/   
  command void disable();
  
/**
*	adds a variable to the list for logging in emergency.
*	@param pointer pointer to the variable (global)
*	@param numBytes width of the variable in bytes
*	@param description name of the variable or other meanfull string
*/  
  command error_t addMonitorVariable(void * pointer, uint8_t numBytes, uint8_t * description);
  
  command void adjustTimeout();

}
