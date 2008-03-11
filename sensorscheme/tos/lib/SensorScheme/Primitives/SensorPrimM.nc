/**
 * @author Leon Evers
 */


includes SensorScheme;

module SensorPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    return makeSmallnum(prim);
  }
}
