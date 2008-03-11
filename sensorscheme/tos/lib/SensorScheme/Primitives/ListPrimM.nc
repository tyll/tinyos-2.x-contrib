/**
 * @author Leon Evers
 */


includes SensorScheme;

module ListPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    return ss_args;
  }
}
