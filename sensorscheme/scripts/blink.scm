(ssmodule blink
  
  (require (lib std))
  
  (define (do-blink n)
    (blink n)
    (call-at-time (+ n 1) do-blink))
  
  (do-blink 0)
  
  )
