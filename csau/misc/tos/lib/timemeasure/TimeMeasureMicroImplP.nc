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
 * @date   Marts 29 2008
 */

#include "TimeMeasure.h"

generic module TimeMeasureMicroImplP(uint8_t numClients) {

	provides {
		interface TimeMeasure<uint32_t>[uint8_t client];
	}

	uses {
		interface Counter<TMicro, uint16_t> as Counter;
	}

} implementation {

	enum {
		INVALID_OVERFLOW = 0xFFFF,
		INVALID_TIME = 0xFFFFFFFF,
	};

	struct time_measure {
		uint16_t overflows;
		uint32_t time;
	} data[numClients];

	async command void TimeMeasure.start[uint8_t client]() {
		atomic {
			data[client].overflows = 0; 
			data[client].time = call Counter.get();
		}
	}
	
	async command void TimeMeasure.stop[uint8_t client]() {
		atomic {
			//if(data[client].overflows!=INVALID_OVERFLOW) {
			uint32_t result = call Counter.get();
			
			// too many overflows
			if(data[client].overflows==INVALID_OVERFLOW) {
				data[client].time = INVALID_TIME;
				return;
			}
			
			// add overflows
			while(data[client].overflows>0) {
				result += 0xFFFF;
				data[client].overflows--;
			}
			
			result -= data[client].time;
			data[client].time = result;
			data[client].overflows = INVALID_OVERFLOW;
		}
		//}
	}
	
	async command uint32_t TimeMeasure.get[uint8_t client]() {
		uint32_t result;
		atomic result = data[client].time;
		return result;
	}
	
	event async void Counter.overflow(){ 
		uint8_t i;
		atomic {
			for(i=0;i<numClients;i++) {
				// add overflows, but never wrap-around counter
				if(data[i].overflows!=INVALID_OVERFLOW) {
					data[i].overflows++;
				}
			}
		}
	}

}
