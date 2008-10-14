(ssmodule
    coveragetest
  
  (require (lib std) (lib network))
  
  (define (square n)
    (* n n))
  
  (define-handler (hello n)
    (blink n)
    (print (* n n)))
  
  (call-at-time (+ (now) 16) (lambda (t)
                               (bcast (msg hello (square (square 15))))))
  
  )