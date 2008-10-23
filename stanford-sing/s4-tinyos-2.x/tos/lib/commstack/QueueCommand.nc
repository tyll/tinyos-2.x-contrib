
interface QueueCommand {
  command error_t setRetransmitCount(uint8_t r);
  command uint8_t getRetransmitCount();
}
