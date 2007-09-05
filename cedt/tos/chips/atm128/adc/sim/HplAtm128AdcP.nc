/// $Id$
/* * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved. * * Permission to use, copy, modify, and distribute this software and its * documentation for any purpose, without fee, and without written agreement is * hereby granted, provided that the above copyright notice, the following * two paragraphs and the author appear in all copies of this software. *  * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO  * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL  * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH  * DAMAGE.  * * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES, * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY  * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS  * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY  * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR  * MODIFICATIONS. */#include "Atm128Adc.h"/** * HPL for the Atmega128 A/D conversion susbsystem. * * @author Martin Turon <mturon@xbow.com> * @author Hu Siquan <husq@xbow.com> * @author David Gay */
/**
 * "Copyright (c) 2007 CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc.
 *  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc BE LIABLE TO
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc HAS BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * CENTRE FOR ELECTRONICS AND DESIGN TECHNOLOGY,IISc SPECIFICALLY DISCLAIMS
 * ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND CENTRE FOR ELECTRONICS
 * AND DESIGN TECHNOLOGY,IISc HAS NO OBLIGATION TO PROVIDE MAINTENANCE,
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

 /**
  * Added ADC functionality for simulation.
  * Currently for MICA2, at ADC0, it returns the RSSI values
  * For other ADC PINs and other platforms, it returns a random number masked to 0x3FF
  *
  * @author Venkatesh S
  * @author Prabhakar T V
  */

module HplAtm128AdcP {  provides interface HplAtm128Adc;  uses interface McuPowerState;}
implementation {  /*variables required for the simulation*/    sim_event_t *adcRead;  void schedule_adc_read();  void readDone();    /*end of simulation variable declaration*/    //=== Direct read of HW registers. =================================
  async command Atm128Admux_t HplAtm128Adc.getAdmux() {     return *(Atm128Admux_t*)&ADMUX;   }
  async command Atm128Adcsra_t HplAtm128Adc.getAdcsra() {     return *(Atm128Adcsra_t*)&ADCSRA;   }
  async command uint16_t HplAtm128Adc.getValue() {     return ADC;   }
  DEFINE_UNION_CAST(Admux2int, Atm128Admux_t, uint8_t);  DEFINE_UNION_CAST(Adcsra2int, Atm128Adcsra_t, uint8_t);
  //=== Direct write of HW registers. ================================
  async command void HplAtm128Adc.setAdmux( Atm128Admux_t x ) {     ADMUX = Admux2int(x);   }
  async command void HplAtm128Adc.setAdcsra( Atm128Adcsra_t x ) {     ADCSRA = Adcsra2int(x); 
    call McuPowerState.update();
    schedule_adc_read();
  }
  async command void HplAtm128Adc.setPrescaler(uint8_t scale){    Atm128Adcsra_t  current_val = call HplAtm128Adc.getAdcsra();     current_val.adif = FALSE;    current_val.adps = scale;    call HplAtm128Adc.setAdcsra(current_val);  }
  // Individual bit manipulation. These all clear any pending A/D interrupt.  // It's not clear these are that useful...
  async command void HplAtm128Adc.enableAdc() {    SET_BIT(ADCSRA, ADEN);    call McuPowerState.update(); 
    dbg("Hpl128AdcP","scheduling ADC read at %s\n",sim_time_string());    schedule_adc_read();  }
  async command void HplAtm128Adc.disableAdc() {    CLR_BIT(ADCSRA, ADEN);     call McuPowerState.update();  }
  async command void HplAtm128Adc.enableInterruption() { SET_BIT(ADCSRA, ADIE); }  async command void HplAtm128Adc.disableInterruption() { CLR_BIT(ADCSRA, ADIE); }  async command void HplAtm128Adc.setContinuous() { SET_BIT(ADCSRA, ADFR); }  async command void HplAtm128Adc.setSingle() { CLR_BIT(ADCSRA, ADFR); }  async command void HplAtm128Adc.resetInterrupt() { SET_BIT(ADCSRA, ADIF); }  async command void HplAtm128Adc.startConversion() { SET_BIT(ADCSRA, ADSC); }
  /* A/D status checks */
  async command bool HplAtm128Adc.isEnabled()     {           return (call HplAtm128Adc.getAdcsra()).aden;   }
  async command bool HplAtm128Adc.isStarted()     {    return (call HplAtm128Adc.getAdcsra()).adsc;   }
  async command bool HplAtm128Adc.isComplete()    {    return (call HplAtm128Adc.getAdcsra()).adif;   }
  /* A/D interrupt handlers. Signals dataReady event with interrupts enabled */
  AVR_ATOMIC_HANDLER(SIG_ADC) {    uint16_t data = call HplAtm128Adc.getValue();    readDone();    __nesc_enable_interrupt();    signal HplAtm128Adc.dataReady(data);  }

  default async event void HplAtm128Adc.dataReady(uint16_t done) { }  async command bool HplAtm128Adc.cancel() {     /* This is tricky */    atomic      {	Atm128Adcsra_t oldSr = call HplAtm128Adc.getAdcsra(), newSr;	/* To cancel a conversion, first turn off ADEN, then turn off	   ADSC. We also cancel any pending interrupt.	   Finally we reenable the ADC.	*/	newSr = oldSr;	newSr.aden = FALSE;	newSr.adif = TRUE; /* This clears a pending interrupt... */	newSr.adie = FALSE; /* We don't want to start sampling again at the			       next sleep */	call HplAtm128Adc.setAdcsra(newSr);	newSr.adsc = FALSE;	call HplAtm128Adc.setAdcsra(newSr);	newSr.aden = TRUE;	call HplAtm128Adc.setAdcsra(newSr);	return oldSr.adif || oldSr.adsc;      }  }    /*Functions required for creating the events of ADC and data handling*/    void adc_read_data_handle(sim_event_t* evt) {    int8_t noiseRSSIdBm;    float Vrssi;    int8_t sigdBm;    double sig;    gain_entry_t* neighborEntry = sim_gain_first(sim_node());    if(evt->cancelled) {
      dbg("HplAtm128AdcP","AdcReadDatahandle event cancelled before signalling\n");      return;    }    else {      //FOR SINGLE ENDED input channels only
      switch(ADMUX & 7) {        case 0: 
	#ifdef PLATFORM_MICA2
		/*		 *  ADC 0 is binded to the radio RSSI pin for mica2		 *  So, return a random value which is uniformly distributed over the time, 		 *  The value taken will be in dBm, convert into appropriate digital value		 *  then signal that value!!
		 *  Heard signal is equal to the signal strength of ambient noise   		 *  plus the signal strength of all transmissions. The pow() and  	         *  log() calls transform dBm into energy and back. 	         */			    		  noiseRSSIdBm = (int8_t)sim_noise_gen(TOS_NODE_ID);		  sig = pow(10.0,noiseRSSIdBm/10.0);		  //read the signal value of the other nodes 
		  while (neighborEntry != NULL) {		    int neighborNode = neighborEntry->mote;		    int currentNode = sim_node();		    int txMode;		    sim_set_node(neighborNode);		    txMode = CC1K_REG_ACCESS(CC1K_PA_POW);		    sim_set_node(currentNode);		    if(txMode!= 0)  {		      sig += pow(10.0,(CC1K_RADIO_PowerMode[txMode]+neighborEntry->gain)/10.0);
		    }		    neighborEntry = sim_gain_next(neighborEntry);		  }		  sigdBm = 10.0*log(sig)/log(10.0);		  //conversion from dBm to digital val, see CC1000 data sheet for details		  //This conversion is for 433 Mhz
		  Vrssi = (sigdBm + 49.2) / (float)(-51.3);		  ADC = (Vrssi*1024)/3;		  dbg("HplAtm128AdcP","Read Signal as %d dBb, Analog Voltage: %f, Digital value: %d \n",sigdBm,Vrssi,ADC);		  break;
	   #endif	case 1:	case 2:	case 3:	case 4: 	case 5:	case 6:	case 7: 	default: ADC = (sim_random() & 0x3FF);		break;      }
      /*Signal ADC DATA READY*/      SIG_ADC();    }  }
  sim_event_t *allocate_adc_read() {    sim_event_t* newEvent = sim_queue_allocate_event();    newEvent->time = sim_time();    newEvent->handle = adc_read_data_handle;    newEvent->cleanup = sim_queue_cleanup_none;    return newEvent;  }  void schedule_adc_read() {    sim_event_t *newEvent = allocate_adc_read();    adcRead = newEvent;    sim_queue_insert(newEvent);
  }    void readDone() {    adcRead->cleanup = sim_queue_cleanup_total;  }}
