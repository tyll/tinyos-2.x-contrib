

#include <AM.h>
#include <Collection.h>
   
interface CollectionPacket {
  command am_addr_t getOrigin(message_t* msg);
    command collection_id_t getType(message_t* msg);

  command uint8_t       get_hopcount ();
  command void triggerRouteUpdate();
  command void triggerImmediateRouteUpdate();
  
  
}
