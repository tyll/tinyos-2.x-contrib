/**
 * @author Leon Evers
 */


includes SensorScheme;

module EvalHandlerPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    // message handler bootstrap procedure, evaluates code sent in message
    // arg1      : src of message -- ignore or treat together with security key (TBD)
    // arg2      : content to be eval'ed
    return arg2;    // actual code
  }
}
