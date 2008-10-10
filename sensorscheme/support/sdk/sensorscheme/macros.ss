(ssmodule
    macros
  
  (provide lambda define-macro cond define-handler case when begin do unless define define-const include let letrec and or quasiquote let*)  
  ; macro's to translate to the internal basic forms
  (%define-macro% 
   lambda 
   (lambda (args . exprs) 
     (if (and (pair? (car exprs)) (eq? (caar exprs) 'define))
         (let ((defines (filter (%lambda% (l) (eq? (car l) 'define)) exprs))
               (rest (filter (%lambda% (l) (not (eq? (car l) 'define))) exprs)))
           (letrec ((define-name (lambda (def) (if (pair? (cadr def)) (caadr def) (cadr def))))
                    (define-body (lambda (def) (if (pair? (cadr def)) `(lambda ,(cdadr def) ,@(cddr def))
                                                   (caddr def)))))
             (let ((names (map define-name defines))
                   (bodies (map define-body defines)))
               `(lambda ,args (letrec ,(map (lambda (n b) `(,n ,b)) names bodies)
                                ,@rest)))))
         `(%lambda% ,args ,@exprs))))
  
  (%define-macro% 
   define-macro 
   (lambda exprs (cond 
                   [(not (pair? exprs)) (error 'define-macro "incorrect syntax")]
                   [(symbol? (car exprs)) 
                    (cons '%define-macro% exprs)]
                   [(pair? (car exprs))
                    ; defining a function
                    (list '%define-macro% (car (car exprs)) 
                          (cons '%lambda% (cons (cdr (car exprs)) (cdr exprs))))]
                   [else (error 'define-macro "incorrect syntax")])))
  
  (define-macro (define . exprs) 
    (cond 
      [(not (pair? exprs)) (error 'define "incorrect syntax")]
      [(symbol? (car exprs)) 
       (cons '%define% exprs)]
      [(pair? (car exprs))
       ; defining a function, make it constant
       (list '%define-const% (car (car exprs)) 
             (cons 'lambda (cons (cdr (car exprs)) (cdr exprs))))]
      [else (error 'define "incorrect syntax")]))
  
  (define-macro (define-handler nameargs . exprs) 
    (if (symbol? nameargs) 
        `(%begin% (%include ,nameargs%) (%define-const% ,nameargs ,@exprs))
        ; else first argument must be a list, defining a function
        `(%begin% (%include% ,(car nameargs)) (%define-const% ,(car nameargs)
                                                        (lambda (src ,@(cdr nameargs)) ,@exprs)))))
  
  (define-macro (define-const . exprs) 
    (cond 
      [(not (pair? exprs)) (error 'define-const "incorrect syntax")]
      [(symbol? (car exprs)) 
       (cons '%define-const% exprs)]
      [(pair? (car exprs))
       ; defining a function
       (list '%define-const% (car (car exprs)) 
             (cons 'lambda (cons (cdr (car exprs)) (cdr exprs))))]
      [else (error 'define "incorrect syntax")]))
  
  
  #;(define-macro if 
      (lambda exns `(%if% ,@exns)))
  
  #;(define-macro quote 
      (lambda (exn) `(%quote% ,exn)))
  
  #;(define-macro set! 
      (lambda (var val) `(%set!% ,var val)))
  
  (define-macro (include . exns) `(%include% ,@exns))
  
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ; other macros that define other useful syntactic constructs
  
  (define-macro (begin . exprs)
    (cond ((null? exprs) exprs)
          ((= (length exprs) 1) (car exprs))
          (else `((lambda () ,@exprs)))))
  
  (define-macro (cond . clauses)
    (define (cond-expand clauses)
      (if (null? clauses) 
          #f
          (if (or (eq? (car (car clauses)) 'else) (eq? (car (car clauses)) #t))
              (cons 'begin (cdr (car clauses)))
              (list 'if (car (car clauses)) 
                    (cons 'begin (cdr (car clauses)))
                    (cond-expand (cdr clauses))))))
    (cond-expand clauses))
  
  (define-macro (when test . clauses)
    (list 'if test (cons 'begin clauses)))
  
  (define-macro (unless test . clauses)
    (list 'if (list 'not test) (cons 'begin clauses)))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
  ;; Scheme primitives implemented in Scheme.
  ;; The quasiquote, and a few others, are from Darius Bacon <djello@well.com>
  ;; (But then, he started with my PAIP code, and modified it.)
  ;; - Peter Norvig
  
  ;;;;;;;;;;;;;;;; Standard Scheme Macros
  
  (define-macro (or . args)
    (if (not (null? args))
        (cons 'cond (map list args))))
  
  (define-macro (and . args)
    (cond ((null? args) #t)
          ((null? (cdr args)) (car args))
          (else (list 'if (car args) (cons 'and (cdr args)) #f))))
  
  (define-macro (quasiquote x) 
    (define (constant? exp)
      (if (pair? exp) (eq? (car exp) 'quote) (not (symbol? exp))))
    (define (combine-skeletons left right exp)
      (cond
        ((and (constant? left) (constant? right)) 
         (if (and (eqv? (eval left) (car exp))
                  (eqv? (eval right) (cdr exp)))
             (list 'quote exp)
             (list 'quote (cons (eval left) (eval right)))))
        ((null? right) (list 'list left))
        ((and (pair? right) (eq? (car right) 'list))
         (cons 'list (cons left (cdr right))))
        (else (list 'cons left right))))
    (define (expand-quasiquote exp nesting)
      (cond
        ;((vector? exp)
        ; (list 'apply 'vector (expand-quasiquote (vector->list exp) nesting)))
        ((not (pair? exp)) 
         (if (constant? exp) exp (list 'quote exp)))
        ((and (eq? (car exp) 'unquote) (= (length exp) 2))
         (if (= nesting 0)
             (cadr exp)
             (combine-skeletons ''unquote 
                                (expand-quasiquote (cdr exp) (- nesting 1))
                                exp)))
        ((and (eq? (car exp) 'quasiquote) (= (length exp) 2))
         (combine-skeletons ''quasiquote 
                            (expand-quasiquote (cdr exp) (+ nesting 1))
                            exp))
        ((and (pair? (car exp))
              (eq? (caar exp) 'unquote-splicing)
              (= (length (car exp)) 2))
         (if (= nesting 0)
             (list 'append (cadr (car exp))
                   (expand-quasiquote (cdr exp) nesting))
             (combine-skeletons (expand-quasiquote (car exp) (- nesting 1))
                                (expand-quasiquote (cdr exp) nesting)
                                exp)))
        (else (combine-skeletons (expand-quasiquote (car exp) nesting)
                                 (expand-quasiquote (cdr exp) nesting)
                                 exp))))
    (expand-quasiquote x 0))
  
  (define-macro (let bindings . body) 
    (define (named-let name bindings body)
      `(let ((,name #f))
         (set! ,name (lambda ,(map car bindings) . ,body))
         (,name . ,(map cadr bindings))))
    (if (symbol? bindings) 
        (named-let bindings (car body) (cdr body))
        `((lambda ,(map car bindings) . ,body) . ,(map cadr bindings))))
  
  (define-macro (let* bindings . body)
    (if (null? bindings) `((lambda () . ,body))
        `(let (,(car bindings))
           (let* ,(cdr bindings) . ,body))))
  
  (define-macro (letrec bindings . body)
    (let ([vars (map car bindings)]
          [vals (map cadr bindings)]
          [illegals (filter (lambda (el) (not (eq? (caadr el) 'lambda))) bindings)])
      (if (not (null? illegals)) (error 'letrec "non-lambda member. ~s" illegals))
      `(let ,(map (lambda (var) `(,var #f)) vars)
         ,@(map (lambda (var val) `(set! ,var ,val)) vars vals)
         . ,body)))
  
  (define-macro (case exp . cases)
    (define (do-case case)
      (cond ((not (pair? case)) (error "bad syntax in case" case))
            ((eq? (car case) 'else) case)
            (else `((member __exp__ ',(car case)) . ,(cdr case)))))
    `(let ((__exp__ ,exp)) (cond . ,(map do-case cases))))
  
  (define-macro (do bindings test-and-result . body)
    (let ((variables (map car bindings))
          (inits (map cadr bindings))
          (steps (map (lambda (clause)
                        (if (null? (cddr clause))
                            (car clause)   
                            (caddr clause)))
                      bindings))
          (test (car test-and-result))
          (result (cdr test-and-result)))
      `(letrec ((__loop__
                 (lambda ,variables
                   (if ,test
                       (begin . ,result)
                       (begin 
                         ,@body
                         (__loop__ . ,steps))))))
         (__loop__ . ,inits))))
  
  ; (define-macro (delay exp) 
  ;     (define (make-promise proc)
  ;       (let ((result-ready? #f)
  ;             (result #f))
  ;         (lambda ()
  ;           (if result-ready?
  ;               result
  ;               (let ((x (proc)))
  ;                 (if result-ready?
  ;                     result
  ;                     (begin (set! result-ready? #t)
  ;                            (set! result x)
  ;                            result)))))))
  ;     `(,make-promise (lambda () ,exp)))
  
  
  )