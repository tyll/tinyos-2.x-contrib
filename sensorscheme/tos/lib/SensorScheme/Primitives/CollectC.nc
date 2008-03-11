/**
 * @author Leon Evers
 */


includes Ctp;

configuration CollectC {
  provides interface SSSender;
}

implementation {

  components CollectionC;
  components SSCollectionC;
  components new CollectionSenderC(CL_SSCOLLECT_MSG);

  SSSender = SSCollectionC.CollectSSSender;
  SSCollectionC.CollectSend -> CollectionSenderC;
  SSCollectionC.CollectReceive -> CollectionC.Receive[CL_SSCOLLECT_MSG];
}
