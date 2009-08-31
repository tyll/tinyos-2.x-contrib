
PYTHON?=/cygdrive/c/Python25/python.exe

all:	test

docs:	buildit
	PYTHONPATH=build\\lib.win32-2.5; $(PYTHON) -c 'import d2xx; help(d2xx)'

test:	buildit
	PYTHONPATH=build\\lib.win32-2.5; $(PYTHON) test.py

buildit:	
	$(PYTHON) setup.py build -c mingw32

clean:	
	rm -rf build

