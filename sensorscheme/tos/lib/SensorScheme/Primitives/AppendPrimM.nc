/**
 * @author Leon Evers
 */


includes SensorScheme;

module AppendPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    if (!isPair(ss_args)) return ss_args;
    {
      ss_val_t res = call SSRuntime.cons(SYM_NIL, SYM_NIL);
      ss_val_t r = res;
      ss_val_t p = ss_args;
      while (!isNull(cdr(p))) {
          ss_val_t q = car(p);
          while (!isNull(q)) {
              cdr(r) = call SSRuntime.cons(car(q), SYM_NIL);
              r = cdr(r);
              q = cdr(q);
          }
          p = cdr(p);
      }
      cdr(r) = car(p);
      return cdr(res);
    }
  }
}
