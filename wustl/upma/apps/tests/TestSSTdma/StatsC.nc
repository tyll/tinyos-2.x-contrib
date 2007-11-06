/*
 * "Copyright (c) 2007 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */
 
/**
 *
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */

module StatsC {
	provides interface Stats;
} implementation {
	uint16_t cca;
	uint16_t csma;
	uint16_t failedCca;

	command uint16_t Stats.getCcaCalls() {
		return cca;
	}
	
	command void Stats.setCcaCalls(uint16_t cca_) {
		cca = cca_;
	}
	
	command void Stats.incCcaCalls() {
		cca++;
	}
	
	
	command uint16_t Stats.getCsmaCalls() {
		return csma;
	}
	
	command void Stats.setCsmaCalls(uint16_t csma_) {
		csma = csma_;
	}
	
	command void Stats.incCsmaCalls() {
		csma++;
	}
	
	command uint16_t Stats.getFailedCcas() {
		return failedCca;
	}
	
	command void Stats.setFailedCcas(uint16_t failedCca_) {
		failedCca = failedCca_;
	}
	
	command void Stats.incFailedCcas() {
		failedCca++;
	}
}
