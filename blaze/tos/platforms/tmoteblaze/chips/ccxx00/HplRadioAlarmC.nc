
generic configuration HplRadioAlarmC() {

  provides interface Init;
  provides interface Alarm<T32khz,uint32_t> as Alarm32khz32;

}

implementation {

  components new Alarm32khz32C();

  Init = Alarm32khz32C;
  Alarm32khz32 = Alarm32khz32C;
  
}
