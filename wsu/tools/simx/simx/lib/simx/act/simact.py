#!/usr/bin/env python

"""
Startup Runner for Simx Act/React.

@author Paul Stickney - Oct 2008
"""

from optparse import OptionParser
import os
import sys
import time
import traceback
from TOSSIM import *

# Enable compiled Simx modules to be found -- this assumes that this
# program was invoked from the directory from which they reside.
sys.path.insert(0, os.getcwd())

BANNER = "=" * 80

def banner(msg):
    printfh("%s\n%s\n%s" % (BANNER, msg.strip(), BANNER), sys.stdout)

def errbanner(msg):
    printfh("%s\n%s\n%s" % (BANNER, msg.strip(), BANNER))

def printfh(msg, fh=sys.stderr, flush=True):
    fh.write(msg)
    if flush:
        fh.flush()
    
try:
    import simx
except ImportError, e:
    errbanner("""
Failed to import base simx module:
Ensure PYTHONPATH contains the Simx python directory.

See the Simx documentation for more information.
""")

from simx.act import context

class Summary(object):
    """
    Maintain and display a collection of summaries.
    """

    def __init__(self):
        self.status = {}

    class Text(object):
        def __init__(self, msg): self.msg = msg
        def __str__(self): return self.msg

    class Ok(Text):
        is_okay = True
        def __init__(self, msg): Summary.Text.__init__(self, msg)

    class Warning(Text):
        is_warning = True
        def __init__(self, msg): Summary.Text.__init__(self, msg)

    class Error(Text):
        is_error = True
        def __init__(self, msg): Summary.Text.__init__(self, msg)

    def set(self, component, msg):
        "Set the summary of a specific component."
        self.status[component] = msg

    @staticmethod
    def text(msg):
        return Summary.Text(msg)

    @staticmethod
    def enabled(msg=""):
        return Summary.Ok("ENABLED: %s" % msg if msg else "ENABLED")

    @staticmethod
    def disabled(msg=""):
        return Summary.Warning("DISABLED: %s" % msg if msg else "DISABLED")

    @staticmethod
    def user_disabled(msg=""):
        return Summary.Ok("USER DISABLED: %s" % msg
                          if msg else "USER DISABLED")

    @staticmethod
    def error(msg):
        return Summary.Error("ERROR: %s" % msg)

    @staticmethod
    def requires(msg):
        return Summary.disabled("Requires " + msg)

    def show(self):
        "Show status of all summaries"
        print "-" * 80
        print "   STATUS SUMMARY"
        print
        for k in sorted(self.status.keys()):
            print "%15s : %-s" % (k, self.status[k])
        print "-" * 80

    def has_errors(self):
        return len([True for st in self.status.values()
                    if hasattr(st, 'is_error') and st.is_error])

    def has_warnings(self):
        return len([True for st in self.status.values()
                    if hasattr(st, 'is_warning') and st.is_warning])


def parse_options():
    """
    Returns [parser, options, args].
    """
    parser = OptionParser()
    opt = parser.add_option

    # Exactly one of --dynamic or --static MUST be specified.
    opt("--dynamic",
        action="store_true", dest="dynamic", default=False,
        help="Enable dynamic topology")

    opt("--static",
        action="store_true", dest="static", default=False,
        help="Disable dynamic topology")

    opt("--no-client",
        action="store_false", dest="client", default=True,
        help="Do not start React GUI client")

    opt("--tossim-vars",
        action="store_true", dest="use_vars", default=False,
        help="Enable standard Tossim vars "
        "(not needed for Probe")

    opt("--no-sensor",
        action="store_false", dest="sensor", default=True,
        help="Disable Sensor module")

    opt("--no-pushback",
        action="store_false", dest="pushback", default=True,
        help="Disable Pushback module")

    opt("--no-sync",
        action="store_false", dest="sync", default=True,
        help="Disable TimeSync module")

    opt("--no-probe",
        action="store_false", dest="probe", default=True,
        help="Disable Probe/ModProbe support")
    
    opt("--stopped",
        action="store_true", dest="start_paused", default=False,
        help="Start the simulating 'stopped' "
        "(normally it is started 'paused')")

    opt("--port",
        dest="port", type="int", default=9091,
        help="Change Act/React communication port "
        "(not recommended)")

    opt("--sf-port",
        dest="sf_port", type="int",
        help="enable Sim-SF bridge on port "
        "(requires sim-sf target)")

    opt("--ping",
        dest="ping", type="int", default=10,
        help="Print 'ping' to stdout evert PING seconds "
        "(disabled by default)")

    opt("--pause",
        dest="pause_time", type="int", default=4,
        help="Pause PAUSE_TIME seconds after loading environment")

    opt("-l", "--load",
        dest="loaders", action="append", default=[],
        help="Execute a loader on startup (e.g. -l Dynamic,10,1")

    opt("--loader-help",
        dest="loader_helps", action="append", default=[],
        help="Request help for a loader (e.g. --loader-help Dynamic)")

    opt("--show-loaders",
        dest="show_loaders", action="store_true", default=False,
        help="Show available Loaders and exit")

    return [parser] + list(parser.parse_args())


def create_logger():
    """
    Create the console logger.
    """
    import logging
    logging.basicConfig(level=logging.DEBUG)
    #console = logging.StreamHandler()
    #console.setLevel(logging.DEBUG)
    #formatter = logging.Formatter('%(name)-12s: %(levelname)-8s %(message)s')
    #console.setFormatter(formatter)
    #logging.getLogger('').addHandler(console)
    return logging.getLogger("runner")


def show_model_message():
    """
    Print text informing about static/dynamic options.
    """
    errbanner("""
Supported Radio Models:

== Static model (--static option) ==

  Established link-gain values are always used:
  Node positions are treated as virtual. That is, changing node positions
  DOES NOT affect the radio model. This is how TOSSIM normally works.

== Dynamic model (--dynamic option) ==
  
  Link-gain values are computed based upon the position of nodes:
  Changing node positions MAY affect the radio model and link quality.
  This enables a more interactive environment at the expense of repeatability.
  This model is required for some features, such as dynamic power control.

NOTE: The model used can NOT be changed after starting Act.
""")


def check_model(parser, options):
    """
    Ensure at least one one of the models has been selected or display
    a message and terminate.
    """

    if options.static and options.dynamic:
        log.error("Refusing to start without explicit model")
        show_model_message()
        parser.error("options --static and --dynamic are mutually exclusive")

    if not (options.static or options.dynamic):
        log.error("Refusing to start without explicit model")
        show_model_message()
        parser.error("must specific either --static or --dynamic option")


def show_loaders():
    """
    Display loaders which can be used.
    """
    from simx.act import loader
    banner("Loader List.")
    loader.list()


def show_loader_helps(helps):
    from simx.act import loader
    for h in helps:
        try:
            banner("Showing help for %s" % h)
            loader.load_single(h, display_help=True)
        except:
            exc = sys.exc_info()[1]
            if hasattr(exc, "print_exception"):
                exc.print_exception()
            else:
                traceback.print_exc()
            exit(1)


def load_tossim():
    """
    Load the TOSSIM module or display a user-friendly error and raise
    an exception.
    """
    try:
        import TOSSIM
        return TOSSIM

    except:
        exc = sys.exc_info()[0:2]
        log.error("Failed to load TOSSIM: %s" % exc)
        errbannerr("""
Failed to load TOSSIM

Make sure the application has been compiled for use with TOSSIM.
""")
        raise RuntimeError("Aborting")


def load_vars(use_vars):
    """
    Load tossim variables (using TossimApp)

    Returns (variable list or None, summary)
    """
    if use_vars:
        from tinyos.tossim.TossimApp import NescApp
        log.info("Loading variables from 'app.xml'...")
        app = NescApp()
        return (app.variables.variables(), Summary.enabled())

    else:
        log.warn("Variable support disabled")
        return (None, Summary.user_disabled())


def init_topo_tossim(tossim_vars=None, dynamic=None, tossim_mod=None):
    """
    Initialize the correct topology manager.
    
    The DynTopo manager is used even for static topologies; in this
    case there is simply no rebuilding of the model. This allows nodes
    to be moved or placed within a virtual area without actually
    trying to apply an automatic model.
     
    Returns (tossim, summary)
    """
    from simx.dyntopo import Topo

    topo = Topo.TossimTopo(tossim_mod.Tossim,tossim_vars or [], dynamic=dynamic)
    #topo = Topo.TossimTopo(tossim_mod.Tossim,tossim_vars or [])

    if dynamic:
        log.info("Using DYNAMIC topology manager.")
        return (topo, 'DYNAMIC')

    else:
        log.info("Using STATIC topology manager.")
        return (topo, 'STATIC')


def load_pushback(enable_pushback):
    """
    Attempts to load Pushback.

    Returns (pushback or None, summary)
    """
    if not enable_pushback:
        log.info("Pushback disabled (--no-pushback)")
        return (None, Summary.user_disabled())

    try:
        from SimxPushback import Pushback
    except:
        exc = sys.exc_info()[1]
        log.warn("Disabled Pushback: %s" % exc)
        return (None, Summary.error(exc))
    else:
        log.info("Loaded Pushback")
        return (Pushback(), Summary.enabled())

 
def load_sensor(enable_sensor, pushback):
    """
    Attempts to load Sensor.

    Returns (sensor_control or None, summary)
    """
    if not enable_sensor:
        log.info("Sensor disabled (--no-sensor)")
        return (None, Summary.user_disabled())

    elif not pushback:
        log.warn("Disabled Sensor: no Pushback")
        return (None, Summary.requires('Pushback'))

    try:
        from simx.sensor import SensorControl
    except:
        exc = sys.exc_info()[1]
        log.error("Disabled Sensor: %s" % exc)
        return (None, Summary.error(exc))
    else:
        log.info("Loaded Sensor")
        return (SensorControl(pushback=pushback), Summary.enabled())

 
def load_leds(enable_leds, pushback):
    """
    Attempts to load Sensor.

    Returns (sensor_control or None, summary)
    """
    if not enable_leds:
        log.info("Leds disabled (--no-leds)")
        return (None, Summary.user_disabled())

    elif not pushback:
        log.warn("Disabled Leds: no Pushback")
        return (None, Summary.requires('Pushback'))

    try:
        from simx.leds import LedControl
    except:
        exc = sys.exc_info()[1]
        log.error("Disabled Leds: %s" % exc)
        return (None, Summary.error(exc))
    else:
        log.info("Loaded Leds")
        return (LedControl(pushback=pushback), Summary.enabled())


def init_events(tossim):
    """
    Initialize Events.

    Returns TossimEvent object
    """
    from simx import event
    tossim_event = event.Manager(tossim)
    log.info("Loaded Event Manager")
    return tossim_event


def init_sim_sf(port):
    """
    Initializes the SF Link.
    
    Returns (sf or None, summary)
    """
    if not port:
        log.info("SerialForward-link not enabled (--sf-port to enabled)")
        return (None, Summary.user_disabled())

    try:
        from TOSSIM import SerialForwarder
        forwarder = SerialForwarder(port)
    except:
        exc = sys.exc_info()[1]
        log.warn("Disabled SerialForward: %s" % exc)
        return (None, Summary.error(exc))
    else:
        log.info("Started mote SerialForward-link on port %d" % port)
        return (forwarder, Summary.enabled("Port %s" % port))


def init_timecontrol(enable_sync, tossim, tossim_event):
    """
    Initializes the TimeControl.
    
    Returns (time_control or None, summary)
    """
    if not enable_sync:
        log.info("TimeControl disabled (--no-sync)")
        return (None, Summary.user_disabled())

    try:
        from SimxSync import SimxSync
    except:
        exc = sys.exc_info()[1]
        log.warn("Disabled TimeControl: %s" % exc)
        return (None, Summary.error(exc))
    else:
        from simx.act import time_control
        control = time_control.Remote(tossim, SimxSync(), tossim_event)
        log.info("Loaded TimeControl")
        return (control, Summary.enabled())


def load_probe_module(probe_enabled):
    """
    Attempt to load the Probe module, if enabled.
   
    Returns (probe_module, summary)
    """
    if not probe_enabled:
        log.info("Probe disabled (--no-probe)")
        return (None, Summary.user_disabled())

    try:
        import _SimxProbe
    except ImportError:
        exc = sys.exc_info()[1]
        log.warn("Failed to load Probe Module: %s" % exc)
        return (None, Summary.error(exc))
    else:
        return (_SimxProbe, Summary.enabled())


def init_probe_loader(probe_enabled, probe_module):
    """
    Initialize Probing if enabled and the module was loaded.
    
    Returns (probe_loader, summary)
    """
    if not probe_enabled:
        return (None, Summary.user_disabled())
    if not probe_module:
        return (None, Summary.requires('Probe Module'))

    try:
        from simx import probe
        loader = probe.Loader('app.xml', probe_module)
        #print " init_probe_loader():",loader,"\n"
        #loader = probe.Loader('app.xml', probe_module)
        
    except:
        exc = sys.exc_info()[1] 
        log.warn("Failed to load Probe Loader: %s" % traceback.format_exc())
        return (None, Summary.error(exc))
    else:
        return (loader, Summary.enabled())


def start_reactor(reactor_port):
    """
    Starts the reactor.
    
    Returns reactor-object
    """

    # (Required) Start packet injector.
    log.debug("Starting Injector on port %d" % reactor_port)
    from simx.inject import inject
    injector = inject.Inject(reactor_port).start()

    # (Required) Create the main reactor.
    log.info("Starting Act ReactR...")
    import simx.act.core
    return simx.act.core.ReactR(injector=injector)


def register_components(reactor, tossim, time_control):
    """
    Register reactor components. This enables name resolution to work.
    """
    log.debug("Registering ReactR components...")

    if time_control:
        reactor.service.register("TimeControl", time_control)

    reactor.service.register("Tossim", tossim)
    reactor.service.register("TossimTopo", tossim)


def load_core_mods(reactor):
    """
    Loads "core" reactor modules.
    
    Returns summary
    """
    log.debug("Loading Act modules...")

    reactor.load_mod('Core')
    log.info("ModCore loaded")

    reactor.load_mod('Topo')
    log.info("ModTopo loaded")

    return Summary.enabled()


def load_modwatch(reactor, tossim_vars):
    """
    Lod ModWatching
    """
    if tossim_vars: 
	
        reactor.load_mod('Watch', Tossim(tossim_vars))
        log.info("ModWatch loaded")
        return Summary.enabled()
    else:
        log.warning("ModWatch not loaded: requires Tossim Vars")
        return Summary.requires('Tossim Vars')


def load_modtime(reactor, time_control):
    """
    Load ModTime
    """
    if time_control:
        reactor.load_mod('Time')
        log.info("ModTime loaded")
        return Summary.enabled()
    else:
        log.warning("ModTime not loaded: requires TimeControl")
        return Summary.requires('TimeControl')


def load_modprobe(reactor, probe_loader):
    """
    Load ModProbe
    """
    if probe_loader:
        try:
            reactor.load_mod('Probe', probe_loader)
        except Exception, exc:
            log.warning("ModProbe not loaded: %s" % exc)
            return Summary.error(str(exc))
        else:
            log.info("ModProbe loaded")
            return Summary.enabled()
    else:
        log.warning("ModProbe not loaded: requires Probe Vars")
        return Summary.requires('Probe Vars')


def enable_ping(ping_time, tossim_event):
    """
    Enables "pings" if ping time is a value larger than 0 and events
    are enabled.

    Returns (ping_enabled, summary)
    """
    if ping_time <= 0:
        log.info("'Ping' disabled (--ping 0?)")
        return (False, Summary.user_disabled())

    elif tossim_event:
        def ping(tossim):
            "A ping event occured."
            #print "!!Ping!! at simtime %s" % tossim.timeStr()
            next_time = tossim.time() + (tossim.ticksPerSecond() * ping_time)
            tossim_event.run_at(next_time, ping)

        tossim_event.run_at(0, ping)
        log.info("Enabled 'ping' (%ds intervals)" % ping_time)
        return (True, Summary.enabled("%ds intervals" % ping_time))

    else:
        log.warn("Diabled 'ping': requires Event")
        return (False, Summary.requires('Event'))


def run_loaders(loaders):
    """
    Execute the specified loaders.
    """
    if loaders:
        log.info("Executing loaders: %s" % str(loaders))
        from simx.act import loader
        try:
            loader.load(loaders)
        except:
            exc = sys.exc_info()[1]
            errbanner("""\
Error attempting to execute loaders.

To get help on a specific loader use:
  --help LoaderName
""")
            if hasattr(exc, "print_exception"):
                exc.print_exception()
            else:
                traceback.print_exc()
            exit(1)

    else:
        log.info("No loaders to execute.")


#REACT_EXEC = ['java', 'react.Boot']
REACT_CWD = os.getenv("SIMX")+'/react'
REACT_EXEC = REACT_CWD + "/run-react"
DELAY_TIME = 0.25 # Give Java enough to barf on invalid class

def launch_client(client_enabled):
    """
    Attempts to launch the react client.
    
    Returns a summary. Raises an exception of the client is not launched
    correctly.
    """
    if client_enabled:
        from subprocess import Popen

        proc = None
        try:
            proc = Popen(REACT_EXEC, cwd=REACT_CWD)
            log.debug("Java test delay :%.1fs" % DELAY_TIME)
            time.sleep(DELAY_TIME)
            if proc.poll():
                raise RuntimeError("Java terminated early")

        except Exception, exc:
            log.error("Failed to start React client: %s" % exc)
            errbanner("""\
Could not start the React client.

This may be caused if "react.jar" or the TinyOS jars are not in the
CLASSPATH environment variable or if Java otherwise fails to start
correctly.

Fix the problem(s) or disable the client with the --no-client option.
""")
            raise RuntimeError("Client failed to launch")

        else:
            log.debug("Started React client (pid=%d)" % proc.pid)
            return Summary.enabled()

    else:
        log.info("No client started (--no-client)")
        return Summary.user_disabled()


def pause_delay(pause_time):
    """
    Possibly pauses for a bit.
    """
    if pause_time > 0:
        log.debug("[%d second pause]" % pause_time)
        time.sleep(pause_time)
    else:
        log.debug("[not pausing]")


def init_running_state(start_paused, time_control):
    """
    Initialize the starting running state of the simulation.

    Returns summary
    """
    if not time_control:
        log.warn("Simulation running (no time control)")
        return 'RUNNING: No TimeControl'
    elif start_paused:
        time_control.stop()
        log.info("Simulation paused")
        return 'PAUSED'
    else:
        log.info("Simulation running")
        return 'RUNNING'


def init_environment(parser, options):
    """
    Initialize the entire environment.
    """

    if options.show_loaders:
        show_loaders()

    if options.loader_helps:
        show_loader_helps(options.loader_helps)

    if options.show_loaders or options.loader_helps:
        print "[Exiting normally after showing loaders/loader help.]"
        exit(0)

    check_model(parser, options)
    log.info("Initializing Act environment")

    summary = Summary()
    
    tossim_mod = load_tossim()

    tossim_vars, _summary = load_vars(options.use_vars)
    summary.set('Tossim Vars', _summary)
    #print "tossim_vars: ",tossim_vars
    tossim, _summary = init_topo_tossim(
        tossim_vars=tossim_vars,
        dynamic=options.dynamic, tossim_mod=tossim_mod)
    summary.set('Model', _summary)

    pushback, _summary = load_pushback(options.pushback)
    summary.set('Pushback', _summary)

    sensor_control, _summary = load_sensor(options.sensor, pushback)
    summary.set('Sensor', _summary)

    led_control, _summary = load_leds(True, pushback)
    summary.set('Leds', _summary)

    event_manager = init_events(tossim)

    forwarder, _summary = init_sim_sf(options.sf_port)
    summary.set('SerialForwarder', _summary)

    time_control, _summary = init_timecontrol(options.sync,
                                              tossim, event_manager)
    summary.set('TimeControl', _summary)

    probe_mod, _summary = load_probe_module(options.probe)
    summary.set('Probe Module', _summary)

    probe_loader, _summary = init_probe_loader(options.probe, probe_mod)
    summary.set('Probe Vars', _summary)

    reactor = start_reactor(options.port)

    register_components(reactor, tossim, time_control)
    load_core_mods(reactor)

    if options.use_vars:
        _summary = load_modwatch(reactor,  tossim_vars)
	summary.set('ModWatch', _summary)
    else:
        _summary = Summary.user_disabled("Tossim Vars disabled")


    #_summary = load_modwatch(reactor,probe_loader)
    #summary.set('ModWatch', _summary)
    
    _summary = load_modtime(reactor, time_control)
    summary.set('ModTime', _summary)

    _summary = load_modprobe(reactor, probe_loader)
    summary.set('ModProbe', _summary)

    _summary = enable_ping(options.ping, event_manager)[1]
    summary.set('Ping', _summary)

    env = {
        'tossim': tossim,
        'event_manager': event_manager,
        'time_control': time_control,
        'reactor': reactor,
        'forwarder': forwarder,
        'sensor_control': sensor_control,
        'led_control': led_control
        }

    import simx.act.context
    simx.act.context.init(env)

    run_loaders(options.loaders)

    if summary.has_errors():
        summary.set('React GUI', Summary.disabled("Errors present"))
    elif summary.has_warnings():
        summary.set('React GUI', Summary.disabled("Warnings present"))
    else:
        _summary = launch_client(options.client)
        summary.set('React GUI', _summary)

    _summary = init_running_state(options.start_paused, time_control)
    summary.set('Start Status', _summary)

    summary.show()

    if summary.has_errors() or summary.has_warnings():
        errbanner("""
Aborting:
  %d errors
  %d warnings

Please fix/correct the issue and try again.

To ignore errors use --ignore-errors (also ignores warnings)
To ignore warnings use --ignore-warnings
(Use only with caution)
""" % (summary.has_errors(), summary.has_warnings()))
        exit(1)

    pause_delay(options.pause_time)
    return env


def run(env):
    """
    Start the simulation.
    """
    tossim = env['tossim']
    event_manager = env['event_manager']
    time_control = env['time_control']
    reactor = env['reactor']
    forwarder = env['forwarder']

    # Use a different simulation engine depending on if time control
    # is enabled or not. Time control support is needed for pausing, etc.
    run_sim = time_control.run_sim if time_control else tossim.runNextEvent
    
    try:
        while 1:
            run_sim()
            event_manager.process()
            reactor.process()
            if forwarder:
                forwarder.process()

    except KeyboardInterrupt:
        # Just exit on ^C
        log.debug("KeyboardInterrupt: exiting")


def _init():
    """
    Do stuff.
    """
    global log
    log = create_logger()
    parser, options, _ = parse_options()
    env = init_environment(parser, options)
    run(env)

if __name__ == "__main__":
    _init()
