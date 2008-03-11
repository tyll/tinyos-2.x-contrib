/**
 * @author Leon Evers
 */


includes SensorScheme;

module AddPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    int32_t x = C_numVal(arg_1);
    int32_t y = C_numVal(arg_2);
    dbg("AddPrimM", "%i + %i = %i\n", x, y, x+y);
    return ss_makeNum(x + y);
  };
}
