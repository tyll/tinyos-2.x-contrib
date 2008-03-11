/**
 * @author Leon Evers
 */


includes SensorScheme;

module PairPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    ss_val_t x = arg_1;
    return isPair(x) ? SYM_TRUE : SYM_FALSE;
  }
}
