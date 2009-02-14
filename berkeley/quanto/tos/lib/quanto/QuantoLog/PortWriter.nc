interface PortWriter {
    async command error_t write(uint8_t *buf, uint16_t len);
    event void writeDone(uint8_t *buf, error_t result);
}
