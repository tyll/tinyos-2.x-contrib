/**
 * @author Leon Evers
 */


includes SensorScheme;

module BitwiseNotPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    return ss_makeNum(~ C_numVal(arg_1));
  }
}
