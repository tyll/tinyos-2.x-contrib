import time

from simx.protomap import ProtoServer

TEST_PORT = 7800

s = ProtoServer(TEST_PORT)
s.start()
while True:
    time.sleep(0.002)
    s.process_messages()
