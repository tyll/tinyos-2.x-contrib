/*
* Copyright (c) 2006 Stanford University.
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
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
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
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 

interface SendBigMsg
{
	/**
	 * broadcasts a message
	 * @param start1 the start of the data to be sent
	 * @param end1 points one byte after the last byte of the data.
	 * @return FAIL if the component is busy sending another message
	 */
	command error_t send(uint8_t *start_buf, uint32_t total_size);

	/**
	 * Re-Sends parts of a message
	 * @param start_buf  - the start of the data to be sent
	 * @param from  - points to the first frame
	 * @param numFrames - number of consecutive frames to send
	 * @return FAIL if the component is busy sending another message
	 */
	command error_t resend(uint8_t *start_buf, uint16_t from, uint16_t numFrames);

	/**
	 * Fired when a successfully initiated <code>send</code> terminates.
	 * @param success SUCCESS, if the message was sent succesfully.
	 */
	event void sendDone(error_t success);
}
