/**
 * @author Leon Evers
 */


includes Ctp;

configuration InterceptC {
  provides interface SSSender;
  provides interface SSReceiver;
} 

implementation {
  components CollectionC;
  components SSCollectionC;
  components new CollectionSenderC(CL_SSINTERCEPT_MSG);
  
  SSSender = SSCollectionC.InterceptSSSender;
  SSReceiver = SSCollectionC.InterceptSSReceiver;
  SSCollectionC.InterceptSend -> CollectionSenderC;
  
  
  SSCollectionC.Intercept -> CollectionC.Intercept[CL_SSINTERCEPT_MSG];
  SSCollectionC.InterceptReceive -> CollectionC.Receive[CL_SSINTERCEPT_MSG];
  
}
