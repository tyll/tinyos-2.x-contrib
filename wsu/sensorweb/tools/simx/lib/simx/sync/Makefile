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

LIBNAME=TossimSync

BUILD ?=$(APP_ROOT)/simbuild/simx/sync

LIB_SRC1=sync.cxx
LIB_OBJ1=$(BUILD)/sync.o

LIB_SRC2=sync_impl.c
LIB_OBJ2=$(BUILD)/sync_impl.o

SWIG_INPUT=sync.i
SWIG_CXX=sync_wrap.cxx
SWIG_PY=SimxSync.py
SWIG_OBJ=$(BUILD)/sync_wrap.o
SWIG_OPTS=-shadow -python -c++ -o $(SWIG_CXX)

MODNAME=SimxSync

# *ix targets
TOSSIM_SO=$(APP_ROOT)/_TOSSIMmodule.so
SYNC_SO=$(BUILD)/_$(MODNAME)module.so
# window targets
TOSSIM_DLL=$(APP_ROOT)/_TOSSIM.dll
SYNC_DLL=$(BUILD)/_$(MODNAME).dll

OBJFILES   = $(LIB_OBJ2) $(LIB_OBJ1) $(SWIG_OBJ)

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
  CORE_LINK_SO=$(BUILD)/_TOSSIM_sync.dll.a
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
	cp $(SWIG_PY) $(APP_ROOT)/
	cp $(SHARED_OBJECT) $(APP_ROOT)/
	@echo "*** Installed $(LIBNAME) to $(APP_ROOT)."

swig: $(SWIG_CXX)

$(LIB_OBJ1): $(LIB_SRC1)
	@echo "  compiling $(LIB_OBJ1) (interface)"
	$(GPP) -c $(PLATFORM_CC_FLAGS) $(PLATFORM_FLAGS) -o $(LIB_OBJ1) $(OPTFLAGS) $(CFLAGS) $(LIB_SRC1) -I$(PYDIR)

$(LIB_OBJ2): $(LIB_SRC2)
	@echo "  compiling $(LIB_OBJ2) (implementation)"
	$(GPP) -c $(PLATFORM_CC_FLAGS) $(PLATFORM_FLAGS) -o $(LIB_OBJ2) $(OPTFLAGS) $(CFLAGS) $(LIB_SRC2) -I$(PYDIR)

$(SWIG_OBJ): $(SWIG_CXX)
	@echo "  compiling $(SWIG_OBJ) (SWIG)"
	$(GPP) -c $(PLATFORM_CC_FLAGS) $(PLATFORM_FLAGS) -o $(SWIG_OBJ) $(OPTFLAGS) $(CFLAGS) $(SWIG_CXX) -I$(PYDIR)

$(SHARED_OBJECT): $(OBJFILES) $(CORE_LINK_SO)
	@echo "  creating $(LIBNAME) shared object ./$(SHARED_OBJECT)"
	$(GPP) $(PLATFORM_BUILD_FLAGS) $(PLATFORM_CC_FLAGS) $(OBJFILES) $(PLATFORM_LIB_FLAGS) $(CORE_LINK_SO) -o $(SHARED_OBJECT)
	@echo "*** Successfully built $(PLATFORM) $(LIBNAME) library. "

$(SWIG_PY): $(SWIG_INPUT)
	$(SWIG) $(SWIG_OPTS) $(SWIG_INPUT)

$(SWIG_CXX): $(SWIG_INPUT)
	$(SWIG) $(SWIG_OPTS) $(SWIG_INPUT)

clean:
	-rm -f $(SHARED_OBJECT)
	-rm -f $(OBJFILES) *.pyc

distclean: clean
	-rm -f *~ \#*\#

FORCE:
