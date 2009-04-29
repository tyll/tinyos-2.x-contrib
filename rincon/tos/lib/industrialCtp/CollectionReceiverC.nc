
/**
 * @author David Moss
 */
 
generic configuration CollectionReceiverC(am_id_t amId) {
  provides {
    interface Receive;
  }
}

implementation {

  components CollectionC;
  Receive = CollectionC.Receive[amId];
  
}
