/**
 * @author Leon Evers
 */


includes SensorScheme;

module CallCCPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    dbg("SensorSchemeC", "FN_CALL_CC %u.\n", car(ss_args).idx);
    ss_set_value(arg_1);
    return ss_cons(makeContinuation(ss_stack, ss_envir), SYM_NIL);
  }
}
