(ssmodule collection-test
  
  (require "std.scm" "collection.scm" "network.scm")
  
  (define (time-loop) 
    (call-at-time (+ (now) 256) time-loop)
    (send-collect (msg sense-val (now) (parent) (neighbors))))
  
  (time-loop)
  
  (include recv-intercept)  
  )