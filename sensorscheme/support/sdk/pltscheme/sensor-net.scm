#lang scheme
(require
 (only-in (lib "1.ss" "srfi") append-map)
 (only-in (lib "13.ss" "srfi") string-take string-drop)
 (file "symmap.scm"))

(provide net-encode net-decode c-ident net-decode-mapfile net-encode-mapfile read-symmap-file)

(define TOK_SYM     0)
(define TOK_NUM     1)
(define TOK_BROPEN  2)
(define TOK_BRCLOSE 3)

(define TOK_NIBBLE  TOK_SYM    )
(define TOK_BYTE    TOK_NUM    )
(define TOK_WORD    TOK_BROPEN )
(define TOK_DWORD   TOK_BRCLOSE)

(define (net-decode byte-list symmap) 
  (let ((bitbuf 0)
        (bitcnt 0))
    
    (define (read-bits)
      (when (= bitcnt 0) 
        (set! bitbuf (car byte-list))
        (set! bitcnt 4)
        (set! byte-list (cdr byte-list)))
      (let ((res (modulo bitbuf 4)))
        (set! bitbuf (quotient bitbuf 4))
        (set! bitcnt (- bitcnt 1))
        res))
    
    (define (read-sym)
      (let ((res (symname symmap (let ((n (car byte-list)))
                                   (if (> n (- 256 8)) (- n 256) n)))))
        (set! byte-list (cdr byte-list))
        res))
    
    (define (read-num)
      (let ((bits (read-bits)))
        (cond ((eq? bits TOK_NIBBLE) (+ (* (read-bits) 4) (read-bits)))
              ((eq? bits TOK_BYTE) (let ((res (car byte-list))) (set! byte-list (cdr byte-list)) (if (>= res 128) (- res 256) res)))
              ((eq? bits TOK_WORD) (let ((res (+ (* (cadr byte-list) 256) (car byte-list)))) (set! byte-list (cddr byte-list)) 
                                     (if (>= res (expt 2 15)) (- res (expt 2 16)) res)))
              ((eq? bits TOK_DWORD) (let ((res (+ (* (+ (* (+ (* (cadddr byte-list) 256) (caddr byte-list)) 256) (cadr byte-list)) 256) (car byte-list))))
                                      (set! byte-list (cddddr byte-list)) 
                                      (if (>= res (expt 2 31)) (- res (expt 2 32)) res)))
              (else (display "panic!\n")))))              
    
    (define (read-list)
      (let ((sexpr (read-sexpr)))
        (cond ((eq? sexpr '<brclose>) '())
              ((eq? sexpr '<dot>) (read-sexpr))
              (else (cons sexpr (read-list))))))
    
    (define (read-sexpr)
      (let ((bits (read-bits)))
        (cond ((eq? bits TOK_SYM) (read-sym))
              ((eq? bits TOK_NUM) (read-num))
              ((eq? bits TOK_BROPEN) (read-list))
              ((eq? bits TOK_BRCLOSE) '<brclose>)
              (else (display "panic!\n")))))
    
    (read-sexpr)))

(define (net-encode sexpr symmap)
  (let ([byte-list '()]
        [bitbuf 0]
        [bitcnt 0]
        [tls '()])
    
    (define (out! b)
      (set! tls (cons b tls)))
    (define (write-bits tok)
      (when (= bitcnt 4) 
        (set! byte-list (append tls (cons bitbuf byte-list)))
        (set! tls '())
        (set! bitbuf 0)
        (set! bitcnt 0))
      (set! bitbuf (+ (quotient bitbuf 4) (* tok 64)))
      (set! bitcnt (+ bitcnt 1)))
    
    (define (write-sym val)
      (out! (modulo (symnum symmap val) 256)))
    
    (define (write-string val)
      (write-bits TOK_SYM)
      (write-sym '%string%)
      (let* ([num (symnum symmap val)]
             [hi-num (quotient num 256)])
        (write-bits (quotient hi-num 4)) (write-bits (modulo hi-num 4))
        (out! (modulo num 256))))
    
    (define (write-num aval)
      (cond ((<= 0 aval 15) (write-bits TOK_NIBBLE) 
                            (write-bits (quotient aval 4)) (write-bits (modulo aval 4)))
            ((<= (- (/ 256 2)) aval (- (/ 256 2) 1)) 
             (write-bits TOK_BYTE) (out! (modulo aval 256)))
            ((<= (- (/ (expt 256 2) 2)) aval (- (/ (expt 256 2) 2) 1)) 
             (write-bits TOK_WORD) 
             (out! (modulo aval 256))
             (out! (quotient (modulo aval (* 256 256)) 256)))
            (else (write-bits TOK_DWORD) 
                  (let ((val (modulo aval (expt 256 4))))
                    (out! (modulo val 256))
                    (out! (modulo (quotient val 256) 256))
                    (out! (modulo (quotient val (* 256 256)) 256))
                    (out! (modulo (quotient val (expt 256 3)) 256))))))
    
    (define (write-list sexpr)
      (cond ((pair? sexpr) (write-sexpr (car sexpr)) (write-list (cdr sexpr)))
            ((null? sexpr) (write-bits TOK_BRCLOSE))
            (else (write-bits TOK_SYM) (write-sym '<dot>) (write-sexpr sexpr))))
    
    (define (write-sexpr sexpr)
      (cond ((or (symbol? sexpr) (boolean? sexpr)) (write-bits TOK_SYM) (write-sym sexpr))
            ((number? sexpr) (write-bits TOK_NUM) (write-num sexpr))
            ((pair? sexpr) (write-bits TOK_BROPEN) (write-list sexpr))
            ((string? sexpr) (write-string sexpr))
            ((null? sexpr) (write-bits TOK_BROPEN) (write-bits TOK_BRCLOSE))))
    
    (define (flush)
      (define (do-flush)
        (write-bits TOK_BRCLOSE)
        (unless (= bitcnt 1)
          (do-flush)))
      (if (= bitcnt 4)
          (begin (do-flush) #;(set! byte-list (cdr byte-list)))
          (do-flush)))
    
    (write-sexpr sexpr)
    (flush)
    (reverse byte-list)))

; makes a legal c identifier from a symbol
; it upcases letters in the symvbol, so this is not reversable
(define (c-ident sym)
  (define (esc c) (list #\_ c #\_))
  (list->string (append-map (lambda (c)
                              (case c
                                [(#\!) (esc #\X)]
                                [(#\*) (esc #\T)]
                                [(#\-) (esc #\M)]
                                [(#\+) (esc #\P)]
                                [(#\=) (esc #\E)]
                                [(#\/) (esc #\D)]
                                [(#\%) (esc #\L)]
                                [(#\?) (esc #\Q)]
                                [(#\:) (esc #\C)]
                                [(#\<) (esc #\S)]
                                [(#\>) (esc #\G)]
                                [(#\^) (esc #\W)]
                                [(#\&) (esc #\N)]
                                [(#\@) (esc #\A)]
                                [(#\$) (esc #\O)]
                                [else (list (char-upcase c))])) (string->list (symbol->string sym)))))

; decode a message using the encoding in a symbols.map file
(define (net-decode-mapfile bytes path)
  (net-decode bytes (read-symmap-file path)))
  
  ; encode a message using the encoding in a symbols.map file, and update the file
  (define (net-encode-mapfile sexpr path)
    (let* ([symmap (read-symmap-file path)]
           [encoded (net-encode sexpr symmap)])
      (write-symmap-file symmap path)   
      encoded))