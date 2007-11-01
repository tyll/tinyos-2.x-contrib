(module symmap mzscheme
  (require )
  
  (provide symname symnum update-symmap empty-symmap symmap->list)
  
  (define-struct symmap (map reverse))
  
  (define (empty-symmap) (make-symmap (make-hash-table) (make-hash-table)))
  
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
     (lambda (el) (let ((curr (hash-table-get (symmap-map oldmap) (car el) (lambda () #f))))
                    (if curr 
                        (if (not (= curr (cadr el))) 
                            (error "incompatible symmaps"))
                        (begin
                          (hash-table-put! (symmap-map oldmap) (car el) (cadr el))
                          (hash-table-put! (symmap-reverse oldmap) (cadr el) (car el))
                          #;(printf "updating ~a ~a~n" (symnum oldmap (car el)) (symname oldmap (cadr el))))))) 
     mapls)
    oldmap)
  
  (define (symmap->list symmap)
    (hash-table-map (symmap-map symmap) (lambda (k v) (list k v))))
  
  )