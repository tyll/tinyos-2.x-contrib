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

HITDKEDIR ?= ../..
SYNSBDIR ?= $(HITDKEDIR)/tos/sensorboards/synsb
CUSTOMSIMFILE ?= $(HITDKEDIR)/tos/lib/tossim/sim_synsb.c
CUSTOMSIMOBJFILE ?= $(BUILDDIR)/sim_synsb.o

PFLAGS += -I $(SYNSBDIR)
BUILD_EXTRA_DEPS += custom-sim-module
CLEAN_EXTRA = *.pyc *.pyo *.dll *.o *.so

custom-sim-module: $(CUSTOMSIMFILE)
	@echo "  compiling synthetic sensorboard implementation into $(CUSTOMSIMOBJFILE)"
	$(GPP) -c $(PLATFORM_CC_FLAGS) $(PLATFORM_FLAGS) -o $(CUSTOMSIMOBJFILE) $(OPTFLAGS) $(CFLAGS) $(SIM_CFLAGS) $(SF_FLAGS) $(CUSTOMSIMFILE) -I$(PYDIR) -I$(SIMDIR)

include $(MAKERULES)

PLATFORM_LIB_FLAGS += $(CUSTOMSIMOBJFILE)
