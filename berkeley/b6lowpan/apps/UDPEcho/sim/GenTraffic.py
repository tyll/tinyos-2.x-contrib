
import random
import sys
from math import sqrt

NSTART = 1
NEND = 225

DISTTHRESH = 5

r = random.Random()

def getDist(n1, n2):
    if (n1 == 225): n1 = 0 
    if (n2 == 225): n2 = 0

    x1 = n1 % 15;
    x2 = n2 % 15;

    y1 = int(n1 / 15);
    y2 = int(n2 / 15);

    return sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)


def getNode(exclude=[]):
    global r
    choice = int(r.uniform(NSTART,NEND+1))
    while choice in exclude:
        choice = int(r.uniform(NSTART,NEND+1))
    return choice

ex = [100]
for i in range(0,int(sys.argv[1])):
    n1 = getNode(ex)
    ex.append(n1)
    n2 = getNode(ex)
    while getDist(n1, n2) > DISTTHRESH:
        n2 = getNode(ex)
    print "%i %i 2048 50" % (n1, n2)
