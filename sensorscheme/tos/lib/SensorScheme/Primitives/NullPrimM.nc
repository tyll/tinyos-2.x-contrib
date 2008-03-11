/**
 * @author Leon Evers
 */


includes SensorScheme;

module NullPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    ss_val_t x = arg_1;
    return isNull(x) ? SYM_TRUE : SYM_FALSE;
  }
}
