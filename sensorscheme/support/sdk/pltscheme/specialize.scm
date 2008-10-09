#lang scheme

(require (file "modules.scm") srfi/1 srfi/26)

(provide specialize-module)

(define *verbose* #t)

(define *parteval-ns* (make-base-namespace))

(define (specialize-module mod-name node-id)
  (define (select-module todo-mdls done-mdls)
    (printi "specialize-module  ~s ~s~n" (map ssmodule-name todo-mdls) (map ssmodule-name done-mdls))
    (if (or (null? todo-mdls) (member (car todo-mdls) done-mdls)) (values '() '() '())          
        (let-values ([(mdls1 defs1 inits1) 
                      (select-module (ssmodule-requires (car todo-mdls)) done-mdls)])
          (let*-values ([(new-inits new-defs) (specialize-module-exprs (ssmodule-init (car todo-mdls)) '() (car todo-mdls))])
            (printi "~nmodule ~s defs: ~s~n       inits: ~s~n" 
                    (ssmodule-name (car todo-mdls)) new-defs new-inits)
            (let-values ([(mdls2 defs2 inits2) (select-module (cdr todo-mdls) (cons (car todo-mdls) done-mdls))])
              (values (append (list (car todo-mdls)) mdls1 mdls2) 
                      (append new-defs defs1 defs2) (append new-inits inits1 inits2)))))))
  (let ([s-mod (process-module mod-name)])
    (when (number? node-id) (hash-set! (ssmodule-defines s-mod) 'id `(const ,node-id)))
    (let-values ([(mdls defs inits) (select-module (list s-mod) null)])
      (values mdls defs inits))))

; auxillary funcitons for variables in environments
(define (constant-var? exp) (eq? (second exp) 'const))
(define (constant-value c) (third c))

(define (specialize-module-exprs exprs defs mdl)
  (define (lookup var env)
    (or (assoc var env) (find-global var)))
  
  ; find a global variable in the module's definitions. if success and this is 
  ;   the first reference of the variable, move its definition to the used list
  (define (find-global name)
    ;(printi "find-global ~s //~s~n" name (map car defs))
    (let ([def-val (assoc name defs)])
      (if def-val def-val
          (let ([val (hash-ref (ssmodule-defines mdl) name #f)])
            (if val (begin (when *verbose* (printi "defined ~s: ~s~n" name val))
                           (cond [(eq? (first val) 'const)
                                  (set! defs (cons (cons name `(define ,(second val))) defs))
                                  (let ([c-val (specialize-expr '() (second val))])
                                    (set! defs (map (lambda (d) (if (eq? (car d) name) `(,name const ,c-val) d)) defs))
                                    (printi "const defined ~s ~s~n" name (third (assoc name defs))))]
                                 [else (set! defs (cons (cons name val) defs))])
                           (assoc name defs))
                (error (ssmodule-name mdl) "not found global ~s~n" name))))))
  
  (define (find-primitive name)
    (let ([val (hash-ref (ssmodule-defines mdl) name #f)])
      (if val (if (eq? (first val) 'primitive) (second val) #f) #f)))
  
  (define (constant-expr? exp)
    (match exp 
      [(list '%proc% _ _ _ ...) #t]
      [(list 'quote val) #t]
      [(or (? number? _) (? string? _) (? null? _) (? boolean? _)) #t]
      [(list _ ...) #f]
      [(? symbol? _) #f]
      [c (printi "constant? ~s~n" c) #f]))
  
  
  (define (specialize-app env fn exprs)    
    (define (specialize-global-app name args params)
      (printi "specialize-global-app ~s ~s~n" args params)
      (let loop ([name (symbol->string name)] [args args] [params params] [call-args null] [call-params null] [call-env null])
        (if (null? params) ; done parsing parameters?
            (values (string->symbol name) (reverse call-args) (reverse call-params) call-env)
            (if (constant-expr? (car args)) 
                (loop (string-append name "<" (symbol->string (car params)) ":" 
                                     (let ([out (open-output-string)])
                                       (write (car args) out)
                                       (get-output-string out)) ">") 
                      (cdr args) (cdr params) call-args call-params (cons (list (car params) 'const (car args)) call-env))
                (loop name (cdr args) (cdr params) (cons (car args) call-args) (cons (car params) call-params) 
                      (cons (list (car params) 'var) call-env))))))
    
    (define (specialize-lambda-app args params)
      (printi "specialize-lambda-app ~s ~s~n" args params)
      (let loop ([args args] [params params] [call-args null] [call-params null] [call-env null])
        (if (null? params) ; done parsing parameters?
            (values (reverse call-args) (reverse call-params) call-env)
            (if (constant-expr? (car args)) 
                (loop (cdr args) (cdr params) call-args call-params (cons (list (car params) 'const (car args)) call-env))
                (loop (cdr args) (cdr params) (cons (car args) call-args) (cons (car params) call-params) 
                      (cons (list (car params) 'var) call-env))))))
    
    (define (make-global-app sp-fn sp-exprs)
      (printi "    make-global-app ~s :: ~s with ~s~n"  `(,fn ,@sp-exprs) (cddr sp-fn) env)
      (when (not (eq? (first sp-fn) '%proc%)) 
        (raise-user-error 'specialize-program "trying to specialize non-function ~s" fn))
      (let-values ([(sp-name call-args call-params call-env) (specialize-global-app fn sp-exprs (third sp-fn))])
        (when (not (assoc sp-name defs)) ; not yet created this funtion, do specialize now! 
          (printi "creating specialized function ~s ~s ~s ~n" sp-name call-args call-params)
          (set! defs (cons `(,sp-name define #f) defs))
          (let*-values ([(new-env) (append call-env (second sp-fn))]
                        [(new-body) (map (cut specialize-expr new-env <>) (cdddr sp-fn))])
            (set! defs (map (lambda (d) (if (eq? (car d) sp-name) `(,sp-name const (%proc% ,env ,call-params ,@new-body)) d)) defs))))
        (let ([new-fun (third (assoc sp-name defs))])
          (printi "fun ~s = ~s~n" sp-name new-fun)
          (if new-fun
              (let ([new-body (cdddr new-fun)])
                (printi "body: ~s~n" new-body)
                (cond ; specialize the result. if application can be made more simple, do so here!!
                  [(every (cut constant-expr? <>) new-body) (last new-body)]
                  [(and (null? call-params) (null? (cdr new-body))) (car new-body)] 
                  [else `(,sp-name ,@call-args)]))
              `(,sp-name ,@call-args)))))
    
    (define (make-lambda-app fn exprs)
      ;(printi "make-lambda-app ~s : ~s with ~s~n" fn exprs env)
      (when (not (eq? (first fn) '%proc%)) 
        (raise-user-error 'specialize-program "trying to specialize non-lambda form ~s" fn))
      (let*-values ([(call-args call-params call-env) (specialize-lambda-app exprs (third fn))]
                    [(new-env) (append call-env (second fn))]
                    [(new-body) (map (cut specialize-expr new-env <>) (cdddr fn))])
        (cond ; specialize the result. if application can be made more simple, do so here!!
          [(every (cut constant-expr? <>) new-body) (last new-body)]
          [(and (null? call-params) (null? (cdr new-body))) (car new-body)] 
          [else
           (printi "specialized lambda call ~s~n" `((%proc% ,(second fn) ,call-params ,@new-body) ,@call-args))
           `((%proc% ,(second fn) ,call-params ,@new-body) ,@call-args)])))
    
    (define (make-const-val val)
      (if (or (symbol? val) (pair? val) (null? val)) `(quote ,val) val))
    (let ([sp-fn (specialize-expr env fn)]
          [sp-exprs (map (cut specialize-expr env <>) exprs)])
      (if (constant-expr? sp-fn)
          (if (symbol? fn)
              (if (assoc fn env) ; local variable
                  (begin (printi "calling constant local variable ~s on ~s~n" fn sp-exprs)
                         (make-lambda-app sp-fn sp-exprs))
                  ;else global var
                  (make-global-app sp-fn sp-exprs))
              (make-lambda-app sp-fn sp-exprs))
          
          ;else, fn not a constant, so just leave it in
          (let ([prim (find-primitive fn)])
            (printi "prim ~s : ~s~n" fn prim)
            (if (and prim (pair? (cddr prim)) (every constant-expr? sp-exprs)) 
                (begin (printi "evaluate prim!!! ~s" `(,(third prim) ,@sp-exprs))
                       (printi " : ~s~n" (eval `(,(third prim) ,@sp-exprs) *parteval-ns*)) 
                       (make-const-val (eval `(,(third prim) ,@sp-exprs) *parteval-ns*)))
                `(,fn ,@sp-exprs))))))
  
  (define (specialize-if env pred conseq alt)
    (let ([sp-pred (specialize-expr env pred)])
      (if (constant-expr? sp-pred) 
          (if sp-pred ; the actual constant 
              (specialize-expr env conseq) 
              (specialize-expr env alt))
          (let ([left (specialize-expr env conseq)]
                [right (specialize-expr env alt)])
            (cond [(equal? left right) left]
                  [else `(if ,sp-pred ,left ,right)])))))
  
  (define (specialize-lambda env params body)
    (let* ([body-env (append (reverse (map (lambda (p) (list p 'var)) params)) env)]
           [new-body (map (cut specialize-expr body-env <>) body)])
      (printi "specialize-lambda ~s ~s~n" params new-body)
      `(%proc% ,env ,params ,@new-body)))
  
  (define (specialize-expr env expr)
    (printi-up "specialize-expr ~s with ~s~n" expr env)
    (let ([res (match expr
                 [(list '%include% syms ...) (printi "syms: ~s~n" syms) (map find-global syms) expr]
                 [(list 'if pred conseq alt) (specialize-if env pred conseq alt)]
                 [(list 'if pred conseq) (specialize-if env pred conseq #f)]
                 [(list 'quote val) expr]
                 [(list 'set! (? symbol? var) val) (lookup var env) `(set! ,var #;,val ,(specialize-expr env val))]
                 [(list '%lambda% params body ...) (specialize-lambda env params body)]
                 [(list '%proc% _ params body ...) `(%proc% ,env ,params ,@body)]
                 [(list fn exprs ...) (specialize-app env fn exprs)]
                 [(? symbol? sym) (cond [(lookup sym env) => (lambda (v) (if (constant-var? v) (constant-value v) sym))]
                                        [else (raise-user-error 'specialize-program "reference of unknown variable ~s" sym)])]
                 [(or (? number? _) (? null? _) (? boolean? _) (? string? _)) expr]
                 
                 [expr (raise-user-error 'specialize-expr "illegal expression: ~s" expr)])])
      (printi-dn "specialize-expr result ~s   :   ~s~n" expr res)
      res))
  
  (printi "specialize-module-exprs ~s~n" exprs)
  (values (map (cut specialize-expr null <>) exprs)
          (reverse defs)))



; renames all local variables to the standard local-variable names, 
; that can be indexed by name
; exp: exression to rename (should come from top level of module)
; returns renamed verion of exp, sharing structures where possible
(define (rename-locals exp)
  (define (varlist l n)
    (cond ((null? l) null)
          ((symbol? l) (cons (cons l (string->symbol (string-append "%l" (number->string n)))) null))
          (else (cons (cons (car l) (string->symbol (string-append "%l" (number->string n)))) 
                      (varlist (cdr l) (+ n 1))))))
  (define (replace-vars v al) 
    (cond ((null? v) null)
          ((symbol? v) (cdr (assoc v al)))
          (else (cons (cdr (assoc (car v) al)) (replace-vars (cdr v) al)))))
  (define (rename-locals-inner exp locals)
    (cond [(pair? exp)
           (case (car exp)
             [(%lambda%) (let* ((ll (varlist (cadr exp) (length locals)))
                                (nvars (replace-vars (cadr exp) ll))
                                (nlocs (append ll locals)))
                           (cons '%lambda% 
                                 (cons nvars (map (lambda (x) (rename-locals-inner x nlocs)) (cddr exp)))))]
             [(quote) exp]
             [else (map (lambda (x) (rename-locals-inner x locals)) exp)]
             )]
          [(symbol? exp) (let ((r (assoc exp locals)))
                           (if r (cdr r) exp))]
          [else exp]))
  #;(printf "rename-locals ~s~n" exp)
  (let ([r (rename-locals-inner exp null)])
    ; (printf ": ~s~n" r)
    r))


(define s-e-cnt 0)
(define (s-e-cnt-same)
  (make-string s-e-cnt #\space))
(define (s-e-cnt-up)
  (begin0 (make-string s-e-cnt #\space) (set! s-e-cnt (+ 1 s-e-cnt))))
(define (s-e-cnt-dn)
  (begin (set! s-e-cnt (- s-e-cnt 1)) (make-string s-e-cnt #\space)))
(define (printi fmt . args)
  (printf "~a~a" (s-e-cnt-same) (apply format fmt args)))
(define (printi-up fmt . args)
  (printf "~a~a" (s-e-cnt-up) (apply format fmt args)))
(define (printi-dn fmt . args)
  (printf "~a~a" (s-e-cnt-dn) (apply format fmt args)))
