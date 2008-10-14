(ssmodule bcastblink
  
  (require (lib std) (lib network))
  
  (define (bcastblink t)
    (call-at-time (+ t 4) bcastblink)
    (bcast (msg blinkleds (/ t 4))))
  
  (define-handler (blinkleds n)
    (blink n))
  
  (bcastblink (now))
  
  )
