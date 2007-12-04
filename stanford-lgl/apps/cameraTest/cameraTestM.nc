/*
* Copyright (c) 2006 Stanford University.
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
 * @brief EnaLab camera board test application
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 
#include "enalabCam.h"
#include "camera.h"

module cameraTestM
{
	uses {
		interface Boot;
		interface Leds;
		interface Timer<TMilli> as Timer0;
		interface Alarm<TMilli,uint32_t> as Alarm;
		interface Init as AlarmInit;

		interface EnalabCam;
		interface Init as CameraInit;
		interface SplitControl as SerialControl;
		interface Packet;

		interface AMSend as FrameSend;
		interface Receive as CmdReceive;

		//dbg
		interface HplOV7649Advanced as OVAdvanced;
		interface AMSend as OVDbgSend;
		interface Receive as OVDbgReceive;
		interface AMSend as PXADbgSend;
		interface Receive as PXADbgReceive;
	}
}
implementation
{
	norace frame_t* frame;
	//	uint8_t bufferTmp[FRAME_BUF_SIZE+1000] __attribute__ ((aligned(4)));
	//#define BASE_FRAME_ADDRESS1 (bufferTmp)
#define SDRAM_ADDRESS	BASE_FRAME_ADDRESS 
	message_t fwdMsg;
	norace frame_part_request_t req;

	message_t pxa_dbg_msg;
	task void send_pxa_dbg();

	//----------------------------------------------------------------------------
	// StdControl Interface Implementation
	//----------------------------------------------------------------------------  
	event void Boot.booted()
	{
		call CameraInit.init();
		call AlarmInit.init();
		call SerialControl.start();
		//call Timer0.startOneShot(1000);
		//call Timer0.startPeriodic(100);
	}

	event void SerialControl.startDone(error_t result) {}

	event void SerialControl.stopDone(error_t result) {}

	norace uint8_t color_picture = 0;
	task void processFrame()
	{
		frame_part_t *part = (frame_part_t *)call Packet.getPayload(&fwdMsg, NULL);
		int total_size;
		int total_parts;
		int buf_offset;
		int len,i;

		total_size = (int) frame->header->size;
		total_parts = total_size / MAX_PART_LEN;
		if (color_picture==0)
			buf_offset = 2*req.part_id * MAX_PART_LEN + 1; // '2*' and '+1' are because we only
		// want the Y component
		else
			buf_offset = req.part_id * MAX_PART_LEN;

		if (req.part_id >= total_parts)
			return;

		part->part_id = req.part_id;
		len = MAX_PART_LEN;

		if (total_size - part->part_id * MAX_PART_LEN < MAX_PART_LEN)
			len = total_size - part->part_id * MAX_PART_LEN;

		for (i = 0; i < len; i++)
		{
			if (color_picture==0)
				part->buf[i] = frame->buf[2*i + buf_offset];
			else
				part->buf[i] = frame->buf[i + buf_offset];
	
			if (call FrameSend.send(AM_BROADCAST_ADDR, &fwdMsg, sizeof(frame_part_t)) == FAIL)
				post processFrame();
		}
	}

	event void FrameSend.sendDone(message_t* bufPtr, error_t error)
	{
		if (error==FAIL) 
		{
			post processFrame();
			return;
		}
		if (req.send_next_n_parts)
		{
			req.part_id++;
			req.send_next_n_parts--;
			post processFrame();
		}
	}

	event void Timer0.fired()
	{
		post processFrame();
		call Leds.led2Toggle();
	}

	task void startProcessing()
	{
		call Timer0.startOneShot(100);
	}

	async event void EnalabCam.acquireDone()
	{
		call Leds.led1Toggle();
		if (color_picture==0)
			frame->header->size /= 2;//*4; 

		req.send_next_n_parts = frame->header->size/MAX_PART_LEN;
		req.part_id = 0;
		post startProcessing();
	}

	task void acquireTask() {
		if (color_picture == 0)
			frame = call EnalabCam.acquire(COLOR_UYVY, (void*)SDRAM_ADDRESS);
		else
			frame = call EnalabCam.acquire(COLOR_RGB565, (void*)SDRAM_ADDRESS);
	}

	norace uint32_t time;
	norace uint8_t stop_timing=1;
	async event void Alarm.fired() {
		dbg_msg32_t *tx_data = (dbg_msg32_t *)call Packet.getPayload(&pxa_dbg_msg, NULL);
		atomic {stop_timing = 1;}
		tx_data->reg_val = time;
		post send_pxa_dbg();
	}

	task void measureCPUticks()
	{
		while (!stop_timing)
		{
			uint8_t i=10;
			while (--i!=0)
				asm volatile("nop");
			time+=33; //each while cycle is at least 3 instructions
			//still not a very good measure - 100s of instructions are wasted somewhere
		}
	}

	task void startCPUmeasurement()
	{
		stop_timing = 0;
		call Alarm.start(time); //ms
		time = 0;
		post measureCPUticks();
	}

	event message_t *CmdReceive.receive(message_t *msg, void *payload, uint8_t len) {
		cmd_msg_t *cmdMsg = (cmd_msg_t *)payload;

		if (cmdMsg->cmd == 0) {
			color_picture = 0;
			post acquireTask();
		}
		else if (cmdMsg->cmd == 1) {
			color_picture = 1;
			post acquireTask();
		}
		else if (cmdMsg->cmd == 2) {
			req.part_id = cmdMsg->val1;
			req.send_next_n_parts = cmdMsg->val2;
			post processFrame();
		}
		else if (cmdMsg->cmd == 3) {
			dbg_msg32_t *tx_data = (dbg_msg32_t *)call Packet.getPayload(&pxa_dbg_msg, NULL);
			uint32_t *sdram = SDRAM_ADDRESS;
			*sdram = 0x10203040UL;
			tx_data->addr = sdram;
			tx_data->reg_val = *sdram;
			post send_pxa_dbg();
		}
		else if (cmdMsg->cmd == 4) {
			dbg_msg32_t *tx_data = (dbg_msg32_t *)call Packet.getPayload(&pxa_dbg_msg, NULL);
			time = cmdMsg->val1;
			tx_data->addr = time;
			post startCPUmeasurement();
		}

		call Leds.led2Toggle();

		return msg;
	}

	/***** READ REGISTERS *****/
	task void send_pxa_dbg() {
		call PXADbgSend.send(AM_BROADCAST_ADDR, &pxa_dbg_msg, sizeof(dbg_msg32_t));
	}
	event message_t *PXADbgReceive.receive(message_t *msg, void *payload, uint8_t len) {
		dbg_msg32_t *rx_data = (dbg_msg32_t *)payload;
		dbg_msg32_t *tx_data = (dbg_msg32_t *)call Packet.getPayload(&pxa_dbg_msg, NULL);
		tx_data->addr = rx_data->addr;
		tx_data->reg_val = _PXAREG(rx_data->addr);
		post send_pxa_dbg();
		call Leds.led2Toggle();
		return msg;
	}
	event void PXADbgSend.sendDone(message_t* bufPtr, error_t error) {}

	message_t ov_dbg_msg;
	task void send_ov_dbg() {
		call OVDbgSend.send(AM_BROADCAST_ADDR, &ov_dbg_msg, sizeof(dbg_msg8_t));
	}
	event message_t *OVDbgReceive.receive(message_t *msg, void *payload, uint8_t len) {
		dbg_msg8_t *rx_data = (dbg_msg8_t *)payload;
		dbg_msg8_t *tx_data = (dbg_msg8_t *)call Packet.getPayload(&ov_dbg_msg, NULL);
		tx_data->addr = rx_data->addr;
		tx_data->reg_val = call OVAdvanced.get_reg_val(tx_data->addr);
		post send_ov_dbg();
		call Leds.led2Toggle();
		return msg;
	}
	event void OVDbgSend.sendDone(message_t* bufPtr, error_t error) {}
	/*~~~~ READ REGISTERS ~~~~*/

}
