/**
 * @author Leon Evers
 */


includes SensorScheme;

module BitwiseNotPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    return ss_makeNum(~ C_numVal(arg1));
  }
}
