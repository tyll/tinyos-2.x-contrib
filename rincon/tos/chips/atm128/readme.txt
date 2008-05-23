@author Danny Park

I am not the author of any of the code here.  The files here that duplicate
files already found in the TinyOS baseline are bug fixes.  The rest add
real time configuration ability and a SyncUartStream on UART1.

For UART configuration be sure to set the config AFTER starting the UART
or your custom settings will be overwritten.