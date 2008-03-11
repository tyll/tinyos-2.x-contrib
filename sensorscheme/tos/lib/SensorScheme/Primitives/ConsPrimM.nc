/**
 * @author Leon Evers
 */


includes SensorScheme;

module ConsPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
   arg_1;    
    // reuse cons cell of arglist
    cdr(ss_args) = arg_2;
    return ss_args;
  };
}
