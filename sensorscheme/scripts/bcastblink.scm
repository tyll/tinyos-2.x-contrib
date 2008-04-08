(ssmodule bcastblink
  
  (require (lib std) (lib network))
  
  (define (bcastblink t)
    (bcast (msg blinkleds (/ t 4)))
    (call-at-time (+ t 4) bcastblink))
  
  (define-handler (blinkleds t))
  
  (bcastblink 0)
  
  )
