@author Danny Park

SyncUartStream takes an ordinary asynchronous UartStream interface and
turns it into a synchronous SyncUartStream interface.

WARNING:This is not recommended for data rates that are not slow
compared to the processor speed.