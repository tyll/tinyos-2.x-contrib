(ssmodule struct
  
  (require (lib std) (lib selector))
  
  (provide define-struct drop nth set-nth!)
  
  (define-macro (define-struct name fields)
    (let loop ([f fields]
             [n 0]
             [r `(%begin% (define ,(string->symbol (apply string-append (map symbol->string (list 'make- name))))
                            (lambda ,fields (list ,@fields))))])
    (if (null? f)
        r
        (loop (cdr f) (+ n 1)
              (append r `((define ,(string->symbol (apply string-append (map symbol->string (list name '- (car f)))))
                         (lambda (l) (nth ,n l )))
                       (define ,(string->symbol (apply string-append (map symbol->string (list 'set- name '-(car f) '!))))
                         (lambda (l) (set-nth! ,n l)))))))))
  
  )