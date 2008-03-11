/**
 * @author Leon Evers
 */


includes SensorScheme;

module CallAtTimePrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    //insert new item into timer queue
    ss_val_t q = ss_timerQueue;
    ss_val_t r = SYM_NIL;
    int32_t t = C_numVal(arg_1);
    cdr(ss_args) = arg_2;
    dbg("CallAtTimePrimM", "call-at-time %i.\n", t);
    while (!isNull(q)) {
        if (ss_numVal(car(car(q))) <= t) {
            // timeout larger than current item in list, keep looking
            r = q;
            q = cdr(q);
        } else {
            break;
        }
    }
    {
      ss_val_t s = ss_cons(ss_args, q);
      if (isNull(r)) ss_set_timerQueue(s);
      else cdr(r) = s;
    }
    call SSRuntime.startTimer(ss_numVal(car(car(ss_timerQueue))));
    return SYM_FALSE;
  }
}
