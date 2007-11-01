(ssmodule
    radioblink-test
  
  (require "std.scm" "selector.scm" "network.scm")
  
  (define (send-blink n) 
    (do-at-time (+ (now) 8) (send-blink (+ n 1)))
    (bcast (list 'blink-recv n)))
  (define-handler (blink-recv n) (blink n))
  (send-blink 0) 
  )
