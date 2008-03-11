/**
 * @author Leon Evers
 */


includes SensorScheme;

module EvalPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    dbg("SensorSchemeC", "EvalPrim.eval %u.\n", car(ss_args).idx);
    return arg_1;
  }
}
