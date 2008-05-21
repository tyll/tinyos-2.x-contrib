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

#include "mc13192Const.h"

module mc13192ControlM {
	provides {
		interface mc13192Control as RadioControl;
		interface mc13192PowerManagement as PowerMng;
		interface SplitControl;
	}
	uses {
		interface mc13192ControlInterrupt as Interrupt;
		interface mc13192Regs as Regs;
		interface mc13192State as State;
		interface mc13192Timer as Timer2;
		interface mc13192TimerCounter as Time;
		interface mc13192Interrupt as HwInterrupt;
		interface mc13192Pins as Pins;
	}
}
implementation
{

	// Globals
	bool timedDoze = FALSE;
	bool clockLost = FALSE;
	bool started = FALSE;
	
	// Forward declarations
	void disableSleepModes();
	void setupExternalClock();
	task void dozeDoneTask();
	task void wakeUpTask();
	task void resetIndicationTask();



	command error_t SplitControl.start()
	{
		call HwInterrupt.enable(); 
		// Take MC13192 out of reset
		call Pins.setReset(); 
		return SUCCESS;
	}
	
	task void startDoneTask()
	{
		signal SplitControl.startDone(SUCCESS);
	}
	
	void setup()
	{
		call Regs.write(0x11,0xA0FF);
		
		call Regs.write(GPIO_DIR, 0x3F80);
		call Regs.write(CCA_THRESH,0x9674); // WAS: 0xA08D
		// Register 0x08 is hidden. bit 1 and 4 should be initialized to 1.
		// Preferred injection
		call Regs.write(0x08,0xFFF7);
			
		 // ATTN masks, LO1
		call Regs.write(IRQ_MASK,0x8240);
		//call Regs.write(IRQ_MASK,0xFFFF);
		// Register 0x06 has some hidden bits. bit 14 should be initialized to 1.
		call Regs.write(CONTROL_A,0x4010);
 
	 	// Secret register settings snatched from Freescale implementation
 		call Regs.write(0x13, 0x1843);
 		call Regs.write(0x31, 0xA000);
	 	call Regs.write(0x38, 0x0008);
 			
 		// These should fix excess power consumption during hibernate and doze.
		call Regs.write(CONTROL_B, 0x7D00); // Was: 0x7D1C (xx00)
 		call Regs.write(CONTROL_C, 0xF3FA); // Was: 0xF3FA (xxxD)
 	
 		call Regs.write(CLKO_CTL, 0x3645); // Use Freescale xtal trim value.
 	
 		// Sets the reset indicator bit
		call Regs.read(RST_IND);
		// Read the status register to clear any undesired IRQs.
		call Regs.read(IRQ_STATUS);
		started = TRUE;
		post startDoneTask();
	}
	
	task void stopDoneTask()
	{
		signal SplitControl.stopDone(SUCCESS);
	}
	
	command error_t SplitControl.stop()
	{
		// Power off the radio.
		call Pins.clrReset();
		started = FALSE;
		post stopDoneTask();
		return SUCCESS;
	}

	command error_t PowerMng.hibernate()
	{
		uint16_t hibernateCtl, irqMask;

		irqMask = call Regs.read(IRQ_MASK);
		irqMask |= 0x8000; // Enable ATTN IRQ.
		call Regs.write(IRQ_MASK, irqMask);

		hibernateCtl = call Regs.read(CONTROL_B);
		hibernateCtl &= 0xFFFC;
		hibernateCtl |= 0x0002; // Hibernate enable
		call Regs.write(CONTROL_B, hibernateCtl);
		return SUCCESS;
	}

	command error_t PowerMng.doze(uint32_t timeout, bool clkOutEnabled)
	{
		uint16_t irqMask;
		uint16_t dozeCtl;

		irqMask = call Regs.read(IRQ_MASK);
		irqMask &= 0xFEEF; // Clear doze and acoma bits.
		irqMask |= 0x8000; // Enable ATTN IRQ.
		dozeCtl = call Regs.read(CONTROL_B);
		dozeCtl &= 0xFDFC; // Clear clko_doze_en, hib_en and doze_en bits.
		
		// Enable clock if required.
		if (clkOutEnabled) {
			dozeCtl |= 0x0201;
		} else {
			dozeCtl |= 0x0001;
		}

		if (timeout == 0) {
			// ACOMA mode
			call Timer2.stop();
			irqMask |= 0x0100;   // acoma enabled, doze irq disabled.
		} else {
			// DOZE mode with timeout
			uint32_t currentTime;
			timedDoze = TRUE;
			
			// Program Timer 2.
			currentTime = call Time.getTimerCounter();
			timeout += currentTime;
			call Timer2.start(timeout);
			
			irqMask |= 0x0010; // acoma disabled, doze irq enabled.
		}
		
		call Regs.write(IRQ_MASK, irqMask);
		call Regs.write(CONTROL_B, dozeCtl);
		return SUCCESS;
	}
	
	default event void PowerMng.dozeDone() {}

	command error_t PowerMng.wake()
	{
		//ASSERT_ATTN; // Wake up the radio
		call Pins.clrATTN(); 
		asm("NOP"); // Wait a bus cycle.
		//DEASSERT_ATTN;
		call Pins.setATTN(); 
		return SUCCESS;
	}

	default event void PowerMng.wakeDone() {}

	command error_t RadioControl.setChannel(uint8_t channel)
	{
		if (channel <= 0x0F) {
			uint16_t num = ((channel + 1)*5 & 0x000F)<<12;
			uint16_t div = 0x0F95;
			while (channel >= 3) {
				div++;
				channel -= 3;
			}

			call Regs.write(LO1_INT_DIV,div);
			call Regs.write(LO1_NUM,num);
			return SUCCESS;
		}
		return FAIL;
	}

	command error_t RadioControl.setClockRate(uint8_t freq)
	{
		uint16_t clockCtl;

		clockCtl = call Regs.read(CLKO_CTL); // Read register and re-write
		clockCtl &= 0xFFF8;
		clockCtl |= (freq & 0x07); // only 3 bits.
		call Regs.write(CLKO_CTL, clockCtl);
		return SUCCESS;
	}

	command error_t RadioControl.setTimerPrescale(uint8_t freq)
	{
		uint16_t timerCtl;

		timerCtl = call Regs.read(CONTROL_C);
		timerCtl &= 0xFFF8;
		timerCtl |= (freq & 0x07); // Only a 3-bit value.
		call Regs.write(CONTROL_C, timerCtl);
		return SUCCESS;
	}

	command error_t RadioControl.softReset()
	{
		call Regs.write(RESET, 0x00);
		return SUCCESS;
	}

	command error_t RadioControl.adjustXtal(uint8_t trimValue)
	{
		uint16_t reg;
		
		reg = (trimValue << 8);
		// Read the current value of XTAL Reg.
		reg |= (call Regs.read(CLKO_CTL) & 0x00FF);
		call Regs.write(CLKO_CTL, reg);
		return SUCCESS;
	}

	command error_t RadioControl.adjustPowerComp(uint8_t compensation)
	{
		uint16_t reg;
		
		// Read the current value of GAIN Reg.
		reg = call Regs.read(CCA_THRESH);
		reg = ((reg & 0xFF00) | compensation);
		call Regs.write(CCA_THRESH, reg);
		return SUCCESS;
	}

	command error_t RadioControl.adjustPAOutput(uint8_t paValue)
	{
		uint16_t paCtl;

		// Read the current value of GAIN Register
		paCtl = call Regs.read(PA_LVL);
		paCtl &= 0xFF00;
    
		if (paValue > 15) {
			// Boost up the PA.
			paCtl |= 0xFF;
		} else {
			paCtl |= ((paValue << 4) | 0x000C);
		}
		call Regs.write(PA_LVL, paCtl);
		return SUCCESS;
	}

	command uint8_t RadioControl.getChipVersion()
	{
		uint16_t reg;
		reg = call Regs.read(CHIP_ID);
		// Version info in bit 10-12.
		reg &= VERSION_MASK;
		reg = reg >> 10;
		return (uint8_t) reg;
	}
	
	command uint8_t RadioControl.getChipMaskSetId()
	{
		uint16_t reg;
		reg = call Regs.read(CHIP_ID);
		// Mask set id info in bit 13-15.
		reg &= MASK_SET_ID_MASK;
		reg = reg >> 13;
		return (uint8_t) reg;
	}
	
	command uint8_t RadioControl.getChipManufacturerId()
	{
		uint16_t reg;
		reg = call Regs.read(CHIP_ID);
		// Version info in bit 7-9.
		reg &= MANUFACTURER_ID_MASK;
		reg = reg >> 7;
		return (uint8_t) reg;
	}

	command uint32_t RadioControl.getRXTimestamp()
	{
		uint32_t upperWord, lowerWord;
		uint32_t timestamp;
    
		atomic {
			upperWord = call Regs.read(TIMESTAMP_A);
			lowerWord = call Regs.read(TIMESTAMP_B);
			upperWord &= TIMESTAMP_HI_MASK;
			timestamp = (uint32_t) (upperWord << 16) | lowerWord;
		}
		return timestamp;
	}

	default event error_t RadioControl.resetIndication()
	{
		return SUCCESS;
	}

	// Control-related radio interrupts
	async event void Interrupt.resetIndication()
	{
		if(!started)
		  setup();
		
		post resetIndicationTask();
	}
	
	async event void Interrupt.wakeUpIndication()
	{
		bool wasTimedDoze = FALSE;
		atomic {
			wasTimedDoze = timedDoze;
			timedDoze = FALSE;
		}
		if (wasTimedDoze) {
			// Disable Timer2 to avoid a T2 irq because of doze w/timeout.
			call Timer2.stop();
		}
		disableSleepModes();
		post wakeUpTask();
	}

	async event void Interrupt.dozeIndication()
	{
		bool wasTimedDoze = FALSE;
		atomic {
			wasTimedDoze = timedDoze;
			timedDoze = FALSE;
		}
		if (wasTimedDoze) {
			// Disable Timer2 to avoid a T2 irq because of doze w/timeout.
			call Timer2.stop();
		}
		// Disable hibernate and doze mode.
		disableSleepModes();
		post dozeDoneTask();
	}
	
	async event error_t Timer2.fired() {
		return SUCCESS;
	}

	// Below here are all tasks.

	task void resetIndicationTask()
	{
		//call State.setRXTXState(INIT_MODE);
		signal RadioControl.resetIndication();
	}

	task void wakeUpTask()
	{
		if (clockLost) {
			setupExternalClock();
			clockLost = FALSE;
		}
		call State.setRXTXStateMirror(IDLE_MODE);
		signal PowerMng.wakeDone();
	}
	
	task void dozeDoneTask()
	{
		if (clockLost) {
			setupExternalClock();
			clockLost = FALSE;
		}
		signal PowerMng.dozeDone();
	}

	// Below here are only helper functions
	
	void disableSleepModes()
	{
		uint16_t tmp;
		tmp = call Regs.read(CONTROL_B); // Read MC13192 Hibernate/Doze register.
		tmp &= 0xFFFC; // Hiberate and Doze disabled
		call Regs.write(CONTROL_B, tmp);	
	}
	
	void setupExternalClock()
	{
		//call RadioControl.setClockRate(0x00); // 16 MHz
		//enterFBEMode(1); // No FLL External Clock / 1 = 16 MHz MCUclk / 8 MHz BUSclk.
		// The low external clock frequency enables us to doze without losing clock and being
		// forced to handle loss-of-clock IRQ.
		call RadioControl.setClockRate(0x05); // 62.5 KHz
		extClock = 62500;
		enterFEEMode(0,8,1); // FLL engaged, 32 MHz MCUclk / 16 MHz BUSclk.
		
//		call RadioControl.setClockRate(0x00); // 62.5 KHz
//		extClock = 16000000;
//		enterFBEMode(1);
	}

	// Loss of clock interrupt handler.
	TOSH_SIGNAL(ICG) {
		ICGS1 |= 0x01; /* Clear lost clock interrupt */
		clockLost = TRUE;
	}
	
	async event void HwInterrupt.fired() {}
}
