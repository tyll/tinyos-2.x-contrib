(ssmodule collection-test
  
  (require (lib std) (lib collection) (lib network))
  
  (define (time-loop) 
    (call-at-time (+ (now) 256) time-loop)
    (send-collect (msg sense-val (now) (parent) (neighbors))))
  
  (time-loop)
  
  (include recv-intercept)  
  )