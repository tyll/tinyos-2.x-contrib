interface Compressor {
  command error_t init();
  command error_t compress(uint16_t x, uint16_t y, uint16_t z);
  command error_t flush();

  event void bufferFull(uint8_t *buffer, uint16_t bytes);

}
