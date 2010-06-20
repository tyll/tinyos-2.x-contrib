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
 * @date   August 19 2009
 */

#include "Neighbor.h"

module ExampleNeighborP @safe() {

	provides {
		interface InitNeighbor;
		interface ExampleNeighbor;
	}

} implementation {

	typedef struct example_data {
		uint16_t counter;
	} example_data_t;

	uint8_t offset = uniqueN(UQ_NEIGHBOR_BYTES, sizeof(example_data_t));
	
	example_data_t* ONE get_data(neighbor_t* n) {
		//return TCAST(example_data_t* BND(n->bytes,n->bytes+uniqueCount(UQ_NEIGHBOR_BYTES)), n->bytes+offset);
		//return (example_data_t*) (n->bytes+offset);
		return TCAST(example_data_t* ONE, n->bytes+offset);
	}

	/***************** InitNeighbor ****************/

	command error_t InitNeighbor.init(neighbor_t* n) {
		get_data(n)->counter = 120;
		return SUCCESS;
	}

	/***************** ExampleNeighbor ****************/

	command uint16_t ExampleNeighbor.getCounter(neighbor_t* ONE n) {
		return get_data(n)->counter;
	}

	command void ExampleNeighbor.setCounter(neighbor_t* ONE n, uint16_t counter) {
		get_data(n)->counter = counter;
	}

}
