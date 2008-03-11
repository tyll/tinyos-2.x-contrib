SensorScheme is an embedded interpreter for tinyos applications based on the
programming language Scheme. 

Before you start, please take into account that right now, SensorScheme is a project 
still in development, so things might not work as smooth as you'd hoped, and documentaiotn is
quite minimal, and at least not very structured yet. 
Please drop me a line if you can't manage to put it to work or don't understand something
at l.evers _at_ utwente.nl

Currently SensorScheme is only developed and tested to run on telosb (or tmotesky) motes, and 
in tossim for the micaz. It might work on other platforms but I haven't tested it.

How to install and use SensorScheme:

- The SensorScheme tool set is written for PLT scheme, so make sure you have 
  the mzscheme program in your path. This is the command line interpereter, 
  which is all you need, but you might want to iinstall the PLT scheme IDE 
  "DrScheme" and libraries as well. it is available at http://download.plt-scheme.org/
  or http://download.plt-scheme.org/mzscheme/ for the commandline only version
   
- I assume you have already downloaded SensorScheme from the tinyos2-contrib CVS repository
  Make a environment variable pointing there with the command:
   export SENSORSCHEME=$TOSROOT"-contrib/sensorscheme"
  it is a good idea to set also put this command in your ~/.profile file or some special tinyos
  config file it executes.

- To get your first sensorscheme program compiled, change to dir
    cd $SENSORSCHEME/support/sdk/sensorscheme 
  and type 
    mzscheme -C ../pltscheme/build.scm radioblink.scm 
  this builds the radioblink example program into the $SENSORSCHEME/apps/SensorScheme dir.
  change dir to that location (preferrably in a new terminal window):
    cd $SENSORSCHEME/apps/SensorScheme/radioblink
  and make it with:
    make telosb
  or build the TOSSIM version:
    make micaz sim

- for now, browse the sample programs in $SENSORSCHEME/support/sdk/sensorscheme and get a 
  feel for how sensorscheme programs are structured. 


- Before you start programming, make sure you know the scheme language. You can
  find tutorials and other documentation at 
    http://www.ccs.neu.edu/home/dorai/t-y-scheme/t-y-scheme.html
  or wherever google leads you: http://www.google.com/search?q=scheme+tutorial  
  
  


Good luck and have fun, 
Leon Evers