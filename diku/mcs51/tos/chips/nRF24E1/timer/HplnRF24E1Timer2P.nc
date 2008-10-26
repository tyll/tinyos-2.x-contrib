/* Not used */

#include <ionRF24E1.h>
#include <nRF24E1Timer.h>

module HplnRF24E1Timer2P {
  provides interface HplnRF24E1Timer16 as Timer2;
  provides interface Init;

} implementation {
  uint8_t mscale, nextScale;
  uint16_t minterval;
  
  command error_t Init.init() {
    P0_DIR = 0;
    P0_ALT = 0;

    return SUCCESS;
  }

  async command uint16_t Timer2.get() {

    uint16_t r;
    ((uint8_t*)&r)[0] = TH2;
    ((uint8_t*)&r)[1] = TL2;
    return r;
  };
  async command void  Timer2.set( uint16_t t ){
    //T1CNT = UINT16_TO_SFR16( t );
    
    TH2 = ((uint8_t*)&t)[0]; //(uint8_t) t;
    TL2 = ((uint8_t*)&t)[1]; //(uint8_t) (t>>8);
  };

  async command void Timer2.setMode( enum nRF24E1_timer2_mode_t mode ){
    call Timer2.setScale(4);
    T2CON = (T2CON & ~nRF24E1_T2CON_MODE_MASK) | mode;
    TF2 = 0; //Clear flag by software
  };
  async command enum nRF24E1_timer2_mode_t Timer2.getMode(){
    return (T2CON & nRF24E1_T2CON_MODE_MASK);
  };

// Sets the interrupt mask
  async command void Timer2.enableEvents(){
    EA = 1;  //is this nessecary??   
    ET2 = 1;
  };
  async command void Timer2.disableEvents(){
    ET2 = 0;
  };

  async command void Timer2.enableOverflow(){
    //TIMIF |=  _BV(CC2430_TIMIF_OVFIM);
  };
  async command void Timer2.disableOverflow() {
    //TIMIF &=  ~CC2430_TIMIF_OVFIM;
  };
/*
  async command bool Timer1.isIfPending(enum cc2430_timer1_if_t if_mask){
    return ( T1CTL & if_mask);
  };
  async command void Timer1.clearIf(enum cc2430_timer1_if_t if_mask){
    T1CTL &= ~if_mask;
  };
/**/
  async command void Timer2.setScale( enum nRF24E1_timer2_prescaler_t scale){
    //T1CTL = ((T1CTL & ~CC2430_T1CTL_DIV_MASK) | p);
    ET2 = 0;
    CKCON = ((CKCON & ~nRF24E1_T2M_CKCON_MASK) | scale);
    ET2 = 1;
  }


  async command enum nRF24E1_timer2_prescaler_t Timer2.getScale(){
    return ( (enum nRF24E1_timer2_prescaler_t) CKCON & nRF24E1_T2M_CKCON_MASK);
  };

  MCS51_INTERRUPT(SIG_TIMER2) {
    TF2 = 0;
    signal Timer2.fired();
  }
}
