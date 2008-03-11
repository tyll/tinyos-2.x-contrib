/**
 * @author Leon Evers
 */


includes SensorScheme;

module CarPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    return C_car(arg_1);
  };

}
