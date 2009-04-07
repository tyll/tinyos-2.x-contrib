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
#include "ClusterHierarchy.h"


/**
 * A module implementing routing table entry accessors in a distance
 * vector message.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module CHMsgRTEntry4BitLevel11BitHeadP {
    provides {
        interface CHMsgRTEntry<nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t>
            as CHMsgRTEntry;
    }
}
implementation {

    // ----------------------- Interface CHMsgRTEntry ----------------------
    command inline uint8_t CHMsgRTEntry.getByteSize() {
        return sizeof(nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t);
    }



    command inline uint8_t CHMsgRTEntry.getLevel(
            nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t const * entry) {
        return (uint8_t)((uint16_t)entry->levelAdjHead & (uint16_t)0x000f);
    }



    command inline void CHMsgRTEntry.setLevel(
            nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t * entry, uint8_t level) {
        uint16_t rest = entry->levelAdjHead & (uint16_t)0xfff0;
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (level > 0x0f) {
            dbgerror("CH|ERROR", \
                "The level %hhu of a message routing entry exceeds %hhu! [%s]", \
                level, 0x0f, __FUNCTION__);
            return;
        }
#endif
#endif
        entry->levelAdjHead = ((uint16_t)level | rest);
    }



    command inline uint16_t CHMsgRTEntry.getHead(
            nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t const * entry) {
        return (uint16_t)entry->levelAdjHead >> 5;
    }



    command inline void CHMsgRTEntry.setHead(
            nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t * entry, uint16_t head) {
        uint16_t rest = (uint16_t)entry->levelAdjHead & (uint16_t)0x001f;
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (head > 0x07ff) {
            dbgerror("CH|ERROR", \
                "The head %hu of a message routing entry exceeds %hu! [%s]", \
                head, 0x07ff, __FUNCTION__);
            return;
        }
#endif
#endif
        entry->levelAdjHead = (rest | (head << 5));
    }



    command inline uint8_t CHMsgRTEntry.getNumHops(
            nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t const * entry) {
        return entry->numHops;
    }



    command inline void CHMsgRTEntry.setNumHops(
            nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t * entry, uint8_t numHops) {
        entry->numHops = numHops;
    }



    command inline ch_rt_entry_seq_no_t CHMsgRTEntry.getSeqNo(
            nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t const * entry) {
        return entry->advertSeqNo;
    }



    command inline void CHMsgRTEntry.setSeqNo(
            nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t * entry,
            ch_rt_entry_seq_no_t advertSeqNo) {
        entry->advertSeqNo = advertSeqNo;
    }



    command inline bool CHMsgRTEntry.getAdjacencyFlag(
            nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t const * entry) {
        return ((uint16_t)entry->levelAdjHead & (uint16_t)0x0010) != 0;
    }



    command inline void CHMsgRTEntry.setAdjacencyFlag(
            nx_ch_phdv_msg_rt_entry_4bit_level_11bit_head_t * entry, bool flag) {
        if (flag) {
            entry->levelAdjHead |= (uint16_t)0x0010;
        } else {
            entry->levelAdjHead &= ~((uint16_t)0x0010);
        }
    }
}
