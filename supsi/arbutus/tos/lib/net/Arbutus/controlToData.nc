

#include <AM.h>
#include <Collection.h>
   
interface controlToData {


    command am_addr_t getOrigin(message_t* msg);
    command collection_id_t getType(message_t* msg);
    command uint16_t getSequenceNumber(message_t* msg);
            command uint16_t getMtx();
            command void resetMtx();
  command uint16_t getQueueOccupancy();
    command uint16_t getGenerated();
     command uint16_t getRelayed();
     command uint8_t getSUSDstate();
          command bool get_ttx() ;

command uint16_t getLoad();

     command bool getAckPending();
     command bool getPacketAcked();
     
     command uint16_t getRxPackets();
     command uint16_t getDropped();
     command uint16_t getLoops();
      event void loopDetected();
      event void congestionDetected();
 event void routeBroken();

      event void decongestionDetected();
       event void slowDown();
      command bool getTxPending();

}
