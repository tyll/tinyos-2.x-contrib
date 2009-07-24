/*
 * Copyright (c) 2009, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Andras Nadas, Miklos Maroti, Gabor Pap, Janos Sallai
 * Contact: Janos Sallai (sallai@isis.vanderbilt.edu)
 */
 
/**
 * DataCommand interface allows an unstructured stream of bytes to be
 * passed (up to 24 bytes) to the component and an acknowledgment be sent
 * back.
 *
 * @author Andras Nadas, Miklos Maroti, Gabor Pap
 * @modified 02/02/05
 */ 
 
interface DataCommand
{
	/**
	 * Called by the RemoteControl module. 
	 * The implementation must execute the corresponding command,
	 * then it should signal the ack() event.
	 *
	 * @param data Pointer to an application specific parameter.
	 * @param length The length of the parameter in bytes.
	 */
	command void execute(void *data, uint8_t length);
	
	/**
	 * Can be signaled by the implementation during or shortly after
	 * the execution of the execute() command.
	 *
	 * @return Application specific return value. 
	 *	This value will be routed back to the base station.
	 */
	event void ack(uint16_t returnValue);
}
