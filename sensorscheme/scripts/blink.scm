(ssmodule blink
  
  (require (lib std))

  (define (blink0 t)
    (blink t)
    (call-at-time (+ t 1) blink0))
  
  (blink0 0)
  
  )
