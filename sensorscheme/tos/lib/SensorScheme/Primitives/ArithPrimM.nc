/**
 * @author Leon Evers
 */


includes SensorScheme;

module ArithPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
}

implementation {

  command ss_val_t SSPrimitive.eval(uint8_t prim) {
    uint32_t x = C_numVal(arg1);
    uint32_t y = C_numVal(arg2);
    uint32_t r;
    switch (prim) {
      case ADD: r = x + y; break;
      case SUB: r = x - y; break;
      case MULT: r = x * y; break;
      case DIV: r = x / y; break;
      case MOD: r = x % y; break;
      case BITWISE_XOR: r = x ^ y; break;
      case BITWISE_IOR: r = x | y; break;
      case BITWISE_AND: r = x & y; break;
      default: r = 0;
    }
    return ss_makeNum(r);
  };
}
