
interface GTSPacket {

  command uint16_t getQuiet(message_t* amsg);
  command void setQuiet(message_t* amsg, uint8_t quiet);

}
