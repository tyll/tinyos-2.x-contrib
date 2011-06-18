/*
 * Copyright (c) 2011, KTH Royal Institute of Technology
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this list
 * 	  of conditions and the following disclaimer.
 *
 * 	- Redistributions in binary form must reproduce the above copyright notice, this
 *    list of conditions and the following disclaimer in the documentation and/or other
 *	  materials provided with the distribution.
 *
 * 	- Neither the name of the KTH Royal Institute of Technology nor the names of its
 *    contributors may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */
/**
 * @author Aitor Hernandez <aitorhh@kth.se>
 * 
 * @version  $Revision$ 
 */

module PinDebugP @ safe() {
	uses {
		interface GeneralIO as PinADC0;
		interface GeneralIO as PinADC1;
		interface GeneralIO as PinADC2;
	}
	provides{
		interface PinDebug;
		interface Init as Reset;
	}
}

implementation {

	/***************** Init Commands ****************/
	command error_t Reset.init() {
		call PinADC0.makeOutput();
		call PinADC1.makeOutput();
		call PinADC2.makeOutput();

		return SUCCESS;
	}
	command void PinDebug.ADC0toggle(){call PinADC0.toggle(); }
	command void PinDebug.ADC0set(){call PinADC0.set();	}
	command void PinDebug.ADC0clr(){call PinADC0.clr();	}
	
	command void PinDebug.ADC1toggle(){call PinADC1.toggle(); }
	command void PinDebug.ADC1set(){call PinADC1.set();	}
	command void PinDebug.ADC1clr(){call PinADC1.clr();	}
	
	command void PinDebug.ADC2toggle(){call PinADC2.toggle(); }
	command void PinDebug.ADC2set(){call PinADC2.set();	}
	command void PinDebug.ADC2clr(){call PinADC2.clr();	}

}
