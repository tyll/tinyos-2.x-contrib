################################################################################
# HITDKE Synthetic DataSource (SDS) Project                                    #
#                                                                              #
# Copyright (C) 2010, Data & Knowledge Engineering Research Center,            #
#                     Harbin Institute of Technology, P. R. China.             #
# All rights reserved.                                                         #
#                                                                              #
# @author LIU Yu <pineapple.liu@gmail.com>                                     #
# @date   Jun 21, 2010                                                         #
#                                                                              #
################################################################################

# initialization
CC = cc
CCFLAGS = -m32 -Wall -ansi -std=gnu99 -g0 -O3 -shared -fPIC -pthread 
CCINCS = -I src
CCDEFS = -D DKERC -D SYNSB -D NDEBUG

AR = ar
ARFLAGS = rcvs
AWK = gawk
DOCTOOL = doxygen
LN = ln -fs
TAR = tar
TAREXT = tar.gz
MD = mkdir -p
INSTALL = install -D

# buid sources and targets
LIBRARY = sds
VERSION = 0.0.1
RELEASE = 1
$(LIBRARY)_hdr = DataSource.h
$(LIBRARY)_src = $($(LIBRARY)_hdr:.h=.c)
$(LIBRARY)_obj = $($(LIBRARY)_src:.c=.o)
$(LIBRARY)_sdist = $(LIBRARY).h $($(LIBRARY)_hdr) $($(LIBRARY)_src) Makefile

# build branches
.PHONY: all clean

all: lib$(LIBRARY).a

lib$(LIBRARY).a: $($(LIBRARY)_obj)
	$(AR) $(ARFLAGS) $(@) $($(LIBRARY)_obj)

$($(LIBRARY)_obj): $($(LIBRARY)_sdist)

clean:
	rm -rf doc
	rm -f $($(LIBRARY)_obj) lib$(LIBRARY).a lib$(LIBRARY).so \
	lib$(LIBRARY).so.$(VERSION)

%.o: %.c
	$(CC) $(CCFLAGS) $(CCDEFS) $(CCINCS) -c -o $(@) $(<)

