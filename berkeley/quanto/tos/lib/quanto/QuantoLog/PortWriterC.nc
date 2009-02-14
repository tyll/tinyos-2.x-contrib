configuration PortWriterC {
  provides interface PortWriter; 
}
implementation {
  components PortWriterP, MainC;
  components HplMsp430GeneralIOC as GeneralIOC;

  PortWriter = PortWriterP;

  PortWriterP.CLOCK -> GeneralIOC.Port20; //GIO0 on Hydrowatch
  PortWriterP.FRAME -> GeneralIOC.Port23; //GIO2 on Hydrowatch
  PortWriterP.Boot -> MainC.Boot;

  components TinySchedulerC;
  PortWriterP.WriteBufferTask -> TinySchedulerC.TaskQuanto[unique("TinySchedulerC.TaskQuanto")];
  //PortWriterP.WriteBufferTask -> TinySchedulerC.TaskBasic[unique("TinySchedulerC.TaskBasic")];
}
