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

module mc13192TimerM
{
	provides {
		interface mc13192Timer as Timer[uint8_t timer];
		interface mc13192EventTimer as EventTimer;
		interface StdControl;
	}
	uses {
		interface mc13192TimerInterrupt as Interrupt;
		interface mc13192Regs as Regs;
	}
}
implementation
{

	// Global variables.
	bool timerFree[NUMTIMERS];
	bool eventTimerSet = FALSE;
	
	// Forward declarations
	error_t getTimerAddr(uint8_t timer, uint8_t *hiAddr, uint8_t *loAddr);
	error_t enableTimerIRQ(uint8_t timer);
	error_t disableTimerIRQ(uint8_t timer);

	/*command error_t StdControl.init()
	{
		return SUCCESS;
	}*/

	command error_t StdControl.start()
	{
		uint8_t i;
		for (i=0;i<NUMTIMERS;i++) {
			call Timer.stop[i]();
		}
		return SUCCESS;
	}

	command error_t StdControl.stop()
	{
		// Stop all timers.
		uint8_t i;
		for (i=0;i<NUMTIMERS;i++) {
			call Timer.stop[i]();
		}	
		return SUCCESS;
	}

	/******************************/
	/* Event triggering functions */
	/******************************/

	command bool EventTimer.isSet()
	{
		return eventTimerSet;
	}
	
	command void EventTimer.clear()
	{
		if (eventTimerSet) {
			disableTimerIRQ(TIMER2);
			timerFree[TIMER2] = TRUE;
			eventTimerSet = FALSE;
		}
	}

	command error_t EventTimer.programEventTimer(uint32_t commenceTime, uint8_t mode)
	{
		uint16_t reg;
		bool wasFree;
		// Reserve timer2
		atomic {
			wasFree = timerFree[TIMER2];
			timerFree[TIMER2] = FALSE;
		}
		if (!wasFree) {
			// Fail if timer2 is already in use.
			//DBG_STR("Timer2 was already reserved",2);
			return FAIL;
		}

		// Enable timer event trigger.
		enableTimerIRQ(TIMER2);
		eventTimerSet = TRUE;

		// Assume packet mode.
		// Write timeout to tmr_cmp2
		reg = call Regs.read(TMR_CMP2_A);
		call Regs.write(TMR_CMP2_A, (reg & 0x7F00) | ((uint16_t)(commenceTime >> 16) & 0x00FF));
		call Regs.write(TMR_CMP2_B, (uint16_t)commenceTime);
	
		return SUCCESS;
	}

	async command error_t Timer.start[uint8_t timer](uint32_t interval)
	{
		uint8_t hiAddr;
		uint8_t loAddr;
		if (timer < NUMTIMERS) {
			atomic timerFree[timer] = FALSE;
			getTimerAddr(timer, &hiAddr, &loAddr);
			// Turn Timer1 mask on
			call Regs.write(hiAddr, ((uint16_t)(interval >> 16) & 0x00FF));
			call Regs.write(loAddr, (uint16_t)interval);
			// enable timer interrupt.
			enableTimerIRQ(timer);
			return SUCCESS;
		}
		return FAIL;
	}

	async command error_t Timer.stop[uint8_t timer]()
	{
		uint8_t hiAddr = 0;
		uint8_t loAddr = 0;
		if (timer < NUMTIMERS) {
			atomic timerFree[timer] = TRUE;
			// disable timer interrupt.
			disableTimerIRQ(timer);
			getTimerAddr(timer, &hiAddr, &loAddr);
			call Regs.write(hiAddr, 0x8000);
			//call Regs.write(loAddr, 0x0000);
			
			return SUCCESS;
		}
		return FAIL;
	}

	command error_t Timer.available[uint8_t timer]()
	{
		bool free;
		if (timer < NUMTIMERS) {
			atomic free = timerFree[timer];
			if (free) {
				return SUCCESS;
			}
		}
		return FAIL;
	}
	
	command error_t Timer.reserve[uint8_t timer]()
	{
		bool free;
		if (timer < NUMTIMERS) {
			atomic
			{
				free = timerFree[timer];
				timerFree[timer] = FALSE;
			}
			if (free) {
				// enable timer interrupt.
				enableTimerIRQ(timer);
				return SUCCESS;
			}
		}
		return FAIL;
	}

	command void Timer.release[uint8_t timer]()
	{
		if (timer < NUMTIMERS) {
			atomic timerFree[timer] = TRUE;
			disableTimerIRQ(timer);
		}
	}
	
	default async event error_t Timer.fired[uint8_t timer]()
	{
		return SUCCESS;
	}
	
	async event error_t Interrupt.timerFired(uint8_t timer)
	{
		if (timer < NUMTIMERS) {
			if (timer == TIMER2 && eventTimerSet) {
				// Operation about to commence.
				// We don't need our timer any more.
				disableTimerIRQ(TIMER2);
				timerFree[TIMER2] = TRUE;
			} else {
				call Timer.stop[timer]();
				signal Timer.fired[timer]();
			}
			return SUCCESS;
		}
		return FAIL;
	}
	
	error_t getTimerAddr(uint8_t timer, uint8_t *hiAddr, uint8_t *loAddr)
	{
		switch(timer) {
			case TIMER1:
				*hiAddr = TMR_CMP1_A;
				*loAddr = TMR_CMP1_B;
				break;
			case TIMER2:
				*hiAddr = TMR_CMP2_A;
				*loAddr = TMR_CMP2_B;
				break;
			case TIMER3:
				*hiAddr = TMR_CMP3_A;
				*loAddr = TMR_CMP3_B;
				break;
			case TIMER4:
				*hiAddr = TMR_CMP4_A;
				*loAddr = TMR_CMP4_B;
				break;
			default:
				return FAIL;
		}
		return SUCCESS;
	}
	
	error_t enableTimerIRQ(uint8_t timer)
	{
		uint16_t mask;
		mask = call Regs.read(IRQ_MASK);
		switch(timer) {
			case TIMER1:
				mask |= TIMER1_IRQMASK_BIT;
				break;
			case TIMER2:
				mask |= TIMER2_IRQMASK_BIT;
				break;
			case TIMER3:
				mask |= TIMER3_IRQMASK_BIT;
				break;
			case TIMER4:
				mask |= TIMER4_IRQMASK_BIT;
				break;
			default:
				return FAIL;
		}
		call Regs.write(IRQ_MASK, mask);
		return SUCCESS;
	}
	
	error_t disableTimerIRQ(uint8_t timer)
	{
		uint16_t mask;
		mask = call Regs.read(IRQ_MASK);
		switch(timer) {
			case TIMER1:
				mask &= (0xFFFF & ~(TIMER1_IRQMASK_BIT));
				break;
			case TIMER2:
				mask &= (0xFFFF & ~(TIMER2_IRQMASK_BIT));
				break;
			case TIMER3:
				mask &= (0xFFFF & ~(TIMER3_IRQMASK_BIT));
				break;
			case TIMER4:
				mask &= (0xFFFF & ~(TIMER4_IRQMASK_BIT));
				break;
			default:
				return FAIL;
		}
		call Regs.write(IRQ_MASK, mask);
		return SUCCESS;	
	}
}
