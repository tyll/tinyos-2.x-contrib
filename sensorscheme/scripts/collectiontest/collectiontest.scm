(ssmodule collection-test
  
  (require (lib std) (lib collection) (lib network))
  
  (define (time-loop t) 
    (call-at-time (+ t 256) time-loop)
    (send-collect (msg sense-val t (etx) (parent) (neighbor-quality)))
    (print t (etx) (parent) (neighbor-quality)))
  
  (time-loop (now))
  
  ;(include recv-intercept)  
  )