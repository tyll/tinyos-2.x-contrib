
/**
 * @author David Moss
 */
 
#include "Blaze.h"

interface RadioSelect{

  /**
   * Select the radio to be used to send this message
   * @param msg The message to configure that will be sent in the future
   * @param radioId The radio ID to use when sending this message.
   *    See CC1100.h or CC2500.h for definitions, the ID is either
   *    CC1100_RADIO_ID or CC2500_RADIO_ID.
   * @return SUCCESS if the radio ID was set. EINVAL if you have selected
   *    an invalid radio
   */
  command error_t selectRadio(message_t *msg, radio_id_t radioId);

  /**
   * Get the radio ID this message will use to transmit when it is sent
   * @param msg The message to extract the radio ID from
   * @return The ID of the radio selected for this message
   */
  command radio_id_t getRadio(message_t *msg);
  
}

