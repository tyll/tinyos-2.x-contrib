/*
 * WMTP - Wireless Modular Transport Protocol
 *
 * Copyright (c) 2008 Luis D. Pedrosa and IT - Instituto de Telecomunicacoes
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Address:
 * Instituto Superior Tecnico - Taguspark Campus
 * Av. Prof. Dr. Cavaco Silva, 2744-016 Porto Salvo
 *
 * E-Mail:
 * luis.pedrosa@tagus.ist.utl.pt
 */

/**
 * Special interface provided by the Tag Router.
 *
 * Special interface allows connection establishment handlers to add Tag
 * associations.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpTagRouter {
    /**
     * Adds a new tag association.
     *
     * @param PreviousAddress The previous address.
     * @param PreviousTag The previous tag.
     * @param NextAddress The next address.
     * @param NextTag The next tag.
     * @param ConnectionSpecification The connection specification that
     *                                identifies the associated connection.
     * @param ActivationTimeOut Number of milliseconds to wait for the cnnection
     *                          to be activated, after which the tag association
     *                          may be dropped.
     * @param UsageTimeOut Number of milliseconds of inactivity after which the
     *                     tag association may be dropped.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t AddTagAssociation( uint16_t PreviousAddress, uint8_t PreviousTag, uint16_t NextAddress, uint8_t NextTag, WmtpConnectionSpecification_t *ConnectionSpecification, uint32_t ActivationTimeOut, uint32_t UsageTimeOut );


    /**
     * Gets a new unused tag for communication with a specified address.
     *
     * @param Address The address to communicate with.
     * @param Tag Variable to be filled in with the new tag.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetNewTag( uint16_t Address, uint8_t *Tag );


    /**
     * Removes a previously existing a tag association.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identifies the associated connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t DropTagAssociation( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Notifies that a tag association has been activated (used for the first
     * time).
     *
     * @param ConnectionSpecification The association's connection specification
     *                                that identifies the associated connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t TagAssociationActivated( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Notifies that a tag association has timed out before being activated and
     * was dropped.
     *
     * @param ConnectionSpecification The association's connection specification
     *                                that identifies the associated connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t TagAssociationTimedOut( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Notifies that a tag association has timed out after it was activated and
     * was dropped.
     *
     * @param ConnectionSpecification The association's connection specification
     *                                that identifies the associated connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t TagAssociationDropped( WmtpConnectionSpecification_t *ConnectionSpecification );
}
