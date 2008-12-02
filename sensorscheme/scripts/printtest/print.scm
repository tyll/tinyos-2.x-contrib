(ssmodule print
  
  (require (lib std))

  (define (time-loop t)
    (call-at-time (+ t 8) time-loop)
    (blink (/ t 8))
    (print '(time is) (/ t 8)))
  
  (time-loop (now))
  
  )
