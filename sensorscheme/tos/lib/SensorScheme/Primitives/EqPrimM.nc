/**
 * @author Leon Evers
 */


includes SensorScheme;

module EqPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    ss_val_t x = arg1;
    ss_val_t y = arg2;
    return ((isNumber(x) && isNumber(y) &&
               (ss_numVal(x) == ss_numVal(y))) ||
               eq(x, y)) ? SYM_TRUE : SYM_FALSE;
  }
}
