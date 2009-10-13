interface SendBuff {
    command error_t send(uint8_t* buff, uint8_t len);
    event void sendDone(uint8_t* buff,error_t err);
}
