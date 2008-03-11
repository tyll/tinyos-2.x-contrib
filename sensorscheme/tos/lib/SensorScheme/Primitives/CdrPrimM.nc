/**
 * @author Leon Evers
 */


includes SensorScheme;

module CdrPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    return C_cdr(arg_1);  
  };

}
