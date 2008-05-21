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


#if DBG_LEVEL && DBG_LEVEL > 0
	#ifndef DBG_MIN_LEVEL
		#define DBG_MIN_LEVEL 1
	#endif

	#define DBG_STR(str,lvl) \
	if (DBG_LEVEL >= lvl && lvl >= DBG_MIN_LEVEL) {\
		call Debug.debugStr(str,lvl);\
	}
	
	#define DBG_STR_CLEAN(str,lvl) \
	if (DBG_LEVEL >= lvl && lvl >= DBG_MIN_LEVEL) {\
		call Debug.debugStrClean(str);\
	}
	
	#define DBG_INT(int,lvl) \
	if (DBG_LEVEL >= lvl && lvl >= DBG_MIN_LEVEL) {\
		call Debug.debugInt(((uint8_t*)&int),sizeof(int),lvl);\
	}
	
	#define DBG_INT_CLEAN(int,lvl) \
	if (DBG_LEVEL >= lvl && lvl >= DBG_MIN_LEVEL) {\
		call Debug.debugIntClean(((uint8_t*)&int),sizeof(int));\
	}
	
	#define DBG_STRINT(str,int,lvl) \
	if (DBG_LEVEL >= lvl && lvl >= DBG_MIN_LEVEL) {\
		call Debug.debugStrInt(str,((uint8_t*)&int),sizeof(int),lvl);\
	}
	
	#define DBG_DUMP(dmp,len,lvl) \
	if (DBG_LEVEL >= lvl && lvl >= DBG_MIN_LEVEL) {\
		call Debug.debugInt(dmp,len,lvl);\
	}

#else

	#define DBG_STR(str,lvl)
	#define DBG_INT(int,lvl)
	#define DBG_STR_CLEAN(str,lvl)
	#define DBG_INT_CLEAN(int,lvl)
	#define DBG_STRINT(str,int,lvl)
	#define DBG_DUMP(dmp,len,lvl)

#endif


#define DBG_STR_TMP(str) call Debug.debugStr(str,0)
#define DBG_INT_TMP(int) call Debug.debugInt(((uint8_t*)&int),sizeof(int),0)
