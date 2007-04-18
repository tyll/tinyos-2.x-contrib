/**
 * Interface to the DSN Component for TinyOS.
 *
 * This component gives the facility to easily log messages to the Deployment Support Network
 * and receive commands.
 *
 * @author Roman Lim <rlim@ee.ethz.ch>
 * @modified 10/3/2006 Added documentation.
 * @modified 10/15/2006 Added Emergency logging.
 *
 **/
#include <message.h>
interface DSN {
/**
*	logging messages can contain following sequences:
*	<p>%i: 	replaces %i with the logged integer in decimal format
*	<p>%bn:	replaces %b with the logged integer in binary format
*			n is optional and sets the required variable width (1,2,3,4 [bytes])
*	<p>%h:	replaces %h with the logged integer in hexadecimal format
*	@param msg Message to be logged
*/
  command error_t log(void * msg);
/**
*	log a message without delimiter
*	@param msg Message to be appended
*/
  command error_t appendLog(void * msg);
  /**
*	log a byte stream as hex stream
*	@param msg byte stream to be logged
*/
  command error_t logHexStream(uint8_t* msg, uint8_t len);
/**
*	log a message with known length
*	@param msg Message to be logged
*	@param len length of message
*/
  command error_t logLen(void * msg, uint8_t len);
  
/**
*	log a message with loglevel ERROR
*	@param msg Message to be logged
*/  
  command error_t logError(void * msg);
  
/**
*	log a message with loglevel WARNING
*	@param msg Message to be logged
*/  
  command error_t logWarning(void * msg);
  
/**
*	log a message with loglevel INFO
*	@param msg Message to be logged
*/  
  command error_t logInfo(void * msg);
  
/**
*	log a message with loglevel DEBUG
*	@param msg Message to be logged
*/  
  command error_t logDebug(void * msg);

/**
*	with this function, numbers to log can be saved.
* 	there is buffer space for up to 5 numbers
*	@param n Number to be logged
*/
  async command void logInt(uint32_t n);
  
/**
*	loggs an active message in following format:
*	header | payload
*	all numbers are printed out in hexadecimal format
*	@param msg pointer to the packet
*/  
  command error_t logPacket(message_t * msg);
  
/**
*	stops active logging. Logs are always saved in the buffer
*/  
  command error_t stopLog();
  
/**
*	starts active logging. After this command, the log buffer is sent first.
*/  
  command error_t startLog();

/**
*	this event is signaled when a command is received
*	@param msg pointer to the command string
*	@param len length of the command string (including trailing \n)
*/  
  event void receive(void * msg, uint8_t len);
  
/**
*	enables the emergency logging after a timeout.
*	if no logging activities have happend within this timeout, the registered variables are dumped
*	@param timeout time in milliseconds
*/  
  command void emergencyLogEnable(uint32_t timeout);
  
/**
*	disables the emergency logging mechanism.
*/   
  command void emergencyLogDisable();
  
/**
*	adds a variable to the list for logging in emergency.
*	@param pointer pointer to the variable (global)
*	@param numBytes width of the variable in bytes
*	@param description name of the variable or other meanfull string
*/  
  command error_t emergencyLogAdd(void * pointer, uint8_t numBytes, uint8_t * description);

}
