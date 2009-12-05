from simx.sensor.util import sineWave
from ..context import Sensor
from ..context import T
from .. import LoadException


def help():
    return """
Connect a generic Sensor to activated nodes.

Binds a generic fairly-well distributed sine-wave sensor
data-generator to Simx/Sensor. The generated data is 16-bits wide.

This module is only useful after some nodes have been activated.

USAGE: %(name)s
"""


def init(*opts, **kws):

    if opts or kws:
        raise LoadException("unexpected parameters")

    if not Sensor:
        raise LoadException("SensorControl not loaded")

    nodes = T.nodes()

    print """
=== Sensor Loader ===
Connecting SineWave sensor generator to %s nodes
""" % len(nodes)

    import random
    for n in nodes:
        fn = sineWave(T,
                      period=(n.id() % 10 + 2) * 4,
                      amplitude=32500,
                      phase=n.id() * 10 * random.random(),
                      offset=33000,
                      min=0,
                      max=65550)
        Sensor.connect(n.id(), 0, fn)
