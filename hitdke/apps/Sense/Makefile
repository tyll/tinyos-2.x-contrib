# $Id$

#
# Copyright (c) 2010 Data & Knowledge Engineering Research Center,
#                    Harbin Institute of Technology, P. R. China.
# All rights reserved.
#

##
# @author: LIU Yu <pineapple.liu@gmail.com>
# @date:   Jun 18 2010
#

COMPONENT = SenseAppC

##
# HITDKEDIR is the root directory of HITDKE's contrib projects.
#

HITDKEDIR ?= ../..

##
# Default SENSORBOARD types are set by specific platforms.
# 
# Uncomment the following line (or specify as an environment variable) will set 
# the SENSORBOARD type to "synsb", which implicitly binds all (supported) Sensor 
# components to HITDKE's Synthetic SensorBoard (SSB) simulator.
# 
# NOTE: *synsb* only compiles in TOSSIM mode (aka. *sim* or *sim-sf* extras).
#

# SENSORBOARD = synsb

ifeq ($(SENSORBOARD),synsb)
  include $(HITDKEDIR)/tos/sensorboards/synsb/synsb.rules
else
  include $(MAKERULES)
endif

