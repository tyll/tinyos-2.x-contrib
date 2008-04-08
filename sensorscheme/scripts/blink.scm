(ssmodule blink
  
  (require (lib std))
  
  (define (blink n)
    (blink n)
    (call-at-time (+ n 1) blink))
  
  (blink 0)
  
  )
