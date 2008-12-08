(ssmodule collection-test
  
  (require (lib std) (lib collection) (lib network))
  
  (define (collect-loop t) 
    (call-at-time (+ t 256) collect-loop)
    (send-intercept (msg tree (parent)))
    (send-collect (msg sense-val t (etx) (parent) (neighbor-quality)))
    (print 'neigh t (etx) (parent) (neighbor-quality)))
  
  (collect-loop (now))
  
  (define-handler (tree p)
    (print 'tree src p))
 
  (include recv-intercept)  
  )