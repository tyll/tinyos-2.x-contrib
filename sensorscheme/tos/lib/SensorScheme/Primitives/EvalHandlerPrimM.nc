/**
 * @author Leon Evers
 */


includes SensorScheme;

module EvalHandlerPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    // message handler bootstrap procedure, evaluates code sent in message
    // arg_1      : src of message -- ignore or treat together with security key (TBD)
    // arg_2      : content to be eval'ed
    return arg_2;    // actual code
  }
}
