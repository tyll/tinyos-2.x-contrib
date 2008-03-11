(module internal-forms mzscheme
  (provide %lambda% %define%)  
  
  (define-syntax %lambda% (syntax-rules ()
                            ((%lambda% bindings body ...)
                             (lambda bindings body ...))))
  
  (define-syntax %define% (syntax-rules ()
                            ((%define% name value)
                             (define name value))))
  )

