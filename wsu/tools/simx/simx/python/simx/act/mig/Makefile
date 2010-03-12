MIG=mig
NCG=ncg

MIG_SRC = $(shell dirname `pwd`)/React.h
MESSAGES = ReactBase ReactCmdBase ReactNodeInfo ReactReply
MESSAGES += ReactLink ReactProbe
MESSAGES += ReactBindWatchBase ReactWatch
MESSAGES += TimeEvent

JAVA_DEST=java/mig
PYTHON_DEST=python

PYTHON_FILES = $(MESSAGES:%=$(PYTHON_DEST)/%.py)
JAVA_FILES = $(MESSAGES:%=$(JAVA_DEST)/%Msg.java)

CONSTANTS = MAX_REACT_PAYLOAD
CONSTANTS += RESULT_SUCCESS RESULT_FAILURE RESULT_PARTIAL RESULT_UNSOLICITED
CONSTANTS += REFINE_NORMAL REFINE_INFO REFINE_WARN REFINE_ERROR	\
REFINE_FATAL REFINE_DEBUG
CONSTANTS += NODE_ON NODE_INVALID NODE_STALE
CONSTANTS += INVALID_LINK IGNORE_LINK

all: structure $(PYTHON_FILES) $(JAVA_FILES) $(JAVA_DEST)/ReactConst.java $(PYTHON_DEST)/ReactConst.py

clean:
	-rm -f __init__.pyc
	-rm -f $(JAVA_DEST)/*.java
	-rm -f $(PYTHON_DEST)/*.{py,pyc}


structure: $(JAVA_DEST) $(PYTHON_DEST)/__init__.py __init__.py

$(JAVA_DEST):
	mkdir -p $(JAVA_DEST)

__init__.py:
	touch __init__.py

$(PYTHON_DEST)/__init__.py: $(PYTHON_DEST)
	touch $(PYTHON_DEST)/__init__.py

$(PYTHON_DEST):
	mkdir -p $(PYTHON_DEST)


$(JAVA_DEST)/ReactConst.java: $(MIG_SRC)
	$(NCG) -java-classname=simx.mig.ReactConst -o $@ java $(MIG_SRC) $(CONSTANTS)

$(PYTHON_DEST)/ReactConst.py: $(MIG_SRC)
	$(NCG) -python-classname=ReactConst -o $@ python $(MIG_SRC) $(CONSTANTS)


$(JAVA_FILES): $(JAVA_DEST)/%Msg.java: $(MIG_SRC)
	$(MIG) java $(MIG_SRC) `perl -e 'print join('_', map "\L$$_", split /(?<=[a-z])(?=[A-Z])/, q/$*/)'` -java-classname=simx.mig.$*Msg -o $@

$(PYTHON_FILES): $(PYTHON_DEST)/%.py: $(MIG_SRC)
	$(MIG) python $(MIG_SRC) `perl -e 'print join('_', map "\L$$_", split /(?<=[a-z])(?=[A-Z])/, q/$*/)'` -python-classname=Msg -o $(PYTHON_DEST)/$*.py
