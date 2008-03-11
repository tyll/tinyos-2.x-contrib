/**
 * @author Leon Evers
 */


includes SensorScheme;

module NumberPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    ss_val_t x = arg_1;
    return isNumber(x) ? SYM_TRUE : SYM_FALSE;
  }
}
