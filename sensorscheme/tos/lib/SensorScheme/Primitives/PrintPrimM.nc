/**
 * @author Leon Evers
 */


includes SensorScheme;

#include "printf.h"

module PrintPrimM {
  provides interface SSPrimitive;
  uses { 
    interface SSRuntime;
  }
}

implementation {

  void printElem(ss_val_t val) {
    if (isNull(val)) {
      printf("()");
    } else if (isSymbol(val)) {
      printf("%%s%i", C_symVal(val));
    } else if (isNumber(val)) {
      printf("%li", C_numVal(val));
    } else if (isPair(val)) {
      printf("(");
      while (isPair(val)) {
        printElem(car(val));
        if (isPair(cdr(val))) {
          printf(" ");
        }
        val = cdr(val);
      }
      printf(")");
    }
  }

  command ss_val_t SSPrimitive.eval() {
    ss_val_t val = ss_args;
    dbg("");
    while (isPair(val)) {
      printElem(car(val));
      if (isPair(cdr(val))) {
        printf(" ");
      }
      val = cdr(val);
    }
    printf("\n");
    printfflush();
    return SYM_FALSE;
  }
}
