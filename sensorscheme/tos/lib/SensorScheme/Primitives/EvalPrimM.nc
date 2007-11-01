/**
 * @author Leon Evers
 */


includes SensorScheme;

module EvalPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    dbg("SensorSchemeC", "EvalPrim.eval %u.\n", car(ss_args).idx);
    return arg1;
  }
}
