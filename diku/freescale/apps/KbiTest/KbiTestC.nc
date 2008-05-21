module KbiTestC
{
  uses interface StdControl as KbiControl;
  uses interface Hcs08Kbi as Kbi;
  uses interface StdControl as ConsoleControl;
  uses interface ConsoleOutput as Out;
  uses interface Boot;
}
implementation
{
  
  event void Boot.booted()
  {
    call KbiControl.start();
    call ConsoleControl.start();
    call Kbi.enableKbiPin2();
    call Kbi.enableKbiPin3();
    call Kbi.enableKbiPin4();
    call Kbi.enableKbiPin5();
  }
  
  async event void Kbi.fired(uint8_t data)
  {
  	if(call Kbi.pin2Fired(data))
  	  call Out.print("Switch 1 pressed.\n");
  	if(call Kbi.pin3Fired(data))
  	  call Out.print("Switch 2 pressed.\n");
  	if(call Kbi.pin4Fired(data))
  	  call Out.print("Switch 3 pressed.\n");
  	if(call Kbi.pin5Fired(data))
  	  call Out.print("Switch 4 pressed.\n");
  }
  

}