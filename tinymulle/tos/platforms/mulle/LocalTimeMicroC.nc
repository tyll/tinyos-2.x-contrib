/**
 * Local time in micro precision.
 *
 * @author Henrik Makitaavola
 */

configuration LocalTimeMicroC
{
	provides interface LocalTime<TMicro>;
}

implementation
{
	components new TransformCounterC(TMicro, uint32_t, TMicro, uint16_t, 0, uint32_t);
	components new CounterToLocalTimeC(TMicro);
        components CounterMicro16C;

	CounterToLocalTimeC.Counter -> TransformCounterC;
	TransformCounterC.CounterFrom -> CounterMicro16C;
	LocalTime = CounterToLocalTimeC;
}
