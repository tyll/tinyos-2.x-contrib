from server import ProtoServer

s = ProtoServer(9000)
s.start()
print "started"
while True:
    r = s.read_packets()
    if r:
        print r
