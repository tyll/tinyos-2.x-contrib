/**
 * @author Leon Evers
 */


includes SensorScheme;

module InjectHandlerPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    // message handler bootstrap procedure, evaluates code sent in message
    // arg_1 : src of message -- ignore or treat together with security key (TBD)
    // content to be eval'ed is in the other args
    // construct a thunk containing the rest arguments, and evaluate it
    ss_val_t res =  ss_cons(ss_cons(SYM(LAMBDA), ss_cons(SYM_NIL, cdr(ss_args))), SYM_NIL);
    return res;   
  }
}
