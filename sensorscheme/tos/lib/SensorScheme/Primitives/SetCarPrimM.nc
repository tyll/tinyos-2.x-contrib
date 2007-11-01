/**
 * @author Leon Evers
 */


includes SensorScheme;

module SetCarPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    ss_val_t c = arg1;
    assertPair(c);
    car(c) = arg2;
    return SYM_FALSE;
  };

}
