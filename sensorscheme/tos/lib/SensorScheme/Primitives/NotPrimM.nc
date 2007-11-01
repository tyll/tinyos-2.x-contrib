/**
 * @author Leon Evers
 */


includes SensorScheme;

module NotPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    return eq(arg1, SYM_FALSE) ? SYM_TRUE : SYM_FALSE;
  }
}
