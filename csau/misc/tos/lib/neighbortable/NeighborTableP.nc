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

module NeighborTableP {
	provides {
		interface Init;
		interface NeighborTable;

		interface Neighbor;
	}
	uses {
		interface Pool<neighbor_t> as Pool;
		interface InitNeighbor;
	}
}
implementation {

	neighbor_t* table[NEIGHBOR_TABLE_SIZE];
	uint8_t count = 0;

	uint8_t find(am_addr_t addr);
	void printTable();

	/***************** Init ****************/	

	command error_t Init.init() {
		int i;
		for(i=0; i<NEIGHBOR_TABLE_SIZE; i++) {
			table[i] = NULL;
		}
		return SUCCESS;
	}
	
	/***************** NeighborTable ****************/	
	
	command neighbor_t* NeighborTable.get(am_addr_t addr) {
		uint8_t tableindex = find(addr);
		dbg("NeighborTable", "Getting addr %hu \n", addr);
		if(tableindex!=NEIGHBOR_TABLE_SIZE) {
			return table[tableindex];
		} else {
			return NULL;
		}
	}

	command error_t NeighborTable.insert(am_addr_t addr) {
		if(call NeighborTable.contains(addr)) {
			dbg("NeighborTable", "Addr %hu already existing \n", addr);
			return EINVAL;
		} else {
			neighbor_t* n = call Pool.get();
			if(n!=NULL) {
				// TODO: why not do the memset?
				memset(n, 0, sizeof(neighbor_t));
				n->addr = addr;
				call Neighbor.setInTable(n, TRUE);
				table[count] = n;
				count++;
				call InitNeighbor.init(n);
				dbg("NeighborTable", "New entry: addr=%hu \n", n->addr);
				return SUCCESS;
			} else {
				return ENOMEM;
			}
		}
	}
	
	command error_t NeighborTable.evict(am_addr_t addr) {
		uint8_t tableindex;
		error_t error;
		neighbor_t* n;
		
		// Check to see if param is known (and thereby also that table is not empty)
		tableindex = find(addr);
		if(tableindex==NEIGHBOR_TABLE_SIZE) {
			return EINVAL;
		}
		n = table[tableindex];
		call Neighbor.setInTable(n, FALSE);
		error = call Pool.put(n);
		if(error!=SUCCESS) {
			dbgerror("Neighbor", "%s: Pool already filled.\n", __FUNCTION__);
		}
		
		table[tableindex] = table[count-1];
		table[count-1] = NULL;
		count--;

		signal NeighborTable.evicted(addr);
		
		return SUCCESS;
	}
	
	command bool NeighborTable.contains(am_addr_t addr) {
		return find(addr)!=NEIGHBOR_TABLE_SIZE;
	}
	
	command uint8_t NeighborTable.numNeighbors() {
		return count;
	}
	
	command neighbor_t* NeighborTable.getById(uint8_t idx) {
		if(idx>=count) {
			dbg("Neighbor", "%s: id is to high.\n", __FUNCTION__);
			return NULL;
		}
		return table[idx];
	}
	
	uint8_t find(am_addr_t addr) {
		int i;
		for(i=0;i<count;i++) {
			if(table[i]->addr==addr) {
				return i;
			}
		}
		return NEIGHBOR_TABLE_SIZE;
	}
	
	void printTable() {
#if TOSSIM
		uint8_t i;
		dbg("NeighborTable", "NeighborTable:\n");
		for(i=0; i<count; i++) {
			dbg("NeighborTable", "  %hhu. addr=%hu\n", i, table[i]->addr);
		}
#endif
	}
	
	/***************** Neighbor ****************/	

	command am_addr_t Neighbor.getAddress(neighbor_t* n) {
		return n->addr;
	}
	command void Neighbor.setAddress(neighbor_t* n, am_addr_t addr) {
		n->addr = addr;
	}

	void setFlag(neighbor_t* n, neighbor_flag_t flag) {
		n->flag |= flag;	
	}
	void clearFlag(neighbor_t* n, neighbor_flag_t flag) {
		n->flag &= ~flag;
	}
	bool getFlag(neighbor_t* n, neighbor_flag_t flag) {
		return ((n->flag & flag) == flag) ? TRUE : FALSE;
	}

	command void Neighbor.setInTable(neighbor_t* n, bool intable) {
		if(intable) {
			setFlag(n, NEIGHBOR_FLAG_INTABLE);
		} else {
			clearFlag(n, NEIGHBOR_FLAG_INTABLE);
		}
	}
	
	command bool Neighbor.getInTable(neighbor_t* n) {
		return getFlag(n, NEIGHBOR_FLAG_INTABLE);
	}

	/***************** Defaults ****************/	

 default command error_t InitNeighbor.init(neighbor_t* neighbor) {
		return SUCCESS;
	}

}
