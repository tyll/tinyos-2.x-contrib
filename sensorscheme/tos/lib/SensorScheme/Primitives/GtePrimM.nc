/**
 * @author Leon Evers
 */


includes SensorScheme;

module GtePrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    uint32_t x = C_numVal(arg_1);
    uint32_t y = C_numVal(arg_2);
    return (x >= y) ? SYM_TRUE : SYM_FALSE;
  }
}
