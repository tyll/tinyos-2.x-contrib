
/**
 * @author Joe Polastre
 */

interface HPLCC2420FIFO {
  /**
   * Read from the RX FIFO queue.  Will read bytes from the queue
   * until the length is reached (determined by the first byte read).
   * RXFIFODone() is signalled when all bytes have been read or the
   * end of the packet has been reached.
   *
   * @param length number of bytes requested from the FIFO
   * @param data buffer bytes should be placed into
   *
   * @return SUCCESS if the bus is free to read from the FIFO
   */
  async command error_t readRXFIFO(uint8_t length, uint8_t *data);

  /**
   * Writes a series of bytes to the transmit FIFO.
   *
   * @param length length of data to be written
   * @param data the first byte of data
   *
   * @return SUCCESS if the bus is free to write to the FIFO
   */
  async command error_t writeTXFIFO(uint8_t length, uint8_t *data);

  /**
   * Notification that a byte from the RX FIFO has been received.
   *
   * @param length number of bytes actually read from the FIFO
   * @param data buffer the bytes were read into
   *
   * @return SUCCESS 
   */
  async event error_t RXFIFODone(uint8_t length, uint8_t *data);

  /**
   * Notification that the bytes have been written to the FIFO
   * and if the write was successful.
   *
   * @param length number of bytes written to the fifo queue
   * @param data the buffer written to the fifo queue
   *
   * @return SUCCESS
   */
  async event error_t TXFIFODone(uint8_t length, uint8_t *data);
}
