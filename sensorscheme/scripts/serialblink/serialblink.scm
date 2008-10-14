(ssmodule serialblink
  
  (require (lib std))
  (include recv-serial)
  
  (define (serialblink t)
    (send-serial (msg blinkleds (/ t 4)))
    (call-at-time (+ t 4) serialblink))
  
  (define-handler (blinkleds n)
    (blink n))
  
  (serialblink 0)
  
  )
