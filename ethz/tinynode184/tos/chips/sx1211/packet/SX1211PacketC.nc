#include "message.h"

configuration SX1211PacketC {
  provides interface SX1211Packet;
  provides interface SX1211PacketBody;
}

implementation {

  components SX1211PacketP;
  SX1211Packet = SX1211PacketP;
  SX1211PacketBody = SX1211PacketP;

}
