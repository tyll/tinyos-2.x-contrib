/**
 * @author Leon Evers
 */


includes SensorScheme;

module SymbolPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    ss_val_t x = arg_1;
    return isSymbol(x) ? SYM_TRUE : SYM_FALSE;
  }
}
