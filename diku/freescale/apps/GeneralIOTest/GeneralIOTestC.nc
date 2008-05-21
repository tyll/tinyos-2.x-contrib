module GeneralIOTestC
{
  uses
  {
    interface Boot;
    interface StdControl as ConsoleControl;
    interface ConsoleInput as In;
    interface ConsoleOutput as Out;
    interface HplHcs08GeneralIO as Led;
    interface HplHcs08GeneralIO as GpIn;
    interface Timer<TMilli> as Timer;
  }
}
implementation
{
  event void Boot.booted()
  {
    call ConsoleControl.start();
    call GpIn.pullupOn();
    call Led.makeOutput();
    call GpIn.makeInput();
    call Timer.startPeriodic(1000);
  }
  
  event void Timer.fired()
  {
  	if(call GpIn.get())
  	  call Out.print("Button1 not pressed.\n");
  	else
  	  call Out.print("Button1 pressed.\n");
  }
  
  async event void In.get(uint8_t data) 
  {
    if(data == 'o' || data == 'O')
    {
      call Out.print("Turning led on.\n");
      call Led.clr();
    }
    if(data == 'f' || data == 'F')
    {
      call Out.print("Turning led off.\n");
      call Led.set();
    }
    if(data == 't' || data == 'T')
    {
      call Out.print("Toggling led.\n");
      call Led.toggle();
    }
    if(data == 'p' || data == 'P')
    {
      if(call GpIn.isPullupOn())
      {
        call Out.print("Turning pullup off.\n");
        call GpIn.pullupOff();
      }
      else
      {
        call Out.print("Turning pullup on.\n");
        call GpIn.pullupOn();
      }
    }
  }
}