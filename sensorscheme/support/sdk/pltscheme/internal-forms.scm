(module internal-forms mzscheme
  (provide %lambda% %define% %define-const% %set!% %quote% %if%)  
  
  (define-syntax %lambda% (syntax-rules ()
                            ((%lambda% bindings body ...)
                             (lambda bindings body ...))))
  
  (define-syntax %define% (syntax-rules ()
                            ((%define% name value)
                             (define name value))))
  
  (define-syntax %define-const% (syntax-rules ()
                            ((%define-const% name value)
                             (define name value))))
  
  
  (define-syntax %set!% (syntax-rules ()
                            ((%set!% name value)
                             (set! name value))))
  
  (define-syntax %quote% (syntax-rules ()
                           ((%quote% value)
                            (quote value))))
  
  (define-syntax %if% (syntax-rules ()
                           ((%if% value ...)
                            (if value ...))))
  )

