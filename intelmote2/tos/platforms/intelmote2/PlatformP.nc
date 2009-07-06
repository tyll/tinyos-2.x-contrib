/*
 * Copyright (c) 2005 Arch Rock Corporation 
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *  
 *   Neither the name of the Arch Rock Corporation nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE ARCHED
 * ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
/**
 * @author Philip Buonadonna, Robbie Adler
 */

#include "hardware.h"
#include "mmu.h"

module PlatformP {
  provides interface Init;
  provides interface PlatformReset;
  uses {
    interface Init as InitL0;
    interface Init as InitL1;
    interface Init as InitL2;
    interface Init as InitL3;
    interface Init as PMICInit;
  }
  uses interface HplPXA27xOSTimer as OST0M3;
  uses interface HplPXA27xOSTimerWatchdog as PXA27xWD;
}
implementation {

  void initMemory(bool bInitSDRAM);

  command error_t Init.init() {
    
    // Enable clocks to critical components 
    CKEN = (CKEN22_MEMC | CKEN20_IMEM | CKEN15_PMI2C | CKEN9_OST);
    // Set the arbiter to something meaningful for this platform
    ARB_CNTL = (ARB_CNTL_CORE_PARK | 
		ARB_CNTL_LCD_WT(0) | ARB_CNTL_DMA_WT(1) | ARB_CNTL_CORE_WT(4));
    

    OSCC = (OSCC_OON);
    while ((OSCC & OSCC_OOK) == 0);
    
    TOSH_SET_PIN_DIRECTIONS();
    
    // Enable access to CP6 (Interrupt Controller processor)
    // Enable access to Intel WMMX enhancements
    asm volatile ("mcr p15,0,%0,c15,c1,0\n\t": : "r" (0x43));

#ifndef SYSTEM_CORE_FREQUENCY
    //FREQUENCY CAN NOT BE GREATER THAN 104 without changing the core voltage using the PMIC
#define SYSTEM_CORE_FREQUENCY 13
#endif
    
#if defined(SYSTEM_CORE_FREQUENCY) && SYSTEM_CORE_FREQUENCY!=13 && SYSTEM_CORE_FREQUENCY!=104 && SYSTEM_CORE_FREQUENCY!=208
    !@$% unsupported frequency
#endif
      
#if defined(SYSTEM_CORE_FREQUENCY) && (SYSTEM_CORE_FREQUENCY==13)
      {
	// Place PXA27X into 13M w/ PPLL enabled...
	// other bits are ignored...but might be useful later
	CCCR = (CCCR_CPDIS | CCCR_L(8) | CCCR_2N(2) | CCCR_A);
	asm volatile (
		      "mcr p14,0,%0,c6,c0,0\n\t"
		      :
		      : "r" (CLKCFG_F)
		      );
      }
#endif
#if defined(SYSTEM_CORE_FREQUENCY) && (SYSTEM_CORE_FREQUENCY==104)
    {
      // Place PXA27x into 104/104 MHz mode
      CCCR = CCCR_L(8) | CCCR_2N(2) | CCCR_A; 
      asm volatile (
		    "mcr p14,0,%0,c6,c0,0\n\t"
		    :
		    : "r" (CLKCFG_B | CLKCFG_F | CLKCFG_T)
		    );
    }
#endif
#if defined(SYSTEM_CORE_FREQUENCY) && (SYSTEM_CORE_FREQUENCY==208)
    {
      // Place PXA27x into 208/208 MHz mode
      CCCR = CCCR_L(16) | CCCR_2N(2) | CCCR_A;
      asm volatile (
		    "mcr p14,0,%0,c6,c0,0\n\t"
		    :
		    : "r" (CLKCFG_B | CLKCFG_F | CLKCFG_T)
		    );
    }
#endif
    
    initMMU();
    enableICache();
    initMemory(TRUE);
    //enableDCache();
    
    // Place all global platform initialization before this command.
    // return call SubInit.init();
    call InitL0.init();
    call InitL1.init();
    call InitL2.init();
    call InitL3.init();
    
    //call PMICInit.init();
    return SUCCESS;
  }
  
  async command void PlatformReset.reset() {
    call OST0M3.setOSMR(call OST0M3.getOSCR() + 1000);
    call PXA27xWD.enableWatchdog();
    while (1);
    return; // Should never get here.
  }

  async event void OST0M3.fired() 
  {
    call OST0M3.setOIERbit(FALSE);
    call OST0M3.clearOSSRbit();
    return;
  }

  default command error_t InitL0.init() { return SUCCESS; }
  default command error_t InitL1.init() { return SUCCESS; }
  default command error_t InitL2.init() { return SUCCESS; }
  default command error_t InitL3.init() { return SUCCESS; }

  void initMemory(bool bInitSDRAM){
   
    uint32_t waitStart;
    uint32_t *pSDRAM = (uint32_t *)0xa0000000;
    int i;
    
    
    //initialize the memory controller
    //PXA27x MemConttroller 1st tier initialization.See 6.4.10 for details
    // Initialize Memory/Flash subsystems
    /**
       1. On hardware reset, complete a power-on wait period (typically 
       100-200 us) to allow the internal clocks (which generate SDCLK) to 
       stabilize. MDREFR[K0RUN] can be enabled at this time for synchronous 
       flash memory. Allowed writes are shown below. Refer to the Intel®
       PXA27x Processor Family EMTS for timing details.
    **/
    
    SA1110 = SA1110_SXSTACK(1);
    //MSC0 =MSC0 | MSC_RBW024 | MSC_RBUFF024 | MSC_RT024(2) ;
    MSC0 =MSC0 | MSC_RBW024 | MSC_RBUFF024 | MSC_RT024(0) ;
    MSC1 =MSC1 | MSC_RBW024;
    MSC2 =MSC2 | MSC_RBW024;
    
    //PXA27x MemController 2nd tier initialization.See 6.4.10 for details
    MECR =0; //no PC Card is present and 1 card slot
    
    /** 
	the folowing registers are used for configuring PC card access
	MCMEM0; used for PC Cards
	MCMEM1; used for PC Cards
	MCATT0;
	MCATT1
	MCIO0;
	MCIO1;
    **/
    
    
    //PXA27x MemController 3rd tier initialization.See 6.4.10 for details
    //FLYCNFG
    
    //PXA27x MemController 4th tier initialization.See 6.4.10 for details
    MDCNFG = (MDCNFG_DTC2(0x3) |MDCNFG_STACK0 | MDCNFG_SETALWAYS |
	      MDCNFG_DTC0(0x3) | MDCNFG_DNB0 | MDCNFG_DRAC0(0x2) | 
	      MDCNFG_DCAC0(0x1) | MDCNFG_DWID0);
    
    
    /**
       From 6.4.10
       Set MDREFR[K0RUN]. Properly configure MDREFR[K0DB2] and MDREFR[K0DB4].
       Retain the current values of MDREFR[APD] (clear) and MDREFR[SLFRSH] 
       (set). MDREFR[DRI] must contain a valid value (not all 0s). If required,
       MDREFR[KxFREE] can be de-asserted.
    **/
    
    MDREFR = (MDREFR & ~(0xFFF)) | MDREFR_DRI(0x18); 
        
    //PXA27x MemController 5th tier initialization.See 6.4.10 for details
    //SXCNFG = SXCNFG_SXEN0 | SXCNFG_SXCL0(4) | SXCNFG_SXTP0(3);
    
    /**
       2. In systems that contain synchronous flash memory, write to the 
       SXCNFG to configure all appropriate bits, including the enables. While 
       the synchronous flash banks are being configured, the SDRAM banks must 
       be disabled and MDREFR[APD] must be de-asserted (auto-power-down 
       disabled).
    **/
    initSyncFlash(); 
    
    if(bInitSDRAM == FALSE){
      return;
    }
    /**
       3. Toggle the SDRAM controller through the following state
       sequence: self-refresh and clock-stop to self-refresh to power-down 
       to PWRDNX to NOP. See Figure 6-4. The SDRAM clock run and enable bits, 
       (MDREFR[K1RUN] and MDREFR[K2RUN] and MDREFR[E1PIN]), are described 
       in Section 6.5.1.3. MDREFR[SLFRSH] must not be set.
    **/

    /**
       a. Set MDREFR[K1RUN], MDREFR[K2RUN] (self-refresh and clock-stop 
       through selfrefresh). MDREFR[K1DB2] and MDREFR[K2DB2] must be 
       configured appropriately.  Also, clear the free running clock bits to
       save power and configure the boot partition (FLASH) clock to run since
       we already put FLASH in sync mode
    **/
    MDREFR = (MDREFR & ~(MDREFR_K0FREE | MDREFR_K1FREE | MDREFR_K2FREE)) | 
      (MDREFR_K1RUN | MDREFR_K1DB2 | MDREFR_K0DB2 | MDREFR_K0RUN); 
    //MDREFR |= (MDREFR_K1RUN | MDREFR_K1DB2); 
    /**
       b. Clear MDREFR[SLFRSH] (self-refresh through power down)
    **/
    MDREFR &= ~MDREFR_SLFRSH;
    
    /**
    c. Set MDREFR[E1PIN] (power down through PWRDNX)
    **/
    MDREFR |= MDREFR_E1PIN;
    
    /**
       d. No write required for this state transition (PWRDNX through NOP)
    **/
    
    /**
       4. Appropriately configure, but do not enable, each SDRAM partition 
       pair. SDRAM partitions are disabled by keeping the MDCNFG[DEx] bits 
       clear.
    **/
    //this was done earlier;

    /**
    5. For systems that contain SDRAM, wait the NOP power-up waiting period 
    required by the SDRAMs (normally 100-200 usec) to ensure the SDRAMs 
    receive a stable clock with a NOP condition.
    **/
    //OSCR0 runs at 3.25MHz.  200us = 650 clks, 250us = 812
    //look at a difference in order to take care of wrapping arithmetic
    waitStart = OSCR0;
    while( (OSCR0 - waitStart) < 800); 
    
    /**
       6. Ensure the XScale core memory-management data cache (Coprocessor 15, 
       Register 1, bit 2) is disabled. If this bit is enabled, the refreshes 
       triggered by the next step may not be passed properly through to the 
       memory controller. Coprocessor 15, register 1, bit 2 must be reenabled
       after the refreshes are performed if data cache is preferred.
       Note:  calling disable DCache takes ~25seconds!!! assume for now that it is
       //already disabled
       
    **/
    //disableDCache();
      
    /**
    7. On hardware reset in systems that contain SDRAM, trigger a number 
    (the number required by the SDRAM manufacturer) of refresh cycles by 
    attempting non-burst read or write accesses to any disabled SDRAM bank. 
    Each such access causes a simultaneous CBR for all four banks, which in 
    turn causes a pass through the CBR state and a return to NOP. On the 
    first pass, the PALL state is incurred before the CBR state. 
    See Figure 6-4.
    **/
    for (i=0; i<7; i++){
      *pSDRAM = (uint32_t)pSDRAM;
    }
    
    /**
    8. Set coprocessor 15, register 1, bit 2 if it was cleared in step 6.
    **/

    /**
       9. In systems that contain SDRAM, enable SDRAM partitions by setting 
       MDCNFG[DEx] bits.
    **/
    MDCNFG |= MDCNFG_DE0;
    
    /**
       10. In systems that contain SDRAM, write the MDMRS register to trigger 
       an MRS command to all enabled banks of SDRAM. For each SDRAM partition 
       pair that has one or both partitions enabled, this forces a pass through
       the MRS state and a return to NOP. The CAS latency is the only variable 
       option and is derived from what was programmed into the MDCNFG[MDTC0]
       and MDCNFG[MDTC2] fields. The burst type and length are always 
       programmed to sequential and four, respectively. For more information, 
       see Section 6.4.2.5.
    **/
    MDMRS = 0;
    
    /**
       11. In systems that contain SDRAM or synchronous flash, optionally 
       enable auto-power-down by setting MDREFR[APD].
    **/
    MDREFR |= MDREFR_APD;
  }
  
}

