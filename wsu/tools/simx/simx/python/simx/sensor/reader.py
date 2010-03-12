import struct

class Reader(object):
    """
    Methods to assist in reading from a file. In all the cases below,
    source is a file object.
    """

    @staticmethod
    def word(source):
        """
        Read the next word (non-whitespace sequence).

        An empty string is returned on EOF.
        """
        word = ""
        while 1:
            char = source.read(1)
            if not char: # at EOF
                return word
            if not char.isspace():
                word = word + char
            elif word:
                return word


    @staticmethod
    def integer(source, invalid_value=-1):
        """
        Read the next integer.

        The integer is read according to the standard prefix rules;
        see int(). None is returned on an EOF; invalid_value if the
        conversion otherwise fails.
        """
        try:
            word = Reader.word(source)
            if not word:
                return None
            return int(word, 0) #guesses base
        except ValueError:
            return invalid_value
 

    @staticmethod
    def unpacked(source, format, size=None):
        """
        Read and unpack data.

        The data is unpacked according to format; see the struct
        module. An exception will be raised on an error. None is
        returned upon EOF.
        """
        size = size or struct.calcsize(format)
        raw_data = source.read(size)
        if len(raw_data) != size:
            return None

        return struct.unpack(format, raw_data)[0]
