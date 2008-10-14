(ssmodule emptybase
  
  (require (lib std) (lib network))
  (include send-local null? cdr car recv-local/ack)
  
  (define (blink0 t ls)
    (call-at-time (+ t 16) (lambda (t) (blink0 t (cons t ls))))
    (let ([m (msg blink1 t ls)])
      #;(print m)
      (when (= id 0)
        (send-local/ack (+ id 1) m))))
  
  (define-handler (blink1 t ls)
    (print t ls)
    (blink (/ t 16)))
  
  (blink0 (+ (now) 64) ())
  
  )