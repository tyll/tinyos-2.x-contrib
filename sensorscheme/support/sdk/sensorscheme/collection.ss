(ssmodule collection
  
(provide 
   etx parent hops neighbors 
   send-collect send-intercept
   recv-intercept)
    
  (define-primitive parent (simple ParentPrim))
  (define-primitive etx (simple EtxPrim))
  (define-primitive hops (simple HopsPrim))
  (define-primitive neighbors (simple NeighborsPrim))
  
  (define-primitive send-collect (sender CollectSender))
  (define-primitive send-intercept (sender InterceptSender))
  
  (define-receiver recv-intercept InterceptReceiver)  
  )
