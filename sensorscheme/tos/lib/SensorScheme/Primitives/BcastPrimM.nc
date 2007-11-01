/**
 * @author Leon Evers
 */


includes SensorScheme;

module BcastPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    dbg("SensorSchemeC", "FN_BCAST.\n");
    ss_set_value(makePrimitive(SEND_LOCAL));
    return ss_cons(ss_makeNum(AM_BROADCAST_ADDR), ss_args);
  }
}
