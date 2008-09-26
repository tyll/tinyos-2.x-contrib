

.PHONY: all ccheck tcheck install uninstall

all: ccheck tcheck

ccheck: 
ifndef CONTRIBDIR
	$(error variable CONTRIBDIR not defined)
else
	@echo 'using contrib directory at $(CONTRIBDIR)'
endif


tcheck: 
ifndef TOSROOT
	$(error variable TOSROOT not defined)
else
	@echo 'using tinyos directory at $(TOSROOT)'
endif
ifeq (,$(findstring 2.x, $(TOSROOT)))
	$(warning Warning! TOSROOT($(TOSROOT)) does not look like a TinyOS 2 root.)
endif

install: ccheck tcheck
	ln -sf $(CONTRIBDIR)/eon/tos/platforms/turtlenet $(TOSROOT)/tos/platforms/turtlenet
	

uninstall: tcheck
	rm -rf $(TOSROOT)/tos/platforms/turtlenet



