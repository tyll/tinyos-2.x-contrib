/**
 * @author Leon Evers
 */


includes SensorScheme;

module RandPrimM {
  provides interface SSPrimitive;
  uses interface Random;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    return ss_makeNum(call Random.rand32());
  }
}
