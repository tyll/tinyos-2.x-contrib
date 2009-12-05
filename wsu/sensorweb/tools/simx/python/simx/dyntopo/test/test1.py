from Topo import GenericTopo
import TopoGen

g = GenericTopo()
TopoGen.line(g[0:21])
g.writeTopo()
g.rebuildModel()
g.writeGain()
