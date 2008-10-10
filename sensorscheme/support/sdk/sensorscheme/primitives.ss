(ssmodule primitives
  
(provide 
   id defined? car cdr set-car! set-cdr! cons + - * / % 
   bitwise-and bitwise-ior bitwise-xor > >= < <= eq? 
   null? pair? symbol? number? boolean? bitwise-not not 
   random now call-at-time sensor blink append list 
   print eval inject-handler apply call/cc
   send-local send-local/ack send-serial 
   recv-local recv-local/ack recv-serial)
  
  (define-primitive id (id))

  (define-primitive defined? (simple DefinedPrim))
    
  (define-primitive car (simple CarPrim car))
  (define-primitive cdr (simple CdrPrim cdr))
  (define-primitive set-car! (simple SetCarPrim set-car!))
  (define-primitive set-cdr! (simple SetCdrPrim set-cdr!))
  (define-primitive cons (simple ConsPrim cons))
  
  (define-primitive + (simple AddPrim +))
  (define-primitive - (simple SubPrim -))
  (define-primitive * (simple TimesPrim *))
  (define-primitive / (simple DividePrim quotient))
  (define-primitive % #;modulo (simple ModuloPrim modulo))
  (define-primitive bitwise-and (simple AndPrim bitwise-and))
  (define-primitive bitwise-ior (simple IorPrim bitwise-ior))
  (define-primitive bitwise-xor (simple XorPrim bitwise-xor))
  
  (define-primitive > (simple GtPrim >))
  (define-primitive >= (simple GtePrim >=))
  (define-primitive < (simple LtPrim <))
  (define-primitive <= (simple LtePrim <=))
  (define-primitive eq? (simple EqPrim eq?))
  
  (define-primitive null? (simple NullPrim null?))
  (define-primitive pair? (simple PairPrim pair?))
  (define-primitive symbol? (simple SymbolPrim symbol?))
  (define-primitive number? (simple NumberPrim number?))
  (define-primitive boolean? (simple BooleanPrim boolean?))
  
  (define-primitive bitwise-not (simple BitwiseNotPrim bitwise-not))
  (define-primitive not (simple NotPrim not))
  (define-primitive random (simple RandomPrim))
  (define-primitive now (simple NowPrim))
  
  (define-primitive call-at-time (simple CallAtTimePrim))
  (define-primitive sensor (simple SensorPrim))
  (define-primitive blink (simple BlinkPrim))
  (define-primitive print (simple PrintPrim))
  
  (define-primitive append (simple AppendPrim append))
  (define-primitive list (simple ListPrim list))
  
  
  (define-primitive eval (eval EvalPrim))
  (define-primitive inject-handler (eval InjectHandlerPrim))
  
  
  (define-primitive apply (apply ApplyPrim apply))
  (define-primitive call/cc (apply CallCCPrim))
  
  (define-primitive send-local (sender AMSender))
  (define-primitive send-local/ack (sender AckSender))
  (define-primitive send-serial (sender SerialSender))
  
  (define-receiver recv-local AMReceiver)
  (define-receiver recv-local/ack AckReceiver)
  (define-receiver recv-serial SerialReceiver)
  
  )