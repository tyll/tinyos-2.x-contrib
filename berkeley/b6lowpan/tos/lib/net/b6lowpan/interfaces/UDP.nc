
interface UDP {

  /*
   * send a payload to the socket address indicated
   * once the call returns, the stack has no claim on the buffer pointed to
   */ 
  command error_t sendto(struct sockaddr_in6 *dest, void *payload, 
                         uint16_t len);

  /*
   * indicate that the stack has finished writing data into the
   * receive buffer.  if error is not SUCCESS, the payload does not
   * contain valid data and the src pointer should not be used.
   */
  event void recvfrom(struct sockaddr_in6 *src, void *payload, 
                      uint16_t len, struct ip_metadata *meta);

}
