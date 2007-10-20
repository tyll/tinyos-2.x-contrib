/**
	Lifeng Sang  <sangl@cse.ohio-state.edu>

	$Date$
	
	Porting TinyOS to Intel PSI motes
 */

In order to make program using TinyOS 2.0 for the PSI mote, please follow these steps.

Assume $tinyos is the directoy where you install the TinyOS 2.0 (e.g. /opt/tinyos-2.0)

1. copy the psi directory into $tinyos/tos/platforms/

2. copy the psi.target into $tinyos/support/make

3. you can 'make psi' (similar to make other platform specific program, e.g. 'make telosb'),
		to create a program for the Intel PSI IR mote.

For further questions (e.g. install on the PSI mote and SerialFowarder/Injector on the phone), 
please contact Lifeng Sang <sangl@cse.ohio-state.edu>.
		