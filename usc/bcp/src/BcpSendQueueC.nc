#include "Bcp.h"

configuration BcpSendQueueC{
  provides{
    /*
     * The Forwarder will Start the SendQueue operation.
     *  This prevents the loss of activate / deactivate
     *  messages. 
     */
    interface StdControl as SendQueueControl; 
    
    interface Init;
    
    // The Queue interface will connect to the forwarding Engine
    interface Queue<fe_queue_entry_t*>;  
    
    // The ForwarderControl interface allows activation and deactivation
    //  of the forwarding activities.
    interface BcpSendQueueForwarderIF as SendQueueForwarderIF;   
  }
  
  uses{ 
    // Used to log the local backpressure every firing 
    interface Timer<TMilli> as Timer;
    
    // The QueueControl interface will connect to the Routing Engine
    interface BcpRouterSendQueueIF as RouterSendQueueIF;    

    // The BcpDebugIF is used for logging at the application layer
    interface BcpDebugIF;
  }	
}
implementation{
  components BcpSendQueueP;
#ifndef LIFO
  components new QueueC(fe_queue_entry_t*, FORWARDING_QUEUE_SIZE);
#else
  components new StackC(fe_queue_entry_t*, FORWARDING_QUEUE_SIZE) as QueueC;
#endif
  BcpSendQueueP.RouterSendQueueIF    = RouterSendQueueIF;
  BcpSendQueueP.SendQueueForwarderIF = SendQueueForwarderIF;
  BcpSendQueueP.Init                 = Init;
  BcpSendQueueP.Timer                = Timer;
  BcpSendQueueP.Queue                = Queue;
  BcpSendQueueP.SendQueueControl     = SendQueueControl;
  BcpSendQueueP.SubQueue            -> QueueC.Queue;
  BcpDebugIF                         = BcpSendQueueP.BcpDebugIF;
}
