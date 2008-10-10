(ssmodule std
  
  (require (lib macros) (lib primitives))
  
  (provide 
   caar cadr cdar cddr 
   caaar caadr cadar caddr cdaar cdadr cddar cdddr 
   caaaar caaadr caadar caaddr cadaar cadadr caddar cadddr 
   cdaaar cdaadr cdadar cdaddr cddaar cddadr cdddar cddddr 
   member memf map map2 filter filter-map any every find foldl foldr for-each 
   equal? = zero? my-append reverse append-reverse append-reverse! 
   sum length avg min max assoc assf assoc-put! assoc-remove! assoc-and-remove! 
   call-with-current-continuation let/cc do-at-time !=
   
   ; macros
   lambda define-macro cond define-handler case when begin do unless define define-const include let letrec and or quasiquote let*
   
   ;primitives
   id defined? car cdr set-car! set-cdr! cons + - * / % 
   bitwise-and bitwise-ior bitwise-xor > >= < <= eq? 
   null? pair? symbol? number? boolean? bitwise-not not 
   random now call-at-time sensor blink append list 
   print eval inject-handler apply call/cc 
   send-local send-local/ack send-serial 
   recv-local recv-local/ack recv-serial
   
   ;comm
   handle msg
   )
  
  
  ; standard functions
  (define-macro caar (lambda (a) `(car (car ,a))))
  (define-macro cadr (lambda (a) `(car (cdr ,a))))
  (define-macro cdar (lambda (a) `(cdr (car ,a))))
  (define-macro cddr (lambda (a) `(cdr (cdr ,a))))
  
  #;(define (caar x) (car (car x)))
  #;(define (cadr x) (car (cdr x)))
  #;(define (cdar x) (cdr (car x)))
  #;(define (cddr x) (cdr (cdr x)))
  
  (define (caaar x) (car (car (car x))))
  (define (caadr x) (car (car (cdr x))))
  (define (cadar x) (car (cdr (car x))))
  (define (caddr x) (car (cdr (cdr x))))
  (define (cdaar x) (cdr (car (car x))))
  (define (cdadr x) (cdr (car (cdr x))))
  (define (cddar x) (cdr (cdr (car x))))
  (define (cdddr x) (cdr (cdr (cdr x))))
  
  (define (caaaar x) (car (car (car (car x)))))
  (define (caaadr x) (car (car (car (cdr x)))))
  (define (caadar x) (car (car (cdr (car x)))))
  (define (caaddr x) (car (car (cdr (cdr x)))))
  (define (cadaar x) (car (cdr (car (car x)))))
  (define (cadadr x) (car (cdr (car (cdr x)))))
  (define (caddar x) (car (cdr (cdr (car x)))))
  (define (cadddr x) (car (cdr (cdr (cdr x)))))
  (define (cdaaar x) (cdr (car (car (car x)))))
  (define (cdaadr x) (cdr (car (car (cdr x)))))
  (define (cdadar x) (cdr (car (cdr (car x)))))
  (define (cdaddr x) (cdr (car (cdr (cdr x)))))
  (define (cddaar x) (cdr (cdr (car (car x)))))
  (define (cddadr x) (cdr (cdr (car (cdr x)))))
  (define (cdddar x) (cdr (cdr (cdr (car x)))))
  (define (cddddr x) (cdr (cdr (cdr (cdr x)))))
  
  (define rest cdr)
  
  (define (member x ls)
    (cond [(null? ls) #f]
          [(eq? (car ls) x) ls]
          [else (member x (cdr ls))]))
  
  (define (memf f ls)
    (cond [(null? ls) #f]
          [(f (car ls)) ls]
          [else (memf f (cdr ls))]))
  
  (define (map fn ls) 
    (if (pair? ls)
        (cons (fn (car ls)) (map fn (cdr ls)))
        ()))
  
  (define (map2 fn ls1 ls2) 
    (if (and (pair? ls1) (pair? ls2))
        (cons (fn (car ls1) (car ls2)) (map2 fn (cdr ls1) (cdr ls2)))
        ()))
  
  (define (filter fn ls) 
    (cond [(null? ls) ()]
          [(fn (car ls)) (cons (car ls) (filter fn (cdr ls)))]
          [else (filter fn (cdr ls))]))
  
  (define (filter-map fn ls)
    (if (pair? ls) 
        (let ([r (fn (car ls))])
          (if r (cons r (filter-map fn (cdr ls)))
              (filter-map fn (cdr ls))))
        ()))
  
  (define (any fn ls) 
    (cond [(null? ls) #f]
          [(fn (car ls)) #t]
          [else (any fn (cdr ls))]))
  
  (define (every fn ls) 
    (cond [(null? ls) #t]
          [(not (fn (car ls))) #f]
          [else (every fn (cdr ls))]))
  
  (define (find fn ls) 
    (cond [(null? ls) #f]
          [(fn (car ls)) (car ls)]
          [else (find fn (cdr ls))]))
  
  (define (foldl fn init ls)
    (define (foldl-hlp curr ls)
      (if (null? ls) 
          curr
          (foldl-hlp (fn (car ls) curr) (cdr ls))))
    (foldl-hlp init ls))
  
  (define (foldr fn init ls) 
    (if (null? ls)
        init
        (fn (car ls) (foldr fn init (cdr ls)))))
  
  (define (for-each fn ls)
    (if (null? ls)
        #t
        (begin (fn (car ls)) (for-each fn (cdr ls)))))
  
  
  (define (equal? left right)
    (if (and (pair? left) (pair? right)) 
        (cond [(and (null? left) (null? right)) #t]
              [(not (equal? (car left) (car right))) #f]
              [else (equal? (cdr left) (cdr right))])
        (eq? left right)))
  
  (define = eq?)        
  
  (define-macro (zero? v)
    `(eq? ,v 0))
  
  (define (my-append . lls) 
    (cond [(null? lls) '()]
          [(null? (cdr lls)) (car lls)]
          [else (foldr (lambda (v l) (cons v l)) (append (cdr lls) (car lls)))]))
  
  (define (reverse ls)
    (foldl cons () ls))
  
  (define (append-reverse rev-head tail)
    (let lp ((rev-head rev-head) (tail tail))
      (if (null-list? rev-head) tail
          (lp (cdr rev-head) (cons (car rev-head) tail)))))
  
  (define (append-reverse! rev-head tail)
    (let lp ((rev-head rev-head) (tail tail))
      (if (null-list? rev-head) tail
          (let ((next-rev (cdr rev-head)))
            (set-cdr! rev-head tail)
            (lp next-rev rev-head)))))
  
  
  (define (sum ls) 
    (if (pair? ls)
        (+ (car ls) (sum (cdr ls)))
        0))
  
  (define (length ls) 
    (if (null? ls)
        0
        (+ 1 (length (cdr ls)))))
  
  (define (avg ls) 
    (/ (sum ls)
       (length ls)))
  
  (define-macro minmax (lambda (op)
                         `(lambda (ls)
                            (letrec ((minmax-hlp (lambda (val ls)
                                                   (if (null? ls)
                                                       val
                                                       (if (,op val (car ls))
                                                           (minmax-hlp val (cdr ls))
                                                           (minmax-hlp (car ls) (cdr ls)))))))
                              (minmax-hlp (car ls) (cdr ls))))))
  
  (define min (minmax <))
  (define max (minmax >))
  
  ;; association list functions and macros
  (define (assoc obj alist) 
    (cond [(null? alist) #f]
          [(eq? obj (caar alist)) (car alist)]
          [else (assoc obj (cdr alist))]))
  
  (define (assf f alist) 
    (cond [(null? alist) #f]
          [(f (caar alist)) (car alist)]
          [else (assoc f (cdr alist))]))
  
  (define-macro (assoc-put! obj val alsvar)
    (let ((p (gensym)))
      `(let ((,p (assoc ,obj ,alsvar)))
         (if ,p 
             (set-cdr! ,p ,val)
             (set! ,alsvar (cons (cons ,obj ,val) ,alsvar))))))
  
  (define-macro (assoc-remove! obj alsvar)
    `(set! ,alsvar (filter (lambda (el) (not (eq? (car el) ,obj))) ,alsvar)))
  
  (define-macro (assoc-and-remove! obj alsvar)
    (let ((v (gensym)))
      `(let ((,v (assoc ,obj ,alsvar)))
         (assoc-remove! ,obj ,alsvar)
         ,v)))
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; sets of macros just to make frequent stuff shorter:
  
  (define call-with-current-continuation call/cc)
  
  (define-macro (let/cc k . body)
    `(call/cc (lambda (,k) ,@body)))  
  
  (define-macro (do-at-time time . body)
    `(call-at-time ,time (lambda () ,@body)))
  
  (define-macro (!= exp1 exp2)
    `(not (= ,exp1 ,exp2)))
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; communication-related functions and acros, independent of 
  ; transmssion method (radio / serial)
  
  ; procedure to handle forwarding messages through protocol layers
  (define (handle src msg) 
    (apply (eval (car msg)) (cons src (cdr msg))))
  
  (define-macro (msg tag . body)
    `(list ',tag ,@body))  
  
  
  
  ) ; end of service definition  
