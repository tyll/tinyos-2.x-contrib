/**
 * @author Leon Evers
 */


includes SensorScheme;

module LogicPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    uint32_t x = C_numVal(arg1);
    uint32_t y = C_numVal(arg2);
    bool r;
    switch (prim) {
      case GT: r = x > y; break;
      case GTE: r = x >= y; break;
      case LT: r = x < y; break;
      case LTE: r = x <= y; break;
      default: r = 0;
      }
    return r ? SYM_TRUE : SYM_FALSE;
  }
}
