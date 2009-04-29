
configuration CtpDebugC {
  uses {
    interface CollectionDebug;
  }
}

implementation {

  components CtpForwardingEngineP;
  CollectionDebug = CtpForwardingEngineP;
  
  components CtpRoutingEngineP;
  CollectionDebug = CtpRoutingEngineP;
  
}
