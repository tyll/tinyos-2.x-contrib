interface SX1211PhyRssi {

    async command error_t getRssi(uint8_t *val);
    async command uint8_t readRxRssi();
}
