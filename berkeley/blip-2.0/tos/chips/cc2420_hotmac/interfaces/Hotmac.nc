/*
 * Provides an interface to 
 *
 * @author Stephen Dawson-Haggerty
 */
interface Hotmac {

  command error_t setPeriod(uint16_t period);

  command uint16_t getPeriod();

  /*  Add an extra payload to periodic probe messages
   *   
   *  This can be used to implement low-overhead consistency protocols
   */
  event int addBeaconPayload(void *where, int len);

  /* Instruct the MAC to listen for extra beacon payloads.
   *
   * The MAC will decide how long to do this for, to guarantee that it
   * will have a chance at overhearing everyone.
   */
  command void overhear();

  event void payloadReceived(uint16_t who, void *payload, int len);

}
