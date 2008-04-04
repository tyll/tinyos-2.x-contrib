(ssmodule primitives
  
(provide 
   id defined? car cdr set-car! set-cdr! cons + - * / % 
   bitwise-and bitwise-ior bitwise-xor > >= < <= eq? 
   null? pair? symbol? number? boolean? bitwise-not not 
   random now call-at-time sensor blink append list 
   eval eval-handler apply call/cc
   send-local send-serial 
   recv-local recv-serial)
  
  (define-primitive id (id))

  (define-primitive defined? (simple DefinedPrim))
    
  (define-primitive car (simple CarPrim))
  (define-primitive cdr (simple CdrPrim))
  (define-primitive set-car! (simple SetCarPrim))
  (define-primitive set-cdr! (simple SetCdrPrim))
  (define-primitive cons (simple ConsPrim))
  
  (define-primitive + (simple AddPrim))
  (define-primitive - (simple SubPrim))
  (define-primitive * (simple TimesPrim))
  (define-primitive / (simple DividePrim))
  (define-primitive % #;modulo (simple ModuloPrim))
  (define-primitive bitwise-and (simple AndPrim))
  (define-primitive bitwise-ior (simple IorPrim))
  (define-primitive bitwise-xor (simple XorPrim))
  
  (define-primitive > (simple GtPrim))
  (define-primitive >= (simple GtePrim))
  (define-primitive < (simple LtPrim))
  (define-primitive <= (simple LtePrim))
  (define-primitive eq? (simple EqPrim))
  
  (define-primitive null? (simple NullPrim))
  (define-primitive pair? (simple PairPrim))
  (define-primitive symbol? (simple SymbolPrim))
  (define-primitive number? (simple NumberPrim))
  (define-primitive boolean? (simple BooleanPrim))
  
  (define-primitive bitwise-not (simple BitwiseNotPrim))
  (define-primitive not (simple NotPrim))
  (define-primitive random (simple RandomPrim))
  (define-primitive now (simple NowPrim))
  
  (define-primitive call-at-time (simple CallAtTimePrim))
  (define-primitive sensor (simple SensorPrim))
  (define-primitive blink (simple BlinkPrim))
  
  (define-primitive append (simple AppendPrim))
  (define-primitive list (simple ListPrim))
  
  
  (define-primitive eval (eval EvalPrim))
  (define-primitive eval-handler (eval EvalHandlerPrim))
  
  
  (define-primitive apply (apply ApplyPrim))
  (define-primitive call/cc (apply CallCCPrim))
  
  (define-primitive send-local (sender AMSender))
  (define-primitive send-serial (sender SerialSender))
  
  (define-receiver recv-local AMReceiver)
  (define-receiver recv-serial SerialReceiver)
  
  )