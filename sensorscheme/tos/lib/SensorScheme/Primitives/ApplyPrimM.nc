/**
 * @author Leon Evers
 */


includes SensorScheme;

module ApplyPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    dbg("SensorSchemeC", "FN_APPLY %u.\n", car(ss_args).idx);
    ss_set_value(arg_1);
    return arg_2;
  }
}
