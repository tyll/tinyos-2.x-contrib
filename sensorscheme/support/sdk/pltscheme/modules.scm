#lang scheme

(require  
 (only-in srfi/1 lset-union lset-difference append-map append-reverse filter-map every))

(require (only-in mzscheme make-namespace))

(provide compile-module set-module-macroexpand! set-module-verbose! write-node-conf read-node-conf)

(provide ssmodule-requires ssmodule-init find-all-globals find-globals lookup-globals ssmodule-name ssmodule-defines process-module)

(define-struct ssmodule (file name defines provides requires init) #:mutable)

; used to hold command-line param
(define *macroexpand* #f)

(define (set-module-macroexpand! v)
  (set! *macroexpand* v))

(define *verbose* #f)
(define (set-module-verbose! v)
  (set! *verbose* v))

(define (put-global! mdl name kind val)
  (if (hash-ref (ssmodule-defines mdl) name #f)
      (error (ssmodule-name mdl) "redefinition of symbol ~s~n" name)
      (begin
        #;(printf "-- defining a ~s \"~s\" to ~s~n" kind name val)
        (hash-set! (ssmodule-defines mdl) name (list kind val)))))

(define (find-global-kind mdl kind)
  (filter (lambda (l) l) (hash-map (ssmodule-defines mdl) 
                                   (lambda (k v) (if (eq? (car v) kind) (cons k (cdr v)) #f)))))

(define (get-global mdl name kind)
  (let ([val (hash-ref (ssmodule-defines mdl) name #f)])
    (if (and val (eq? (car val) kind)) val #f)))

(define mdl-path-list '("."))
(define lib-path-list (list (build-path (getenv "TOSROOT") "support" "sdk" "sensorscheme")))
(define (find-module file)
  (let-values ([(file path-list) (if (and (list? file) (eq? (car file) 'lib))
                                     (values (if (symbol? (cadr file)) (string-append (symbol->string (cadr file)) ".ss") 
                                                 (cadr file)) lib-path-list)
                                     (values file mdl-path-list))])
    (let/cc break
      (if (absolute-path? file)
          (when (file-exists? file) (break file))
          (for-each 
           (lambda (p) 
             (let ((fp (path->complete-path (build-path p file))))
               (when (file-exists? fp)
                 (break fp))))
           path-list))
      (error 'find-module "module ~s not found~n" file))))

; gets all code needed for given module 
; 
(define (select-module todo-mdls done-mdls)
  #;(printf "select-module  ~s ~s~n" (map ssmodule-name todo-mdls) (map ssmodule-name done-mdls))
  (if (or (null? todo-mdls) (member (car todo-mdls) done-mdls)) (values '() '() '())          
      (let-values ([(mdls1 defs1 inits1) 
                    (select-module (ssmodule-requires (car todo-mdls)) done-mdls)])
        (let* ([new-inits (ssmodule-init (car todo-mdls))]
               [new-defs (find-all-globals new-inits '() (car todo-mdls))])
          #;(printf "module ~s defs: ~s~n       inits:~s~n" 
                    (ssmodule-name (car todo-mdls)) new-defs new-inits)
          (let-values ([(mdls2 defs2 inits2) (select-module (cdr todo-mdls) (cons (car todo-mdls) done-mdls))])
            (values (append (list (car todo-mdls)) mdls1 mdls2) 
                    (append new-defs defs1 defs2) (append new-inits inits1 inits2)))))))

; get all code dependencies for the main module of a SensorScheme app
(define (compile-module mfile)
  (let-values ([(mdls defs inits) (select-module (list (process-module mfile)) '())])
    (values mdls (map (lambda (el) (if (member (second el) '(const define)) 
                                       (list (first el) (second el) (rename-locals (third el)))
                                       el)) defs)
            (map (lambda (el) (rename-locals el)) inits))))

(define module-cache (make-hash))
(define (process-module mfile)
  (or (hash-ref module-cache mfile #f)
      ; Start by doing the whole module definition
      (let ([exps (with-input-from-file (find-module mfile) 
                    (lambda () (read)))])
        (when (not (eq? (car exps) 'ssmodule))
          (error 'process-module "File ~s is not a valid module (no ssmodule found at start)~n" mfile))
        (when *verbose* (printf "process-module ~s~n" mfile))
        (let ([mdl (make-ssmodule mfile (cadr exps) (make-hasheq) '() '() '())])
          (define (process-clauses clauses)
            (unless (null? clauses)
              (process-clause (macro-expand (car clauses) mdl))
              (process-clauses (cdr clauses))))
          
          ; Dispatch on the type of the clause.
          (define (process-clause clause)
            (when (pair? clause)
              (case (car clause)
                [(require)
                 (let ([new-mdls (map (lambda (el) (process-module el)) (cdr clause))])
                   (set-ssmodule-requires! mdl (append new-mdls (ssmodule-requires mdl)))
                   (for-each (lambda (other-mdl)
                               (for-each (lambda (defk)
                                           (let ([defv (hash-ref (ssmodule-defines other-mdl) defk #f)])
                                             (if defv (if (hash-ref (ssmodule-defines mdl) defk #f) 
                                                          (error (ssmodule-name mdl) 
                                                                 "redefinition of ~s in require~n" defk)
                                                          (hash-set! (ssmodule-defines mdl) defk defv))
                                                 (error (ssmodule-name mdl) "definition of ~s not found~n" defk)))) 
                                         (ssmodule-provides other-mdl))) new-mdls))]
                [(provide)
                 (set-ssmodule-provides! mdl (append (cdr clause) (ssmodule-provides mdl)))]
                #;[(include)
                   (set-ssmodule-includes! mdl (append (cdr clause) (ssmodule-includes mdl)))]
                [(%begin%)
                 (for-each process-clause (cdr clause))]
                [(%define%)
                 (put-global! mdl (cadr clause) 'define (caddr clause))]
                [(%define-const%)
                 (put-global! mdl (cadr clause) 'const (caddr clause))]
                [(%define-macro%)
                 (put-global! mdl (cadr clause) 'macro (caddr clause))
                 #;(printf "define-macro ~s: ~s~n" (cadr clause) 
                           (cdr (hash-ref (ssmodule-defines mdl) (cadr clause))))]
                [(define-primitive)
                 (put-global! mdl (cadr clause) 'primitive (caddr clause))]
                [(define-receiver)
                 (put-global! mdl (cadr clause) 'receiver (caddr clause))]
                [else
                 (set-ssmodule-init! mdl (cons clause (ssmodule-init mdl)))])))            
          (process-clauses (cddr exps))
          ; check that provides clause is consistent: only existing values, no doubles
          (let loop ([ls (ssmodule-provides mdl)])
            (when (not (null? ls))
              (cond [(member (car ls) (cdr ls)) (error (ssmodule-name mdl) "duplicate \"~s\" in provides~n" (car ls))]
                    [(hash-ref (ssmodule-defines mdl) (car ls) 
                               (lambda () (error (ssmodule-name mdl) "provided \"~s\" not defined~n" (car ls))))])
              (loop (cdr ls))))
          #;(hash-table-for-each (ssmodule-defines mdl) (lambda (k v)
                                                          (printf "~s: ~s~n" k v)))
          (hash-set! module-cache mfile mdl)
          mdl))))

(define (macro-expand exp mdl)
  ; expand macros in module
  (if (pair? exp)
      (let ([expander (get-global mdl (car exp) 'macro)])
        (if expander 
            (macro-expand 
             (let* ([eval-exp (cons (cadr expander) 
                                    (map (lambda (x) (list 'quote x)) (cdr exp)))]
                    [orig-ns (current-namespace)])
               (when *macroexpand* (printf "macro-expand ~s: " (car exp)))
               (parameterize ([current-namespace macro-namespace])      
                 (let ([result (with-handlers ([exn? 
                                                (lambda (exn)     
                                                  (printf "Error during macro-expand of ~s : ~s in ~s~n" 
                                                          (car exp) (exn-message exn) exp))]) 
                                 (eval eval-exp))])
                   (when *macroexpand* (printf "expanding ~s to ~s~n" exp result))
                   result))) mdl)
            (if (list? exp) (map (lambda (x) (macro-expand x mdl)) exp) exp)))
      exp))

; make sure all required definitions are in the macroexpansion namespace

(define macro-namespace (parameterize ([current-namespace (make-namespace)])
                          (namespace-require '(all-except (lib "1.ss" "srfi") reverse! member map for-each assoc append!))
                          (namespace-require `(file ,(path->string (build-path (getenv "TOSROOT")
                                                                               "support" "sdk" "pltscheme" "internal-forms.scm"))))
                          (current-namespace)
                          ))


; finds all globals referred to in expressions
; returns list of found global identifiers
(define (find-globals exps)
  (define (dotted-map fn ls)
    (if (null? ls)
        '()
        (if (pair? ls)
            (cons (fn (car ls)) (dotted-map fn (cdr ls)))
            (list (fn ls)))))
  (define (find-in-exp exp locals)
    (if (pair? exp)
        ;function application
        (case (car exp)
          ;lambda found, add local vars 
          [(%lambda%)
           (let ((newlocals (append (cadr exp) locals)))
             (apply lset-union (cons eq? (map (lambda (el) (find-in-exp el newlocals)) (cddr exp)))))]
          ;if
          [(if)
           (apply lset-union eq? (dotted-map (lambda (el) (find-in-exp el locals)) (cdr exp)))]
          ;quote found, ignore argument
          [(quote)
           '()]
          [(set!)
           (when (not (symbol? (cadr exp))) (error 'set! "first argument not a variable reference: ~s~n" (cadr exp)))
           (lset-union eq? (find-in-exp (cadr exp) locals) (find-in-exp (caddr exp) locals))]
          ; include only names other symbols to find
          [(%include%) (when (not (every symbol? (cdr exp))) (error "parameters to include should all be symbols")) 
                       (apply lset-union eq? (map (lambda (el) (find-in-exp el locals)) (cdr exp)))]
          ; process each term in application as exression
          (else (apply lset-union eq? (dotted-map (lambda (el) (find-in-exp el locals)) exp))))
        ; code not pair, must be varref or constant
        (if (or (member exp locals) (not (symbol? exp)))
            ; local var ref
            '() 
            ;global var
            (list exp))))
  
  (let ((r (apply lset-union (cons eq? (map (lambda (el) (find-in-exp el '())) exps)))))
    ;(printf "find-globals ~s: ~s~n" exps r)
    r))

; recursively checks the globals referred to
; exps: code to look for globals 
; found: list of definitions of globals already found in previous call
(define (find-all-globals exps found mdl)
  (if (null? exps) found
      (let ([globals-to-find (lset-difference eq? (find-globals exps) (map car found))])
        ;(printf "in ~s~nto find: ~s~n" exps globals-to-find)
        (let ([new-found (lookup-globals mdl globals-to-find)])
          (find-all-globals (filter-map (lambda (el) (case (cadr el) 
                                                       [(define const) (caddr el)]
                                                       [else #f])) new-found) 
                            (append new-found found) mdl)))))

(define (lookup-globals mdl globals)
  (map (lambda (name) (let ([val (hash-ref (ssmodule-defines mdl) name #f)])
                        (if val (begin (when *verbose* (printf "val ~s: ~s~n" name val)) (cons name val))
                            (error (ssmodule-name mdl) "not found global ~s~n" name)))) globals))

; builds the injector message to send into the network
#;(define (build-inject-msg cache code injector-module injector . injector-params) 
    (let* ((msg (macro-expand (append (list injector code) injector-params) (process-module injector-module)))
           (globals-to-find (lset-difference eq? (find-globals msg) (map car (cache-defines cache)))))
      (unless (null? globals-to-find)
        (printf "error - unfound globals: ~s~n" globals-to-find)
        (printf "message: ~s~n" msg))
      msg))

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





; reading and writing config.ncf files
(define (write-node-conf mdls defs inits)
  (pretty-print (list (map ssmodule-file mdls) defs inits))) 

(define (read-node-conf)
  (let* ([cfg (read)]
         [mdls (first cfg)]
         [defs (second cfg)]
         [inits (third cfg)])
    (values mdls defs inits)))
;

