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
 * Author: Andras Nadas, Miklos Maroti
 * Contact: Janos Sallai (sallai@isis.vanderbilt.edu)
 * Date last modified: 02/02/05
 */


/**
 * The RemoteControl service allows sending commands, and starting/stopping and
 * restarting TinyOS components on all or on a subset of nodes of a multi-hop network,
 * and it routes acknowledgments or return values from the affected components
 * back to the base station.
 *
 * The network must have a TOSBase or GenericBase node attached to a base station
 * laptop running MessageCenter (net.tinyos.mcenter.MessageCenter). The commands
 * can be initiated from the RemoteControl panel and the acknowledgments displayed
 * using the MessageTable panel. To use the service, one must select a unique remote
 * control application ID and implement one or more of the following interfaces:
 *
 * 	IntCommand:	allows one uint16_t to be passed as argument.
 * 			An uint16_t acknowledgment return value can be routed
 * 			back to the base station.
 *
 * 	DataCommand: allows an unstructured stream of bytes to be passed
 * 			(up to 24 bytes) to the component and an acknowledgment
 * 			be sent back.
 *
 * 	StdControl:	allows stopping/starting and restarting one component
 *			that already implements the StdControl interface.
 *			The return value (result_t) will be routed back to
 *			the base station.
 *
 * The IntCommand and DataCommand interfaces support split-phase execution, that
 * is, the acknowledgment value can be sent back from a posted task at some later time.
 * Once one of these interfaces are implemented, the following wiring must be done:
 *
 *
 * 	components ..., RemoteControlC, ...
 *
 * 	RemoteControlC.IntCommand[AppID] -> CommandedModuleM.IntCommand;
 *
 *
 *
 * @author Andras Nadas, Miklos Maroti
 * @modified 02/02/05
 */

configuration RemoteControlC
{
	uses
	{
		interface IntCommand[uint8_t id];
		interface DataCommand[uint8_t id];
		interface StdControl as StdControlCommand[uint8_t id];
	}
}

implementation
{
	components
	    new AutoStartC(),
	    RemoteControlM,
	    ActiveMessageC as AM, new TimerMilliC() as TimerC, RandomC, HilTimerMilliC;

#ifdef LEAF_NODE
	components	GradientLeafPolicyC as GradientPolicyC;
#define DFRF_BUFFER_SIZE 12
#else
	components	GradientPolicyC;
#define DFRF_BUFFER_SIZE 60
#endif

  components new DfrfClientC(APPID_REMOTECONTROL, reply_t, offsetof(reply_t, unique_delimiter), DFRF_BUFFER_SIZE) as DfrfService;

  AutoStartC.StdControl -> RemoteControlM;

	IntCommand = RemoteControlM;
	DataCommand = RemoteControlM;
	StdControlCommand = RemoteControlM;


	RemoteControlM.Receive -> AM.Receive[AM_REMOTECONTROL];
	RemoteControlM.AMSend -> AM.AMSend[AM_REMOTECONTROL];
	RemoteControlM.Packet -> AM;
	RemoteControlM.AMPacket -> AM;
	RemoteControlM.Timer -> TimerC;
	RemoteControlM.Random -> RandomC;
	RemoteControlM.RandomInit -> RandomC.SeedInit;
	RemoteControlM.LocalTime -> HilTimerMilliC;

	RemoteControlM.DfrfControl-> DfrfService.StdControl;
	RemoteControlM.DfrfSend -> DfrfService;
	DfrfService.Policy -> GradientPolicyC.DfrfPolicy;

}
