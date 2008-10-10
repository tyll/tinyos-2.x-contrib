/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration PrintPrim {
  provides interface SSPrimitive;
}

implementation {
  components PrintPrimM;
  components SensorSchemeC;
  components LedsC;
  
  SSPrimitive = PrintPrimM;
  PrintPrimM.SSRuntime -> SensorSchemeC;
  PrintPrimM.Leds -> LedsC;

#ifdef DO_PRINTF_DBG
  components PrintfC;

  PrintPrimM.PrintfControl -> PrintfC;
  PrintPrimM.PrintfFlush -> PrintfC;
#endif
}
