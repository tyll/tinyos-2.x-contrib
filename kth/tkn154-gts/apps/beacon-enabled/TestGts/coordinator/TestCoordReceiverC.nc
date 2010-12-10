/**
 * TestCoordReceiverC.nc  
 *  
 * <br /> KTH | Royal Institute of Technology
 * <br /> Automatic Control
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @modified 2010/07/30 
 */

#include "TKN154.h"
#include "app_profile.h"
module TestCoordReceiverC
{
	uses {
		interface Boot;
		interface MCPS_DATA;
		interface MLME_RESET;
		interface MLME_START;
		interface MLME_SET;
		interface MLME_GET;
		interface MLME_GTS;

		interface IEEE154Frame as Frame;
		interface IEEE154TxBeaconPayload;
		interface Leds;

		interface Packet;
		interface Timer<TMilli> as SendTimer;

	}
}implementation {

	bool m_ledCount;

	message_t m_frame;
	uint8_t m_payloadLen;
	uint8_t m_payload;
	bool startSend;
	
	task void packetSendTask();

	event void Boot.booted() {
		call MLME_RESET.request(TRUE);
		startSend = FALSE;
	}
	event void SendTimer.fired() {startSend = TRUE;}

	task void packetSendTask()
	{
		uint8_t *payloadRegion;
		m_payloadLen = sizeof(m_payload);

		m_payload ++;
		payloadRegion = call Packet.getPayload(&m_frame, m_payloadLen);
		if (m_payloadLen <= call Packet.maxPayloadLength()) {
			memcpy(payloadRegion, &m_payload, m_payloadLen);
		}
		if( call MCPS_DATA.request (
						&m_frame, // frame,
						m_payloadLen, // payloadLength,
						0, // msduHandle,
						TX_OPTIONS_GTS | TX_OPTIONS_ACK // TxOptions,
				) != IEEE154_SUCCESS)
		call Leds.led0Toggle(); //fail!
		else
		call Leds.led0Off();

	}

	event void MLME_RESET.confirm(ieee154_status_t status)
	{
		if (status != IEEE154_SUCCESS)
		return;
		call MLME_SET.phyTransmitPower(TX_POWER_BEACON);
		call MLME_SET.macShortAddress(COORDINATOR_ADDRESS);
		call MLME_SET.macAssociationPermit(FALSE);
		call MLME_SET.macGTSPermit(TRUE);

		call MLME_START.request(
				PAN_ID, // PANId
				RADIO_CHANNEL, // LogicalChannel
				0, // ChannelPage,
				0, // StartTime,
				BEACON_ORDER, // BeaconOrder
				SUPERFRAME_ORDER, // SuperframeOrder
				TRUE, // PANCoordinator
				FALSE, // BatteryLifeExtension
				FALSE, // CoordRealignment
				0, // CoordRealignSecurity,
				0 // BeaconSecurity
		);
	}

	event void MLME_START.confirm(ieee154_status_t status) {
		char payload[] = "Hello Device!";
		uint8_t *payloadRegion;
		ieee154_address_t deviceShortAddress;

		// construct the frame
		m_payloadLen = strlen(payload);
		payloadRegion = call Packet.getPayload(&m_frame, m_payloadLen);
		deviceShortAddress.shortAddress = 0x02; // destination
		m_payload=0;

		if (status == IEEE154_SUCCESS && m_payloadLen <= call Packet.maxPayloadLength()) {
			memcpy(payloadRegion, payload, m_payloadLen);
			call Frame.setAddressingFields(
					&m_frame,
					ADDR_MODE_SHORT_ADDRESS, // SrcAddrMode,
					ADDR_MODE_SHORT_ADDRESS, // DstAddrMode,
					PAN_ID, // DstPANId,
					&deviceShortAddress, // DstAddr,
					NULL // security
			);
		}

		call SendTimer.startOneShot(10000);
	}

	event message_t* MCPS_DATA.indication ( message_t* frame )
	{
		call Leds.led1Toggle();
		return frame;
	}

	event void MCPS_DATA.confirm(
			message_t *msg,
			uint8_t msduHandle,
			ieee154_status_t status,
			uint32_t Timestamp
	) {		}

	event void IEEE154TxBeaconPayload.aboutToTransmit() {}

	event void IEEE154TxBeaconPayload.setBeaconPayloadDone(void *beaconPayload, uint8_t length) {}

	event void IEEE154TxBeaconPayload.modifyBeaconPayloadDone(uint8_t offset, void *buffer, uint8_t bufferLength) {}

	event void IEEE154TxBeaconPayload.beaconTransmitted()
	{
		ieee154_macBSN_t beaconSequenceNumber = call MLME_GET.macBSN();
		if (beaconSequenceNumber & 1)
		call Leds.led2On();
		else
		call Leds.led2Off();
		
		if (startSend)
			post packetSendTask();

		printfflush();
	}

	event void MLME_GTS.confirm (
			uint8_t GtsCharacteristics,
			ieee154_status_t status) {}

	event void MLME_GTS.indication (
			uint16_t DeviceAddress,
			uint8_t GtsCharacteristics,
			ieee154_security_t *security) {}
}
