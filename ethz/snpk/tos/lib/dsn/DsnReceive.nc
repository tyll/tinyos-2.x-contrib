/**
 * Interface to the DSN Component for TinyOS.
 *
 * This component gives the facility to easily log messages to the Deployment Support Network
 * and receive commands.
 *
 * @author Roman Lim <rlim@ee.ethz.ch>
 *
 **/
interface DsnReceive {
/**
*	this event is signaled when a command is received
*	@param msg pointer to the command string
*	@param len length of the command string (including trailing \n)
*/  
  event void receive(void * msg, uint8_t len);
}
