#
# IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
# downloading, copying, installing or using the software you agree to
# this license.  If you do not agree to this license, do not download,
# install, copy or use the software.
#
# Copyright (c) 2006-2008 Vrije Universiteit Amsterdam and
# Development Laboratories (DevLab), Eindhoven, the Netherlands.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# - Redistributions of source code must retain the above copyright
#   notice, this list of conditions, the author, and the following
#   disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions, the author, and the following disclaimer
#   in the documentation and/or other materials provided with the
#   distribution.
# - Neither the name of the Vrije Universiteit Amsterdam, nor the name of
#   DevLab, nor the names of their contributors may be used to endorse or
#   promote products derived from this software without specific prior
#   written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL VRIJE
# UNIVERSITEIT AMSTERDAM, DEVLAB, OR THEIR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Authors: Konrad Iwanicki
# CVS id: $Id$
#

COMPONENT=HierarchicalClusteringDemoAppC



# *** Includes. ***

HC_DEMO_INCLUDES = -I../../tos/interfaces/
HC_DEMO_INCLUDES += -I../../tos/le/
HC_DEMO_INCLUDES += -I../../tos/hierclust/common/
HC_DEMO_INCLUDES += -I../../tos/hierclust/interfaces/
HC_DEMO_INCLUDES += -I../../tos/hierclust/phb/
HC_DEMO_INCLUDES += -I../../tos/hierclust/phdv/
HC_DEMO_INCLUDES += -I../../tos/hierclust/hybrid/
HC_DEMO_INCLUDES += -I../../tos/sequencing/
HC_DEMO_INCLUDES += -I../../tos/utils/



# *** Static configuration of some components. ***

CFLAGS += -DTOSH_DATA_LENGTH=114
CFLAGS += -DCC2420_DEF_RFPOWER=7
# CFLAGS += -DLOW_POWER_LISTENING=1
# CFLAGS += -DHC_DEMO_USE_LPL=1

CFLAGS += -DDEF_MAX_NUM_NEIGHBORS=80
CFLAGS += -DDEF_CH_MAX_LABEL_LOGLENGTH=4
CFLAGS += -DDEF_CH_MAX_LABEL_LENGTH=6
CFLAGS += -DDEF_CH_MAX_NUM_RT_ENTRIES=80
CFLAGS += -DDEF_CH_MAX_RT_ENTRY_NEXT_HOP_CANDIDATES=3

# !!! Choose *one* of the three flags below. !!!
# CFLAGS += -DCH_MAINTPROT_PERIODIC_HIERARHICAL_BEACONING=1
CFLAGS += -DCH_MAINTPROT_PERIODIC_HIERARHICAL_DISTANCE_VECTOR=1
# CFLAGS += -DCH_MAINTPROT_HYBRID_BEACONING_AND_DISTANCE_VECTOR=1


CFLAGS += $(HC_DEMO_INCLUDES)



# *** All additional dependencies. ***

# CLEAN_EXTRA += \



# *** All additional make rules. ***

include $(MAKERULES)
