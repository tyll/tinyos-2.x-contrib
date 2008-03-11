/**
 * @author Leon Evers
 */


includes SensorScheme;

module NotPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    return eq(arg_1, SYM_FALSE) ? SYM_TRUE : SYM_FALSE;
  }
}
