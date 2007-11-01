(ssmodule
    network
  
  (require "std.scm")
  
  ; procedure to handle forwarding messages through protocol layers
  (define (handle src msg) 
    (apply (eval (car msg)) (cons src (cdr msg))))    
  
  ;redundant-bcast: sends a broadcast n times to ensure arrival. 
  ; when arrived it is only handled once  
  (define (redundant-bcast n msg)
    (when (> 0 n)
      (bcast msg)
      (redundant-bcast (- n 1) msg)))
  
  (define-macro (msg tag . body)
    `(list ',tag ,@body))  
  )