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
 * WMTP Tag Multihop router.
 *
 * This component implements the Tag multihop router, this router is the basis
 * of all connection oriented services.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

#define MAX_TAG_ASSOCIATIONS 10

module WmtpTagRouterP {
    provides {
        interface Init;
        interface WmtpMultihopRouter;
        interface WmtpTagRouter;
    }
    uses {
        //interface Time;
        //interface TimeUtil;
        //interface AbsoluteTimer;
        interface Timer<TMilli>;

        interface Queue<TagAssociation_t *> as IdleTagAssociationsQueue;
        interface Queue<TagAssociation_t *> as ActiveTagAssociationsQueue;
    }
} implementation {
    TagAssociation_t TagAssociationBuffers[MAX_TAG_ASSOCIATIONS];


    /**
     * Initializes the module.
    **/

    command error_t Init.init() {
        unsigned char i;

        for ( i = 0; i < MAX_TAG_ASSOCIATIONS; i++ )
            call IdleTagAssociationsQueue.enqueue( &TagAssociationBuffers[i] );

        return SUCCESS;
    }

    void DeactivateTag( TagAssociation_t *TagAssociation ) {
        TagAssociation_t *ptr;
        uint8_t i = 0;

        ptr = call ActiveTagAssociationsQueue.dequeue();
        if ( call ActiveTagAssociationsQueue.empty() ) return;

        for (; i < call ActiveTagAssociationsQueue.size() ; i++) {
            if ( ptr == TagAssociation ) return;

            call ActiveTagAssociationsQueue.enqueue( ptr );
            ptr = call ActiveTagAssociationsQueue.dequeue();
        }

        call ActiveTagAssociationsQueue.enqueue( ptr );
    }

    void processTimers() {
        TagAssociation_t *i;
        uint32_t curTime = call Timer.getNow();
        uint32_t *nextTimer = NULL;
        uint8_t e = 0;

        // Iterate through all tag associations.

        if ( ! call ActiveTagAssociationsQueue.empty() ) {
            do {
                uint8_t dropTA = FALSE;

                i = call ActiveTagAssociationsQueue.element( e++ );
                // Check if the tag association has expired.
                if ( curTime >= i->TimeOutTime ) {
                    dbg( "WMTP", "WmtpTagRouterP: Dropping tag association (%d:%d)<->(%d:%d).\n", i->PreviousAddress, i->PreviousTag, i->NextAddress, i->NextTag );

                    if ( i->Activated )
                        signal WmtpTagRouter.TagAssociationDropped( i->ConnectionSpecification );
                    else
                        signal WmtpTagRouter.TagAssociationTimedOut( i->ConnectionSpecification );

                    dropTA = TRUE;
                }

                if ( dropTA ) {
                    //LinkedLists_removeElement( &activeTagAssociations, &(tmp->element) );
                    //LinkedLists_insertElementBeginning( &idleTagAssociations, &(tmp->element) );
                    DeactivateTag( i );
                    call IdleTagAssociationsQueue.enqueue( i );

                    if ( e == 1 ) {
                        e = 0;
                    }
                    if ( call ActiveTagAssociationsQueue.empty() )
                        break;
                }
            } while ( e < call ActiveTagAssociationsQueue.size() );
        }

        // Cancel any previous timer.
        call Timer.stop();

        // Iterate through all tag associations.

        if ( ! call ActiveTagAssociationsQueue.empty() ) {
            e = 0;
            do {
                i = call ActiveTagAssociationsQueue.element( e++ );
                // Check if the next timer has already been defined.
                if ( nextTimer == NULL ) {
                    // Define it.
                    nextTimer = &(i->TimeOutTime);
                } else {
                    // Check if we've found a new timer that's earlier.
                    if ( *nextTimer > i->TimeOutTime )
                        nextTimer = &(i->TimeOutTime);
                }

            } while ( e < call ActiveTagAssociationsQueue.size() );

            call Timer.startOneShot( *nextTimer - call Timer.getNow() );
        }
    }


    event void Timer.fired() {
        processTimers();
    }


    command error_t WmtpMultihopRouter.GetNextHop( uint16_t SourceAddress, void *RoutingData, uint8_t *RoutingDataSize, uint16_t *Address, WmtpConnectionSpecification_t **ConnectionSpecification ) {
        WmtpTagRouterData_t *TagRouterData = (WmtpTagRouterData_t *) RoutingData;
        TagAssociation_t *i;
        uint8_t e = 0;

        // Routing header has a constant size.
        *RoutingDataSize = sizeof( WmtpTagRouterData_t );

        // Check if we should generate an inicial untranslated header first.
        if ( SourceAddress == TOS_NODE_ID )
            TagRouterData->Tag = (*ConnectionSpecification)->RouterSpecification.RouterData.TagRouter.OutgoingTag;

        // Get tag associations.

        // Check if there were any tag associations.
        if ( ! call ActiveTagAssociationsQueue.empty() ) {
            // Iterate through all tag associations.
            do {
                i = call ActiveTagAssociationsQueue.element( e++ );
                // Check if we found a match.
                if ( (i->PreviousAddress == SourceAddress && i->PreviousTag == TagRouterData->Tag) ) {
                    if ( ! i->Activated ) {
                        i->Activated = TRUE;

                        signal WmtpTagRouter.TagAssociationActivated( i->ConnectionSpecification );
                    }

                    // Get the associated parameters and translate the tag.
                    *Address = i->NextAddress;
                    TagRouterData->Tag = i->NextTag;
                    *ConnectionSpecification = i->ConnectionSpecification;

                    // Reset timeout timer and process timers.
                    i->TimeOutTime = call Timer.getNow() + i->UsageTimeOut;
                    processTimers();

                    return SUCCESS;
                }
                if ( (i->NextAddress == SourceAddress && i->NextTag == TagRouterData->Tag) ) {
                    if ( ! i->Activated ) {
                        i->Activated = TRUE;

                        signal WmtpTagRouter.TagAssociationActivated( i->ConnectionSpecification );
                    }

                    // Get the associated parameters and translate the tag.
                    *Address = i->PreviousAddress;
                    TagRouterData->Tag = i->PreviousTag;
                    *ConnectionSpecification = i->ConnectionSpecification;

                    // Reset timeout timer and process timers.
                    i->TimeOutTime = call Timer.getNow() + i->UsageTimeOut;
                    processTimers();

                    return SUCCESS;
                }

            } while ( e < call ActiveTagAssociationsQueue.size() );

            return FAIL;
        } else { // No registered tag associations.
            return FAIL;
        }
    }


    command error_t WmtpTagRouter.AddTagAssociation( uint16_t PreviousAddress, uint8_t PreviousTag, uint16_t NextAddress, uint8_t NextTag, WmtpConnectionSpecification_t *ConnectionSpecification, uint32_t ActivationTimeOut, uint32_t UsageTimeOut ) {
        // Check if any idle tag associations were available.
        if ( ! call IdleTagAssociationsQueue.empty() ) {
            // Get an idle tag association
            //TagAssociation_t *TA = LinkedLists_removeFirstElement( &idleTagAssociations );
            TagAssociation_t *TA = call IdleTagAssociationsQueue.dequeue();

            dbg( "WMTP", "WmtpTagRouterP: Adding tag association (%d:%d)<->(%d:%d).\n", PreviousAddress, PreviousTag, NextAddress, NextTag );

            // Fill in tag association.
            TA->PreviousAddress = PreviousAddress;
            TA->PreviousTag = PreviousTag;
            TA->NextAddress = NextAddress;
            TA->NextTag = NextTag;
            TA->ConnectionSpecification = ConnectionSpecification;
            TA->UsageTimeOut = UsageTimeOut;
            TA->TimeOutTime = call Timer.getNow() + ActivationTimeOut;
            TA->Activated = FALSE;

            // Add it to the list of active associations.
            //LinkedLists_insertElementBeginning( &activeTagAssociations, &(TA->element) );
            call ActiveTagAssociationsQueue.enqueue( TA );

            // Process time out timers.
            processTimers();

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpTagRouter.GetNewTag( uint16_t Address, uint8_t *Tag ) {
        TagAssociation_t *i;
        uint8_t tempTag = 0;
        uint8_t matchFound, e = 0;

        // Get tag associations.

        // Check if there were any tag associations.
        if ( ! call ActiveTagAssociationsQueue.empty() ) {
            // Iterate through all possible tag values.
            do {
                matchFound = FALSE;
                // Iterate through all tag associations.
                do {
                    i = call ActiveTagAssociationsQueue.element( e++ );
                    // Check if we found a match.
                    if ( (i->PreviousAddress == Address && i->PreviousTag == tempTag) ||
                            (i->NextAddress == Address && i->NextTag == tempTag) ) {
                        matchFound = TRUE;
                        break;
                    }

                } while ( e < call ActiveTagAssociationsQueue.size() );

                if ( ! matchFound ) {
                    // Found unused tag.
                    *Tag = tempTag;

                    return SUCCESS;
                }
                e = 0;
            } while ( tempTag++ < 255 );

            // All tags are used.
            return FAIL;
        } else { // No registered tag associations.
            *Tag = 0;

            return SUCCESS;
        }
    }


    command error_t WmtpTagRouter.DropTagAssociation( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        TagAssociation_t *i;
        uint8_t e = 0;

        // Get tag associations.

        // Check if there were any tag associations.
        if ( ! call ActiveTagAssociationsQueue.empty() ) {
            // Iterate through all tag associations.
            do {
                i = call ActiveTagAssociationsQueue.element( e++ );
                // Check if we found a match.
                if ( i->ConnectionSpecification == ConnectionSpecification ) {
                    //LinkedLists_removeElement( &activeTagAssociations, &(i->element) );
                    //LinkedLists_insertElementBeginning( &idleTagAssociations, &(i->element) );
                    DeactivateTag( i );
                    call IdleTagAssociationsQueue.enqueue( i );

                    return SUCCESS;
                }
            } while ( e < call ActiveTagAssociationsQueue.size() );
            // No match found.
            return FAIL;
        } else { // No registered tag associations.
            return FAIL;
        }
    }
}
