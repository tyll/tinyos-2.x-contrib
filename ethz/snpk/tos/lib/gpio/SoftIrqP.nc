/**
 *  Copyright (c) 2004-2005 Crossbow Technology, Inc.
 *  All rights reserved.
 *
 *  Permission to use, copy, modify, and distribute this software and its
 *  documentation for any purpose, without fee, and without written
 *  agreement is hereby granted, provided that the above copyright
 *  notice, the (updated) modification history and the author appear in
 *  all copies of this source code.
 *
 *  Permission is also granted to distribute this software under the
 *  standard BSD license as contained in the TinyOS distribution.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS 
 *  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA, 
 *  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
 *  THE POSSIBILITY OF SUCH DAMAGE.
 *
 *  @author Matt Miller, Crossbow <mmiller@xbow.com>
 *  @author Martin Turon, Crossbow <mturon@xbow.com>
 *
 *  $Id$
 */

/**
 * Interrupt emulation interface access for GPIO pins.
 *
 * @param  interval   How often to check soft irq pin in msec
 */
generic module SoftIrqP (uint8_t interval)
{
    provides interface GpioInterrupt as SoftIrq;
    
    uses {
	interface Timer<TMilli> as IrqTimer;
	interface GeneralIO as IrqPin;
    }
}
implementation
{
    norace struct {
	uint8_t final : 1;
	uint8_t last  : 1;
    } state;

	bool enabled=FALSE;

	task void stoptimer();
	task void starttimer();

    // ************* SoftIrq Interrupt handlers and dispatch *************
  
	async command error_t SoftIrq.enableRisingEdge() {
		atomic { enabled=TRUE;
			 state.final = TRUE;
		}    // save state we await
		state.last = call IrqPin.get();          // get current state
		post starttimer(); // wait interval in msec
		return SUCCESS;
  	}
  
  	async command error_t SoftIrq.enableFallingEdge() {
  		atomic { enabled=TRUE;
		 	 state.final = FALSE;
		}    // save state we await
		state.last = call IrqPin.get();          // get current state
		post starttimer(); // wait interval in msec
		return SUCCESS;
  	}

	async command error_t SoftIrq.disable() {
		atomic enabled=FALSE;
		post stoptimer();
		return SUCCESS;
  	}

	event void IrqTimer.fired() {
		uint8_t  l_state = call IrqPin.get();
		atomic {if (!enabled) return;}
	
		if ((state.last != state.final) && 
		    	(state.final == l_state)) {
	    		// If we found an edge, fire SoftIrq!
	    		signal SoftIrq.fired();
        	} 
		atomic if (enabled) {
			// Otherwise, restart timer and try again
			state.last = l_state;
			call IrqTimer.startOneShot(interval);
		}
    	}

	task void stoptimer() {
		atomic {
			if (!enabled)
				call IrqTimer.stop();
		}
	}
	
	task void starttimer() {
		atomic {
			if (enabled)
				call IrqTimer.startOneShot(interval);
		}
	}
}
