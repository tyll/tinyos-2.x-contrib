/*
 * IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
 * downloading, copying, installing or using the software you agree to
 * this license.  If you do not agree to this license, do not download,
 * install, copy or use the software.
 *
 * Copyright (c) 2006-2008 Vrije Universiteit Amsterdam and
 * Development Laboratories (DevLab), Eindhoven, the Netherlands.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions, the author, and the following
 *   disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions, the author, and the following disclaimer
 *   in the documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Vrije Universiteit Amsterdam, nor the name of
 *   DevLab, nor the names of their contributors may be used to endorse or
 *   promote products derived from this software without specific prior
 *   written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL VRIJE
 * UNIVERSITEIT AMSTERDAM, DEVLAB, OR THEIR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Authors: Konrad Iwanicki
 * CVS id: $Id$
 */
#ifndef __HIERARCHICAL_CLUSTERING_DEMO_STATS__H__
#define __HIERARCHICAL_CLUSTERING_DEMO_STATS__H__



/*
 * This file contains statistics reporting functionality for the
 * cluster hierarchy maintenance algorithms.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */



// ************************* Static configuration *************************

// ###### Simulation config ######
#define CONF_SIM_STATS_TRAFFIC_LAYER_PROTOCOL_ONLY                        0
#define CONF_SIM_STATS_TRAFFIC_LAYER_WHOLE_STACK                          1



// *************************** Local structures ***************************


// ******************* Message and storage structures *********************
enum {
    /** the AM identifier for statistic messages with traffic statistics */
    AM_CH_STATS_REPORT_TRAFFIC_MSG = 100,
    /** the AM identifier for statistic messages for the link estimator */
    AM_CH_STATS_REPORT_LE_MSG = 101,
    /** the AM identifier for statistic messages for the area hierarchy */
    AM_CH_STATS_REPORT_AREAHIER_MSG = 102,
};


/**
 * The header used for all statistic messages.
 */
typedef nx_struct  {
    nx_uint16_t    reportNumber;
    nx_uint8_t     indexInSeriesAndFlags;
} nx_ch_stats_report_header_t;



enum {
    NX_CH_STATS_REPORT_HEADER_INDEX_MASK = 0x7f,
    NX_CH_STATS_REPORT_HEADER_FLAG_LAST = 0x80,
};



/**
 * The traffic statistics message sent over the serial port.
 */
typedef nx_struct nx_ch_stats_report_traffic_msg_t {
    nx_ch_stats_report_header_t               statsHeader;
    nx_uint32_t                               txedMessagesCHOnly;
    nx_uint32_t                               txedBytesCHOnly;
    nx_uint32_t                               rxedMessagesCHOnly;
    nx_uint32_t                               rxedBytesCHOnly;
    nx_uint32_t                               txedMessagesCHComplete;
    nx_uint32_t                               txedBytesCHComplete;
    nx_uint32_t                               rxedMessagesCHComplete;
    nx_uint32_t                               rxedBytesCHComplete;
} nx_ch_stats_report_traffic_msg_t;



/**
 * The header used for link estimator statistic messages.
 */
typedef nx_struct {
    nx_uint8_t      numNeighbors;
} nx_ch_stats_report_le_header_t;


/**
 * A neighbor in the link estimator statistics report.
 */
typedef nx_struct {
    nx_am_addr_t    addr;   // the link-layer address
    nx_uint8_t      flq;    // the forward link quality
    nx_uint8_t      rlq;    // the reverse link quality
} nx_ch_stats_report_le_neighbor_t;



/**
 * The header used for area hierarchy statistic messages.
 */
typedef nx_struct {
    nx_uint8_t      numRTEntriesAndFlags;
} nx_ch_stats_report_ch_header_t;


enum {
    NX_CH_STATS_REPORT_CH_HEADER_NUM_RT_ENTRIES_MASK = 0x7f,
    NX_CH_STATS_REPORT_CH_HEADER_FLAG_LABEL_PRESENT = 0x80,
};


/**
 * The next hop for a routing table entry in the cluster hierarchy
 * statistics report.
 */
typedef nx_struct {
    nx_am_addr_t    addr;
    nx_uint8_t      numHops;
} nx_ch_stats_report_ch_rt_entry_next_hop_t;

/**
 * A routing table entry in the cluster hierarchy statistics report.
 */
typedef nx_struct {
    nx_uint8_t                                  level;
    nx_uint16_t                                 head;
    nx_uint8_t                                  numHops;
    nx_ch_stats_report_ch_rt_entry_next_hop_t   nextHops[CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES];
} nx_ch_stats_report_ch_rt_entry_t;



#endif //__HIERARCHICAL_CLUSTERING_DEMO_STATS__H__
