from simx.probe import Loader

from TOSSIM import Tossim
import SimxProbe

_tossim = Tossim([])
loader = Loader('app.xml', SimxProbe)

print "--1--"
v1 = loader.lookup("OctopusC$alpha")
print "have def: %s" % v1
p1 = v1.bind(1)

print "have probe: %s" % p1.get()

print "--2--"
v2 = loader.lookup("OctopusC$ttt")
print "have def: %s" % v2
p2 = v2.bind(2)
print "have probe: %s" % p2.print_buf()

print "--3--"
v3 = loader.lookup("OctopusC$ttt_optimized_out")
print "have def: %s" % 32
try:
    p3 = v3.bind(3)
    print "have probe: %s" % p3
except Exception, e:
    print "it is expected this raises an exception: %s" % e.message
