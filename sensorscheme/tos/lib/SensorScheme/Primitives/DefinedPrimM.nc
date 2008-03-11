/**
 * @author Leon Evers
 */


includes SensorScheme;

module DefinedPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    ss_val_t env = ss_envir;
    ss_val_t t;
    assertSymbol(arg_1); /* Variable is not symbol in defined? */
    while (!isNull(cdr(env))) {
        env = cdr(env);
    }
    t = car(env);
    while (!isNull(t)) {
        if (eq(car(ss_args), car(car(t)))) {
            return SYM_TRUE;
        }
        t = cdr(t);
    }
    return SYM_FALSE;
  }
}
