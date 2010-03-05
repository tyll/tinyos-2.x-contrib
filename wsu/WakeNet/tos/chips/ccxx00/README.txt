

Documentation is located in the TinyOS documentation website:
http://docs.tinyos.net/index.php/CC1100/CC2500

This radio stack requires fast SPI bus access. For MSP430 platforms, that
means compiling your applications with:

  CFLAGS+=-DENABLE_SPI0_DMA

This radio stack was developed and funded by Rincon Research Corporation.


________________________________________________________________________________
Notes on Throughput:

Throughput is limited by a few elements in the radio stack, the most notable of
which is the CSMA layer. The continuous CSMA and acknowledgment layers have been
carefully constructed to support fair channel utilization in a BMAC type low
power strategy.

If your application requires very fast throughput:
  * Modify Csma.h:
    >> Decrease BLAZE_MIN_INITIAL_BACKOFF to something like 100
    >> Decrease BLAZE_MIN_BACKOFF to something like 10
    >> We used a logic analyzer and several nodes to make sure there were
       no collisions and the channel was being shared fairly.
    
  * Modify AcknowledgmentsP:
    >> In AckReceive.receive(), uncomment the code that stops the AckWaitTimer.
       This will allow the acknowledgment layer to exit as soon as an ack is
       available.
       
Making these types of changes will increase throughput at the expense of a 
single node possibly capturing the channel for longer periods of time than it
should. Experimentation is necessary in all cases.
________________________________________________________________________________

