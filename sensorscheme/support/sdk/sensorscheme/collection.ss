(ssmodule collection
  
(provide 
   etx parent neighbors neighbor-quality
   send-collect send-intercept
   recv-intercept)
    
  (define-primitive parent (simple ParentPrim))
  (define-primitive etx (simple EtxPrim))
  (define-primitive neighbors (simple NeighborsPrim))
  (define-primitive neighbor-quality (simple NeighQualityPrim))
  
  (define-primitive send-collect (sender CollectSender))
  (define-primitive send-intercept (sender InterceptSender))
  
  (define-receiver recv-intercept InterceptReceiver)  
  )
