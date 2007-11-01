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

interface SSReceiver {

  command error_t start();

  command error_t stop();

  command uint8_t *getPayload(message_t* pkt);

  event message_t* receive(message_t* msg, am_addr_t addr,
      uint8_t *data, uint8_t *end);
}
