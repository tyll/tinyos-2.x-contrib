import random
import unittest

import string

from Message import ReactMsg, ReactDoMsg

class TestReactDoMsg(unittest.TestCase):
    
    def test_cmd_access(self):
        cmd1 = "hello world!"
        cmd2 = "yawn"

        m = ReactDoMsg(cmd=cmd1)
        self.assertEquals(cmd1, m.get_cmd())

        m.set_cmd(cmd2)
        self.assertEquals(cmd2, m.get_cmd())


class TestReactMsg(unittest.TestCase):

    def setUp(self):
        cmd = string.join(chr(x) for x in xrange(0,256)) * 4
        self.r = ReactDoMsg(cmd=cmd)
        self.encoded = ReactMsg.encode(self.r, track_id=13)

    def test_payload_access(self):
        pass

    def test_encode_remaining(self):
        r = self.r
        encoded = self.encoded
        first = encoded[0]

        self.assertEqual(len(r.dataGet()), first.get_remaining())

        # backwards-count
        last_rem = 0
        for elm in reversed(encoded):
            rem = elm.get_remaining()
            must_provide = rem - last_rem
            self.assertEqual(len(elm.get_payload()), must_provide)
            last_rem = rem

        self.assertEqual(first.get_remaining(), last_rem)

    def test_payload_split(self):
        r = self.r
        encoded = self.encoded

        # fully packed
        for elm in encoded[:-1]:
            payload_len = len(elm.get_payload())
            self.assertEqual(ReactMsg.max_payload(), payload_len)
        
        # last does not exceed cap
        last, = encoded[-1:]
        payload_len = len(last.get_payload())
        self.assert_(ReactMsg.max_payload() >= payload_len)

    def test_encoded_types(self):
        r = self.r
        encoded = self.encoded

        # only first has type
        self.assertEqual(r.get_amType(), encoded[0].get_type())
        for elm in encoded[1:]:
            self.assertEqual(0, elm.get_type())

    def test_merge(self):
        r1 = self.r
        encoded = self.encoded

        fin = encoded[0]
        for elm in encoded[1:]:
            fin.merge(elm)

        self.assert_(fin.complete())
        (type, track_id, data) = fin.extract()

        self.assertEqual(13, track_id)
        self.assertEqual(ReactDoMsg.get_amType(), type)
        r2 = ReactDoMsg(data=data)
        self.assertEqual(r1.get_cmd(), r2.get_cmd())

if __name__ == '__main__':
    unittest.main()
