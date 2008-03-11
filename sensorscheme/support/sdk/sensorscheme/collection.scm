(ssmodule collection
  
(provide 
   parent neighbors 
   send-collect send-intercept
   recv-intercept)
    
  (define-primitive parent (simple ParentPrim))
  (define-primitive neighbors (simple NeighborsPrim))
  
  (define-primitive send-collect (sender CollectSender))
  (define-primitive send-intercept (sender InterceptSender))
  
  (define-receiver recv-intercept InterceptReceiver)  
  )