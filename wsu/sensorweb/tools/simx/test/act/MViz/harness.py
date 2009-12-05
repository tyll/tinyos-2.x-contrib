#
# Sample file for TReact harness.
#
# This assumes that the TOSSIM module has been built with sim-sf,
# TossimSync and PseudoSensor support following the convention where
# the directory (or link) "simx" refers to the top-level of the SimX
# structure. If this is not true, then this file must be appropriately
# customized.
#

# (Required) Add SimX to module search path.
import sys
sys.path.append("simx")

# (Required for setup) Load additional objects -- requires compiled support!
#from PseudoSensor import PseudoSensor
from pseudo_sensor import PseudoSensorSupport

# (Highly recommended) Variables scheme must be loaded to enable
# monitoring.
from tinyos.tossim.TossimApp import NescApp
print "loading variables from 'app.xml'..."
app = NescApp()
vars = app.variables.variables()

# (Required for this setup) TossimTopo provides topology control
# extension to Tossim. The normal Tossim object may be used but it
# will require disabling some "core" modules below.
print "starting tossim-topo"
import TOSSIM
from tossim_topo import Topo, TopoGen
tossim = Topo.TossimTopo(TOSSIM, vars if vars is not None else [])
tossim_topo = tossim
T = tossim

# (Required for this setup) Schedule python events "in mote
# time". This provides the periodic time reporting. It is also
# extremely useful to setup events that occur when a node is booted.
from tossim_evt.TossimEvent import *
tossim_event = TossimEvent(tossim)

# (Optional) Enable to forward packets from mote serial to SF.  This
# is not strictly required for TReact but allows another application
# to simultaneously monitor normal mote output.
from TOSSIM import SerialForwarder
sf = SerialForwarder(9002)

# (Required for this setup) Manage simulation time. This can be
# disabled but it requires disabling a "core" module.
from TossimSync import TossimSync
from act import TimeControl
time_control = TimeControl.Remote(tossim, TossimSync(), tossim_event)

# (Required) Start packet injector.
print "starting injector"
from simsf_inject.SFInject import SFInject
injector = SFInject(9091).start()

# (Required) Create the main reactor. For consistency with modules,
# the global variable 'R' should be used.
print "creating reactor"
from act.ReactR import ReactR
R = ReactR(injector=injector, globals=globals())

# (Required unless explicit passed in to loadMod()) Allows modules to
# automatically "discover" services.
R.service.register(time_control, "TimeControl")
R.service.register(tossim_topo, "Tossim", "TossimTopo")

# (Highly recommended) Load standard modules. Disabling these modules
# will result in reduced TReactViz capabilities.
print "loading standard modules"
R.loadMod('Core')
R.loadMod('Topo')
R.loadMod('Watch')
R.loadMod('Time')

# (Recommended) Periodically display the time on the local console.
def ping(t):
  print "at simtime %s" % t.timeStr()
  tossim_event.runAt(t.time() + t.ticksPerSecond(), ping)
tossim_event.runAt(0, ping)

# (Optional) Pause the simulation until started manually.
print "starting simulation 'paused'."
time_control.stop()

# (Required) Run the primary event loop. The order presented below
# (run simulation cycle, process TossimEvent, process TReact, process
# SF) is how TReact has been tested. Other configurations should work.
while 1:
  time_control.runSim()
  tossim_event.processEvents()
  R.process(locals=locals())
  sf.process()
