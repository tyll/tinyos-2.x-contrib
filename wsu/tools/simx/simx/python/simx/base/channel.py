import os, fcntl


class ChannelBridge(object):
    """
    Bridge TOSSIM channels to Python.

    TOSSIM channels write directly to File Descriptor ids. This class
    allows the TOSSIM channels to be intercepted in python without
    needing to passed directly to a file sink.

    B{WARNING:} This implementation assumes pipe, fcntl, and
    O_NONBLOCK support. B{It will likely not work in Windows.}
    """
    def __init__(self):
        """
        Initializer.

        New object can be passed to L{TossimBase.add_channel}.
        """
        (r_fd, w_fd) = os.pipe()
        # setup non-block on the reader
        fcntl.fcntl(r_fd, fcntl.F_SETFL, os.O_NONBLOCK)
        self.r = os.fdopen(r_fd)
        self.w = os.fdopen(w_fd, "a")


    def get_writefile(self):
        """
        Returns the writable file object.

        @rtype:  file
        @return: object suitable to pass to L{TossimBase.add_channel}.
        """
        return self.w


    def readline(self, strip=False):
        """
        Reads the next line from the channel.

        B{WARNING:} Make sure TOSSIM channels send newlines or this will
        never be true.

        @type  strip: bool
        @param strip: if a true value, then trailing whitespace will be
                      stripped as per string.rstrip()

        @rtype:  string, or None
        @return: the next line, which may be "",
                 or None if there is no line yet
        """
        try:
            line = self.r.readline()
            if strip:
                return line.rstrip()
            return line
        except IOError:
            return None
