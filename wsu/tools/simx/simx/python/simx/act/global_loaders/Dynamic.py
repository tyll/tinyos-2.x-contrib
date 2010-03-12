"""
Configure a dynamic topology.
"""

import re
import random
from ..context import T
from .. import LoadException

NOISE_TRACE_COUNT = 100 # TOSSIM 2x requirement

def help():
    return """
Configure a dynamic topology:

Activates and powers on a specified number of nodes. Then links nodes
together (with bi-directional links) based on a specified density.

This loader should generally be used before other loaders.

USAGE: %(name)s,count,density[,floor]

count - Number of nodes to activate (nodes activated are in the range
        [0..count)). This will use all activated nodes, which can be
        configured abitrarily in advance. A count of 0 activates no
        additional nodes.

density - Probability of node A being connected to node B, for all
          nodes A, B such that A is not B. The value must be in the
          range [0, 1]. A value of 0 ensures no links are created.

floor - Default noise floor to add to motes. A value of 0 disables
        adding a noise floor. A default floor of -95 is assumed unless
        otherwise specified.
"""


def parse_int(val, name):
    try:
        return int(val)
    except ValueError:
        raise LoadException("%s: %s is not an integer" % (name, val))

def parse_float(val, name):
    try:
        return float(val)
    except ValueError:
        raise LoadException("%s: %s is not a float" % (name, val))


def init(*opts, **kws):
    count = 0
    density = 0
    floor = -95
    
    if not T.dynamic:
        raise LoadException("topology manager is not dynamic; use --dynamic")

    if len(opts) >= 1:
        count = parse_int(opts[0], "count")
        if count < 0:
            raise LoadException("count: must be >= 0")
    else:
        raise LoadException("count: required param missing")

    if len(opts) >= 2:
        density = parse_float(opts[1], "density")
        if density < 0 or density > 1:
            raise LoadException("density: must be in the range [0.0, 1.0]")
    else:
        raise LoadException("density: required param missing")

    if len(opts) >= 3:
        floor = parse_int(opts[2], "floor")
        if floor > 0:
            raise LoadException("floor must be <= 0")

    if len(opts) >= 4:
        raise LoadException("extra parameters: %s" % (opts,))

    print """
=== Dynamic Loader ===
Turning on %d nodes
""" % count

    build_model(count, density)
    if floor:
        print "Creating noise noise floor: %ddBm" % floor
        add_noise_floor(floor)
    else:
        print "Warning: not adding a noise floor"


def build_model(count, density):

    for i in xrange(0, count):
        T[i].turnOn()

    nodes = list(T.poweredNodes())
    print "Connecting %d nodes (probability is %f)" % (len(nodes), density)

    while nodes:
        n = nodes.pop()
        for o in nodes:
            if random.random() <= density:
                n.touch(o)
                o.touch(n)


def add_noise_floor(floor):
    for n in T.nodes():
        for i in xrange(0, NOISE_TRACE_COUNT):
            n.addNoiseTraceReading(floor)
        n.createNoiseModel()
