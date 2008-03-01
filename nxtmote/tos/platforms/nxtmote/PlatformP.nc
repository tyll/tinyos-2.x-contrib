/*
 * Copyright (c) 2007 nxtmote project
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
 * - Neither the name of nxtmote project nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */

#include "hardware.h"

module PlatformP{
  provides interface Init;
  uses {
      interface Init as InitL0;
      interface Init as InitL1;
      interface Init as InitL2;
      interface Init as InitL3;
      interface Init as PInit;
  }
}
implementation{

  command error_t Init.init() {
    // AT91F_LowLevelInit() in Cstartup_SAM7.c has been called
    // TODO: Move it so equivalent code is called from this place
    //int            i;
    uint32_t TmpReset;

    AT91PS_PMC     pPMC = AT91C_BASE_PMC;

    //* Set Flash Waite sate
    //  Single Cycle Access at Up to 30 MHz, or 40
    //  if MCK = 47923200 I have 72 Cycle for 1,5 usecond ( flied MC_FMR->FMCN
    AT91C_BASE_MC->MC_FMR = ((AT91C_MC_FMCN)&(72 <<16)) | AT91C_MC_FWS_1FWS ;

    //* Watchdog Disable
    AT91C_BASE_WDTC->WDTC_WDMR= AT91C_WDTC_WDDIS;

    //* Set MCK at 47 923 200
    // 1 Enabling the Main Oscillator:
    // SCK = 1/32768 = 30.51 uSecond
    // Start up time = 8 * 6 / SCK = 56 * 30.51 = 1,46484375 ms
    pPMC->PMC_MOR = (( (AT91C_CKGR_OSCOUNT & (0x06 <<8)) | AT91C_CKGR_MOSCEN ));

    // Wait the startup time
    while(!(pPMC->PMC_SR & AT91C_PMC_MOSCS));

    // 2 Checking the Main Oscillator Frequency (Optional)
    // 3 Setting PLL and divider:
    // - div by 14 Fin = 1.3165 =(18,432 / 14)
    // - Mul 72+1: Fout = 96.1097 =(3,6864 *73)
    // for 96 MHz the erroe is 0.11%
    // Field out NOT USED = 0
    // PLLCOUNT pll startup time estimate at : 0.844 ms
    // PLLCOUNT 28 = 0.000844 /(1/32768)
    pPMC->PMC_PLLR = ((AT91C_CKGR_DIV      &  14) |
                      (AT91C_CKGR_PLLCOUNT & (28<<8)) |
                      (AT91C_CKGR_MUL      & (72<<16)));

    // Wait the startup time
    while(!(pPMC->PMC_SR & AT91C_PMC_LOCK));
    while(!(pPMC->PMC_SR & AT91C_PMC_MCKRDY));

    // 4. Selection of Master Clock and Processor Clock
    // select the PLL clock divided by 2
    pPMC->PMC_MCKR = AT91C_PMC_PRES_CLK_2 ;
    while(!(pPMC->PMC_SR & AT91C_PMC_MCKRDY));

    pPMC->PMC_MCKR |= AT91C_PMC_CSS_PLL_CLK  ;
    while(!(pPMC->PMC_SR & AT91C_PMC_MCKRDY));

    // Set up the default interrupts handler vectors
    // See CStartup.S. Fast interrupt and interrupt are mapped to
    //   fiqhandler and irqhandler in HplInteruptM.nc

    // Enable the PIOA controller so the reading of AT91_PIOA_PDSR will
    // work in the Led toggle call.
    pPMC->PMC_PCER = (1<<AT91C_ID_PIOA);

    //AT91C_BASE_AIC->AIC_SVR[0] = (int) AT91F_Default_FIQ_handler ;

    //TODO
    AT91C_BASE_AIC->AIC_SPU  = (int) AT91F_Spurious_handler ;

    *AT91C_RSTC_RMR  = 0xA5000401;
    *AT91C_AIC_DCR   = 1;

    // PIT timer is for 1 ms intervals
    //*AT91C_PITC_PIMR = (0x000FFFFF | 0x01000000 ); /*original*/
    *AT91C_PITC_PIMR = (MS_1_TIME | AT91C_PITC_PITEN | AT91C_PITC_PITIEN );
    TmpReset         = *AT91C_PITC_PIVR;
    TmpReset         = TmpReset;/* Suppress warning*/

    *AT91C_PMC_PCER  = (1L<<AT91C_ID_TWI);/* Enable TWI Clock        */

    call InitL0.init();
    call InitL1.init();
    call InitL2.init();
    call InitL3.init();
    call PInit.init();

    return SUCCESS;
  }

  default command error_t InitL0.init() { return SUCCESS; }
  default command error_t InitL1.init() { return SUCCESS; }
  default command error_t InitL2.init() { return SUCCESS; }
  default command error_t InitL3.init() { return SUCCESS; }
  default command error_t PInit.init()  { return SUCCESS; }
}
