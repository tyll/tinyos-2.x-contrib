import random

from simx.protomap.packet import Packet

def rand_data(min, max):
    count = random.randint(min, max)
    return "".join(chr(random.randint(0,255)) for x in xrange(0,count))

def test_packet_1():
    for i in xrange(0, 20):
        track_id = random.randint(0, 0xffff)
        message = rand_data(1, 0xff)
        payload = rand_data(0, 0xffff)
        expected = Packet(track_id, message, payload)
        actual = Packet.decode(expected.encode())
        yield packet_check, expected, actual

def packet_check(expect, actual):
    assert_equals(expect.track_id, actual.track_id)
    assert_equals(expect.protocol, actual.protocol)
    assert_equals(expect.payload, actual.payload)    

def assert_equals(expected, actual):
    assert expected == actual, "[%s] == [%s]" % (expected, actual)
