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
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORSip_malloc.h
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  @author Philipp Sommer <sommer@tik.ee.ethz.ch>
* 
*/

#include <6lowpan.h>
#include <ip.h>
#include <lib6lowpan.h>
#include <ip.h>

#include "MDNS.h"

module MDNSP {
  uses {
    
    interface UDP;
    interface Leds;
    interface Boot;
    interface IPAddress;
    interface Timer<TMilli> as BackoffTimer;
    interface Random;
  }
  
  provides {
  	interface MDNS;
  }

} implementation {


  // Current interval to send the next value
  uint32_t traffic_interval = 0;

  struct sockaddr_in6 mdns_dest;
  
  char *serviceName, *serviceType;
  uint16_t servicePort;
  

  event void Boot.booted() {
    
    mdns_dest.sin6_port = hton16(MDNS_PORT);
    inet_pton6(MDNS_ADDRESS, &mdns_dest.sin6_addr);
    call UDP.bind(MDNS_PORT);

  }

  task void publishService() {

	DNS_Question_t* mdns_question;
	DNS_SRV_Description_t* mdns_srv_desc;
	struct in6_addr* addr;
	uint8_t* packet;
	DNSHeader_t* mdns_header;
	size_t pos = 0, length, servicePos, localPos, hostPos, ptrPos;
	
        length = sizeof(DNSHeader_t) + 3*sizeof(DNS_Question_t) + sizeof(DNS_SRV_Description_t) + strlen(serviceType) + 4*strlen(serviceName) + 34;
	packet = (uint8_t*)ip_malloc(length);
	
	mdns_header = (DNSHeader_t*)packet;
	// clear DNS header fields
	memset(mdns_header, 0, sizeof(DNSHeader_t));
	
	// set non-zero fields
	mdns_header->qr = 1;		// set response flag
	mdns_header->aa = 1;		// set authoritive answer flag
	mdns_header->ancount = 1;	// 1 answer
	mdns_header->arcount = 2;	// 2 additional records
  	  	
  	pos = sizeof(DNSHeader_t);
  	
  	// answer 1
  	
  	// QNAME field
	length = strlen(serviceType);
  	servicePos = pos;
  	packet[pos++] = length;
  	memcpy(&packet[pos], serviceType, length);
  	pos += length;
  	
  	// ".local"
  	localPos = pos;
  	packet[pos++] = strlen(MDNS_LOCAL_STRING);
  	memcpy(&packet[pos], MDNS_LOCAL_STRING, strlen(MDNS_LOCAL_STRING));
  	pos += strlen(MDNS_LOCAL_STRING);
  	packet[pos++] = 0;
  	
  	mdns_question = (DNS_Question_t*)&packet[pos];
  	length = strlen(serviceName);
  	mdns_question->type = DNS_TYPE_PTR;
  	mdns_question->flush = MDNS_CACHE_FLUSH_FLAG;
  	mdns_question->class = DNS_CLASS_IN;
	mdns_question->ttl = MDNS_DEFAULT_TTL;
  	mdns_question->length = length + 3; // strlen(name) + 3 additional characters  	
  	pos += sizeof(DNS_Question_t);
  	
  	ptrPos = pos;
  	packet[pos++] = length;	// RDATA
  	memcpy(&packet[pos], serviceName, length);
  	pos += length;
  	packet[pos++] = 0xC0;
  	packet[pos++] = servicePos;
  	
  	
  	// additional records
  	  	
  	// QNAME field
  	packet[pos++] = 0xC0;
  	packet[pos++] = ptrPos;
  	
  	mdns_question = (DNS_Question_t*)&packet[pos];
  	mdns_question->type = DNS_TYPE_SRV;
  	mdns_question->flush = MDNS_CACHE_FLUSH_FLAG;
  	mdns_question->class = DNS_CLASS_IN;
	mdns_question->ttl = MDNS_DEFAULT_TTL;
  	mdns_question->length = 9 + length;  	
  	pos += sizeof(DNS_Question_t);
  	
  	mdns_srv_desc = (DNS_SRV_Description_t*)&packet[pos];
  	mdns_srv_desc->priority = 0;
  	mdns_srv_desc->weight = 0;
  	mdns_srv_desc->port = servicePort;
  	pos += sizeof(DNS_SRV_Description_t);
  	
  	hostPos = pos;
  	length = strlen(serviceName);
  	packet[pos++] = length;
  	memcpy(&packet[pos], serviceName, length);
  	pos += length;
  	packet[pos++] = 0xC0;
  	packet[pos++] = localPos;
  	
  		
  	// QNAME field
  	packet[pos++] = 0xc0;
  	packet[pos++] = hostPos;
  	  	  	
  	mdns_question = (DNS_Question_t*)&packet[pos];
  	mdns_question->type = DNS_TYPE_AAAA;
  	mdns_question->flush = MDNS_CACHE_FLUSH_FLAG;
  	mdns_question->class = DNS_CLASS_IN;
	mdns_question->ttl = MDNS_DEFAULT_TTL;
  	mdns_question->length = sizeof(struct in6_addr);  	
   	
   	pos += sizeof(DNS_Question_t);
  	
  	addr = call IPAddress.getPublicAddr();
  	  	
  	memcpy(&packet[pos], addr, sizeof(struct in6_addr));
  	pos += sizeof(struct in6_addr);
  	
  	call UDP.sendto(&mdns_dest, packet, pos); 
  	
  	ip_free(packet);	
  	
  	// set timer for next message
  	if (traffic_interval>0) {
          call BackoffTimer.startOneShot(traffic_interval);
        }

  }

  

  command void MDNS.registerService(char *name, char *type, uint16_t port){
	serviceName = name;
	serviceType = type;
	servicePort = port;
  }

	
  command void MDNS.publishNow() {
	traffic_interval = 0;
	call BackoffTimer.startOneShot(call Random.rand16() & MDNS_BACKOFF_MASK);
  }
	
  command void MDNS.publishPeriodic(uint32_t period) {
	traffic_interval = period;
	call BackoffTimer.startOneShot(call Random.rand16() & MDNS_BACKOFF_MASK);
  }
  
  command void MDNS.publishStop() {
	traffic_interval = 0;
	call BackoffTimer.stop();
  }


  event void BackoffTimer.fired() {
  	post publishService();
  }
  

  event void UDP.recvfrom(struct sockaddr_in6 *from, void *data, uint16_t len, struct ip_metadata *meta) {
  	
	// forward mDNS packets towards the border router
	if (MDNS_RELAYING_ENABLED) {
	
          // only forward query responses
          DNSHeader_t* mdns_header = (DNSHeader_t*)data;
	  if (mdns_header->qr == 1) call UDP.sendto(&mdns_dest, data, len);
	}
  }

}
