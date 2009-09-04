
generic configuration HplRadioAlarmC() {

  provides interface Init;
  provides interface Alarm<T32khz,uint16_t> as Alarm32khz16;

}

implementation {

  components new Alarm32khz16C();

  Init = Alarm32khz16C;
  Alarm32khz16 = Alarm32khz16C;
  
}
