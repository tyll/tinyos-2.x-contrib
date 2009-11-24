/* Copyright (c) 2009, Distributed Computing Group (DCG), ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
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
*  @author Lars Schor <lschor@ee.ethz.ch>
* 
*/

// Implements a simple reset on port 19191

module ResetNodeP{
	uses {
		interface Boot;
		interface UDP;
	}
}
implementation{

	event void Boot.booted(){
		call UDP.bind(19191);
	}

	event void UDP.recvfrom(struct sockaddr_in6 *src, void *payload, uint16_t len, struct ip_metadata *meta){
		#if defined(PLATFORM_MICA) || defined(PLATFORM_MICA2) || defined(PLATFORM_MICA2DOT) || defined(PLATFORM_MICAZ)
		    	cli(); 
		  	wdt_enable(0); 
		  	while (1) { 
		  		__asm__ __volatile__("nop" "\n\t" ::);
		  	}
		#elif defined(PLATFORM_TELOS) || defined(PLATFORM_TELOSB) || defined(PLATFORM_EPIC)
		        WDTCTL = 0;
		#elif defined(PLATFORM_MESHBEAN900) || defined(PLATFORM_IRIS) || defined(PLATFORM_PIXIE) || defined(PLATFORM_MESHBEAN) 
		    wdt_enable(0);  
		    while (1) { 
				__asm__ __volatile__("nop" "\n\t" ::);
		  	}
		  	// Needs additional settings in the RealMainP.nc file! 
		#else
		#error "Reset.h not defined/supported for your platform, aborting..."
		#endif
	}
}
