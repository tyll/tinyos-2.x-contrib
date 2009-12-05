"""
Streamers are designed to process streams read from file objects. They
do this by generating a function that returns the next value on each
invocation. The methods in this class all accept a filename or file
object as the source; see as_file.

Since the streamer-generated functions accept (ignore) any parameters
they may be used as SimxSensor functions directly.
"""

import struct
from .reader import Reader


class Streamer(object):

    def __init__(self, open_mode="r"):
        self.open_mode = open_mode

    @staticmethod
    def as_file(source, mode="r"):
        """
        Normalize source to a file object.

        If source is not a file object, assume it is a string and open
        it according to mode (all the usual exceptions apply). If
        source is a file object, it is returned directly.
        """
        if isinstance(source, file):
            return source
        else:
            return open(source, mode)


class BinaryStreamer(Streamer):
    """
    For streaming binary files in a fixed format.
    """

    def __init__(self, source, format=None, reset_on_eof=True, eof_return=-1):
        """
        Source is handled according to as_file. The data is unpacked
        by format; see the python struct module.
        """
        Streamer.__init__(self, "rb")
        assert format

        self.source = Streamer.as_file(source, "rb")
        if source.mode.find("b") < 0:
            raise ValueError("Not opened in binary mode: %s" % source.name)

        self.format = format
        self.reset_on_eof = reset_on_eof
        self.eof_return = eof_return


    def generator(self):
        """
        Return the generator.
        """

        size = struct.calcsize(self.format)

        def reader(*ignore):
            try:
                return Reader.unpacked(self.source, self.format, size)
            except EOFError:
                if self.reset_on_eof:
                    self.source.seek(0, 0)
                    # rather throw an EOF than get caught in a cycle
                    return Reader.unpacked(self.source, self.format, size)
                else:
                    return self.eof_return

        return reader


## PST- not updated
class SacStreamer(Streamer):
    """
    For streaming SAC streams.
    """

    def __init__(self):
        Streamer.__init__(self, "rb")

    def generate(self, source, sac_module=None,
                 reset_on_eof=True, eof_return=-1):
        """
        Returns a SimxSensor callback to read from a SAC file.

        This will not work correctly with SAC files with a second data
        section.  See simx/extra/sac.
        """
        assert sac_module

        source = Streamer.as_file(source, "rb")
        if source.mode.find("b") < 0:
            raise ValueError("Not opened in binary mode: %s" % source.name)

        sac = sac_module.Reader(source)
        if sac.header.big_endian:
            # header is in big_endian, but data is in le? I don't get it...
            format = "<i"
        else:
            format = "<i"
        
        source.seek(sac_module.HEADER_SIZE)

        def reader(*ignore):
            # really should just read from sac.data1 ... no need for IO
            try:
                return Reader.unpacked(source, format, 4)
            except EOFError:
                if reset_on_eof:
                    source.seek(sac_module.HEADER_SIZE)
                    # rather throw an EOF than get caught in a cycle
                    return Reader.unpacked(source, format, 4)
                else:
                    return eof_return

        return reader


class TextStreamer(Streamer):
    """
    For streaming integer values as text.
    """

    def __init__(self, source=None, reset_on_eof=True,
                 eof_value=-1, invalid_value=-1):
        """
        Streamer to read read integer-words from a text file.

        Source is handled according to as_file. If reset_on_eof is
        true then source will be reset each time an EOF is reached.
        
        0 is returned for invalid input (negative number, int parse
        error or EOF).
        """
        Streamer.__init__(self, "r")
        self.source = Streamer.as_file(source)
        self.reset_on_eof = reset_on_eof
        self.eof_value = eof_value
        self.invalid_value = invalid_value

    def generator(self):
        """
        Return the generator.
        """
        def reader(*ignore):
            data = Reader.integer(self.source, self.invalid_value)
            #print("sensor"+str(data));
            if data is not None:
                return long(data)
            
            # data is None - at EOF
            if self.reset_on_eof:
                self.source.seek(0, 0)
                return long(reader())
            else:
                return long(self.eof_value)

        return reader
