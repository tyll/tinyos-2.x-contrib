# $Id$

#
# Copyright (c) 2010 Data & Knowledge Engineering Research Center,
#                    Harbin Institute of Technology, P. R. China.
# All rights reserved.
#

##
# 
# @author: LIU Yu <pineapple.liu@gmail.com>
# @date:   Jun 18 2010
#

COMPONENT = SenseAppC

##
# HITDKEDIR is the root directory of HITDKE's contrib projects.
# 
HITDKEDIR ?= ../..

##
# SENSORBOARD types is *null* by default.
# In this defult setting, the app's configuration remains the same as it was 
# in the official tinyos-2.x distribution.
#
# change this to "synsb" (or specify as an nvironment variable) will bind all
# (supported) Sensor components to the Synthetic SensorBoard (SSB).
# 
# NOTE: *synsb* only compiles in TOSSIM mode (aka. *sim* or *sim-sf* extras).
#
SENSORBOARD ?= 

ifeq ($(SENSORBOARD),synsb)
  include $(HITDKEDIR)/tos/sensorboards/synsb/synsb.rules
else
  include $(MAKERULES)
endif

