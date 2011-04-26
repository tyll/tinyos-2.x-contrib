######################################################################
# 
#  Top-level make file.  Just build all of the apps
#
######################################################################


# default to using -s, unless VERBOSE_MAKE is set
ifeq ($(VERBOSE_MAKE)_x, _x)
MAKEFLAGS += -s
endif
export VERBOSE_MAKE


# catch-all rule - pass targets on to the lower level
%:
	@for d in `ls`; do \
	if [ -f $$d/Makefile ]; then \
		echo "$$d...."; \
		$(MAKE) -C $$d $@ || fail=yes; \
	fi; \
	done; test -z "$$fail"
