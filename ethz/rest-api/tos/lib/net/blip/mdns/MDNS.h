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
*  @author Philipp Sommer <sommer@tik.ee.ethz.ch>
* 
*/

#ifndef MDNS_H
#define MDNS_H


#define MDNS_PORT 5353
#define MDNS_ADDRESS "ff02::fb"
#define MDNS_RELAYING_ENABLED 1


#define MDNS_DEFAULT_TTL 600
#define MDNS_LOCAL_STRING "local"
#define MDNS_BACKOFF_MASK 0x1000

#define DNS_TYPE_PTR 12
#define DNS_TYPE_SRV 33
#define DNS_TYPE_AAAA 28
#define DNS_CLASS_IN 1
#define MDNS_CACHE_FLUSH_FLAG 0x80

typedef nx_struct DNSHeader {
  nx_uint16_t id; 	/* query identification number */
  
  nx_uint8_t qr: 1;	/* response flag */
  nx_uint8_t opcode: 4;	/* purpose of message */
  nx_uint8_t aa: 1;	/* authoritive answer */
  nx_uint8_t tc: 1;	/* truncated message */
  nx_uint8_t rd: 1;	/* recursion desired */
  /* byte boundary */
  nx_uint8_t ra: 1;	/* recursion available */
  nx_uint8_t unused :1;	/* unused bits (MBZ as of 4.9.3a3) */
  nx_uint8_t ad: 1;	/* authentic data from named */
  nx_uint8_t cd: 1;	/* checking disabled by resolver */
  nx_uint8_t rcode :4;	/* response code */
  /* byte boundary */
  nx_uint16_t qdcount;	/* number of question entries */
  nx_uint16_t ancount;	/* number of answer entries */
  nx_uint16_t nscount;	/* number of authority entries */
  nx_uint16_t arcount;	/* number of resource entries */
} DNSHeader_t;

typedef nx_struct DNS_Question {
  nx_uint16_t type;	/* type */
  nx_uint8_t flush;	/* cache flush */
  nx_uint8_t class;	/* class */
  nx_uint32_t ttl;	/* time to live */
  nx_uint16_t length;	/* rd length */
} DNS_Question_t;

typedef nx_struct DNS_SRV_Description {
  nx_uint16_t priority;
  nx_uint16_t weight;
  nx_uint16_t port;
} DNS_SRV_Description_t;

#endif /* MDNS_H */
