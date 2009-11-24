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

// REST includes
#include "Rest.h"

// IP Dispatch Information
#include <IPDispatch.h>

// Similar to UDPEchoP
module reportBlipP {
  uses {
    interface Json;
    interface Rest; 
    interface Boot;

    interface Statistics<ip_statistics_t> as IPStats;
    interface Statistics<route_statistics_t> as RouteStats;
    interface Statistics<icmp_statistics_t> as ICMPStats;
  } 
}
implementation{
	
	/************* Variables ***********/
	
	uint16_t sensValue; 
	
	/************* Boot ****************/
	event void Boot.booted(){
		call Rest.bind("report/blip"); 
	}
	
	/**
	 * Information to IP Layer
	 */
	void getInfoIp(char *buf, char *element, uint16_t len)
	{
		// Will not be recorded currently! 
		uint16_t bufLen = 0;
		uint8_t methodList[] = {JSON_METH_GET}; 
		
		ip_statistics_t ip;
		
		call IPStats.get(&ip);
		
		call Json.createElement(buf, "IP Statistic");
		call Json.addMethod(buf,methodList , 1);
		call Json.addParamInt(buf, "sent", ip.sent, "i", 0, 1);
		call Json.addParamInt(buf, "forwarded", ip.forwarded, "i", 0, 0); 
		call Json.addParamInt(buf, "rx_drop", ip.rx_drop, "i", 0, 0); 
		call Json.addParamInt(buf, "tx_drop", ip.tx_drop, "i", 0, 0); 
		call Json.addParamInt(buf, "fw_drop", ip.fw_drop, "i", 0, 0); 
		/*call Json.addParamInt(buf, "rx_total", ip.rx_total, "i", 0, 0); 
		call Json.addParamInt(buf, "real_drop", ip.real_drop, "i", 0, 0); 
		call Json.addParamInt(buf, "hlim_drop", ip.hlim_drop, "i", 0, 0); 
		call Json.addParamInt(buf, "senddone_el", ip.senddone_el, "i", 0, 0); 
		call Json.addParamInt(buf, "fragpool", ip.fragpool, "i", 0, 0); 
		call Json.addParamInt(buf, "sendinfo", ip.sendinfo, "i", 0, 0); 
		call Json.addParamInt(buf, "sendentry", ip.sendentry, "i", 0, 0); 
		call Json.addParamInt(buf, "sndqueue", ip.sndqueue, "i", 0, 0); 
		call Json.addParamInt(buf, "encfail", ip.encfail, "i", 0, 0); 
		call Json.addParamInt(buf, "heapfree", ip.heapfree, "i", 0, 0);*/
		 
		bufLen = call Json.finishElement(buf); 
		call Rest.sendData(buf, bufLen); 
	}
	
	/**
	 * Information to Routes
	 */
	void getInfoRoute(char *buf, char *element, uint16_t len)
	{
		uint16_t bufLen = 0;
		uint8_t methodList[] = {JSON_METH_GET}; 
		
		route_statistics_t route;
		call RouteStats.get(&route);
		
		call Json.createElement(buf, "Routing Statistic");
		call Json.addMethod(buf,methodList , 1);
		call Json.addParamInt(buf, "hop_limit", route.hop_limit, "i", 0, 1);
		call Json.addParamInt(buf, "parent", route.parent, "i", 0, 0); 
		call Json.addParamInt(buf, "parent_metric", route.parent_metric, "i", 0, 0); 
		call Json.addParamInt(buf, "parent_etx", route.parent_etx, "i", 0, 0); 
				 
		bufLen = call Json.finishElement(buf); 
		call Rest.sendData(buf, bufLen); 
	}
	
	/**
	 * Information to ICMP
	 */
	void getInfoIcmp(char *buf, char *element, uint16_t len)
	{
		uint16_t bufLen = 0;
		uint8_t methodList[] = {JSON_METH_GET}; 
		
		icmp_statistics_t icmp;
		call ICMPStats.get(&icmp);
		
		call Json.createElement(buf, "ICMP Statistic");
		call Json.addMethod(buf,methodList , 1);
		call Json.addParamInt(buf, "rx", icmp.rx, "i", 0, 1); 
				 
		bufLen = call Json.finishElement(buf); 
		call Rest.sendData(buf, bufLen); 
	}
	
		
	/**
	 * Generates the Collection-Response
	 */
	void getCollection(char *collection){
		uint16_t len; 
		
		// Add all elements one have and send them as resources
		call Json.createCollection(collection, "res"); 
		call Json.addToCollection(collection, "routing", 1);
		call Json.addToCollection(collection, "icmpinfo", 0);
		call Json.addToCollection(collection, "ipinfo", 0); 
		 
		len = call Json.finishCollection(collection);
		call Rest.sendData(collection, len);
	}

	/************ REST *****************/
	event void Rest.getReceived(char *elementName, uint16_t len, char* buf){
		
		// Get the request for the collection
		if (strncmp(elementName, "*", 1) == 0)
		{
			getCollection(buf);
		}
		// Get the request for an element
		else
		{
			if (strcmp(elementName, "routing") == 0)
				getInfoRoute(buf, elementName, len);
			else  if (strcmp(elementName, "icmpinfo") == 0)
				getInfoIcmp(buf, elementName, len);
			else if (strcmp(elementName, "ipinfo") == 0)
				getInfoIp(buf, elementName,len); 
			else
				call Rest.sendControl(REST_NOT_IMPL); 
		}
	}

	event void Rest.putReceived(char *element, uint16_t len, char *param_name, char *param_value){
	}

	event void Rest.deleteReceived(char *elementName, uint16_t len){
	}
}
