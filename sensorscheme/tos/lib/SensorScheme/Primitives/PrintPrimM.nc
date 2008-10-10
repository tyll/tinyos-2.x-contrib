/**
 * @author Leon Evers
 */


includes SensorScheme;

module PrintPrimM {
  provides interface SSPrimitive;
  uses { 
    interface SSRuntime;
    interface Leds;

#ifdef DO_PRINTF_DBG
    interface SplitControl as PrintfControl;
    interface PrintfFlush;
#endif
  }
}

implementation {

#ifdef DO_PRINTF_DBG
  event void PrintfFlush.flushDone(error_t error) {
  }

  event void PrintfControl.startDone(error_t error) {
  }
	
  event void PrintfControl.stopDone(error_t error) {
  } 
#endif
  void printElem(ss_val_t val) {
    if (isNull(val)) {
      pr_dbg_clear("SensorSchemePrint", "()");
    } else if (isSymbol(val)) {
      pr_dbg_clear("SensorSchemePrint", "%%s%i", C_symVal(val));
    } else if (isNumber(val)) {
      pr_dbg_clear("SensorSchemePrint", "%li", C_numVal(val));
    } else if (isPair(val)) {
      pr_dbg_clear("SensorSchemePrint", "(");
      while (isPair(val)) {
        printElem(car(val));
        if (isPair(cdr(val))) {
          pr_dbg_clear("SensorSchemePrint", " ");
        }
        val = cdr(val);
      }
      pr_dbg_clear("SensorSchemePrint", ")");
    }
  }

  command ss_val_t SSPrimitive.eval() {
    ss_val_t val = ss_args;
    dbg("SensorSchemePrint", "");
    while (isPair(val)) {
      printElem(car(val));
      if (isPair(cdr(val))) {
        pr_dbg_clear("SensorSchemePrint", " ");
      }
      val = cdr(val);
    }
    pr_dbg_clear_f("SensorSchemePrint", "\n");
    return SYM_FALSE;
  }
}
