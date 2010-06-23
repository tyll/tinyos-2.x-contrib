# $Id$

#
# Copyright (c) 2010 Data & Knowledge Engineering Research Center,
#                    Harbin Institute of Technology, P. R. China.
# All rights reserved.
#

##
# @author: LIU Yu <pineapple.liu@gmail.com>
# @date:   Jun 22, 2010
#

COMPONENT = SenseAppC

SENSORBOARD ?= synsb

ifeq ($(SENSORBOARD),synsb)
HITDKEDIR ?= ../..
TOSMAKE_PATH += $(HITDKEDIR)/support/make
BUILD_EXTRA_DEPS += sim-synsb-deps
endif

include $(MAKERULES)

