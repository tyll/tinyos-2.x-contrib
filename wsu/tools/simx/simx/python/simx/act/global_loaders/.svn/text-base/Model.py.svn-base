"""
Load link-gain information from a file and apply a tossim noise model.
"""

import re
from ..context import T


def buildModel(source):
    matches = re.match("^(\d{1,3})%$", source)
    if matches:
        integral_percent = max(0, min(int(matches.group(1)), 100))
        percent = 100.0 / integral_percent
        T.linkAllNodes()

    else:
        file = None
        try:
            file = open(source, "r")
            T.readGain(file)
        finally:
            if file:
                file.close()


def buildNoise(noise_source):
    try:
        static_noise = float(noise_source)
        useStaticNoise(static_noise)
    except ValueError:
        useFileNoise(noise_source)

    for node in T.activeNodes():
        node.createNoiseModel()


def useStaticNoise(noise_level):
    for node in T.nodes():
        for i in range(0, 100):
            node.addNoiseTraceReading(noise_level)


def useFileNoise(filename):
    # load from "noise" file
    file = None
    try:
        file = open(filename, "r")

        lines = file.readlines()
        for line in lines:
            str = line.strip()
            if str != "":
                val = int(str)
                for node in T.activeNodes():
                    node.addNoiseTraceReading(val)

    finally:
        if file:
            file.close()


def startup(*opts, **kws):
    if len(opts) < 1:
        raise RuntimeError("required link-gain file missing")
    if len(opts) < 2:
        raise RuntimeError("noise source missing")
    if len(opts) > 2:
        raise RuntimeError("extra parameters: %s" % (opts,))

#    if T.dynamic:
#        raise RuntimeError("an explicit link-gain model only makes sense "
#                          "with a static topology manager")

    filename = opts[0]
    noise_source = opts[1]

    buildModel(filename)
    buildNoise(noise_source)
