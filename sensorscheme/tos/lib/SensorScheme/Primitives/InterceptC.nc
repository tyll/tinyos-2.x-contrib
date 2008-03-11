/**
 * @author Leon Evers
 */


includes Ctp;

configuration InterceptC {
  provides interface SSSender;
  provides interface SSReceiver;
} 

implementation {
  components SSCollectionC;

  components new CollectionSenderC(CL_SSINTERCEPT_MSG);
  
  SSSender = SSCollectionC.InterceptSSSender;
  SSReceiver = SSCollectionC.InterceptSSReceiver;
  SSCollectionC.InterceptSend -> CollectionSenderC;
}
