/* Copyright (c) 2006, Jan Flora <janflora@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
  @author Jan Flora <janflora@diku.dk>
*/

module mc13192InterruptM {
	provides
	{
		interface mc13192DataInterrupt as Data;
		interface mc13192ControlInterrupt as Control;
		interface mc13192TimerInterrupt as Timer;
	}
	uses
	{
		interface mc13192Interrupt as Interrupt;
		interface mc13192Regs as Regs;
	}
}
implementation
{

	// Forward declarations.
	inline void handleAttnIRQ();

	// MC13192 interrupt handler.
	async event void Interrupt.fired() 
	{
		volatile uint16_t status_content; // Result of the status register read.

		call Interrupt.disable(); 
		
		status_content = call Regs.read(IRQ_STATUS);

		// Packet RX is done
		if (status_content & RX_IRQ_MASK) {
			signal Data.dataIndication(status_content & CRC_VALID_MASK);
			call Interrupt.enable(); 
			return;
		}

		// Packet TX done signal senddone.
		if (status_content & TX_IRQ_MASK) {
			signal Data.txDone();
			call Interrupt.enable(); 
			return;
		}

		if (!(status_content & 0xFFFC)) {
			call Interrupt.enable(); 
			return;
		}

		// TIMER1 IRQ Handler
		if (status_content & TIMER1_IRQ_MASK) 
		{
			signal Timer.timerFired(TIMER1);
		}

		// LO LOCK IRQ - Occurs when MC13192 loses channel frequency lock.
		// When this happens, all rx/tx traffic is aborted.
		if (status_content & LO_LOCK_IRQ_MASK)
		{
			signal Data.lockLost();
		}

		// DOZE Complete Interrupt
		if (status_content & DOZE_IRQ_MASK)
		{
			signal Control.dozeIndication();
		}
		
		// ATTN IRQ Handler
		if (status_content & ATTN_IRQ_MASK)
		{
			handleAttnIRQ();
		}
				
		// TIMER2 IRQ Handler
		if (status_content & TIMER2_IRQ_MASK) 
		{
			signal Timer.timerFired(TIMER2);
		}		
		
		// TIMER3 IRQ Handler
		if (status_content & TIMER3_IRQ_MASK) 
		{
			signal Timer.timerFired(TIMER3);
		}		

		// TIMER4 IRQ Handler
		if (status_content & TIMER4_IRQ_MASK)
		{
			signal Timer.timerFired(TIMER4);
		}
		
		// If CCA done signal
		if (status_content & CCA_IRQ_MASK) {
			signal Data.ccaDone(!(status_content & CCA_STATUS_MASK));
		}
		
		call Interrupt.enable(); 
	}
		
	inline void handleAttnIRQ()
	{
		uint16_t tmp;

		tmp = call Regs.read(RST_IND);
		
		tmp &= RESET_BIT_MASK;
		if (tmp == 0) {
			// If RST_IND is 0, a reset has occured.
			signal Control.resetIndication();
		} else {
			// This must be a wakeup request.
			signal Control.wakeUpIndication();
		}	
	}

	// Default events.
	default async event void Control.resetIndication() {}
	default async event void Control.wakeUpIndication() {}
	default async event void Control.dozeIndication() {}
}
