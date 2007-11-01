(eval-handler
  ((%lambda%
     ()
     (%define%
       map
       (%lambda%
         (%l0 %l1)
         (if (pair? %l1) (cons (%l0 (car %l1)) (map %l0 (cdr %l1))) ()))
       length
       (%lambda% (%l0) (if (null? %l0) 0 (+ 1 (length (cdr %l0)))))
       numlist
       (%lambda% (%l0) (if (> %l0 0) (cons %l0 (numlist (- %l0 1))) '()))
       tail-recursion
       (%lambda%
         (%l0 %l1)
         (if (> %l0 0) (tail-recursion (- %l0 1) (cons %l0 %l1)) %l1))
       var
       (apply - (list 1 2 3 5)))
     (call/cc
       (%lambda%
         (%l0)
         (set-car!
           (cons 1 2)
           (length
             (eval
              '(list
                (< 1 0)
                (> -1 0)
                (>= 1 8)
                (<= 8191 12)
                (number? 16)
                (boolean? #t)
                (symbol? 'a)
                (eq? 3762 3762)))))
         (set! var
           ((%lambda%
              (%l1 %l2)
              (set-cdr! (cons 1 2) 3)
              (car (cons (if (> (/ %l1 %l2) (- 1 (+ %l1 %l2))) #f #t) '())))
            (* 4095 20)
            (% 1543 56)))
         (call-at-time
           (+ (now) 16)
           (%lambda%
             ()
             (bcast (cons '+ (tail-recursion 50 ())))
             (send-serial
               (cons '+ (map (%lambda% (%l1) (+ %l1 65535)) (numlist 15))))
             (blink 8201)
             (%l0 #f))))))))
