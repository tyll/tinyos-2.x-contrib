import getopt, sys
from common import *
from TopoVis import *
from PSPlotter import Plotter

###############################################
def readParams(args):
    params = Parameters()
    optlist, args = getopt.getopt(args, '', [
        'scale=',
        'node-size=',
        'text-size=',
        'grid=',
        'hollow=',
        'double-outline=',
        'node-width=',
        'bg-color=',
        'grid-color=',
        'node-color=',
        'margin-guard='])

    for (x,y) in optlist:
        if x == '--scale':
            params.scale = float(y)
        elif x == '--node-size':
            params.nodesize = int(y)
        elif x == '--text-size':
            params.textsize = int(y)
        elif x == '--grid':
            params.grid = float(y)
        elif x == '--hollow':
            params.hollow = bool(y)
        elif x == '--double-outline':
            params.double = bool(y)
        elif x == '--node-width':
            params.nodewidth = float(y)
        elif x == '--bg-color':
            params.bgcolor = Color(y)
        elif x == '--grid-color':
            params.gridcolor = Color(y)
        elif x == '--node-color':
            params.nodecolor = Color(y)
        elif x == '--margin-guard':
            params.guard = int(y)

    return (params, args)

###############################################
def showParams(params):
    print 'Current option settings:'
    print '  scale          = ', params.scale
    print '  node-size     = ', params.nodesize
    print '  text-size     = ', params.textsize
    print '  hollow         = ', params.hollow
    print '  double         = ', params.double
    print '  node-width    = ', params.nodewidth
    print '  grid            = ', params.grid
    print '  bg-color      = ', params.bgcolor
    print '  node-color    = ', params.bgcolor
    print '  grid-color    = ', params.gridcolor
    print '  margin-guard = ', params.guard

###############################################
def main():
    try:
        (params, args) = readParams(sys.argv[1:])
        output = args[0]
    except:
        print "Usage: topovis2ps.py [OPTIONS...] output"
        exit()

    showParams(params)
    print 'Output will be saved to "%s"' % output

    stream = open(output, "w")
    ps = Plotter(stream, params)
    scene = Scene(timescale=0)
    scene.addPlotter(ps)
    while True:
        line = sys.stdin.readline()
        if len(line) == 0: break
        (time,cmd) = line.strip().split(' ',1)
        scene.execute(float(time), cmd.strip())
    ps.close()
    stream.close()

###############################################
def test():
    topo = TopoVis(None, None)
    topo.linestyle(1, color=(0.3,0.6,0.9), dash=(2,1))
    topo.linestyle(1, show=False)

###############################################
if __name__ == "__main__":
    main()
