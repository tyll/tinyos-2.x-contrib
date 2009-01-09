/* Copyright (c) 2008, Computer Engineering Group, Yazd University , Iran .
*  All rights reserved.
*
*  Permission to use, copy, modify, and distribute this software and its
*  documentation for any purpose, without fee, and without written
*  agreement is hereby granted, provided that the above copyright
*  notice, the (updated) modification history and the author appear in
*  all copies of this source code.
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
*/

module BlockingReadP {
	provides interface BlockingRead;
	uses interface Read<uint16_t>;
	uses interface JobControl;
}
implementation {
	
	uint16_t val;
	uint8_t job_id;
	error_t res;
	
	inline command error_t BlockingRead.readB(uint8_t id,uint16_t* data)
	{
		job_id = id;		
		call Read.read();
		call JobControl.suspend(job_id);
		*data = val;
		return res;
	}
	
	event void Read.readDone(error_t result, uint16_t data) __attribute__((noinline))
	{
		if (result==SUCCESS) {
			val = data;
		}
		res = result;
		call JobControl.resume(job_id);
	}
	
}
