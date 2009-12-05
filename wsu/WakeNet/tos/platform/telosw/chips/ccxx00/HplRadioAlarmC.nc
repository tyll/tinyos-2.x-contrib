
generic configuration HplRadioAlarmC() {

  provides interface Init;
	//modified by Gang Sep 1 09
  //provides interface Alarm<T32khz,uint32_t> as Alarm32khz32;
  provides interface Alarm<T32khz,uint16_t> as Alarm32khz16;
	//end of modification

}

implementation {

  components new Alarm32khz16C();
  Init = Alarm32khz16C;
  Alarm32khz16 = Alarm32khz16C;
  
}
