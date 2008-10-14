(ssmodule chemical
  
  (require (lib std) (lib network) "/Users/leonevers/sensorscheme/scripts/chemical-data.scm")
  
  ; constants defined externally:
  ; reactions
  ; nodes
  
  ;;;;;;;;;;;;; access functions ;;;;;;;;;;;;;;;;;;;;
  
  (define (my-chem)
    (cadr (assoc id nodes)))
  
  ;;;;;;;;;;;; the real program ;;;;;;;;;;;;;;;;;;;
  
  (define (reactive? chem1 chem2)
    (any (lambda (el) 
           (or (and (eq? (car el) chem2) 
                    (eq? (cadr el) chem1))
               (and (eq? (car el) chem1)
                    (eq? (cadr el) chem2)))) 
         reactions)) 
  
  (define-handler (chem-hdl c)
    (set! recv-ls (cons c recv-ls)))
  
  (define (alert chem) 
    (print "alert for chemical" chem))
  
  (define recv-ls ())
  
  (define (time-loop t)
    (call-at-time (+ t 64) time-loop)
    (when (any (lambda (el) 
                 (reactive? el (my-chem))) recv-ls) 
      (alert (my-chem)))
    (set! recv-ls ())
    (bcast (msg chem-hdl (my-chem))))  
  
  (time-loop (now))
  
  )
