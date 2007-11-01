/**
 * @author Leon Evers
 */


includes SensorScheme;

module ConsPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
   arg1;    
    // reuse cons cell of arglist
    cdr(ss_args) = arg2;
    return ss_args;
  };
}
