#!/usr/bin/env mzscheme -u

#lang scheme

; ssinject
; 

(require (file "modules.scm") (file "specialize.scm")
         srfi/1)



(define *server-port* 7828)

(define *protocol* 'dissemination)

(define *address* "")

(define (set-port! p) (set! *server-port* p))

(define (set-protocol! p) (set! *protocol* p))

(define (set-address! a) (set! *address* (string->number a)))

(define (reset-state!) #f)

(define (filter-config defs kind) 
  (filter-map (lambda (l) 
                (if (and (pair? l) (eq? (second l) kind))
                    (cons (first l) (cddr l)) 
                    #f)) defs))


(define (filter-defs defs sym)
  (filter-map (lambda (el) 
                (if (eq? (cadr el) sym)
                    (cons (car el) (cddr el)) #f)) defs))

(define (main argv)
  (let*-values ([(script) (command-line #:argv argv
                                        #:help-labels 
                                        "injects a script into the network"
                                        "connects to the ssgw deamon controlling the network"
                                        "params:"
                                        " - script : the script to inject"
                                        #:once-any
                                        (("-d" "--diss") "use the dissemination protocol (default)" 
                                                         (set-protocol! 'dissemination))
                                        (("-e" "--delivery") address "use the delivery protocol" 
                                                             (set-protocol! 'delivery) (set-address! address))
                                        (("-n" "--handoff") address "use the handoff protocol" 
                                                            (set-protocol! 'handoff) (set-address! address))
                                        #:once-each
                                        (("-p" "--port") port "TCP port to connect to (default 7828)" 
                                                         (set-port! (string->number port)))
                                        (("-r" "--reset") "send a reset, and discard the current network state" 
                                                          (reset-state!))
                                        #:args (script) (path->complete-path script))]
                [(in out) (tcp-connect "localhost" *server-port*)]
                [(base) (read-line in)])
    (printf "Base: ~a~n" base)
    
    (let*-values ([(old-mdls old-defs old-inits) (with-input-from-file (build-path base "config.ncf") read-node-conf)]
                  [(old-primitives old-receivers old-defines old-consts) 
                   (apply values (map (lambda (l) (filter-config old-defs l)) '(primitive receiver define const)))]
                  
                  [(mdls defs inits) (specialize-module script (case *protocol*
                                                                 [(dissemination) #f]
                                                                 [(delivery handoff) *address*]))]
                  
                  #;[(mdls defs inits) (compile-module script)]
                  #;[(defines consts primitives receivers) 
                   (apply values (map (lambda (x) (filter-defs defs x)) '(define const primitive receiver)))]
                  
                  #;[(primitives defines consts inits) 
                   (specialize-program (case *protocol*
                                         [(dissemination) #f]
                                         [(delivery handoff) *address*]) primitives defines consts inits)]
                  
                  #;[(diff-primitives) (lset-difference equal? primitives old-primitives)]
                  #;[(diff-receivers)  (lset-difference equal? receivers old-receivers)]
                  #;[(diff-defines)    (lset-difference equal? defines old-defines)]
                  #;[(diff-consts)     (lset-difference equal? consts old-consts)]
                  #;[(diff-inits)      (lset-difference equal? inits old-inits)]
                  
                  #;[(msg) `(inject-handler (%define% ,@(apply append diff-defines) ,@(apply append diff-consts)) ,@diff-inits)])
      (printf "defs:~n")
      (pretty-print defs) 
      (printf "inits:~n")
      (pretty-print inits)
      #;(when (not (null? diff-primitives)) (raise-user-error 'ssinject "Cannot execute script on network. The following primitives are missing: ~s"
                                                            (map car diff-primitives)))
      #;(when (not (null? diff-receivers)) (raise-user-error 'ssinject "Cannot execute script on network. The following receivers are missing: ~s"
                                                           (map car diff-receivers)))
      
      
      #;(printf "primitives: ~s~nreceivers: ~s~ndefines: ~s~nconsts: ~s~ninits: ~s~n~nmsg: ~s~n" 
                diff-primitives diff-receivers diff-defines diff-consts diff-inits msg)
      #;(printf "old-defs: ~s~nreceivers old: ~s~n         new: ~s~n" old-defs old-receivers receivers)
      
      
      #;(fprintf out "~s~n" `(disseminate ,msg)))
    (close-input-port in)
    (close-output-port out)))

(main (current-command-line-arguments))