(module modules mzscheme
  (require  
   (only (lib "1.ss" "srfi") lset-union lset-difference append-map append-reverse filter-map)
   (lib "list.ss" "mzlib")
   "symmap.scm")
  
  (provide read-node-conf build-node-conf compile-module get-gateway-requires)
  
  (define-struct ssmodule (file name defines provides includes requires gateway-requires init))
  
  (define (put-global! mdl name kind val)
    (if (hash-table-get (ssmodule-defines mdl) name #f)
        (error (ssmodule-name mdl) "redefinition of symbol ~s~n" name)
        (begin
          #;(printf "-- defining a ~s \"~s\" to ~s~n" kind name val)
          (hash-table-put! (ssmodule-defines mdl) name (cons kind val)))))
  
  (define (find-global-kind mdl kind)
    (filter (lambda (l) l) (hash-table-map (ssmodule-defines mdl) 
                                           (lambda (k v) (if (eq? (car v) kind) (cons k (cdr v)) #f)))))
  
  (define (get-global mdl name kind)
    (let ([val (hash-table-get (ssmodule-defines mdl) name #f)])
      (if (and val (eq? (car val) kind)) val #f)))
  
  (define mdl-path-list '("../sensorscheme" "."))
  (define (find-module file)
    (let/cc break
      (for-each 
       (lambda (p) 
         (let ((fp (path->complete-path (build-path p file))))
           (if (file-exists? fp)
               (break fp))))
       mdl-path-list)
      (error 'find-module "module ~s not found~n" file)))
  
  ; gets all code needed for given module 
  ; 
  (define (select-module todo-mdls done-mdls)
    #;(printf "select-module  ~s ~s~n" (map ssmodule-name todo-mdls) (map ssmodule-name done-mdls))
    (if (or (null? todo-mdls) (member (car todo-mdls) done-mdls)) (values '() '() '())          
        (let-values ([(mdls1 inits1 defs1) 
                      (select-module (ssmodule-requires (car todo-mdls)) done-mdls)])
          (let* ([new-inits (ssmodule-init (car todo-mdls))]
                 [includes (ssmodule-includes (car todo-mdls))]
                 [new-defs (find-all-globals (append includes new-inits) '() (car todo-mdls))])
            #;(printf "module ~s defs: ~s~n       inits:~s~n" 
                    (ssmodule-name (car todo-mdls)) new-defs new-inits)
            (let-values ([(mdls2 inits2 defs2) (select-module (cdr todo-mdls) (cons (car todo-mdls) done-mdls))])
              (values (append (list (car todo-mdls)) mdls1 mdls2) 
                      (append new-inits inits1 inits2) (append new-defs defs1 defs2)))))))
  
  ; get all code dependencies for the main module of a SensorScheme app
  (define (compile-module mfile)
    (select-module (list (process-module mfile)) '()))
  
  (define module-cache (make-hash-table 'equal))
  (define (process-module mfile)
    (or (hash-table-get module-cache mfile #f)
        ; Start by doing the whole module definition
        (let ([exps (with-input-from-file (find-module mfile) 
                      (lambda () (read)))])
          (when (not (eq? (car exps) 'ssmodule))
            (error 'process-module "File ~s is not a valid module (no ssmodule found at start)~n" mfile))
          (printf "process-module ~s~n" mfile)
          (let ([mdl (make-ssmodule mfile (cadr exps) (make-hash-table) '() '() '() '() '())])
            (define (process-clauses clauses)
              (unless (null? clauses)
                (process-clause (macro-expand (car clauses) mdl))
                (process-clauses (cdr clauses))))
            
            ; Dispatch on the type of the clause.
            (define (process-clause clause)
              (if (pair? clause)
                  (case (car clause)
                    [(require)
                     (let ([new-mdls (map (lambda (el) (process-module el)) (cdr clause))])
                       (set-ssmodule-requires! mdl (append new-mdls (ssmodule-requires mdl)))
                       (for-each (lambda (other-mdl)
                                   (for-each (lambda (defk)
                                               (let ([defv (hash-table-get (ssmodule-defines other-mdl) defk #f)])
                                                 (if defv (if (hash-table-get (ssmodule-defines mdl) defk #f) 
                                                              (error (ssmodule-name mdl) 
                                                                     "redefinition of ~s in require~n" defk)
                                                              (hash-table-put! (ssmodule-defines mdl) defk defv))
                                                     (error (ssmodule-name mdl) "definition of ~s not found~n" defk)))) 
                                             (ssmodule-provides other-mdl))) new-mdls))]
                    [(require-for-gateway)
                     (set-ssmodule-gateway-requires! mdl (append (cdr clause) (ssmodule-gateway-requires mdl)))]
                    [(provide)
                     (set-ssmodule-provides! mdl (append (cdr clause) (ssmodule-provides mdl)))]
                    [(include)
                     (set-ssmodule-includes! mdl (append (cdr clause) (ssmodule-includes mdl)))]
                    [(%define%)
                     (put-global! mdl (cadr clause) 'define (rename-locals (caddr clause)))]
                    [(%define-handler%)
                     (put-global! mdl (cadr clause) 'handler (rename-locals (caddr clause)))]
                    [(%define-macro%)
                     (put-global! mdl (cadr clause) 'macro (caddr clause))
                     #;(printf "define-macro ~s: ~s~n" (cadr clause) 
                               (cdr (hash-table-get (ssmodule-defines mdl) (cadr clause))))]
                    [(define-primitive)
                     (put-global! mdl (cadr clause) 'primitive (caddr clause))]
                    [(define-receiver)
                     (put-global! mdl (cadr clause) 'receiver (caddr clause))]
                    [else
                     (set-ssmodule-init! mdl (cons (rename-locals clause) (ssmodule-init mdl)))])))            
            (process-clauses (cddr exps))
            ; check that provides clause is consistent: only existing values, no doubles
            (let loop ([ls (ssmodule-provides mdl)])
              (when (not (null? ls))
                (cond [(member (car ls) (cdr ls)) (error (ssmodule-name mdl) "duplicate \"~s\" in provides~n" (car ls))]
                      [(hash-table-get (ssmodule-defines mdl) (car ls) 
                                       (lambda () (error (ssmodule-name mdl) "provided \"~s\" not defined~n" (car ls))))])
                (loop (cdr ls))))
            ; same for includes
            (let loop ([ls (ssmodule-includes mdl)])
              (when (not (null? ls))
                (cond [(member (car ls) (cdr ls)) (error (ssmodule-name mdl) "duplicate \"~s\" in includes~n" (car ls))]
                      [(hash-table-get (ssmodule-defines mdl) (car ls) 
                                       (lambda () (error (ssmodule-name mdl) "included \"~s\" not defined~n" (car ls))))])
                (loop (cdr ls))))
            #;(hash-table-for-each (ssmodule-defines mdl) (lambda (k v)
                                                            (printf "~s: ~s~n" k v)))
            (hash-table-put! module-cache mfile mdl)
            mdl))))
  
  (define (macro-expand exp mdl)
    ; expand macros in module
    (if (pair? exp)
        (let ([expander (get-global mdl (car exp) 'macro)])
          (if expander 
              (macro-expand 
               (let* ([eval-exp (cons (cdr expander) 
                                      (map (lambda (x) (list 'quote x)) (cdr exp)))]
                      [orig-ns (current-namespace)])
                 #;(printf "macro-expand ~s using ~s~n" (car exp) eval-exp)
                 (current-namespace macro-namespace)      
                 (let ([result (with-handlers ([exn? 
                                                (lambda (exn)     
                                                  (printf "Error during macro-expand of ~s : ~s in ~s~n" 
                                                          (car exp) (exn-message exn) exp))]) 
                                 (eval eval-exp))])
                   (current-namespace orig-ns)
                   #;(printf "expanding ~s to ~s~n" exp result)
                   result)) mdl)
              (if (list? exp) (map (lambda (x) (macro-expand x mdl)) exp) exp)))
        exp))
  
  ; make sure all required definitions are in the macroexpansion namespace
  (define macro-namespace (make-namespace))
  (let ([orig-ns (current-namespace)])
    (current-namespace macro-namespace)
    (namespace-require '(all-except (lib "1.ss" "srfi") reverse! member map for-each assoc append!))
    (namespace-require '(file "internal-forms.scm"))
    (current-namespace orig-ns)
    )
  
  
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
            ((if)
             (apply lset-union eq? (dotted-map (lambda (el) (find-in-exp el locals)) (cdr exp))))
            ;quote found, ignore argument
            ((quote)
             '())
            ((set!)
             (when (not (symbol? (cadr exp))) (error 'set! "first argument not a variable reference: ~s~n" (cadr exp)))
             (lset-union eq? (find-in-exp (cadr exp) locals) (find-in-exp (caddr exp) locals)))
            ; process each term in application as exression
            (else (apply lset-union eq? (dotted-map (lambda (el) (find-in-exp el locals)) exp))))
          ; code not pair, must be varref or constant
          (if (or (member exp locals) (not (symbol? exp)))
              ; local var ref
              '() 
              ;global var
              (list exp))))
    ;(printf "find-globals ~s" exps)
    (let ((r (apply lset-union (cons eq? (map (lambda (el) (find-in-exp el '())) exps)))))
      ;(printf ": ~s~n"r)
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
                                                         [(define handler) (cddr el)]
                                                         [else #f])) new-found) 
                              (append-reverse new-found found) mdl)))))
  
  (define (lookup-globals mdl globals)
    (map (lambda (name) (let ([val (hash-table-get (ssmodule-defines mdl) name #f)])
                          (if val (begin #;(printf "val ~s: ~s~n" name val) (cons name val))
                              (error (ssmodule-name mdl) "not found global ~s~n" name)))) globals))
  
  ; builds the injector message to send into the network
  #;(define (build-inject-msg cache code injector-module injector . injector-params) 
      (let* ((msg (macro-expand (append (list injector code) injector-params) (process-module injector-module)))
             (globals-to-find (lset-difference eq? (find-globals msg) (map car (cache-defines cache)))))
        (unless (null? globals-to-find)
          (printf "error - unfound globals: ~s~n" globals-to-find)
          (printf "message: ~s~n" msg))
        msg))
  
  
  ; reads the contents of a base-conf file into a cache and the application's symmap
  ; todo: fix again, not tested
  (define (read-node-conf fname symmap)
    (let* ((fcont (with-input-from-file fname (lambda () (read))))
           (mdls (map process-module (car fcont)))
           (defines (filter-map 
                     (lambda (el) (if (eq? (caddr el) '%special%) 
                                      #f
                                      (list (car el) (caddr el))))
                     (cadr fcont))))
      (values (update-symmap (cadr fcont) symmap))))
  
  ; build a new base-conf file from a cache and the application's symmap.
  (define (build-node-conf mdls inits defs symmap)
    (list (map ssmodule-file mdls)
          (sort (map (lambda (el) 
                       (list (car el) (cadr el) 
                             (let ((kv (assq (car el) defs)))
                               (if kv (cdr kv) 'special)))) 
                     (symmap->list symmap))
                (lambda (f s) (< (cadr f) (cadr s))))))
  
  ; returns the gateway-requires that are defined in module mdl and dependencies
  (define (get-gateway-requires mfile)
    (define (gateway-sub-modules mdl)
      (lset-union eq? (list mdl) (append-map gateway-sub-modules (ssmodule-requires mdl))))
    (let* ((mdl (process-module mfile))
           (subs (gateway-sub-modules mdl)))
      (printf "subs: ~s gw: ~s~n" (map ssmodule-name subs) 
              (append-map ssmodule-gateway-requires subs))
      (append-map ssmodule-gateway-requires subs)))
  
  
  ; renames all local variables to the standard local-variable names, 
  ; that can be indexed by name
  ; exp: exression to rename (should come from top level of module)
  ; returns renamed verion of exp, sharing structures where possible
  (define (rename-locals exp)
    (define (varlist l n)
      (cond ((null? l) ())
            ((symbol? l) (cons (cons l (string->symbol (string-append "%l" (number->string n)))) ()))
            (else (cons (cons (car l) (string->symbol (string-append "%l" (number->string n)))) 
                        (varlist (cdr l) (+ n 1))))))
    (define (replace-vars v al) 
      (cond ((null? v) ())
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
    (let ([r (rename-locals-inner exp ())])
      ; (printf ": ~s~n" r)
      r))
  
  ;(trace find-all-globals)
  )

