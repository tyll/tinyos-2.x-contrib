

configuration PriorityQueueC {

  provides interface AMSend[ am_id_t id ];
  provides interface AmRegistry[ am_id_t id ];
  
  uses interface AMSend as SubSend[ am_id_t id ];
  
}

implementation {

  components PriorityQueueP;
  
  AMSend = PriorityQueueP;
  PriorityQueueP.SubSend = SubSend;

  PriorityQueueP.AmRegistry = AmRegistry;
  
  components new StateC();
  PriorityQueueP.State -> StateC;

}

