#lang scheme

(require (only-in (lib "list.ss") filter)
         (only-in (lib "26.ss" "srfi") cut))

(provide symname symnum new-symmap update-symmap symmap->list read-symmap write-symmap read-symmap-file write-symmap-file)

(define-struct symmap (map reverse))

(define (symname symmap num) (hash-ref (symmap-reverse symmap) num))

(define (symnum symmap name)
  (hash-ref (symmap-map symmap) name
            (lambda () 
              (let ([newval (+ 1 (if (symbol? name) 
                                     (apply max 0 (filter (cut > 256 <>) 
                                                          (hash-map (symmap-map symmap) 
                                                                    (lambda (k v) v))))
                                     (apply max 255 (hash-map (symmap-map symmap) 
                                                              (lambda (k v) v)))))])
                (hash-set! (symmap-map symmap) name newval)
                (hash-set! (symmap-reverse symmap) newval name)
                newval))))

(define (update-symmap mapls oldmap)
  (when (not (symmap? oldmap))
    (set! oldmap (make-symmap (make-hash) (make-hash))))
  (for-each 
   (lambda (el) 
     (when (not (and (or (symbol? (car el))
                         (boolean? (car el))
                         (string? (car el))) (integer? (cadr el)))) (raise-user-error "symmaps map only symbols to numbers: ~s" el))
     (let ([curr (hash-ref (symmap-map oldmap) (car el) (lambda () #f))])
       (if curr 
           (when (not (= curr (cadr el))) 
             (error "incompatible symmaps"))
           (begin
             (hash-set! (symmap-map oldmap) (car el) (cadr el))
             (hash-set! (symmap-reverse oldmap) (cadr el) (car el))
             #;(printf "updating ~a ~a~n" (symnum oldmap (car el)) (symname oldmap (cadr el))))))) 
   mapls)
  oldmap)

(define (new-symmap)
  ; put in hard-coded symbol numbers
  (update-symmap '((%l0               -1)
                   (%l1               -2)
                   (%l2               -3)
                   (%l3               -4)
                   (%l4               -5)
                   (%l5               -6)
                   (%l6               -7)
                   (%l7               -8)
                   (%l8               -9)
                   (%l9              -10)
                   (%l10             -11)
                   (%l11             -12)
                   (%l12             -13)
                   (%l13             -14)
                   (%l14             -15)
                   (%l15             -16)
                   
                   (%nil%              0)
                   (#t                 1)
                   (#f                 2)
                   ; read symbols
                   (%string%           3)
                   (%dot%              4)
                   ; the special forms
                   (%lambda%           5)
                   (if                 6)
                   (quote              7)
                   (%define%           8)
                   (set!               9)
                   (%closure%         10)
                   (%continuation%    11)
                   (%primitive%       12)
                   (id                13)) 
                 #f))

(define (symmap->list symmap)
  (hash-map (symmap-map symmap) (lambda (k v) (list k v))))


; reading and writing symmaps
(define (read-symmap)
  (with-handlers ([exn:fail? (lambda (e) 
                               (fprintf (current-error-port) "warning illegal contents of symbol map file, using empty mapping instead (~a)~n" 
                                        (exn-message e))
                               (new-symmap))])
    (update-symmap (read) #f)))

(define (write-symmap smap)
  (pretty-print (sort (symmap->list smap)
                      #:key second <)))

(define (read-symmap-file path) 
  (let ([sfile (path->complete-path (build-path path "symbols.map"))])
    (if (file-exists? sfile)
        (with-input-from-file sfile read-symmap)
        (new-symmap))))

(define (write-symmap-file symmap path)
  (with-output-to-file (path->complete-path (build-path path "symbols.map"))
    (lambda () 
      (printf ";; This file contains the mapping between the textual and numerical 
;; values for a network configuration. It is generated automatically. 
;; Do not edit manually.~n~n")
      (write-symmap symmap)) #:exists 'replace))