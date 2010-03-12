"""
Load a standard topology file.
"""

from ..context import T

def startup(*opts, **kws):
    if not opts:
        raise RuntimeError("required topology file missing")

    filename = opts[0]

    file = None
    try:
        file = open(filename, "r")
        T.readTopo(file)
    finally:
        if file:
            file.close()
    
