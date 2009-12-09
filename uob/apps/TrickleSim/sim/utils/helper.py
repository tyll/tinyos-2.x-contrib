
def id2xy(id, nodes):
    x = (id-1)/nodes
    y = (id-1)%nodes
    return (x, y)

def xy2id(x, y, nodes):
    return x*nodes + y +1

def floatRange(a, b, inc):
  """
  Returns a list containing an arithmetic progression of floats.
  This is simply a float version of the built-in range(a, b, step)
  function.  The result is [ , ) as always in Python.
  """
  try: x = [float(a)]
  except: return False
  for i in range(1, int(math.ceil((b - a ) / inc))):
    x. append(a + i * inc)
  return x

def numberOfNeighbors(connectivity):
    neighbors = 0
    inc = 4
    for i in range(connectivity):
        neighbors += inc
        inc *= 2
    return neighbors

import math
def powrange(start, stop, base, basestepsize):
    rng = []
    item = start
    i = 0

    print ">", start, stop, base
    while item < stop:
        item = item + basestepsize*math.pow(i, base)
        i+=1
        rng.append(item)

    return rng

class Time:
    def __init__(self, h, m, s):
        self.h = int(h)
        self.m = int(m)
        self.s = float(s)

    def in_second(self):
        return ((24*self.h)+60*self.m) + self.s

    def __str__(self):
        return ""
