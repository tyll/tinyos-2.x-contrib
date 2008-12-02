/**
 * @author Leon Evers
 */

includes printf;

includes SensorScheme;

module PrintPrimM {
  provides interface SSPrimitive;
  uses { 
    interface SSRuntime;
  }
}

implementation {

#ifdef TOSSIM 
#define doprint(...) \
  dbg_clear("SensorSchemePrint", __VA_ARGS__) 
#define doflush() 
#else
#define doprint(...) \
  printf(__VA_ARGS__) 

#define doflush() \
  printfflush() 
#endif

  
  void printElem(ss_val_t val) {
    if (isNull(val)) {
      doprint("()");
    } else if (isSymbol(val)) {
      doprint("%%s%i", C_symVal(val));
    } else if (isNumber(val)) {
      doprint("%li", C_numVal(val));
    } else if (isPair(val)) {
      doprint("(");
      while (isPair(val)) {
        printElem(car(val));
        if (isPair(cdr(val))) {
          doprint(" ");
        }
        val = cdr(val);
      }
      doprint(")");
    }
  }

  command ss_val_t SSPrimitive.eval() {
    ss_val_t val = ss_args;
#ifdef TOSSIM 
    dbg("SensorSchemePrint", ""); 
#endif
    while (isPair(val)) {
      printElem(car(val));
      if (isPair(cdr(val))) {
        doprint(" ");
      }
      val = cdr(val);
    }
    doprint("\n");
    doflush();
    return SYM_FALSE;
  }
}
