(ssmodule bananas
  (require (lib std) 
           (lib network))
  
  (define LED_RED 1)
  (define LED_GREEN 2)  
  (define LED_BLUE 4)
  
  (define type (cond [(= id 0) 'farm]
                     [(= id 1) 'harbor]
                     [(= id 2) 'truck]
                     [(= id 3) 'container]
                     [(= id 4) 'coffee]
                     [(= id 5) 'coffee]
                     [else 'banana]))
  
  (define type-list ())
  (define-handler (announce rcv-type)
    (set! type-list (cons rcv-type type-list)))
  
  (define (update-state state types)
    (cond [(eq? type 'banana)
           (cond [(= state 0) (if (member 'truck type-list) 1 0)]
                 [(= state 1) (if (member 'harbor type-list) 2 1)]
                 [(= state 2) (if (member 'container type-list) 3 2)]
                 [(= state 3) (if (member 'farm type-list) 4 3)])]
          [(eq? type 'coffee) state]
          [else (number-of 'banana types)]))
  
  (define (number-of tp types)
    (length (filter (lambda (t) (eq? t tp)) types)))
  
  (define (led-blink state types) 
    (+ (cond 
         [(eq? type 'banana) 
          (if (>= (+ 1 (number-of 'banana types)) (* 2 (number-of 'coffee types))) 
              LED_GREEN LED_RED)]
         [(eq? type 'coffee) 
          (if (member 'banana types) LED_RED LED_GREEN)]
         [else (if (member 'coffee types) LED_RED LED_GREEN)])        
       (if (> state 0) LED_BLUE 0)))
  
  (define (time-loop t state) 
    (bcast (msg announce type))      
    (let* ([types type-list]
           [new-state (update-state state types)])
      (set! type-list ())
      (blink (led-blink new-state types))
      (call-at-time (+ t (if (= new-state 0) 8 (- (* new-state 4) 2))) 
        (lambda (t) (blink 0)))
      (call-at-time (+ t 16) (lambda (t) (time-loop t new-state)))))
  
  (time-loop (now) 0)
  )