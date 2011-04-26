/*
 * TTSP - Tagus Time Synchronization Protocol
 *
 * Copyright (c) 2010 Hugo Freire and IT - Instituto de Telecomunicacoes
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Address:
 * Instituto Superior Tecnico - Taguspark Campus
 * Av. Prof. Dr. Cavaco Silva, 2744-016 Porto Salvo
 *
 * E-Mail:
 * hugo.freire@ist.utl.pt
 */

/**
 * TTSP Protocol.
 *
 * This component implements the TTSP time synchronization protocol.
 *
 * @author Hugo Freire <hugo.freire@ist.utl.pt>
**/

#include "printf.h"

module AdaptiveTimeSyncP {
	provides {
		interface Init;
		interface AdaptiveTimeSync;
		interface StdControl;
	}
	uses {
		interface Boot;
		interface StdControl as TimeSyncStdControl;
		interface Timer<TMilli>;
		interface TimeSyncControl;
		interface TimeSyncInfo;
		interface Leds;
	}
} implementation {
	
	enum {
		INIT_SYNC_PERIOD = 10240, // 10 sec
		MAX_SYNC_PERIOD = 1024000, // 1000 sec
		AVG_SYNC_PERIOD = 102400, // 100 sec
		MIN_SYNC_PERIOD = 10240, // 1 sec
		ROOT_TIMEOUT = 3,
		SYNC_PERIOD_SAFE_MARGIN = 6,
		PHASE0_MAX_NUM_ERRORS = 2,
		PHASE1_MAX_NUM_ERRORS = 4,
		PHASE0_SAFE_PERIOD_NUM_INCREASES = 2,
		PHASE1_SAFE_PERIOD_NUM_INCREASES = 1,
	};
	
  enum {
  	PHASE_0 = 0x00,
  	PHASE_1 = 0x01,
  	PHASE_2 = 0x02
  };

	uint8_t phase;
	uint8_t heartBeats;
	uint32_t syncPeriod = INIT_SYNC_PERIOD;
	uint32_t safeSyncPeriod = INIT_SYNC_PERIOD;
	uint32_t maxPrecisionError;
	uint32_t currentPrecisionError;
	uint8_t numErrors = 0;
	uint8_t numLeft = 0;
	uint8_t lastSeqNum = 0;
	uint8_t numIncreases = 0;
	uint32_t maxPeriodPhase0;
	uint32_t minPeriodPhase0;
	uint32_t maxPeriodPhase1;

	void applyNewSyncPeriod() {
		uint32_t timeLeft;
			
		timeLeft = call Timer.getNow() - call Timer.gett0();
			
		call Timer.stop();
			
		if(timeLeft > syncPeriod) {
			call Timer.startOneShot(0);
		} else {
			call Timer.startOneShot(syncPeriod-timeLeft);
		}
	}

	task void calculateSyncPeriod() {
		if (currentPrecisionError < maxPrecisionError-SYNC_PERIOD_SAFE_MARGIN) {
			
			switch (phase) {
				case PHASE_0:
					if (numErrors != 0) {
						if (numIncreases >= PHASE0_SAFE_PERIOD_NUM_INCREASES) {
							printf("PHASE_0: numErrors=0.\n"); printfflush();
							numErrors = 0;
						}
					}
					
					if (syncPeriod < MAX_SYNC_PERIOD) {
						printf("PHASE_0: numIncreases=%i.\n", numIncreases+1); printfflush();
				
						syncPeriod *= 1.4;
						call TimeSyncControl.setSyncPeriod(syncPeriod);
						
						if (++numIncreases == PHASE0_SAFE_PERIOD_NUM_INCREASES) {
							numIncreases = 0;
							safeSyncPeriod = syncPeriod/1.4;
							printf("PHASE_0: numIncreases=0.\nPHASE_0: safeSyncPeriod=%lu.\n", safeSyncPeriod);printfflush();
						}
						
						printf("PHASE_0: syncPeriod=%lu.\n\n", syncPeriod);
					}			

					break;
				case PHASE_1:
					printf("PHASE_1:\n"); printfflush();
					
					if (numErrors != 0) {
						if (numIncreases >= PHASE0_SAFE_PERIOD_NUM_INCREASES) {
							printf("PHASE_1: numErrors=0.\n"); printfflush();
							numErrors = 0;
						}
					}
					
					if (syncPeriod < maxPeriodPhase0) {
						printf("PHASE_1: numIncreases=%i.\n", numIncreases+1); printfflush();

						if (syncPeriod*1.2 > maxPeriodPhase0) {
							syncPeriod = maxPeriodPhase0;
						} else {
							syncPeriod *= 1.2;
						}

						call TimeSyncControl.setSyncPeriod(syncPeriod);
						
						if (++numIncreases == PHASE1_SAFE_PERIOD_NUM_INCREASES) {
							numIncreases = 0;
							safeSyncPeriod = syncPeriod/1.2;
							printf("PHASE_1: numIncreases=0.\nPHASE_1: safeSyncPeriod=%lu.\n", safeSyncPeriod);printfflush();
						}
						
						printf("PHASE_1: syncPeriod=%lu.\n\n", syncPeriod);
					}						
					
					break;
				case PHASE_2:
					printf("PHASE_2:\n"); printfflush();
					break;
				default:
			}
		} else {
			
			switch (phase) {
				case PHASE_0:
					printf("PHASE_0: numIncreases=0.\n"); printfflush();
					
					numIncreases = 0;
					
					if (++numErrors < PHASE0_MAX_NUM_ERRORS) {
							printf("PHASE_0: numErrors=%i.\n", numErrors); printfflush();
							
							if (syncPeriod < MAX_SYNC_PERIOD) {
								syncPeriod *= 1.1;
								call TimeSyncControl.setSyncPeriod(syncPeriod);
								applyNewSyncPeriod();
								printf("PHASE_0: syncPeriod=%lu.\n\n", syncPeriod);
							}					
		
					} else if (numErrors == PHASE0_MAX_NUM_ERRORS) {
						printf("PHASE_0: numErrors=%i.\n", numErrors);
						
						printf("PHASE_0: maxPeriodPhase0=%lu.\n", syncPeriod); printfflush();
						
						if (syncPeriod > MIN_SYNC_PERIOD) {
							minPeriodPhase0 = safeSyncPeriod;
							maxPeriodPhase0 = syncPeriod;
							syncPeriod = minPeriodPhase0;
							call TimeSyncControl.setSyncPeriod(syncPeriod);
							applyNewSyncPeriod();
							printf("PHASE_0: Resetting sync period to %lu.\n\n", syncPeriod);
						}
						
						numErrors = 0;
						
						printf("PHASE_0: phase=PHASE_1.\n"); printfflush();
						phase = PHASE_1;
					}
					
					break;
				case PHASE_1:
					printf("PHASE_1:\n"); printfflush();
					
					numIncreases = 0;

					if (safeSyncPeriod > minPeriodPhase0) { // Increase+Error
						maxPeriodPhase1 = syncPeriod;
						syncPeriod = safeSyncPeriod;
						call TimeSyncControl.setSyncPeriod(syncPeriod);
						applyNewSyncPeriod();
						printf("PHASE_1: Resetting sync period to %lu.\n\n", syncPeriod);
							
						numErrors = 0;
						
						printf("PHASE_1: phase=PHASE_2.\n"); printfflush();
						phase = PHASE_2;
					} else { // Just errors
						
						if (++numErrors < PHASE1_MAX_NUM_ERRORS) { // Bellow max number of errors
							
							if (syncPeriod*0.8 > MIN_SYNC_PERIOD) {
								syncPeriod *= 0.8;
							} else {
								syncPeriod = MIN_SYNC_PERIOD;
							}
							
							call TimeSyncControl.setSyncPeriod(syncPeriod);
							applyNewSyncPeriod();
							printf("PHASE_1: syncPeriod=%lu.\n\n", syncPeriod);
							
						} else { // Above or equal max number of errors
							
							printf("PHASE_1: numErrors=%i.\n", numErrors);
						
							printf("PHASE_1: maxPeriodPhase1=%lu.\n", syncPeriod); printfflush();
						
							if (syncPeriod > MIN_SYNC_PERIOD) {
								maxPeriodPhase1 = syncPeriod;
								syncPeriod = safeSyncPeriod;
								call TimeSyncControl.setSyncPeriod(syncPeriod);
								applyNewSyncPeriod();
								printf("PHASE_1: Resetting sync period to %lu.\n\n", syncPeriod);
							}
						
							numErrors = 0;
						
							printf("PHASE_1: phase=PHASE_2.\n"); printfflush();
							phase = PHASE_2;
						}
					}
					break;
				case PHASE_2:
					printf("PHASE_2:\n"); printfflush();
					break;
				default:
			}
		}
		
		printfflush();
	}
	
	command error_t Init.init() {
		phase = PHASE_0;
		heartBeats = 0;
		return SUCCESS;
	}

	command error_t StdControl.start() {
		printf("[AdaptiveTimeSyncP] Starting Adaptive Time Synchronization...\n");
		printfflush();

		call TimeSyncStdControl.start();
		
		call TimeSyncControl.setSyncPeriod(syncPeriod);
		
		call Timer.startOneShot(syncPeriod);
		return SUCCESS;
	}
	
	command error_t StdControl.stop() {
		call TimeSyncStdControl.stop();
		if(call Timer.isRunning()) {
			call Timer.stop();
		}
		return SUCCESS;
	}
	
	command error_t AdaptiveTimeSync.setMaxPrecisionError(uint32_t precisionError) {
		maxPrecisionError = precisionError;
		
		return SUCCESS;
	}

	event void Timer.fired() {
	
		if(!(call TimeSyncInfo.isRoot()) && ++heartBeats >= ROOT_TIMEOUT) {
			heartBeats = 0;
			call Leds.set(LEDS_LED0 | LEDS_LED1 | LEDS_LED2);
			call TimeSyncControl.setRoot();
		}
		
		if(call TimeSyncInfo.isSynced()) {
			call TimeSyncControl.sendMsg();
		}
		
		if (numLeft > 0) {
			numLeft--;
			call Timer.startOneShot(INIT_SYNC_PERIOD);
		} else {
			call Timer.startOneShot(syncPeriod);
		}
		
		
	}
	
	event void TimeSyncControl.foundRoot(uint32_t period, uint16_t nodeID) {
		printf("\n[AdaptiveTimeSyncP] Found root with id %i and period %lu through node %i.\n", call TimeSyncInfo.getRootId(), period, nodeID);
		printfflush();
		
		heartBeats = 0;
		
		if(syncPeriod != period) {
			syncPeriod = period;
			
			call TimeSyncControl.setSyncPeriod(syncPeriod);
		}
	}
	
	event void TimeSyncControl.foundFalseRoot() {
		printf("\n[AdaptiveTimeSyncP] Found fake root.\n");
		printfflush();
		
		if (call TimeSyncInfo.isRoot()) {
			numLeft = 4;
			
			call Timer.stop();
			call Timer.startOneShot(0);
		}
	}
	
	event void TimeSyncControl.synced() {
		call Leds.set(call TimeSyncInfo.getRootId());
	}

	event void TimeSyncControl.currentPrecisionError(uint8_t seqNum, uint16_t nodeID, uint32_t precisionError) {
		
		if (call TimeSyncInfo.isRoot()) { // root
			
			if (lastSeqNum < seqNum) {
				
				lastSeqNum = seqNum;
				currentPrecisionError = precisionError;
				
				//if (currentPrecisionError >= 1) {
				//	currentPrecisionError--;
				//}

				printf("seqNum=%i error=%lu.\n", seqNum, currentPrecisionError);
				printfflush();		
				
				post calculateSyncPeriod();
			} else if (lastSeqNum == seqNum  
				&& currentPrecisionError < maxPrecisionError-SYNC_PERIOD_SAFE_MARGIN 
				&& precisionError > maxPrecisionError-SYNC_PERIOD_SAFE_MARGIN) {
				
				currentPrecisionError = precisionError;
				
				//if (currentPrecisionError >= 1) {
				//	currentPrecisionError--;
				//}

				printf("seqNum=%i nodeID=%i error=%lu.\n", seqNum, nodeID, currentPrecisionError);
				printfflush();		


				post calculateSyncPeriod();
			}
			
		} else { // non-root
			
			printf("seqNum=%i error=%lu.\n", seqNum, precisionError);
			printfflush();		
			
			//if (numIncreases++ > 1) {
			//	call TimeSyncControl.removeOldestSyncPoint();
			//	numIncreases = 0;
			//}
		}
	}

	event void Boot.booted() {}	
	event void TimeSyncControl.sendDone() {}
	event void TimeSyncControl.msgReceived() {}
	command uint32_t AdaptiveTimeSync.getSyncPeriod() {return syncPeriod;}
	command uint32_t AdaptiveTimeSync.getPrecisionError() {return currentPrecisionError;}
}