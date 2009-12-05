import math

from simx.dyntopo import TopoGen
from ..context import T

DEFAULT_SPACING = 7

def init(*opts, **kws):

    spacing = DEFAULT_SPACING

    if not T.dynamic:
        raise RuntimeError("Scatter only works with dynamic topologies")

    nodes = T.nodes()

    print """
=== Scatter Loader ===
Scattering %s nodes randomly
""" % len(nodes)
    
    n_width = math.sqrt(len(nodes)) 
    width = int(n_width * spacing)

    TopoGen.scatter(nodes, bounds=(0, 0, width, width))
