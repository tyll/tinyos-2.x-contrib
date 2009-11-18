/*
* Copyright (c) 2009 GTI/TC-1 Research Group.  Universidade de Vigo.
*                    Gradiant (www.gradiant.org)
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
* - Neither the name of Universidade de Vigo nor the names of its
*   contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
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
*
* - Revision -------------------------------------------------------------
* $Revision$
* $Date$
* @author Daniel F. Piñeiro-Santos <danips@enigma.det.uvigo.es>
* @author Felipe Gil-Castiñeira <xil@det.uvigo.es>
* @author David Chaves-Diéguez <dchaves@gradiant.org>
* ========================================================================
*/

#ifndef NWK_H
#define NWK_H

#include "AppProfile.h"
#include "Nwk_MicaZ.h"
#include "TKN154.h"

/**************************************************
 * Zigbee Network Layer Enumerations
 **************************************************/

typedef enum nwk_status {
  //NWK Layer Status Values
  NWK_SUCCESS                = 0x00,
  NWK_INVALID_PARAMETER      = 0xC1,
  NWK_INVALID_REQUEST        = 0xC2,
  NWK_NOT_PERMITTED          = 0xC3,
  NWK_STARTUP_FAILURE        = 0xC4,
  NWK_ALREADY_PRESENT        = 0xC5,
  NWK_SYNC_FAILURE           = 0xC6,
  NWK_NEIGHBOR_TABLE_FULL    = 0xC7,
  NWK_UNKNOWN_DEVICE         = 0xC8,
  NWK_UNSUPPORTED_ATTRIBUTE  = 0xC9,
  NWK_NO_NETWORKS            = 0xCA,
  NWK_MAX_FRM_COUNTER        = 0xCC,
  NWK_NO_KEY                 = 0xCD,
  NWK_BAD_CCM_OUTPUT         = 0xCE,
  NWK_NO_ROUTING_CAPACITY    = 0xCF,
  NWK_ROUTE_DISCOVERY_FAILED = 0xD0,
  NWK_ROUTE_ERROR            = 0xD1,
  NWK_BT_TABLE_FULL          = 0xD2,
  NWK_FRAME_NOT_BUFFERED     = 0xD3
} nwk_status_t;

typedef enum route_status {
  //Route Status Values
  NWK_ACTIVE              = 0x0,
  NWK_DISCOVERY_UNDERWAY  = 0x1,
  NWK_DISCOVERY_FAILED    = 0x2,
  NWK_INACTIVE            = 0x3,
  NWK_VALIDATION_UNDERWAY = 0x4
} route_status_t;

typedef enum nwk_status_failure {
  NWK_FAILURE_NO_ROUTE_AVAILABLE            = 0x00,
  NWK_FAILURE_TREE_LINK_FAILURE             = 0x01,
  NWK_FAILURE_NON_TREE_LINK_FAILURE         = 0x02,
  NWK_FAILURE_LOW_BATTERY_LEVEL             = 0x03,
  NWK_FAILURE_NO_ROUTING_CAPACITY           = 0x04,
  NWK_FAILURE_NO_INDIRECT_CAPACITY          = 0x05,
  NWK_FAILURE_INDIRECT_TRANSACTION_EXPIRITY = 0x06,
  NWK_FAILURE_TARGET_DEVICE_UNVAILABLE      = 0x07,
  NWK_FAILURE_TARGET_ADDRESS_UNALLOCATED    = 0x08,
  NWK_FAILURE_PARENT_LINK_FAILURE           = 0x09,
  NWK_FAILURE_VALIDATE_ROUTE                = 0x0A,
  NWK_FAILURE_SOURCE_ROUTE_FAILURE          = 0x0B,
  NWK_FAILURE_MANY_TO_ONE_ROUTE_FAILURE     = 0x0C,
  NWK_FAILURE_ADDRESS_CONFLICT              = 0x0D,
  NWK_FAILURE_VERIFY_ADDRESSES              = 0x0E,
  NWK_FAILURE_PAN_IDENTIFIER_UPDATE         = 0x0F,
  NWK_FAILURE_NETWORK_ADDRESS_UPDATE        = 0x10,
  NWK_FAILURE_BAD_FRAME_COUNTER             = 0x11,
  NWK_FAILURE_BAD_KEY_SEQUENCE_NUMBER       = 0x12,
} nwk_status_failure_t;

enum {
  // NWK Layer Constants
  nwkcCoordinatorCapable   = NWK_PROFILE_nwkcCoordinatorCapable,//***
  nwkcDefaultSecurityLevel = NWK_PROFILE_nwkcDefaultSecurityLevel,//***
  nwkcDiscoveryRetryLimit  = 0x03,
  nwkcMinHeaderOverhead    = 0x08,
  nwkcProtocolVersion      = 0x02,
  nwkcWaitBeforeValidation = 0x500,
  nwkcRouteDiscoveryTime   = 0x2710,
  nwkcMaxBroadcastJitter   = 0x40,
  nwkcInitialRREQRetries   = 0x03,
  nwkcRREQRetries          = 0x02,
  nwkcRREQRetryInterval    = 0xFE,
  nwkcMinRREQJitter        = 0x01,
  nwkcMaxRREQJitter        = 0x40,
  nwkcMACFrameOverhead     = 0x0B
};

enum {
  // NIB Attributes Ids
  nwkPANId                          = 0x80,
  nwkSequenceNumber                 = 0x81,
  nwkPassiveAckTimeout              = 0x82,
  nwkMaxBroadcastRetries            = 0x83,
  nwkMaxChildren                    = 0x84,
  nwkMaxDepth                       = 0x85,
  nwkMaxRouters                     = 0x86,
  nwkNeighborTable                  = 0x87,
  nwkNetworkBroadcastDeliveryTime   = 0x88,
  nwkReportConstantCost             = 0x89,
  nwkRouteDiscoveryRetriesPermitted = 0x8A,
  nwkRouteTable                     = 0x8B,
  nwkTimeStamp                      = 0x8C,
  nwkTxTotal                        = 0x8D,
  nwkSymLink                        = 0x8E,
  nwkCapabilityInformation          = 0x8F,
  nwkAddrAlloc                      = 0x90,
  nwkUseTreeRouting                 = 0x91,
  nwkManagerAddr                    = 0x92,
  nwkMaxSourceRoute                 = 0x93,
  nwkUpdateId                       = 0x94,
  nwkTransactionPersistenceTime     = 0x95,
  nwkNetworkAddress                 = 0x96,
  nwkStackProfile                   = 0x97,
  nwkBroadcastTransactionTable      = 0x98,
  nwkGroupIDTable                   = 0x99,
  nwkExtendedPANId                  = 0x9A,
  nwkUseMulticast                   = 0x9B,
  nwkRouteRecordTable               = 0x9C,
  nwkIsConcentrator                 = 0x9D,
  nwkConcentratorRadius             = 0x9E,
  nwkConcentratorDiscoveryTime      = 0x9F,
  nwkSecurityLevel                  = 0xA0,
  nwkSecurityMaterialSet            = 0xA1,
  nwkActiveKeySeqNumber             = 0xA2,
  nwkAllFresh                       = 0xA3,
  nwkSecureAllFrames                = 0xA5,
  nwkLinkStatusPeriod               = 0xA6,
  nwkRouterAgeLimit                 = 0xA7,
  nwkUniqueAddr                     = 0xA8,
  nwkAddressMap                     = 0xA9
};

typedef enum nwk_device_type {
  //NWK type of neighbor device
  NWK_ZIGBEE_COORDINATOR = 0x00,
  NWK_ZIGBEE_ROUTER      = 0x01,
  NWK_ZIGBEE_END_DEVICE  = 0x02,
} nwk_device_type_t;

typedef enum nwk_relationship {
  //NWK relationship between neighbor and device
  NWK_NEIGHBOR_IS_PARENT     = 0x00,
  NWK_NEIGHBOR_IS_CHILD      = 0x01,
  NWK_NEIGHBOR_IS_SIBLING    = 0x02,
  NWK_NONE_OF_ABOVE          = 0x03,
  NWK_PREVIOUS_CHILD         = 0x04,
  NWK_UNAUNTHENTICATED_CHILD = 0x05,
} nwk_relationship_t;

/*
 * Typedefs NIB value types
 */
typedef uint16_t nwkPANId_t;
typedef uint8_t  nwkSequenceNumber_t;
typedef uint16_t nwkPassiveAckTimeout_t;
typedef uint8_t  nwkMaxBroadcastRetries_t;
typedef uint8_t  nwkMaxChildren_t;
typedef uint8_t  nwkMaxDepth_t;
typedef uint8_t  nwkMaxRouters_t;
typedef ieee154_CapabilityInformation_t nwkCapabilityInformation_t;
typedef struct {
  bool               used;

  uint64_t           ExtendedAddress;//Mandatory
  uint16_t           NetworkAddress;//Mandatory
  nwk_device_type_t  DeviceType;//Mandatory
  bool               RxOnWhenIdle;
  nwk_relationship_t Relationship;//Mandatory
  uint8_t            TransmitFailure;//Mandatory
  uint8_t            LQI;//Mandatory
  uint8_t            OutgoingCost;//Mandatory if nwkSymLink == TRUE
  uint8_t            Age;//Mandatory if nwkSymLink == TRUE
  //  uint32_t           IncomingBeaconTimestamp;//Optional
  //  uint32_t           BeaconTransmissionTimeOffset;//Optional

  //Additional Neighbor Table Fields
  uint64_t           ExtendedPANId;
  uint8_t            LogicalChannel;
  uint8_t            Depth;
  uint8_t            BeaconOrder;
  bool               PermitJoining;
  uint8_t            PotentialParent;

  uint8_t            StackProfile;
  bool               RouterCapacity;
  bool               EndDeviceCapacity;
  uint8_t            nwkUpdateId;
  uint16_t           PANId;
  nwkCapabilityInformation_t CapabilityInfo;//has RxOnWhenIdle and DeviceType!
} nwkNeighborTable_t;//***
typedef uint8_t  nwkNetworkBroadcastDeliveryTime_t;
typedef uint8_t  nwkReportConstantCost_t;
typedef uint8_t  nwkRouteDiscoveryRetriesPermitted_t;
typedef struct {
  uint16_t        DestinationAddress;
  route_status_t  Status;
  bool            NoRouteCache;
  bool            ManyToOne;
  bool            RouteRecordRequired;
  bool            GroupIDFlag;
  uint8_t         NextHopAddress;
} nwkRouteTable_t;//***
typedef bool     nwkTimeStamp_t;
typedef uint16_t nwkTxTotal_t;
typedef bool     nwkSymLink_t;
typedef uint8_t  nwkAddrAlloc_t;
typedef bool     nwkUseTreeRouting_t;
typedef uint16_t nwkManagerAddr_t;
typedef uint8_t  nwkMaxSourceRoute_t;
typedef uint8_t  nwkUpdateId_t;
typedef uint16_t nwkTransactionPersistenceTime_t;
typedef uint16_t nwkNetworkAddress_t;
typedef uint8_t  nwkStackProfile_t;
typedef struct {
  uint16_t SourceAddress;
  uint8_t SequenceNumber;
  uint8_t ExpirationTime;
} nwkBroadcastTransactionTable_t;//***
typedef uint16_t nwkGroupIDTable_t;//***
typedef uint64_t nwkExtendedPANId_t;
typedef bool     nwkUseMulticast_t;
typedef struct {
  uint16_t  NetworkAddress;
  uint16_t  RelayCount;
  uint16_t  Path[NWK_ROUTE_TABLE_PATH_SIZE];
} nwkRouteRecordTable_t;//***
typedef bool     nwkIsConcentrator_t;
typedef uint8_t  nwkConcentratorRadius_t;
typedef uint8_t  nwkConcentratorDiscoveryTime_t;
typedef enum {
  None        = 0x00,//No security implemented, always None-0x00
  MIC_32      = 0x01,
  MIC_64      = 0x02,
  MIC_128     = 0x03,
  ENC         = 0x04,
  ENC_MIC_32  = 0x05,
  ENC_MIC_64  = 0x06,
  ENC_MIC_128 = 0x07
} nwkSecurityLevel_t;//***// Security Attribute
//typedef uint8_t  nwkSecurityMaterialSet_t;//***// Security Attribute
//typedef uint_t   nwkActiveKeySeqNumber_t;//***// Security Attribute
//typedef uint_t   nwkAllFresh_t;//***// Security Attribute
//typedef uint_t   nwkSecureAllFrames_t;//*** Security Attribute
typedef uint8_t  nwkLinkStatusPeriod_t;
typedef uint8_t  nwkRouterAgeLimit_t;
typedef bool     nwkUniqueAddr_t;
typedef struct {
  uint64_t IeeeAddress64bit;
  uint16_t NetworkAddress16bit;
} nwkAddressMap_t;//***


/*
 * Network information base (NIB)
 */
typedef struct {
  nwkPANId_t                          nwkPANId;
  nwkSequenceNumber_t                 nwkSequenceNumber;
  nwkPassiveAckTimeout_t              nwkPassiveAckTimeout;
  nwkMaxBroadcastRetries_t            nwkMaxBroadcastRetries;
  nwkMaxChildren_t                    nwkMaxChildren;
  nwkMaxDepth_t                       nwkMaxDepth;
  nwkMaxRouters_t                     nwkMaxRouters;
  nwkNeighborTable_t                  nwkNeighborTable[NWK_NEIGHBOR_TABLE_SIZE];//***
  nwkNetworkBroadcastDeliveryTime_t   nwkNetworkBroadcastDeliveryTime;
  nwkReportConstantCost_t             nwkReportConstantCost;
  nwkRouteDiscoveryRetriesPermitted_t nwkRouteDiscoveryRetriesPermitted;
  nwkRouteTable_t                     nwkRouteTable[NWK_ROUTE_TABLE_SIZE];//***
  nwkTimeStamp_t                      nwkTimeStamp;
  nwkTxTotal_t                        nwkTxTotal;
  nwkSymLink_t                        nwkSymLink;
  nwkCapabilityInformation_t          nwkCapabilityInformation;
  nwkAddrAlloc_t                      nwkAddrAlloc;
  nwkUseTreeRouting_t                 nwkUseTreeRouting;
  nwkManagerAddr_t                    nwkManagerAddr;
  nwkMaxSourceRoute_t                 nwkMaxSourceRoute;
  nwkUpdateId_t                       nwkUpdateId;
  nwkTransactionPersistenceTime_t     nwkTransactionPersistenceTime;
  nwkNetworkAddress_t                 nwkNetworkAddress;
  nwkStackProfile_t                   nwkStackProfile;
  nwkBroadcastTransactionTable_t      nwkBroadcastTransactionTable[NWK_BROADCAST_TRANSACTION_TABLE_SIZE];//***
  nwkGroupIDTable_t                   nwkGroupIDTable[NWK_GROUP_ID_TABLE_SIZE];//***
  nwkExtendedPANId_t                  nwkExtendedPANId;
  nwkUseMulticast_t                   nwkUseMulticast;
  nwkRouteRecordTable_t               nwkRouteRecordTable[NWK_ROUTE_RECORD_TABLE_SIZE];//***
  nwkIsConcentrator_t                 nwkIsConcentrator;
  nwkConcentratorRadius_t             nwkConcentratorRadius;
  nwkConcentratorDiscoveryTime_t      nwkConcentratorDiscoveryTime;
  nwkSecurityLevel_t                  nwkSecurityLevel;//***// Security Attribute
  //  nwkSecurityMaterialSet_t nwkSecurityMaterialSet;//***// Security Attribute
  //  nwkActiveKeySeqNumber_t nwkActiveKeySeqNumber;//***// Security Attribute
  //  nwkAllFresh_t nwkAllFresh;//***// Security Attribute
  //  nwkSecureAllFrames_t nwkSecureAllFrames;//***// Security Attribute
  nwkLinkStatusPeriod_t               nwkLinkStatusPeriod;
  nwkRouterAgeLimit_t                 nwkRouterAgeLimit;
  nwkUniqueAddr_t                     nwkUniqueAddr;
  nwkAddressMap_t                     nwkAddressMap[NWK_ADDRESS_MAP_SIZE];//***
} NIB_t;

//NIB Defaults
#ifndef NWK_DEFAULT_nwkPANId
  #define NWK_DEFAULT_nwkPANId                          0xFFFF
#endif
//  NWK_DEFAULT_nwkSequenceNumber                 = 0x81,
//  NWK_DEFAULT_nwkPassiveAckTimeout              = 0x82,
#ifndef NWK_DEFAULT_nwkMaxBroadcastRetries
  #define NWK_DEFAULT_nwkMaxBroadcastRetries            0x03
#endif
//  NWK_DEFAULT_nwkMaxChildren                    = 0x84,
//  NWK_DEFAULT_nwkMaxDepth                       = 0x85,
//  NWK_DEFAULT_nwkMaxRouters                     = 0x86,
#ifndef NWK_DEFAULT_nwkNeighborTable
  #define NWK_DEFAULT_nwkNeighborTable                  NULL
#endif
//  NWK_DEFAULT_nwkNetworkBroadcastDeliveryTime   = 0x88,
#ifndef NWK_PROFILE_nwkNetworkBroadcastDeliveryTime
  #define NWK_PROFILE_nwkNetworkBroadcastDeliveryTime   (nwkNetworkBroadcastDeliveryTime_t)(2 * nib.nwkMaxDepth * ((0.05 + (nwkcMaxBroadcastJitter / 2)) + nib.nwkPassiveAckTimeout * nib.nwkMaxBroadcastRetries / 1000))
#endif
#ifndef NWK_DEFAULT_nwkReportConstantCost
  #define NWK_DEFAULT_nwkReportConstantCost             0x00
#endif
#ifndef NWK_DEFAULT_nwkRouteDiscoveryRetriesPermitted
  #define NWK_DEFAULT_nwkRouteDiscoveryRetriesPermitted nwkcDiscoveryRetryLimit
#endif
#ifndef NWK_DEFAULT_nwkRouteTable
  #define NWK_DEFAULT_nwkRouteTable                     NULL
#endif
#ifndef NWK_DEFAULT_nwkTimeStamp
  #define NWK_DEFAULT_nwkTimeStamp                      FALSE
#endif
#ifndef NWK_DEFAULT_nwkTxTotal
  #define NWK_DEFAULT_nwkTxTotal                        0
#endif
#ifndef NWK_DEFAULT_nwkSymLink
  #define NWK_DEFAULT_nwkSymLink                        FALSE
#endif
#ifndef NWK_DEFAULT_nwkCapabilityInformation
  #define NWK_DEFAULT_nwkCapabilityInformation          0x00
#endif
#ifndef NWK_DEFAULT_nwkAddrAlloc
  #define NWK_DEFAULT_nwkAddrAlloc                      0x00
#endif
#ifndef NWK_DEFAULT_nwkUseTreeRouting
  #define NWK_DEFAULT_nwkUseTreeRouting                 TRUE
#endif
#ifndef NWK_DEFAULT_nwkManagerAddr
  #define NWK_DEFAULT_nwkManagerAddr                    0x0000
#endif
#ifndef NWK_DEFAULT_nwkMaxSourceRoute
  #define NWK_DEFAULT_nwkMaxSourceRoute                 0x0C
#endif
#ifndef NWK_DEFAULT_nwkUpdateId
  #define NWK_DEFAULT_nwkUpdateId                       0x00
#endif
#ifndef NWK_DEFAULT_nwkTransactionPersistenceTime
  #define NWK_DEFAULT_nwkTransactionPersistenceTime     0x01F4
#endif
#ifndef NWK_DEFAULT_nwkNetworkAddress
  #define NWK_DEFAULT_nwkNetworkAddress                 0xFFFF
#endif
//  NWK_DEFAULT_nwkStackProfile                   = 0x97,
#ifndef NWK_DEFAULT_nwkBroadcastTransactionTable
  #define NWK_DEFAULT_nwkBroadcastTransactionTable      NULL
#endif
#ifndef NWK_DEFAULT_nwkGroupIDTable
  #define NWK_DEFAULT_nwkGroupIDTable                   NULL
#endif
#ifndef NWK_DEFAULT_nwkExtendedPANId
  #define NWK_DEFAULT_nwkExtendedPANId                  0x0000000000000000
#endif
#ifndef NWK_DEFAULT_nwkUseMulticast
  #define NWK_DEFAULT_nwkUseMulticast                   TRUE
#endif
#ifndef NWK_DEFAULT_nwkRouteRecordTable
  #define NWK_DEFAULT_nwkRouteRecordTable               NULL
#endif
#ifndef NWK_DEFAULT_nwkIsConcentrator
  #define NWK_DEFAULT_nwkIsConcentrator                 FALSE
#endif
#ifndef NWK_DEFAULT_nwkConcentratorRadius
  #define NWK_DEFAULT_nwkConcentratorRadius             0x0000
#endif
#ifndef NWK_DEFAULT_nwkConcentratorDiscoveryTime
  #define NWK_DEFAULT_nwkConcentratorDiscoveryTime      0x0000
#endif
#ifndef NWK_DEFAULT_nwkSecurityLevel
  #define NWK_DEFAULT_nwkSecurityLevel                  0x00
#endif
//  NWK_DEFAULT_nwkSecurityMaterialSet            = 0xA1,
//  NWK_DEFAULT_nwkActiveKeySeqNumber             = 0xA2,
//  NWK_DEFAULT_nwkAllFresh                       = 0xA3,
//  NWK_DEFAULT_nwkSecureAllFrames                = 0xA5,
#ifndef NWK_DEFAULT_nwkLinkStatusPeriod
  #define NWK_DEFAULT_nwkLinkStatusPeriod               0x0F
#endif
#ifndef NWK_DEFAULT_nwkRouterAgeLimit
  #define NWK_DEFAULT_nwkRouterAgeLimit                 3
#endif
#ifndef NWK_DEFAULT_nwkUniqueAddr
  #define NWK_DEFAULT_nwkUniqueAddr                     TRUE
#endif
#ifndef NWK_DEFAULT_nwkAddressMap
  #define NWK_DEFAULT_nwkAddressMap                     NULL
#endif


/**************************************************
 * Zigbee Network Frame (NPDU)
 **************************************************/
typedef nx_struct {
  nxle_uint16_t FrameType              :2;
  nxle_uint16_t ProtocolVersion        :4;
  nxle_uint16_t DiscoverRoute          :2;
  nxle_uint16_t MulticastFlag          :1;
  nxle_uint16_t Security               :1;
  nxle_uint16_t SourceRoute            :1;
  nxle_uint16_t DestinationIEEEAddress :1;
  nxle_uint16_t SourceIEEEAddress      :1;
  nxle_uint16_t Reserved               :2;
} nwk_frameControlField;

typedef nx_struct nwk_header_common_t {
  nwk_frameControlField FrameControl;
  //  nxle_uint16_t FrameControl;
  nxle_uint16_t DestinationAddress;
  nxle_uint16_t SourceAddress;
  nxle_uint8_t  Radius;
  nxle_uint8_t  SequenceNumber;

  //  0 - nxle_uint64_t DestinationIEEEAddress;
  //  0 - nxle_uint64_t SourceIEEEAddress;
  //  0 - nxle_uint8_t  MulticastControl;
  //  nxle_uint??_t SourceRouteSubframe;
} nwk_header_common_t;

typedef nx_struct {
  nxle_uint8_t CommandIdentifier;
  nx_struct {
    nxle_uint8_t Reserved       :5;
    nxle_uint8_t Rejoin         :1;
    nxle_uint8_t Request        :1;
    nxle_uint8_t RemoveChildren :1;
  } LeaveCommandOptionsField;
} nwk_frame_leave_t;

typedef nx_struct {
  nxle_uint8_t CommandIdentifier;
  nxle_uint16_t NetworkAddress;
  nxle_uint8_t RejoinStatus;
} nwk_frame_rejoin_response;

enum {
  NWK_FCF_FRAME_TYPE_MASK = 0x0003,
  NWK_FCF_PROTOCOL_VERSION_MASK = 0x003C,
  NWK_FCF_DISCOVER_ROUTE_MASK = 0x00C0,
  NWK_FCF_MULTICAST_FLAG_MASK = 0x0100,
  NWK_FCF_SECURITY_MASK = 0x0200,
  NWK_FCF_SOURCE_ROUTE_MASK = 0x0400,
  NWK_FCF_DESTINATION_IEEE_ADDRESS_MASK = 0x0800,
  NWK_FCF_SOURCE_IEEE_ADDRESS_MASK = 0x1000,

  NWK_FRAME_TYPE_DATA = 0x0,
  NWK_FRAME_TYPE_COMMAND = 0x1,

  NWK_DISCOVER_ROUTE_SUPRESS = 0x0,
  NWK_DISCOVER_ROUTE_ENABLE = 0x1,
  
  NWK_MCF_MULTICAST_MODE_MASK = 0x03,
  NWK_MCF_NONMEMBERRADIUS_MASK = 0x1C,
  NWK_MCF_MAXNONMEMBERRADIUS_MASK = 0xE0,
  
  NWK_MULTICAST_MODE_NON_MEMBER_MODE = 0x0,
  NWK_MULTICAST_MODE_MEMBER_MODE = 0x1,
  
  
};

typedef enum nwk_command_frame {
  NWK_ROUTE_REQUEST   = 0x01,
  NWK_ROUTE_REPLY     = 0x02,
  NWK_NETWORK_STATUS  = 0x03,
  NWK_LEAVE           = 0x04,
  NWK_ROUTE_RECORD    = 0x05,
  NWK_REJOIN_REQUEST  = 0x06,
  NWK_REJOIN_RESPONSE = 0x07,
  NWK_LINK_STATUS     = 0x08,
  NWK_NETWORK_REPORT  = 0x09,
  NWK_NETWORK_UPDATE  = 0x0A,
} nwk_command_frame_t;

/**************************************************
 * Zigbee Network Beacon Payload
 **************************************************/
typedef nx_struct {
  nxle_uint8_t  ProtocolID          :8;
  nxle_uint8_t  StackProfile        :4;
  nxle_uint8_t  nwkcProtocolVersion :4;
  nxle_uint8_t  Reserved            :2;
  nxle_uint8_t  RouterCapacity      :1;
  nxle_uint8_t  DeviceDepth         :4;
  nxle_uint8_t  EndDeviceCapacity   :1;
  nxle_uint64_t nwkExtendedPANId   :64;
  nxle_uint32_t TxOffset           :24;
  nxle_uint32_t nwkUpdateId         :8;
} nwk_beacon_payload_t;

/*******************************************************
 * Zigbee Network Descriptor for NLME_NETWORK_DISCOVERY
 *******************************************************/
typedef struct {
  uint64_t ExtendedPANId;
  uint8_t  LogicalChannel;
  uint8_t  StackProfile;
  uint8_t  ZigBeeVersion;
  uint8_t  BeaconOrder;
  uint8_t  SuperframeOrder;
  bool     PermitJoining;
  bool     RouterCapacity;
  bool     EndDeviceCapacity;
} nwk_NetworkDescriptor_t;

/*
 * Disabled TKN154 services, we do not need them
 */
//#define IEEE154_DISASSOCIATION_DISABLED


#endif // NWK_H
