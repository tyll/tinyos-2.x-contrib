// $Id$
/*
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 *
 * The basic chip-independent TOSSIM Active Message layer for radio chips
 * that do not have simulation support.
 *
 * @author Philip Levis
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk> (ported from ActiveMessageC)
 * @date December 2 2005
 */

configuration Ieee154MessageC {
  provides {
    interface SplitControl;

    interface Resource as SendResource[uint8_t clientId];
    interface Ieee154Send;
    interface Receive as Ieee154Receive;

    interface Ieee154Packet;
    interface Packet;

    interface PacketAcknowledgements;
    /*interface LinkPacketMetadata;
    interface LowPowerListening;
    interface PacketLink;*/
  }
}
implementation {
  components TossimIeee154MessageC as Ieee154;
  components TossimPacketModelC as Network;

  components CpmModelC as Model;

  components ActiveMessageAddressC as Address;
  components MainC;

  components new FcfsResourceQueueC(uniqueCount(RADIO_SEND_RESOURCE));

	components CC2420RadioC;
  
  MainC.SoftwareInit -> Network;
	MainC.SoftwareInit -> FcfsResourceQueueC;
  SplitControl = CC2420RadioC;
	CC2420RadioC.SubControl -> Network;
 
	SendResource = Ieee154;
  Ieee154Send = Ieee154;
  Ieee154Receive = Ieee154;
  Packet = Ieee154;
  Ieee154Packet = Ieee154;
  PacketAcknowledgements = Network;

  Ieee154.Model -> CC2420RadioC;
	CC2420RadioC.SubModel -> Network.Packet;
  Ieee154.amAddress -> Address;
	Ieee154.Queue -> FcfsResourceQueueC;

	CC2420RadioC.Packet -> Ieee154;

  Network.GainRadioModel -> Model;
}

