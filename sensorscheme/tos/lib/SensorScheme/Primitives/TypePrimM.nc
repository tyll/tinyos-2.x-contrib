/**
 * @author Leon Evers
 */


includes SensorScheme;

module TypePrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    ss_val_t x = arg1;
    bool r;
    switch (prim) {
      case NULLP: r = isNull(x); break;
      case PAIRP: r = isPair(x); break;
      case SYMBOLP: r = isSymbol(x); break;
      case NUMBERP: r = isNumber(x); break;
      case BOOLEANP: r = isBool(x); break;
      default: r = 0;
    }
    return r ? SYM_TRUE : SYM_FALSE;
  }
}
