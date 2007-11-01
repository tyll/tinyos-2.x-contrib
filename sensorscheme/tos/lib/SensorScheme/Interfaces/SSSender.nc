/*
 * Authors:		Leon Evers
 * Date last modified:  25/10/07
 */

/**
 * @author Leon Evers
 */


//includes SensorScheme;

/**
 * Interface for evaluating SensorScheme primitives
 *
 */

interface SSSender {

  command error_t start();

  command error_t stop();

  command ss_val_t eval(am_addr_t *addr);
  
  command uint8_t *getPayload(message_t* pkt);
  
  command uint8_t *getPayloadEnd(message_t* pkt);
  
  command am_addr_t getDestination(message_t* pkt);
  
  command error_t send(am_addr_t addr, message_t* pkt, uint8_t *dataEnd);

  event void sendDone(message_t *msg, error_t error);
}
