#!/usr/bin/env mzscheme -u

#lang scheme

; ssspecialinject
; 

(define *server-port* 7828)

(define *protocol* 'dissemination)

(define *address* "0")

(define (set-port! p) (set! *server-port* p))

(define (set-protocol! p) (set! *protocol* p))

(define (set-address! a) (set! *address* a))

(define (reset-state!) #f)


(define (main argv)
  (command-line #:argv argv
                #:help-labels 
                "injects a script into the network"
                "connects to the ssgw deamon controlling the network"
                "params:"
                " - script : the script to inject"
                #:once-any
                (("-i" "--diss") "use the dissemination protocol" (set-protocol! 'dissemination))
                (("-d" "--delivery") address "use the delivery protocol" 
                                     (set-protocol! 'delivery) (set-address! address))
                (("-h" "--handoff") address "use the handoff protocol (default, address = 0)" 
                                     (set-protocol! 'handoff) (set-address! address))
                #:once-each
                (("-p" "--port") port "TCP port to connect to (default 7828)" (set-port! port))
                (("-r" "--reset") "send a reset, and discard the current network state" (reset-state!))
                #:args (script) script))
