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

module mc13192TimerCounterM
{
	provides
	{
		interface mc13192TimerCounter as Time;
	}
	uses
	{
		interface mc13192Regs as Regs;
	}
}
implementation
{
	
	command uint32_t Time.getTimerCounter()
	{
		uint32_t upperWord, lowerWord;
    
		atomic {
			upperWord = call Regs.read(CURRENT_TIME_A);
			lowerWord = call Regs.read(CURRENT_TIME_B);
		}
		upperWord &= TIMESTAMP_HI_MASK;
		return (uint32_t) (upperWord << 16) | lowerWord;
	}
	
	command error_t Time.setTimerCounter(uint32_t time)
	{
		uint16_t upperWord, lowerWord;
    
		// Split 32 bit input into 2 16 bit values
		upperWord = ((uint16_t)(time >> 16) & 0x00FF);
		lowerWord = (uint16_t)time;
		// Program Time1 comparator with time.
		call Regs.write(TMR_CMP1_A, upperWord);
		call Regs.write(TMR_CMP1_B, lowerWord);
		
		return call Time.resetTimerCounter();
	}
	
	// This command assumes that Timer1 is stopped using the
	// timer interface.
	command error_t Time.resetTimerCounter()
	{
		uint16_t timerCtl;
		
		timerCtl = call Regs.read(CONTROL_B);
		call Regs.write(CONTROL_B, timerCtl|0x8000);
		call Regs.write(CONTROL_B, timerCtl);
		return SUCCESS;
	}
}
