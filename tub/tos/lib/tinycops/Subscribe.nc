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
interface Subscribe 
{
  /**
   * Issue a subscription.
   *
   * @param handle   the subscription
   * @return         SUCCESS if the request was accepted and will issue
   *                 a subscribeDone event, EBUSY if the component cannot accept
   *                 the request now but will be able to later, FAIL
   *                 if sending failed due to the matching algorithm determining
   *                 no match (the latter is disabled if push==TRUE), EINVAL
   *                 if there is a mismatch between the client who created
   *                 the handle and the client sending the subscription
   */     
  command error_t subscribe(subscription_handle_t handle);

  /**
   * Signalled in response to an accepted subscribe request. <tt>handle</tt>
   * is the sent subscription, and <tt>error</tt> indicates whether the
   * subscribe operation was succesful.
   * 
   * @param handle   the subscription which was requested to send
   * @param error    SUCCESS if it was transmitted successfully, 
   *                 any other error code is propated from the corresponding
   *                 sendDone() event of the subscription send protocol
   */ 
  event void subscribeDone(subscription_handle_t handle, error_t error);

  /** 
   * A matching notification has been received. The <code>handle</code> 
   * must not be referenced after the return of the eventhandler!
   * (you should e.g. memcpy the content to some local buffer)
   * The handle must not be used to modify the notification content.
   * 
   * @param  handle the notification
   */
  event void notificationReceived(notification_handle_t handle);

  /** 
   * Issue an un-subscription, cancelling out the previous
   * subscription issued by the client. This call modifies
   * the content of the subscription represented by the 
   * <code>handle</code>.
   * 
   * @param  handle handle to the subscription
   * @return  SUCCESS if the request was accepted and will issue
   *          a unsubscribeDone event, FAIL otherwise
   */
  command error_t unsubscribe(subscription_handle_t handle);

  /**
   * Signalled in response to an accepted unsubscribe request. <tt>handle</tt>
   * is the sent subscription, and <tt>error</tt> indicates whether the
   * subscribe operation was succesful.
   * 
   * @param handle   the subscription which was requested to send
   * @param error    SUCCESS if it was transmitted successfully, 
   *                 any other error code is propated from the corresponding
   *                 sendDone() event of the subscription send protocol
   */ 
  event void unsubscribeDone(subscription_handle_t handle, error_t error);
}

