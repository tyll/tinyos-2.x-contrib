/**
 * Adapted for nxtmote.
 * @author Rasmus Ulslev Pedersen
 */
#include "hardware.h"

module HplAT91OSTimerM {
  provides {
    interface Init;
    // chnl_id is 0-based but can be remapped to a timer channel
    // with TIMER_PID(chnl_id)
    interface HplAT91OSTimer as AT91OST[uint8_t chnl_id];
  }
  uses {
    interface HplAT91Interrupt as OST0Irq;
  }
}

implementation {

  bool gfInitialized = FALSE;

  void DispatchOSTInterrupt(uint8_t id)
  {
    signal AT91OST.fired[id]();
    return;
  }

  command error_t Init.init()
  {

    bool initflag;
    atomic {
      initflag = gfInitialized;
      gfInitialized = TRUE;
    }

    if(!initflag) {
      // Open timer0

//      AT91F_TC_Open(AT91C_BASE_TC0,TC_CLKS_MCK2|AT91C_TC_CPCTRG,AT91C_ID_TC0);
      
//      call OST0Irq.allocate();
//      call OST0Irq.enable();
    //__nesc_enable_interrupt();


    }
    
    return SUCCESS;
  }
  
  //TODO: (typedef frequency_tag)
  async command bool AT91OST.open[uint8_t chnl_id]() 
  {
    bool bFlag = FALSE;
    unsigned int dummy;
    
    //if(frequency_tag == TMilli)
    {
      //TODO: the rest of the channels
      switch(TIMER_PID(chnl_id)) {
        case AT91C_ID_TC0:
          // periphclock
__nesc_enable_interrupt();          
          AT91C_BASE_PMC->PMC_PCER = (1<<AT91C_ID_TC0);

          AT91C_BASE_TC0->TC_CCR = AT91C_TC_CLKDIS ;
          AT91C_BASE_TC0->TC_IDR = 0xFFFFFFFF ;

          //* Clear status bit
          dummy = AT91C_BASE_TC0->TC_SR;
          //* Suppress warning variable "dummy" was set but never used
          dummy = dummy;

          //* Set the Mode of the Timer Counter
          AT91C_BASE_TC0->TC_CMR = TC_CLKS_MCK2|AT91C_TC_CPCTRG ;

          //* Enable the clock
          AT91C_BASE_TC0->TC_CCR = AT91C_TC_CLKEN ;
          AT91C_BASE_TC0->TC_IER = AT91C_TC_CPCS;


          AT91C_BASE_AIC->AIC_IDCR = (1 << AT91C_ID_TC0);
          AT91C_BASE_AIC->AIC_SMR[AT91C_ID_TC0] = (AT91C_AIC_SRCTYPE_INT_LEVEL_SENSITIVE|0x4);

          AT91C_BASE_AIC->AIC_ICCR = (1 << AT91C_ID_TC0);
          AT91C_BASE_AIC->AIC_IECR = (1 << AT91C_ID_TC0);

//          AT91C_BASE_TC0->TC_RC = TICKSONEMSCLK2;

          AT91C_BASE_TC0->TC_CCR = AT91C_TC_SWTRG ;
/*
          while(1){
            uint16_t cv = AT91C_BASE_TC0->TC_CV;
            if(cv == (TICKSONEMSCLK2-1)){
            }
          }
*/          
			    bFlag = TRUE;
          break;
        default:
          break;
      }
    }
    return bFlag;    
  }

/*  
  async command void NXTARMOST.setTCRC[uint8_t chnl_id](uint32_t val) 
  {
    return;
  }
*/  
  async command uint32_t AT91OST.getTCCV[uint8_t chnl_id]()
  {
    uint32_t val;
    AT91PS_TC pTC;
    
    pTC = (AT91PS_TC)PID_ADR_TABLE[TIMER_PID(chnl_id)];
    
    val = pTC->TC_CV; 

    return val;
  }
  
  async command void AT91OST.setTCRC[uint8_t chnl_id](uint32_t val)
  {
    AT91PS_TC pTC;
    
    pTC = (AT91PS_TC)PID_ADR_TABLE[TIMER_PID(chnl_id)];
 
    pTC->TC_RC = val;   
    
    return;
  }
  
    async command uint32_t AT91OST.getTCRC[uint8_t chnl_id]()
    {
      uint32_t val;
      AT91PS_TC pTC;
      
      pTC = (AT91PS_TC)PID_ADR_TABLE[TIMER_PID(chnl_id)];
   
      val = pTC->TC_RC;
      
      return val;
  }
  
  // Can do CLKDIS, CLKEN, and SWTRG
  async command void AT91OST.setTCCCR[uint8_t chnl_id](uint32_t val)
  {
    //AT91C_BASE_TC0->TC_CCR = AT91C_TC_SWTRG ;
    AT91PS_TC pTC;
        
    pTC = (AT91PS_TC)PID_ADR_TABLE[TIMER_PID(chnl_id)];
       
    pTC->TC_CCR = val; 
    
    return;
  }

  async command void AT91OST.setTCIDR[uint8_t chnl_id](uint32_t val)
  {
    AT91PS_TC pTC;
    
    pTC = (AT91PS_TC)PID_ADR_TABLE[TIMER_PID(chnl_id)];
    
    pTC->TC_IDR = val; 

    return;
  }

  async command bool AT91OST.getTCSR[uint8_t chnl_id]() 
  {
    bool bFlag;
    AT91PS_TC pTC;
    
    pTC = (AT91PS_TC)PID_ADR_TABLE[TIMER_PID(chnl_id)];
    
    if(pTC->TC_SR & AT91C_TC_CPCS)
      bFlag = TRUE;
    else 
      bFlag = FALSE;

    return bFlag;
  }

  async command void AT91OST.setTCIER[uint8_t chnl_id](bool flag)
  {
    AT91PS_TC pTC;
    
    pTC = (AT91PS_TC)PID_ADR_TABLE[TIMER_PID(chnl_id)];
    
    if(flag) {
      pTC->TC_IER = AT91C_TC_CPCS;
    }
    else {
      pTC->TC_IDR = AT91C_TC_CPCS;
    }
    
    return;
  }

  async command void AT91OST.setIECR[uint8_t chnl_id]()
  {
    AT91C_BASE_AIC->AIC_IECR = TIMER_PID(chnl_id);
  }
  
  async command void AT91OST.setICCR[uint8_t chnl_id]()
  {
    AT91C_BASE_AIC->AIC_ICCR = TIMER_PID(chnl_id);
  }
    
  async command void AT91OST.setIDCR[uint8_t chnl_id]()
  {
    AT91C_BASE_AIC->AIC_IDCR = TIMER_PID(chnl_id);
  }

  async event void OST0Irq.fired() 
  {
    DispatchOSTInterrupt(0);
  }
  

  default async event void AT91OST.fired[uint8_t chnl_id]() 
  {
    //call AT91OST.setTCIER[chnl_id](FALSE);
    return;
  }

}
