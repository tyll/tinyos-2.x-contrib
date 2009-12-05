#-*-Makefile-*- vim:syntax=make
# taken from sim.extra in Tos 2.02

GCC=gcc
GPP=g++
SWIG=swig
OPTFLAGS=-g -O0 -I. -I$(TOSROOT)/tos/lib/tossim
LIBS=-lm-lstdc++ 
PFLAGS+= -tossim 
WFLAGS=-Wno-nesc-data-race
PYTHON_VERSION=2.5
PLATFORM=micaz

LIBNAME=SimxProbe

BUILD ?=$(APP_ROOT)/simbuild/simx/probe

SWIG_INPUT=probe.i
SWIG_OUTPUT=probe_wrap.c
SWIG_PY=SimxProbe.py
SWIG_OBJ=$(BUILD)/probe.o
SWIG_OPTS=-python -o $(SWIG_OUTPUT)

# *ix targets
TOSSIM_SO=$(APP_ROOT)/_TOSSIMmodule.so
SYNC_SO=$(BUILD)/_$(LIBNAME)module.so
# window targets
TOSSIM_DLL=$(APP_ROOT)/_TOSSIM.dll
SYNC_DLL=$(BUILD)/_$(LIBNAME).dll

OBJFILES   = $(SWIG_OBJ)

PYDIR      = /usr/include/python$(PYTHON_VERSION)
XML        = $(APP_ROOT)/app.xml
DUMPTYPES  = -fnesc-dump=components -fnesc-dump=variables -fnesc-dump=constants -fnesc-dump=typedefs -fnesc-dump=interfacedefs -fnesc-dump=tags

all: pre-build install

ifeq ($(findstring cygwin, $(OSTYPE)),cygwin)
  OS=Windows_NT
endif

ifeq ($(OS), Windows_NT) 
  PLATFORM_FLAGS=-DUSE_DL_IMPORT -fpic 
  SHARED_OBJECT=$(SYNC_DLL)
  CORE_SO=$(TOSSIM_DLL)
  CORE_LINK_SO=$(BUILD)/_TOSSIM_tossim_sync.dll.a
  DEF_FILE=$(BUILD)/_TOSSIM.def
  PLATFORM_BUILD_FLAGS=-shared -fpic -W1,--enabled-auto-image-base 
  PLATFORM_LIB_FLAGS=-L/usr/lib/python$(PYTHON_VERSION)/config -L/$(PYDIR)/config -lm -lstdc++ -lpython$(PYTHON_VERSION)

$(CORE_LINK_SO): $(CORE_SO)
	@# re-build the _TOSSIM dll with all exports
	@echo "  rebuilding $(CORE_SO) -- need exports"
	dlltool -D _TOSSIM.dll --export-all-symbols -e $(BUILD)/_TOSSIM.exp $(CORE_SO)
	$(GPP) $(PLATFORM_BUILD_FLAGS) $(PLATFORM_CC_FLAGS) $(APP_ROOT)/simbuild/micaz/*.o $(PLATFORM_LIB_FLAGS) -Wl,$(BUILD)/_TOSSIM.exp -o $(CORE_SO)
	@# now make linker...
	dlltool -D _TOSSIM.DLL -d tossim.def -l $(CORE_LINK_SO)

else ifeq ($(findstring darwin, $(OSTYPE)), darwin)
  PLATFORM_FLAGS=-fPIC
  PLATFORM_CC_FLAGS=-bundle
  SHARED_OBJECT=$(SYNC_SO)
  CORE_SO=$(TOSSIM_SO)
  PLATFORM_BUILD_FLAGS=-flat_namespace -undefined suppress 
  PLATFORM_LIB_FLAGS=-lstdc++ 

else # linux
  PLATFORM_FLAGS=-shared -fPIC
  SHARED_OBJECT=$(SYNC_SO)
  CORE_SO=$(TOSSIM_SO)
  PLATFORM_LIB_FLAGS=-lstdc++ 
  PLATFORM_BUILD_FLAGS=-shared -fPIC

endif

CORE_LINK_SO ?= $(CORE_SO)

BUILD_DEPS =

pre-build:
	mkdir -p $(BUILD)

install: $(SWIG_PY) $(SHARED_OBJECT)
	@echo "*** Installing to $(APP_ROOT)."
	@cp $(SWIG_PY) $(APP_ROOT)/
	@cp $(SHARED_OBJECT) $(APP_ROOT)/
	@echo "=== $(LIBNAME) installed ==="
	@echo

swig: $(SWIG_OUTPUT)

$(SWIG_OBJ): $(SWIG_OUTPUT)
	@echo "  compiling $(SWIG_OBJ) (SWIG)"
	$(GCC) -c $(PLATFORM_CC_FLAGS) $(PLATFORM_FLAGS) -o $(SWIG_OBJ) $(OPTFLAGS) $(CFLAGS) $(SWIG_OUTPUT) -I$(PYDIR)

$(SHARED_OBJECT): $(OBJFILES) $(CORE_LINK_SO)
	@echo "  creating $(LIBNAME) shared object ./$(SHARED_OBJECT)"
	$(GCC) $(PLATFORM_BUILD_FLAGS) $(PLATFORM_CC_FLAGS) $(OBJFILES) $(PLATFORM_LIB_FLAGS) $(CORE_LINK_SO) -o $(SHARED_OBJECT)
	@echo "*** Successfully built $(PLATFORM) $(LIBNAME) library. "

$(SWIG_PY): $(SWIG_INPUT)
	$(SWIG) $(SWIG_OPTS) $(SWIG_INPUT)

$(SWIG_OUTPUT): $(SWIG_INPUT)
	$(SWIG) $(SWIG_OPTS) $(SWIG_INPUT)

clean:
	-rm -f $(SHARED_OBJECT)
	-rm -f $(OBJFILES) 

distclean: clean
	-rm -f *~ \#*\#

FORCE:
