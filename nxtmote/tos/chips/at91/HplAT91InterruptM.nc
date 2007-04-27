/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
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

  void irqhandler() __attribute__ ((interrupt ("IRQ"))) @C() @atomic_hwevent() {

    uint32_t irqID;

    irqID = AT91F_AIC_ActiveID(AT91C_BASE_AIC); // Current interrupt source number
    
    signal AT91Irq.fired[irqID]();   // Handler is responsible for clearing interrupt

    return;
  }

  void fiqhandler() __attribute__ ((interrupt ("FIQ"))) @C() @atomic_hwevent() {
    return;
  }


  error_t allocate(uint8_t id, bool level, uint8_t priority)
  {

    AT91F_AIC_ConfigureIt ( AT91C_BASE_AIC, id, priority, AT91C_AIC_SRCTYPE_INT_HIGH_LEVEL, irqhandler);

    return TRUE;
  }

  void enable(uint8_t id)
  {
    atomic {
      if (id < 34) {
        AT91C_BASE_TC0->TC_IER = AT91C_TC_CPCS;        
        AT91F_AIC_EnableIt(AT91C_BASE_AIC, id);
      }
    }
    return;
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
    return allocate(id, FALSE, TOSH_IRP_TABLE[id]);
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
