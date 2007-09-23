/*
 * Copyright (c) 2006-2007 Stanford University.
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
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
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
 */

/**
 * Top-level configuration for the noise sampling application.
 *
 * @author HyungJune Lee (abbado@stanford.edu)
 */

#include "StorageVolumes.h"
#include "NoiseSample.h"

configuration NoiseAppC
{
}

implementation
{
	components MainC;
	components LedsC;
	components new Alarm32khz32C() as Alarm0;
	components new CC2420RssiC() as RssiC;
	components NoiseSampleP as App;
	components ActiveMessageC;
	components SerialActiveMessageC;
	components new SerialAMSenderC(AM_RSSI_SAMPLE_MSG);
	components new BlockStorageC(VOLUME_BLOCK);
	components HplCC2420PinsC as Pins;

	App->MainC.Boot;
	App.Leds->LedsC;
	App.Alarm0->Alarm0; 
	App.Resource->RssiC;
	App.RSSI->RssiC;
	App.CSN->Pins.CSN;
	App.RadioControl->ActiveMessageC;
	App.SerialControl->SerialActiveMessageC;
	App.AMSend->SerialAMSenderC;
	App.Packet->SerialAMSenderC;
	App.BlockRead->BlockStorageC;
	App.BlockWrite->BlockStorageC;
}


