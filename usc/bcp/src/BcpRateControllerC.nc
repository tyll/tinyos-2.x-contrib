configuration BcpRateControllerC{
  provides
  {
    interface Send;
  }
  uses
  {
    interface Packet as subPacket;
    interface Get<uint16_t> as getBackpressure;
    interface Send as SubSend;
    interface BcpDebugIF;
  }
}
implementation{	
  components BcpRateControllerP as RateController;
  components BcpRoutingEngineP as Router;
  components new exponentialRandomC(100) as exponentialRandom; // Set mean to 100, this doesn't mean anything (changed by setMean)
  components new PoolC(message_t, 6) as modPool;
  components new QueueC(message_t*, 6) as modQueue;
  components new TimerMilliC() as admissionTimer;
  
  RateController = Send;
  RateController = getBackpressure;
  RateController = SubSend;
  RateController = BcpDebugIF;
  RateController = subPacket;
  RateController.setMean -> exponentialRandom.setMean;
  RateController.exponentialRandom -> exponentialRandom;
  RateController.modPool -> modPool;
  RateController.modQueue -> modQueue;
  RateController.admissionTimer -> admissionTimer;
}
