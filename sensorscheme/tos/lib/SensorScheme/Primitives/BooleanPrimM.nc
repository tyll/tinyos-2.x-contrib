/**
 * @author Leon Evers
 */


includes SensorScheme;

module BooleanPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    ss_val_t x = arg_1;
    return isBool(x) ? SYM_TRUE : SYM_FALSE;
  }
}
