"""
Functions to generate different topologies.

Each function takes a list of nodes followed by function-specific
keyword arguments. The list of nodes need to support the extended
interface added on via DynTopo.

All unit lengths should be taken as meters.
"""

import math
import random

def scatter(nodes, bounds=(0,0,100,100), random=random.Random()):
    """Randomly toss nodes about.

    Nodes are randomly placed in bounds (x1,y1,x2,y2). random, if
    specified, is the random number source.
    """
    (x1, y1, x2, y2) = bounds
    for n in nodes:
        n.set_pos((random.uniform(x1, x2), random.uniform(y1, y2)))

def line(nodes, start=(-10,0), end=(10,0)):
    """Align nodes in a line.

    Nodes are placed evenly along the line from start (x,y) to end
    (x,y).
    """
    (ox, oy) = start
    dx = end[0] - ox
    dy = end[1] - oy
    dist = math.sqrt(dx*dx + dy*dy)
    l = len(nodes) - 1
    if l > 0:
        (stepx, stepy) = (float(dx) / l, float(dy) / l)
    else:
        (stepx, stepy) = (0, 0)
    for i, n in enumerate(nodes):
        x = i * stepx
        y = i * stepy
        n.set_pos((x + ox, y + oy))

def grid(nodes, offset=(0,0), spacing=(4,4)):
    """Place nodes in a grid.

    The grid starts at offset (x,y) and nodes are placed spacing (x,y)
    distance apart. If the number of nodes is not a perfect square the
    last row will contain the odd-nodes-out.
    """
    (ox, oy) = offset
    (sx, sy) = spacing
    width = int(math.sqrt(len(nodes)))
    if width < 1:
        width = 1
    for i, n in enumerate(nodes):
        x = sx * (i % width)
        y = sy * int(i / width)
        n.set_pos((x + ox, y + oy))

def arc(nodes, offset=0, length=2*math.pi,
        origin=(0,0), axis=(10,10), touching=True):
    """Align nodes in an arc.

    The nodes are placed within length units (in radians) evenly
    spaced in a counter-clockwise fashion from offset (also in
    radians). The arc is centered about origin (x,y) with axis of
    (w,h) relative to the origin.
    """
    (ox, oy) = origin
    (rx, ry) = axis
    l = len(nodes) - (1 if touching else 0)
    if l > 0:
        step = float(length) / l
    else:
        step = 0
    for i, n in enumerate(nodes):
        theta = i * step + offset
        x = rx * math.cos(theta)
        y = ry * math.sin(theta)
        n.set_pos((x + ox, y + oy))

def ellipse(nodes, origin=(0,0), axis=(10,10)):
    """Align nodes in an ellipse (or circle).

    The ellipse is centered at origin (x,y) and has axis (x,y).
    """
    arc(nodes, origin=origin, axis=axis, touching=False)

def place(nodes, position):
    """Put nodes at specific positions.
    """
    pass
