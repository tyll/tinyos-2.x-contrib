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


configuration FlashAccessC {
    provides {
        interface StdControl as FlashControl;
        interface FlashAccess;
    }
}

implementation {

    components MainC;
    MainC.SoftwareInit -> FlashAccessM.FlashInit;
    MainC.SoftwareInit -> HPLSpiM.Init;

    components FlashAccessM, HALSTM25P40M, HPLSTM25P40M, HPLSpiM, BusArbitrationC;
    FlashControl = FlashAccessM.FlashControl;
    FlashAccess = FlashAccessM.FlashAccess;

    FlashAccessM.Flash      ->  HALSTM25P40M.Flash;

    HALSTM25P40M.BusArbitration     ->  BusArbitrationC.BusArbitration[unique("BusArbitration")];
    HALSTM25P40M.Spi                ->  HPLSpiM.Spi;
    HALSTM25P40M.HPLFlash           ->  HPLSTM25P40M.HPLFlash;

    components new TimerMilliC() as TimerC;
    HALSTM25P40M.Timer              ->  TimerC;

    HPLSTM25P40M.Spi        ->  HPLSpiM.Spi;
    
    components StdNullC as StdOutC;
    HALSTM25P40M.StdOut -> StdOutC;
    HPLSTM25P40M.StdOut -> StdOutC;
}


