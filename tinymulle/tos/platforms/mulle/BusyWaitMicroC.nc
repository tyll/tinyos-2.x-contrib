/**
 * Implementation of the HIL required micro busy wait.
 * For more information see TEP 102.
 *
 * @author Henrik Makitaavola
 */
configuration BusyWaitMicroC
{
  provides interface BusyWait<TMicro, uint16_t>;
}
implementation
{
  components CounterMicro16C,
      new BusyWaitCounterC(TMicro, uint16_t);

  BusyWait = BusyWaitCounterC;
  BusyWaitCounterC.Counter -> CounterMicro16C;
}
