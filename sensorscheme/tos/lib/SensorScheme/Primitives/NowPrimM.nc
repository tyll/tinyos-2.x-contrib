/**
 * @author Leon Evers
 */


includes SensorScheme;

module NowPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
//  uses interface Timer<TMilli>;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    return ss_makeNum(call SSRuntime.now());
  }
}
