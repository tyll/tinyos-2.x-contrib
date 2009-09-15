

#include <Arbutus.h>

generic configuration CollectionSenderC(collection_id_t collectid) {
  provides {
    interface Send;
    interface Packet;
  }
}
implementation {
  components new CollectionSenderP(collectid, unique(UQ_ARBUTUS_CLIENT));
  Send = CollectionSenderP;
  Packet = CollectionSenderP;
}
