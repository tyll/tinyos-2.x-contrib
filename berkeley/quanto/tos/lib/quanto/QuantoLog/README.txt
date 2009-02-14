Contains several implementations of Quanto Loggers.
The connection to the rest of the Quanto System is through the two
interfaces

 SingleContextTrack
 MultiContextTrack
 PowerStateTrack

Currently there are three major approaches, but we have others
planned (including compressing the UART stream).

  1. QuantoLogMyUARTWriterC is a log that streams over the UART.
  Files:
     QuantoLogMyUARTWriterC/P
   
  2. QuantoLogPortWriterC is a logger that doesn't need any
configuration, and uses a byte-wide port in the processor to write
out log data. It uses a producer-consumer buffer to absorb rate
mismatches when there are bursts of logs, and uses a different task
scheduler to schedule log dumping tasks with the lowest priority in
the system. This logger is very efficient, low overhead, high-bandwidth,
and does not generate interrupts, BUT requires a LabJack or some other
device that can read directly from the processor port. It is likely that
you don't have this...

  Files:
    PortWriter*
    QuantoLogPortWriter*
    
  3. The original in-memory QuantoLog family of loggers, which log
to a buffer in RAM and then dump the log to the UART. They require
an interface to start, stop, and flush the log, but can also be
configured to dump when full. Less recommended.
 
  QuantoLogStagedMyUARTC/P 
 
 
  These loggers use the serial/MySerialSender interfaces and
implementation, which use the standard TinyOS UART framing but do
not use the standard AM headers. This saves considerable bandwidth
in the logging.


