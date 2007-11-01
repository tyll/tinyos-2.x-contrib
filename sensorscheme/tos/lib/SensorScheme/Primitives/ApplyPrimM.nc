/**
 * @author Leon Evers
 */


includes SensorScheme;

module ApplyPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    dbg("SensorSchemeC", "FN_APPLY %u.\n", car(ss_args).idx);
    ss_set_value(arg1);
    return arg2;
  }
}
