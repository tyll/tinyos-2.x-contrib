/**
 * @author Leon Evers
 */


includes SensorScheme;

module SetCarPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    ss_val_t c = arg_1;
    assertPair(c);
    car(c) = arg_2;
    return SYM_FALSE;
  };

}
