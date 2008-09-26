




interface AckStore {
  command bool check_packet(uint8_t addr, uint16_t id);
  command bool check_packet_entry(uint8_t addr, uint16_t id, uint16_t* minid, uint16_t* maxid);
  command bool get_random_ack(uint8_t *addr, uint16_t* minid, uint16_t* maxid);
  command bool get_numbered_ack(int idx, bool *valid, uint16_t *addr, uint16_t* minid, uint16_t* maxid);
  command result_t report_ack(uint8_t addr, uint16_t minid, uint16_t maxid);
  
}

