(ssmodule injecttest
  
  (require (lib std))
  
  (define (blink-loop t)
    (call-at-time (+ t 1) blink-loop)
    (do-blink t))
  
  (define (do-blink n)
    (blink (/ n 4))
    (print "do-blink"))
  
  (blink-loop (now))
  
  )