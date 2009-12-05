configuration ProbeTestAppC { }
implementation {
  components MainC, ProbeTestC, new TimerMilliC();
  
  ProbeTestC.Boot -> MainC;
  ProbeTestC.Timer -> TimerMilliC;
}
