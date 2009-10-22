/*
 * Copyright (c) 2009 Aarhus University
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of Aarhus University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL AARHUS
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   Marts 29 2009
 */

generic module RandomOffsetTimerMilliP() {

	provides {
		interface Timer<TMilli> as Timer;
	}

	uses {
		interface Timer<TMilli> as SubTimer;
		interface Random;
	}

} implementation {

	bool periodic;
	uint32_t interval;
	uint32_t t; 
	bool tHasPassed;
	
	void start(uint32_t t0) {
		t = interval;
		t /= 2;
		t += (call Random.rand32() % t);
		tHasPassed = FALSE;
		call SubTimer.stop();
		call SubTimer.startOneShotAt(t0, t);
	}

	void remainingInterval() {
		uint32_t remaining = interval;
		remaining -= t;
		tHasPassed = TRUE;
		call SubTimer.startOneShot(remaining);
	}

	event void SubTimer.fired() {
		if(!tHasPassed) {
			remainingInterval();
			signal Timer.fired();
		} else {
			if(periodic) {
				start(call SubTimer.getNow());
			}
		}
	}

	command void Timer.startPeriodic(uint32_t dt) {
		call Timer.startPeriodicAt(call SubTimer.getNow(), dt);
	}
	
	command void Timer.startOneShot(uint32_t dt) {
		call Timer.startOneShotAt(call SubTimer.getNow(), dt);
	}
	
	command void Timer.stop() {
		call SubTimer.stop();
	}
	
	command bool Timer.isRunning() {
		return call SubTimer.isRunning();
	}
	
	command bool Timer.isOneShot() {
		return !periodic;
	}
	
	command void Timer.startPeriodicAt(uint32_t t0, uint32_t dt) {
		periodic = TRUE;
		interval = dt;
		start(t0);
	}
	
	command void Timer.startOneShotAt(uint32_t t0, uint32_t dt) {
		periodic = FALSE;
		interval = dt;
		start(t0);
	}
	
	command uint32_t Timer.getNow() {
		return call SubTimer.getNow();
	}
	
	command uint32_t Timer.gett0() {
		if(tHasPassed) {
			return call SubTimer.gett0() - t;
		} else {
			return call SubTimer.gett0();
		}
	}
	
	command uint32_t Timer.getdt() {
		return interval;
	}

}
