"""
Load various Loader ('startup') modules.

Each loader is expected to have two entry-points:
1) init - execute loader code; is passed decomposed options
2) help - displays help/usage info

sim.act.context is initialized before loaders are invoked.
"""

import sys
import os
import re
import traceback

from . import LoadException
from util import dynamic_import

# Where to look for loaders; first-come, first-serve.
LOCATION_TAGS = {
    'loaders': 'LOCAL',
    'simx.act.global_loaders': 'GLOBAL'
    }
LOCATIONS = LOCATION_TAGS.keys()
            

def load_loader(name, locations):
    """
    Load a specific loader searching locations (a dictionary) in order.

    locations - list of paths to search, using "." as path separator

    Returns None if the lookup fails.
    """
    for location in locations:
        try:
            full = location + "." + name
            return dynamic_import(full)
        except ImportError, e:
            pass


def parser_loader_string(loader_str):
    pass


def load_single(loader_str, display_help=False):
    """
    Try to execute a single loader.
    """
    parts = loader_str.split(",")
    if not parts:
        raise ArgumentError("loader: name of module not specified")

    name = parts[0]
    mod = load_loader(name, LOCATIONS)

    if not mod:
        raise LoadException("loader: could not find %s\n   searched in: %s"
                            % (name, ", ".join(LOCATIONS)), command=loader_str)

    # module loaded...
    fn = None
    if not display_help:
        fn = getattr(mod, 'init', None)
        if not fn:
            raise LoadException("loader is invalid (no 'init' method)",
                                command=loader_str)
    else:
        help = getattr(mod, 'help', None)
        if not help:
            raise LoadException("no help for loader (no 'help' method)",
                                command=loader_str)
        def display_help(*args):
            print help()
        fn = display_help

    try:
        fn(*parts[1:])
    except LoadException, e:
        e.command = loader_str
        raise
    except:
        (exc_type, exc, trace) = sys.exc_info()
        stack_list = traceback.extract_tb(trace)
        raise LoadException(exc, stack_list[1:], command=loader_str)


def load(loader_strs):
    """
    Load a bunch of loaders at once.
    If a loader fails subsequent loaders will not be run.

    Returns None if all loaders succeeded. Otherwise returns an
    Exception object of the failing loader.
    """
    for m in loader_strs:
        load_single(m)


def find(locations):
    """
    Returns a list of (location, path, loaders) for each location in
    locations. locations is expected to be in PYTHONPATH and be in
    module-name form (eg. "a.b.c").
    """
    loaders = []
    for location in locations:
        files = []
        path = "NOT FOUND: make sure location contains __init__.py"
        try:
            mod = dynamic_import(location)
            path = mod.__path__[0]
        except (ImportError, AttributeError, IndexError), e:
            pass
        else:
            # Only select "simple looking" python files
            regex = re.compile("^([A-Za-z]\\w+)\\.py$")
            files = [m.group(1) for m in 
                     (regex.match(f) for f in os.listdir(path))
                     if m]

        loaders.append((location, path, files))

    return loaders


def list(locations=LOCATIONS, tags=LOCATION_TAGS):
    """
    Display loaders found in the various locations.
    """
    loader_info = find(locations)

    for (location, path, loaders) in loader_info:
        tag = tags.get(location, "")
        print "%s loaders in %s:" % (tag, location)
        print "     (source: %s)" % path
        for loader in loaders:
            print "  - %s" % loader
