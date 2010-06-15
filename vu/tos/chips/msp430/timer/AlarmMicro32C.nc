generic configuration AlarmMicro32C() {
	provides interface Alarm<TMicro, uint32_t>;
} implementation {

  components new TransformAlarmC(TMicro,uint32_t,TMicro,uint16_t,0);
  components new AlarmMicro16C();
  components CounterMicro32C;
  
  TransformAlarmC.AlarmFrom -> AlarmMicro16C.Alarm;
  TransformAlarmC.Counter -> CounterMicro32C;
  Alarm = TransformAlarmC;

}
