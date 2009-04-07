#include "Dfrf.h"

generic module DfrfClientP(typedef payload_t, uint8_t uniqueLength, uint16_t bufferSize) {
  provides {
    interface StdControl;
    interface DfrfSend<payload_t>;
    interface DfrfReceive<payload_t>;
  }
  uses {
    interface DfrfControl as SubDfrfControl;
    interface DfrfSendAny as SubDfrfSend;
    interface DfrfReceiveAny as SubDfrfReceive;
  }
} implementation {

  uint8_t routingBuffer[sizeof(dfrf_desc_t) + bufferSize * (sizeof(payload_t) + sizeof(dfrf_block_t))];

  command error_t StdControl.start() {
    return call SubDfrfControl.init(sizeof(payload_t), uniqueLength, routingBuffer, sizeof(routingBuffer));
  }

  command error_t StdControl.stop() {
    call SubDfrfControl.stop();
    return SUCCESS;
  }

  command error_t DfrfSend.send(payload_t* data, uint32_t timeStamp) {
    return call SubDfrfSend.send((void*)data, timeStamp);
  }

  event bool SubDfrfReceive.receive(void *data, uint32_t timeStamp) {
    return signal DfrfReceive.receive((payload_t*)data, timeStamp);
  }

  default event bool DfrfReceive.receive(payload_t* data, uint32_t timestamp) { return TRUE; }

}

