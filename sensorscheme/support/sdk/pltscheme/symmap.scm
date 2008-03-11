(module symmap mzscheme
  (require )
  
  (provide symname symnum new-symmap update-symmap symmap->list)
  
  (define-struct symmap (map reverse))

  (define (symname symmap num) (hash-table-get (symmap-reverse symmap) num))

  (define (symnum symmap name)
    (hash-table-get (symmap-map symmap) name
                    (lambda () (let ((newval (+ 1 (apply max 0 
                                                         (hash-table-map (symmap-map symmap) 
                                                                         (lambda (k v) v)))))) 
                                 (hash-table-put! (symmap-map symmap) name newval)
                                 (hash-table-put! (symmap-reverse symmap) newval name)
                                 newval))))
  
  (define (update-symmap mapls oldmap)
    (if (not (symmap? oldmap))
        (set! oldmap (make-symmap (make-hash-table) (make-hash-table))))
    (for-each 
     (lambda (el) (let ([curr (hash-table-get (symmap-map oldmap) (car el) (lambda () #f))])
                    (if curr 
                        (if (not (= curr (cadr el))) 
                            (error "incompatible symmaps"))
                        (begin
                          (hash-table-put! (symmap-map oldmap) (car el) (cadr el))
                          (hash-table-put! (symmap-reverse oldmap) (cadr el) (car el))
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
                     
                     (%nil%              0)
                     (#t                 1)
                     (#f                 2)
                     ; read symbols
                     (%brclose%          3)
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
    (hash-table-map (symmap-map symmap) (lambda (k v) (list k v))))
  
  )