/* 
 * Copyright (c) 2006, Technische Universitaet Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitaet Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */

#ifndef __ATTRIBUTES_H
#define __ATTRIBUTES_H

#define EYESIFX_TEMPERATURE_ATTRIBUTE_ID 0
#define EYESIFX_LIGHT_ATTRIBUTE_ID 2
#define EYESIFX_RSSI_ATTRIBUTE_ID 3
#define MSP430_TEMPERATURE_ATTRIBUTE_ID 10
#define MSP430_VOLTAGE_ATTRIBUTE_ID 11
#define SENSIRION_TEMPERATURE_ATTRIBUTE_ID 12
#define SENSIRION_HUMIDITY_ATTRIBUTE_ID 13
#define PING_ATTRIBUTE_ID 17
#define DISCOVERY_ATTRIBUTE_ID 18
#define RANDOM_ATTRIBUTE_ID 19
#define FALSE_ATTRIBUTE_ID 20

#define RATE_ATTRIBUTE_ID 100
#define COUNT_ATTRIBUTE_ID 101
#define REBOOT_ATTRIBUTE_ID 104

#define ATTRIBUTE_NOTIFICATION_AMID 106
#define ATTRIBUTE_CLIENT_ID 107
#define ATTRIBUTE_SUBSCRIBER_ADDRESS 108
#define ATTRIBUTE_NOTIFICATION_HEADER 109
#define ATTRIBUTE_SEND_ON_DELTA 110
#define ATTRIBUTE_PARENT_ADDR 111
#define ATTRIBUTE_INTM_HOP_ADDR 112

#endif
