/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b_pdca.h"

generic module PeripheralDmaControllerP(uint8_t PID)
{
  provides interface PeripheralDmaController[uint8_t id];
  uses interface InterruptController;
}
implementation
{
  async command void PeripheralDmaController.registerInterruptHandler[uint8_t id](void * callback)
  {
    call InterruptController.registerPdcaInterruptHandler(id, callback);
  }

  async command uint32_t PeripheralDmaController.getTransferCounter[uint8_t id]() {
    return get_register(get_avr32_pdca_baseaddress(id) + AVR32_PDCA_TCR0);
  }

  async command void PeripheralDmaController.startupTransaction[uint8_t id](void * buf, uint16_t len, bool enable_int)
  {
    // start PDCA clock
    get_register(AVR32_PM_ADDRESS + AVR32_PM_HSBMASK) |= (1 << AVR32_HSBMASK_PDCA_OFFSET);
    get_register(AVR32_PM_ADDRESS + AVR32_PM_PBAMASK) |= (1 << AVR32_PBAMASK_PDCA_OFFSET);

    // configure PDCA/DMA
    get_register(get_avr32_pdca_baseaddress(id) + AVR32_PDCA_MAR0) = (uint32_t) buf;
    get_register(get_avr32_pdca_baseaddress(id) + AVR32_PDCA_PSR0) = PID;
    get_register(get_avr32_pdca_baseaddress(id) + AVR32_PDCA_TCR0) = len;
    get_register(get_avr32_pdca_baseaddress(id) + AVR32_PDCA_MR0) = AVR32_PDCA_MR0_SIZE_BYTE;

    if (enable_int)
    {
      // enable PDCA/DMA interrupt
      get_register(get_avr32_pdca_baseaddress(id) + AVR32_PDCA_IER0) = ((1 << AVR32_PDCA_IER0_TERR_OFFSET) |
                                                                        (1 << AVR32_PDCA_IER0_TRC_OFFSET) |
                                                                        (0 << AVR32_PDCA_IER0_RCZ_OFFSET));
    }

    // start PDCA/DMA transfer
    get_register(get_avr32_pdca_baseaddress(id) + AVR32_PDCA_CR0) = ((1 << AVR32_PDCA_CR0_ECLR_OFFSET) | 
                                                                     (1 << AVR32_PDCA_CR0_TEN_OFFSET));
  }

  async command error_t PeripheralDmaController.shutdownTransaction[uint8_t id]()
  {
    error_t status;

    if (get_register(get_avr32_pdca_baseaddress(id) + AVR32_PDCA_ISR0) & AVR32_PDCA_ISR0_TERR_MASK)
    {
      status = FAIL;
    }
    else
    {
      status = SUCCESS;
    }

    // stop PDCA/DMA transfer
    get_register(get_avr32_pdca_baseaddress(id) + AVR32_PDCA_CR0) = (1 << AVR32_PDCA_CR0_TDIS_OFFSET);

    // disable PDCA/DMA interrupt
    get_register(get_avr32_pdca_baseaddress(id) + AVR32_PDCA_IDR0) = ((1 << AVR32_PDCA_IDR0_TERR_OFFSET) |
                                                                      (1 << AVR32_PDCA_IDR0_TRC_OFFSET) |
                                                                      (1 << AVR32_PDCA_IDR0_RCZ_OFFSET));

    // TODO: check if PDCA is unused resp. no other PDCA channel is active
    // stop PDCA clock
    get_register(AVR32_PM_ADDRESS + AVR32_PM_HSBMASK) &= ~(1 << AVR32_HSBMASK_PDCA_OFFSET);
    get_register(AVR32_PM_ADDRESS + AVR32_PM_PBAMASK) &= ~(1 << AVR32_PBAMASK_PDCA_OFFSET);

    return status;
  }
}
