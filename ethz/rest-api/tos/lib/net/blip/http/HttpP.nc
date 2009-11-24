/* Copyright (c) 2009, Distributed Computing Group (DCG), ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  @author Lars Schor <lschor@ee.ethz.ch>
* 
*/


// Std includes
#include <stdio.h>
#include <string.h>

// Blip includes
#include <IPDispatch.h>
#include <lib6lowpan.h>
#include <ip.h>
#include <lib6lowpan.h>
#include <ip.h>

// HTTP includes
#include "Http.h"

// Size of the TCP buffers
#define BUFSZ 512

module HttpP{
	provides
	{
		interface Http; 
	}
	
	uses 
	{
	    interface Boot;
	    interface SplitControl as RadioControl;	
	    interface Tcp; 
	    interface Timer<TMilli> as TimerSend;  
    }
}
implementation{
	
	// TCP Buffer
  	void *rx_loc_buf = NULL; 
  	void *tx_loc_buf = NULL; 

	// Current send position
	char *send; 
	uint16_t sendWait = 50; 

	/*************** Boot ***********************/
	event void Boot.booted(){
		call RadioControl.start();
    	
    	call Tcp.bind(80);;  
	}

	/*************** RadioControl ***********************/
	
	event void RadioControl.stopDone(error_t error){
	}

	event void RadioControl.startDone(error_t error){
	}
	
	
	/*************** Local Functions ***********************/

	/**
	 * Print the payload of a HTTP packet
	 */
/*	void printPayload(void *payload, uint16_t len)
	{
		char *buf;
		int i; 
	
		buf = (char *) payload; 
		
		printf("Len = %d\n", len); 
		
		for (i = 0; i < len; i ++)
		{
			printf("%c", buf[i]); 
		}
			
		printf("\n");  
	}
*/

	/*************** TCP ***********************/
	event void Tcp.recv(void *payload, uint16_t len)
	{
		signal Http.received(payload, len); 
	}

	event void Tcp.closed(error_t e)
	{
		call Tcp.bind(80);	
	}
	

	event bool Tcp.accept(struct sockaddr_in6 *from, void **tx_buf, int *tx_buf_len)
	{
  
  		if (tx_loc_buf == NULL)
  			tx_loc_buf = malloc(BUFSZ);
  		*tx_buf = tx_loc_buf;
  		*tx_buf_len = BUFSZ; 
		
		return TRUE; 	
	}

	event void Tcp.connectDone(error_t e){ 
	}
	
	event void Tcp.acked() {
	}
	
	/*************** HTTP ***********************/
	command uint16_t Http.createHeader(char *payload, bool shortHeader){
		// Create the header to send
		char httpVersion[20] = "HTTP/1.1 200 OK"; 
		char httpLength[30] = "Content-Length: xxx"; 
		
		payload[0] = '\0'; 
		
		// Merge the message
		strcat(payload, httpVersion); 
		strcat(payload, END_LINE); 
		strcat(payload, httpLength); 
		strcat(payload, END_LINE);
		
		// If a normal HTTP header should be generated
		if (!shortHeader)
		{
			char httpType[30] = "Content-Type: text/html";
			char httpConn[20] = "Connection: close"; 
			strcat(payload, httpType); 
			strcat(payload, END_LINE); 
			strcat(payload, httpConn); 
			strcat(payload, END_LINE);
		}
		 
		strcat(payload, END_LINE);
		
		return (uint16_t)strlen(payload); 
	}
	
	command void Http.sendData(char *payload, uint16_t len)
	{
		char lenStr[5]; 
		
		// Add the length
		sprintf(lenStr,"%d", len + sizeof(END_LINE) - 1); 
		
		if (len + sizeof(END_LINE) - 1 < 100) {
			payload[HTTP_LEN_START] = '0';
			payload[HTTP_LEN_START + 1] = lenStr[0];
			payload[HTTP_LEN_START + 2] = lenStr[1];
		}
		else {
			payload[HTTP_LEN_START] = lenStr[0]; 
			payload[HTTP_LEN_START + 1] = lenStr[1];
			payload[HTTP_LEN_START + 2] = lenStr[2];
		}
		
		strcat(payload, END_LINE); 
		
		// Send the data over tcp, but each packet is allowed to have a maximal size of 66 bytes! 
		send = (char *)payload;
		call TimerSend.startOneShot(0);  
	}
	
	command void Http.sendControl(uint16_t code)
	{
		char httpVersion[15] = "HTTP/1.1"; 
		char httpCodeText[40] = ""; 
		char message[60] = ""; 
		uint16_t len = 0; 
		
		// Write the correct http Code Text
		switch (code)
		{
			case HTTP_OK: 
				strcat(httpCodeText, "200 OK");  
				break; 
			case HTTP_MOVED_PERMANENTLY:	
				strcat(httpCodeText, "301 Moved Permanently");  
				break;
			case HTTP_BAD_REQUEST:
				strcat(httpCodeText, "400 Bad Request"); 
				break;  
			case HTTP_UNAUTHORIZED:
				strcat(httpCodeText, "401 Unauthorized"); 
				break; 
			case HTTP_FORBIDDEN:
				strcat(httpCodeText, "403 Forbidden"); 
				break;  
			case HTTP_NOT_FOUND:
				strcat(httpCodeText, "404 Not Found"); 
				break;  
			case HTTP_METHOD_NOT_ALLOWED:
				strcat(httpCodeText, "405 Method Not Allowed"); 
				break;
			case HTTP_NOT_IMPLEMENTED:
				strcat(httpCodeText, "501 Not Implemented"); 
				break;  
			default :
				// Unsupported error
				strcat(httpCodeText, "500 Internal Server Error"); 
				break; 
		}
		
		// Set the message together
		strcat(message, httpVersion);
		strcat(message, " ");  
		strcat(message, httpCodeText); 
		strcat(message, END_LINE); 
		strcat(message, END_LINE); 
		
		len = (uint16_t) strlen(message); 
		
		call Tcp.send(message, len); 	 
	}
	
	default event void Http.received(void *payload, uint16_t len)
	{
	}
	
	/******************* Timer Send ******************/
	event void TimerSend.fired()
  	{
  		uint16_t sendLen = 0; 
		
  		if ((sendLen = (uint16_t)strlen(send) > 66 ? 66 : (uint16_t)strlen(send)) > 0)
		{
			call Tcp.send(send, sendLen);
			send = send + sendLen; 
			call TimerSend.startOneShot(sendWait); 
		} 
		else
		{
			signal Http.sendDataDone(); 
		}
  	}
}
