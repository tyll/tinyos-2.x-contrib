/**
 * Adapted for nxtmote.
 * @author Rasmus Ulslev Pedersen
 */
#include "hardware.h"
module HplAT91InterruptM
{
  provides {
    // The id is an actual peripheral like AT91C_ID_TC
    interface HplAT91Interrupt as AT91Irq[uint8_t id];
    interface HplAT91Interrupt as AT91Fiq[uint8_t id];
  }
  
}

implementation 
{

  // We save the registers in the assembler interrupt control code, so this
  // __attribute__ ((interrupt ("IRQ"))) @C() @atomic_hwevent() 
  // will work. Instead tell the compiler it is a "plain" C function.
  void irqhandler() __attribute__ ((C, spontaneous)) {
    uint32_t irqID;

    irqID = AT91F_AIC_ActiveID(AT91C_BASE_AIC); // Current interrupt source number

    signal AT91Irq.fired[irqID]();   
    
    return;
  }

  void fiqhandler() __attribute__ ((interrupt ("FIQ"))) @C() @atomic_hwevent() {
    return;
  }

  // Peripheral clock and AIC
  void enable(uint8_t id)
  {
    atomic {
      if (id < 34) {
        AT91C_BASE_TC0->TC_IER = AT91C_TC_CPCS;        
        AT91F_PMC_EnablePeriphClock(AT91C_BASE_PMC, id);
        // Enable interrupt on AIC
        AT91F_AIC_EnableIt(AT91C_BASE_AIC, id);
      //AT91F_AIC_EnableIt(AT91C_BASE_AIC, AT91C_ID_TC0);
      }
    }
    return;
  }

  error_t allocate(uint8_t id, bool level, uint8_t priority)
  {
    uint32_t srctype;
    if(level) {
      srctype = AT91C_AIC_SRCTYPE_INT_HIGH_LEVEL;
      //AT91F_AIC_ConfigureIt( AT91C_BASE_AIC, id, priority, AT91C_AIC_SRCTYPE_INT_HIGH_LEVEL, irqhandler);
    }
    else {
      srctype = AT91C_AIC_SRCTYPE_INT_EDGE_TRIGGERED;
      //AT91F_AIC_ConfigureIt( AT91C_BASE_AIC, id, priority, AT91C_AIC_SRCTYPE_INT_EDGE_TRIGGERED, irqhandler);
    }
    
    AT91F_AIC_ConfigureIt( AT91C_BASE_AIC, id, priority, srctype, irqhandler);
//AT91F_AIC_ConfigureIt( AT91C_BASE_AIC, AT91C_ID_SYS, AT91C_AIC_PRIOR_HIGHEST, AT91C_AIC_SRCTYPE_INT_HIGH_LEVEL, irqhandler);
    return TRUE;
  }

  void disable(uint8_t id)
  {
    atomic {
      if (id < 34) {
        AT91C_BASE_TC0->TC_IDR = AT91C_TC_CPCS;
        AT91F_AIC_DisableIt(AT91C_BASE_AIC, id);
      }
    }
    return;
  }

  async command error_t AT91Irq.allocate[uint8_t id]()
  {
    return allocate(id, TOSH_IRQLEVEL_TABLE[id], TOSH_IRP_TABLE[id]);
  }

  async command void AT91Irq.enable[uint8_t id]()
  {
    enable(id);
    return;
  }

  async command void AT91Irq.disable[uint8_t id]()
  {
    disable(id);
    return;
  }

  async command error_t AT91Fiq.allocate[uint8_t id]() 
  {
    return allocate(id, TRUE, TOSH_IRP_TABLE[id]);
  }

  async command void AT91Fiq.enable[uint8_t id]()
  {
    enable(id);
    return;
  }

  async command void AT91Fiq.disable[uint8_t id]()
  {
    disable(id);
    return;
  }

  default async event void AT91Irq.fired[uint8_t id]() 
  {
    return;
  }

  default async event void AT91Fiq.fired[uint8_t id]() 
  {
    return;
  }

}
