


configuration S4TopologyC {
  provides {
    interface S4Topology;
    interface Init; 
  }
  
}
implementation {
  components  S4TopologyM   //StdControl provided            
            ;

  S4Topology = S4TopologyM;
  Init = S4TopologyM;
  
}
