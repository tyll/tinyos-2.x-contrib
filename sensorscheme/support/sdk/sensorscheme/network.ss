(ssmodule
    network
  
  (require (lib std))
  
  (provide bcast redundant-bcast)
  
  (define (bcast mess)
    (send-local -1 mess))
  
  (include recv-local)
  
  ;redundant-bcast: sends a broadcast n times to ensure arrival. 
  ; when arrived it is only handled once  
  (define (redundant-bcast n msg)
    (when (> 0 n)
      (bcast msg)
      (redundant-bcast (- n 1) msg)))
  
  )  