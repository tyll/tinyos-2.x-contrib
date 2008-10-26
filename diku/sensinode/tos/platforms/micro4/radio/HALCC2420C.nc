/*
 * Copyright (c) 2007 University of Copenhagen
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *
 * @author Marcus Chang <marcus@diku.dk>
 * @author Klaus S. Madsen <klaussm@diku.dk>
 */



configuration HALCC2420C {
	provides {
		interface HALCC2420;
		interface StdControl;
	}
	uses {
		interface StdOut;
	}
}

implementation {
	components MainC, HALCC2420M, HPLCC2420M, HPLSpiM, 
		BusArbitrationC, HPL1wireM;

    MainC.SoftwareInit -> HPLCC2420M.Init;
    MainC.SoftwareInit -> HALCC2420M.Init;
    MainC.SoftwareInit -> HPLSpiM.Init;

    StdControl = HALCC2420M.HALCC2420Control;
	HALCC2420 = HALCC2420M.HALCC2420;
	StdOut = HALCC2420M.StdOut;
	
	HALCC2420M.Spi -> HPLSpiM.Spi;
    HALCC2420M.HPLCC2420Control -> HPLCC2420M.HPLCC2420Control;
	HALCC2420M.HPLCC2420 -> HPLCC2420M.HPLCC2420;
	HALCC2420M.HPLCC2420RAM -> HPLCC2420M.HPLCC2420RAM;
	HALCC2420M.HPLCC2420FIFO -> HPLCC2420M.HPLCC2420FIFO;
	HALCC2420M.HPLCC2420Status -> HPLCC2420M.HPLCC2420Status;
	HALCC2420M.BusArbitration -> BusArbitrationC.BusArbitration[unique("BusArbitration")];
	HALCC2420M.HPL1wire -> HPL1wireM.HPL1wire;

	HPLCC2420M.Spi -> HPLSpiM.Spi;

    components HplMsp430InterruptC;
    components new Msp430InterruptC() as MSP430Interrupt;
    MSP430Interrupt.HplInterrupt -> HplMsp430InterruptC.Port17;

    HALCC2420M.MSP430Interrupt -> MSP430Interrupt.Interrupt;
}


