;/* TinyDB: SELECT avg(temp) SAMPLE PERIOD 60s */
;settimer0(600); // Fire Timer0 every epoch (60s)
;mhop_set_update(120); // Update multihop route every 2min
;// 'spatialavg(f)' returns an "object" with methods for
;// performing spatial averaging of f. The methods are:
;// spatial_sample: measure f locally
;// spatial_agg: include results from a child
;// spatial_get: get completed results for this subtree
;// (as a string of length spatialavg_length, ready for
;// transmission)
;// An "object" is a vector with functions as elements.
;spatialavg = fn (function attr) {
;any sstate = spatialavg_make(attr);
;epoch_change = fn() spatialavg_epoch_update(sstate);
;vector(fn (data) spatialavg_intercept(sstate, data),
;fn () spatialavg_sample(sstate, sstate[0]()),
;fn () spatialavg_get(sstate))
;};
;avgtemp = spatialavg(temp);
;timer0_handler = fn () {
;any summary;
;// the root (id 0) does only aggregation
;if (id()) {
;next_epoch();
;avgtemp[spatial_sample]();
;};
;summary = avgtemp[spatial_get]();
;if (summary)
;mhopsend(encode(vector(epoch(), summary)));
;};
;// decode messages heard, update epoch if necessary,
;// add child summaries to our summary
;snoop_handler = fn ()
;snoop_epoch(decode_message(snoop_msg())[0]);
;intercept_handler = fn () {
;vector fields = decode_message(intercept_msg());
;snoop_epoch(fields[0]);
;avgtemp[spatial_agg](fields[1]);
;};
;decode_message = fn (msg)
;decode(msg, vector(2, make_string(spatialavg_length)));

(module dbquery sensorscheme
;-- SensorScheme version:

; TinyDB: SELECT avg(temp) SAMPLE PERIOD 60s 
(settimer0 600) ; Fire Timer0 every epoch (60s)
(mhop_set_update 120) ; Update multihop route every 2min
;// 'spatialavg(f)' returns an "object" with methods for
;// performing spatial averaging of f. The methods are:
;// spatial_sample: measure f locally
;// spatial_agg: include results from a child
;// spatial_get: get completed results for this subtree
;// (as a string of length spatialavg_length, ready for
;// transmission)
;// An "object" is a vector with functions as elements.

(define (spatialavg attr) 
  (let* ((sstate (spatialavg_make attr))
         (epoch_change (lambda () (spatialavg_epoch_update sstate))))
    (list (lambda (data) (spatialavg_intercept sstate data))
          (lambda () (spatialavg_sample sstate (ref sstate 0)))
          (lambda () (spatialavg_get sstate)))))

(define avgtemp (spatialavg temp))
(define (timer0_handler) 
  (let ((summary))
    ; the root (id 0) does only aggregation
    (if (<> id 0) 
        (begin (next_epoch)
               ((ref avgtemp spatial_sample))))
    (set! summary ((ref avgtemp spatial_get)))
    (if (summary) (mhopsend (encode  (list (epoch) summary))))))

; decode messages heard, update epoch if necessary,
; add child summaries to our summary
(define (snoop_handler )
  (snoop_epoch (ref decode_message (snoop_msg) 0)))

(define (intercept_handler )
  (let ((fields (decode_message (intercept_msg))))
    (snoop_epoch (ref fields 0))
    ((ref avgtemp spatial_agg) (ref fields 1))))

(define (decode_message msg)
  (decode msg (list 2 (make_string spatialavg_length))))


;-- another attempt, now serious:

; query: (snquery 4576 0 'avg 'query-temp 60)

(define (query-temp) (list (temp-sensor) 1))
(define (avg x) (list (apply + (map first x)) (apply + (map second x))))

(define-handler (snquery parent reqid hop get-meas agg period)
  (letrec 
      ((epochstart 
        (lambda (epoch)
          (call-at-time (+ (now) period)
            (lambda ()
              (let ([req (assoc reqid waiting-reqs)])
                (if (and req (= (second req) epoch))  ; second req is epoch
                    (let ((meas (agg (third req)))) ;third req is list of values
                      (if (= hop 0)
                          ;if gateway (id 0) is parent, send result
                          (send-gateway `(queryresult ,reqid ,epoch ,meas))
                          ; otherwise propagate 
                          (send parent `(snqueryrecv ,reqid ,(- hop 1) ,epoch ,meas)))
                      (epochstart (+ epoch 1)))))))
          ; start epoch 
          (assoc-put! reqid (list epoch (list (get-meas))) waiting-reqs))))
    
    (if (not (assoc reqid waiting-reqs))
        (begin
          (bcast `(snquery ,reqid ,(+ hop 1) ,get-meas ,agg , period))
          (set! get-meas (eval get-meas))
          (set! agg (eval agg))
          (epochstart hop)))))

(define-handler (snqueryrecv src reqid hop epoch val)
  (let ((req (assoc reqid waiting-reqs)))
    (if (and req (= (second req) epoch))
        (assoc-put! reqid (list (second req) (cons val (third req))) waiting-reqs))))

(define-macro query-injector 
  (lambda (sexpr reqid get-meas agg)
    `(snquery ,reqid 0 ,get-meas ,agg)))
)
