(module modules mzscheme
  (require  
   (only (lib "1.ss" "srfi") lset-union lset-difference append-map append-reverse filter-map)
     (lib "list.ss" "mzlib")
     "symmap.scm")
  
  (provide read-base-conf build-base-conf select-module build-inject-msg get-gateway-requires get-module-files)
  
  (define-struct ssmodule (file name provides requires defines handlers gateway-requires macros init))
  
  (define-struct cache (modules defines))
  
  (define svc-path-list '("../sensorscheme/lib" "."))
  (define (find-module file)
    (let/cc break
      (for-each 
       (lambda (p) 
         (let ((fp (path->complete-path (build-path p file))))
           (if (file-exists? fp)
               (break fp))))
       svc-path-list)
      (error 'find-module "module ~s not found~n" file)))
  
  ; gets all code needed for given module and current state of cache, 
  ; and returns code to be installed and updates cache.
  (define (select-module mfile cache)
    ; recursively finds all required modules
    (define (recursive-requires svc)
      (let ((req-svcs (ssmodule-requires svc)))
        (if (null? req-svcs) '()
            (apply lset-union (lambda (s1 s2) (eq? (ssmodule-name s1) (ssmodule-name s2)))
                   (list svc) (map recursive-requires req-svcs)))))
    ; gets all required servcies that are not yet loaded in cache
    (define (get-new-requires svc)
      (lset-difference (lambda (s1 s2) (eq? (ssmodule-name s1) (ssmodule-name s2)))
                       (recursive-requires svc) (cache-modules cache)))
    
    (let* ([svc (process-module mfile)]
           [new-svcs (get-new-requires svc)]
           [inits (reverse (append-map ssmodule-init new-svcs))]
           [handlers (append-map ssmodule-handlers new-svcs)]
           [defines (lset-difference equal? (find-all-globals (append (map cadr handlers) inits) 
                                                              (append handlers (cache-defines cache)) svc)
                                     (cache-defines cache))])
      ;(display (apply append defines)) (newline)
      (values (if (null? defines) inits 
                  (cons 
               (cons '%define% (apply append defines))
               inits))
              (make-cache (append (cache-modules cache) new-svcs) 
                          (append defines (cache-defines cache))))))
  
  (define module-cache (make-hash-table 'equal))
  (define (process-module mfile)
    (or (hash-table-get module-cache mfile (lambda () #f))
        ; Process each clause in turn
        (let ((svc (make-ssmodule '() '() '() '() '() '() '() '() '())))
          (define (process-clauses clauses)
            (unless (null? clauses)
              (process-clause (macro-expand (car clauses) svc))
              (process-clauses (cdr clauses))))
          
          ; Dispatch on the type of the clause.
          (define (process-clause clause)
            (if (pair? clause)
                (case (car clause)
                  ((require)
                   (set-ssmodule-requires! 
                    svc (append (map (lambda (el) (process-module el)) (cdr clause)) (ssmodule-requires svc))))
                  ((require-for-gateway)
                   (set-ssmodule-gateway-requires! svc (append (cdr clause) (ssmodule-gateway-requires svc))))
                  ((provide)
                   (set-ssmodule-provides! svc (cons (cdr clause) (ssmodule-provides svc))))
                  ((%define%)
                   (set-ssmodule-defines! svc (cons (cons (cadr clause) (rename-locals (cddr clause))) 
                                                   (ssmodule-defines svc))))
                  ((%define-handler%)
                   (set-ssmodule-handlers! svc (cons (cons (cadr clause) (rename-locals (cddr clause)))
                                                    (ssmodule-handlers svc))))
                  ((%define-macro%)
                   (set-ssmodule-macros! svc (cons (cdr clause) (ssmodule-macros svc))))
                  (else
                   (set-ssmodule-init! svc (cons (rename-locals clause) (ssmodule-init svc)))))))
          
          ; Start by doing the whole module definition
          (let* ((exps (with-input-from-file (find-module mfile) 
                         (lambda () (read)))))
            (if (eq? (car exps) 'ssmodule)
                (begin 
                  (set-ssmodule-name! svc (cadr exps))
                  (set-ssmodule-file! svc mfile)
                  (process-clauses (cddr exps))
                  #;(printf "~a : ~a, ~a~n" (ssmodule-name svc) (map car (ssmodule-defines svc)) 
                            (ssmodule-handlers svc)) 
                    (hash-table-put! module-cache mfile svc)
                    svc)
                (error 'process-module "File ~s is not a valid module (no ssmodule found at start)~n" mfile))))))
  
  (define (macro-expand exp svc)
    ; expand macros in module
    (if (pair? exp)
        (let ([expander (find-expander (car exp) svc)])
          (if expander 
              (macro-expand 
               (let* ([eval-exp (cons (car expander) 
                                      (map (lambda (x) (list 'quote x)) (cdr exp)))]
                      [orig-ns (current-namespace)])
                 (current-namespace macro-namespace)      
                 (let ([result (with-handlers ([exn? 
                                                (lambda (exn)     
                                                  (printf "Error during macro-expand of ~s : ~s in ~s~n" 
                                                          (car exp) (exn-message exn) exp))]) 
                                 (eval eval-exp))])
                   (current-namespace orig-ns)
                   result)) svc)
              (if (list? exp) (map (lambda (x) (macro-expand x svc)) exp) exp)))
        exp))
  
  (define (find-expander exp svc)
    (define (find-in-requires svclist)
      (and (pair? svclist)
           (or (find-expander exp (car svclist))
               (find-in-requires (cdr svclist)))))
    (let ((expander (assq exp (ssmodule-macros svc))))
      (if expander
          (cdr expander)
          (find-in-requires (ssmodule-requires svc)))))
  
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
            ((%lambda%)
             (let ((newlocals (append (cadr exp) locals)))
               (apply lset-union (cons eq? (map (lambda (el) (find-in-exp el newlocals)) (cddr exp))))))
            ;if
            ((if)
             (apply lset-union eq? (dotted-map (lambda (el) (find-in-exp el locals)) (cdr exp))))
            ;quote found, ignore argument
            ((quote)
             '())
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
  (define (find-all-globals exps found svc)
    (let ((globals-to-find (lset-difference eq? (find-globals exps) (map car found))))
      (if (null? globals-to-find)
          found
          (
           let-values (((new-found not-found) (lookup-globals svc globals-to-find)))
            ;(display (ssmodule-name svc)) (display ": to find:") (display globals-to-find) 
            ;(display " found:") (display (map car new-found)) 
            ;(newline)
            (if (pair? not-found)
                (printf "~s: not found ~s~n" (ssmodule-name svc) not-found))            
            (find-all-globals new-found (append-reverse new-found found) svc)))))
  
  
  (define (lookup-globals svc globals)
    (define (lookup-loop svcls found globals)
      (if (null? svcls)
          (values found globals)
          (
           let-values (((new-found not-found) (lookup-globals (car svcls) globals)))
            
            (lookup-loop (cdr svcls) (append found new-found) not-found))))
    
    (let* ((new-globals (lset-difference eq? globals (map car (ssmodule-handlers svc))))
           (found (filter-map (lambda (el) (assq el (ssmodule-defines svc))) new-globals))
           (not-found (filter-map (lambda (el) (if (not (assq el (ssmodule-defines svc))) el #f)) new-globals)))
      (lookup-loop (ssmodule-requires svc) found not-found)
      ))
  
  ; builds the injector message to send into the network
  (define (build-inject-msg cache code injector-module injector . injector-params) 
    (let* ((msg (macro-expand (append (list injector code) injector-params) (process-module injector-module)))
           (globals-to-find (lset-difference eq? (find-globals msg) (map car (cache-defines cache)))))
      (unless (null? globals-to-find)
        (printf "error - unfound globals: ~s~n" globals-to-find)
        (printf "message: ~s~n" msg))
      msg))
  
  
  ; reads the contents of a base-conf file into a cache and the application's symmap
  (define (read-base-conf fname symmap)
    (let* ((fcont (with-input-from-file fname (lambda () (read))))
           (svcs (map process-module (car fcont)))
           (defines (filter-map 
                     (lambda (el) (if (eq? (caddr el) '%special%) 
                                      #f
                                      (list (car el) (caddr el))))
                     (cadr fcont))))
      (values (make-cache svcs defines)
              (update-symmap (cadr fcont) symmap))))
  
  ; build a new base-conf file from a cache and the application's symmap.
  (define (build-base-conf cache symmap)
    #;(printf "modules: ~a~n" (map ssmodule-file (cache-modules cache)))
    (list (map ssmodule-file (cache-modules cache))
          (sort (map (lambda (el) 
                       (list (car el) (cadr el) 
                             (let ((kv (assq (car el) (cache-defines cache))))
                               (if kv (cadr kv) '%special%)))) 
                     (symmap->list symmap))
                (lambda (f s) (< (cadr f) (cadr s))))))
  
  ; returns the gateway-requires that are defined in module svc and dependencies
  (define (get-gateway-requires mfile)
    (define (gateway-sub-modules svc)
      (lset-union eq? (list svc) (append-map gateway-sub-modules (ssmodule-requires svc))))
    (let* ((svc (process-module mfile))
           (subs (gateway-sub-modules svc)))
      #;(printf "subs: ~s gw: ~s~n" (map ssmodule-name subs) 
                (append-map ssmodule-gateway-requires subs))
      (append-map ssmodule-gateway-requires subs)))
  
  (define (get-module-files cache)
    (map ssmodule-file (cache-modules cache)))
  
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
    ;(printf "rename-locals ~s" exp)
    (let ([r (rename-locals-inner exp ())])
      ; (printf ": ~s~n" r)
      r))
  
  ;(trace find-all-globals)
  )

