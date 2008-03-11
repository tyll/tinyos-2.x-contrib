/**
 * @author Leon Evers
 */


includes SensorScheme;

module BlinkPrimM {
  provides interface SSPrimitive;
  uses interface SSRuntime;
  uses interface Leds;
}

implementation {

  command ss_val_t SSPrimitive.eval() {
    dbg("SensorSchemeC", "FN_BLINK %i.\n", ss_numVal(arg_1));
    // TODO: make this actually blink
    call Leds.set(ss_numVal(arg_1));
    return SYM_FALSE;
  }
}
