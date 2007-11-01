/**
 * @author Leon Evers
 */


includes SensorScheme;

module CallCCPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    dbg("SensorSchemeC", "FN_CALL_CC %u.\n", car(ss_args).idx);
    ss_set_value(arg1);
    return ss_cons(makeContinuation(ss_stack, ss_envir), SYM_NIL);
  }
}
