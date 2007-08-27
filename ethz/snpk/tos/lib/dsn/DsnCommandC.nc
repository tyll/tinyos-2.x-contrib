/* Copyright (c) 2007 ETH Zurich.
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
*  For additional information see http://www.btnode.ethz.ch/
*
*  $Id$
* 
*/

/**
 * This modules detects dsn commands with following format:
 * key value1 value2 value3 ...
 * 
 * commands with too many parameters, non-integer parameters are not detected
 * 
 * module parameters:
 * key: command string to detect
 * valueType: type of parameters (only integers)
 * maxValueCount: upper bound of parameter count
 * 
 * --> don't forget to wire every new DsnCommand to the DSNC component !
 * 
 * @author Roman Lim <rlim@ee.ethz.ch>
 * 
 */
 
generic configuration DsnCommandC(
	uint8_t key[], 
	typedef valueType @integer(),
	uint8_t maxValueCount)
{
  provides interface DsnCommand<valueType>;
}
implementation
{
	components
		DSNC,
		new DsnCommandP(key, valueType, maxValueCount);
		
	DsnCommand=DsnCommandP;
	DsnCommandP.DsnReceive->DSNC;
}
