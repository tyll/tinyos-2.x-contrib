
#include <Ieee154.h>

interface HotmacPacket {

  async command void constructHeader(message_t *msg, ieee154_saddr_t addr, uint8_t len); 

  async command uint8_t getDsn(message_t *msg);
  async command void setDsn(message_t *msg, uint8_t dsn);

  async command uint8_t getNetwork(message_t *msg);
  async command void setNetwork(message_t *msg, uint8_t nwid);
}
