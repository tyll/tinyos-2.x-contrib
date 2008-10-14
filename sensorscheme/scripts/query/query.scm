(ssmodule query ;sensorscheme
  
  (require (lib std))
  (require (lib collection))
  (require (lib struct))
  
  (define-struct query (epochs cons nil period))
  
  (define-struct epoch (t val)) 
  
  (define queries ())
  (define (get-query qid)
    (cdr (assoc qid queries)))
  
  (define (time-loop qid epoch)
    (let* ([q (get-query qid)] ; find the query, and do nothing if not present
           [period (query-period (cdr q))] 
           [qnil (query-nil (cdr q))])
      (call-at-time (* period (+ 1 epoch)) (lambda (t) (time-loop q t)))
      (sample qid epoch (qnil))
      (forward qid (+ (- 10 hops) epoch))))
  
  (define (sample q epoch val)
    (let* ([e (assoc epoch (query-epochs q))])
      (if e (set-cdr! e ((query-cons (cdr e) val))) ; this epoch already has values
          (set-query-epochs! (cdr q) (cons (cons epoch val) (query-epochs (cdr q))))))) ; new value for epoch
  
  (define (forward qid epoch)
    (let* ([q (get-query qid)]
           [val (cdr (assoc epoch (query-epochs (cdr q))))])
      (send-intercept (msg (result qid epoch (val))))))
  
  (define-handler (recv-query qid qcons qnil period)
    (let ([q (assoc qid queries)])
      (if q 
          (set-cdr! q (make-query () cons qnil period)) ; this query has already been defined before
          (begin
            (set! queries (cons (cons qid (make-query () cons qnil period) queries))) ; it is a new query. store and start timer
            (time-loop qid (/ (now) (query-period (cdr q))))))))
  
  (define-handler (result qid epoch val)
    (sample (get-query qid) epoch val))
  
  ;(call-at-time (lambda (t) (send-intercept (result qid epoch (assoc queries)))))
  )