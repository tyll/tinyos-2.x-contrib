/*
 * Copyright (c) 2002, Vanderbilt University
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
 * Author: Miklos Maroti, Brano Kusy (kusy@isis.vanderbilt.edu)
 * Date last modified: 10/11/05
 *
 */

interface TimeStamping<precision_tag, size_type> 
{
	/**
	 * Returns the time stamp of the last received message. See addStamp()
	 * discussion for time stamp semantics. This method should be called 
	 * when the ReceiveMsg.receive() is fired. 
	 */
	command uint32_t getStamp();

	/**
	 * Adds a time stamp to the current message when sent by the radio. This
	 * method must be called immediatelly after SendMsg.send() returns
	 * SUCCESS. The message must include space for the 32-bit time stamp. 
	 * The offset parameter is the offset of the time stamp field
	 * in the TOS_Msg.data payload. 
	 * The local time will be ***ADDED*** to this time stamp field in the message
	 * at the time of transmission. 
	 * Usage: 
	 *	 	 1.) time stamp field is initialized to 0: receiver gets local time of 
	 *	 	 	   at sender when it actually sent the message;
	 *	 	 2.) time stamp field is initialized to the negative of an event time: 
	 *	 	 	 	 receiver gets the elapsed time since that event and can compute
	 *	 	 	 	 event time in its local time.
	 *	 	 	 	 	 	 
	 * @return SUCCESS if the offset is in the valid range, or FALSE
	 *	if the message will not be time stamped.
	 */
	/**
	 * We remember pointer to the timestamped TOS msg to avoid timestamping wrong 
	 * TOS packets. 
	 */
	command error_t addStamp(message_t* msg, int8_t offset);
}
