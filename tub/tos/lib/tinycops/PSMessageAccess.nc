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
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */

  /** 
   * A notification/subscription is represented by a handle, which allows to
   * treat notifications/subscriptions as abstract data types.  This
   * interface provides the accessor commands to inspect notification/
   * subscription content, as well as to allocate space for new
   * attributes/constraints/metadata within a given notification/
   * subscription. Such allocated attributes/constraints/metadata can then be
   * filled with content by the application by directly accessing the returned
   * struct pointers (avpair_t*, constraint_t*). To reset (delete complete
   * message content) use the PSHandle interface.
   */     

#include "TinyCOPS.h"
interface PSMessageAccess
{ 
  /**
   * Returns the number of attributes that are in a notification.
   * @param handle   the subscription
   * @param num      a pointer where the number of attributes will be stored.
   * @return         SUCCESS if the request was accepted, FAIL otherwise
   */       
  command error_t numAttributes(notification_handle_t handle, uint8_t *num);
  /**
   * Returns the number of constraints that are in a subscription.
   * @param handle   the subscription
   * @param num      a pointer where the number of attributes will be written
   * @return         SUCCESS if the request was accepted, FAIL otherwise
   */  
  command error_t numConstraints(subscription_handle_t handle, uint8_t *num);
  /**
   * Returns the number of metadata items that are in a subscription.
   * @param handle   the subscription
   * @param num      a pointer where the number of metadata will be written
   * @return         SUCCESS if the request was accepted, FAIL otherwise
   */  
  command error_t numMetadata(subscription_handle_t handle, uint8_t *num);

  /**
   * Returns a list of attribute identifiers in a notification.
   * @param handle   the notification 
   * @param id       a pointer where the attribute identifiers will be written,
   *                 it must have a size of *num entries !
   * @param num      a pointer to a variable that stores the length of the 
   *                 id buffer - after the call this variable will hold the
   *                 number of identifiers that have been written to the id
   *                 buffer, which may be less or equal than the previous value
   * @return         SUCCESS if the request was accepted, FAIL otherwise
   */  
  command error_t getAttributeIDs(notification_handle_t handle, attribute_id_t *id, uint8_t *num);
  /**
   * Returns a list of constraint identifiers in a subscription.
   * @param handle   the subscription 
   * @param id       a pointer where the constraint identifiers will be written,
   *                 it must have a size of *num entries !
   * @param num      a pointer to a variable that stores the length of the 
   *                 id buffer - after the call this variable will hold the
   *                 number of identifiers that have been written to the id
   *                 buffer, which may be less or equal than the previous value
   * @return         SUCCESS if the request was accepted, FAIL otherwise
   */  
  command error_t getConstraintIDs(subscription_handle_t handle, attribute_id_t *id, uint8_t *num);
  /**
   * Returns a list of metadata identifiers in a subscription.
   * @param handle   the subscription 
   * @param id       a pointer where the metadata identifiers will be written,
   *                 it must have a size of *num entries !
   * @param num      a pointer to a variable that stores the length of the 
   *                 id buffer - after the call this variable will hold the
   *                 number of identifiers that have been written to the id
   *                 buffer, which may be less or equal than the previous value
   * @return         SUCCESS if the request was accepted, FAIL otherwise
   */  
  command error_t getMetadataIDs(subscription_handle_t handle, attribute_id_t *id, uint8_t *num);

  /**
   * Returns a pointer to an attribute-value pair in a notification identified by 
   * the attribute identifier.
   * @param handle     the notification 
   * @param id         the identifier of the sought attribute 
   * @param valueSize  a pointer to where the size (in byte) of the attribute
   *                   value will be written
   * @return           a pointer to the avpair or NULL if there is no such attribute
   *                   in the notification
   */  
  command avpair_t *getAttributeViaId(notification_handle_t handle, attribute_id_t id, uint8_t *valueSize);
  /**
   * Returns a pointer to a constraint in a subscription identified by 
   * the constraint identifier.
   * @param handle     the subscription 
   * @param id         the identifier of the sought constraint 
   * @param valueSize  a pointer to where the size (in byte) of the constraint 
   *                   value will be written
   * @return           a pointer to the constraint or NULL if there is no such  
   *                   constraint in the notification
   */    
  command constraint_t *getConstraintViaId(subscription_handle_t handle, attribute_id_t id, uint8_t *valueSize);
  /**
   * Returns a pointer to a metadata item in a subscription identified by 
   * the attribute identifier.
   * @param handle     the subscription 
   * @param id         the identifier of the sought metadata item 
   * @param valueSize  a pointer to where the size (in byte) of the metadata 
   *                   value will be written
   * @return           a pointer to the metadata or NULL if there is no such  
   *                   metadata in thesubscription 
   */      
  command avpair_t *getMetadataViaId(subscription_handle_t handle, attribute_id_t id, uint8_t *valueSize);

  /**
   * Returns a pointer to an attribute-value pair in a notification identified by 
   * an index. The index corresponds to the list of identfiers that can
   * be obtained through the getAttributeIDs command
   * @param handle     the notification 
   * @param _index     the index of the sought attribute-value pair  
   * @param valueSize  a pointer to where the size (in byte) of the attribute 
   *                   value will be written
   * @return           a pointer to the attribute-value pair or NULL if there is no such  
   *                   attribute in the notification 
   */   
  command avpair_t *getAttributeViaIndex(notification_handle_t handle, uint8_t _index, uint8_t *valueSize);
  /**
   * Returns a pointer to a constraint in a subscription identified by 
   * an index. The index corresponds to the list of identfiers that can
   * be obtained through the getConstraintIDs command
   * @param handle     the subscription 
   * @param _index     the index of the sought constraint  
   * @param valueSize  a pointer to where the size (in byte) of the constraint 
   *                   value will be written
   * @return           a pointer to the constraint or NULL if there is no such  
   *                   constraint in the subscription 
   */    
  command constraint_t *getConstraintViaIndex(subscription_handle_t handle, uint8_t _index, uint8_t *valueSize);
  /**
   * Returns a pointer to a metadata item in a subscription identified by 
   * an index. The index corresponds to the list of identfiers that can
   * be obtained through the getMetadataIDs command
   * @param handle     the subscription 
   * @param _index     the index of the sought metadata item 
   * @param valueSize  a pointer to where the size (in byte) of the metadata 
   *                   value will be written
   * @return           a pointer to the metadata or NULL if there is no such  
   *                   metadata in thesubscription 
   */   
  command avpair_t *getMetadataViaIndex(subscription_handle_t handle, uint8_t _index, uint8_t *valueSize);

  /**
   * Reserves space for an attribute-value pair in a notification.
   * If this call succeeds, the caller can modify the content of this
   * attribute-value pair.
   * @param handle     the notification 
   * @param valueSize  the size (in byte) to reserve for the attribute's value portion
   * @return           a pointer to the attribute-value pair or NULL if the  
   *                   allocation failed 
   */  
  command avpair_t* allocateAttribute(notification_handle_t handle, uint8_t valueSize);
  /**
   * Reserves space for a constraint in a subscription.
   * If this call succeeds, the caller can modify the content of this
   * constraint.
   * @param handle     the subscription 
   * @param valueSize  the size (in byte) to reserve for the constraint's value portion
   * @return           a pointer to the constraint or NULL if the  
   *                   allocation failed 
   */  
  command constraint_t* allocateConstraint(subscription_handle_t handle, uint8_t valueSize);
  /**
   * Reserves space for a metadata item in a subscription.
   * If this call succeeds, the caller can modify the content of this
   * metadata item.
   * @param handle     the subscription 
   * @param valueSize  the size (in byte) to reserve for the metadata's value portion
   * @return           a pointer to the metadata or NULL if the  
   *                   allocation failed 
   */  
  command avpair_t* allocateMetadata(subscription_handle_t handle, uint8_t valueSize);  
}
