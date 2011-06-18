@title README for tkn154 test applications
@author Aitor Hernandez <aitorhh@kth.se>

D E S C R I P T I O N
--------------------------------------------------

This folder contains test applications for "TKN15.4" with the GTS
implementation that allows you to use more than 7 GTS slots.

This modification removes the allocation/deallocation/expiration
mechanism. And assumes that the Coordinator (Network Manager), allocates
the new slots depending on their requirements

R E C O M E N D A T I O N S
--------------------------------------------------
It is recommended to use a Beacon Order bigger than the Superframe order
(BO > SO) in order to update the GTS descriptor during the inactive period.

O P T I O N S
--------------------------------------------------
I. tos/lib/mac/tkn154/TKN154_MAC.h

   IEEE154_aNumSuperframeSlots: Indicates the number of slots that we
   			want in the superframe. With the modifications the beacon
   			interval and superframe duration has changed with respect
   			to the standard. 
   			
   IEEE154_MAX_BEACON_LISTEN_TIME(BO): By increasing the GTS descriptor
   			(GTS slots allocated) the beacon length will increase. So,
   			by increasing this time, we allow the device to wait more
   			until it considers the beacon as missed. 

II. tos/lib/mac/tkn154/TKN154.h
	
	CFP_NUMBER_SLOTS: Maximum number of GTS slots. By default is set to
					CFP_NUMBER_SLOTS = (IEEE154_aNumSuperframeSlots-1)
					
					
					
R E S T R I C T I O N S
--------------------------------------------------
I. The maximum number of slots is IEEE154_aNumSuperframeSlots = 32, because
	the field Final CAP Slot has 5 bits.
	
II. 

II. 