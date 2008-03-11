/**
 * @author Leon Evers
 */


includes SensorScheme;

module EqPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    ss_val_t x = arg_1;
    ss_val_t y = arg_2;
    return ((isNumber(x) && isNumber(y) &&
               (ss_numVal(x) == ss_numVal(y))) ||
               eq(x, y)) ? SYM_TRUE : SYM_FALSE;
  }
}
