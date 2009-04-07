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
 * An implementation of the local state of the cluster hierarchy.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module CHLocalStateP {
    provides {
        interface Init;
        interface CHLocalState;
        interface CHStateDebug;
    }
}
implementation {
    // ------------------------- Private members --------------------------
    enum {
        /** the maximal number of rows in a routing table */
        CH_MAX_NUM_RT_ROWS = CH_MAX_LABEL_LENGTH - 1,
    };


    /**
     * A row in the routing table.
     * The entries in a row are sorted based on the head identifier.
     * This is important for selecting the entries to send in
     * a message.
     */
    typedef struct {
        ch_rt_entry_t *        pfirst; // the first entry on the list
    } ch_rt_row_t;


    /**
     * The routing table itself.
     */
    typedef struct {
        // the rows containing lists of entries
        ch_rt_row_t      rows[CH_MAX_NUM_RT_ROWS];
        // the pool of free entries used for allocating new entries
        // all entries in the pool form a linked list
        ch_rt_entry_t    entryPool[CH_MAX_NUM_RT_ENTRIES];
        // the pointer to the first free entry in the pool
        ch_rt_entry_t *  pfree;
        // the number of allocated entries
        // the number of free entries can be obtained with:
        // MAX_NUM_AREAHIER_RT_ENTRIES - numEntries
        uint8_t          numEntries;
    } ch_rt_t;



    /** the label */
    uint16_t      labelElements[CH_MAX_LABEL_LENGTH];
    /** the routing table */
    ch_rt_t       rt;
    /** the length of the label */
    uint8_t       labelLength;



    // -------------------------- Interface Init --------------------------
    command inline error_t Init.init() {
        uint8_t i;

        if (TOS_NODE_ID == CH_INVALID_CLUSTER_HEAD) {
            return FAIL;
        }

        // Initialize the label.
        labelLength = 1;
        labelElements[0] = TOS_NODE_ID;
        for (i = 1; i < CH_MAX_LABEL_LENGTH; ++i) {
            labelElements[i] = CH_INVALID_CLUSTER_HEAD;
        }

        // Initialize the routing table.
        for (i = 0; i < CH_MAX_NUM_RT_ROWS; ++i) {
            rt.rows[i].pfirst = NULL;
        }
        for (i = 0; i < CH_MAX_NUM_RT_ENTRIES - 1; ++i) {
            rt.entryPool[i].pnext = &(rt.entryPool[i + 1]);
        }
        rt.entryPool[CH_MAX_NUM_RT_ENTRIES - 1].pnext = NULL;
        rt.pfree = &(rt.entryPool[0]);
        rt.numEntries = 0;

        return SUCCESS;
    }



    // ---------------------- Interface CHLocalState ----------------------
    command inline uint8_t CHLocalState.getLabelLength() {
        return labelLength;
    }



    command inline void CHLocalState.setLabelLength(uint8_t len) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (len < 1 || len > CH_MAX_LABEL_LENGTH) {
            dbgerror("CH|ERROR", \
                "Invalid label length %hhu to set! [%s]\n", \
                len, __FUNCTION__);
            return;
        }
#endif
#endif
        labelLength = len;
    }



    command inline uint16_t CHLocalState.getLabelElement(uint8_t i) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (i >= labelLength) {
            dbgerror("CH|ERROR", \
                "Invalid element index %hhu of a label! " \
                "Allowed values: 0..%hhu! [%s]\n", i, labelLength - 1, \
                __FUNCTION__);
            return CH_INVALID_CLUSTER_HEAD;
        }
#endif
#endif
        return labelElements[i];
    }



    command inline void CHLocalState.setLabelElement(uint8_t i, uint16_t val) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (i >= labelLength || i < 1) {
            dbgerror("CH|ERROR", \
                "Invalid element index %hhu of a label! " \
                "Allowed values: 1..%hhu! [%s]\n", i, labelLength - 1, \
                __FUNCTION__);
            return;
        }
#endif
#endif
        labelElements[i] = val;
    }



    command inline uint8_t CHLocalState.getLevelAsHead() {
        uint8_t i;

        for (i = 1; i < labelLength; ++i) {
            if (labelElements[i] != labelElements[0]) {
                break;
            }
        }
        return i - 1;
    }



    command inline uint8_t CHLocalState.getRTSize() {
        return rt.numEntries;
    }



    command inline ch_rt_entry_t * CHLocalState.getRTEntry(
            uint8_t level, uint16_t head) {
        ch_rt_entry_t * res;

        --level;

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (level >= CH_MAX_NUM_RT_ROWS) {
            dbgerror("CH|ERROR", \
                "Invalid routing entry level %hhu! " \
                "Allowed values: 1..%hhu! [%s]\n", level + 1, \
                CH_MAX_NUM_RT_ROWS, __FUNCTION__);
            return NULL;
        }
#endif
#endif

        for (res = rt.rows[level].pfirst;
                res != NULL;
                res = res->pnext) {
            if (res->head >= head) {
                if (res->head == head) {
                    return res;
                } else {
                    return NULL;
                }
            }
        }
        return NULL;
    }



    command inline ch_rt_entry_t * CHLocalState.putRTEntry(
            uint8_t level, uint16_t head) {
        ch_rt_entry_t * res;
        ch_rt_entry_t * pprev;

        --level;

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (level >= CH_MAX_NUM_RT_ROWS) {
            dbgerror("CH|ERROR", \
                "Invalid routing entry level %hhu! " \
                "Allowed values: 1..%hhu! [%s]\n", level + 1, \
                CH_MAX_NUM_RT_ROWS, __FUNCTION__);
            return NULL;
        }
#endif
#endif

        // Check if the entry exists.
        for (res = rt.rows[level].pfirst, pprev = NULL;
                res != NULL;
                res = res->pnext) {
            if (res->head >= head) {
                if (res->head == head) {
                    // If the entry exists, then return it.
                    return res;
                } else {
                    break;
                }
            }
            pprev = res;
        }

        // The entry does not exist, so try to allocate it.
        if (rt.pfree == NULL) {
            return NULL;
        }
        ++rt.numEntries;
        res = rt.pfree;
        rt.pfree = rt.pfree->pnext;

        // Add the entry to the list.
        if (pprev == NULL) {
            // The entry will be added at the beginning.
            res->pnext = rt.rows[level].pfirst;
            rt.rows[level].pfirst = res;
        } else {
            // The entry will be added in the middle.
            res->pnext = pprev->pnext;
            pprev->pnext = res;
        }
        res->head = head;
        res->level = level + 1;

        return res;
    }



    command inline ch_rt_entry_t * CHLocalState.removeRTEntry(
            uint8_t level, uint16_t head) {
        ch_rt_entry_t * res;
        ch_rt_entry_t * pprev;

        --level;

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (level >= CH_MAX_NUM_RT_ROWS) {
            dbgerror("CH|ERROR", \
                "Invalid routing entry level %hhu! " \
                "Allowed values: 1..%hhu! [%s]\n", level + 1, \
                CH_MAX_NUM_RT_ROWS, __FUNCTION__);
            return NULL;
        }
#endif
#endif

        for (res = rt.rows[level].pfirst, pprev = NULL;
                res != NULL;
                res = res->pnext) {
            if (res->head >= head) {
                if (res->head == head) {
                    call CHLocalState.removeRTEntryByPointers(res, pprev);
                    return res;
                } else {
                    return NULL;
                }
            }
            pprev = res;
        }

        return NULL;
    }



    command inline void CHLocalState.removeRTEntryByPointers(
            ch_rt_entry_t * pentry, ch_rt_entry_t * pprev) {
        // Remove the entry from the level list.
        if (pprev == NULL) {
            rt.rows[pentry->level - 1].pfirst = pentry->pnext;
        } else {
            pprev->pnext = pentry->pnext;
        }

        // Add the entry to the entry pool.
        pentry->pnext = rt.pfree;
        rt.pfree = pentry;
        --rt.numEntries;
    }



    command inline ch_rt_entry_t * CHLocalState.changeRTEntryLevel(
            ch_rt_entry_t * pentry, uint8_t level) {
        ch_rt_entry_t * pcurr;
        ch_rt_entry_t * pprev;

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (level - 1 >= CH_MAX_NUM_RT_ROWS) {
            dbgerror("CH|ERROR", \
                "Invalid routing entry level %hhu! " \
                "Allowed values: 1..%hhu! [%s]\n", level, \
                CH_MAX_NUM_RT_ROWS, __FUNCTION__);
            return NULL;
        }
        if (pentry == NULL) {
            dbgerror("CH|ERROR", \
                "NULL routing entry! [%s]\n", __FUNCTION__);
            return NULL;
        }
        if (pentry->level - 1 >= CH_MAX_NUM_RT_ROWS) {
            dbgerror("CH|ERROR", \
                "Invalid level %hhu of a routing entry! " \
                "Allowed values: 1..%hhu! [%s]\n", pentry->level, \
                CH_MAX_NUM_RT_ROWS, __FUNCTION__);
            return NULL;
        }
#endif
#endif

        // Find the entry in its row.
        pprev = NULL;
        pcurr = rt.rows[pentry->level - 1].pfirst;
        while (pcurr != NULL && pcurr != pentry) {
            pprev = pcurr;
            pcurr = pcurr->pnext;
        }

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (pcurr == NULL) {
            dbgerror("CH|ERROR", \
                "Internal error: Entry from level %hhu not found at " \
                "this level! [%s]\n", pentry->level, __FUNCTION__);
            return NULL;
        }
#endif
#endif

        // Remove the entry.
        if (pprev == NULL) {
            rt.rows[pcurr->level - 1].pfirst = pcurr->pnext;
        } else {
            pprev->pnext = pcurr->pnext;
        }

        // Add the entry.
        for (pprev = NULL, pcurr = rt.rows[level - 1].pfirst;
                pcurr != NULL;
                pcurr = pcurr->pnext) {
            if (pcurr->head >= pentry->head) {
                break;
            }
            pprev = pcurr;
        }

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (pcurr != NULL) {
            if (pcurr->head == pentry->head) {
                dbgerror("CH|ERROR", \
                    "Internal error: Entry %hu at level %hhu duplicated! [%s]\n ", \
                    pentry->head, pentry->level, __FUNCTION__);
            }
        }
#endif
#endif

        if (pprev == NULL) {
            pentry->pnext = rt.rows[level - 1].pfirst;
            rt.rows[level - 1].pfirst = pentry;
        } else {
            pentry->pnext = pprev->pnext;
            pprev->pnext = pentry;
        }

        // Change the 'level' filed of the entry.
        pentry->level = level;

        return pentry;
    }



    command inline ch_rt_entry_t * CHLocalState.getFirstRTEntryAtLevel(
            uint8_t level) {

        --level;

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (level >= CH_MAX_NUM_RT_ROWS) {
            dbgerror("CH|ERROR", \
                "Invalid routing entry level %hhu! " \
                "Allowed values: 1..%hhu! [%s]\n", level + 1, \
                CH_MAX_NUM_RT_ROWS, __FUNCTION__);
            return NULL;
        }
#endif
#endif

        return rt.rows[level].pfirst;
    }



    command inline ch_rt_entry_t * CHLocalState.getNextRTEntryAtLevel(
            ch_rt_entry_t const * pentry) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (pentry == NULL) {
            dbgerror("CH|ERROR", \
                "NULL routing entry! [%s]\n", __FUNCTION__);
            return NULL;
        }
#endif
#endif

        return pentry->pnext;
    }



    command inline ch_rt_entry_t * CHLocalState.getRTEntryAtAnyHigherLevel(
            uint8_t level, uint16_t head) {

#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        if (level == 0 || level >= CH_MAX_LABEL_LENGTH) {
            dbgerror("CH|ERROR", \
                "Invalid routing entry level %hhu! " \
                "Allowed values: 1..%hhu! [%s]\n", level, \
                CH_MAX_LABEL_LENGTH, __FUNCTION__);
            return NULL;
        }
#endif
#endif

        for (; level < CH_MAX_LABEL_LENGTH; ++level) {
            ch_rt_entry_t * res;
            res = call CHLocalState.getRTEntry(level, head);
            if (res != NULL) {
                return res;
            }
        }

        return NULL;
    }



    // ---------------------- Interface CHStateDebug ----------------------
    command void CHStateDebug.tossimDbgLabel(char * channel) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        uint8_t i;

        dbg_clear(channel, "%hu", labelElements[0]);
        for (i = 1; i < labelLength; ++i) {
            dbg_clear(channel, " %hu", labelElements[i]);
        }
#endif
#endif
    }



    command void CHStateDebug.tossimDbgRoutingTable(char * channel) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        uint8_t              row;
        uint8_t              i;
        ch_rt_entry_t *      pentry;

        for (row = 0; row < CH_MAX_NUM_RT_ROWS; ++row) {
            for (pentry = rt.rows[row].pfirst;
                    pentry != NULL;
                    pentry = pentry->pnext) {
                dbg_clear(channel, " <L:%hhu,H:%hu,D:%hhu", \
                    pentry->level, pentry->head, pentry->numHops);
                for (i = 0; i < CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES; ++i) {
                    if (pentry->nextHops[i].addr != AM_BROADCAST_ADDR) {
                        dbg_clear(channel, ",(A:%hu)", \
                            pentry->nextHops[i].addr);
                    }
                }
                dbg_clear(channel, ",M:[PHB{S:%u,T:%hu},M[PHDV{S:%u,T:%hu,A:%s}]>", \
                    pentry->maintenance.phb.seqNo, \
                    pentry->maintenance.phb.ttl, \
                    pentry->maintenance.phdv.seqNo, \
                    pentry->maintenance.phdv.ttl, \
                    pentry->maintenance.phdv.adjacent ? "yes" : "no");
            }
        }
        dbg_clear(channel, "\n");
#endif
#endif
    }



    command void CHStateDebug.tossimPrintLabel() {
#ifdef TOSSIM
        uint8_t i;

        printf("%hu", labelElements[0]);
        for (i = 1; i < labelLength; ++i) {
            printf(".%hu", labelElements[i]);
        }
        for (i = labelLength; i < CH_MAX_LABEL_LENGTH; ++i) {
            printf(".?");
        }
#endif
    }



}
