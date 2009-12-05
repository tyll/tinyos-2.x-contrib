APP_ROOT ?=..
BUILD =$(APP_ROOT)/simbuild

SIMACT_TARGET =$(BUILD)/simact.py

all: pre-build install

pre-build:
	mkdir -p $(BUILD)

install: $(SIMACT_TARGET)

$(SIMACT_TARGET): simact.py
	cp simact.py $(SIMACT_TARGET)
	chmod a+x $(SIMACT_TARGET)

clean:
