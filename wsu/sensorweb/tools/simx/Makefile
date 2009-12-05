all: FORCE

clean: FORCE
	make -C lib clean
	make -C python clean

test: FORCE
	make -C python test

doc: epydoc

epydoc: FORCE
	epydoc -v -o docs/simx simx.sync simx.probe \
		simx.base simx.sensor simx.event \
		simx.dyntopo simx.inject simx.fluid

FORCE:
