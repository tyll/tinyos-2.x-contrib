/*
 * Copyright (c) 2007, Technische Universitaet Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitaet Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$ @author: Jan Hauer
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */

#include "TinyCOPS.h" 
interface Publish 
{
  /**
   * Publish a notification.
   *
   * @param handle   the notification
   * @param push     a flag influencing the matching point; TRUE means that
   *                 the matching algorithm is not applied on the source node, 
   *                 FALSE means that it is
   * @return         SUCCESS if the request was accepted and will issue
   *                 a publishDone event, EBUSY if the component cannot accept
   *                 the request now but will be able to later, FAIL
   *                 if sending failed due to the matching algorithm determining
   *                 no match (the latter is disabled if push==TRUE), EINVAL
   *                 if there is a mismatch between the client who created
   *                 the handle and the client sending the notification
   */    
  command error_t publish(notification_handle_t handle, bool push);

  /**
   * Signalled in response to an accepted publish request. <tt>handle</tt>
   * is the sent notification, and <tt>error</tt> indicates whether the
   * publish operation was succesful.
   * 
   * @param handle   the notification which was requested to send
   * @param error    SUCCESS if it was transmitted successfully, 
   *                 any other error code is propated from the corresponding
   *                 sendDone() event of the notification send protocol
   */ 
  event void publishDone(notification_handle_t handle, error_t error);
}

