from simx.base.testutil import import_assert_functions
import_assert_functions(globals())


from simx.sensor import TextStreamer, BinaryStreamer


def test_text_streamer_repeating():
    expected = range(0, 16) + [-1]
    gen = TextStreamer("data/integer_source.txt").generator()
    for i in expected * 3:
        assertEquals(i, gen())

        
def test_text_streamer_terminating():
    expected = range(0, 16) + [-1]
    gen = TextStreamer("data/integer_source.txt",
                       reset_on_eof=False,
                       eof_value=-42).generator()
    for i in expected + ([-42] * 50):
        assertEquals(i, gen())

        
def test_text_streamer_bad():
    expected = range(0, 5) + [-17] + range(6, 16) + [-1]
    gen = TextStreamer("data/integer_source_bad.txt",
                       invalid_value=-17).generator()
    for i in expected:
        assertEquals(i, gen())
